import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Question extends Equatable {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> answers;

  const Question({
    @required this.category,
    @required this.difficulty,
    @required this.question,
    @required this.correctAnswer,
    @required this.answers,
  });

  @override
  List<Object> get props => [
        category,
        difficulty,
        question,
        correctAnswer,
        answers,
      ];

  factory Question.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return Question(
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
      question: map['question'] ?? '',
      correctAnswer: map['correct_answer'] ?? '',
      answers: List<String>.from(map['incorrect_answers'] ?? [])
        ..add(map['correct_answer'] ?? '')
        ..shuffle(),
    );
  }
}

Future<Question> fetchQuestion() async {
  String url = "https://opentdb.com/api.php?amount=1&type=multiple";
  http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return Question.fromMap(jsonDecode(response.body)["results"][0]);
  } else {
    throw Exception('Failed to load question');
  }
}
