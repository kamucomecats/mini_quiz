import 'package:json_annotation/json_annotation.dart';
import 'package:mini_quiz/models/quiz_progress.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  int userId;
  String userName;
  List<String> goals;
  List<DateTime> goalDates;
  List<QuizProgress> quizProgresses;

  UserData({
    this.userId = 0,
    this.userName = "Nishikawa",
    this.goals = const [],
    this.goalDates = const [],
    this.quizProgresses = const [],
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
