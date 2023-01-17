import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '/screens/check_sheet_products_screen/core/detail_bloc/product_bloc.dart';
import '/screens/check_sheet_products_screen/core/search_products/search_products_cubit.dart';

import '../../../constants/contains.dart';
import '../../../utils/utils.dart';
import '../../screens.dart';
import '../model/product_dto.dart';

class CheckSheetSearchScreen extends SearchDelegate<dynamic> {
  final SearchProductsCubit searchProdCubit;
  final int branchId;
  final _debounce = Debounce(milliseconds: 300);

  CheckSheetSearchScreen(
      {required this.searchProdCubit, required this.branchId});

  @override
  void showResultsNotUnFocus(BuildContext context) {
    var searchQuery = query;
    _debounce.run(() {
      searchProdCubit.searchProduct(
          query: searchQuery, branchId: branchId, pageIndex: 1, pageSize: 50);
    });
    super.showResultsNotUnFocus(context);
  }

  @override
  get searchFieldLabel => 'Tìm kiếm sản phẩm';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showResultsNotUnFocus(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          if (searchProdCubit.state is ProductLoadedSearch) {
            searchProdCubit.loadMoreSearchProduct(
                branchId: branchId, pageSize: 50, query: query);
          }
        }
        return true;
      },
      child: BlocBuilder<SearchProductsCubit, SearchProductsState>(
        bloc: searchProdCubit,
        builder: (context, state) {
          if (state is SearchProductsInitial) {
            return Center(
              child: "Tìm kiếm sản phẩm".text.make(),
            );
          }
          if (state is ProductLoadedSearch) {
            return state.products.isEmpty
                ? _noDataSection("Không có dữ liệu")
                : ListView.builder(
                    controller: ScrollController(),
                    itemCount: state.hasNext && state.isLoading != null
                        ? state.products.length + 1
                        : state.products.length,
                    addAutomaticKeepAlives: true,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < state.products.length) {
                        return _listProducts(context,
                            product: state.products[index], index: index);
                      }
                      return _loadingSection();
                    });
          }

          if (state is Error) {
            return const Center(
              child: Text('Có lỗi xảy ra'),
            );
          }
          return Center(
            child: "Chưa có dữ liệu".text.make(),
          );
        },
      ),
    );
  }

  _noDataSection(String message) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Center(
              child: Text(
            message,
            style: const TextStyle(fontSize: 20),
          )),
        )
      ],
    );
  }

  _listProducts(BuildContext context, {required ProductDTO product, index}) {
    Color color = kPrimaryColor.withOpacity(0.1);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
      child: InputDecorator(
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(Icons.add_box_sharp, color: kPrimaryColor),
            onPressed: () {
              BlocProvider.of<ProductBloc>(context)
                  .add(AddProductDTOEvent(product: product));
            },
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
          child: InkWell(
            onTap: () {
              //CheckSheetDetailScreen(product: product, index: index)
              Get.toNamed(CheckSheetDetailScreen.routeName, arguments: {
                'product': product,
                'index': index,
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: color,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Image.network(
                          product.image ?? '',
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(
                              width: 80,
                              height: 120,
                              child: Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              width: 80,
                              height: 120,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: kDefaultPadding / 2,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${product.name}",
                          style: kTextAveHev14.copyWith(color: kColorBlack),
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 4,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       height:8,
                        //       width: 8,
                        //       decoration: BoxDecoration(
                        //           color: character.status=="Alive"?kColorGreen:kColorRed,
                        //           shape: BoxShape.circle
                        //       ),
                        //     ),
                        //     const SizedBox(width: kDefaultPadding/4,),
                        //     Text(character.status!,style: kTextAveHev14.copyWith(
                        //         color: kColorBlack,
                        //         fontSize: 14
                        //     ),),
                        //   ],
                        // ),
                        Text(
                          "Code: ${product.code ?? ''}",
                          style: kTextAveHev14.copyWith(
                              color: kColorBlack.withOpacity(0.6),
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 4,
                        ),
                        Text(
                          "Giá: ${convertToVND(product.price ?? 0)}",
                          style: kTextAveHev14.copyWith(
                              color: kColorBlack, fontSize: 14),
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 4,
                        ),
                        Text(
                          "Tồn kho: ${(product.inventory?.toInt()) ?? 0}",
                          style: kTextAveHev14.copyWith(
                              color: kColorBlack.withOpacity(0.6),
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 4,
                        ),
                        Text(
                          "Tồn thực tế: ${(product.inventoryCurrent.toInt())}",
                          style: kTextAveHev14.copyWith(
                              color: kColorBlack.withOpacity(0.6),
                              fontSize: 14),
                        ),
                        const SizedBox(
                          height: kDefaultPadding / 4,
                        ),
                        //list to text, split ,
                        Text(
                          product.expires!.isNotEmpty
                              ? "Hạn sử dụng: ${product.expires?.map((e) => e.date).join(', ')}"
                              : '',
                          style: kTextAveHev14.copyWith(
                              color: kColorBlack.withOpacity(0.6),
                              fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _loadingSection() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

class Debounce {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounce({this.milliseconds = 300});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
