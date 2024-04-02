import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

import 'logica.dart';

class Databases {
  //READ USER
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<QuerySnapshot?> pesquisarUsuario({required String email}) async {
    return await users.where('email', isEqualTo: email).get();
  }

  logicaCadastro LogicaCadastro = logicaCadastro();

  Future<bool> cadastrarUsuario({required String nome,
    required String telefone,
    required String email,
    required String perfil}) async {
    try {

      String retornoImg = await LogicaCadastro.uploadImgPerfil(
          bytes: LogicaCadastro.imagemPerfilBytes!, chatId: email);


      int randomUsuario = 9999 + Random().nextInt(99999 - 9999);

      users.add({
        'name': nome,
        'telefone': telefone,
        'email': email,
        'img_perfil': retornoImg,
        'tokenFcm': 'token',
        'idUsuario': randomUsuario,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


}