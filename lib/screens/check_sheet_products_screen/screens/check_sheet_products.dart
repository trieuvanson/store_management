import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_management/screens/check_sheet_products_screen/core/product_bloc.dart';
import 'package:store_management/screens/check_sheet_products_screen/model/product_dto.dart';

import '../../../constants/contains.dart';
import '../../../utils/utils.dart';
import '../widget/app_barcode_scanner_widget.dart';

class CheckSheetProductsScreen extends StatefulWidget {
  final int branchId;

  const CheckSheetProductsScreen({Key? key, required this.branchId})
      : super(key: key);

  static const String routeName = '/check-sheet-products/:branchId';

  @override
  State<CheckSheetProductsScreen> createState() =>
      _CheckSheetProductsScreenState();
}

class _CheckSheetProductsScreenState extends State<CheckSheetProductsScreen> {
  late ScrollController _scrollController;
  late ProductBloc _productBloc;
  int _pageIndex = 1;
  int _pageSize = 50;
  bool _isShowCam = false;
  int indexFocus = -1;

  @override
  void initState() {
    _productBloc = BlocProvider.of<ProductBloc>(context);
    _productBloc.add(LoadProducts(
      branchId: widget.branchId,
      pageIndex: _pageIndex,
      pageSize: _pageSize,
    ));
    _scrollController = ScrollController();
    super.initState();
  }

  _scrollToItem(int index, final data) {
    if (index == -1) index = data.length - 1;
    try {
      if ((index * _scrollController.position.maxScrollExtent / data.length) ==
          _scrollController.position.pixels) {
        return;
      }
      _scrollController.animateTo(
        index * _scrollController.position.maxScrollExtent / data.length,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      print(e);
    }
  }

  initPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }

  addBarCode(String barcode) {
    print('barcode: $barcode');
    var state = _productBloc.state as ProductLoaded;
    bool isExist = false;
    for (var i = 0; i < state.products.length; i++) {
      var element = state.products[i];
      if (element.code == barcode) {
        _productBloc.add(
          EditProduct(
            product: element.copyWith(
                inventoryCurrent: element.inventoryCurrent + 1),
            index: i,
          ),
        );
        _scrollToItem(i, state.products);
        isExist = true;
      }
    }
    if (!isExist) {
      try {
        _productBloc.add(
          AddProduct(barcode: barcode, branchId: widget.branchId),
        );
      } catch (e) {
      }
    }
    soundWhenScanned();
  }

  soundWhenScanned() async {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/Scanner-Beep-Sound.wav'));
    print('Sound');
  }

  hideShowCamera() {
    setState(() {
      _isShowCam = !_isShowCam;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const SCREEN_NAME = 'Kiểm tra tồn kho';
    return Scaffold(
      appBar: AppBar(
        title: const Text(SCREEN_NAME),
        actions: [
          IconButton(
            onPressed: hideShowCamera,
            icon: Icon(
              _isShowCam ? Icons.close : Icons.camera_alt,
              color: Colors.white,
            ),
            tooltip: _isShowCam ? "Ẩn camera" : "Hiện camera",
          ),
          //Làm mới
          IconButton(
            onPressed: () => {
              //Create beautiful dialog
              // Get.dialog(
              //   //Một phần nhỏ màn hình
              //   AlertDialog(
              //     title: const Text('Thông báo'),
              //     content: SizedBox(
              //       height: 200,
              //       width: 200,
              //       child: AppBarcodeScannerWidget.defaultStyle(
              //         resultCallback: (String code) {
              //           print('code: $code');
              //           // addBarCode(code);
              //         },
              //       ),
              //     ),
              //     actions: [
              //       TextButton(
              //         onPressed: () => Get.back(),
              //         child: const Text('Không'),
              //       ),
              //       TextButton(
              //         onPressed: () => {
              //           setState(() {}),
              //           Get.back(),
              //         },
              //         child: const Text('Có'),
              //       ),
              //     ],
              //   ),
              // )
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _isShowCam
                ? Expanded(
                    flex: 2,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      child: AppBarcodeScannerWidget.defaultStyle(
                        resultCallback: addBarCode,
                        openManual: true,
                      ),
                    ),
                  )
                : Container(),
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollNotification) {
                if (scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
                  if (_productBloc.state is ProductLoaded) {
                    _productBloc.add(LoadMoreProducts(
                        branchId: widget.branchId, pageSize: _pageSize));
                  }
                }
                return true;
              },
              child: Expanded(
                flex: 6,
                child: BlocBuilder<ProductBloc, ProductState>(
                  bloc: _productBloc,
                  builder: (context, state) {
                    if (state is ProductInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is ProductLoaded) {
                      return state.products.isEmpty
                          ? _noDataSection("Không có dữ liệu")
                          : ListView.builder(
                              controller: _scrollController,
                              itemCount: state.hasNext
                                  ? state.products.length + 1
                                  : state.products.length,
                              addAutomaticKeepAlives: true,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index < state.products.length) {
                                  return _listProducts(
                                      product: state.products[index],
                                      index: index);
                                }
                                return _loadingSection();
                              });
                    }

                    if (state is Error) {
                      return const Center(
                        child: Text('Có lỗi xảy ra'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
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

  _listProducts({required ProductDTO product, index}) {
    return Padding(
      key: Key(product.id.toString()),
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 4),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
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
              const SizedBox(
                width: kDefaultPadding / 2,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${product.name} - $index",
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
                    //         fontSize: 12
                    //     ),),
                    //   ],
                    // ),
                    const SizedBox(
                      height: kDefaultPadding / 4,
                    ),
                    Text(
                      "Code: ${product.code!}",
                      style: kTextAveRom12.copyWith(color: kColorBlack),
                    ),
                    const SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                    const SizedBox(
                      height: kDefaultPadding / 5,
                    ),
                    Text(
                      "Giá: ${convertToVND(product.price)}",
                      style: kTextAveHev14.copyWith(
                          color: kColorBlack, fontSize: 12),
                    ),
                    const SizedBox(
                      height: kDefaultPadding / 4,
                    ),
                    Text(
                      "Tồn kho: ${(product.inventory!.toInt())}",
                      style: kTextAveHev14.copyWith(
                          color: kColorBlack.withOpacity(0.6), fontSize: 12),
                    ),
                    const SizedBox(
                      height: kDefaultPadding / 4,
                    ),
                    Text(
                      "Tồn thực tế: ${(product.inventoryCurrent.toInt())}",
                      style: kTextAveHev14.copyWith(
                          color: kColorBlack.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _loadingSection() {
    return const Center(child: CircularProgressIndicator());
  }
}
