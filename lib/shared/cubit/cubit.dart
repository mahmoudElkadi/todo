import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'package:untitled/shared/cubit/states.dart';

import '../../modules/Archive/archive.dart';
import '../../modules/Done/done.dart';
import '../../modules/tasks/tasks.dart';
import '../component/constats.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit():super(AppInitState());

  static AppCubit get(context)=> BlocProvider.of(context);

  int i=0;
  late Database database;

  List <Widget>screens=[
    TasksScreen(),
    DoneScreen(),
    ArchiveScreen(),

  ];
  List<String>title=['New Tasks','Done Tasks','Archived Tasks'];
  void createDatabase1()async{
    database = await openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database,version){
          print('database created');

          database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT ,status TEXT,time TEXT)').then((value){
            print('created');
          }).catchError((err){
            print('erorr ${err.toString()}');
          });


        },
        onOpen: (database)
        {

          getDataFromDatabase(database);
          print('database opened') ;

        }
    ).then((value) {
    return database=value;

  });
  }



   insertToDatabase({
    required String title,
    required String time,
    required String date
  })async{
     await database.transaction((txn) {
      return txn.rawInsert('INSERT INTO tasks(title ,date ,status,time) VALUES("$title","$date", "Active", "$time")').then((value) {
        print('$value inserted');
        emit(InsertIntoDatabase());

        getDataFromDatabase(database);

      });


    });
  }

  void getDataFromDatabase(database){
    newTasks=[];
    doneTasks=[];
    archiveTasks=[];


    emit(GetDataLoadingDatabase());
     database.rawQuery('SELECT * FROM tasks').then((value){

       value.forEach((element) {
         if(element['status']=='Active'){
           newTasks.add(element);
         }else if(element['status']=='done'){
           doneTasks.add(element);
         }else if(element['status']=='archive'){
           archiveTasks.add(element);
         }
       });

       print(newTasks);

       emit(GetDataFromDatabase());


     });


  }

  void updateData({
  required String status,
  required int id
})async{
     database.rawUpdate(
        'UPDATE tasks SET status = ?  WHERE id = ?',
        ['$status', '$id' ]).then((value) {
       getDataFromDatabase(database);
          emit(UpdateDatabase());
     });
    
  //  print('updated: $count');
  }

  void deleteData({ required int id })async{
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', ['$id']).then((value){
          getDataFromDatabase(database);
          emit(DeleteDatabase());
    });
  }

  void changeIndex(int index){
    i=index;
    emit(AppChangeBottomNavBar());
  }

  void createDatabase(){
    createDatabase1();
    emit(CreateDatabaseState());
  }

  bool isBottomSheet=true;
  var icons=Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
}){
    isBottomSheet=isShow;
    icons=icon;

    emit(AppChangeBottomSheetState());
  }

}

