import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:origami/bussinus_logic/authentication_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              // BlocProvider.of<AuthenticationCubit>(context)
              //     .setLoginStatus(false);

              logout();
            },
            child: Text("logout")),
      ),
    );
  }
}