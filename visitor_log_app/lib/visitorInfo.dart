class VisitorInfo {
  final String visitorName;
  final String address;
  final String gender;
  final String contactNumber;
  final String description;
  final String email;

  VisitorInfo(
      {this.visitorName,
      this.address,
      this.gender,
      this.contactNumber,
      this.description,
      this.email});

  Map toJson() {
    List<String> names = visitorName.split(" ");
    var map = new Map<String, dynamic>();
    map["firstName"] = names[0];
    map["lastName"] = (names[1] == null) ? "" : names[1];
    map["address"] = address;
    map["gender"] = gender;
    map["contact"] = contactNumber;
    map["description"] = description;
    map["email"] = email;

    return map;
  }
}
