import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../shared/component/component.dart';
import '../../shared/component/constats.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class TasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit,AppState>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, state) {
        return taskBuilder(tasks: newTasks);
      },


    );
  }
}
