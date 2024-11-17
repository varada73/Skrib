import 'package:flutter/material.dart';
import 'package:skribblrr/paint_screen.dart';
import './widgets/custom_text_field.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _roomcontroller = TextEditingController();
  String? _maxRoundsValue;
  String? _roomSizeValue;
  void createRoom() {
    if (_namecontroller.text.isNotEmpty &&
        _roomcontroller.text.isNotEmpty &&
        _maxRoundsValue != null &&
        _roomSizeValue != null) {
      Map data = {
        "nickname": _namecontroller.text,
        "name": _roomcontroller.text,
        "occupancy": _roomSizeValue,
        "maxRounds": _maxRoundsValue
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PaintScreen(data: data, screenFrom: "createRoom")));
    }
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
        DropdownButton<String>(
          focusColor: Color(0xffF5F6FA),
          items: ["2", "5", "10", "15"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          hint: Text(
            'Select Max Rounds',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          onChanged: (String? value) {
            setState(() {
              _maxRoundsValue = value;
            });
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        DropdownButton<String>(
          focusColor: Color(0xffF5F6FA),
          items: ["2", "3", '4', "5", "6", "7", "8"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text(
            'Select Room Size',
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          onChanged: (String? value) {
            setState(() {
              _roomSizeValue = value;
            });
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        ElevatedButton(
          onPressed: () {
            createRoom();
          },
          child: const Text("Create Room"),
        ),
      ],
    ));
  }
}
