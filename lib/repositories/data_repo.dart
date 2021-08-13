import 'package:dio/dio.dart';
import 'package:flutter_infinite_scroll/podo/infinite_scroll_podo.dart';
import 'package:flutter_infinite_scroll/repositories/i_data_repo.dart';
import 'package:flutter_infinite_scroll/util/rest_client.dart';

class DataRepository implements IDataRepository {
  final Dio _restClient;

  DataRepository({required Dio restClient}) : _restClient = restClient;

  Future<List<InfiniteScrollPODO>> fetchData(url, nextPage) async {
    print('page number $nextPage');
    try {
      Response response = await _restClient.get('$url?page=$nextPage');
      RequestResponse parseResponse = response.data;
      return InfiniteScrollPODO().fromJsonArr(parseResponse.data);
    } on DioError catch (e) {
      print('error one');
      throw e.error;
    } catch (e) {
      throw e.toString();
    }
  }
}
