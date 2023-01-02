import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:store_management/screens/check_sheet_products_screen/screens/check_sheet_products.dart';
import 'package:store_management/utils/utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../utils/date_utils.dart';
import '../../../../utils/flie_utils.dart';
import '../../model/product_dto.dart';
import '../../repository/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
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

  _onLoad(LoadProductsEvent event, Emitter<ProductState> emit) async {
    try {
      //check if file saved
      List<dynamic> dataMap =
          await fileUtils.readDataFromFileJson(_fileName(event.branchId!));
      List<ProductDTO> productOld =
          dataMap.map<ProductDTO>((e) => ProductDTO.fromJson(e)).toList();

      //get new
      var products = await productRepository.getAllBy(
          event.branchId!, event.pageIndex!, event.pageSize!);

      if (products != null && products.isEmpty) {
        emit(ProductLoaded(products: products, hasNext: false, nextPage: 1));
      } else {
        for (var element in productOld) {
          products.removeWhere((item) => element.code == item.code);
        }
        List<ProductDTO> newProducts = [...productOld, ...products];
        emit(ProductLoaded(
            products: newProducts,
            nextPage: event.pageIndex! + 1,
            hasNext: true,
            isLoading: "more"));
        return;
      }
    } catch (e) {
      emit(ProductError("Không có dữ liệu"));
    }
  }

  void _onAdd(AddProductEvent event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      final product =
          await productRepository.getOneBy(event.barcode, event.branchId);
      List<ProductDTO> newProducts = List.from(currentState.products);
      if (product != null && product.id != null) {
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
      if ((e as DioError).response!.statusCode == 400) {
        showToastErr('Sản phẩm không tồn tại');
      } else {
        showToastErr("Có lỗi xảy ra không thể thêm dữ liệu");
      }
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
      emit(ProductError(e.toString()));
    }
  }

  void _onDelete(DeleteProductEvent event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.delete(event.product);
      emit(ProductDeleted(message: "Xóa thành công"));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onLoadMore(
      LoadMoreProductsEvent event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      if (currentState.hasNext) {
        final products = await productRepository.getAllBy(
            event.branchId!, currentState.nextPage, event.pageSize!);
        var size1 = products.length;
        if (products != null && products.isNotEmpty) {
          List<ProductDTO> newProducts = List.from(currentState.products);
          //Xoá bỏ nếu như danh sách products mới có phần tử trùng với cũ
          for (var element in newProducts) {
            products.removeWhere((item) => element.code == item.code);
          }
          newProducts.addAll(products);
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
      Get.snackbar("Lỗi", e.toString());
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
          msg: "Không thể cập nhật sản phẩm, vui lòng thử lại",
          toastLength: Toast.LENGTH_SHORT);
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
    } catch (e) {}
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

  String _fileName(int branchId, {String? date}) {
    date ??= dateUtils.getFormattedDateByCustom(DateTime.now(), "dd_MM_yyyy");
    return "${branchId}_check_sheet_products_$date"
        .replaceAll(" ", "")
        .replaceAll('/', '_');
  }
}
