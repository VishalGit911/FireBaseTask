class Address {
  String id;
  String address;
  String addressLine1;
  String addressLine2;
  String city;
  String pinCode;
  String state;

  Address({
    this.id = '',
    required this.address,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.pinCode,
    required this.state,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'address': address,
    'addressLine1': addressLine1,
    'addressLine2': addressLine2,
    'city': city,
    'pincode': pinCode,
    'state': state,
  };

  static Address fromJson(dynamic json) => Address(
    id: json['id'],
    address: json['address'],
    addressLine1: json['addressLine1'],
    addressLine2: json['addressLine2'],
    city: json['city'],
    pinCode: json['pincode'],
    state: json['state'],
  );
}
