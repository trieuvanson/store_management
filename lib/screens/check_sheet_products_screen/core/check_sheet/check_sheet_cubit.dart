import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '/screens/check_sheet_products_screen/model/check_sheet_dto.dart';

import '../../repository/check_sheet_repository.dart';

part 'check_sheet_state.dart';

class CheckSheetCubit extends Cubit<CheckSheetState> {
  final CheckSheetRepository _checkSheetRepository;

  CheckSheetCubit(this._checkSheetRepository) : super(CheckSheetInitial());

  Future<void> getAllBy(
      {required int branchId,
      required int pageIndex,
      required int pageSize,
      String? date}) async {
    try {
      var checkSheets = await _checkSheetRepository.getAllBy(
          branchId: branchId,
          pageIndex: pageIndex,
          pageSize: pageSize);
      emit(CheckSheetLoaded(checkSheets: checkSheets.data!, nextPage: pageIndex+1, hasNext: checkSheets.totalRecord! < pageIndex*pageSize));
    } catch (e) {
      emit(CheckSheetError(error: e.toString()));
    }
  }

  String? _getDate(String? date) {
    if (date != null && date.length > 10) {
      date = date.substring(0, 10);
    }
    return date;
  }
}
