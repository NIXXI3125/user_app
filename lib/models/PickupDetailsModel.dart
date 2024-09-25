class Pickupdetailsmodel {
  String? name = '';
  String? phoneNo = '';
  String? address = '';

  Pickupdetailsmodel({
    this.address,
    this.phoneNo,
    this.name,
  });

  factory Pickupdetailsmodel.fromMap(Map<String, dynamic> map) {
    return Pickupdetailsmodel(
      name: map['name'],
      phoneNo: map['phoneNo'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNo': phoneNo,
      'address': address,
    };
  }
}
