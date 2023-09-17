
class UserModel {
     var email;
     var uid;
     var password;
     var name;
     var url;
  UserModel({
    required this.email,
    required this.uid,
    required this.password,
    required this.name,
    required this.url,
  });

  // Factory method to create a User instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      uid: json['uid'],
      password: json['password'],
      name: json['name'],
      url: json['profileimageurl']
    );
  }

  // Convert the User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'uid': uid,
      'password': password,
      'name': name,
      'profileimageurl':url
    };
  }






}