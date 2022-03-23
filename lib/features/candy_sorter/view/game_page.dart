import 'package:candy_sorter/features/candy_sorter/model/game_setting_provider.dart';
import 'package:candy_sorter/features/candy_sorter/model/model.dart';
import 'package:candy_sorter/features/candy_sorter/view/bowl_area.dart';
import 'package:candy_sorter/features/candy_sorter/view/candy_area.dart';
import 'package:candy_sorter/features/candy_sorter/widgets/timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Game? game;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettingProvider>(
      builder: ((context, setting, child) {
        _createGame() {
          return Game(
            numberOfColors: setting.numOfColors,
            numberOfCandies: setting.numOfCandies,
            timerDuration: setting.timerDuration,
            gameArea: Size(
              MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height / 2,
            ),
          );
        }

        _startGame() {
          game!.start();
        }

        _resetGame() {
          var _game = _createGame();
          setState(() => game = _game);
        }

        _createAndStartGame() {
          _resetGame();
          _startGame();
        }

        /// Call this when you put a candy into the bowl.
        void _onRemoveCandy(Candy candy) {
          game!.removeCandy(candy);
          setState(() {});
        }

        _showSetting() => showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 400,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Text(
                          'Number of candies',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      StatefulBuilder(
                        builder: ((context, setState) {
                          var numOfCandies = setting.numOfCandies.toDouble();
                          return Slider(
                            value: numOfCandies,
                            min: 1,
                            max: 100,
                            divisions: 20,
                            label: numOfCandies.toString(),
                            onChanged: (double value) {
                              var val = value.toInt();
                              if (val != numOfCandies) {
                                setState(() => numOfCandies = value);
                                setting.setNumOfCandies(val);
                              }
                            },
                          );
                        }),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Text(
                          'Time limit',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      StatefulBuilder(
                        builder: ((context, setState) {
                          var value =
                              setting.timerDuration.inSeconds.toDouble();
                          return Slider(
                            value: value,
                            min: 30,
                            max: 600,
                            label: Duration(seconds: value.toInt()).toString(),
                            onChanged: (double _value) {
                              var _val = _value.toInt();
                              if (_val != value.toInt()) {
                                setState(() => value = _value);
                                setting
                                    .setTimerDuration(Duration(seconds: _val));
                              }
                            },
                          );
                        }),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Text(
                          'Number of colors',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      StatefulBuilder(
                        builder: ((context, setState) {
                          var value = setting.numOfColors.toDouble();
                          return Slider(
                            value: value,
                            min: 2,
                            max: 10,
                            label: Duration(seconds: value.toInt()).toString(),
                            onChanged: (double _value) {
                              var _val = _value.toInt();
                              if (_val != value.toInt()) {
                                setState(() => value = _value);
                                setting.setNumOfColors(_val);
                              }
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              );
            });

        // whenever setting has been updated, create new game.

        if (game == null) {
          game = _createGame();
        } else {
          if (game!.numberOfCandies != setting.numOfCandies) {
            game!.setNumberOfCandies(setting.numOfCandies);
          }
          if (game!.timerDuration.compareTo(setting.timerDuration) != 0) {
            game!.setTimeDuration(setting.timerDuration);
          }
          if (game!.numberOfColors != setting.numOfColors) {
            game!.setNumberOfColors(setting.numOfColors);
          }
        }

        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Candy Sorter'),
              actions: [
                IconButton(
                  onPressed: _showSetting,
                  icon: const Icon(Icons.settings),
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  child: StreamBuilder<Status>(
                    stream: game!.statusController.stream,
                    builder: ((context, AsyncSnapshot<Status?> snapshot) {
                      switch (snapshot.data) {
                        case Status.started:
                          return ElevatedButton(
                            onPressed: _resetGame,
                            child: const Text('Reset game'),
                          );
                        case Status.completed:
                          return ElevatedButton(
                            onPressed: _createAndStartGame,
                            child: const Text('Well done Start new game?'),
                          );
                        case Status.failed:
                          return ElevatedButton(
                            onPressed: _createAndStartGame,
                            child: const Text('You need more time?'),
                          );
                        default:
                          return ElevatedButton(
                            onPressed: _startGame,
                            child: const Text('Let\' start!'),
                          );
                      }
                    }),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Candies left: ${game!.numberOfLeft}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      'Candies sorted: ${game!.numberOfSorted}',
                      style: Theme.of(context).textTheme.headline6,
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: CandyArea(
                    game: game!,
                    onCandyRemoved: _onRemoveCandy,
                  ),
                ),
                Expanded(
                  child: BowlArea(game: game!),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: TimerWidget(
                    game: game!,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
