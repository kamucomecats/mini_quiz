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

  List keys = [];
  List values = [];

  void mapToList(quiz) {
    keys = quiz.keys.toList();
    values = quiz.values.toList();
    return;
  }

  void makeQuiz(int ans_num) {
    const option_num = 4;

    final candidates = List.generate(quiz.length, (i) => i)..remove(ans_num);

    List opt_nums = [];

    opt_nums.addAll(candidates.take(option_num - 1));

    //問題文=randomKey
    //正答のindex=ans_num
    //誤答のindex=opt_nums
    mapToList(quiz);
    var randomKey = keys[ans_num];
    var randomValue = values[ans_num];

    //add correct_int to dummy_int List to generate options
    opt_nums.add(ans_num);
    opt_nums.shuffle();

    //回答候補4つのList=opt_answers
    //問題4つのList=opt_questions
    List<String> opt_questions = [];
    List<String> opt_answers = [];
    for (int i = 0; i < option_num; i++) {
      opt_questions.add(keys[opt_nums[i]]);
      opt_answers.add(values[opt_nums[i]]);
    }

    //問題文と選択肢4つ出力
    print(randomKey);
    print("options : $opt_answers");

    //read
    String? user_ans = stdin.readLineSync();
    final user_ans_int = int.tryParse(user_ans ?? '-1');

    final correct_ans_int = opt_answers.indexOf(randomValue);

    //1-order index of option will be answer
    if ((user_ans_int! - 1) == correct_ans_int) {
      print("correct!!!!!!!!!!");
      return;
    }
    print("wrong!!!!!!!");
    print("correct is $randomValue");
    return;
  }

  //generate answers from size
  List rand_ans(int size) {
    List ans_list = [];
    for (int i = 0; i < quiz.length; i++) {
      ans_list.add(i);
    }
    ans_list.shuffle();
    ans_list.addAll(ans_list.take(size));
    return ans_list;
  }

  void quizController() {
    //問題数
    //ans size
    const ans_size = 5;

    final ans_list = rand_ans(ans_size);

    //only refer to quiz-list using generated index-list
    for (int i = 0; i < ans_size; i++) {
      print("question${i + 1}");
      makeQuiz(ans_list[i]);
    }

    print("finish!");
  }
}

void main() {
  var x = Quiz();
  x.quizController();
  return;
}
