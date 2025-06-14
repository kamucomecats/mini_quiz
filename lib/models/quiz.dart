import 'dart:collection';

//クイズ生成ロジックとデータを含む

//外部から見たら、getNextするだけでとにかくStringが返ってくるのが理想
//外から呼ぶものを1つに絞る
//呼ばれるのはgetNextMondai()、getNextOptions()、increment()
//3つにしたのは外で扱いやすいと思ったから!
//3つは出題のたびに必ず、同時に、一度に呼ぶ

class Quiz {
  Quiz() {
    mapToList(quiz);
    update();
  }

  final Map<String, String> quiz = {
    '1': 'one',
    '2': 'two',
    '3': 'three',
    '4': 'four',
    '5': 'five',
    '6': 'six',
    '7': 'seven',
    '8': 'eight',
    '9': 'nine',
  };

  /*  '私は学校に走ります。': 'Ich laufe zur Schule.',
    '私の趣味は女装です。': 'Mein Hobby ist Cross-Dressing.',
    '私は東京出身です。': 'Ich komme aus Tokio.',
    '私の職業は料理人です。': 'Mein Beruf ist Koch.',
    '私の好きな科目は数学です。': 'Mein Lieblingsfach ist Mathematik.',
    '私は図書館にいます。': 'Ich bin in der Bibliothek.',
    '私は財布を探しています。': 'Ich suche meine Brieftasche.',
    '私は電車を待っています。': 'Ich warte auf einen Zug.',
    '私は彼に怒っています。': 'Ich bin wütend auf ihn.',
    '私は風邪をひいています。': 'Ich habe eine Erkältung.',*/

  //0-dim is quizIndex
  //1-dim is recent correct ans rate(10 times)
  List<List<int>> seigoHyo = [];

  Queue<Map<String, List<String>>> quizHistory = Queue();
  Queue<int> seikaiHistory = Queue();
  final quizHistoryMax = 100;
  final bookHistoryMax = 5;

  //gudge just before quiz
  int gudge(int userAns, String mondai, List<String> options) {
    var countPrevious = count - 1;
    if (countPrevious == -1) countPrevious = size - 1;

    if (quiz[mondai] == options[userAns]) {
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
      quiz.length, (_) => Queue<int>()..addAll(List.generate(5, (_) => 2)));

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
    for (int i = 0; i < quiz.length; i++) {
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
  List<String> values = [];

  //make keys and values
  void mapToList(quiz) {
    keys = quiz.keys.toList();
    values = quiz.values.toList();
    return;
  }

  var size = 5;
  var count = 0;
  final optionsNum = 4;

  //randKeysのあとで呼ぶ
  String getNextMondai() {
    return randKeys[count];
  }

  //randKeysのあとで呼ぶ
  List<String> getNextOptions() {
    return randValues[count];
  }

  //count進数制御、update
  void increment() {
    count++;
    if (count >= size) {
      count = 0;
      update();
    }
  }

  List<String> randKeys = [];
  List<List<String>> randValues = [];

  //randKeys and randOptions update
  void update() {
    //randKeyUpdate
    List<int> randKeysIndex = List.generate(quiz.length, (i) => i).toList();
    randKeysIndex.shuffle();
    randKeysIndex = randKeysIndex.take(size).toList();
    randKeys = [];
    for (int i = 0; i < size; i++) {
      randKeys.add(keys[randKeysIndex[i]]);
    }

    //randOptionsUpdate
    List<List<int>> randValuesIndex = [];
    for (int i = 0; i < size; i++) {
      var candidates = List.generate(quiz.length, (i) => i).toList()
        ..remove(randKeysIndex[i]);
      candidates.shuffle();

      randValuesIndex.add(candidates.take(optionsNum - 1).toList());
      randValuesIndex[i].add(randKeysIndex[i]);
      randValuesIndex[i].shuffle();
    }
    randValues = [];
    for (int i = 0; i < size; i++) {
      List<String> randValuesMini = [];
      for (int j = 0; j < randValuesIndex[i].length; j++) {
        randValuesMini.add(values[randValuesIndex[i][j]]);
      }
      randValues.add(randValuesMini);
    }
    return;
  }
}
