class InvalidClassException implements Exception {
  String error() =>
      "Esta objeto não possui os métodos necessários para executar operações no banco de dados!";

  @override
  String toString() => "InvalidClassException: ${error()}";
}
