import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String? text;
  const CustomElevatedButton({
    super.key,
    required this.onTap,
    required this.text,
  });
  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.onTap,
        child: Text(
          widget.text.toString(),
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ));
  }
}
