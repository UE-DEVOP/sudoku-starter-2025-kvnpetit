import 'package:flutter/material.dart';

class InnerGrid extends StatelessWidget {
  final double boxSize;

  const InnerGrid({Key? key, required this.boxSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var innerBoxSize = boxSize / 3;

    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (x) {
        return Container(
          width: innerBoxSize,
          height: innerBoxSize,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
          ),
        );
      }),
    );
  }
}
