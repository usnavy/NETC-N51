class Album {
  final String email;
  final String password;

  const Album({required this.email, required this.password});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      email: json['email'],
      password: json['password'],
    );
  }
}