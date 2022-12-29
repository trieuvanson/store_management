part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class LoadProducts extends ProductEvent {
  int? branchId;
  int? pageIndex;
  int? pageSize;

  LoadProducts({required this.branchId, this.pageIndex = 1, this.pageSize = 50});
}

class LoadMoreProducts extends ProductEvent {
  int? branchId;
  int? pageIndex;
  int? pageSize;

  LoadMoreProducts(
      {required this.branchId, this.pageIndex = 1, this.pageSize = 50});
}

class AddProduct extends ProductEvent {
  final int branchId;
  final String barcode;

  AddProduct({required this.barcode, required this.branchId});
}

class EditProduct extends ProductEvent {
  final ProductDTO product;
  final int index;

  EditProduct({required this.product, required this.index});
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

class ProductEventNotValidated extends ProductEvent {
  final String error;

  ProductEventNotValidated(this.error);
}

class ProductEventNotValidatedName extends ProductEvent {
  final String error;

  ProductEventNotValidatedName(this.error);
}

class ProductEventNotValidatedDescription extends ProductEvent {
  final String error;

  ProductEventNotValidatedDescription(this.error);
}
