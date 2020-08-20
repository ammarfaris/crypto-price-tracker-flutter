import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform; // just exposed the Platform library file

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coin = CoinData();
  String selectedCurrency;
  String selectedCoin;
  String convertedCurrency = '?';

  @override
  void initState() {
    super.initState();
    selectedCurrency = 'myr';
    selectedCoin = 'bitcoin';
    getInitValue(selectedCoin, selectedCurrency);
  }

  void getInitValue(coinName, currency) async {
    var coinData = await CoinData().convertCoin(coinName, currency);
    updateUI(coinData, coinName, currency);
  }

  void updateUI(
      dynamic coinData, String coinLowerCase, String currencyLowerCase) {
    setState(() {
      if (coinData == null) {
        convertedCurrency = '?';
        return;
      }
      // can either be double or int, hence we set to dynamic
      dynamic convertedCurrencyVal =
          coinData['$coinLowerCase']['$currencyLowerCase'];
      convertedCurrency = convertedCurrencyVal.toString();
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = []; // <String> as child

    for (String currency in currenciesList) {
      // currenciesList from coin_dart.dart
      var newItem = DropdownMenuItem(
        child: Text(currency.toUpperCase()),
        value: currency,
      );

      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency, // specify starting value
        items: dropdownItems,
        onChanged: (value) async {
          selectedCurrency = value;
          var coinData = await coin.convertCoin(selectedCoin, selectedCurrency);
          updateUI(coinData, selectedCoin, selectedCurrency);
        });
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency.toUpperCase()));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) async {
        selectedCurrency = currenciesList[selectedIndex];
        //TODO similar code can be refactored
        var coinData = await coin.convertCoin(selectedCoin, selectedCurrency);
        updateUI(coinData, selectedCoin, selectedCurrency);
      },
      children: pickerItems,
    );
  }

//  Widget getPicker() {
//    if (Platform.isIOS) {
//      return iOSPicker();
//    } else if (Platform.isAndroid) {
//      return androidDropdown();
//    } else {
//      return androidDropdown();
//    }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Crypto Price Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ${selectedCoin.toUpperCase()} = $convertedCurrency ${selectedCurrency.toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
