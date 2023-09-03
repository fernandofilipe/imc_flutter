import 'package:flutter/material.dart';

class AppColors {
  static const Color bluishClr = Color(0xFF4e5ae8); // Laranja adequado
  static const Color yellowClr = Color(0xFFFFb746); // Cor de destaque
  static const Color pinkClr = Color(0xFFFF4667); // Cor de destaque
  static const Color white = Colors.white; // Cor de destaque
  static const Color primaryClr = bluishClr; // Cor de destaque
  static const Color darkGreyClr = Color(0xFF121212); // Cor de destaque
  static const Color darkHeaderClr = Color(0xFF424242); // Cor de destaque

  // Cores para indicar faixas de IMC
  static const Color lightUnderweightColor =
      Color.fromARGB(255, 236, 191, 55); // Abaixo do peso
  static const Color underweightColor = Color(0xFFE57373); // Abaixo do peso
  static const Color normalWeightColor = Colors.green; // Peso normal
  static const Color overweightColor = yellowClr; // Sobrepeso
  static const Color obesityColor = pinkClr; // Obesidade

  // Cores de texto
  static const Color textColor = Color(0xFF333333); // Cor do texto principal
  static const Color resultTextColor =
      Color(0xFF4CAF50); // Cor do texto de resultado

  static const Color primaryLightColor = Colors.cyan;
  static const Color primaryDarkColor = Colors.deepPurple;

  //botões
  static const Color buttonPrimaryLightColor =
      primaryLightColor; // Cor do texto principal
  static const Color buttonPrimaryDarkColor =
      primaryDarkColor; // Cor do texto principal

  // Cor de fundo
  static const Color backgroundColor = Color(0xFFF5F5F5); // Cor de fundo
}
