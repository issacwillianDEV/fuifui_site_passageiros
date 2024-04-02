import 'dart:io';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fuifui_site_passageiro/cadastro/widgets.dart';
import 'package:fuifui_site_passageiro/sucesso/sucesso.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'database.dart';
import 'logica.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _InicioState();
}

class _InicioState extends State<Cadastro> {
  IconData _iconeShowHide = Icons.visibility;

  //  Logica
  CustomWidgetsLogCad widgetsCustomizados = CustomWidgetsLogCad();
  logicaCadastro logicaCadastrar = logicaCadastro();
  Databases database = Databases();

  // CAMERA
  final _picker = ImagePicker();
  String _imagemPerfil = 'imagens/imagem_perfil/perfil.png';
  Color _corCamera = Colors.black;

  // NOME COMPLETO
  final _formKeyNome = GlobalKey<FormState>();
  final _nomeControle = TextEditingController();

  // TELEFONE
  final _telefoneFocus = FocusNode();
  final _formKeyTelefone = GlobalKey<FormState>();
  final _telefoneControle = MaskedTextController(mask: '(00) 00000-0000');

  // E-MAIL
  final _emailFocus = FocusNode();
  final _formKeyEmail = GlobalKey<FormState>();
  final _emailControle = TextEditingController();

  // SENHA
  final _passwordFocus = FocusNode();
  final _formKeySenha = GlobalKey<FormState>();
  final _senhaControle = TextEditingController();
  bool _showHidePass = true;

  // BOTÃO FAZER CADASTRO
  final List<int> _erros = [1, 2, 3, 4];

  customWidgets widgetsCustomizado = customWidgets();

  bool retornobd = false;

