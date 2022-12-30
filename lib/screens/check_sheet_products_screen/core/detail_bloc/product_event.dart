part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class LoadProducts extends ProductEvent {
  int? branchId;
  int? pageIndex;
  int? pageSize;

  LoadProducts(
      {required this.branchId, this.pageIndex = 1, this.pageSize = 50});
}

class LoadMoreProducts extends ProductEvent {
  int? branchId;
  int? pageIndex;
  int? pageSize;

  LoadMoreProducts(
      {required this.branchId, this.pageIndex = 1, this.pageSize = 50});
}

class SearchProducts extends ProductEvent {
  String? query;
  int? branchId;
  int? pageIndex;
  int? pageSize;

  SearchProducts({
    required this.query,
    required this.branchId,
    this.pageIndex = 1,
    this.pageSize = 50,
  });
}

class LoadMoreSearchProducts extends ProductEvent {
  String? query;
  int? branchId;
  int? pageIndex;
  int? pageSize;

  LoadMoreSearchProducts({
    required this.query,
    required this.branchId,
    this.pageIndex = 1,
    this.pageSize = 50,
  });
}

class AddProduct extends ProductEvent {
  final int branchId;
  final String barcode;

  AddProduct({required this.barcode, required this.branchId});
}

class EditProduct extends ProductEvent {
  final ProductDTO product;
  final int index;
  String? action;

  EditProduct({required this.product, required this.index, this.action});
}

class UpdateProduct extends ProductEvent {
  final ProductDTO product;

  UpdateProduct(this.product);
}

class SaveToFileEvent extends ProductEvent {
  final int branchId;

  SaveToFileEvent({required this.branchId});
}

class DeleteProduct extends ProductEvent {
  final ProductDTO product;

  DeleteProduct(this.product);
}

class DeleteAllProducts extends ProductEvent {
  final int branchId;
  final String? date;

  DeleteAllProducts({required this.branchId, this.date});
}