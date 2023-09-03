import "package:flutter/material.dart";
import "package:imc_flutter/exceptions/database.exception.dart";
import "package:imc_flutter/models/imc.dart";
import "package:imc_flutter/models/response.dart";
import "package:sqflite/sqflite.dart";

class DBHelper {
  static Database? _database;
  static const int _version = 1;
  static const String _tablename = "imc";

  static Future<void> init() async {
    if (_database != null) return;

    try {
      String path = "${await getDatabasesPath()}imc.db";
      //await deleteDatabase(path);

      _database = await openDatabase(path, version: _version,
          onCreate: (Database db, int version) {
        return db.execute(
          """
            CREATE TABLE $_tablename 
              (id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, height REAL, weight REAL, imc_value REAL, measured_at TEXT, created_at TEXT CURRENT_TIMESTAMP, updated_at TEXT CURRENT_TIMESTAMP, active INTEGER)
          """,
        );
      });
    } catch (e) {
      debugPrint("Erro: $e");
    }
  }

  static Future<ImcResponse> insert(Imc imc) async {
    try {
      if (_database == null) throw DatabaseConnectionException();

      int id = await _database!.insert(_tablename, imc.toJson());

      return ImcResponse(
        error: false,
        data: id,
        message: "Inserido com sucesso.",
        title: "Sucesso",
      );
    } on DatabaseConnectionException catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    } catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    }
  }

  static Future<ImcResponse> query(String date) async {
    try {
      if (_database == null) throw DatabaseConnectionException();

      var data = await _database!.query(_tablename,
          where: "measured_at=?", whereArgs: [date], orderBy: "id DESC");

      return ImcResponse(
        error: false,
        data: data,
        message: "O Item CADASTRADO com sucesso.",
        title: "Sucesso",
      );
    } on DatabaseConnectionException catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    } catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    }
  }

  static Future<ImcResponse> delete(Imc imc) async {
    try {
      if (_database == null) throw DatabaseConnectionException();

      int id = await _database!
          .delete(_tablename, where: "id=?", whereArgs: [imc.id]);

      return ImcResponse(
        error: false,
        data: id,
        message: "O Item #${imc.id} foi REMOVIDO com sucesso.",
        title: "Sucesso",
      );
    } on DatabaseConnectionException catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    } catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    }
  }

  static Future<ImcResponse> update(Imc imc) async {
    try {
      if (_database == null) throw DatabaseConnectionException();

      int id = await _database!.update(
        _tablename,
        imc.toJson(),
        where: "id=?",
        whereArgs: [imc.id],
      );
      return ImcResponse(
        error: false,
        data: id,
        message: "O Item #${imc.id} foi ATUALIZADO com sucesso.",
        title: "Sucesso",
      );
    } on DatabaseConnectionException catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    } catch (e) {
      debugPrint("Database error: $e");
      return ImcResponse(
        error: true,
        data: null,
        message: e.toString(),
        title: "Erro",
      );
    }
  }
}
