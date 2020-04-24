class Faculty {
  final String name;
  final String designation;
  final String email;

  Faculty({this.name, this.designation, this.email});

  factory Faculty.fromJson(Map <String, dynamic> json) {
    return Faculty(
      name: json['name'],
      designation: json['designation'],
      email: json['email'],
    );
  }
}