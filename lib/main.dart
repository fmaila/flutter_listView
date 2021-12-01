import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/Gif.dart';

void main() {
  // 1
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Empresa _facebook = new Empresa('Face', 'norte', 245);
  Empresa _google = new Empresa('Goo', 'sur', 128);

  Future<List<Gif>>? _listGifs;

 Future<List<Gif>> _getGifs() async{
   var url = Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=xictvg07oFGIK6jnutZRa7GhUjD6rL0Z&limit=10&rating=g");
   final response = await http.get(url);
   List<Gif> gifs =[];

 if(response.statusCode == 200){
   //print(response.body);
   String body = utf8.decode(response.bodyBytes);
   final jsonData= jsonDecode(body);
   //print(jsonData["data"][1]["id"]);
   for(var item in jsonData["data"]){
     gifs.add(
       Gif(item["title"],item["images"]["downsized"]["url"])
     );
   }

   return gifs;


 }else{
   throw Exception("Fallo la conexiòn");
 }
 }

  List<Persona> _personas = [
    Persona('jose', 'amsk', '1234343'),
    Persona('manuel', 'jose', '1234343'),
    Persona('mrad', 'jose', '1234343'),
    Persona('dfdf', 'jose', '1234343'),
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _listGifs =_getGifs();

    print(_facebook.nombre);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Api Rest'),),
            body: ListView.builder(
              itemCount: _personas.length,
                itemBuilder: (context, index) {
          return ListTile(
            onLongPress: (){
             _borrarPersona(context, _personas[index]);
            },
              title: Text(_personas[index].name!+ ' ' + _personas[index].lastname!),
          subtitle: Text(_personas[index].phone!),
            leading: CircleAvatar(
              child: Text(_personas[index].name!.substring(0,1)),
            ),
            trailing: Icon(Icons.arrow_forward_ios),

                  );

        })
        ),
      ),
    );
  }

  _borrarPersona(context,Persona persona){
    showDialog(context: context,
        builder: (_)=> AlertDialog(
          title: Text('Eliminar contacto'),
          content: Text("Esta seguro de eliminar a"+persona.name! +'?'),
          actions: [
            FloatingActionButton(onPressed: (){
              Navigator.pop(context);
            },
            child: Text('cancelar'),
            ),
            FloatingActionButton(onPressed: (){
              print(persona.name);
              this.setState((

                  ) {
                this._personas.remove(persona);
              });

              Navigator.pop(context);
            },
              child: Text('Borrar',style: TextStyle(color:Colors.red),),
            )
          ],

        ));
  }
}

class Empresa {
  String? nombre;
  String? direccion;
  int? numero;

  Empresa(String n, String d, int number) {
    this.nombre = n;
    this.direccion = d;
    this.numero = number;
  }
}

class Persona {
  String? name;
  String? lastname;
  String? phone;
  Persona(String name, String lastname, String phone) {
    this.name = name;
    this.lastname = lastname;
    this.phone = phone;
  }
}

