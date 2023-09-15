class User {
  final int userId;
  final int clientId;
  final int roleId;
  final String firstName;
  final String email;
  final int isOffer;
  final int isEnabled;
  final int isAgreed;
  final String lastActivity;
  final int parentId;
  final String createdAt;
  final String updatedAt;

  User({
    required this.userId,
    required this.clientId,
    required this.roleId,
    required this.firstName,
    required this.email,
    required this.isOffer,
    required this.isEnabled,
    required this.isAgreed,
    required this.lastActivity,
    required this.parentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      clientId: json['client_id'],
      roleId: json['role_id'],
      firstName: json['first_name'],
      email: json['email'],
      isOffer: json['is_offer'],
      isEnabled: json['is_enabled'],
      isAgreed: json['is_agreed'],
      lastActivity: json['last_activity'],
      parentId: json['parent_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
