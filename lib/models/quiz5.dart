import 'dart:collection';

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
    '1': [
      'one',
      'dummy',
      'dummy',
      'dummy',
    ],
    '2': [
      'two',
      'dummy',
      'dummy',
      'dummy',
    ],
    '3': [
      'three',
      'dummy',
      'dummy',
      'dummy',
    ],
    '4': [
      'four',
      'dummy',
      'dummy',
      'dummy',
    ],
    '5': [
      'five',
      'dummy',
      'dummy',
      'dummy',
    ],
    '6': [
      'six',
      'dummy',
      'dummy',
      'dummy',
    ],
    '7': [
      'seven',
      'dummy',
      'dummy',
      'dummy',
    ],
    '8': [
      'eight',
      'dummy',
      'dummy',
      'dummy',
    ],
    '9': [
      'nine',
      'dummy',
      'dummy',
      'dummy',
    ],
  };

  //seigoHyo[quizIndex][recent correct ans rate(?? times)]
  List<List<int>> seigoHyo = [];

  Queue<Map<String, List<String>>> quizHistory = Queue();
  Queue<int> seikaiHistory = Queue();
  final quizHistoryMax = 100;
  final bookHistoryMax = 5;

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
  void quizHistoryUpdate(
      int userAns, String mondai, List<String> options, int seikai) {
    if (quizHistory.length >= quizHistoryMax) {
      quizHistory.removeLast();
      seikaiHistory.removeLast();
    }
    quizHistory.addFirst({mondai: options});
    seikaiHistory.addFirst(seikai);
  }

  //should not accessed before instance initialize
  late List<Queue<int>> bookHistory = List.generate(
      quiz5.length, (_) => Queue<int>()..addAll(List.generate(5, (_) => 2)));

  //bookHistory
  //設問ごとの正誤履歴
  void bookHistoryUpdate(String mondai, int seikai) {
    var index = keys.indexOf(mondai);
    if (bookHistory[index].length >= bookHistoryMax) {
      bookHistory[index].removeLast();
    }
    bookHistory[index].addFirst(seikai);
  }

  //設問ごとの正誤履歴をUI表示用にString化
  List<String> bookHistoryToStr() {
    List<String> bookHistoryStr = [];
    for (int i = 0; i < quiz5.length; i++) {
      String bookHistoryStrMini = '';
      for (int j = 0; j < bookHistoryMax; j++) {
        switch (bookHistory[i].elementAt(j)) {
          case 0:
            bookHistoryStrMini = '$bookHistoryStrMini' 'o';
            break;
          case 1:
            bookHistoryStrMini = '$bookHistoryStrMini' 'x';
            break;
          case 2:
            bookHistoryStrMini = '$bookHistoryStrMini' '-';
            break;
        }
      }
      bookHistoryStr.add(bookHistoryStrMini);
    }
    return bookHistoryStr;
  }

  List<String> keys = [];

  //make keys and values
  void _mapToList(quiz) {
    keys = quiz.keys.toList();
    return;
  }

  var size = 5;
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
}
