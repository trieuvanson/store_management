import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import '/screens/check_sheet_products_screen/model/check_sheet_dto.dart';

import '../../../../utils/date_utils.dart';
import '../../model/product_dto.dart';
import '../../repository/check_sheet_repository.dart';

part 'check_sheet_state.dart';

class CheckSheetCubit extends Cubit<CheckSheetState> {
  final CheckSheetRepository _checkSheetRepository;

  CheckSheetCubit(this._checkSheetRepository) : super(CheckSheetInitial());

  loading() {
    emit(CheckSheetLoading());
  }

  Future<void> getAllBy(
      {required int branchId,
      required int pageIndex,
      required int pageSize,
      String? date}) async {
    try {
      var checkSheets = await _checkSheetRepository.getAllBy(
          branchId: branchId, pageIndex: pageIndex, pageSize: pageSize);
      emit(CheckSheetLoaded(
          checkSheets: checkSheets.data!,
          nextPage: pageIndex + 1,
          hasNext: checkSheets.totalRecord! < pageIndex * pageSize));
    } catch (e) {
      emit(CheckSheetError(error: "Lỗi khi tải dữ liệu"));
    }
  }

  Future<void> createWithBody(
      {String? date,
      required List<ProductDTO> products,
      required int branchId,
      int? checkSheetId}) async {
    try {
      date ??= dateUtils.getFormattedDateByCustom(
          DateTime.now(), 'dd/MM/yyyy HH:mm:ss');
      CheckSheetDtoResponse isExistCheckSheet =
          (await _checkSheetRepository.getAllBy(
              branchId: branchId, pageIndex: 1, pageSize: 50, date: date));
      if (isExistCheckSheet.data!.isNotEmpty) {
        await _checkSheetRepository.updateWithBody(
            date: date,
            products: products,
            branchId: branchId,
            checkSheetId: isExistCheckSheet.data![0].id!);
      } else {
        await _checkSheetRepository.createWithBody(
            date: date, products: products, branchId: branchId);
        getAllBy(branchId: branchId, pageIndex: 1, pageSize: 50);
      }
      Fluttertoast.showToast(
          msg: 'Đã lưu phiếu kiểm kho vào lúc $date',
          backgroundColor: Colors.green);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Lỗi: $e');
    }
  }

  delete(int branchId, String? date) async {
    try {
      var checkSheet = await _checkSheetRepository.getAllBy(
          branchId: branchId, pageIndex: 1, pageSize: 1, date: date);
      if (checkSheet.data!.isNotEmpty) {
        var info = await _checkSheetRepository
            .deleteCustom(queries: {"checkSheetId": checkSheet.data![0].id!});
        getAllBy(branchId: branchId, pageIndex: 1, pageSize: 50);
        Fluttertoast.showToast(msg: info ?? 'Đã xóa phiếu kiểm kho');
      } else {
        Fluttertoast.showToast(msg: 'Không thể xoá!\nKhông có phiếu kiểm kho');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Lỗi: $e');
    }
  }

  String? _getDate(String? date) {
    if (date != null && date.length > 10) {
      date = date.substring(0, 10);
    }
    return date;
  }
}
