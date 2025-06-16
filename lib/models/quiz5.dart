import 'dart:collection';
import 'quiz_log.dart';

//クイズ生成ロジックとデータを含む

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

  Queue<Map<String, List<String>>> quizHistory = Queue();
  Queue<int> seikaiHistory = Queue();
  Queue<int> userAnsHistory = Queue();
  final quizHistoryMax = 5;
  final gradeHistoryMax = 5;

  //gudge just before quiz
  //return 0 when correct
  int gudge(int userAns, String mondai, List<String> options) {
    var countPrevious = count - 1;
    if (countPrevious == -1) countPrevious = size - 1;

    if (quiz5[mondai]![0] == options[userAns]) {
      return 0;
    }
    return 1;
  }

  //quizHistory
  //出題ごとの問題・選択肢履歴
  //難しいので一旦、(問題 + 選択肢)、正誤、回答は別々のqueueでスタート
  void quizHistoryUpdate(
      int userAns, String mondai, List<String> options, int seikai) {
    if (quizHistory.length >= quizHistoryMax) {
      quizHistory.removeLast();
      seikaiHistory.removeLast();
      userAnsHistory.removeLast();
    }
    quizHistory.addFirst({mondai: options});
    seikaiHistory.addFirst(seikai);
    userAnsHistory.addFirst(userAns);
  }

  //should not accessed before instance initialize
  late List<Queue<int>> gradeHistory = List.generate(
      quiz5.length, (_) => Queue<int>()..addAll(List.generate(5, (_) => 2)));

  //gradeHistory List<Queue<int>>
  //設問ごとの正誤履歴
  void gradeHistoryUpdate(String mondai, int seikai) {
    var index = keys.indexOf(mondai);
    if (gradeHistory[index].length >= gradeHistoryMax) {
      gradeHistory[index].removeLast();
    }
    gradeHistory[index].addFirst(seikai);
  }

  //設問ごとの正誤履歴をUI表示用にString化
  List<String> gradeHistoryToStr() {
    List<String> gradeHistoryStrs = [];
    for (int i = 0; i < quiz5.length; i++) {
      String bookHistoryStr = '';
      for (int j = 0; j < gradeHistoryMax; j++) {
        switch (gradeHistory[i].elementAt(j)) {
          case 0:
            bookHistoryStr = '$bookHistoryStr' '✅';
            break;
          case 1:
            bookHistoryStr = '$bookHistoryStr' '❌';
            break;
          case 2:
            bookHistoryStr = '$bookHistoryStr' '⬛';
            break;
        }
      }
      gradeHistoryStrs.add(bookHistoryStr);
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

  //randKeysのあとで呼ぶ
  String getNextMondai() {
    return randQuestions[count];
  }

  //randKeysのあとで呼ぶ
  List<String> getNextOptions() {
    return randAnswers[count];
  }

  //count進数制御、update
  void increment() {
    count++;
    if (count >= size) {
      count = 0;
      update();
    }
  }

  List<String> randQuestions = [];
  List<List<String>> randAnswers = [];

  //randQuestions and randOptions update
  void update() {
    //randKeyUpdate
    List<int> randQuestionsIndex =
        List.generate(quiz5.length, (i) => i).toList()..shuffle();
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

  List<QuizLog> quizHistoryToLog() {
    final history = <QuizLog>[];
    final mondaiList = quizHistory.toList();
    final seikaiList = seikaiHistory.toList();
    final userAnsList = userAnsHistory.toList();

    for (int i = 0; i < mondaiList.length; i++) {
      final entry = mondaiList[i].entries.first;
      history.add(
        QuizLog(
          mondai: entry.key,
          options: entry.value,
          userAns: userAnsList[i],
          seikai: seikaiList[i],
        ),
      );
    }
    return history;
  }
}
