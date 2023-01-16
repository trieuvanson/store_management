import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:store_management/network/error_handling.dart';
import 'package:store_management/screens/check_sheet_products_screen/model/check_sheet_dto.dart';
import 'package:store_management/screens/check_sheet_products_screen/screens/check_sheet_products.dart';
import 'package:store_management/utils/utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../utils/date_utils.dart';
import '../../../../utils/flie_utils.dart';
import '../../model/product_dto.dart';
import '../../repository/check_sheet_repository.dart';
import '../../repository/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository productRepository;
  CheckSheetRepository checkSheetRepository;

  ProductBloc(this.productRepository, this.checkSheetRepository)
      : super(ProductInitial()) {
    on<ProductEventLoading>(_loading);
    on<LoadProductsEvent>(_onLoad);
    on<EditProductEvent>(_onEdit);
    on<AddProductEvent>(_onAdd);
    on<AddProductDTOEvent>(_onAddEdit);
    on<UpdateProductEvent>(_onUpdate);
    on<DeleteProductEvent>(_onDelete);
    on<LoadMoreProductsEvent>(_onLoadMore,
        transformer: throttleDroppable(const Duration(milliseconds: 100)));
    on<SaveToFileEventEvent>(_onSaveToFile);
    on<DeleteAllProductsEvent>(_onDeleteAllProducts);
  }

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  _loading(ProductEventLoading event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
  }

  _onLoad(LoadProductsEvent event, Emitter<ProductState> emit) async {
    try {
      print(state);

      CheckSheetDtoResponse isExistCheckSheet =
          (await checkSheetRepository.getAllBy(
              branchId: event.branchId!,
              pageIndex: event.pageIndex!,
              pageSize: event.pageSize!,
              date: event.date!));
      var productOld = [];
      if (isExistCheckSheet.data!.isNotEmpty) {
        productOld = await checkSheetRepository.getCheckSheetDetail(
          branchId: event.branchId!,
          pageIndex: event.pageIndex!,
          pageSize: event.pageSize!,
          checkSheetId: isExistCheckSheet.data![0].id,
        );
      }
      List<ProductDTO> products = [];
      if (event.date ==
          dateUtils.getFormattedDateByCustom(DateTime.now(), 'dd/MM/yyyy')) {
        products = await productRepository.getAllBy(
            event.branchId!, event.pageIndex!, event.pageSize!);
      }

      if (products != null &&
          products.isEmpty &&
          isExistCheckSheet.data!.isEmpty) {
        emit(ProductLoaded(products: products, hasNext: false, nextPage: 1));
      } else {
        for (var element in productOld) {
          products.removeWhere((item) => element.code == item.code);
        }
        List<ProductDTO> newProducts = [...productOld, ...products];
        emit(ProductLoaded(
            products: newProducts,
            nextPage: event.pageIndex! + 1,
            hasNext: newProducts.length >= event.pageSize!,
            checkSheetId: isExistCheckSheet.data!.isNotEmpty
                ? isExistCheckSheet.data![0].id
                : null,
            isLoading: "more"));
      }
      Fluttertoast.showToast(
          msg: "Đã tải kiểm kho ngày ${event.date}",
          backgroundColor: Colors.green);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Lỗi tải kiểm kho ngày ${event.date}",
          backgroundColor: Colors.red);
      emit(ProductError(ErrorHandling.showMessage(e)));
    }
  }

  void _onAdd(AddProductEvent event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      final product =
          await productRepository.getOneBy(event.barcode, event.branchId);
      List<ProductDTO> newProducts = List.from(currentState.products);
      if (product.id != null) {
        showToastSuccess('Thêm sản phẩm thành công');
        product.inventoryCurrent = product.inventoryCurrent + 1;
        newProducts.add(product);
        emit(ProductLoaded(
            products: newProducts,
            nextPage: currentState.nextPage,
            hasNext: currentState.hasNext,
            isLoading: "more"));
        return;
      }
      showToastErr('Không tìm thấy sản phẩm');
    } catch (e) {
      showToastErr(ErrorHandling.showMessage(e));
    }
  }

  void _onAddEdit(AddProductDTOEvent event, Emitter<ProductState> emit) async {
    ProductLoaded currentState = state as ProductLoaded;
    var products = List<ProductDTO>.from(currentState.products);
    bool checkExist =
        products.any((element) => element.code == event.product.code);
    if (checkExist) {
      Fluttertoast.showToast(
          msg: 'Sản phẩm đã tồn tại',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red);
    } else {
      products.add(event.product);
      emit(ProductLoaded(
          products: products,
          nextPage: currentState.nextPage,
          hasNext: currentState.hasNext,
          isLoading: "more"));
      Fluttertoast.showToast(
          msg: 'Thêm sản phẩm thành công',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green);
    }
  }

  void _onUpdate(UpdateProductEvent event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.update(event.product);
      if (product != null) {
        emit(ProductUpdated(product: product));
        return;
      }
      emit(ProductError("Lỗi khi cập nhật dữ liệu"));
    } catch (e) {
      emit(ProductError(ErrorHandling.showMessage(e)));
    }
  }

  void _onDelete(DeleteProductEvent event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.delete(event.product);
      emit(ProductDeleted(message: "Xóa thành công"));
    } catch (e) {
      emit(ProductError(ErrorHandling.showMessage(e)));
    }
  }

  void _onLoadMore(
      LoadMoreProductsEvent event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      if (currentState.hasNext) {
        List<ProductDTO> checkSheetProducts = [];
        if (currentState.checkSheetId != null) {
          checkSheetProducts = await checkSheetRepository.getCheckSheetDetail(
            branchId: event.branchId!,
            pageIndex: event.pageIndex!,
            pageSize: event.pageSize!,
            checkSheetId: currentState.checkSheetId,
          );
        }
        final products = await productRepository.getAllBy(
            event.branchId!, currentState.nextPage, event.pageSize!);
        var size1 = products.length;
        if (products != null && products.isNotEmpty) {
          List<ProductDTO> newProducts = List.from(currentState.products);
          //Xoá bỏ nếu như danh sách products mới có phần tử trùng với cũ
          for (var element in newProducts) {
            products.removeWhere((item) => element.code == item.code);
          }
          newProducts = [...newProducts, ...products];
          for (var element in checkSheetProducts) {
            newProducts.removeWhere((item) => element.code == item.code);
          }
          newProducts = [...newProducts, ...checkSheetProducts];
          emit(ProductLoaded(
            products: newProducts,
            nextPage: currentState.nextPage + 1,
            hasNext: event.pageSize! == size1,
            isLoading: products.isNotEmpty ? 'more' : null,
          ));
          Fluttertoast.showToast(
              msg: "Đang tải trang ${currentState.nextPage}",
              toastLength: Toast.LENGTH_SHORT);
          return;
        } else {
          emit(ProductLoaded(
              products: currentState.products,
              nextPage: currentState.nextPage + 1,
              hasNext: false));
        }
      } else {
        Fluttertoast.showToast(
            msg: "Không còn dữ liệu", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      Get.snackbar("Lỗi", ErrorHandling.showMessage(e));
    }
  }

  void _onEdit(EditProductEvent event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      List<ProductDTO> newProducts = List.from(currentState.products);
      // var updateProduct = await productRepository.updateWithParams(
      //     storeDto: event.product, branchId: event.branchId);
      newProducts[event.index] = event.product;
      emit(
        ProductLoaded(
          products: newProducts,
          nextPage: currentState.nextPage,
          hasNext: currentState.hasNext,
          isLoading: "more",
        ),
      );
      if (event.action == null) {
        Fluttertoast.showToast(
          msg:
              "${event.product.name}\nSố lượng: ${event.product.inventoryCurrent.toInt()}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
        );
      } else {
        Get.back();
        Fluttertoast.showToast(msg: "Thành công!");
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: ErrorHandling.showMessage(e), toastLength: Toast.LENGTH_SHORT);
    }
  }

  void _onSaveToFile(
      SaveToFileEventEvent event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      var fileName = _fileName(event.branchId);
      bool deleteBefore = await fileUtils.removeFile(fileName);
      bool saved =
          await fileUtils.saveDataToFileJson(currentState.products, fileName);
      if (saved) {
        Fluttertoast.showToast(
            msg: "Đã lưu lại dữ liệu hiện tại", backgroundColor: Colors.green);
      } else {
        Fluttertoast.showToast(
            msg: "Dữ liệu chưa được lưu lại, đã xảy ra lỗi",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: ErrorHandling.showMessage(e), backgroundColor: Colors.red);
    }
  }

  void _onDeleteAllProducts(
      DeleteAllProductsEvent event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      var fileName = _fileName(event.branchId, date: event.date);
      bool deleteBefore = await fileUtils.removeFile(fileName);
      if (deleteBefore) {
        emit(ProductLoaded(
            products: [],
            nextPage: currentState.nextPage,
            hasNext: currentState.hasNext));
        Fluttertoast.showToast(
            msg: "Đã xoá dữ liệu hiện tại ngày ${event.date}",
            backgroundColor: Colors.green);
        return;
      }
      Fluttertoast.showToast(
          msg: "Không có dữ liệu ngày ${event.date}",
          backgroundColor: Colors.red);
    } catch (e) {}
  }

  int getIndex(String code) {
    if (state is ProductLoaded) {
      ProductLoaded currentState = state as ProductLoaded;
      for (var i = 0; i < currentState.products.length; i++) {
        if (currentState.products[i].code == code) {
          return i;
        }
      }
    }
    return -1;
  }



  get index => getIndex;

  String _fileName(int branchId, {String? date}) {
    date ??= dateUtils.getFormattedDateByCustom(DateTime.now(), "dd_MM_yyyy");
    return "${branchId}_check_sheet_products_$date"
        .replaceAll(" ", "")
        .replaceAll('/', '_');
  }
}
