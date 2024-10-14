import 'dart:math';

import 'package:minesweeper/constants/game_rules.dart';

class Block {
  String label;
  int nrBombs;
  bool isBomb;
  bool isClicked;

  Block(
      {required this.label,
      required this.nrBombs,
      required this.isBomb,
      required this.isClicked});

  static List<List<Block>> GAMETABLE = getBlockModel();

  static List<List<Block>> getBlockModel() {
    List<List<Block>> table = [];

    for (int a = 0; a < GameRules.GRIDSIZE; a++) {
      // Initialize the inner list
      List<Block> innerList = [];

      for (int b = 0; b < GameRules.GRIDSIZE; b++) {
        // Add a new BlockModel to the inner list
        innerList.add(
            Block(label: ' ', nrBombs: 0, isBomb: false, isClicked: false));
      }

      // Add the inner list to the outer list
      table.add(innerList);
    }

    addMines(table);

    return table;
  }

  static addMines(List<List<Block>> table) {
    int nrGoalMines = 10;
    int nrMines = 0;
    Random random = Random();

    while (nrMines != nrGoalMines) {
      int randomRow = random.nextInt(9); // Generates a number between 0 and 8
      int randomColumn =
          random.nextInt(9); // Generates a number between 0 and 8
      Block randomBlock = table[randomRow][randomColumn];

      if (!randomBlock.isBomb) {
        randomBlock.isBomb = true;
        table[randomRow][randomColumn] = randomBlock;
        nrMines++;
      }
    }
  }
}
