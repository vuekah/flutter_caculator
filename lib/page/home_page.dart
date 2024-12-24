import 'package:flutter/material.dart';
import 'package:flutter_caculator/common/widget/button_widget.dart';
import 'package:flutter_caculator/common/widget/toggle_widget.dart';
import 'package:flutter_caculator/gen/assets.gen.dart';
import 'package:flutter_caculator/page/home_viewmodel.dart';
import 'package:flutter_caculator/theme/my_app_color.dart';
import 'package:flutter_caculator/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textEditingController = TextEditingController();
  int pressTimes = 2;

  String _display = '';
  void _onButtonPressed(String input, BuildContext context) {
    final isCalculated =
        Provider.of<HomeViewmodel>(context, listen: false).isCalculated;
    if (isCalculated) {
      _display =
          Provider.of<HomeViewmodel>(context, listen: false).history.last;
      _textEditingController.text = _display;
      Provider.of<HomeViewmodel>(context, listen: false).clear();
    }
    setState(() {
      _textEditingController.text += input;
      _display += input;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return ChangeNotifierProvider<HomeViewmodel>(
      create: (context) => HomeViewmodel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: ToggleWidget(
            initialValue: Provider.of<ThemeProvider>(context).isLightMode,
            onChanged: (bool value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ),
        body: isPortrait
            ? _buildBody(context)
            : SingleChildScrollView(
                child: _buildBody(context),
              ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(context),
        _buildFirstRow(context),
        _buildSecondRow(
            context,
            ["7", "8", "9"],
            Image.asset(
              Assets.images.multiplication.path,
              width: 17,
            )),
        _buildSecondRow(context, ["4", "5", "6", "-"]),
        _buildSecondRow(context, ["1", "2", "3", "+"]),
        _buildLastRow(context),
        const SizedBox(
          height: 35,
        )
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.11),
          child: Selector<HomeViewmodel, bool>(
            selector: (context, viewmodel) => viewmodel.isCalculated,
            builder: (context, result, child) => FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomRight,
              child: Text(
                result ? _display : Provider.of<HomeViewmodel>(context).result,
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 40, color: Colors.grey),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.bottomRight,
            child: Text(
              Provider.of<HomeViewmodel>(context, listen: true).isCalculated
                  ? Provider.of<HomeViewmodel>(context).result
                  : _display,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
          onPressed: () {
            setState(() {
              _textEditingController.text = '';
              _display = '';
            });
            Provider.of<HomeViewmodel>(context, listen: false).resetAll();
          },
          color: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.darkDotColor
              : MyAppColors.lightButonColor,
          titleColor: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.whiteColor
              : MyAppColors.blackColor,
          title: "C",
        ),
        const SizedBox(width: 16),
        ButtonWidget(
          onPressed: () {
            bool isNegative = _display.startsWith("-");
            if (isNegative) {
              _display = _display.substring(1);
            } else {
              _display = "-$_display";
            }
            setState(() {
              _textEditingController.text = _display;
            });
          },
          color: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.darkDotColor
              : MyAppColors.lightButonColor,
          image: !Provider.of<ThemeProvider>(context).isLightMode
              ? Image.asset(
                  Assets.images.abs.path,
                  width: 28,
                )
              : Image.asset(
                  Assets.images.absBlack.path,
                  width: 28,
                ),
        ),
        const SizedBox(width: 16),
        ButtonWidget(
          onPressed: () {
            if (Provider.of<HomeViewmodel>(context, listen: false)
                .history
                .isNotEmpty) {
              _display = Provider.of<HomeViewmodel>(context, listen: false)
                  .history
                  .last;
              _display = Provider.of<HomeViewmodel>(context, listen: false)
                  .calculate(_display, true);
              Provider.of<HomeViewmodel>(context, listen: false).clear();
            }
          },
          color: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.darkDotColor
              : MyAppColors.lightButonColor,
          titleColor: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.whiteColor
              : MyAppColors.blackColor,
          title: "%",
        ),
        const SizedBox(width: 16),
        ButtonWidget(
          onPressed: () {
            _onButtonPressed("÷", context);
          },
          color: MyAppColors.operatorColor,
          title: "÷",
        ),
      ],
    );
  }

  Widget _buildSecondRow(BuildContext context, List<String> buttons,
      [Image? image]) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...buttons.map((e) => ButtonWidget(
              color: !Provider.of<ThemeProvider>(context).isLightMode
                  ? (e == "-" || e == "+"
                      ? MyAppColors.operatorColor
                      : MyAppColors.darkColor)
                  : (e == "-" || e == "+"
                      ? MyAppColors.operatorColor
                      : MyAppColors.whiteColor),
              titleColor: !Provider.of<ThemeProvider>(context).isLightMode
                  ? MyAppColors.whiteColor
                  : (e == "-" || e == "+"
                      ? MyAppColors.whiteColor
                      : MyAppColors.blackColor),
              onPressed: () {
                _onButtonPressed(e, context);
              },
              title: e,
            )),
        if (image != null)
          ButtonWidget(
            onPressed: () {
              _onButtonPressed("x", context);
            },
            color: MyAppColors.operatorColor,
            image: image,
          ),
      ],
    );
  }

  Widget _buildLastRow(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
          color: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.darkColor
              : MyAppColors.whiteColor,
          titleColor: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.whiteColor
              : MyAppColors.blackColor,
          onPressed: () {
            _onButtonPressed(".", context);
          },
          title: ".",
        ),
        ButtonWidget(
          color: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.darkColor
              : MyAppColors.whiteColor,
          titleColor: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.whiteColor
              : MyAppColors.blackColor,
          onPressed: () {
            _onButtonPressed("0", context);
          },
          title: "0",
        ),
        ButtonWidget(
          color: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.darkColor
              : MyAppColors.whiteColor,
          titleColor: !Provider.of<ThemeProvider>(context).isLightMode
              ? MyAppColors.whiteColor
              : MyAppColors.blackColor,
          onPressed: () {
            setState(() {
              if (_display.isNotEmpty) {
                _display = _display.substring(0, _display.length - 1);
              }
            });
          },
          image: !Provider.of<ThemeProvider>(context).isLightMode
              ? Image.asset(
                  Assets.images.delete.path,
                  width: 32,
                )
              : Image.asset(
                  Assets.images.deleteBlack.path,
                  width: 32,
                ),
        ),
        ButtonWidget(
          onPressed: () {
            if (_textEditingController.text.isNotEmpty) {
              Provider.of<HomeViewmodel>(context, listen: false)
                  .calculate(_textEditingController.text);
            }
            _textEditingController.clear();
          },
          color: MyAppColors.operatorColor,
          title: "=",
        ),
      ],
    );
  }
}
