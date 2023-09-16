import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime selectedDate;
  final DatePickerController? controller;
  final Function(DateTime)? onDateChanged;
  const CustomDatePicker(
      {super.key,
      required this.startDate,
      required this.selectedDate,
      this.controller,
      this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    return DatePicker(
      startDate,
      initialSelectedDate: selectedDate,
      controller: controller,
      daysCount: _calculateDays(startDate) + 1,
      height: 100,
      width: 80,
      locale: Intl.defaultLocale ?? Constants.appLocale,
      selectionColor: Theme.of(context).colorScheme.inversePrimary,
      selectedTextColor: Colors.white,
      dateTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
      dayTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
      monthTextStyle: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
      onDateChange: onDateChanged,
    );
  }

  int _calculateDays(var startDate) {
    final today = DateTime.now();
    final difference = today.difference(startDate).inDays;
    return difference;
  }
}
