class HttpException implements Exception {
  final String message;

  HttpException([this.message]);

  String toString() {
    var message = this.message;
    if (message == null) return "Exception";
    return "Exception: $message";
  }
}
