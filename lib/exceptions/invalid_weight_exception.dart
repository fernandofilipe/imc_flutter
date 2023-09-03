class InvalidWeightException implements Exception {
  String error() => "Peso invalido!";

  @override
  String toString() => "InvalidWeightException: ${error()}";
}
