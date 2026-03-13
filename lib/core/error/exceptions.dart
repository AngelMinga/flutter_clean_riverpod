abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  AppException(this.message, [this.stackTrace]);
}

class ServerException extends AppException {
  ServerException(String message, [StackTrace? stackTrace]) : super(message, stackTrace);
}

class CacheException extends AppException {
  CacheException(String message, [StackTrace? stackTrace]) : super(message, stackTrace);
}
