import 'package:dio/dio.dart';
import 'package:flutter_infinite_scroll/util/rest_client.dart';

abstract class IDataRepository {
  Future fetchData(url, nextPage);
}
