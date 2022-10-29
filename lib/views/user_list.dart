// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud/components/user_tile.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/rotes/app.rules.dart';
import 'package:flutter_crud/views/user_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserList extends StatefulWidget {
  UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> alunos = [];

  @override
  void initState() {
    super.initState();
    getAlunos();
  }

  getAlunos() async {
    alunos.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('alunos') != null) {
      List<String> alunosJson = prefs.getStringList('alunos')!;
      for (var alunoJson in alunosJson) {
        setState(() {
          alunos.add(User.fromMap(json.decode(alunoJson)));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuarios'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserForm()),
              ).whenComplete(() => getAlunos());
            },
          ),
        ],
      ),
      body: ListView(
        children: alunos
            .map((e) => UserTile(
                  user: e,
                  onDeleted: () {
                    print('teste');
                    getAlunos();
                  },
                ))
            .toList(),
      ),
    );
  }
}
