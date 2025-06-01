import 'dart:math';
import 'dart:io';

class Quiz {
  final Map<String, String> quiz = {
    '俺が今食べたいものは': '唐揚げ',
    '夏の旬といえば': 'スイカ',
    'あなたの好物': 'コロッケ',
    '寒いときにおいしい': 'おでん',
    '家のは格別な': 'ホイル焼き',
    'たまに食べたい': 'ちまき',
    '食べ物の王様': 'カレー',
    '週3で食べたい': 'ホットドッグ',
  };

  void randQuiz() {
    var random = Random();
    int option_num = 4;

    final keys = quiz.keys.toList();
    final values = quiz.values.toList();
    final randomIndex = random.nextInt(quiz.length);
    final candidates = List.generate(quiz.length, (i) => i)
      ..remove(randomIndex);

    List opt_nums = [];

    if (option_num > 1) {
      opt_nums.addAll(candidates.take(option_num - 1));
    } else {
      return;
    }

    //問題文=randomKey
    //正答=word
    //正答のindex=randomIndex
    //誤答のindex=opt_nums

    var randomKey = keys[randomIndex];
    var randomValue = values[randomIndex];

    opt_nums.add(randomIndex);
    opt_nums.shuffle();

    //回答候補4つのList=opt_answers
    //問題4つのList=opt_questions
    List<String> opt_questions = [];
    List<String> opt_answers = [];
    for (int i = 0; i < option_num; i++) {
      opt_questions.add(keys[opt_nums[i]]);
      opt_answers.add(values[opt_nums[i]]);
    }

    print(randomKey);
    print("options : $opt_answers");

    String? user_ans = stdin.readLineSync();
    final user_ans_int = int.tryParse(user_ans ?? '');

    final correct_ans_int = opt_answers.indexOf(randomValue);

    //0-order index of option will be answer
    if (user_ans_int == correct_ans_int) {
      print("correct!!!!!!!!!!");
    } else {
      print("wrong!!!!!!!");
      print("correct is $randomValue");
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
