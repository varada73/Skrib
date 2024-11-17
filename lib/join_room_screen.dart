import 'package:flutter/material.dart';
import 'package:skribblrr/paint_screen.dart';
import './widgets/custom_text_field.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _roomcontroller = TextEditingController();
  void joinRoom() {
    Map data = {"nickname": _namecontroller.text, "name": _roomcontroller.text};
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaintScreen(data: data, screenFrom: 'joinRoom')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Create Room",
          style: TextStyle(color: Colors.brown, fontSize: 30),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            Controller: _namecontroller,
            hinttext: "Enter your name:",
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomTextField(
            Controller: _roomcontroller,
            hinttext: "Enter room name:",
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        ElevatedButton(
          onPressed: () {
            if (_namecontroller.text.isEmpty || _roomcontroller.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("All fields are required!"),
                ),
              );
              return;
            }
            joinRoom();
          },
          child: const Text("Join Room"),
        ),
      ],
    ));
  }
}
