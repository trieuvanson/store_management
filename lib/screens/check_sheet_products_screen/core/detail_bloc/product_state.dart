part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {}

class ProductInitial extends ProductState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductLoading extends ProductState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductLoaded extends ProductState {
  List<ProductDTO> products;
  int nextPage = 1;
  bool hasNext = true;
  String? isLoading = null;

  ProductLoaded(
      {required this.products, required this.nextPage, required this.hasNext, this.isLoading});

  ProductLoaded copyWith(
      {List<ProductDTO>? products, int? nextPage, bool? hasNext}) {
    return ProductLoaded(
        products: products ?? this.products,
        nextPage: nextPage ?? this.nextPage,
        hasNext: hasNext ?? this.hasNext);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [products, nextPage, hasNext];
}

//created
class ProductCreated extends ProductState {
  ProductDTO product;

  ProductCreated({required this.product});

  @override
  List<Object?> get props => [product];
}

//updated
class ProductUpdated extends ProductState {
  ProductDTO product;

  ProductUpdated({required this.product});

  @override
  List<Object?> get props => [product];
}

//deleted
class ProductDeleted extends ProductState {
  String? message;

  ProductDeleted({this.message});

  @override
  List<Object?> get props => [message];
}

class ProductError extends ProductState {
  final String error;

  ProductError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
