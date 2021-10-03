import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance";

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

/*
  CRIANDO OS CONTROLLERS PARA RECEBER O VALORES
*/
class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final arsController = TextEditingController();
  final yenController = TextEditingController();
  final libController = TextEditingController();

  double? dolar;
  double? euro;
  double? ars;
  double? yen;
  double? lib;

/*
  IMPLEMENTANDO AS CONVERSÕES PARA REAL
  PARA APARECER NO APLICATIVO
*/
  void _realChanged(String texto) {
    double real = double.parse(texto);
    dolarController.text = (real / dolar!).toStringAsFixed(2);
    euroController.text = (real / euro!).toStringAsFixed(2);
    arsController.text = (real / ars!).toStringAsFixed(2);
    yenController.text = (real / yen!).toStringAsFixed(2);
    yenController.text = (real / lib!).toStringAsFixed(2);
  }

  void _dolarChanged(String texto) {
    double _dolar = double.parse(texto);
    realController.text = (_dolar * dolar!).toStringAsFixed(2);
    euroController.text = (_dolar * dolar! / euro!).toStringAsFixed(2);
    arsController.text = (_dolar * dolar! / ars!).toStringAsFixed(2);
    yenController.text = (_dolar * dolar! / yen!).toStringAsFixed(2);
    libController.text = (_dolar * dolar! / lib!).toStringAsFixed(2);
  }

  void _euroChanged(String texto) {
    double _euro = double.parse(texto);
    realController.text = (_euro * euro!).toStringAsFixed(2);
    dolarController.text = (_euro * euro! / dolar!).toStringAsFixed(2);
    arsController.text = (_euro * euro! / ars!).toStringAsFixed(2);
    yenController.text = (_euro * euro! / yen!).toStringAsFixed(2);
    libController.text = (_euro * euro! / lib!).toStringAsFixed(2);
  }

  void _arsChanged(String texto) {
    double _ars = double.parse(texto);
    realController.text = (_ars * ars!).toStringAsFixed(2);
    dolarController.text = (_ars * ars! / dolar!).toStringAsFixed(2);
    euroController.text = (_ars * ars! / euro!).toStringAsFixed(2);
    yenController.text = (_ars * ars! / yen!).toStringAsFixed(2);
    libController.text = (_ars * ars! / lib!).toStringAsFixed(2);
  }

  void _yenChanged(String texto) {
    double _yen = double.parse(texto);
    realController.text = (_yen * yen!).toStringAsFixed(2);
    dolarController.text = (_yen * yen! / dolar!).toStringAsFixed(2);
    euroController.text = (_yen * yen! / euro!).toStringAsFixed(2);
    arsController.text = (_yen * yen! / ars!).toStringAsFixed(2);
    libController.text = (_yen * yen! / lib!).toStringAsFixed(2);
  }

  void _libChanged(String texto) {
    double _lib = double.parse(texto);
    realController.text = (_lib * lib!).toStringAsFixed(2);
    dolarController.text = (_lib * lib! / dolar!).toStringAsFixed(2);
    euroController.text = (_lib * lib! / euro!).toStringAsFixed(2);
    arsController.text = (_lib * lib! / ars!).toStringAsFixed(2);
    yenController.text = (_lib * lib! / yen!).toStringAsFixed(2);
  }

  /*
    IMPLEMENTANDO OS WIDGETS QUE SERÁ O FRONT END DO APP
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor de Moedas"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: pegarDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Erro ao Carregar os Dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                ars = snapshot.data!["results"]["currencies"]["ARS"]["buy"];
                yen = snapshot.data!["results"]["currencies"]["JPY"]["buy"];
                lib = snapshot.data!["results"]["currencies"]["GBP"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                        color: Colors.amber,
                      ),
                      construirTextField("Reais", "R\$", realController,
                          _realChanged), // aqui é configurado o que aparece na tela
                      Divider(),
                      construirTextField(
                          "Dolares", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      construirTextField(
                          "Euros", "€", euroController, _euroChanged),
                      Divider(),
                      construirTextField(
                          "Peso ARG", "\$", arsController, _arsChanged),
                      Divider(),
                      construirTextField(
                          "Yen JP", "\¥", yenController, _yenChanged),
                      Divider(),
                      construirTextField(
                          "LIBRA UK", "\£", libController, _libChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget construirTextField(
    String texto, String prefixo, TextEditingController c, Function(String) f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: texto,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefixo,
    ),
    style: TextStyle(
      color: Colors.amber,
      fontSize: 25,
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}

/*
  pegando os dados da api
 */
Future<Map> pegarDados() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}
