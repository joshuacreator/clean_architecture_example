class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserEntity &&
        other.id == id &&
        other.email == email &&
        other.name == name &&
        other.profileImageUrl == profileImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        profileImageUrl.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, email: $email, name: $name, profileImageUrl: $profileImageUrl)';
  }
}
