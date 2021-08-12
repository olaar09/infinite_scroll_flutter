part of 'bloc.dart';

abstract class FetchDataEvent {}

class InitFetch extends FetchDataEvent implements Equatable {
  final String url;

  InitFetch({required this.url});

  @override
  // TODO: implement props
  List<Object> get props => [url];

  @override
  // TODO: implement stringify
  bool get stringify => true;
}
