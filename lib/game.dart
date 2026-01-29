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

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  void _generatePuzzle() {
    PuzzleOptions puzzleOptions = PuzzleOptions(patternName: "winter");
    puzzle = Puzzle(puzzleOptions);
    puzzle!.generate().then((_) {
      setState(() {});
    });
  }

  void _selectCell(int blockIndex, int cellIndex) {
    setState(() {
      selectedBlock = blockIndex;
      selectedCell = cellIndex;
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
        if (_isPuzzleCompleted()) {
          context.go('/end');
        }
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            duration: Duration(seconds: 2),
            content: AwesomeSnackbarContent(
              title: 'Erreur',
              message: 'Mauvaise valeur !',
              contentType: ContentType.failure,
              inMaterialBanner: true,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: boxSize * 3,
              width: boxSize * 3,
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(9, (x) {
                  return Container(
                    width: boxSize,
                    height: boxSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                int value = i + 1;
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () => _setValue(value),
                    child: Text('$value'),
                  ),
                );
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                int value = i + 6;
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () => _setValue(value),
                    child: Text('$value'),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _solveAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
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
