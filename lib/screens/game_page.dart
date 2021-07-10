import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:quiz_app/models/question.dart';
import 'package:quiz_app/screens/quiz_finish_page.dart';

class GamePage extends StatefulWidget {
  final int questionNo;
  final int correctNo;
  GamePage({Key key, this.questionNo, this.correctNo}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(questionNo: questionNo, correctNo: correctNo);
}

class _GamePageState extends State<GamePage> {
  _GamePageState({this.questionNo, this.correctNo});
  final int questionNo;
  int correctNo;
  int _indexOfCorrect;
  bool _isNextAvailable = false;
  Future<Question> futureQuestion;

  @override
  void initState() {
    super.initState();
    futureQuestion = fetchQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Color(0xFF252C4A),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.80,
          height: MediaQuery.of(context).size.height * 0.90,
          child: questionNo > 9
              ? QuizFinishPage(correctNo: correctNo)
              : FutureBuilder<Question>(
                  future: futureQuestion,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Expanded(
                            flex: 10,
                            child: Text((questionNo + 1).toString() + "/10", style: TextStyle(color: Colors.white, fontSize: 80)),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 8,
                            child: Text(HtmlCharacterEntities.decode(snapshot.data.question), style: TextStyle(fontSize: 20)),
                          ),
                          Spacer(),
                          drawOptions(0, snapshot.data.answers, snapshot.data.correctAnswer),
                          Spacer(),
                          drawOptions(1, snapshot.data.answers, snapshot.data.correctAnswer),
                          Spacer(),
                          drawOptions(2, snapshot.data.answers, snapshot.data.correctAnswer),
                          Spacer(),
                          drawOptions(3, snapshot.data.answers, snapshot.data.correctAnswer),
                          Spacer(),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _isNextAvailable ? Color(0xFFFFFFFF) : Color(0xFF362136),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: EdgeInsets.only(left: 25),
                                alignment: Alignment.centerLeft,
                                child: Text("Next Question", style: TextStyle(color: Colors.black, fontSize: 16)),
                              ),
                              onTap: () {
                                if (_isNextAvailable) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GamePage(questionNo: questionNo + 1, correctNo: correctNo)));
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Container();
                  }),
        ),
      ),
    );
  }

  Widget drawOptions(int _isChosen, List answers, String correctAnswer) {
    return Expanded(
      flex: 3,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: _indexOfCorrect == _isChosen ? Color(0xFF5EE48B) : Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.only(left: 25),
          alignment: Alignment.centerLeft,
          child: Text(HtmlCharacterEntities.decode(answers[_isChosen]), style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        onTap: () {
          if (!_isNextAvailable) {
            setState(() {
              _indexOfCorrect = answers.indexOf(correctAnswer);
              _isNextAvailable = true;
            });
            if (_indexOfCorrect == _isChosen) {
              correctNo += 1;
            }
          }
        },
      ),
    );
  }
}
