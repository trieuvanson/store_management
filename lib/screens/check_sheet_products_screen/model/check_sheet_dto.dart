import '/utils/date_utils.dart';

class CheckSheetDtoResponse {
  int? totalRecord;
  int? pageIndex;
  int? pageSize;
  List<CheckSheetDTO>? data;

  CheckSheetDtoResponse(
      {this.totalRecord, this.pageIndex, this.pageSize, this.data});

  factory CheckSheetDtoResponse.fromJson(Map<String, dynamic> json) =>
      CheckSheetDtoResponse(
        totalRecord: json['totalRecord'],
        pageIndex: json['pageIndex'],
        pageSize: json['pageSize'],
        data: json['data'] != null && json['data'] is List && json['data'].length > 0
            ? (json['data'] as List)
                .map((e) => CheckSheetDTO.fromJson(e))
                .toList()
            : [],
      );

  Map<String, dynamic> toJson() => {
        'totalRecord': totalRecord,
        'pageIndex': pageIndex,
        'pageSize': pageSize,
        'data': data,
      };
}

class CheckSheetDTO {
  int? id;
  String? code;
  String? createByCode;
  String? date;
  String? branchName;

  CheckSheetDTO(
      {this.id, this.code, this.createByCode, this.date, this.branchName});

  factory CheckSheetDTO.fromJson(Map<String, dynamic> json) {
    return CheckSheetDTO(
      id: json['id'],
      code: json['code'],
      createByCode: json['createByCode'],
      date: json['date'],
      branchName: json['branchName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'createByCode': createByCode,
        'date': date,
        'branchName': branchName,
      };
}
