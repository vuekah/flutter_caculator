import 'package:flutter/material.dart';
import 'package:flutter_caculator/theme/my_app_color.dart';

class ButtonWidget extends StatelessWidget {
  final Color? color;
  final Color? titleColor;
  final VoidCallback onPressed;
  final String? title;
  final Image? image;

  const ButtonWidget({
    super.key,
    required this.onPressed,
    this.title,
    this.image,
    this.color = MyAppColors.operatorColor,
    this.titleColor = MyAppColors.whiteColor,
  }) : assert(title != null || image != null,
            'Either title or image must be provided');

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = screenWidth / 5.25;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        width: buttonSize,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: color,
        ),
        child: Center(
          child: image ??
              Text(
                title!,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 32.0,
                ),
              ),
        ),
      ),
    );
  }
}
