class DatabaseConnectionException implements Exception {
  String error() => "Erro ao tentar conectar no banco de dados!";

  @override
  String toString() => "DatabaseConnectionException: ${error()}";
}
