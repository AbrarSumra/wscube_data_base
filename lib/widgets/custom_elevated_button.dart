import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? text;
  const CustomElevatedButton({
    super.key,
    required this.onTap,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        child: Text(
          text.toString(),
          style: const TextStyle(fontSize: 22, color: Colors.white),
        ));
  }
}
