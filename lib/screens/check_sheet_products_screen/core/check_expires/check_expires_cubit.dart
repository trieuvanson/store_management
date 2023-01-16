import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:store_management/network/error_handling.dart';
import 'package:store_management/screens/check_sheet_products_screen/model/product_dto.dart';

import '../../repository/product_repository.dart';

part 'check_expires_state.dart';

class CheckExpiresCubit extends Cubit<CheckExpiresState> {
  ProductRepository _productRepository;

  CheckExpiresCubit(this._productRepository) : super(CheckExpiresInitial());

  loading() {
    emit(CheckExpiresLoading());
  }

  checkExpires({
    required int branchId,
    required int pageIndex,
    required int pageSize,
    int? expiryDate,
  }) async {
    try {
      var checkExpires = await _productRepository.checkExpires(
        branchId: branchId,
        pageIndex: pageIndex,
        pageSize: pageSize,
        expiryDate: expiryDate,
      );
      emit(CheckExpiresLoaded(
          checkExpires: checkExpires!.data!,
          nextPage: pageIndex + 1,
          hasNext: checkExpires.totalRecord! < pageIndex * pageSize));
    } catch (e) {
      emit(CheckExpiresError(error: ErrorHandling.showMessage(e)));
    }
  }
}
