import 'package:json_annotation/json_annotation.dart';

part 'quiz_item.g.dart';

@JsonSerializable()
class QuizItem {
  final String question;
  final List<String> options;
  final String explanation;
  final List<String> tags;
  final String sourceFile;
  bool isSelected;

  QuizItem({
    required this.question,
    required this.options,
    required this.explanation,
    required this.tags,
    required this.sourceFile,
    this.isSelected = false,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) =>
      _$QuizItemFromJson(json);

  Map<String, dynamic> toJson() => _$QuizItemToJson(this);
}
