// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizProgress _$QuizProgressFromJson(Map<String, dynamic> json) => QuizProgress(
      filename: json['filename'] as String,
      trainCounts: (json['trainCounts'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      correctCounts: (json['correctCounts'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      correctHistory: (json['correctHistory'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k),
                (e as List<dynamic>).map((e) => e as bool).toList()),
          ) ??
          const {},
      trainDates: (json['trainDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuizProgressToJson(QuizProgress instance) =>
    <String, dynamic>{
      'filename': instance.filename,
      'trainCounts': instance.trainCounts,
      'correctCounts': instance.correctCounts,
      'correctHistory':
          instance.correctHistory.map((k, e) => MapEntry(k.toString(), e)),
      'trainDates':
          instance.trainDates.map((e) => e.toIso8601String()).toList(),
    };
