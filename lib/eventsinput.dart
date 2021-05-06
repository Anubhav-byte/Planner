import 'package:flutter/material.dart';
import 'package:notekeeper/model/notes.dart';
import 'package:notekeeper/util/databasehelper.dart';
class NoteInput extends StatefulWidget {
  @override
  _NoteInputState createState() => _NoteInputState();
}

class _NoteInputState extends State<NoteInput> {
  List<String> _priorities=['Low','High'];
  String value ='Low';
  int priority=1;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DatabaseHelper databaseHelper= DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            ListTile(
              title: DropdownButton(
                  items: _priorities.map<DropdownMenuItem<String>>(
                      (String dropDownStringItem){
                        return DropdownMenuItem(
                          value: dropDownStringItem,
                          child: Text(dropDownStringItem),
                        );
                      }
                  ).toList(),
                onChanged: (value){
                  setState(() {
                    this.value=value;
                  });
                },
                value: value,
              ),
            ),
            SizedBox(height: 20.0,),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",

                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      style: BorderStyle.solid
                  )
                )

              ),
            ),
            SizedBox(height: 20.0,),
            TextField(
              controller: descriptionController ,
              decoration: InputDecoration(
                labelText: "Description",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                        style: BorderStyle.solid
                  )
                )

              ),
            ),
          SizedBox(height: 10.0,),
          Row(
              children: [
              Expanded(
                child: TextButton(
                  onPressed: (){
                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL")),
              ),
              SizedBox(width: 5.0,),
              Expanded(
                child: ElevatedButton(
                  onPressed: insertToDatabase,
                  child: Text("SAVE")),
              ),
           ]
          )
          ],
        ),
      ),
    );
  }

  int getPriority(var value){
      return value=='Low'?2:1;
  }

  Future<void> insertToDatabase() async {
    int priorityValue= getPriority(this.value);
    Note note = Note(
      title: titleController.text,
      date:'05/05/21',
      priority: priorityValue,
      description: descriptionController.text
    );
    DatabaseHelper databaseHelper = DatabaseHelper();
    databaseHelper.insertNoteData(note);
    Navigator.pop(context);
  }
}
