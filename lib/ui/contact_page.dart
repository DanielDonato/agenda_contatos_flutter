import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;
  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    }else{
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              Navigator.pop(context, _editedContact);
            }else{
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _editedContact.img != null ? FileImage(File(_editedContact.img)) : AssetImage("images/person.png")
                      )
                  ),
                ),
                onTap: (){
                  ImagePicker.pickImage(source: ImageSource.camera) //TODO Colocar suporte a galeria
                    .then((file){
                      if(file == null){
                        return;
                      }
                      setState(() {
                        _editedContact.img = file.path;
                      });
                  });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.email = text;
                },
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.phone = text;
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
      builder: (context)  => AlertDialog(
        title: Text("Descartar Alterações"),
        content: Text("Se sair as alteraçõe serão perdidas"),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancelar"),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text("Sim"),
            onPressed: (){
              Navigator.pop(context); // sai do dialogo
              Navigator.pop(context); // sai da tela
            },
          )
        ],
      )
      );
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

}

