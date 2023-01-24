import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge({Key? key, required this.child, required this.value, this.color})
      : super(key: key);

  final Widget child;
  final String value;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // ignore: prefer_if_null_operators, unnecessary_null_comparison
                color: color != null
                    ? color
                    : Theme.of(context).colorScheme.secondary),
            constraints: const BoxConstraints(maxWidth: 16, minHeight: 16),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            ),
          ),
          right: 8,
          top: 8,
        ),
      ],
    );
  }
}
