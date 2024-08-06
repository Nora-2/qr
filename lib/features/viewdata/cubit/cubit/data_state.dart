
part of 'data_cubit.dart';

abstract class DataState {}

class DataInitial extends DataState {}

class DataDeleted extends DataState {}

class AllDataDeleted extends DataState {}
class DataDeletionError
 extends DataState {}
class DataDeletedSuccessfully extends DataState {}
class AllDataDeletedSuccessfully extends DataState {}


class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<Map<String, dynamic>> qrcodes;
  DataLoaded(this.qrcodes);
}
class qrload extends DataState {}
class dateload extends DataState {}
class companyload extends DataState {}
class idload extends DataState {}
class DataError extends DataState {
  final String message;
  DataError(this.message);
}
