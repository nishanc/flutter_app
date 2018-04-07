import 'package:flutter/material.dart';
import 'package:flutter_app/utils/question.dart';
import 'package:flutter_app/utils/quiz.dart';
import 'package:flutter_app/ui/answer_button.dart';
import 'package:flutter_app/ui/question_text.dart';
import 'package:flutter_app/ui/correct_incorrect_overlay.dart';
import 'package:flutter_app/pages/score_page.dart';

class QuizPage extends StatefulWidget{
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage>{
  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Question 1", false),
    new Question("Question 2", true),
    new Question("Question 3", false),
    new Question("Question 4", true),
    new Question("Question 5", true),
    new Question("Question 6", true)
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayIsVisible =false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer){
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState((){
      overlayIsVisible = true;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( //main page
          children: <Widget>[
            new AnswerButton(true,()=> handleAnswer(true)),
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false,()=>handleAnswer(false)),
          ],
        ),
        overlayIsVisible == true ? new CorrectIncorrectOverlay(
            isCorrect,
            (){
              if(quiz.length == questionNumber){
                Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)),(Route route)=>route==null);
                return;
              }
              currentQuestion = quiz.nextQuestion;
              this.setState((){
                overlayIsVisible=false;
                questionText=currentQuestion.question;
                questionNumber=quiz.questionNumber;
              });
            }
        ):new Container()
      ],
    );
  }
}