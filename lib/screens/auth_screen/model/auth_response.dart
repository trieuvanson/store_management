class AuthResponse {
  String? accessToken;
  int? expiresIn;
  String? tokenType;
  String? message;

  AuthResponse({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'expires_in': expiresIn,
      'token_type': tokenType,
    };
  }

  @override
  String toString() {
    return 'AuthResponse{accessToken: $accessToken, expiresIn: $expiresIn, tokenType: $tokenType}';
  }
}