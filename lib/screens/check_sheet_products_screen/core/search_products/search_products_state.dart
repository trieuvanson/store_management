part of 'search_products_cubit.dart';

@immutable
abstract class SearchProductsState {}

class SearchProductsInitial extends SearchProductsState {}

class ProductLoadedSearch extends SearchProductsState {
  List<ProductDTO> products;
  int nextPage = 1;
  bool hasNext = true;
  String? isLoading = null;

  ProductLoadedSearch(
      {required this.products, required this.nextPage, required this.hasNext, this.isLoading});

  ProductLoadedSearch copyWith(
      {List<ProductDTO>? products, int? nextPage, bool? hasNext}) {
    return ProductLoadedSearch(
        products: products ?? this.products,
        nextPage: nextPage ?? this.nextPage,
        hasNext: hasNext ?? this.hasNext);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [products, nextPage, hasNext];
}


