import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/models/model_user.dart';
import 'package:provider/provider.dart';
import 'package:movies/models/user_data.dart';

typedef UserListEntry = DropdownMenuEntry<UserData>;

class FormComboboxCard extends StatefulWidget {

  final List<UserData> userList;

  FormComboboxCard({super.key, required this.userList});

  @override
  State<FormComboboxCard> createState() => _FormComboboxCardState();
}


class _FormComboboxCardState extends State<FormComboboxCard> {


  final userPasswordController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  bool isObscure = true;
  UserData? selectedUser;
  late List<DropdownMenuEntry<UserData>> userEntries;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
    userPasswordController.addListener(_LatestUserPasswordValue);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _updateUserList();
    userController.text = Provider.of<UserModel>(context).name;
  }

  @override
  void didUpdateWidget(FormComboboxCard oldWidget){
    super.didUpdateWidget(oldWidget);
    if(oldWidget.userList.length != widget.userList.length)
      _updateUserList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    userController.dispose();
    userPasswordController.dispose();
    super.dispose();
  }

  void _updateUserList(){
    //setState(() {
      userEntries = UnmodifiableListView<UserListEntry>(
        widget.userList.map<UserListEntry>(
              (UserData user) => UserListEntry(
            value: user,
            label: user.name,
            enabled: true,
           // style: MenuItemButton.styleFrom(foregroundColor:  Theme.of(context).colorScheme.surface),
          ),
        ),
      );
   // });

  }


  void _LatestUserPasswordValue() {
    final text = userPasswordController.text;
    Provider.of<UserModel>(context, listen: false).password = text;
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
            DropdownMenu<UserData>(
              controller: userController,
              requestFocusOnTap: true,
              label: const Text('User'),
              onSelected: (UserData? user) {
                setState(() {
                  selectedUser = user;
                  Provider.of<UserModel>(context, listen: false).id = user?.id ?? "";
                });
              },
              dropdownMenuEntries: userEntries,
              leadingIcon:Icon(Icons.person),
              width: 700.w,
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
              label: const Text("Password")),
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
