import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:sudoku_starter/cell.dart';

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
        int? expectedValue =
            puzzle?.solvedBoard()?.matrix()?[blockIndex][y].getValue();
        bool isSelected = selectedBlock == blockIndex && selectedCell == y;
        bool isEmpty = value == null || value == 0;
        bool isEditable = isEmpty;

        return SudokuCell(
          size: innerBoxSize,
          value: value,
          expectedValue: expectedValue,
          isSelected: isSelected,
          isEmpty: isEmpty,
          isEditable: isEditable,
          onTap: () => onCellSelected(blockIndex, y),
        );
      }),
    );
  }
}
