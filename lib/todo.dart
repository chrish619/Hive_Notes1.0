import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
 

  @HiveField(0)
  String name;

  @HiveField(1)
  bool isChecked;

  
   Todo({required this.name, required this.isChecked,});
}
