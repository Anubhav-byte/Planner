class Note {
  int id;
  final String title;
  final String description;
  final String date;
  final int priority;


  Note({this.title, this.date, this.priority, this.description});
  Note.fromId({this.id,this.title,this.date,this.priority,this.description});

  Map<String,dynamic> toMap(){
    return{
      'title':title,
      'date':date,
      'priority': priority,
      'description':description
    };
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, description: $description, date: $date, priority: $priority}';
  }
}

