import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_infinite_scroll/podo/data_podo.dart';
import 'package:flutter_infinite_scroll/repositories/i_data_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:sealed_unions/sealed_unions.dart';

part 'event.dart';

part 'state.dart';

class InfiniteScrollBloc extends Bloc<FetchDataEvent, FetchDataState> {
  IDataRepository dataRepo;

  InfiniteScrollBloc(this.dataRepo) : super(FetchDataState.initial());

  dispatchFetchEvent(url) {
    this.add(InitFetch(url: url));
  }

  @override
  Stream<FetchDataState> mapEventToState(FetchDataEvent event) async* {
    if (event is InitFetch) {
      yield* mapToFetchDoc(event);
    }
  }

  Stream<FetchDataState> mapToFetchDoc(InitFetch event) async* {
    try {
      yield FetchDataState.loading();
      List<DataPODO> data = await dataRepo.fetchData(event.url);
      yield FetchDataState.loaded(data);
    } catch (e) {
      print(e.toString());
      yield FetchDataState.error(
        generic: 'An error occurred, please try again',
      );
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
