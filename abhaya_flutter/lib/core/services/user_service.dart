import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ExamRecord {
  final String id;
  final String subject;
  final String format;
  final int score;
  final int total;
  final int percentage;
  final String date;
  final List<String> missedTopics;

  ExamRecord({
    required this.id,
    required this.subject,
    required this.format,
    required this.score,
    required this.total,
    required this.percentage,
    required this.date,
    this.missedTopics = const [],
  });

  String get title => '$subject · $format';
  String get scoreDisplay => '$score/$total';
}

class TodayTask {
  final String id;
  final String title;
  final String subject;
  final String duration;
  bool completed;
  final IconData icon;
  final Color color;

  TodayTask({
    required this.id,
    required this.title,
    required this.subject,
    required this.duration,
    this.completed = false,
    required this.icon,
    required this.color,
  });
}

class SavedChat {
  final String id;
  final String initials;
  final Color initialsBg;
  final Color initialsColor;
  final String title;
  final String subtitle;
  final String time;
  final String character;
  final String mode;

  String get topic => title;
  String get timeAgo => time;

  SavedChat({
    required this.id,
    required this.initials,
    required this.initialsBg,
    required this.initialsColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.character,
    required this.mode,
  });
}

class SavedDiagram {
  final String id;
  final String title;
  final String time;
  final String type; // 'Uploaded' or 'Generated'
  final IconData icon;
  final Color iconColor;
  final List<Color> gradient;

  String get timeAgo => time;

  SavedDiagram({
    required this.id,
    required this.title,
    required this.time,
    required this.type,
    required this.icon,
    required this.iconColor,
    required this.gradient,
  });
}

class JournalEntry {
  final String id;
  final String tag;
  final String date;
  final String text;

  JournalEntry({
    required this.id,
    required this.tag,
    required this.date,
    required this.text,
  });
}

/// Central dynamic User Service that manages active user session,
/// personalized preferences, dynamic stats, exam records, and daily progress.
class UserService extends ChangeNotifier {
  static final UserService instance = UserService._internal();
  UserService._internal() {
    _initDefaultTasks();
  }

  // User profile details
  String fullName = '';
  String email = '';
  String studentId = '';
  int semester = 1;
  String degree = 'B.Sc Nursing';
  String college = 'College of Nursing';
  String dailyStudyTime = '30 min';
  List<String> focusTopics = ['Med-Surg', 'Critical care'];
  String learningStyle = 'Stories';
  Uint8List? profileImageBytes;
  bool isLoggedIn = false;

  // Dynamic user stats for a fresh student (start at 0)
  int streakDays = 1;
  double studyHoursThisWeek = 0.0;
  int scenariosCompleted = 0;
  int flashcardsReviewed = 0;
  int checkInsThisWeek = 0;
  bool hasCheckedInToday = false;
  int breathingMinutes = 0;
  int calmAudioMinutes = 0;
  int motivationReadCount = 0;
  String lastChatWithFuss = 'No chats yet';

  // Dynamic collections
  final List<ExamRecord> examHistory = [];
  final List<TodayTask> todayTasks = [];
  final List<SavedChat> savedChats = [];
  final List<SavedDiagram> savedDiagrams = [];
  final List<JournalEntry> journalEntries = [];

  void _initDefaultTasks() {
    todayTasks.clear();
    todayTasks.addAll([
      TodayTask(
        id: 'task-1',
        title: 'Anaphylaxis Management Scenario',
        subject: 'Critical Care',
        duration: '15 min',
        completed: false,
        icon: Icons.medical_services_rounded,
        color: AppColors.teal,
      ),
      TodayTask(
        id: 'task-2',
        title: 'Cardiovascular Drug Dosages',
        subject: 'Pharmacology',
        duration: '20 min',
        completed: false,
        icon: Icons.medication_rounded,
        color: AppColors.blushInk,
      ),
      TodayTask(
        id: 'task-3',
        title: 'Label Heart Conduction System',
        subject: 'Diagram Trainer',
        duration: '10 min',
        completed: false,
        icon: Icons.draw_rounded,
        color: AppColors.skyInk,
      ),
      TodayTask(
        id: 'task-4',
        title: 'Post-Op Wound Care Quiz (10 Qs)',
        subject: 'Medical-Surgical',
        duration: '25 min',
        completed: false,
        icon: Icons.quiz_rounded,
        color: AppColors.lilacInk,
      ),
    ]);
  }

  // --- Dynamic Getters ---

