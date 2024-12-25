import 'package:flutter/material.dart';
import 'package:flutter_caculator/common/widget/button_widget.dart';
import 'package:flutter_caculator/common/widget/toggle_widget.dart';
import 'package:flutter_caculator/enum/button_label.dart';
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
          title: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) => ToggleWidget(
              initialValue: themeProvider.isLightMode,
              onChanged: (bool value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ),
        body: isPortrait
            ? _buildBody(context)
            : SingleChildScrollView(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Selector<ThemeProvider, bool>(
      selector: (context, viewmodel) => viewmodel.isLightMode,
      builder: (context, value, child) {
        return Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            _buildTitle(context),
            _buildFirstRow(context),
            _buildButtonRow(context, [
              ButtonLabel.seven,
              ButtonLabel.eight,
              ButtonLabel.nine,
              ButtonLabel.multiply
            ]),
            _buildButtonRow(context, [
              ButtonLabel.four,
              ButtonLabel.five,
              ButtonLabel.six,
              ButtonLabel.subtract
            ]),
            _buildButtonRow(context, [
              ButtonLabel.one,
              ButtonLabel.two,
              ButtonLabel.three,
              ButtonLabel.add
            ]),
            _buildLastRow(context),
            const SizedBox(height: 35),
          ],
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Selector<ThemeProvider, bool>(
      selector: (context, viewmodel) => viewmodel.isLightMode,
      builder: (context, value, child) => Column(
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
                  result
                      ? Provider.of<HomeViewmodel>(context, listen: false)
                          .display
                      : Provider.of<HomeViewmodel>(context, listen: false)
                          .result,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 40,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),
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
                    : Provider.of<HomeViewmodel>(context).display,
                textAlign: TextAlign.end,
                style:
                    const TextStyle(fontSize: 96, fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstRow(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
            context,
            ButtonLabel.clear,
            () =>
                Provider.of<HomeViewmodel>(context, listen: false).resetAll()),
        _buildButton(
            context,
            ButtonLabel.changeSign,
            () => Provider.of<HomeViewmodel>(context, listen: false)
                .changeNegativeNumber()),
        _buildButton(
            context,
            ButtonLabel.percent,
            () => Provider.of<HomeViewmodel>(context, listen: false)
                .calculateAndUpdateDisplay()),
        _buildButton(
            context,
            ButtonLabel.divide,
            () => Provider.of<HomeViewmodel>(context, listen: false)
                .onButtonPressed(ButtonLabel.divide.label),
            isOperator: true),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context, List<ButtonLabel> buttons) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons
          .map((e) => _buildButton(
              context,
              e,
              () => Provider.of<HomeViewmodel>(context, listen: false)
                  .onButtonPressed(e.label),
              isOperator: e == ButtonLabel.subtract ||
                  e == ButtonLabel.add ||
                  e == ButtonLabel.multiply))
          .toList(),
    );
  }

  Widget _buildLastRow(BuildContext context) {
    return Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(
            context,
            ButtonLabel.decimal,
            () => Provider.of<HomeViewmodel>(context, listen: false)
                .onButtonPressed(ButtonLabel.decimal.label)),
        _buildButton(
            context,
            ButtonLabel.zero,
            () => Provider.of<HomeViewmodel>(context, listen: false)
                .onButtonPressed(ButtonLabel.zero.label)),
        _buildButton(context, ButtonLabel.delete,
            () => Provider.of<HomeViewmodel>(context, listen: false).delete()),
        _buildButton(
            context,
            ButtonLabel.equals,
            () => Provider.of<HomeViewmodel>(context, listen: false)
                .calculate(isPercent: false),
            isOperator: true),
      ],
    );
  }

  Widget _buildButton(
      BuildContext context, ButtonLabel label, VoidCallback onPressed,
      {bool isOperator = false}) {
    bool isLightMode = Provider.of<ThemeProvider>(context).isLightMode;
    Color color = isOperator
        ? MyAppColors.operatorColor
        : (isLightMode ? MyAppColors.whiteColor : MyAppColors.darkColor);
    Color titleColor = isLightMode
        ? (isOperator ? MyAppColors.whiteColor : MyAppColors.blackColor)
        : MyAppColors.whiteColor;
    return ButtonWidget(
      onPressed: onPressed,
      color: color,
      titleColor: titleColor,
      title: label.label,
    );
  }
}
