// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizItem _$QuizItemFromJson(Map<String, dynamic> json) => QuizItem(
      question: json['question'] as String,
      options:
          (json['options'] as List<dynamic>).map((e) => e as String).toList(),
      explanation: json['explanation'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      sourceFile: json['sourceFile'] as String,
      isSelected: json['isSelected'] as bool? ?? false,
    );

Map<String, dynamic> _$QuizItemToJson(QuizItem instance) => <String, dynamic>{
      'question': instance.question,
      'options': instance.options,
      'explanation': instance.explanation,
      'tags': instance.tags,
      'sourceFile': instance.sourceFile,
      'isSelected': instance.isSelected,
    };
