import 'package:flutter/material.dart';
import 'package:imc_flutter/shared/constants.dart';
import 'package:imc_flutter/shared/layout/theme.dart';
import 'package:intl/intl.dart';

class CustomAppHeader extends StatelessWidget {
  const CustomAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd(Constants.appLocale).format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                Constants.appTitle,
                style: headingStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
