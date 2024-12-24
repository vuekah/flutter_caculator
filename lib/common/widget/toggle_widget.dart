import 'package:flutter/material.dart';
import 'package:flutter_caculator/gen/assets.gen.dart';
import 'package:flutter_caculator/theme/my_app_color.dart';

class ToggleWidget extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const ToggleWidget(
      {super.key, required this.initialValue, required this.onChanged});

  @override
  State<ToggleWidget> createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  late bool _isToggled;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      _isToggled = !_isToggled;
      widget.onChanged(_isToggled);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        width: 72.0,
        height: 34.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: _isToggled ? MyAppColors.whiteColor : MyAppColors.darkColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn,
                left: _isToggled ? 38.0 : 0.0,
                right: _isToggled ? 0.0 : 38.0,
                child: Container(
                  width: 24.0,
                  height: 24.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isToggled
                        ? MyAppColors.lightDotColor
                        : MyAppColors.darkDotColor,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeIn,
                left: _isToggled ? 0.0 : 38.0,
                right: _isToggled ? 38.0 : 0.0,
                child: Image.asset(
                  _isToggled ? Assets.images.sun.path : Assets.images.moon.path,
                  width: 24.0,
                  height: 24.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
