import 'package:flutter/material.dart';



typedef RadioButtonTapCallback = void Function();

class RadioButton extends StatelessWidget {
  final bool isSelected;
  final RadioButtonTapCallback onTap;

  RadioButton({
    super.key,
    required this.isSelected,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12.0,
          ),
          radioButton(isSelected, context),
          SizedBox(
            width: 8.0,
          ),
          Text("Remember me",
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins-Medium"))
        ],
      ),
    );
  }

  Widget radioButton(bool selected, BuildContext context) => Container(
    width: 16.0,
    height: 16.0,
    padding: EdgeInsets.all(2.0),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 2.0, color: Theme.of(context).colorScheme.primary)),
    child: selected
        ? Container(
      width: double.infinity,
      height: double.infinity,
      decoration:
      BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.primary),
    )
        : Container(),
  );
}

