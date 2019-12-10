import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe/bloc/bloc.dart';

class AccountPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwRepeatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder(
        bloc: BlocProvider.of<AuthenticationBloc>(context),
        builder: (context, state) {
          if (state is AuthenticationAuthenticated)
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: CachedNetworkImageProvider(
                        state.user.picture,
                      ),
                      radius: 30,
                      foregroundColor: Colors.white24,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: null,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                      height: 1,
                    ),
                    Text(
                      "Profile",
                      textScaleFactor: 3,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    labelText: state.user.name,
                    hasFloatingPlaceholder: false,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    labelText: state.user.email,
                    hasFloatingPlaceholder: false,
                  ),
                ),
                const SizedBox(height: 20),
                RaisedButton(
                    child: Text("Update Account"),
                    onPressed: () => updateProfile(context)),
                const SizedBox(height: 25),
                TextField(
                  controller: _pwController,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    hasFloatingPlaceholder: false,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _pwRepeatController,
                  autocorrect: false,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Repeat New Password",
                    hasFloatingPlaceholder: false,
                  ),
                ),
                const SizedBox(height: 20),
                RaisedButton(
                    child: Text("Update Password"),
                    onPressed: () => updatePassword(context)),
                FlatButton(
                    child: Text("Logout"), onPressed: () => logout(context)),
                FlatButton(
                    child: Text("Delete Account"),
                    onPressed: () => deleteAccount(context)),
              ],
            );
        },
      ),
    );
  }

  void updateProfile(BuildContext context) {
    BlocProvider.of<SettingsBloc>(context).dispatch(SettingsUpdateAccount(
      name: _nameController.text,
      email: _emailController.text,
    ));
  }

  void updatePassword(BuildContext context) {
    if (_pwController.text == _pwRepeatController.text)
      BlocProvider.of<SettingsBloc>(context).dispatch(SettingsUpdatePassword(
        password: _pwController.text,
      ));
  }

  void logout(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context)
        .dispatch(AuthenticationLogout());
  }

  void deleteAccount(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text("All your information will be lost!"),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (confirm) {
      BlocProvider.of<AuthenticationBloc>(context)
          .dispatch(AuthenticationDelete());
    }
  }
}
