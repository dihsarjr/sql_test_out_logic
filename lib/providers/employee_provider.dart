import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sql_app/model/employee_model.dart';
import 'package:sql_app/model/todo_model.dart';

import 'data_base_provider.dart';

class EmployeeProvider with ChangeNotifier {
  List<TodoModel> todoModel;
  Dio dio = Dio();
  Future<List<TodoModel>> getTodo() async {
    const url = "https://jsonplaceholder.typicode.com/todos";

    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        print(response.data);
        todoModel = todoModelFromJson(json.encode(response.data));
        for (var i = 1; i < todoModel.length; i++) {
          var todo = Todo(
              id: todoModel[i].id,
              title: todoModel[i].title,
              userId: todoModel[i].userId,
              completed: todoModel[i].completed);
          DBProvider.db.createTodo(todo);
        }
        return todoModel;
      } else {
        print("server error ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
    return null;
  }
}
