import 'package:flutter/material.dart';

class SudokuCell extends StatelessWidget {
  final double size;
  final int? value;
  final int? expectedValue;
  final bool isSelected;
  final bool isEmpty;
  final bool isEditable;
  final VoidCallback onTap;

  const SudokuCell({
    Key? key,
    required this.size,
    required this.value,
    required this.expectedValue,
    required this.isSelected,
    required this.isEmpty,
    required this.isEditable,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEditable ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.3),
          color: _getBackgroundColor(),
        ),
        child: Center(
          child: Text(
            _getDisplayText(),
            style: TextStyle(
              color: _getTextColor(),
              fontWeight: isEditable ? FontWeight.normal : FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected) {
      return Colors.blueAccent.shade100.withAlpha(100);
    }
    if (!isEditable) {
      return Colors.grey.shade200;
    }
    return Colors.transparent;
  }

  Color _getTextColor() {
    if (isEmpty) {
      return Colors.black12;
    }
    if (!isEditable) {
      return Colors.black87;
    }
    return Colors.blue.shade700;
  }

  String _getDisplayText() {
    if (isEmpty) {
      return expectedValue?.toString() ?? '';
    }
    return value.toString();
  }
}
