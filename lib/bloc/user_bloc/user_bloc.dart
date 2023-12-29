import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dinesh_project/models/task_model.dart';
import 'package:dinesh_project/models/user_model.dart';
import 'package:dinesh_project/repository/user_repo.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepo userRepo;
  UserBloc({required this.userRepo}) : super(UserInitial()) {
    on<UploadUserDataEvent>(_onUploadUserData);
    on<UploadTaskEvent>(_onUploadTask);
    on<FetchTaskEvent>(_onFetchTasks);
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileDataEvent>(_onUpdateUserProfile);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<UpdateTaskCompletionEvent>(_mapUpdateTaskCompletionToState);
  }
  Future<void> _onUploadUserData(
    UploadUserDataEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    try {
      await userRepo.uploadUserData(event.user);
      emit(UserLoadedState(user: event.user));
    } catch (e) {
      emit(
        ErrorState(error: 'Error uploading user data: $e'),
      );
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateProfileDataEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    try {
      add(FetchProfileEvent());
      await userRepo.updateProfileData(event.user);
      emit(UpdateUserState(user: event.user));
      add(FetchProfileEvent());
    } catch (e) {
      emit(
        ErrorState(error: 'Error uploading user data: $e'),
      );
    }
  }

  Future<void> _onUploadTask(
    UploadTaskEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    try {
      await userRepo.uploadTask(event.task, event.docId);
      emit(DataAddedState(taskModel: event.task));
      add(FetchTaskEvent());
    } catch (e) {
      emit(
        ErrorState(error: 'Error uploading user data: $e'),
      );
    }
  }

  Future<void> _updateTask(
    UpdateTaskEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    try {
      await userRepo.updateTask(event.task, event.docId);
      emit(DataAddedState(taskModel: event.task));
      add(FetchTaskEvent());
    } catch (e) {
      emit(
        ErrorState(error: 'Error uploading user data: $e'),
      );
    }
  }

  Future<void> _onFetchTasks(
      FetchTaskEvent event, Emitter<UserState> emit) async {
    emit(UserLoadingState());

    try {
      final List<TaskModel> taskList = await userRepo.fetchTaskData();
      emit(TaskFetchState(taskModel: taskList));
    } catch (e) {
      emit(ErrorState(error: 'Error fetching task data: $e'));
    }
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoadingState());

    try {
      final List<UserModel> userProfile = await userRepo.fetchUserData();
      if (userProfile.isNotEmpty) {
        emit(ProfileFetchState(userProfile: userProfile.first));
      } else {
        emit(ErrorState(error: 'User profile not found'));
      }
    } catch (e) {
      emit(ErrorState(error: 'Error fetching user profile: $e'));
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await userRepo.deleteTask(event.docId);
      emit(DataDeletedState());
      add(FetchTaskEvent());
    } catch (e) {
      emit(ErrorState(error: 'Error deleting task: $e'));
    }
  }

  Future<void> _mapUpdateTaskCompletionToState(
    UpdateTaskCompletionEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      await userRepo.updateTaskCompletion(event.docId, event.isCompleted);
    } catch (e) {
      emit(ErrorState(error: 'Error updating task completion: $e'));
    }
  }
}
