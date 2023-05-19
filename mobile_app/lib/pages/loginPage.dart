import 'package:flutter/material.dart';
import 'package:mw_inside/components/middleButton.dart';
import 'package:mw_inside/components/alreadyHaveAnAccount.dart';
import 'package:mw_inside/components/authErrorMessage.dart';
import 'package:mw_inside/services/authorizationService.dart';

void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(title: Text(title), content: Text(text)),
    );

class LoginPage extends StatefulWidget {
  final VoidCallback onSignUpButtonPressed;
  final VoidCallback onSubmitButtonPressed;

  LoginPage(
      {@required this.onSignUpButtonPressed,
      @required this.onSubmitButtonPressed});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<Widget> errorMessages = [];

  void addErrorMessage(String text) {
    setState(() {
      errorMessages.add(AuthErrorMessage(text: text));
      errorMessages.add(SizedBox(height: 5.0));
    });
  }

  void clearErrorMessages() {
    setState(() {
      errorMessages = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "LOGIN",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
                hintText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
                hintText: 'Password'),
          ),
          Container(
            child: Column(
              children: errorMessages,
            ),
          ),
          MiddleButton(
            text: "LOGIN",
            press: () async {
              String username = _usernameController.text;
              String password = _passwordController.text;
              print("login_called");
              bool loginSuccessful =
                  await login(username, password);
              clearErrorMessages();
              if (!loginSuccessful) {
                addErrorMessage("Your login and password are incorrect. "
                    "Please check them again");
              } else {
                widget.onSubmitButtonPressed();
              }
            },
          ),
          SizedBox(height: 5.0),
          AlreadyHaveAnAccount(
            press: () {
              widget.onSignUpButtonPressed();
            },
          ),
        ],
      ),
    );
  }
}
