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

class Quiz6 {
  Quiz6() {
    _mapToList(quiz6);
    update();
  }

  final Map<String, List<String>> quiz6 = {
    "Only after the meeting ___ that the project had been approved.": [
      "did we realize",
      "we realized",
      "realized we",
      "we had realized",
      "この文は倒置構文（inversion）の一種です。「Only after」などの否定的または制限的副詞句が文頭に来ると、倒置が起きます。正しい語順は『did + 主語 + 動詞』で、did we realize が正解。これは強調や文体的なフォーマルさを加える目的で使われます。"
    ],
    "If she ___ the deadline, she would have received the bonus.": [
      "had met",
      "met",
      "would meet",
      "meets",
      "これは仮定法過去完了の構文です。『would have + 過去分詞』は「過去に起こらなかったこと」に対する仮定を表します。条件節では『had + 過去分詞』を使います。したがって正解は had met。"
    ],
    "It is crucial that every employee ___ the safety procedures.": [
      "follow",
      "follows",
      "followed",
      "will follow",
      "この文は仮定法現在（subjunctive mood）を使う構文です。demand, suggest, recommend, crucial などの語に続く that節では、主語が三人称でも動詞の原形を使います（例：that he go, that she arrive）。したがって正解は follow。"
    ],
    "Scarcely had they entered the room ___ the lights went out.": [
      "when",
      "than",
      "as",
      "so",
      "『Scarcely...when』は倒置構文＋時間の慣用表現です。「～したとたんに...した」という意味で、接続詞には when が使われます（No sooner...than / Hardly...when / Scarcely...when などの表現と同様の構造）。"
    ],
    "I wish I ___ more time to finish this report.": [
      "had",
      "have",
      "would have",
      "will have",
      "これは仮定法過去の表現で、現実とは異なる願望を述べるときに使われます。『I wish I had...』は「〜だったらよかったのに／〜ならいいのに」という意味。時制は実際より一段過去に下げます。"
    ],
    "Not until next week ___ the new manager start working.": [
      "will",
      "does",
      "is",
      "did",
      "『Not until 〜』で始まる文は倒置構文になります。通常文『The new manager will start working next week』において、副詞句を前に出すことで『Not until next week will the new manager start working』という倒置が生じます。"
    ],
    "The professor suggested that the students ___ more primary sources.": [
      "use",
      "uses",
      "used",
      "will use",
      "suggestなどの動詞の後に続く that節では、主語にかかわらず動詞の原形を用いる仮定法現在が用いられます。したがって『that the students use』が正しい構文です（三単現でも原形）。"
    ],
    "Were I ___ the opportunity, I would gladly take the position.": [
      "given",
      "giving",
      "give",
      "gives",
      "これは倒置構文を使った仮定法です。通常文『If I were given the opportunity』の倒置形で、『Were I + 過去分詞』という形になります。これは公式な文体でよく用いられる形式です。"
    ],
    "Little ___ about the new project until the official announcement.": [
      "did we know",
      "we knew",
      "we know",
      "knowing we",
      "この文も倒置構文です。『Little』が文頭に来ると否定的意味を持つため、疑問文と同じ語順が求められます（助動詞 + 主語 + 動詞）。正解は『did we know』。"
    ],
    "If only he ___ earlier about the schedule change!": [
      "had known",
      "knows",
      "knew",
      "would know",
      "『If only + 過去完了形』は過去に対する強い後悔や願望を表します。『If only he had known』で「彼が知っていたらよかったのに」という意味になります。"
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

    if (quiz6[mondai]![0] == options[userAns]) {
      return true;
    }
    return false;
  }

  //正誤履歴の初期化、全部の問題をboolの空queue(=未回答)で埋める
  late List<Queue<bool>> gradeHistory =
      List.generate(quiz6.length, (_) => Queue<bool>());

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
    for (int i = 0; i < quiz6.length; i++) {
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

  String getNextKaisetu() {
    return randKaisetu[count];
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
  List<String> randKaisetu = [];

  ///randIds + randQuestions + randOptions
  ///size分まとめて生成(=重複なしのメリット)
  void update() {
    //randQuestionsUpdate
    randQuestionsIndex = List.generate(quiz6.length, (i) => i).toList()
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
      List<String> randAnswersMini = [...quiz6[key]!].sublist(0, 4);
      randAnswersMini.shuffle();
      randAnswers.add(randAnswersMini);
    }

    //randKaisetuUpdate
    randKaisetu = [];
    const kaisetuIndex = 4;
    for (var i in randQuestions) {
      randKaisetu.add(quiz6[i]![kaisetuIndex]);
    }
    return;
  }
}
