class QuizItem {
  final String question;
  final List<String> options;
  final String explanation;

  QuizItem({
    required this.question,
    required this.options,
    required this.explanation,
  });

  factory QuizItem.fromJson(Map<String, dynamic> json) {
    return QuizItem(
        question: json['question'],
        options: List<String>.from(json['options']),//List<dynamic> -> List<String>が無理だったため
        explanation: json['explanation']);
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options,
      'explanation': explanation,
    };
  }
}
