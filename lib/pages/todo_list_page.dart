import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class TodoListPage extends StatelessWidget {


  final TextEditingController _controller = TextEditingController();

   TodoListPage({Key? key}) : super(key: key);

  void _addTask() {

    FirebaseFirestore.instance.collection("todos")
      .add({"title": _controller.text});

    _controller.text = "";

  }

   Widget _buildList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length, 
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        final map = doc.data(); 
        return ListTile(
          title: Text(map!["title"])
        );
      }
    );
  }


  

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: TextField(
                  controller: _controller,
              decoration: InputDecoration(hintText: "Enter task name"),
            )),
            FlatButton(
              child: Text("Add Task", style: TextStyle(color: Colors.white)),
              color: Colors.green,
              onPressed: () {
                _addTask();
              },
            )
          ],
        ),

       StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("todos").snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return LinearProgressIndicator();

            
            return Expanded(
              child: _buildList(snapshot.data!['title'])
            );
          } 
        )



      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: _buildBody(context),
    );
  }
}
