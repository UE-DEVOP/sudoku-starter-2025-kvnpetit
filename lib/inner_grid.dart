import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InnerGrid extends StatelessWidget {
  final double boxSize;
  final Puzzle? puzzle;
  final int blockIndex;
  final int? selectedBlock;
  final int? selectedCell;
  final Function(int, int) onCellSelected;

  const InnerGrid({
    Key? key,
    required this.boxSize,
    required this.puzzle,
    required this.blockIndex,
    required this.selectedBlock,
    required this.selectedCell,
    required this.onCellSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var innerBoxSize = boxSize / 3;

    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (y) {
        int? value = puzzle?.board()?.matrix()?[blockIndex][y].getValue();
        bool isSelected = selectedBlock == blockIndex && selectedCell == y;

        return InkWell(
          onTap: () => onCellSelected(blockIndex, y),
          child: Container(
            width: innerBoxSize,
            height: innerBoxSize,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.3),
              color: isSelected
                  ? Colors.blueAccent.shade100.withAlpha(100)
                  : Colors.transparent,
            ),
            child: Center(
              child: Text(
                value != null && value != 0 ? value.toString() : '',
              ),
            ),
          ),
        );
      }),
    );
  }
}
