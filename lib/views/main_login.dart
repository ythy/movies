import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/views/cards/form_card.dart';
import 'package:movies/views/cards/form_combobox_card.dart';
import 'package:movies/views/top_bar.dart';
import 'package:movies/views/main_portal.dart';
import 'package:movies/models/model_user.dart';
import 'package:provider/provider.dart';
import 'package:movies/widgets/radio_button.dart';
import 'package:movies/widgets/animate_loading_button.dart';
import 'package:http/http.dart' as http;
import 'package:movies/models/user_data.dart';
import 'package:movies/models/respond_data.dart';
import 'package:crypto/crypto.dart';
import 'package:movies/widgets/initial_animated_builder.dart';
import 'package:movies/widgets/custom_page_transformer.dart';
import 'package:another_transformer_page_view/another_transformer_page_view.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}


class _LoginState extends State<Login> with TickerProviderStateMixin{

  bool _isRememberSelected = false;
  int _cardIndex = 0;
  List<UserData> _userList = [];

  late AnimationController _submitController;
  late AnimationController _initialController;

  late IndexController _cardController;

  Duration get loginTime => const Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _submitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _initialController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),

    );
    _cardController = IndexController();


   _fetchUserList().then((onValue){
     setState(() {
       _userList = onValue;
     });

   });

  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration(milliseconds: 1000)).then((_){
      _initialController.forward();
    });
  }


  @override
  void dispose() {
    _submitController.dispose();
    _cardController.dispose();
    _initialController.dispose();
    super.dispose();
  }

  Future<List<UserData>> _fetchUserList() async {
    final response = await http.get(
      Uri.parse('http://109.14.6.43:6636/ux/getUserList?jsonString=%7B%22blockflag%22%3A%22N%22%2C%22usertype%22%3A%22U%22%2C%22iPageCount%22%3A20%2C%22iStart%22%3A0%7D'),
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse thON.
      var data = RespondData.fromJson(jsonDecode(response.body)).data;
      List<UserData> result = [];
      for (var user in data) {
        result.add(UserData.fromJson(user));
      }
      return result; UserData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load remote uri');
    }
  }

  Future<String?> _authUser(String id, String password) async{
    await _submitController.forward();
    var bytes = utf8.encode(password); // data being hashed

    UserData request = UserData(id: id, name: "", blockflag: "N", password: md5.convert(bytes).toString().toUpperCase());
    print(jsonEncode(request));
    final response = await http.get(
      Uri.parse('http://109.14.6.43:6636/ux/verifyUser?jsonString=${jsonEncode(request)}'),
    );
    await _submitController.reverse();

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse thON.
      print(jsonDecode(response.body));
      var respond = RespondData.fromJson(jsonDecode(response.body));

      return respond.msg; UserData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load remote uri');
    }
  }

  // void _changeCard(int newCardIndex) {
  //
  //   setState(() {
  //     _pageController.animateToPage(
  //       newCardIndex,
  //       duration: const Duration(milliseconds: 500),
  //       curve: Curves.ease,
  //     );
  //     _cardIndex = newCardIndex;
  //   });
  // }

  void _onRememberRadioTap() {
    setState(() {
      _isRememberSelected = !_isRememberSelected;
    });
  }

  void _onLoginTap() {
    var result = _authUser(Provider.of<UserModel>(context, listen: false).id,
       Provider.of<UserModel>(context, listen: false).password);
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



  Widget _changeToCard(BuildContext context) {
    return SizedBox(
        height: 270.0,
        child:  new TransformerPageView(
          loop: false,
          duration: Duration(milliseconds: 1000),
          index: _cardIndex,
          viewportFraction: 1.0,
          controller: _cardController,
          transformer: new ScaleAndFadeTransformer(),//CustomPageTransformer(),
          onPageChanged: (int? index) {
            setState(() {
              _cardIndex = index!;
            });
          },
          itemBuilder: (BuildContext context, int index) {
             switch (index) {
                case 0:
                  return InitialAnimatedBuilder(
                    controller: _initialController,
                    interval: Interval(0, 1),
                    type: 1,
                    child: FormComboboxCard(userList: _userList, controller: _initialController));
                case 1:
                  return FormCard();
               default:
                 return  FormCard();
            }
          }, itemCount: 2)
    );
  }

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
                    _changeToCard(context),
                    SizedBox(height: ScreenUtil().setHeight(40)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RadioButton(isSelected: _isRememberSelected, onTap: _onRememberRadioTap),
                          SizedBox(
                            width: 150,
                            child: InitialAnimatedBuilder(
                              controller: _initialController,
                              child: AnimatedLoadingButton(
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
                        InkWell(
                          onTap: () {
                            if(_initialController.status == AnimationStatus.dismissed)
                              _initialController.forward();
                            else
                              _initialController.reverse();
                          },

                          child: Text("switch",
                              style: TextStyle(
                                  fontFamily: "Poppins-Bold")),
                        ),
                        SizedBox(
                          width: ScreenUtil().setHeight(40),
                        ),
                        InkWell(
                          onTap: () {
                            var a = Random().nextBool();
                            if(a)
                              _cardController.next();
                            else
                              _cardController.previous();
                          },
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

