import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

import '../../model/product_dto.dart';
import '../../repository/product_repository.dart';

part 'search_products_state.dart';

class SearchProductsCubit extends Cubit<SearchProductsState> {
  final ProductRepository productRepository;

  SearchProductsCubit(this.productRepository) : super(SearchProductsInitial());

  Future<void> searchProduct(
      {String? query, int? branchId, int? pageIndex, int? pageSize}) async {
    try {
      if (query == null || query.isEmpty) {
        emit(ProductLoadedSearch(
            products: const [], hasNext: false, nextPage: pageIndex! + 1));
        return;
      }
      var products = await productRepository.search(query,
          branchId: branchId, pageIndex: pageIndex, pageSize: pageSize);
      if (products != null && products.isNotEmpty) {
        emit(ProductLoadedSearch(
            products: products,
            nextPage: pageIndex! + 1,
            hasNext: true,
            isLoading: "more"));
      } else {
        emit(ProductLoadedSearch(
            products: products, hasNext: false, nextPage: pageIndex! + 1));
      }
    } catch (e) {
      emit(ProductLoadedSearch(
          products: const [], hasNext: false, nextPage: pageIndex! + 1));
    }
  }

  Future<void> loadMoreSearchProduct(
      {String? query, int? branchId, int? pageIndex, int? pageSize}) async {
    ProductLoadedSearch currentState = state as ProductLoadedSearch;

    try {
      if (currentState.hasNext) {
        final products = await productRepository.search(query,
            branchId: branchId,
            pageIndex: currentState.nextPage,
            pageSize: pageSize);
        // var size1 = products.length;
        if (products != null && products.isNotEmpty) {
          // List<ProductDTO> newProducts = List.from(currentState.products);
          // //Xoá bỏ nếu như danh sách products mới có phần tử trùng với cũ
          // for (var element in newProducts) {
          //   products.removeWhere((item) => element.code == item.code);
          // }
          // newProducts.addAll(products);
          emit(ProductLoadedSearch(
            products: [...currentState.products, ...products],
            nextPage: currentState.nextPage + 1,
            hasNext: products.length == pageSize!,
            isLoading: products.isNotEmpty ? 'more' : null,
          ));
          // Fluttertoast.showToast(
          //   msg: "Đang tải trang ${currentState.nextPage}",
          //   toastLength: Toast.LENGTH_SHORT,
          // );
          return;
        } else {
          emit(ProductLoadedSearch(
              products: currentState.products,
              nextPage: currentState.nextPage + 1,
              hasNext: false));
        }
      }
      // else {
      //   Fluttertoast.showToast(msg: "Không còn dữ liệu");
      // }
    } catch (e) {
      emit(ProductLoadedSearch(
        products: currentState.products,
        nextPage: currentState.nextPage + 1,
        hasNext: false,
        isLoading: null,
      ));
      Fluttertoast.showToast(
          msg: "Không còn dữ liệu", toastLength: Toast.LENGTH_SHORT);
    }
  }
}
