///define quiz_log shape

class QuizLog {
  final int id;
  final String mondai;
  final List<String> options;
  final String kaisetu;
  int? userAns;
  bool? seikai;

  QuizLog({
    required this.id,
    required this.mondai,
    required this.options,
    required this.kaisetu,
    required this.userAns,
    required this.seikai,
  });
}
