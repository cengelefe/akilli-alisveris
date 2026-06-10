class UserProfile {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String language;
  final bool notificationsEnabled;

  UserProfile({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.language = 'tr',
    this.notificationsEnabled = true,
  });

  UserProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? language,
    bool? notificationsEnabled,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'password': password,
      'language': language,
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      language: (map['language'] as String?) ?? 'tr',
      notificationsEnabled: (map['notificationsEnabled'] as int? ?? 1) == 1,
    );
  }
}
