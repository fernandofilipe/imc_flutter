import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imc_flutter/models/user.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:intl/intl.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Get.isDarkMode ? Colors.deepPurple : Colors.lightBlue,
        ),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMeasurementsBox(
                  "Altura",
                  "m",
                  user.height.toStringAsFixed(2),
                  Icons.design_services_outlined,
                ),
                _buildMeasurementsBox(
                  "Criado",
                  "",
                  DateFormat.yMd(Constants.appLocale)
                      .format(DateTime.parse(user.createdAt.toString())),
                  Icons.calendar_month_outlined,
                ),
                _buildMeasurementsBox(
                  "Atualizado",
                  "",
                  DateFormat.yMd(Constants.appLocale)
                      .format(DateTime.parse(user.updatedAt.toString())),
                  Icons.calendar_month_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildHeader() {
    return Row(
      children: [
        const Icon(
          Icons.person_pin_rounded,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          user.name,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Text(
          "${user.id}",
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        const Icon(
          Icons.key_outlined,
          color: Colors.white,
          size: 20,
        ),
      ],
    );
  }

  _buildMeasurementsBox(String title, String unitOfmeasurement,
      String measurement, IconData icon) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.grey[200],
              size: 18,
            ),
            Text(
              "$measurement $unitOfmeasurement",
              style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.grey[200],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
