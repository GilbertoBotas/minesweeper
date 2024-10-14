import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:minesweeper/constants/colors.dart';
import 'package:minesweeper/constants/game_rules.dart';
import 'package:minesweeper/models/block_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.PRIMARY,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                GameRules.WIN
                    ? 'Ganhaste'
                    : GameRules.GAMEOVER
                        ? 'Perdeste'
                        : 'Minesweeper',
                style: const TextStyle(
                    fontSize: 36,
                    color: AppColors.ACCENT,
                    fontWeight: FontWeight.bold)),
            GridView.builder(
                shrinkWrap: true,
                itemCount: calculateNrOfBlocks(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: GameRules.GRIDSIZE),
                itemBuilder: (_, index) {
                  int x = index ~/ GameRules.GRIDSIZE;
                  int y = index % GameRules.GRIDSIZE;

                  return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            clickBlock(x, y);
                            checkIfWon();
                          });
                        },
                        child: Container(
                          color: Color.fromRGBO(25, 2, 62, 1),
                          child: Center(
                              child: (Text(
                            getBlockLabel(x, y),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: getBlockColor(x, y)),
                          ))),
                        ),
                      ));
                }),
            const SizedBox(
              height: 32,
            ),
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 32,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    resetGame();
                  });
                },
                icon: const Icon(
                  Icons.refresh,
                  size: 32,
                  color: AppColors.ACCENT,
                ),
              ),
            )
          ],
        ));
  }

  Color getBlockColor(int x, int y) {
    return Block.GAMETABLE[x][y].isBomb
        ? Colors.redAccent
        : Block.GAMETABLE[x][y].nrBombs == 0
            ? AppColors.ACCENT
            : Block.GAMETABLE[x][y].nrBombs == 1
                ? Colors.blue
                : Block.GAMETABLE[x][y].nrBombs == 2
                    ? Colors.amber
                    : Colors.red;
  }

  String getBlockLabel(int x, int y) {
    return Block.GAMETABLE[x][y].isClicked
        ? (Block.GAMETABLE[x][y].isBomb
            ? 'X'
            : '${Block.GAMETABLE[x][y].nrBombs}')
        : ' ';
  }

  int calculateNrOfBlocks() => GameRules.GRIDSIZE * GameRules.GRIDSIZE;

  clickBlock(int row, int column) {
    if (!isValidCoordinates(row, column) || GameRules.WIN) {
      return;
    }

    if (Block.GAMETABLE[row][column].isClicked) return;

    Block.GAMETABLE[row][column].isClicked = true;

    if (Block.GAMETABLE[row][column].isBomb && !GameRules.GAMEOVER) {
      gameOver();
      return;
    }

    Block.GAMETABLE[row][column].nrBombs = countMinesNearBlock(row, column);

    if (Block.GAMETABLE[row][column].nrBombs != 0) return;

    for (int a = row - 1; a <= row + 1; a++) {
      for (int b = column - 1; b <= column + 1; b++) {
        clickBlock(a, b);
      }
    }
  }

  isValidCoordinates(int row, int column) {
    if (row >= Block.GAMETABLE.length ||
        row < 0 ||
        column >= Block.GAMETABLE[0].length ||
        column < 0) {
      return false;
    } else {
      return true;
    }
  }

  gameOver() {
    GameRules.GAMEOVER = true;
    revealTable();
  }

  revealTable() {
    for (int a = 0; a < Block.GAMETABLE.length; a++) {
      for (int b = 0; b < Block.GAMETABLE[0].length; b++) {
        clickBlock(a, b);
      }
    }
  }

  int countMinesNearBlock(int row, int column) {
    int count = 0;

    for (int a = row - 1; a <= row + 1; a++) {
      for (int b = column - 1; b <= column + 1; b++) {
        if (isValidCoordinates(a, b)) {
          Block block = Block.GAMETABLE[a][b];
          if (!(a == row && b == column) && block.isBomb) {
            count++;
          }
        }
      }
    }
    return count;
  }

  void toast(String message) => Fluttertoast.showToast(
      msg: message, backgroundColor: const Color.fromRGBO(0, 0, 0, 0.6));

  void resetGame() {
    Block.GAMETABLE = Block.getBlockModel();
    GameRules.WIN = false;
    GameRules.GAMEOVER = false;
  }

  void checkIfWon() {
    int safeBlocks = 0;
    int requiredSafeBlocks = calculateNrSafeBombs();

    for (List<Block> row in Block.GAMETABLE) {
      for (Block block in row) {
        if (!didBlockExplode(block)) {
          safeBlocks++;
        }
      }
    }

    if (didPlayerWin(safeBlocks, requiredSafeBlocks)) {
      GameRules.WIN = true;
    }
  }

  bool didPlayerWin(int safeBlocks, int requiredSafeBlocks) =>
      safeBlocks == requiredSafeBlocks && !GameRules.GAMEOVER;

  bool didBlockExplode(Block block) => block.isBomb && block.isClicked;

  int calculateNrSafeBombs() =>
      GameRules.GRIDSIZE * GameRules.GRIDSIZE - GameRules.NRBOMBS;
}
