class Profile {
  String id;
  String organizationId;
  String firstName;
  String lastName;
  int permissionLevel;
  int score;
  String createdAt;
  String updatedAt;

  Profile(
      {this.id,
      this.organizationId,
      this.firstName,
      this.lastName,
      this.permissionLevel,
      this.score,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationId = json['organization_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    permissionLevel = json['permission_level'];
    score = json['score'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_id'] = this.organizationId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['permission_level'] = this.permissionLevel;
    data['score'] = this.score;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}