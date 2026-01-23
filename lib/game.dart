import 'package:flutter/material.dart';
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
      ),
    );
  }
}
