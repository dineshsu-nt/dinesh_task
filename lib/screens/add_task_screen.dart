import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinesh_project/bloc/user_bloc/user_bloc.dart';
import 'package:dinesh_project/custom_widget/bnb.dart';
import 'package:dinesh_project/custom_widget/custom_button.dart';
import 'package:dinesh_project/custom_widget/custom_text_field.dart';
import 'package:dinesh_project/custom_widget/gap.dart';
import 'package:dinesh_project/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../repository/app_repo.dart';

class AddTaskScreen extends StatefulWidget {
  String docId;
  String taskName;
  String description;
  bool isEditScreen;
  AddTaskScreen(
      {Key? key,
      this.isEditScreen = false,
      this.taskName = "",
      this.docId = "",
      this.description = ""})
      : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    initializeControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.isEditScreen
              ? Text(
                  "Edit Task",
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  "Add Task",
                  style: TextStyle(color: Colors.white),
                ),
          backgroundColor: Colors.deepPurple,
        ),
        body: widget.isEditScreen == false
            ? BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is DataAddedState) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BnbScreen(
                                  selectedIndex: 0,
                                )));
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFieldTitle(
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "Task cannot be a empty";
                              }
                            },
                            controller: taskController,
                            fieldTitle: "Title",
                            hintText: "Enter Title",
                          ),
                          Gap2(),
                          CustomTextFieldTitle(
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "Description cannot be a empty";
                              }
                            },
                            controller: descriptionController,
                            fieldTitle: "Description",
                            hintText: "Enter Task",
                          ),
                          Gap2(),
                          CustomButton(
                            textColor: Colors.white,
                            isLoading: state is UserLoadingState,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                String customID = const Uuid().v4();
                                context.read<UserBloc>().add(UploadTaskEvent(
                                    docId: customID,
                                    task: TaskModel(
                                        docID: customID,
                                        task: taskController.text,
                                        description: descriptionController.text,
                                        isCompleted: false)));
                              }
                            },
                            buttonText: "Add",
                            buttonColor: Colors.deepPurple,
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : BlocConsumer<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is DataAddedState) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BnbScreen(
                                  selectedIndex: 0,
                                )));
                  }
                },
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFieldTitle(
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "Task cannot be a empty";
                              }
                              return null;
                            },
                            controller: taskController,
                            fieldTitle: "Title",
                            hintText: "Enter Title",
                          ),
                          Gap2(),
                          CustomTextFieldTitle(
                            validator: (p0) {
                              if (p0!.isEmpty) {
                                return "Description cannot be a empty";
                              }
                              return null;
                            },
                            controller: descriptionController,
                            fieldTitle: "Description",
                            hintText: "Enter Task",
                          ),
                          Gap2(),
                          CustomButton(
                            textColor: Colors.white,
                            isLoading: state is UserLoadingState,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                context.read<UserBloc>().add(UpdateTaskEvent(
                                    task: TaskModel(
                                      docID: widget.docId,
                                      description: descriptionController.text,
                                      isCompleted: false,
                                      task: taskController.text,
                                    ),
                                    docId: widget.docId));
                              }
                            },
                            buttonText: "Add",
                            buttonColor: Colors.deepPurple,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ));
  }

  void initializeControllers() async {
    taskController = TextEditingController();
    descriptionController = TextEditingController();

    if (widget.isEditScreen) {
      taskController = TextEditingController(text: widget.taskName);
      descriptionController = TextEditingController(text: widget.description);
    }
  }
}
