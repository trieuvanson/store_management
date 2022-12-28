class ChooseStoreDTO {
  int? id;
  String? branchName;
  String? address;
  String? locationName;
  String? wardName;
  String? contactNumber;
  int? retailerId;
  DateTime? modifiedDate;
  DateTime? createdDate;

  ChooseStoreDTO({
    this.id,
    this.branchName,
    this.address,
    this.locationName,
    this.wardName,
    this.contactNumber,
    this.retailerId,
    this.modifiedDate,
    this.createdDate,
  });

  factory ChooseStoreDTO.fromJson(Map<String, dynamic> json) {
    return ChooseStoreDTO(
      id: json['id'],
      branchName: json['branchName'],
      address: json['address'],
      locationName: json['locationName'],
      wardName: json['wardName'],
      contactNumber: json['contactNumber'],
      retailerId: json['retailerId'],
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'])
          : null,
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchName': branchName,
      'address': address,
      'locationName': locationName,
      'wardName': wardName,
      'contactNumber': contactNumber,
      'retailerId': retailerId,
      'modifiedDate': modifiedDate,
      'createdDate': createdDate,
    };
  }

  @override
  String toString() {
    return 'Branch{id: $id, branchName: $branchName, address: $address, locationName: $locationName, wardName: $wardName, contactNumber: $contactNumber, retailerId: $retailerId, modifiedDate: $modifiedDate, createdDate: $createdDate}';
  }

  ChooseStoreDTO copyWith({
    int? id,
    String? branchName,
    String? address,
    String? locationName,
    String? wardName,
    String? contactNumber,
    int? retailerId,
    DateTime? modifiedDate,
    DateTime? createdDate,
  }) {
    return ChooseStoreDTO(
      id: id ?? this.id,
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      locationName: locationName ?? this.locationName,
      wardName: wardName ?? this.wardName,
      contactNumber: contactNumber ?? this.contactNumber,
      retailerId: retailerId ?? this.retailerId,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChooseStoreDTO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          branchName == other.branchName &&
          address == other.address &&
          locationName == other.locationName &&
          wardName == other.wardName &&
          contactNumber == other.contactNumber &&
          retailerId == other.retailerId &&
          modifiedDate == other.modifiedDate &&
          createdDate == other.createdDate;

  @override
  int get hashCode =>
      id.hashCode ^
      branchName.hashCode ^
      address.hashCode ^
      locationName.hashCode ^
      wardName.hashCode ^
      contactNumber.hashCode ^
      retailerId.hashCode ^
      modifiedDate.hashCode ^
      createdDate.hashCode;
}
