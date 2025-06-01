import 'dart:math';

class Quiz {
  Map<String, String> quiz = {
    '0': 'fuji',
    '1': 'taka',
    '2': 'nasubi',
    '3': 'tsukune',
    '4': 'nara',
    '5': 'kyoto',
    '6': 'saga',
    '7': 'hakodate',
  };

  void getquiz() {
    var random = Random();
    int option_num = 4;

    final keys = quiz.keys.toList();
    final correct = random.nextInt(keys.length);
    final candidates = List.generate(keys.length, (i) => i)..remove(correct);

    candidates.shuffle();

    final dammy;

    if (option_num > 1) {
      dammy = candidates.take(option_num - 1);
    } else {
      return;
    }

    var randomKey = keys[correct];
    print("randomkey is ${randomKey}:");
    print(dammy);
    String word = quiz[randomKey]!;
    print(word);
    return;
  }
}

void main() {
  var x;
  x = Quiz();
  x.getquiz();
}
