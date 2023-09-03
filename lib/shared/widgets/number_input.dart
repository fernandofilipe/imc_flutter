import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:imc_flutter/shared/layout/theme.dart';

class NumberInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? value;
  final Function()? onChanged;
  final String? error;
  final Widget? icon;
  final bool disabled;
  final bool allowDecimal;
  final String? regex;

  const NumberInput({
    super.key,
    this.controller,
    this.hint,
    this.value,
    this.onChanged,
    this.error,
    this.icon,
    this.disabled = false,
    this.allowDecimal = true,
    this.regex = r'[0-9]+[,.]{0,1}[0-9]*',
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: value,
      onChanged: onChanged as void Function(String)?,
      readOnly: disabled,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(_getRegexString())),
        TextInputFormatter.withFunction(
          (oldValue, newValue) => newValue.copyWith(
            text: newValue.text.replaceAll('.', ','),
          ),
        ),
      ],
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: subTitleStyle,
        errorText: error,
        icon: icon,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: context.theme.colorScheme.background,
            width: 0,
          ),
        ),
      ),
    );
  }

  String _getRegexString() => allowDecimal ? regex! : r'[0-9]';
}
