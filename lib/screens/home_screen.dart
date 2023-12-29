import 'package:dinesh_project/bloc/user_bloc/user_bloc.dart';
import 'package:dinesh_project/custom_widget/gap.dart';
import 'package:dinesh_project/repository/user_repo.dart';
import 'package:dinesh_project/screens/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserBloc _userBloc;

  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc(
      userRepo: UserRepo(),
    );
    _userBloc.add(FetchTaskEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskScreen(
                        isEditScreen: false,
                      )));
          _userBloc.add(FetchTaskEvent());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Task Screen',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _userBloc,
        child: BlocBuilder<UserBloc, UserState>(
          buildWhen: (previous, current) {
            return previous != current;
          },
          builder: (context, state) {
            if (state is TaskFetchState) {
              var data = state.taskModel;
              return data.isEmpty
                  ? Center(
                      child: Text("Add new task"),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final taskList = data[index];
                        return GestureDetector(
                          onTap: () {
                            debugPrint(taskList.docID);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTaskScreen(
                                          docId: taskList.docID,
                                          isEditScreen: true,
                                          taskName: taskList.task,
                                          description: taskList.description,
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: Card(
                              elevation: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    child: Checkbox(
                                      checkColor: Colors.deepPurple,
                                      value: taskList.isCompleted,
                                      onChanged: (value) {
                                        context.read<UserBloc>().add(
                                            UpdateTaskCompletionEvent(
                                                docId: taskList.docID,
                                                isCompleted: value!));
                                        // FirebaseFirestore.instance
                                        //     .collection('users')
                                        //     .doc(AppRepo().uid)
                                        //     .collection("task")
                                        //     .doc(taskList.docID)
                                        //     .update({'isCompleted': value});
                                        setState(() {
                                          taskList.isCompleted = value ??
                                              false; // Update local value
                                        });
                                      }, // Disable checkbox interaction
                                      activeColor: Colors.green,
                                    ),
                                  ),
                                  GapWidth(
                                    width: 5.w,
                                  ),
                                  SizedBox(
                                    width: 50.w,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.sp,
                                        horizontal: 5.sp,
                                      ),
                                      title: Text(
                                        "Title: ${taskList.task}",
                                        style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                            decoration: taskList.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                      subtitle: Text(
                                        "Description: ${taskList.description}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            decoration: taskList.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                    ),
                                  ),
                                  GapWidth(
                                    width: 5.w,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.read<UserBloc>().add(
                                          DeleteTaskEvent(
                                              docId: taskList.docID));
                                    },
                                    icon: Icon(Icons.delete),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            } else if (state is UserLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ErrorState) {
              debugPrint(state.error);
              return Text("error ----------${state.error}");
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
