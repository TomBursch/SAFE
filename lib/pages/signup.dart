import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/bloc.dart';
import 'package:safe/main.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignupBloc _signupBloc;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _pwRepeatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _signupBloc = SignupBloc(storage: SafeApp.storage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: _signupBloc,
        listener: (context, state) {
          if (state is SignupFailure) {
            _pwController.clear();
            _pwRepeatController.clear();
          }
          if (state is SignupSuccess) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<SignupEvent, SignupState>(
          bloc: _signupBloc,
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                AbsorbPointer(
                  absorbing: state is SignupLoading,
                  child: Stack(
                    children: <Widget>[
                      ListView(
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                        children: <Widget>[
                          Transform.translate(
                            child: Text("Signup", textScaleFactor: 1.5,),
                            offset: Offset(40, 0),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "display name",
                              hasFloatingPlaceholder: false,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            autofocus: true,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "email",
                              hasFloatingPlaceholder: false,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            autofocus: true,
                            controller: _pwController,
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "password",
                              hasFloatingPlaceholder: false,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            autofocus: true,
                            controller: _pwRepeatController,
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "repeat password",
                              hasFloatingPlaceholder: false,
                            ),
                          ),
                          FlatButton(
                            child: Text("SignUp"),
                            onPressed: () => _signupBloc.dispatch(
                              SignupButtonPressed(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _pwController.text,
                                passwordRepeat: _pwRepeatController.text,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        padding:
                            EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
                Opacity(
                    opacity: state is SignupLoading ? 1 : 0,
                    child: Center(child: CircularProgressIndicator())),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _signupBloc.dispose();
    super.dispose();
  }
}
