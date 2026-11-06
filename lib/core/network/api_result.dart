abstract class ApiResult<T> {}

class Success<T> extends ApiResult<T> {
  final T data;

  Success(this.data);
}

class Failure<T> extends ApiResult<T> {
  final String message;

  Failure(this.message);
}
