import 'dart:collection';
import 'quiz_log.dart';

//クイズ生成ロジックとデータを含む
//model(=参照先、内部値は絶対になし、静的要素全部)

//具体的には
//問題・正答誤答データ保管(quiz5では)
//正誤判定(gudge関数, called only by others)
//出題、回答履歴の更新

//外部から見たら、getNextするだけでとにかくStringが返ってくるのが理想
//外から呼ぶものを1つに絞る
//呼ばれるのはgetNextMondai()、getNextOptions()、increment()
//3つにしたのは外で扱いやすいと思ったから!
//3つは出題のたびに必ず、同時に、一度に呼ぶ

//quizの4択を指定可能にしたversion

class Quiz5 {
  Quiz5() {
    _mapToList(quiz5);
    update();
  }

  final Map<String, List<String>> quiz5 = {
    "Only after the meeting ___ that the project had been approved.": [
      "did we realize",
      "we realized",
      "realized we",
      "we had realized"
    ],
    "If she ___ the deadline, she would have received the bonus.": [
      "had met",
      "met",
      "would meet",
      "meets"
    ],
    "It is crucial that every employee ___ the safety procedures.": [
      "follow",
      "follows",
      "followed",
      "will follow"
    ],
    "Scarcely had they entered the room ___ the lights went out.": [
      "when",
      "than",
      "as",
      "so"
    ],
    "I wish I ___ more time to finish this report.": [
      "had",
      "have",
      "would have",
      "will have"
    ],
    "Not until next week ___ the new manager start working.": [
      "will",
      "does",
      "is",
      "did"
    ],
    "The professor suggested that the students ___ more primary sources.": [
      "use",
      "uses",
      "used",
      "will use"
    ],
    "Were I ___ the opportunity, I would gladly take the position.": [
      "given",
      "giving",
      "give",
      "gives"
    ],
    "Little ___ about the new project until the official announcement.": [
      "did we know",
      "we knew",
      "we know",
      "knowing we"
    ],
    "If only he ___ earlier about the schedule change!": [
      "had known",
      "knows",
      "knew",
      "would know"
    ],
  };

  //seigoHyo[quizIndex][recent correct ans rate(?? times)]
  List<List<int>> seigoHyo = [];

  Queue<QuizLog> quizLog = Queue();
  Queue<int> seikaiHistory = Queue();
  Queue<int> userAnsHistory = Queue();
  final quizLogMax = 5;
  final gradeHistoryMax = 5;

  //gudge just before quiz
  //return 0 when correct
  bool isCorrect(int userAns, String mondai, List<String> options) {
    var countPrevious = count - 1;
    if (countPrevious == -1) countPrevious = size - 1;

    if (quiz5[mondai]![0] == options[userAns]) {
      return true;
    }
    return false;
  }

  //正誤履歴の初期化、全部の問題をboolの空queue(=未回答)で埋める
  late List<Queue<bool>> gradeHistory =
      List.generate(quiz5.length, (_) => Queue<bool>());

  //gradeHistory List<Queue<int>>
  //設問ごとの正誤履歴
  void gradeHistoryUpdate(String mondai, bool seikai) {
    var index = keys.indexOf(mondai);
    if (gradeHistory[index].length >= gradeHistoryMax) {
      gradeHistory[index].removeLast();
    }
    gradeHistory[index].addFirst(seikai);
  }

  //設問ごとの正誤履歴をUI表示用にString化
  //最初にQueueの長さを見る、bool出てるやつはT/F対応
  //残りは黒の四角で埋める
  List<String> gradeHistoryToStr() {
    List<String> gradeHistoryStrs = [];
    for (int i = 0; i < quiz5.length; i++) {
      String gradeHistoryStr = '';
      for (int j = 0; j < gradeHistory[i].length; j++) {
        if (gradeHistory[i].elementAt(j)) {
          gradeHistoryStr += '✅';
        } else {
          gradeHistoryStr += '❌';
        }
      }
      for (int j = 0; j < gradeHistoryMax - gradeHistory[i].length; j++) {
        gradeHistoryStr = '$gradeHistoryStr' '⬛';
      }
      gradeHistoryStrs.add(gradeHistoryStr);
    }
    return gradeHistoryStrs;
  }

  List<String> keys = [];

  //make keys and values
  void _mapToList(quiz) {
    keys = quiz.keys.toList();
    return;
  }

  final size = 5;
  var count = 0;
  final optionsNum = 4;

  ///randKeysのあとで呼ぶ3関数(必ず同時に)
  ///getNextMondaiIndex, getNextMondai, getNextOptions
  ///表示することを前提としている3要素をListから出す
  int getNextMondaiIndex() {
    return randQuestionsIndex[count] + 1;
  }

  String getNextMondai() {
    return randQuestions[count];
  }

  List<String> getNextOptions() {
    return randAnswers[count];
  }

  //count、[size]進数制御、update
  void increment() {
    count++;
    if (count >= size) {
      count = 0;
      update();
    }
  }

  List<int> randQuestionsIndex = [];
  List<String> randQuestions = [];
  List<List<String>> randAnswers = [];

  ///randIds + randQuestions + randOptions
  ///size分まとめて生成(=重複なしのメリット)
  void update() {
    //randQuestionsUpdate
    randQuestionsIndex = List.generate(quiz5.length, (i) => i).toList()
      ..shuffle();
    randQuestionsIndex = randQuestionsIndex.take(size).toList();
    randQuestions = [];
    for (int i = 0; i < size; i++) {
      randQuestions.add(keys[randQuestionsIndex[i]]);
    }

    //randOptionsUpdate
    randAnswers = [];
    for (int i = 0; i < size; i++) {
      final key = randQuestions[i];
      List<String> randAnswersMini = [...quiz5[key]!];
      randAnswersMini.shuffle();
      randAnswers.add(randAnswersMini);
    }
    return;
  }
}
