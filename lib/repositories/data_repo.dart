import 'package:dio/dio.dart';
import 'package:flutter_infinite_scroll/podo/data_podo.dart';
import 'package:flutter_infinite_scroll/repositories/i_data_repo.dart';
import 'package:flutter_infinite_scroll/util/rest_client.dart';

class DataRepository implements IDataRepository {
  final Dio _restClient;

  DataRepository({required Dio restClient}) : _restClient = restClient;

  Future<List<DataPODO>> fetchData(url) async {
    try {
      Response response = await _restClient.get('$url');
      RequestResponse parseResponse = response.data;
      return DataPODO().fromJsonArr(parseResponse.data);
    } on DioError catch (e) {
      print('error one');
      throw e.error;
    } catch (e) {
      throw e.toString();
    }
  }
}