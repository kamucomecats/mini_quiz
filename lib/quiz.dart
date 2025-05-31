import 'dart:math';

class Quiz {
  Map<String, String> quiz = {
    'iti': 'fuji',
    'ni': 'taka',
    'san': 'nasubi',
  };

  String getquiz() {
    var random = Random();
    var word;
    var key;

    final keys = quiz.keys.toList();
    final randomKey = keys[random.nextInt(keys.length)];

    word = quiz[randomKey];

    key = keys[random.nextInt(quiz.length)];
    word = quiz[key];
    return word;
  }
}

void main() {
  var quiz1 = Quiz();
  print(quiz1.getquiz());
}
