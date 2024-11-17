import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:skribblrr/widgets/touch_points.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import './widgets/my_custom-painter.dart';

class PaintScreen extends StatefulWidget {
  final Map data;
  final String screenFrom;

  const PaintScreen({required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map dataOfRoom = {};
  List<TouchPoints> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
    print(widget.data);
  }

  void connect() {
    _socket = IO.io("http://192.168.70.25:3000", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    _socket.connect();
    if (widget.screenFrom == 'createRoom') {
      _socket.emit('create-game', widget.data);
    } else {
      _socket.emit('join-room', widget.data);
    }
    _socket.onConnect((data) {
      print('connected!');
      _socket.on('updateRoom', (roomData) {
        setState(() {
          this.dataOfRoom = roomData;
        });
        if (roomData['isJoin'] != true) {
          //start the time
        }
      });
      _socket.on('points', (point) {
        if (point['details'] != null) {
          setState(() {
            points.add(TouchPoints(
                points: Offset(point['details']['dx'].toDouble(),
                    point['details']['dy'].toDouble()),
                paint: Paint()
                  ..strokeCap = strokeType
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        }
      });
      _socket.on('color-change', (color) {
        int value = int.parse(color, radix: 16);
        Color otherColor = new Color(value);
        setState(() {
          selectedColor = otherColor;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    void selectColor() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Choose Color'),
                content: SingleChildScrollView(
                    child: BlockPicker(
                  pickerColor: selectedColor,
                  onColorChanged: (color) {
                    String colorString = color.toString();
                    String valueString =
                        colorString.split('(0x')[1].split(')')[0];
                    print(colorString);
                    print(valueString);
                    Map map = {
                      'color': valueString,
                      'roomName': dataOfRoom['name']
                    };
                    _socket.emit('color-change', map);
                  },
                )),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'))
                ],
              ));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width,
                  height: height * 0.55,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      print(details.localPosition.dx);
                      _socket.emit('paint', {
                        'details': {
                          'dx': details.localPosition.dx,
                          'dy': details.localPosition.dy,
                        },
                        'roomName': widget.data['name']
                      });
                    },
                    onPanStart: (details) {
                      print(details.localPosition.dx);
                      _socket.emit('paint', {
                        'details': {
                          'dx': details.localPosition.dx,
                          'dy': details.localPosition.dy,
                        },
                        'roomName': widget.data['name']
                      });
                    },
                    onPanEnd: (details) {
                      _socket.emit(
                          'paint', {'details': null, 'roomName': widget.data});
                    },
                    child: SizedBox.expand(
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: RepaintBoundary(
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: MyCustomPainter(pointsList: points),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          selectColor();
                        },
                        icon: Icon(
                          Icons.color_lens,
                          color: selectedColor,
                        )),
                    Expanded(
                        child: Slider(
                      min: 1.0,
                      max: 10,
                      label: "Strokewidth $strokeWidth",
                      activeColor: selectedColor,
                      value: strokeWidth,
                      onChanged: (double) {},
                    )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.layers_clear, color: selectedColor))
                  ],
                )
              ],
            )
          ],
        ));
  }
}
