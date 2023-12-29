import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dinesh_project/bloc/sign_up_bloc/sign_up_bloc.dart';
import 'package:dinesh_project/bloc/user_bloc/user_bloc.dart';
import 'package:dinesh_project/custom_widget/custom_button.dart';
import 'package:dinesh_project/custom_widget/custom_text_field.dart';
import 'package:dinesh_project/repository/user_repo.dart';
import 'package:dinesh_project/screens/edit_profile.dart';
import 'package:dinesh_project/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../repository/app_repo.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? profileImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Text('Profile screen',
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => EditProfileScreen(
                          email: emailController.text,
                          name: nameController.text,
                          phoneNumber: phoneNumberController.text,
                          profileImage: profileImage,
                        )),
              );
            },
            icon: Icon(Icons.edit),
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(AppRepo().uid)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData ||
                snapshot.data == null ||
                !snapshot.data!.exists) {
              return Center(child: Text('No user data available.'));
            }

            // Assuming the snapshot data represents user profile data
            Map<String, dynamic>? userProfile = snapshot.data!.data();
            if (userProfile == null || userProfile.isEmpty) {
              return Center(child: Text('User profile data is empty.'));
            }

            nameController.text = userProfile['userName'] ?? '';
            emailController.text = userProfile['email'] ?? '';
            phoneNumberController.text = userProfile['phoneNumber'] ?? '';
            profileImage = userProfile['profileImage'] ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: Column(
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 16.0),
                    profileImage!.isEmpty
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'),
                            maxRadius: 50.0.sp,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(profileImage!),
                            maxRadius: 50.0.sp,
                          ),
                    SizedBox(height: 24.0),
                    CustomTextFieldTitle(
                        focusColor: Colors.grey,
                        readOnly: true,
                        controller: nameController,
                        fieldTitle: "UserName"),
                    SizedBox(height: 16.0),
                    CustomTextFieldTitle(
                        focusColor: Colors.grey,
                        readOnly: true,
                        controller: emailController,
                        fieldTitle: "Email"),
                    const SizedBox(height: 16.0),
                    CustomTextFieldTitle(
                        focusColor: Colors.grey,
                        readOnly: true,
                        controller: phoneNumberController,
                        fieldTitle: "Phone number"),
                    const SizedBox(height: 24.0),
                    CustomButton(
                      onTap: () {
                        displayLoggedOutDialog(context);
                      },
                      textColor: Colors.white,
                      buttonText: "Sign-Out",
                      buttonColor: Colors.deepPurple,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future displayLoggedOutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return BlocConsumer<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state is SignOutSuccessState) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return AlertDialog(
              title: Text(
                "Sign Out? ",
              ),
              actions: [
                MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Yes"),
                  onPressed: () {
                    context.read<SignUpBloc>().add(SignOutEvent());
                  },
                ),
                MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
