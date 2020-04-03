import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //atributos
  double dolar;
  double euro;

  //controladores dos campos de textos
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  //métodos para conversão das moedas
  void _realCampoAlterado(String texto){
    if(texto.isEmpty){
      _limparCampos();
    }else{
      double real = double.parse(texto);
      dolarController.text = (real/dolar).toStringAsFixed(2);
      euroController.text = (real/euro).toStringAsFixed(2);
    }
  }
  void _dolarCampoAlterado(String texto){
    if(texto.isEmpty){
      _limparCampos();
    }else{
      double dolar = double.parse(texto);
      realController.text = (dolar * this.dolar).toStringAsFixed(2);
      euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
    }
  }
  void _euroCampoAlterado(String texto){
    if(texto.isEmpty){
      _limparCampos();
    }else{
      double euro = double.parse(texto);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
    }
  }
  //método para limpeza dos campos
  void _limparCampos(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      ///como será utilizado um dado futuro,
      ///é necessário que o body receba um FutureBuilder (no caso do tipo Map,
      ///porque a função getData() retorna um Map),
      ///além diddo, é necessário especificar o que vai ser recebido no parâmetro "future"
      ///e no builder do FutureBuilder é necessário informar: "context e snapshot"
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return carregandoDados();
            default:
              if(snapshot.hasError){
                return erroAoCarregarDados();
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150,
                          color: Colors.amber,
                      ),
                      campoDeTexto("Real", "R\$ ", realController, _realCampoAlterado),
                      Divider(),
                      campoDeTexto("Dolar", "US\$ ", dolarController, _dolarCampoAlterado),
                      Divider(),
                      campoDeTexto("Euro", "€ ", euroController, _euroCampoAlterado)
                    ],
                  ),
                );
              }
          }
        },),
    );
  }

  Center erroAoCarregarDados() {
    return Center(
                child: Text("Erro ao Carregar Dados!",
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25
                  ),
                  textAlign: TextAlign.center,
                ),
              );
  }

  Center carregandoDados() {
    return Center(
              child: Text("Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25
                  ),
                textAlign: TextAlign.center,
              ),
            );
  }

  TextFormField campoDeTexto(String label, String prefixo, TextEditingController controller, Function f){
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Colors.amber
          ),
          border: OutlineInputBorder(),
          prefixText: prefixo
      ),
      style: TextStyle(
          color: Colors.amber,
          fontSize: 25
      ),
      //TextInputType.number só funciona no android
      //keyboardType: TextInputType.number,
      //TextInputType.numberWithOptions(decimal: true) funciona no iOS e android
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: f,
    );
  }
}

///preparação para obter dados através de uma api
///requisição
const request = "https://api.hgbrasil.com/finance?format=json&key=24d7a889";
///requisição para api de moedas
Future<Map> getData() async {
  http.Response response = await http.get(request);
  var dados = json.decode(response.body);
  return dados;
}
