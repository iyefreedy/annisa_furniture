import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoundedTextField extends StatefulWidget {
  const RoundedTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.prefixText,
    this.textStyle,
    this.textAlign,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final Icon? prefixIcon;
  final bool obscureText;
  final TextInputType? textInputType;
  final String? prefixText;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.85,
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        autocorrect: false,
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: widget.textInputType,
        obscureText: widget.obscureText && !_isVisible,
        textAlign: widget.textAlign ?? TextAlign.start,
        style: widget.textStyle ??
            TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
        inputFormatters: widget.textInputType != null &&
                widget.textInputType == TextInputType.number
            ? [
                LengthLimitingTextInputFormatter(12),
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        decoration: InputDecoration(
            isDense: true,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            prefixText:
                widget.prefixText != null ? '${widget.prefixText} ' : null,
            prefixStyle: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(999)),
            suffixIcon: widget.obscureText
                ? InkWell(
                    child: Icon(
                        !_isVisible ? Icons.visibility : Icons.visibility_off),
                    onTap: () {
                      setState(
                        () {
                          _isVisible = !_isVisible;
                        },
                      );
                    },
                  )
                : null),
      ),
    );
  }
}
