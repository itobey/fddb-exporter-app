import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double opacity;

  const CustomDivider({
    super.key,
    this.height = 1,
    this.thickness = 1,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Divider(
        height: height,
        thickness: thickness,
        color: Theme.of(context).colorScheme.secondary.withOpacity(opacity),
      ),
    );
  }
}
