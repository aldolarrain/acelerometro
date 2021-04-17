import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sensors/sensors.dart';
void main() => runApp(MiApp());
//primer widget inmutable
class MiApp extends StatelessWidget {
  const MiApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     title: "Mi App",
     home: Inicio(),//Llamar funcion mutable
    );
  }
}
//Funcion /widget mutable
class Inicio extends StatefulWidget {
  Inicio({Key key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  Future<String> sendData()async{
     String cadena = "{'NameDevice': 'prueba1','EventDate': '2021-03-02T21:10:45', 'Event': 'dose'}";
     var data = json.encode(cadena);
     var response = await http.post(
       Uri.encodeFull("https://apiproductoraldo.azurewebsites.net/api/data"),
       headers:{"Content-Type": "Application/json"},
       body: jsonEncode(<String,String>{
         "NameDevice": "SM J260M",
         "EventDate": DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now()).toString(), 
         "Event": "Button.click"
       })
     );
     print(response.body);
    return response.body;
  }

@override
void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        sendData();
        print("Desde el Acelerometro");
      });
    }));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text("Mi App Aldo")
       ),
       body: Center(
         child: new ElevatedButton(
           onPressed: sendData,
            child: new Text("Enviar Datos")
            ),
       ),
    );
  }
}