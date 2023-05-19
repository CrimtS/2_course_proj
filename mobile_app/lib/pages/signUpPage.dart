import 'package:flutter/material.dart';
import 'package:mw_inside/components/authErrorMessage.dart';
import 'package:mw_inside/components/middleButton.dart';
import 'package:mw_inside/components/alreadyHaveAnAccount.dart';
import 'package:mw_inside/services/authorizationService.dart';


class SignUpPage extends StatefulWidget {
  final VoidCallback onLogInButtonPressed;
  SignUpPage({@required this.onLogInButtonPressed});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  List<Widget> errorMessages = [];

  void addErrorMessage(String text){
    setState(() {
      errorMessages.add(AuthErrorMessage(text: text));
      errorMessages.add(SizedBox(height: 5.0));
    });
  }

  void clearErrorMessages(){
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
            "SIGN UP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.03),
          SizedBox(height: 0.03),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20.0),
                border: InputBorder.none,
                hintText: 'Username'),
          ),
          SizedBox(height: 0.03),
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
            text: "SIGN UP",
            press: () async {
              String username = _usernameController.text;
              String password = _passwordController.text;
              bool registerSuccessful = await register(username, password);
              clearErrorMessages();
              if (registerSuccessful) {
                widget.onLogInButtonPressed();
              }
              else {
                addErrorMessage('Регистрация прошла с ошибками, пожалуйста,'
                    ' перепроверьте введённые данные ');
              }
            },
          ),
          SizedBox(height: 5.0),
          AlreadyHaveAnAccount(
            login: false,
            press: () {
              widget.onLogInButtonPressed();
            },
          ),
        ],
      ),
    );
  }
}
