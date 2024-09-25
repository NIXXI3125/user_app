class Dropdetailsmodel {
  String? name = '';
  String? phoneNo = '';
  String? address = '';

  Dropdetailsmodel({
    this.address,
    this.phoneNo,
    this.name,
  });

  factory Dropdetailsmodel.fromMap(Map<String, dynamic> map) {
    return Dropdetailsmodel(
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
