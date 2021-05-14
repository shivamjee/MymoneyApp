class httpException implements Exception
{
  final String message;
  httpException(this.message);
  String toString()
  {
    return message;
  }
}