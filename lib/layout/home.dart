
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../shared/component/component.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';

class HomeLayout extends StatelessWidget
{

  late Database database;
  var scaffoldKey=GlobalKey<ScaffoldState>();
  late final GlobalKey<FormState> formKey =GlobalKey<FormState>();

  var titleController= TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();





  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   createDatebase();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AppCubit()..createDatabase();
      },
      child: BlocConsumer<AppCubit,AppState>(
        listener: (BuildContext context, AppState state) {  },
        builder: (BuildContext context, AppState state) {
         return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title:Text(

                '${AppCubit.get(context).title[AppCubit.get(context).i]}',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300
                ),
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! GetDataLoadingDatabase,
              builder:(context)=>AppCubit.get(context).screens[AppCubit.get(context).i],
              fallback: (context)=>Center(child: CircularProgressIndicator(),),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()  {
                // if(formKey.currentState!.validate()){
                //   print('sss');
                // }

                if(!AppCubit.get(context).isBottomSheet){
                  if(formKey.currentState!.validate()){
                    AppCubit.get(context).insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text).then((value) {

                      // getDataFromDatabase(database).then((value){
                         Navigator.pop(context);
                      //   // setState(() {
                      //   //
                      AppCubit.get(context).changeBottomSheetState(isShow: true, icon: Icons.edit);
                      //   //   icons=Icons.edit;
                      //   //
                      //   //   tasks=value;
                      //   //   print(tasks[0]);
                      //   // });
                      // });
                    });
                  }
                }else  {
                  scaffoldKey.currentState?.showBottomSheet((context) =>
                      Container(
                        color: Colors.white,

                        padding: EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultTextFormField(controller: titleController, type: TextInputType.text, label: 'Title', prefixIcon: Icons.title, kind: 'title'),
                              SizedBox(height: 20,),
                              defaultTextFormField(controller: timeController, type: TextInputType.datetime, label: 'Time', prefixIcon: Icons.watch_later_outlined, kind: 'Time',onTab: () {
                                print('Timing taped');
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
                                  timeController.text= value?.format(context)as String;
                                });
                              }),
                              SizedBox(height: 20,),
                              defaultTextFormField(controller: dateController, type: TextInputType.datetime, label: 'Date', prefixIcon: Icons.date_range_outlined, kind: 'Date',onTab: (){
                                print('taped date');
                                showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2024)).then((value){
                                  print(DateFormat.yMMMd().format(value!));
                                  dateController.text=DateFormat.yMMMd().format(value!);
                                });
                              }),

                            ],
                          ),
                        ),
                      ),
                    elevation: 20,
                  ).closed.then((value){

                    AppCubit.get(context).changeBottomSheetState(isShow: true, icon: Icons.edit);

                   // isBottomSheet=true;
                    // setState((){
                    //   icons=Icons.edit;
                    // });
                  });

                  AppCubit.get(context).changeBottomSheetState(isShow: false, icon: Icons.add);

                  //  isBottomSheet=false;
                  // setState(() {
                  //   icons=Icons.add;
                  // });

                }
              },
              child: Icon(AppCubit.get(context).icons),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 50,
              currentIndex: AppCubit.get(context).i,
              onTap: (index){

                AppCubit.get(context).changeIndex(index);

              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.task_outlined),
                    label: "Task"
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',

                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: 'Archive'
                ),
              ],
            ),
          );
        },

      ),
    );
  }


  // Future<String>  getName() async{
  //   return 'mahmoud Elkady';
  // }




}



