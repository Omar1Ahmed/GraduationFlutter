import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb{

Database?  _dataBase;

Future<Database?> get database async {
  if(_dataBase == null){
    _dataBase = await initiaDB();
    return _dataBase;
  }else{
    return _dataBase;
  }
}

initiaDB () async {
  String databasePath = await getDatabasesPath();
  String path = join(databasePath, 'DB.db');

  Database database = await openDatabase(path, version: 1, onCreate: _onCreate, readOnly: false);
  return database;
}

_onCreate(Database database, int version) async {
  await database.execute('''
      CREATE TABLE "Meetings" ("meeting_id" INTEGER PRIMARY KEY ,
                     "time" time,
                      "date" date,
                       "about" text,
                        "in_or_Out" text,
                         "address" text ,
                          "notes" text ,
                            "person" text,
                            "updatedAt" text,
                            "createdAt" text,
                             "attachmentLink" longText,
                             "attachmentName" text,
                             "status" text)
  ''');
  await database.execute(
      "CREATE TABLE `notes` (\n" +
      "  `notes_id` INTEGER PRIMARY KEY,\n" +
      "  `title` varchar(255) NOT NULL,\n" +
      "  `content` longtext DEFAULT NULL,\n" +
      "  `meeting_id` INTEGER DEFAULT 0 ,\n" +
      "  `manager_id` INTEGER DEFAULT 0,\n" +
      "  `updatedAt` datetime NOT NULL,\n" +
          "'about' varchar,\n"+
          "'date' date ,\n"+
          "'person' varchar(255))");

  await database.execute('''CREATE TABLE "meeting_Manager" (
  "manager_id" int(3) NOT NULL,
  "meeting_id" int(3) NOT NULL
  )''');

  await database.execute('''CREATE TABLE "Notifications" (
  "notification_id" int(3) NOT NULL,
  "person" varchar NOT NULL,
   "createdAt" date
  )''');
  print('DB Created');
}

insertData(String sql, List<String> list) async {
  Database? db = await database;
  int response = -1 ;
  try{
   response = await db!.rawInsert(sql,list);
  }catch(e){
    print(e);
  }
  return response;
}
deleteData(String sql) async {
  Database? db = await database;
  int response = await db!.rawDelete(sql);
  return response;
}

readData(String sql) async {
  Database? db = await database;
  List<Map> response = await db!.rawQuery(sql);

  return response;
}

updateData(String sql, List<String> list) async {
  Database? db = await database;
  int response = -1;
  try {
    response = await db!.rawUpdate(sql, list);
  }catch(e){
    print(e);
  }
    return response;


}

deleteAllData(String sql) async {
  Database? db = await database;
  int response = await db!.rawDelete(sql);
}
}