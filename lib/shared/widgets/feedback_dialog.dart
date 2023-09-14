import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/models/response.dart';
import 'package:imc_flutter/shared/layout/theme.dart';

class FeedBackDialog extends StatelessWidget {
  final GeneralResponse response;
  const FeedBackDialog({super.key, required this.response});
  final textMaxLines = 10;

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.labelLarge;
    return AlertDialog(
      content: Wrap(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Icon(response.error ? Icons.warning_amber : Icons.check),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    response.title,
                    style: subHeadingStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      response.message,
                      maxLines: textMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
            textStyle: textStyle,
          ),
          child: const Text("Fechar"),
        ),
      ],
    );
  }
}
