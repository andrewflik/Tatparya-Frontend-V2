/*
    Input Page
*/

import 'package:tatparya/widgets/centered_view.dart';
import 'package:tatparya/widgets/result_page.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPage createState() => _InputPage();
}

class _InputPage extends State<InputPage> {
  TextEditingController _input = new TextEditingController();

  final List<String> items = [
    'Twitter',
    'Facebook',
    'Reddit',
  ];
  String? selectedValue;

  Widget buildInput() {
    return SizedBox(
      width: 500,
      height: 50,
      child: TextField(
        cursorColor: Colors.red,
        cursorRadius: Radius.circular(16.0),
        cursorWidth: 16.0,
        //textAlign: TextAlign.center,
        controller: _input,
        onSubmitted: (text) => print(_input.text),
        maxLines: 1,
        decoration: InputDecoration(
          hintText: """ Enter username """,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(
              color: Colors.amber,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CenteredView(
          child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, //Center Column contents vertically,
        crossAxisAlignment:
            CrossAxisAlignment.center, //Center Column contents horizontally,
        children: <Widget>[
          CenteredView(
              child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // This row will contain Logos of twitter/reddit/facebook
              FaIcon(
                FontAwesomeIcons.twitter,
                color: Colors.blueAccent,
                size: 70,
              ),
              SizedBox(width: 20),
              FaIcon(
                FontAwesomeIcons.facebook,
                //color: Colors.deepOrange,
                size: 70,
              ),
              SizedBox(width: 20),
              FaIcon(
                FontAwesomeIcons.reddit,
                color: Colors.redAccent,
                size: 70,
              ),
            ],
          )),
          CenteredView(
              child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Row contents horizontally,
            crossAxisAlignment:
                CrossAxisAlignment.center, //Center Row contents vertically,
            children: [
              Container(
                child: buildInput(),
              ),
              SizedBox(width: 10),
              DropdownButtonHideUnderline(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      ' Select Profile',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    buttonHeight: 40,
                    buttonWidth: 140,
                    itemHeight: 40,
                  ),
                ),
              ),
            ],
          )),
          SizedBox(height: 10),
          SizedBox(
            width: 100, // <-- match_parent
            height: 38, // <-- match-parent
            child: MaterialButton(
                color: Colors.blue,
                child: Text(
                  'Analyze',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  // onPress passs input via API to python
                  print(selectedValue);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ResultPage(_input.text)));
                }),
          )
        ],
      )),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}
