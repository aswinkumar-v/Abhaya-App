import 'package:flutter/material.dart';

class ClinicalScenario {
  final String id;
  final String title;
  final String category;
  final String patientAge;
  final String urgency;
  final String description;
  final int stepsCount;
  final Color badgeColor;

  const ClinicalScenario({
    required this.id,
    required this.title,
    required this.category,
    required this.patientAge,
    required this.urgency,
    required this.description,
    required this.stepsCount,
    required this.badgeColor,
  });
}

class ExamQuestionModel {
  final int id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ExamQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class StudyNote {
  final String id;
  final String subject;
  final String title;
  final String summary;
  final int flashcardCount;
  final String readTime;

  const StudyNote({
    required this.id,
    required this.subject,
    required this.title,
    required this.summary,
    required this.flashcardCount,
    required this.readTime,
  });
}

class ChatMessage {
  final String sender;
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatMessage({
    required this.sender,
    required this.text,
    required this.isUser,
    required this.time,
  });
}
