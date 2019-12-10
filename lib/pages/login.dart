import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/bloc.dart';
import 'package:safe/main.dart';
import './signup.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc _loginBloc;
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(storage: SafeApp.storage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginEvent, LoginState>(
          bloc: _loginBloc,
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                AbsorbPointer(
                  absorbing: state is LoginLoading,
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Spacer(),
                        TextField(
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "email",
                            hasFloatingPlaceholder: false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          autofocus: false,
                          controller: _pwController,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "password",
                            hasFloatingPlaceholder: false,
                          ),
                        ),
                        const SizedBox(height: 30),
                        RaisedButton(
                          child: Text("Login"),
                          onPressed: () => _loginBloc.dispatch(
                            LoginButtonPressed(
                              email: _emailController.text,
                              password: _pwController.text,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Expanded(child: Divider(endIndent: 10,)),
                            Text("or"),
                            Expanded(child: Divider(indent: 10,)),
                          ],
                        ),
                        FlatButton(
                          child: Text("SignUp"),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          ),
                        ),
                        const Spacer(flex: 3,)
                      ],
                    ),
                  ),
                ),
                Opacity(
                  opacity: (state is LoginLoading) ? 1 : 0,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
