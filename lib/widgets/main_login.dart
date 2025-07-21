import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/widgets/form_card.dart';
import 'package:movies/widgets/top_bar.dart';
import 'package:movies/widgets/main_portal.dart';
import 'package:movies/models/model_user.dart';
import 'package:provider/provider.dart';
import 'package:movies/models/login_data.dart';

const users =  {
  'maoxin': '12345',
  'imc': 'hunter',
};


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> {

  bool _isSelected = false;

  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) {
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }


  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Theme.of(context).colorScheme.primary)),
    child: isSelected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary),
    )
        : Container(),
  );

  Widget signButton() => InkWell(
    child: Container(
      width: ScreenUtil().setWidth(230),
      height: ScreenUtil().setHeight(80),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary
          ]),
          borderRadius: BorderRadius.circular(6.0),
          boxShadow: [
            BoxShadow(
                color:
                Theme.of(context).colorScheme.primary.withOpacity(.3),
                offset: Offset(0.0, 8.0),
                blurRadius: 8.0)
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            var result = _authUser(LoginData(name: Provider.of<UserModel>(context, listen: false).userName,
                password: Provider.of<UserModel>(context, listen: false).userPassword));
            result.then((value)=>{
                if(value == null){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Mainframe() ;
                        },
                      ),
                          (route) => false,
                    )
                  }else{
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(value, style: TextStyle(color:
                        Theme.of(context).colorScheme.onError)),
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating),)
                  }
            });
          },
          child: Center(
            child: Text("SIGNIN",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontFamily: "Poppins-Bold",
                    fontSize: 18,
                    letterSpacing: 1.0)),
          ),
        ),
      ),
    ),
  );

  Widget horizontalLine() => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: ScreenUtil().setWidth(120),
      height: 1.0,
      color: Theme.of(context).colorScheme.onSurface.withOpacity(.6),
    ),
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TopBar(),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                      "assets/image_02.png",
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary),
                )
            ),
            SingleChildScrollView(
              child: Padding(
                padding:
                EdgeInsets.only(left: 28.0, right: 28.0, top: 50.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("",
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .onSurface,
                                fontSize: ScreenUtil().setSp(46),
                                letterSpacing: .6,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(180),
                    ),
                    FormCard(),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: _radio,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 12.0,
                                ),
                                radioButton(_isSelected),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Text("Remember me",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Poppins-Medium"))
                              ],
                            ),
                          ),
                          signButton()
                        ]),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text("Social Login",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: "Poppins-Medium")),
                        horizontalLine()
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "New User? ",
                          style: TextStyle(fontFamily: "Poppins-Medium"),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text("SignUp",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold")),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }


}

