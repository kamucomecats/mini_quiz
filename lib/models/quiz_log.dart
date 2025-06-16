class QuizLog {
  final String mondai;
  final List<String> options;
  final int userAns;
  final int seikai;

  QuizLog({
    required this.mondai,
    required this.options,
    required this.userAns,
    required this.seikai,
  });
}
