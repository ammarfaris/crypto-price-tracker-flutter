import 'package:bitcoin_ticker/services/networking.dart';

const coinAPI = 'https://api.coingecko.com/api/v3/simple/price';

const List<String> currenciesList = [
  'MYR',
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  // 'RON', // not available
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BITCOIN', // BTC
  'ETHEREUM', // ETH
  'LITECOIN', // LTC
];

class CoinData {
  Future<dynamic> convertCoin(String coinName, String currency) async {
    var url = '$coinAPI?ids=$coinName&vs_currencies=$currency';
    NetworkHelper networkHelper = NetworkHelper(url);

    var coinData = await networkHelper.getData();
    return coinData;
  }
}
