import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:store_management/utils/utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../model/product_dto.dart';
import '../repository/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository productRepository;

  ProductBloc(this.productRepository) : super(ProductInitial()) {
    on<LoadProducts>(_onLoad);
    on<EditProduct>(_onEdit);
    on<AddProduct>(_onAdd);
    on<UpdateProduct>(_onUpdate);
    on<DeleteProduct>(_onDelete);
    on<LoadMoreProducts>(_onLoadMore,
        transformer: throttleDroppable(const Duration(milliseconds: 100)));
  }

  EventTransformer<E> throttleDroppable<E>(Duration duration) {
    return (events, mapper) {
      return droppable<E>().call(events.throttle(duration), mapper);
    };
  }

  _onLoad(LoadProducts event, Emitter<ProductState> emit) async {
    try {
      final products = await productRepository.getAllBy(
          event.branchId!, event.pageIndex!, event.pageSize!);

      if (products != null && products.isEmpty) {
        emit(ProductLoaded(products: products, hasNext: false, nextPage: 1));
      } else {
        emit(ProductLoaded(
            products: products,
            nextPage: event.pageIndex! + 1,
            hasNext: products.length == event.pageSize));
        return;
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onAdd(AddProduct event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      final product =
          await productRepository.getOneBy(event.barcode, event.branchId);
      List<ProductDTO> newProducts = List.from(currentState.products);
      if (product != null && product.id != null) {
        product.inventoryCurrent = product.inventoryCurrent + 1;
        newProducts.add(product);
        emit(ProductLoaded(
            products: newProducts,
            nextPage: currentState.nextPage,
            hasNext: currentState.hasNext));
        showToastSuccess('Thêm sản phẩm thành công');
        return;
      }
      showToastErr('Không tìm thấy sản phẩm');
    } catch (e) {
      showToastErr("Có lỗi xảy ra không thể thêm dữ liệu");
    }
  }

  void _onUpdate(UpdateProduct event, Emitter<ProductState> emit) async {
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

  void _onDelete(DeleteProduct event, Emitter<ProductState> emit) async {
    try {
      final product = await productRepository.delete(event.product);
      emit(ProductDeleted(message: "Xóa thành công"));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  void _onLoadMore(LoadMoreProducts event, Emitter<ProductState> emit) async {
    try {
      ProductLoaded currentState = state as ProductLoaded;
      if (currentState.hasNext) {
        final products = await productRepository.getAllBy(
            event.branchId!, currentState.nextPage, event.pageSize!);

        if (products != null && products.isNotEmpty) {
          List<ProductDTO> newProducts = List.from(currentState.products);
          //Xoá bỏ nếu như danh sách products mới có phần tử trùng với cũ
          for (var element in newProducts) {
            products.removeWhere((item) => element.code == item.code);
          }
          newProducts.addAll(products);
          emit(ProductLoaded(
              products: newProducts,
              nextPage: currentState.nextPage! + 1,
              hasNext: products.length == event.pageSize));
          return;
        } else {
          emit(ProductLoaded(
              products: currentState.products,
              nextPage: currentState.nextPage! + 1,
              hasNext: false));
        }
      } else {
        Fluttertoast.showToast(msg: "Không còn dữ liệu");
      }
    } catch (e) {
      Get.snackbar("Lỗi", e.toString());
    }
  }

  void _onEdit(EditProduct event, Emitter<ProductState> emit) async {
    ProductLoaded currentState = state as ProductLoaded;
    List<ProductDTO> newProducts = List.from(currentState.products);
    newProducts[event.index] = event.product;
    emit(ProductLoaded(
        products: newProducts,
        nextPage: currentState.nextPage,
        hasNext: currentState.hasNext));
    Fluttertoast.showToast(
        msg:"${event.product.name} - Số lượng: ${event.product.inventoryCurrent.toInt()}");
  }
}
