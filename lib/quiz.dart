import 'dart:math';
import 'dart:io';

class Quiz {
  final Map<String, String> quiz = {
    '0': 'fuji',
    '1': 'taka',
    '2': 'nasubi',
    '3': 'tsukune',
    '4': 'nara',
    '5': 'kyoto',
    '6': 'saga',
    '7': 'hakodate',
  };

  void randQuiz() {
    var random = Random();
    int option_num = 4;

    final keys = quiz.keys.toList();
    final randomIndex = random.nextInt(keys.length);
    final candidates = List.generate(keys.length, (i) => i)
      ..remove(randomIndex);

    candidates.shuffle();

    final dummy;

    if (option_num > 1) {
      dummy = candidates.take(option_num - 1);
    } else {
      return;
    }

    var randomKey = keys[randomIndex];
    print("randomkey is $randomKey:");
    print(dummy);
    String word = quiz[randomKey]!;
    print(word);
    print("question:what is $randomKey ?");
    String? user_ans = stdin.readLineSync();

    if (user_ans == word) {
      print("correct!!!!!!!!!!");
    } else {
      print("wrong!!!!!!!");
    }
    return;
  }
}

void main() {
  var x;
  x = Quiz();
  x.randQuiz();
  return;
}
