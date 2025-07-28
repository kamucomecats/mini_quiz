import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'dart:collection';
import 'package:mini_quiz/models/user_data.dart';
import 'package:mini_quiz/providers/quiz_state.dart';

class UserdataManager {
  late UserData userdata;

  Future<void> loadQuizData() async {
    //jsonをStringとして取り込み
    final String jsonString =
        await rootBundle.loadString('assets/users/user1.json');

    userdata = json.decode(jsonString);
  }
}
