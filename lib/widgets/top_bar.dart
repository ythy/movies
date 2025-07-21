import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies/models/model_theme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TopBar extends AppBar {

  @override
  State<TopBar> createState() => _TopBarState();
}


class _TopBarState extends State<TopBar> {

  late Color pickedColor;


  void didChangeDependencies() {
    super.didChangeDependencies();
    pickedColor = Provider.of<ThemeModel>(context).seedColor;
  }

  void changeColor(Color color) {
    setState(() {
      pickedColor = color;
    });
  }

  void onSeekColor(){
    Provider.of<ThemeModel>(context, listen: false).setColor(pickedColor);
  }

  void onRingClick(){
    var seekColor = Provider.of<ThemeModel>(context, listen: false).seedColor.toHexString();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('seek color is a' + seekColor)));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            // child: ColorPicker(
            //   pickerColor: pickedColor,
            //   onColorChanged: changeColor,
            // ),
            // Use Material color picker:
            //
            child: MaterialPicker(
              pickerColor: pickedColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                onSeekColor();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Brightness brightness = Provider.of<ThemeModel>(context).brightness;
    Icon brightIcon =  brightness == Brightness.dark ? const Icon(Icons.light_mode) :
    const Icon(Icons.dark_mode);
    return AppBar(
        title: const Text('UX SYS'),
        scrolledUnderElevation: 4.0,
        shadowColor: Theme.of(context).shadowColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.palette),
            tooltip: 'Change color theme',
            onPressed: () {
              _dialogBuilder(context);
            },
          ),
          IconButton(
            icon: brightIcon,
            tooltip: 'Switch brightness mode',
            onPressed: () {
              Provider.of<ThemeModel>(context, listen: false).switchBrightness();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: onRingClick,
          ),
        ],
      );
  }
}

