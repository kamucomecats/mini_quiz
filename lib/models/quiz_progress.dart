import 'package:json_annotation/json_annotation.dart';

part 'quiz_progress.g.dart';

@JsonSerializable()
class QuizProgress {
  String filename;
  List<int> trainCounts; //count total training time
  List<int> correctCounts; // questionId -> count
  Map<int, List<bool>> correctHistory; //length=3
  List<DateTime> trainDates; //for user activity

  QuizProgress({
    required this.filename,
    this.trainCounts = const [],
    this.correctCounts = const [],
    this.correctHistory = const {},
    this.trainDates = const [],
  });

  factory QuizProgress.fromJson(Map<String, dynamic> json) =>
      _$QuizProgressFromJson(json);

  Map<String, dynamic> toJson() => _$QuizProgressToJson(this);
}
