import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuifui_site_passageiro/sucesso/sucesso.dart';

class CustomWidgetsLogCad {
  //ALERTA LOGIN
  Widget errosLoginCad(
      {required String logOuCad,
        required BuildContext context,
        required Color cor,
        required int numAlert}) {
    if (logOuCad == 'login') {
      return CupertinoAlertDialog(
        title: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: const Text(
              'E-mail ou senha inválidos!',
              style: TextStyle(fontFamily: 'SourceSansPro'),
            )),
        content: const Text(
            'O seu e-mail ou senhas estão incorretos, tente novamente!',
            style: TextStyle(fontFamily: 'SourceSansPro')),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Tentar novamente',
                style: TextStyle(color: cor),
              ))
        ],
      );
    } else {
      if (numAlert == 1) {
        return CupertinoAlertDialog(
          title: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: const Text(
                'Cadastro efetuado com sucesso!',
                style: TextStyle(fontFamily: 'SourceSansPro'),
              )),
          content: const Text(
              'O seu cadastro foi realizado com sucesso!',
              style: TextStyle(fontFamily: 'SourceSansPro')),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Sucesso()),
                  );
                },
                child: Text(
                  'Baixar App',
                  style: TextStyle(color: cor),
                ))
          ],
        );
      } else {
        return CupertinoAlertDialog(
          title: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: const Text(
                'Erro ao efetuar o cadastro!',
                style: TextStyle(fontFamily: 'SourceSansPro'),
              )),
          content: const Text(
              'Verifique se  todos os campos foram preenchidos corretamente e tente novamente.',
              style: TextStyle(fontFamily: 'SourceSansPro')),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Tentar novamente',
                  style: TextStyle(color: cor),
                ))
          ],
        );
      }
    }
  }
}


class customWidgets {

  Color customColor() {
    return const Color(0xfff19b09);
  }
}