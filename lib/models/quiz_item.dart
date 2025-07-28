///1問分に該当
///問題セットjsonからListとして抽出

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'quiz_item.g.dart';

@JsonSerializable()
class QuizItem {
  final String question;
  final List<String> options;
  final String explanation;
  final List<String> tags; //複数種のタグに対応
  late final String sourceFile;
  final bool isSelected;

  QuizItem({
    required this.question,
    required this.options,
    required this.explanation,
    required this.tags,
    required this.sourceFile,
    this.isSelected = false,
  });

/// fromJsonをカスタム実装、tagは"none"がデフォ
  factory QuizItem.fromJson(Map<String, dynamic> json){
    return QuizItem(
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      explanation: json['explanation'] as String,
      tags: json['tags'] == null
      ? ['none']
      :List<String>.from(json['tags']),
      sourceFile: json['sourceFile'] ?? '',
      isSelected: json['isSelected'] ?? false,
      );
  }

  Map<String, dynamic> toJson() => _$QuizItemToJson(this);

  QuizItem copyWith({
    String? question,
    List<String>? options,
    String? explanation,
    List<String>? tags,
    String? sourceFile,
    bool? isSelected,
  }) {
    return QuizItem(
      question: question ?? this.question,
      options: options ?? this.options,
      explanation: explanation ?? this.explanation,
      tags: tags ?? this.tags,
      sourceFile: sourceFile ?? this.sourceFile,
    );
  }
}
