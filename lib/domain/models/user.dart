class User {
  User({
    this.id,
    required this.school,
    required this.grade,
    required this.birthdate,
    required this.email,
  });

  int? id;
  String school;
  String grade;
  String birthdate;
  String email;

  String get info => '$school $grade';

  String get emailAddress => email;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        school: json["school"]??"someschool",
        grade: json["grade"]?? "somegrade",
        birthdate: json["birthdate"]?? "somebirthdate",
        email: json["email"] ?? "someemail",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "school": school,
        "grade": grade,
        "birthdate": birthdate,
        "email": email,
      };
}
