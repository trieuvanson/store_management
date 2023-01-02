import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:store_management/repositories/abstract_interface.dart';
import 'package:store_management/screens/check_sheet_products_screen/model/product_dto.dart';

import '../../../repositories/abstract_repository.dart';
import '../../../utils/secure_storage.dart';

class ProductRepository extends AbstractRepository
    implements AbstractInterface<double, ProductDTO> {
  final String _finalUrl = '/data/productLixs';

  @override
  Future<ProductDTO> create(ProductDTO storeDto) {
    // TODO: implement create
    throw UnimplementedError();
  }

  Future<List<ProductDTO>> search(query,
      {required branchId, pageSize = 50, pageIndex = 1}) async {
    try {
      var url =
          "$_finalUrl/search/$query?branchId=$branchId&pageSize=$pageSize&pageIndex=$pageIndex";
      print('url: $url');
      final auth = await secureStorage.readAuth();
      var response = await get(url: url, token: auth!.accessToken);
      if (response.statusCode == 200) {
        var data = response.data;
        var res = ProductResponse.fromJson(data);
        return res.data!;
      } else {
        return Future.error(response.data['message']);
      }
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> delete(ProductDTO storeDto) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<List<ProductDTO>> getAllBy(
      int branchId, int pageIndex, int pageSize) async {
    try {
      final auth = await secureStorage.readAuth();
      final response = await get(
        url: _finalUrl,
        token: auth!.accessToken,
        queryParameters: {
          'branchId': branchId,
          'pageIndex': pageIndex,
          'pageSize': pageSize,
        },
      );
      if (response.statusCode == 200) {
        var res = ProductResponse.fromJson(response.data);
        return res.data!;
      } else {
        return Future.error("Có lỗi xảy ra vui lòng thử lại");
      }
    } catch (e) {
      rethrow;
    }
  }

  //getOneBy
  Future<ProductDTO> getOneBy(String barcode, int branchId) async {
    try {
      final auth = await secureStorage.readAuth();
      final response = await get(
        url: '$_finalUrl/code/$barcode',
        token: auth!.accessToken,
        branchId: branchId,
      );
      if (response.statusCode == 200) {
        return ProductDTO.fromJson(response.data['data']);
      } else {
        return Future.error(response.data['message']);
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
    return Future.error('Không tìm thấy sản phẩm');
  }

  @override
  Future<ProductDTO> getOne(double id) {
    // TODO: implement getOne
    throw UnimplementedError();
  }

  @override
  Future<ProductDTO> update(ProductDTO storeDto) {
    throw UnimplementedError();
  }





  Future<ProductDTO> updateWithParams(
      {required ProductDTO storeDto, required int branchId}) async {
    try {
      final auth = await secureStorage.readAuth();
      final response = await put(
        url: "$_finalUrl/id/${storeDto.id}",
        token: auth!.accessToken,
        branchId: branchId,
        data: jsonEncode((storeDto.toJson()))
      );
      if (response.statusCode == 200) {
        return ProductDTO.fromJson(response.data['data']);
      } else {
        return Future.error(response.data['message']);
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 400) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
    return Future.error('Không tìm thấy sản phẩm');
  }

  @override
  Future<List<ProductDTO>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }
}
