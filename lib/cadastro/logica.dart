import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class logicaCadastro {
  Uint8List? imagemPerfilBytes;
  static final logicaCadastro _singleton =
  logicaCadastro._internal();

  logicaCadastro._internal();

  // Fábrica para retornar a única instância
  factory logicaCadastro() {
    return _singleton;
  }

  final picker = ImagePicker();
  Color corCamera = Colors.black;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> registerUser(String email, String password) async {
    try {
      final UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Usuário registrado: ${user.user?.email}");
      return true;
    } catch (e) {
      print("Erro ao registrar: $e");
      return false;
    }
  }

  Future<void> mostrarTermos(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            children: [
              Expanded(
                child: SizedBox(width: double.infinity,child:
                SfPdfViewer.asset(
                    'assets/pdf/termos.pdf'),
                ),
              ),
              const SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Entendi os termos de uso!', style: TextStyle(color: const Color(0xfff19b09)),)),
              SizedBox(height: 10,)
            ],
          ),
        );
      },
    );
  }

  Future<void> mostrarPolitica(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            children: [
              Expanded(
                child: Container(width: double.infinity,child:
                Container(
                    child: SfPdfViewer.asset(
                        'assets/pdf/privacidade.pdf')),
                ),
              ),
              SizedBox(height: 10,),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Entendi a politica de privacidade!', style: TextStyle(color: const Color(0xfff19b09)),)),
              SizedBox(height: 10,)
            ],
          ),
        );
      },
    );
  }

  // Future<bool> registerUser(String email, String password) async {
  //   try {
  //     final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //
  //     final User? user = userCredential.user;
  //     if (user != null) {
  //       await user.sendEmailVerification();
  //       print("Usuário registrado: ${user.email}. E-mail de verificação enviado.");
  //       return true;
  //     } else {
  //       print("Erro ao registrar: Usuário não encontrado");
  //       return false;
  //     }
  //   } catch (e) {
  //     print("Erro ao registrar: $e");
  //     return false;
  //   }
  // }

  Future<bool> loginUser(String email, String password) async {
    try {
      final UserCredential user = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Usuário logado: ${user.user?.email}");
      return true;
    } catch (e) {
      print("Erro ao logar: $e");
      return false;
    }
  }

  Future<bool> resetPass(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );
      print("E-mail de recuperação enviado");
      return true;
    } catch (e) {
      print("E-mail de recuperação não enviado $e");
      return false;
    }
  }

  Future<bool> signOutUser() async {
    try {
      await _auth.signOut();
      print("Usuário deslogado com sucesso!");
      return true;
    } catch (e) {
      print("Erro ao deslogar: $e");
      return false;
    }
  }

  bool verificaUsuarioLogado() {
    User? usuarioAtual = _auth.currentUser;

    if (usuarioAtual != null) {
      // O usuário está logado
      print('Usuário logado: ${usuarioAtual.email}');
      return true;
    } else {
      // Nenhum usuário está logado
      print('Nenhum usuário logado');
      return false;
    }
  }

  Future<List<int>> imageToBlob(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    return imageBytes;
  }


  Future<String> uploadImgPerfil({required Uint8List bytes, required String chatId}) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instance;
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = storage.ref().child('perfil/$chatId/$timestamp');

      // Upload da imagem usando putData
      await ref.putData(bytes);

      // Obtenção da URL da imagem
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Erro no upload da imagem: $e');
      return "";
    }
  }
}