class User {
  int? id;            String? fullname;
  String? email;      String? phone;
  String? username;   String? password;
  String? picture;

  User({
    this.id,          this.fullname,
    this.email,       this.phone,
    this.username,    this.password,
    this.picture,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'],                   fullname: data['fullname'],
      email: data['email'],             phone: data['phone'],
      username: data['username'],       password: data['password'],
      picture: data['picture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,                   'fullname': fullname,
      'email': email,             'phone': phone,
      'username': username,       'password': password,
      'picture': picture,
    };
  }
}
