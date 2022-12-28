import 'dart:convert';

import 'package:store_management/repositories/abstract_repository.dart';
import 'package:store_management/screens/home_screen/model/store_dto.dart';

import '../../../repositories/abstract_interface.dart';

class StoreDtoRepository extends AbstractRepository
    implements AbstractInterface<double, ChooseStoreDTO> {
  final String storeDtoUrl = "/storeDto";

  // Get all storeDto
  @override
  Future<List<ChooseStoreDTO>> getAll() async {
    try {
      final response = await get(url: storeDtoUrl);
      return (response.data['data'] as List)
          .map((e) => ChooseStoreDTO.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get storeDto by id
  @override
  Future<ChooseStoreDTO> getOne(double id) async {
    try {
      final response = await get(url: "$storeDtoUrl/$id");
      return ChooseStoreDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Create storeDto
  @override
  Future<ChooseStoreDTO> create(ChooseStoreDTO storeDto) async {
    try {
      final response = await post(url: storeDtoUrl, data: storeDto.toJson());
      return ChooseStoreDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Update storeDto
  @override
  Future<ChooseStoreDTO> update(ChooseStoreDTO storeDto) async {
    try {
      final response = await put(
          url: "$storeDtoUrl/${storeDto.id}", data: storeDto.toJson());
      return ChooseStoreDTO.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Delete storeDto
  @override
  Future<void> delete(ChooseStoreDTO storeDto) async {
    try {
      await deleteHttp(url: "$storeDtoUrl/${storeDto.id}");
    } catch (e) {
      rethrow;
    }
  }
}
