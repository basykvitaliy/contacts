import 'package:flutter/material.dart';

import 'db/DatabaseRepository.dart';
import 'model/ContactModel.dart';

class AddContactScreen extends StatefulWidget {
  AddContactScreen({this.contact, Key key, this.updateListContact})
      : super(key: key);

  final Contact contact;
  final Function updateListContact;

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  String _name = "";
  String _num = "";
  String _num2 = "";

  final _keys = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  String initialCountry = 'NG';

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _name = widget.contact.name;
      _num = widget.contact.num;
      _num2 = widget.contact.num2;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _keys,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "Имя*"),
                  validator: (input) =>
                      input.trim().isEmpty ? "Введите имя" : null,
                  initialValue: _name,
                  onSaved: (input) => _name = input,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Телефон*"),
                  validator: (input) =>
                      input.trim().isEmpty ? "Введите телефон" : null,
                  initialValue: _num,
                  onSaved: (input) => _num = input,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Дом. телефон"),
                  // validator: (input) =>
                  //     input.trim().isEmpty ? "Enter phone" : null,
                  initialValue: _num2,
                  onSaved: (input) => _num2 = input,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50, left: 16, right: 16),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextButton(
                    child: Text(
                      widget.contact == null ? "ADD" : "UPDATE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: _submit),
              ),
              widget.contact != null
                  ? Container(
                      margin: EdgeInsets.only(top: 20, left: 16, right: 16),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        child: Text(
                          "DELETE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: _delete,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_keys.currentState.validate()) {
      _keys.currentState.save();
      final contact = Contact(name: _name, num: _num, num2: _num2);
      if (widget.contact == null) {
        DatabaseRepository.instance.insert(contact);
      } else {
        contact.id = widget.contact.id;
        DatabaseRepository.instance.update(contact);
      }
      widget.updateListContact();
      Navigator.pop(context);
    }
  }

  void _delete() {
    DatabaseRepository.instance.delete(widget.contact.id);
    widget.updateListContact();
    Navigator.pop(context);
  }
}
