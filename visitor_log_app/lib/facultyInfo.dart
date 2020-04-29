class FacultyInfo {
  final String name;
  final String id;
  final String email;
  final String username;

  FacultyInfo({this.name, this.id, this.email, this.username});

  factory FacultyInfo.fromJson(Map<String, dynamic> parsedJson) {
    return FacultyInfo(
        name: parsedJson['name'],
        id: parsedJson['id'],
        email: parsedJson['email'],
        username: parsedJson['username']);
  }
}
