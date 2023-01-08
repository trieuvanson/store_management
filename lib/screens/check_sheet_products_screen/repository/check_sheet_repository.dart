import 'dart:convert';

import 'package:store_management/repositories/abstract_interface.dart';
import 'package:store_management/repositories/abstract_repository.dart';
import 'package:store_management/screens/check_sheet_products_screen/model/check_sheet_dto.dart';

import '../../../utils/date_utils.dart';
import '../../../utils/secure_storage.dart';
import '../model/check_sheet_detail_dto.dart';
import '../model/product_dto.dart';

class CheckSheetRepository extends AbstractRepository
    implements AbstractInterface<double, CheckSheetDTO> {
  final String _finalUrl = '/data/kiemKhos';

  @override
  Future<CheckSheetDTO> create(CheckSheetDTO storeDto) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(CheckSheetDTO storeDto) {
    //  TODO: implement delete
    throw UnimplementedError();
  }

  Future<CheckSheetDtoResponse> getAllBy(
      {required int branchId,
      required int pageIndex,
      required int pageSize,
      String? date}) async {
    try {
      final auth = await secureStorage.readAuth();
      var response = await get(
        url: _finalUrl,
        token: auth!.accessToken,
        queryParameters: {
          'branchId': branchId,
          'pageIndex': pageIndex,
          'pageSize': pageSize,
          if (date != null) 'date': date
        },
      );
      return CheckSheetDtoResponse.fromJson(response.data!);
    } catch (e) {
      throw e;
    }
  }

  Future<List<ProductDTO>> getCheckSheetDetail(
      {required int branchId,
      required int pageIndex,
      required int pageSize,
      int? checkSheetId}) async {
    try {
      final auth = await secureStorage.readAuth();
      var response = await get(
        url: '/data/kiemKhoDetails/kiemKhoId/$checkSheetId',
        token: auth!.accessToken,
        queryParameters: {
          'branchId': branchId,
          'pageIndex': pageIndex,
          'pageSize': pageSize,
        },
      );
      List<ProductDTO> returnList = (response.data!['data'] as List)
          .map((e) => ProductDTO.fromJson(e['productAPI']))
          .toList();
      return returnList;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<List<CheckSheetDTO>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<CheckSheetDTO> getOne(double id) {
    // TODO: implement getOne
    throw UnimplementedError();
  }

  Future<dynamic> createWithBody(
      {String? date,
      required List<ProductDTO> products,
      required int branchId}) async {
    try {
      final auth = await secureStorage.readAuth();
      var checkSheets = [];
      for (var product in products) {
        CheckSheetDetailDTO checkSheetDetailDTO = CheckSheetDetailDTO();
        checkSheetDetailDTO.product = product;
        checkSheets.add(checkSheetDetailDTO.toJson());
      }

      Map<String, dynamic> map = {
        "date": date,
        "kiemKhoDetailAPIs": checkSheets
      };
      var response = await post(
        url: _finalUrl,
        token: auth!.accessToken,
        branchId: branchId,
        data: jsonEncode(map),
      );

      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> updateWithBody(
      {String? date,
      required List<ProductDTO> products,
      required int branchId,
      required int checkSheetId}) async {
    try {
      final auth = await secureStorage.readAuth();
      var checkSheets = [];
      for (var product in products) {
        CheckSheetDetailDTO checkSheetDetailDTO = CheckSheetDetailDTO();
        checkSheetDetailDTO.product = product;
        checkSheets.add(checkSheetDetailDTO.toJson());
      }

      Map<String, dynamic> map = {
        "id": checkSheetId,
        "date": date,
        "kiemKhoDetailAPIs": checkSheets
      };
      var response = await put(
        url: "$_finalUrl/id/$checkSheetId",
        token: auth!.accessToken,
        branchId: branchId,
        data: jsonEncode(map),
      );

      return response.data;
    } catch (e) {
      throw e;
    }
  }

  Future<String?> deleteCustom({required Map<String, dynamic> queries}) async {
    try {
      final auth = await secureStorage.readAuth();
      var response = await deleteHttp(
        url: "$_finalUrl/id/${queries['checkSheetId']}",
        token: auth!.accessToken,
      );
      if (response.statusCode == 200) {
        return response.data['msg'];
      }
    } catch (e) {
      throw e;
    }
    return null;
  }

  @override
  Future<CheckSheetDTO> update(CheckSheetDTO storeDto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
