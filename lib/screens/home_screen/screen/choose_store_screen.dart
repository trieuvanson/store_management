import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/screens/home_screen/repository/store_dto_repository.dart';

import '../../../constants/contains.dart';
import '../../screens.dart';

class ChooseStoreScreen extends StatefulWidget {
  static const String routeName = '/choose-store-screen';

  const ChooseStoreScreen({Key? key}) : super(key: key);

  @override
  State<ChooseStoreScreen> createState() => _ChooseStoreScreenState();
}

class _ChooseStoreScreenState extends State<ChooseStoreScreen> {
  late StoreDtoRepository _storeDtoRepository;
  var data = {
    "total": 4,
    "pageSize": 20,
    "data": [
      {
        "id": 16413,
        "branchName": "555 KINGMART 108",
        "address": "108 BẠCH ĐẰNG",
        "locationName": "Kiên Giang - Huyện Phú Quốc",
        "wardName": "",
        "contactNumber": "0975911555",
        "retailerId": 107783,
        "modifiedDate": "2018-10-25T15:17:08.0130000",
        "createdDate": "2016-09-19T11:03:17.9200000"
      },
      {
        "id": 80204,
        "branchName": "KHO TỔNG",
        "address": "141a Trần Hưng Đạo",
        "locationName": "Kiên Giang - Huyện Phú Quốc",
        "wardName": "Thị trấn Dương Đông",
        "contactNumber": "0975911555",
        "retailerId": 107783,
        "modifiedDate": "2021-06-07T14:58:46.5500000",
        "createdDate": "2018-04-28T00:35:12.3030000"
      },
      {
        "id": 80203,
        "branchName": "KING KONG 141",
        "address": "141A TRẦN HƯNG ĐẠO",
        "locationName": "Kiên Giang - Huyện Phú Quốc",
        "wardName": "Thị trấn Dương Đông",
        "contactNumber": "0975911555",
        "retailerId": 107783,
        "modifiedDate": "2021-09-10T15:20:11.9530000",
        "createdDate": "2018-04-28T00:34:19.9700000"
      }
    ],
    "timestamp": "2022-12-15T14:45:19.4208364+07:00"
  };
  var _logoutStatus = '';

  var _dataDecode = [];

  @override
  void initState() {
    _storeDtoRepository = StoreDtoRepository();
    decodeData();
    super.initState();
  }

  decodeData() {
    _dataDecode = jsonDecode(jsonEncode(data))['data'];
  }

  DateTime? currentBackPressTime;

  _handleWillPop() async {
    final now = DateTime.now();
    final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
        currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > const Duration(seconds: 2);

    if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
      currentBackPressTime = now;
      Get.snackbar(
        'Thông báo',
        'Nhấn lần nữa để thoát',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        snackStyle: SnackStyle.FLOATING,
        animationDuration: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 2),
        icon: const Icon(
          Icons.info,
          color: Colors.white,
        ),
        mainButton: TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      );
      return false;
    }
    SystemNavigator.pop();
    return null;
  }

  _handleLogout() {
    _logoutStatus = '';
    // GetSnackBar(
    //   ).show();

    Get.snackbar(
      'Thông báo',
      'Đang đăng xuất',
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      snackStyle: SnackStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      progressIndicatorValueColor:
          const AlwaysStoppedAnimation<Color>(Colors.green),
      mainButton: TextButton(
        onPressed: () {
          _logoutStatus = 'CANCEL';
          Get.back();
        },
        child: const Text("Huỷ", style: TextStyle(color: Colors.white)),
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
      snackbarStatus: (status) {
        if (status == SnackbarStatus.CLOSED && _logoutStatus != 'CANCEL') {
          Get.offAllNamed(AuthScreen.routeName);
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lựa chọn chi nhánh'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => decodeData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
          ),
          //Quay lại đăng nhập
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
        //No back icon
        automaticallyImplyLeading: false,
      ),
      //ListView
      body: WillPopScope(
        onWillPop: () => _handleWillPop(),
        child: SafeArea(
          child: _listView(context, _dataDecode),
        ),
      ),
    );
  }

  _listView(BuildContext context, List<dynamic> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _listTile(context, data[index]);
      },
    );
  }

  _listTile(BuildContext context, data) {
    var item = data;
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding / 2.5),
        child: ListTile(
          onTap: () => {
            Get.toNamed(CheckSheetProductsScreen.routeName,
                arguments: item['id']),
          },
          key: ValueKey(item['id']),
          style: ListTileStyle.list,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: RichText(
            text: TextSpan(
              text: item['branchName'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: ' - ${item['contactNumber']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item['address']}${item['wardName'] != '' ? ", " + item['wardName'] : ""}, ${item['locationName']}',
                style: TextStyle(
                  fontSize: 14,
                  color: kPrimaryColor.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
