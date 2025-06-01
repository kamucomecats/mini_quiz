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

  void randQuiz(int ques_num) {
    const option_num = 4;

    final keys = quiz.keys.toList();
    final values = quiz.values.toList();

    final candidates = List.generate(quiz.length, (i) => i)..remove(ques_num);

    List opt_nums = [];

    if (option_num > 1) {
      opt_nums.addAll(candidates.take(option_num - 1));
    } else {
      return;
    }

    //問題文=randomKey
    //正答=word
    //正答のindex=ques_num
    //誤答のindex=opt_nums

    var randomKey = keys[ques_num];
    var randomValue = values[ques_num];

    //add correct_int to dummy_int List to generate options
    opt_nums.add(ques_num);
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
    final user_ans_int = int.tryParse(user_ans ?? '-1');

    final correct_ans_int = opt_answers.indexOf(randomValue);

    //1-order index of option will be answer
    if ((user_ans_int! - 1) == correct_ans_int) {
      print("correct!!!!!!!!!!");
    } else {
      print("wrong!!!!!!!");
      print("correct is $randomValue");
    }
    return;
  }

  void loopQuiz() {
    const looptime = 5;

    List<int> question_nums = [];

    for (int i = 0; i < looptime; i++) {
      question_nums.add(i);
    }
    question_nums.shuffle();

    List<int> question_nums_little = [];
    question_nums_little.addAll(question_nums.take(looptime));

    for (int i = 0; i < looptime; i++) {
      print("question${i + 1}");
      randQuiz(question_nums_little[i]);
    }

    print("finish!");
  }
}

void main() {
  var x;
  x = Quiz();
  x.loopQuiz();
  return;
}
