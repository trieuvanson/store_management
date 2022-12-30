import 'dart:convert';

class Expiry {
  int? id;
  String? date;
  int? quantity;

  Expiry({this.id, this.date, this.quantity});

  factory Expiry.fromJson(Map<String, dynamic> json) {
    return Expiry(
      id: json['id'],
      date: json['date'],
      quantity: json['quantity']??0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'quantity': quantity,
    };
  }
}

class ProductResponse {
  ProductResponse({
    this.totalRecord,
    this.pageIndex,
    this.pageSize,
    this.data,
  });

  int? totalRecord;
  int? pageIndex;
  int? pageSize;
  List<ProductDTO>? data;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        totalRecord: json["totalRecord"],
        pageIndex: json["pageIndex"],
        pageSize: json["pageSize"],
        data: json['data'] != null
            ? (json['data'] as List)
            .map((e) => ProductDTO.fromJson(e))
            .toList()
            : null,
      );

  Map<String, dynamic> toMap() => {
        "totalRecord": totalRecord,
        "pageIndex": pageIndex,
        "pageSize": pageSize,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ProductDTO {
  int? id;
  String? code;
  String? name;
  double? price;
  double? inventory;
  double inventoryCurrent;
  String image;
  List<Expiry>? expires;

  ProductDTO({
    this.id,
    this.code,
    this.name,
    this.price,
    this.inventory,
    this.inventoryCurrent = 0.0,
    this.image = '',
    this.expires,
  });

  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      price: json['price'],
      inventory: json['inventory'],
      inventoryCurrent: json['inventoryCurrent'],
      image: json['image'],
      expires: json['hanSuDungAPIs'] != null
          ? (json['hanSuDungAPIs'] as List)
              .map((e) => Expiry.fromJson(e))
              .toList()
          : [],
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'price': price,
      'inventory': inventory,
      'inventoryCurrent': inventoryCurrent,
      'image': image,
      'hanSuDungAPIs': expires == null
          ? null
          : List<dynamic>.from(expires!.map((x) => x.toJson())),
    };
  }

  //copyWith
  ProductDTO copyWith({
    int? id,
    String? code,
    String? name,
    double? price,
    double? inventory,
    double? inventoryCurrent,
    String? image,
    List<Expiry>? expires,
  }) {
    return ProductDTO(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
      inventory: inventory ?? this.inventory,
      inventoryCurrent: inventoryCurrent ?? this.inventoryCurrent,
      image: image ?? this.image,
      expires: expires ?? this.expires,
    );
  }

  //toString
  @override
  String toString() {
    return 'ProductDTO{id: $id, code: $code, name: $name, price: $price, inventory: $inventory, expires: $expires}';
  }
}
