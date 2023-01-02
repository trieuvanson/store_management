import 'dart:convert';

import '/repositories/abstract_interface.dart';
import '/repositories/abstract_repository.dart';
import '/screens/check_sheet_products_screen/model/check_sheet_dto.dart';

import '../../../utils/secure_storage.dart';
import '../model/check_sheet_detail_dto.dart';

class CheckSheetRepository extends AbstractRepository implements AbstractInterface<double, CheckSheetDTO> {

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
      {required int branchId, required int pageIndex, required int pageSize, String? date}) async {
    try {
      final auth = await secureStorage.readAuth();
      var response = await get(url:_finalUrl, token: auth!.accessToken,
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
  Future<dynamic> createWithBody({required String date, required List<CheckSheetDetailDTO> checkSheetDetails, required int branchId}) async {
    try {
      final auth = secureStorage.readAuth();
      var data = {
        "date": date,
        "kiemKhoDetailAPIs": []
      };


    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> updateWithBody({required String date, required List<CheckSheetDetailDTO> checkSheetDetails, required int branchId}) async {
    try {
      final auth = secureStorage.readAuth();


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