import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/models/model_user.dart';
import 'package:provider/provider.dart';


class FormCard extends StatefulWidget {
  const FormCard({super.key});

  @override
  State<FormCard> createState() => _FormCardState();
}


class _FormCardState extends State<FormCard> {

  final userNameController = TextEditingController();
  final userPasswordController = TextEditingController();
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    userNameController.addListener(_LatestUserNameValue);
    userPasswordController.addListener(_LatestUserPasswordValue);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userNameController.text = Provider.of<UserModel>(context).userName;
  }


  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    userNameController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  void _LatestUserNameValue() {
    final text = userNameController.text;
    Provider.of<UserModel>(context, listen: false).userName = text;
  }

  void _LatestUserPasswordValue() {
    final text = userPasswordController.text;
    Provider.of<UserModel>(context, listen: false).userPassword = text;
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
        width: double.infinity,
//      height: ScreenUtil.getInstance().setHeight(500),
        padding: EdgeInsets.only(bottom: 1),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 15.0),
                  blurRadius: 15.0),
              BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, -10.0),
                  blurRadius: 10.0),
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Login",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.titleLarge?.fontSize, // ✅
                      letterSpacing: .6)),
              SizedBox(
                height: 30.h, // ✅ correct
              ),
              TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Username",
                    hintStyle: TextStyle(
                        fontSize:  Theme.of(context).textTheme.bodyMedium?.fontSize)),
                controller: userNameController,

              ),
              SizedBox(
                height: ScreenUtil().setHeight(30),
              ),
              TextField(
                obscureText: isObscure,
                controller: userPasswordController,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(
                        fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize)),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(80),
              ),
            ],
          ),
        ),
      );
  }
}
