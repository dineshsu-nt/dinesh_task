import 'package:dinesh_project/bloc/sigin_in_bloc/auth_bloc.dart';
import 'package:dinesh_project/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:dinesh_project/bloc/user_bloc/user_bloc.dart';
import 'package:dinesh_project/custom_widget/bnb.dart';
import 'package:dinesh_project/repository/user_repo.dart';
import 'package:dinesh_project/screens/login_screen.dart';
import 'package:dinesh_project/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';
import 'repository/auth_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<SignInEmailBloc>(
              create: (context) => SignInEmailBloc(authRepo: AuthRepo())),
          BlocProvider<SignUpBloc>(
              create: (context) => SignUpBloc(authRepo: AuthRepo())),
          BlocProvider<UserBloc>(
              create: (context) => UserBloc(userRepo: UserRepo())),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: LoginScreen(),
        ),
      );
    });
  }
}