  String get firstName {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'Nurse';
    final parts = trimmed.split(RegExp(r'\s+'));
    return parts.first;
  }

  String get greetingName => firstName;

  String get initials {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'N';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  int get completedTaskCount => todayTasks.where((t) => t.completed).length;
  int get totalTaskCount => todayTasks.length;
  double get todayProgress => totalTaskCount == 0 ? 0.0 : completedTaskCount / totalTaskCount;

  int get mockTestsTaken => examHistory.length;

  int get examReadiness {
    if (examHistory.isEmpty) return 0;
    final totalPct = examHistory.map((e) => e.percentage).reduce((a, b) => a + b);
    return (totalPct / examHistory.length).round();
  }

  double get clinicalReadiness {
    if (examHistory.isEmpty && completedTaskCount == 0 && scenariosCompleted == 0) {
      return 0.0;
    }
    final examContribution = examReadiness * 0.5;
    final taskContribution = todayProgress * 30.0;
    final scenarioContribution = (scenariosCompleted.clamp(0, 4) / 4.0) * 20.0;
    final sum = examContribution + taskContribution + scenarioContribution;
    return sum.clamp(0.0, 100.0);
  }

  String get weakSpotsText {
    if (examHistory.isEmpty) {
      return 'No tests taken yet · Complete your first mock to identify weak spots';
    }
    final allMissed = examHistory.expand((e) => e.missedTopics).toSet().toList();
    if (allMissed.isEmpty) {
      return 'Great mastery · No weak spots detected in completed tests';
    }
    return 'Weak spots: ${allMissed.take(2).join(', ')}';
  }

  int get journalEntriesCount => journalEntries.length;
  int get breathingMinutesThisWeek => breathingMinutes;

  // --- Actions & State Updates ---

  void toggleTask(int index) {
    if (index >= 0 && index < todayTasks.length) {
      todayTasks[index].completed = !todayTasks[index].completed;
      if (todayTasks[index].completed) {
        studyHoursThisWeek += 0.2;
      }
      notifyListeners();
    }
  }

  void markTaskCompleteBySubject(String subjectPrefix) {
    for (var task in todayTasks) {
      if (!task.completed && task.subject.toLowerCase().contains(subjectPrefix.toLowerCase())) {
        task.completed = true;
        studyHoursThisWeek += 0.3;
        break;
      }
    }
    notifyListeners();
  }

  void recordExamResult({
    required String subject,
    required String format,
    required int score,
    required int total,
    required List<String> missedTags,
  }) {
    final pct = total > 0 ? ((score / total) * 100).round() : 0;
    final record = ExamRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      subject: subject,
      format: format,
      score: score,
      total: total,
      percentage: pct,
      date: 'Today',
      missedTopics: missedTags,
    );
    examHistory.insert(0, record);
    studyHoursThisWeek += (total * 1.5) / 60.0;
    studyHoursThisWeek = double.parse(studyHoursThisWeek.toStringAsFixed(1));
    markTaskCompleteBySubject('Medical-Surgical');
    notifyListeners();
  }

  void recordScenarioCompleted(String title) {
    scenariosCompleted += 1;
    studyHoursThisWeek += 0.3;
    studyHoursThisWeek = double.parse(studyHoursThisWeek.toStringAsFixed(1));
    markTaskCompleteBySubject('Critical Care');
    notifyListeners();
  }

  void recordBreathing(int minutes) {
    breathingMinutes += minutes;
    studyHoursThisWeek += minutes / 60.0;
    studyHoursThisWeek = double.parse(studyHoursThisWeek.toStringAsFixed(1));
    notifyListeners();
  }

  void recordMoodCheckIn(String mood) {
    if (!hasCheckedInToday) {
      checkInsThisWeek += 1;
      hasCheckedInToday = true;
    }
    notifyListeners();
  }

