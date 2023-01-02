part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class LoadProductsEvent extends ProductEvent {
  int? branchId;
  int? pageIndex;
  int? pageSize;

  LoadProductsEvent(
      {required this.branchId, this.pageIndex = 1, this.pageSize = 50});
}

class LoadMoreProductsEvent extends ProductEvent {
  int? branchId;
  int? pageIndex;
  int? pageSize;

  LoadMoreProductsEvent(
      {required this.branchId, this.pageIndex = 1, this.pageSize = 50});
}



class AddProductEvent extends ProductEvent {
  final int branchId;
  final String barcode;

  AddProductEvent({required this.barcode, required this.branchId});
}

class AddProductDTOEvent extends ProductEvent {
  final ProductDTO product;

  AddProductDTOEvent({required this.product});
}




class EditProductEvent extends ProductEvent {
  final ProductDTO product;
  final int index;
  String? action;

  EditProductEvent({required this.product, required this.index, this.action});
}

class UpdateProductEvent extends ProductEvent {
  final ProductDTO product;

  UpdateProductEvent(this.product);
}

class SaveToFileEventEvent extends ProductEvent {
  final int branchId;

  SaveToFileEventEvent({required this.branchId});
}

class DeleteProductEvent extends ProductEvent {
  final ProductDTO product;

  DeleteProductEvent(this.product);
}

class DeleteAllProductsEvent extends ProductEvent {
  final int branchId;
  final String? date;

  DeleteAllProductsEvent({required this.branchId, this.date});
}