  bool termosDeUso = false;
  bool politica = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFFffffff), // Cor da barra de navegação
      systemNavigationBarIconBrightness: Brightness
          .dark, // Ícones da barra de navegação (isso os tornará escuros se a barra for clara)
    ));

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    child: Image.asset(
                      'assets/imagens/logo/logo-ff.png',
                      height: 130,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    width: double.infinity,
                    child: Center(
                        child: Text(
                          'Fazer cadastro',
                          style: GoogleFonts.mulish(
                              fontSize: 32, fontWeight: FontWeight.w700),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: double.infinity,
                    child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Abra sua conta agora, sem complicações, e solicite um motorista de maneira inovadora!',
                          style: GoogleFonts.mulish(
                              fontSize: 17, fontWeight: FontWeight.w300),
                        )),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Form(
                      key: _formKeyNome,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        onFieldSubmitted: (term) {
                          // Quando o usuário pressiona "Next" no teclado, muda o foco para o campo de senha
                          FocusScope.of(context).requestFocus(_telefoneFocus);
                        },
                        validator: (value) {
                          String pattern =
                              r'^[a-zA-ZÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç\s-]{2,}\s[a-zA-ZÁÉÍÓÚáéíóúÂÊÔâêôÃÕãõÇç\s-]{2,}$';
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value!)) {
                            _erros.add(1);
                            return 'Insira o seu nome completo';
                          } else {
                            _erros.removeWhere((element) => element == 1);
                            return null;
                          }
                        },
                        controller: _nomeControle,
                        cursorColor: const Color(0xFF727272),
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: Container(
                                margin: const EdgeInsets.all(15),
                                child: const Icon(
                                  CommunityMaterialIcons.account,
                                  size: 35,
                                  color: Color(0xFF727272),
                                )),
                            labelText: 'Nome completo',
                            filled: true,
                            fillColor: const Color(0xFFdcdcdc),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove a borda externa
                              borderRadius:
                              BorderRadius.circular(15), // Arredonda os cantos
                            ),
                            labelStyle: const TextStyle(
                                color: Color(0xFF727272),
                                fontFamily: 'SourceSansPro',
                                fontSize: 18)),
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Form(
                      key: _formKeyTelefone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        focusNode: _telefoneFocus,
                        onFieldSubmitted: (term) {
                          // Quando o usuário pressiona "Next" no teclado, muda o foco para o campo de senha
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                        validator: (value) {
                          if (value!.length <= 13) {
                            _erros.add(2);
                            return 'Insira um telefone válido';
                          } else {
                            _erros.removeWhere((element) => element == 2);
                            return null;
                          }
                        },
                        controller: _telefoneControle,
                        cursorColor: const Color(0xFF727272),
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: Container(
                                margin: const EdgeInsets.all(15),
                                child: const Icon(
                                  CommunityMaterialIcons.phone,
                                  size: 35,
                                  color: Color(0xFF727272),
                                )),
                            labelText: 'Telefone',
                            filled: true,
                            fillColor: const Color(0xFFdcdcdc),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove a borda externa
                              borderRadius:
                              BorderRadius.circular(15), // Arredonda os cantos
                            ),
                            labelStyle: const TextStyle(
                                color: Color(0xFF727272),
                                fontFamily: 'SourceSansPro',
                                fontSize: 18)),
                      ),
                    ),
                  ), // TELEFONE

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                    child: Form(
                      key: _formKeyEmail,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        focusNode: _emailFocus,
                        onFieldSubmitted: (term) {
                          // Quando o usuário pressiona "Next" no teclado, muda o foco para o campo de senha
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        validator: (value) {
                          String pattern =
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$'; // Expressão regular para validar e-mail
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(value!)) {
                            _erros.add(3);
                            return 'Insira um e-mail válido';
                          } else {
                            _erros.removeWhere((element) => element == 3);
                            return null;
                          }
                        },
                        controller: _emailControle,
                        cursorColor: const Color(0xFF727272),
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: Container(
                                margin: const EdgeInsets.all(15),
                                child: const Icon(
                                  CommunityMaterialIcons.email,
                                  size: 35,
                                  color: Color(0xFF727272),
                                )),
                            labelText: 'E-mail',
                            filled: true,
                            fillColor: const Color(0xFFdcdcdc),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove a borda externa
                              borderRadius:
                              BorderRadius.circular(15), // Arredonda os cantos
                            ),
                            labelStyle: const TextStyle(
                                color: Color(0xFF727272),
                                fontFamily: 'SourceSansPro',
                                fontSize: 18)),
                      ),
                    ),
                  ), // E-MAIL

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Form(
                      key: _formKeySenha,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        controller: _senhaControle,
                        obscureText: _showHidePass,
                        focusNode: _passwordFocus,
                        validator: (value) {
                          if (value!.length >= 2 && value.length <= 6) {
                            _erros.add(4);
                            return 'A senha deve conter pelo menos 6 caracteres';
                          } else {
                            _erros.removeWhere((element) => element == 4);
                            return null;
                          }
                        },
                        cursorColor: const Color(0xFF727272),
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _iconeShowHide,
                                color: const Color(0xFF727272),
                              ),
                              onPressed: () {
                                setState(() {
                                  _showHidePass = !_showHidePass;
                                  if (_showHidePass) {
                                    _iconeShowHide = Icons.visibility;
                                  } else {
                                    _iconeShowHide = Icons.visibility_off;
                                  }
                                });
                              },
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            prefixIcon: Container(
                                margin: const EdgeInsets.all(15),
                                child: const Icon(
                                  CommunityMaterialIcons.lock,
                                  size: 35,
                                  color: Color(0xFF727272),
                                )),
                            labelText: 'Senha',
                            filled: true,
                            fillColor: const Color(0xFFdcdcdc),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // Remove a borda externa
                              borderRadius:
                              BorderRadius.circular(15), // Arredonda os cantos
                            ),
                            labelStyle: const TextStyle(
                                color: Color(0xFF727272),
                                fontFamily: 'SourceSansPro',
                                fontSize: 18)),
                      ),
                    ),
                  ), // SENHA

                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: const Text(
                      'Foto de perfil(Opcional)\nClique na câmera para selecionar uma foto.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, fontFamily: 'SourceSansPro'),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: ClipOval(
                        child: Stack(children: [
                          if (logicaCadastrar.imagemPerfilBytes != null)
                            Positioned.fill(
                              child: Image.memory(logicaCadastrar.imagemPerfilBytes!,
                                  fit: BoxFit.cover),
                            ),
                          if (logicaCadastrar.imagemPerfilBytes == null)
                            Positioned.fill(
                              child: Image.asset(
                                  fit: BoxFit.cover,
                                  'assets/imagens/imagem_perfil/perfil.png'),
                            ),
                          Center(
                            child: IconButton(
                              onPressed: () async {
                                final XFile? image = await logicaCadastrar.picker
                                    .pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  image.readAsBytes().then((bytes) {
                                    setState(() {
                                      logicaCadastrar.imagemPerfilBytes = bytes;
                                      logicaCadastrar.corCamera =
                                          widgetsCustomizado.customColor();
                                    });
                                  });
                                } else {
                                  setState(() {
                                    logicaCadastrar.imagemPerfilBytes = null;
                                    logicaCadastrar.corCamera = Colors.black;
                                  });
                                }
                              },
                              icon: Icon(
                                FontAwesomeIcons.camera,
                                size: 40,
                                color: logicaCadastrar.corCamera,
                              ),
                            ),
                          )
                        ])),
                  ), // NOME COMPLETO

                  const SizedBox(
                    height: 30,
                  ), // NOME COMPLETO
                  Row(
                    children: [
                      Checkbox(
                          activeColor: widgetsCustomizado.customColor(),
                          value: termosDeUso,
                          onChanged: (bool? value) {
                            setState(() {
                              termosDeUso = value!;
                            });
                          }),
                      Flexible(
                        child: Text('Sim, eu aceito termos de uso do passageiro',
                            style: GoogleFonts.mulish(fontSize: 18)),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //         onPressed: () {
                  //           logicaCadastrar.mostrarTermos(context);
                  //         },
                  //         child: Text('> Veja os termos de uso',
                  //             style: GoogleFonts.mulish(
                  //                 fontSize: 18,
                  //                 color: widgetsCustomizado.customColor()))),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: widgetsCustomizado.customColor(),
                          value: politica,
                          onChanged: (bool? value) {
                            setState(() {
                              politica = value!;
                            });
                          }),
                      Flexible(
                        child: Text(
                            'Sim, eu aceito termos de politica de privacidade',
                            style: GoogleFonts.mulish(fontSize: 18)),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     TextButton(
                  //         onPressed: () {
                  //           logicaCadastrar.mostrarPolitica(context);
                  //         },
                  //         child: Text('> Veja a politica de privacidade',
                  //             style: GoogleFonts.mulish(
                  //                 fontSize: 18,
                  //                 color: widgetsCustomizado.customColor()))),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 30,
                  ),

                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                      width: double.infinity,
                      height: 60,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                widgetsCustomizado.customColor(),
                              ),
                            ),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: widgetsCustomizado.customColor(),
                                        ),
                                        const SizedBox(width: 20),
                                        const Text("Carregando..."),
                                      ],
                                    ),
                                  );
                                },
                              );

                              if (politica && termosDeUso) {
                                if (_erros.isEmpty) {
                                  bool retorno = await logicaCadastrar.registerUser(
                                      _emailControle.text, _senhaControle.text);
                                  if (retorno) {
                                    retornobd = await database.cadastrarUsuario(
                                        nome: _nomeControle.text,
                                        telefone: _telefoneControle.text,
                                        email: _emailControle.text,
                                        perfil: _imagemPerfil);
                                  } else {
                                    retornobd = false;
                                  }
                                  Navigator.of(context).pop();
                                  if (retorno && retornobd) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (context) => Sucesso()),
                                    );
                                  } else {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return widgetsCustomizados.errosLoginCad(
                                            logOuCad: 'cadastro',
                                            context: context,
                                            cor: widgetsCustomizado.customColor(),
                                            numAlert: 2);
                                      },
                                    );
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return widgetsCustomizados.errosLoginCad(
                                          logOuCad: 'cadastro',
                                          context: context,
                                          cor: widgetsCustomizado.customColor(),
                                          numAlert: 2);
                                    },
                                  );
                                }
                              }else{
                                Navigator.of(context).pop();
                                QuickAlert.show(
                                  context: context,
                                  title: 'Você precisa aceitar os termos do nosso app!',
                                  type: QuickAlertType.error,
                                  confirmBtnColor: widgetsCustomizado
                                      .customColor(),
                                  confirmBtnText: 'Verificar',
                                  text: 'Para fazer parte da nossa plataforma você deve estar condizente com os termos de uso da nossa plataforma!',
                                );
                              }
                            },
                            child: Text(
                              'Cadastrar agora',
                              style: GoogleFonts.mulish(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )),
                      )),
                ],
              ),
            ),
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailControle.dispose();
    _senhaControle.dispose();
    super.dispose();
  }
}
