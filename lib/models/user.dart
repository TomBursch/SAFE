class User {
  String id;
  String name;
  String email;
  String picture;

  User({this.id = "", this.name = "", this.email = "", this.picture = ""});

  factory User.fromJson(Map<String, dynamic> source) {
    return User(
      id: source["_id"],
      email: source["email"],
      name: source["name"],
      picture: source["picture"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "email": email,
        "name": name,
        "picture": picture,
      };
}
