import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserForm extends StatefulWidget {
  final User? user;
  const UserForm({super.key, this.user});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();

  List<String> alunos = [];
  List<User> alunosModel = [];
  User user = User();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      user = widget.user!;
    }
    getAlunos();
  }

  getAlunos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList('alunos') != null) {
      alunos = prefs.getStringList('alunos')!;
    }
  }

  getAlunosModel() async {
    alunosModel.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getStringList('alunos') != null) {
      List<String> alunosJson = prefs.getStringList('alunos')!;
      for (var alunoJson in alunosJson) {
        setState(() {
          alunosModel.add(User.fromMap(json.decode(alunoJson)));
        });
      }
    }
  }

  setAlunos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user.id != null) {
      user.id = Random().nextInt(10000);
    }
    alunos.add(json.encode(user.toMap()));
    prefs.setStringList('alunos', alunos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Usuário'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              await getAlunosModel();
              if (widget.user != null) {
                int index = alunosModel.indexWhere((usuario) {
                  return usuario.id == widget.user!.id;
                });

                alunosModel[index] = user;
                setAlunos();
              } else {
                if (_form.currentState!.validate()) {
                  setAlunos();
                }
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                initialValue: user.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um nome';
                  }
                },
                onChanged: (value) {
                  user.name = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                initialValue: user.email,
                onChanged: (value) {
                  user.email = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'URL do Avatar'),
                initialValue: user.avatarUrl,
                onChanged: (value) {
                  user.avatarUrl = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nota 1'),
                initialValue: user.nota1 != null ? user.nota1.toString() : '',
                onChanged: (value) {
                  setState(() {
                    user.nota1 = double.parse(value);
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nota 2'),
                initialValue: user.nota2 != null ? user.nota2.toString() : '',
                onChanged: (value) {
                  setState(() {
                    user.nota2 = double.parse(value);
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nota3'),
                initialValue: user.nota3 != null ? user.nota3.toString() : '',
                onChanged: (value) {
                  setState(() {
                    user.nota3 = double.parse(value);
                  });
                },
              ),
              Text(
                  (((user.nota1 ?? 0) + (user.nota2 ?? 0) + (user.nota3 ?? 0)) /
                          3)
                      .toString()),
            ],
          ),
        ),
      ),
    );
  }
}
