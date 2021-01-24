import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iknoweverything/models/answers.dart';

class QuestionAnswerPage extends StatefulWidget {
  @override
  _QuestionAnswerPageState createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
  //[1]Text Editing Controller for question textfield
  TextEditingController _questionFieldController = TextEditingController();

  //To store the current answer object
  Answer _currentAnswer;

  //Scaffold key
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //[2]Handle process of gettting a yes/no response
  _handleGetAnswer() async {
    String questionText = _questionFieldController.text?.trim();
    if (questionText == null ||
        questionText.length == 0 ||
        questionText[questionText.length - 1] != '?') {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Please Ask A Valid Question'),
          duration: Duration(seconds: 2)));
      return;
    }
    try {
      http.Response response = await http.get('https://yesno.wtf/api');
      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        Answer theanswer = Answer.fromMap(responseBody);
        setState(() {
          _currentAnswer = theanswer;
        });
      }
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
    }
  }

  //Handle Reset Operation
  _handleResetOperation() {
    _questionFieldController.text = '';
    setState(() {
      _currentAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('I Know Everything',
              style: TextStyle(color: Colors.black87)),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 0.6 * MediaQuery.of(context).size.width,
            child: TextField(
              controller: _questionFieldController,
              decoration: InputDecoration(
                labelText: 'Ask A Question',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 20),
          if (_currentAnswer != null)
            Container(
              height: 250,
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_currentAnswer.image))),
            ),
          if (_currentAnswer != null) SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: _handleGetAnswer,
                child: Text(
                  'Get Answered',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 20),
              RaisedButton(
                onPressed: _handleResetOperation,
                child: Text(
                  'Reeesett Mee',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
