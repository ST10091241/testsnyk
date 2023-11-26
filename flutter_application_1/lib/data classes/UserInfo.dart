class UsersInfo {
  final String? name;
  final String? surname;
  final String? phoneNumber;
  final String? emailAddress; 
  final String usertype;

  UsersInfo({
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.emailAddress,
    this.usertype = 'customer',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'usertype': usertype,
    };
  }
  factory UsersInfo.fromJson(Map<String, dynamic> json) {
    return UsersInfo(
      name: json['name'],
      surname: json['surname'],
      phoneNumber: json['phoneNumber'],
      emailAddress: json['emailAddress'],
      usertype: json['usertype'],
    );
  }
}


