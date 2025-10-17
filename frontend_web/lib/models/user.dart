import 'dart:convert';

class User {
  final int id;
  final String email;
  final String name;
  final String createdAt;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt,
    };
  }
}

class UserCreateRequest {
  final String email;
  final String password;
  final String username;

  UserCreateRequest({
    required this.email,
    required this.password,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'username': username,
    };
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class LoginResponse {
  final String token;
  final User user;

  LoginResponse({
    required this.token,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // Handle backend response format
    if (json.containsKey('data')) {
      final dataString = json['data'] as String?;
      if (dataString != null) {
        try {
          final data = Map<String, dynamic>.from(jsonDecode(dataString));
          return LoginResponse(
            token: data['token'] ?? '',
            user: User(
              id: 1, // Mock ID since backend doesn't provide it yet
              email: data['email'] ?? '',
              name: data['username'] ?? '',
              createdAt: DateTime.now().toIso8601String(),
            ),
          );
        } catch (e) {
          // Fallback if JSON parsing fails
          return LoginResponse(
            token: '',
            user: User(
              id: 1,
              email: '',
              name: '',
              createdAt: DateTime.now().toIso8601String(),
            ),
          );
        }
      }
    }
    
    // Handle direct format
    return LoginResponse(
      token: json['token'] ?? '',
      user: User.fromJson(json['user']),
    );
  }
}
