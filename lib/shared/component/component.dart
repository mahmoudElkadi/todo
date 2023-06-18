
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  IconData ?suffixIcon,
  bool isPass=false,
  Function()? showPass,
  Function()? onTab,
  required String label,
  required IconData prefixIcon,
  required String kind

}) {
  return TextFormField(
    controller: controller,
    onTap: onTab,
    keyboardType: type,
    obscureText: isPass,
    validator: (String? value) {
      if (value!.isEmpty) {
        return '$kind must not be Empty';
      }
      return null;
    },
    decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(onPressed: showPass, icon: Icon(suffixIcon),)


    ),
  );
}

Widget buildTaskItem(Map model,context){
 return Dismissible(
   key: UniqueKey(),
   child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
                '${model['time']}'
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${model['title']}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),
                Text('${model['date']}')
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(onPressed:(){
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          }, icon: Icon(
              Icons.check_box,
              color: Colors.green,
          )),
          IconButton(onPressed:(){
            AppCubit.get(context).updateData(status: 'archive', id: model['id']);
          }, icon: Icon(
              Icons.archive,
            color: Colors.grey,
          ))

        ],
      ),
    ),
     onDismissed:(direction){
     AppCubit.get(context).deleteData(id: model['id']);
     },

 );
}


Widget taskBuilder({required List<Map> tasks}){
  return ConditionalBuilder(
    condition: tasks.length>0,
    builder: (BuildContext context) {
      return ListView.separated(itemBuilder: (context,Index)=>buildTaskItem(tasks[Index],context),
        separatorBuilder: (context,index)=>Container(
          width: double.infinity,
          height: 1,
          color: Colors.grey[300],
        ),
        itemCount: tasks.length,
      );
    },
    fallback: (context){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu,
              size:100,
              color: Colors.grey,
            ),


            Text('No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey
              )

            )
          ],
        ),
      );
    },

  );
}