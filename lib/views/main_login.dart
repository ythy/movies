import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/views/cards/form_card.dart';
import 'package:movies/views/top_bar.dart';
import 'package:movies/views/main_portal.dart';
import 'package:movies/models/model_user.dart';
import 'package:provider/provider.dart';
import 'package:movies/models/login_data.dart';
import 'package:movies/widgets/radio_button.dart';
import 'package:movies/widgets/animate_button.dart';

const users =  {
  'maoxin': '12345',
  'imc': 'hunter',
};


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> with TickerProviderStateMixin{

  bool _isRememberSelected = false;
  var _isLoading = false;
  var _isSubmitting = false;
  var _showShadow = true;

  late AnimationController _submitController;
  late Animation<double> _buttonScaleAnimation;
  late AnimationController _loadingController;

  Duration get loginTime => const Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _submitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _buttonScaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _loadingController,
        curve: const Interval(.5, 1, curve: Curves.bounceInOut),
      ),
    );

  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadingController.forward();
  }


  @override
  void dispose() {
    _submitController.dispose();
    super.dispose();
  }


  Future<String?> _authUser(LoginData data) async{

    await _submitController.forward();
    setState(() => _isSubmitting = true);

    debugPrint('Name: ${data.name}, Password: ${data.password}');

    return Future.delayed(loginTime).then((_) {
      _submitController.reverse();
      setState(() => _isSubmitting = false);
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return null;
    });
  }


  void _onRememberRadioTap() {
    setState(() {
      _isRememberSelected = !_isRememberSelected;
    });
  }

  void _onLoginTap() {
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
  }

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
                          RadioButton(isSelected: _isRememberSelected, onTap: _onRememberRadioTap),
                          SizedBox(
                            width: 150,
                            child: ScaleTransition(
                              scale: _buttonScaleAnimation,
                              child: AnimatedButton(
                                  text: "LOGIN", onPressed: _onLoginTap, controller: _submitController
                              ),
                            ),
                          )

                         // Ring(color: Theme.of(context).colorScheme.primary, value: 1,)
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

