import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/rotes/app.rules.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/user_form.dart';

class UserTile extends StatelessWidget {
  final User user;
  final Function onDeleted;
  UserTile({super.key, required this.user, required this.onDeleted});
  List<User> alunos = [];

  getAlunos() async {
    alunos.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('alunos') != null) {
      List<String> alunosJson = prefs.getStringList('alunos')!;
      for (var alunoJson in alunosJson) {
        alunos.add(User.fromMap(json.decode(alunoJson)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatar = user.avatarUrl == null || user.avatarUrl!.isEmpty
        ? const CircleAvatar(child: Icon(Icons.person))
        : CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl!));
    return ListTile(
      leading: avatar,
      title: Text(user.name ?? ''),
      subtitle: Text(user.email ?? ''),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.orange,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserForm(
                      user: user,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () async {
                await getAlunos();

                int index = alunos.indexWhere((usuario) {
                  return usuario.id == user.id;
                });

                alunos.removeAt(index);
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                List<String> alunosString = [];
                for (var aluno in alunos) {
                  alunosString.add(json.encode(aluno.toMap()));
                }
                prefs.setStringList('alunos', alunosString);
                onDeleted();
              },
            ),
          ],
        ),
      ),
    );
  }
}
