class AdminModel {
  String? adminName;
  String? adminUid;
  String? adminUserName;
  String? password;

  AdminModel({
    this.adminName,
    this.adminUid,
    this.adminUserName,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'adminUid': adminUid,
      'adminName': adminName,
      'adminUserName': adminUserName,
      'password': password,
    };
  }

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      adminName: map['Name'],
      adminUid: map['id'],
      password: map['passWord'],
      adminUserName: map['userName'],
    );
  }

  @override
  String toString() {
    return 'AdminModel('
        'adminUid: $adminUid, '
        'adminName: $adminName, '
        'adminUserName: $adminUserName, '
        'password: $password, '
        ')';
  }
}
