import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_management/utils/utils.dart';

import '../../../constants/contains.dart';
import '../../screens.dart';

class ChooseStoreScreen extends StatefulWidget {
  static const String routeName = '/choose-store-screen';

  const ChooseStoreScreen({Key? key}) : super(key: key);

  @override
  State<ChooseStoreScreen> createState() => _ChooseStoreScreenState();
}

class _ChooseStoreScreenState extends State<ChooseStoreScreen> {

  DateTime? currentBackPressTime;

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
        "id": 392899,
        "branchName": "KHO BẾP BÁNH",
        "address": "141",
        "locationName": "Kiên Giang - Huyện Phú Quốc",
        "wardName": "Thị trấn Dương Đông",
        "contactNumber": "0915794238",
        "retailerId": 107783,
        "createdDate": "2022-01-19T12:53:10.0130000"
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

  var _dataDecode = [];

  @override
  void initState() {
    decodeData();
    super.initState();
  }

  decodeData() {
    _dataDecode = jsonDecode(jsonEncode(data))['data'];
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
            onPressed: () => {},
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
          ),
          //Quay lại đăng nhập
          IconButton(
            onPressed: () => Get.offAllNamed(AuthScreen.routeName),
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
          ),
        ],
        //No back icon
        automaticallyImplyLeading: false,

      ),
      //ListView
      body: WillPopScope(
        onWillPop: () => handleWillPop(currentBackPressTime, context),
        child: SafeArea(
          child: ListView.builder(
            itemCount: _dataDecode.length,
            itemBuilder: (context, index) {
              var item = _dataDecode[index];
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
                    onTap: () => Get.toNamed(CheckSheetProductsScreen.routeName),
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
            },
          ),
        ),
      ),
    );
  }
}
