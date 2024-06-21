import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Forms with persistence',
    home: FlutterDemo(userInputsStorage: UserInputsStorage()),
    theme:
        ThemeData(colorScheme: const ColorScheme.light(primary: Colors.pink)),
  ));
}

class FlutterDemo extends StatefulWidget {
  final UserInputsStorage userInputsStorage;

  const FlutterDemo({super.key, required this.userInputsStorage});

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  final userInputController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.userInputsStorage.readUserInput().then((value) {
      setState(() {
        userInputController.text = value;
      });
    });
  }

  //SAVE USER INPUT
  Future<File> _saveUserInput() {
    return widget.userInputsStorage.writeUserInput(userInputController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userInputController.text.isEmpty
            ? 'Demo'
            : userInputController.text),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: userInputController,
            decoration: const InputDecoration(labelText: 'Enter Text'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _saveUserInput();
          });
        },
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }
}

class UserInputsStorage {
  // PATH
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //FILE

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/input.txt');
  }

//READ FROM FILE
  Future<String> readUserInput() async {
    try {
      final File file = await _localFile;
      final content = file.readAsString();
      return content;
    } catch (error) {
      return "";
    }
  }

// WRITE INTO THE FILE
  Future<File> writeUserInput(String userInput) async {
    print("writeUserInput");
    final file = await _localFile;
    return file.writeAsString(userInput);
  }
}
