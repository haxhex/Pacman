import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import 'ghost.dart';
import 'path.dart';
import 'pixel.dart';
import 'player.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = 144;
  int ghost = numberInRow * 2 - 2;
  String ghostDirection = "left";
  int lives = 3; // add lives variable

  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    33,
    44,
    55,
    66,
    88,
    99,
    110,
    121,
    132,
    143,
    154,
    155,
    156,
    157,
    158,
    159,
    160,
    161,
    162,
    163,
    164,
    153,
    142,
    131,
    120,
    109,
    98,
    76,
    65,
    54,
    43,
    32,
    21,
    24,
    35,
    46,
    26,
    27,
    28,
    30,
    41,
    52,
    68,
    69,
    70,
    59,
    48,
    50,
    61,
    72,
    73,
    74,
    75,
    89,
    90,
    91,
    92,
    103,
    114,
    97,
    96,
    95,
    94,
    105,
    116,
    112,
    123,
    134,
    118,
    129,
    140,
    136,
    137,
    138
  ];

  List<int> food = [];
  String direction = "right";
  bool preGame = true;
  bool mouthClosed = false;
  int score = 0;
  bool paused = false;

  void playSampleSound() async {
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.play(AssetSource('sounds/background.mp3'));
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void initState() {
    super.initState();
    // Play the background sound
    playSampleSound();
  }

  void startGame() {
    preGame = false;
    paused = false;
    getFood();
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (!paused) {
        setState(() {
          mouthClosed = !mouthClosed;
        });
        if (food.contains(player)) {
          food.remove(player);
          score++;
        }
        switch (direction) {
          case "left":
            moveLeft();
            break;
          case "right":
            moveRight();
            break;
          case "up":
            moveUp();
            break;
          case "down":
            moveDown();
            break;
        }
        moveGhost();
        if (lives == 0) {
          paused = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Game Over"),
                content: Text("You lost!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        preGame = true;
                        score = 0;
                        player = 144;
                        ghost = numberInRow * 2 - 2;
                        direction = "right";
                        ghostDirection = "left";
                        food.clear();
                        paused = true;
                        mouthClosed = false;
                        lives = 3;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Play Again"),
                  ),
                ],
              );
            },
          );
        } else if (food.isEmpty) {
          paused = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("You win!"),
                content: Text("Congratulation!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        preGame = true;
                        score = 0;
                        player = 144;
                        ghost = numberInRow * 2 - 2;
                        direction = "right";
                        ghostDirection = "left";
                        food.clear();
                        paused = true;
                        mouthClosed = false;
                        lives = 3;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text("Play Again"),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  void getFood() {
    for (int i = 0; i < 165; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (player == 77 && direction == "left") {
      setState(() {
        player = 87;
      });
    } else if (player == 87 && direction == "right") {
      setState(() {
        player = 77;
      });
    } else if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (player == 77 && direction == "left") {
      setState(() {
        player = 87;
      });
    } else if (player == 87 && direction == "right") {
      setState(() {
        player = 77;
      });
    } else if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  void moveGhost() {
    Random random = Random();
    int randomNumber = random.nextInt(4);
    switch (randomNumber) {
      case 0:
        ghostDirection = "left";
        if (!barriers.contains(ghost - 1)) {
          ghost--;
        }
        break;
      case 1:
        ghostDirection = "right";
        if (!barriers.contains(ghost + 1)) {
          ghost++;
        }
        break;
      case 2:
        ghostDirection = "up";
        if (!barriers.contains(ghost - numberInRow)) {
          ghost -= numberInRow;
        }
        break;
      case 3:
        ghostDirection = "down";
        if (!barriers.contains(ghost + numberInRow)) {
          ghost += numberInRow;
        }
        break;
    }
    if (ghost == player) {
      lives--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 165,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 11),
                    itemBuilder: (BuildContext context, int index) {
                      if (mouthClosed && player == index) {
                        return Padding(
                          padding: EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.yellow, shape: BoxShape.circle),
                          ),
                        );
                      } else if (player == index) {
                        switch (direction) {
                          case "left":
                            return Transform.rotate(
                              angle: pi,
                              child: MyPlayer(),
                            );
                            break;
                          case "right":
                            return MyPlayer();
                            break;
                          case "up":
                            return Transform.rotate(
                              angle: 3 * pi / 2,
                              child: MyPlayer(),
                            );
                            break;
                          case "down":
                            return Transform.rotate(
                              angle: pi / 2,
                              child: MyPlayer(),
                            );
                            break;
                          default:
                            return MyPlayer();
                        }
                      } else if (ghost == index) {
                        return MyGhost();
                      } else if (barriers.contains(index)) {
                        return MyPixel(
                          innerColor: Colors.blue[800],
                          outerColor: Colors.blue[900],
                          // child: Text(index.toString()),
                        );
                      } else if (food.contains(index) || preGame) {
                        return MyPath(
                          innerColor: Colors.yellow,
                          outerColor: Colors.black,
                          // child: Text(index.toString()),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    lives,
                    (index) => Padding(
                      padding: EdgeInsets.all(4),
                      child: Container(
                        width: 20, // Set the width to 10
                        height: 20, // Set the height to 10
                        child: Image.asset(
                          'lib/images/pacman.png',
                          fit: BoxFit
                              .contain, // Ensure the image fits within the container
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Score: " + score.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    if (preGame)
                      ElevatedButton(
                        onPressed: startGame,
                        child: Text(
                          "PLAY",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    else
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                paused = !paused;
                              });
                            },
                            child: Text(
                              paused ? "RESUME" : "PAUSE",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                preGame = true;
                                score = 0;
                                player = 144;
                                ghost = numberInRow * 2 - 2;
                                direction = "right";
                                ghostDirection = "left";
                                food.clear();
                                paused = true;
                                mouthClosed = false;
                                lives = 3;
                              });
                            },
                            child: Text(
                              "RESET",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
