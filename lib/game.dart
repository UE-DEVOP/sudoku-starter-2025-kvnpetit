import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:sudoku_starter/inner_grid.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Puzzle? puzzle;
  int? selectedBlock;
  int? selectedCell;
  int errorCount = 0;
  static const int maxErrors = 3;

  // Chronomètre
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _generatePuzzle() {
    PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "winter");
    puzzle = Puzzle(puzzleOptions);
    puzzle!.generate().then((_) {
      setState(() {});
    });
  }

  void _selectCell(int blockIndex, int cellIndex) {
    if (puzzle == null) return;

    // Vérifier si la case est déjà remplie
    int? value = puzzle!.board()?.matrix()?[blockIndex][cellIndex].getValue();
    if (value != null && value != 0) return;

    setState(() {
      selectedBlock = blockIndex;
      selectedCell = cellIndex;
    });
  }

  void _deselectCell() {
    setState(() {
      selectedBlock = null;
      selectedCell = null;
    });
  }

  bool _isPuzzleCompleted() {
    if (puzzle == null) return false;
    var board = puzzle!.board()?.matrix();
    var solvedBoard = puzzle!.solvedBoard()?.matrix();
    if (board == null || solvedBoard == null) return false;

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        if (board[i][j].getValue() != solvedBoard[i][j].getValue()) {
          return false;
        }
      }
    }
    return true;
  }

  void _solveAll() {
    if (puzzle == null) return;
    var board = puzzle!.board()?.matrix();
    var solvedBoard = puzzle!.solvedBoard()?.matrix();
    if (board == null || solvedBoard == null) return;

    setState(() {
      for (int i = 0; i < 9; i++) {
        for (int j = 0; j < 9; j++) {
          board[i][j].setValue(solvedBoard[i][j].getValue()!);
        }
      }
    });
    _timer?.cancel();
    context.go('/end');
  }

  void _setValue(int value) {
    if (selectedBlock != null && selectedCell != null && puzzle != null) {
      int? expectedValue = puzzle!
          .solvedBoard()
          ?.matrix()?[selectedBlock!][selectedCell!]
          .getValue();

      if (value == expectedValue) {
        ScaffoldMessenger.of(context).clearSnackBars();
        setState(() {
          puzzle!
              .board()!
              .matrix()![selectedBlock!][selectedCell!]
              .setValue(value);
        });
        _deselectCell();
        if (_isPuzzleCompleted()) {
          _timer?.cancel();
          context.go('/end');
        }
      } else {
        setState(() {
          errorCount++;
        });
        _deselectCell();

        if (errorCount >= maxErrors) {
          _timer?.cancel();
          context.go('/defeat');
          return;
        }

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            duration: const Duration(seconds: 2),
            content: AwesomeSnackbarContent(
              title: 'Erreur',
              message: 'Mauvaise valeur !',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    }
  }

  Widget _buildNumberButton(int value) {
    bool isEnabled = selectedBlock != null && selectedCell != null;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        elevation: isEnabled ? 4 : 1,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isEnabled ? () => _setValue(value) : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isEnabled
                    ? [Colors.blue.shade400, Colors.blue.shade700]
                    : [Colors.grey.shade300, Colors.grey.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  color: isEnabled ? Colors.white : Colors.grey.shade600,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer),
            const SizedBox(width: 8),
            Text(
              _formatTime(_seconds),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Compteur d'erreurs
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                'Erreurs : $errorCount / $maxErrors',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: boxSize * 3,
                width: boxSize * 3,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (x) {
                    return Container(
                      width: boxSize,
                      height: boxSize,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 1),
                      ),
                      child: InnerGrid(
                        boxSize: boxSize,
                        puzzle: puzzle,
                        blockIndex: x,
                        selectedBlock: selectedBlock,
                        selectedCell: selectedCell,
                        onCellSelected: _selectCell,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) => _buildNumberButton(i + 1)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => _buildNumberButton(i + 6)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _solveAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.auto_fix_high),
              label: const Text('Résoudre tout'),
            ),
          ],
        ),
      ),
    );
  }
}
