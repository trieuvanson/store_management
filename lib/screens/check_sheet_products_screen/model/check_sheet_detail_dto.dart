import '/screens/check_sheet_products_screen/model/product_dto.dart';

class CheckSheetDetailDTO {
  int? id;
  ProductDTO? product;
  double quantityCurrent = 0;
  double price = 0;


  CheckSheetDetailDTO({this.id, this.product, this.quantityCurrent = 0, this.price = 0});

  factory CheckSheetDetailDTO.fromJson(Map<String, dynamic> json) {
    return CheckSheetDetailDTO(
      id: json['id'],
      product: ProductDTO.fromJson(json['product']),
      quantityCurrent: json['quantityCurrent'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productAPI': product!.toJson(),
      'quantityCurrent': quantityCurrent,
      'price': price,
    };
  }

}