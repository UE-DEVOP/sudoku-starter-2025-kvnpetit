import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InnerGrid extends StatelessWidget {
  final double boxSize;
  final Puzzle? puzzle;
  final int blockIndex;

  const InnerGrid({
    Key? key,
    required this.boxSize,
    required this.puzzle,
    required this.blockIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var innerBoxSize = boxSize / 3;

    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (y) {
        int? value = puzzle?.board()?.matrix()?[blockIndex][y].getValue();

        return Container(
          width: innerBoxSize,
          height: innerBoxSize,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
          ),
          child: Center(
            child: Text(
              value != null && value != 0 ? value.toString() : '',
            ),
          ),
        );
      }),
    );
  }
}
