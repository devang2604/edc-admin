import 'package:flutter/material.dart';
import 'package:vp_admin/utils/validators.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.maxLenth,
    this.maxLines,
  });
  final String? label;
  final String? hint;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLenth;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            labelText: label,
            border: const OutlineInputBorder(),
            hintText: hint),
        validator: validator ?? Validators.validateRequired,
        onSaved: onSaved,
        onChanged: onChanged,
        initialValue: initialValue,
        keyboardType: keyboardType,
        maxLength: maxLenth,
        maxLines: maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction ?? TextInputAction.next,
      ),
    );
  }
}
