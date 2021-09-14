class Contact {
  int id;
  String name;
  String num;
  String num2;

  Contact({this.name, this.num, this.num2});
  Contact.withId({this.id, this.name, this.num, this.num2});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["num"] = num;
    map["num2"] = num2;
    return map;
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact.withId(
      id: map["id"],
      name: map["name"],
      num: map["num"],
      num2: map["num2"],
    );
  }
}
