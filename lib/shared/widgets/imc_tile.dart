import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imc_flutter/models/imc.dart';

class ImcTile extends StatelessWidget {
  final Imc? imc;
  const ImcTile({super.key, this.imc});

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
          color: imc!.color,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(
              color: Colors.white,
            ),
            Row(
              children: [
                _buildMeasurementsBox(
                  "Altura",
                  "m",
                  imc!.height.toStringAsFixed(2),
                  Icons.design_services_outlined,
                ),
                _buildMeasurementsBox(
                  "Peso",
                  "kg",
                  imc!.weight.toStringAsFixed(1),
                  Icons.fitness_center_outlined,
                ),
                _buildMeasurementsBox(
                  "IMC",
                  "",
                  imc!.imcValue.toStringAsFixed(2),
                  Icons.balance,
                ),
                _buildVerticalLine(),
                _buildVerticalBox(),
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
          Icons.person_outline_sharp,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          "#${imc!.id} - ${imc!.user}",
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        const Icon(
          Icons.calendar_month,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          imc!.measuredAt ?? "",
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  _buildMeasurementsBox(String title, String unitOfmeasurement,
      String measurement, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(
            height: 12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.grey[200],
                size: 18,
              ),
              const SizedBox(
                width: 6,
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
      ),
    );
  }

  _buildVerticalLine() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      width: 0.5,
      color: Colors.grey[200]!.withOpacity(0.7),
    );
  }

  _buildVerticalBox() {
    return RotatedBox(
      quarterTurns: 3,
      child: Text(
        imc!.classification,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
