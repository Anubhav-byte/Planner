import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notekeeper/eventsinput.dart';
import 'package:notekeeper/model/notes.dart';
import 'package:notekeeper/util/databasehelper.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  DatabaseHelper databaseHelper= DatabaseHelper();
  List<Note> noteList;
  int count=0;
  @override
  Widget build(BuildContext context) {
    getNoteData();
    return Scaffold(
      appBar: AppBar(
          title:Text("Planner"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(CupertinoIcons.plus),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NoteInput() )
          );
          },
      ),
      body: getNoteView(),
    );
  }

  ListView getNoteView() {
      return ListView.builder(
          itemCount: count ,
          itemBuilder:(BuildContext context, int index){
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: Text("${noteList[index].title}"),
                subtitle: Text("${noteList[index].description}"),
                leading: CircleAvatar(
                  backgroundColor: getPriorityColor(noteList[index].priority),
                  child: getPriorityIcon(noteList[index].priority),
                ),
                trailing:GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: (){
                    showDialog(
                    context: context,
                    builder:(context){
                      return deleteDialog(noteList[index].id);
                    });
                  },
                ),
            )
          );
          });
      }

      //Returns the priority color
  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;

    }
  }

  //Returns the priority icon
  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  //Delete from ListView
  Future<void> _delete(int id) async{
    await databaseHelper.deleteNoteData(id);
    var data = await databaseHelper.getNoteData();
    setState(() {
      noteList = data;
      count = noteList.length;
    });
  }

  //Get data from Database
  Future<void> getNoteData() async {
    var result = await databaseHelper.getNoteData();
    setState(() {
      noteList = result;
      count = noteList.length;
    });
  }

  //Show Dialog
  deleteDialog(int id){
    return Dialog(
      shape: BeveledRectangleBorder(),
      child: Container(
        height: 110,
        width: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text(
                  "Do you want to delete it ?",
                  style: TextStyle(

                  ),
                ),

                ButtonBar(
                  children: [
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("NO")),
                    ElevatedButton(
                        onPressed: (){
                          _delete(id);
                          Navigator.pop(context);

                        },
                        child: Text("YES"))
                  ],
                )
              ]


          ),
        ),
      ),
    );
  }


}