  void addJournalEntry({required String tag, required String text}) {
    journalEntries.insert(
      0,
      JournalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tag: tag,
        date: 'Today',
        text: text,
      ),
    );
    studyHoursThisWeek += 0.1;
    studyHoursThisWeek = double.parse(studyHoursThisWeek.toStringAsFixed(1));
    notifyListeners();
  }

  void recordChatSession({
    required String title,
    required String tutor,
    required String mode,
  }) {
    final initials = tutor.split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join();
    final existingIndex = savedChats.indexWhere((c) => c.title == title);
    if (existingIndex >= 0) {
      savedChats.removeAt(existingIndex);
    }
    savedChats.insert(
      0,
      SavedChat(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        initials: initials.isNotEmpty ? initials : 'TU',
        initialsBg: const Color(0xFFD5EFE6),
        initialsColor: const Color(0xFF1E6B63),
        title: title,
        subtitle: '$tutor · $mode',
        time: 'Just now',
        character: tutor,
        mode: mode,
      ),
    );
    notifyListeners();
  }

  void recordDiagramSaved({
    required String title,
    required String type,
  }) {
    savedDiagrams.insert(
      0,
      SavedDiagram(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        time: 'Today',
        type: type,
        icon: Icons.grain_rounded,
        iconColor: AppColors.teal,
        gradient: const [Color(0xFFDCF0EA), Color(0xFFC9E7DE)],
      ),
    );
    markTaskCompleteBySubject('Diagram Trainer');
    notifyListeners();
  }

  // --- Auth & Profile ---

  void signup({
    required String name,
    required String userEmail,
  }) {
    fullName = name.trim();
    email = userEmail.trim();
    isLoggedIn = true;
    notifyListeners();
  }

  void updateProfileSetup({
    String? newStudentId,
    int? newSemester,
    String? newStudyTime,
    Uint8List? newImageBytes,
  }) {
    if (newStudentId != null && newStudentId.trim().isNotEmpty) {
      studentId = newStudentId.trim();
    }
    if (newSemester != null) {
      semester = newSemester;
    }
    if (newStudyTime != null && newStudyTime.trim().isNotEmpty) {
      dailyStudyTime = newStudyTime.trim();
    }
    if (newImageBytes != null) {
      profileImageBytes = newImageBytes;
    }
    notifyListeners();
  }

  void updateInterests({
    required List<String> topics,
    required String way,
  }) {
    if (topics.isNotEmpty) {
      focusTopics = List.from(topics);
    }
    learningStyle = way;
    notifyListeners();
  }

  void updateProfile({
    String? newName,
    String? newEmail,
    String? newStudentId,
    String? newCollege,
    int? newSemester,
    String? newStudyTime,
    Uint8List? newImageBytes,
  }) {
    if (newName != null && newName.trim().isNotEmpty) fullName = newName.trim();
    if (newEmail != null && newEmail.trim().isNotEmpty) email = newEmail.trim();
    if (newStudentId != null) studentId = newStudentId.trim();
    if (newCollege != null) college = newCollege.trim();
    if (newSemester != null) semester = newSemester;
    if (newStudyTime != null) dailyStudyTime = newStudyTime.trim();
    if (newImageBytes != null) profileImageBytes = newImageBytes;
    notifyListeners();
  }

  void login({
    required String userEmail,
    String? fallbackName,
  }) {
    email = userEmail.trim();
    if (fullName.isEmpty) {
      if (fallbackName != null && fallbackName.trim().isNotEmpty) {
        fullName = fallbackName.trim();
      } else if (email.isNotEmpty) {
        final prefix = email.split('@').first;
        final clean = prefix.replaceAll(RegExp(r'[^a-zA-Z]'), ' ').trim();
        final parts = clean.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
        if (parts.isNotEmpty) {
          fullName = parts.map((p) => p[0].toUpperCase() + p.substring(1)).join(' ');
        } else {
          fullName = 'Nurse Student';
        }
      } else {
        fullName = 'Nurse Student';
      }
    }
    isLoggedIn = true;
    notifyListeners();
  }

  void resetForNewUser() {
    fullName = '';
    email = '';
    studentId = '';
    semester = 1;
    degree = 'B.Sc Nursing';
    college = 'College of Nursing';
    dailyStudyTime = '30 min';
    focusTopics = ['Med-Surg', 'Critical care'];
    learningStyle = 'Stories';
    profileImageBytes = null;
    isLoggedIn = false;

    // Fresh stats: Day 1 streak, 0.0 study hours, 0 mock tests
    streakDays = 1;
    studyHoursThisWeek = 0.0;
    scenariosCompleted = 0;
    flashcardsReviewed = 0;
    checkInsThisWeek = 0;
    hasCheckedInToday = false;
    breathingMinutes = 0;
    calmAudioMinutes = 0;
    motivationReadCount = 0;
    lastChatWithFuss = 'No chats yet';

    examHistory.clear();
    savedChats.clear();
    savedDiagrams.clear();
    journalEntries.clear();
    _initDefaultTasks();

    notifyListeners();
  }
}
