part of 'check_sheet_cubit.dart';

@immutable
abstract class CheckSheetState {}

class CheckSheetInitial extends CheckSheetState {}

class CheckSheetLoaded extends CheckSheetState {
  final List<CheckSheetDTO> checkSheets;
  int nextPage = 1;
  bool hasNext = true;
  String? isLoading = null;
  CheckSheetLoaded({required this.checkSheets, required this.nextPage, required this.hasNext, this.isLoading});
}

class CheckSheetLoading extends CheckSheetState {}

class CheckSheetError extends CheckSheetState {
  final String error;
  CheckSheetError({required this.error});
}
