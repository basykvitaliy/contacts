import 'package:flutter/material.dart';

import 'AddContactScreen.dart';
import 'db/DatabaseRepository.dart';
import 'model/ContactModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Contact>> _listContact;

  @override
  void initState() {
    _updateContactList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: FutureBuilder(
        future: _listContact,
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return _buildNote(snapshot.data[index]);
                      })),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddContactScreen(
                        updateListContact: _updateContactList,
                      )));
        },
      ),
    );
  }

  void _updateContactList() {
    setState(() {
      _listContact = DatabaseRepository.instance.getContactList();
    });
  }

  Widget _buildNote(Contact contact) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              contact.name,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.num,
                ),
                Text(
                  contact.num2,
                ),
              ],
            ),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddContactScreen(
                      updateListContact: _updateContactList,
                      contact: contact))),
        ),
        Divider(),
      ],
    );
  }
}
