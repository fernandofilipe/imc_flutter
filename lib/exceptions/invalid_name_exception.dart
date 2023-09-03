class InvalidNameException implements Exception {
  String error() => "Nome inválido!";

  @override
  String toString() => "InvalidNameException: ${error()}";
}
