import 'package:candy_sorter/features/candy_sorter/model/game.dart';
import 'package:flutter/cupertino.dart';

class TimerWidget extends StatefulWidget {
  final bool timerOn;
  final Game game;
  const TimerWidget({
    Key? key,
    this.timerOn = false,
    required this.game,
  }) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Duration duration;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.game.timerController.stream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData ? Text(snapshot.data.toString()) : Container();
      },
    );
  }
}
