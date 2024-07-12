// ignore_for_file: camel_case_types

part of 'excel_cubit.dart';

@immutable
sealed class ExcelState {}

final class ExcelInitial extends ExcelState {}
final class filedownloadsecss extends ExcelState {}
final class filedownloadfailed extends ExcelState {}