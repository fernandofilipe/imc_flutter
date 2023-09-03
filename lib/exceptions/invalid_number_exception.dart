class InvalidNumberException implements Exception {
  String error() => "Número inválido!";

  @override
  String toString() => "InvalidNumberException: ${error()}";
}
