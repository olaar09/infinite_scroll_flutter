import 'package:bloc/bloc.dart';
import 'package:flutter_infinite_scroll/podo/infinite_scroll_podo.dart';
import 'package:flutter_infinite_scroll/repositories/i_data_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:sealed_unions/sealed_unions.dart';

part 'state.dart';

class InfiniteScrollCubit extends Cubit<FetchDataState> {
  IDataRepository dataRepo;
  int nextPage = 0;

  InfiniteScrollCubit(this.dataRepo) : super(FetchDataState.initial());

  dispatchRefreshEvent(String url, List<InfiniteScrollPODO> oldData) async {
    resetPage();
    this.emit(FetchDataState.loading(oldData: oldData));
    await Future.delayed(Duration(seconds: 3));
    await this.fetchDataOnce(url);
  }

  dispatchLoadMoreEvent(String url, List<InfiniteScrollPODO> oldData) async {
    this.emit(FetchDataState.loading(oldData: oldData, isLoadMore: true));
    await Future.delayed(Duration(seconds: 3));
    await this.fetchDataJoin(url, oldData);
  }

  dispatchFetchEvent(url) async {
    this.emit(FetchDataState.loading());
    await this.fetchDataOnce(url);
  }

  fetchDataOnce(String url) async {
    try {
      List<InfiniteScrollPODO> data = await dataRepo.fetchData(url, nextPage);
      this.emit(FetchDataState.loaded(data));
      incrementPage();
    } catch (e) {
      print(e.toString());
      this.emit(FetchDataState.error(
        generic: 'An error occurred, please try again',
      ));
    }
  }

  fetchDataJoin(String url, List<InfiniteScrollPODO> oldData) async {
    try {
      List<InfiniteScrollPODO> data = await dataRepo.fetchData(url, nextPage);
      final newData = [...oldData, ...data];
      this.emit(FetchDataState.loaded(newData));
      incrementPage();
    } catch (e) {
      this.emit(FetchDataState.error(
        generic: 'An error occurred, please try again',
      ));
    }
  }

  incrementPage() => nextPage = nextPage + 1;

  resetPage() => nextPage = 0;
}
