import 'package:calculator/screens/views/home_screenVM.dart';
import 'package:calculator/utils/app_colors.dart';
import 'package:calculator/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import '../operations/calculations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenVM viewModel = HomeScreenVM();
  TextEditingController itemcontroller = TextEditingController();

  String outputtext = '';
  double _fontsize = 40;
  final List numbers = [
    'c',
    '÷',
    '×',
    '7',
    '8',
    '9',
    '4',
    '5',
    '6',
    '1',
    '2',
    '3',
    '%',
    '0',
    '.',
  ];

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    ScreenUtils.screensize(screenwidth, screenheight);

    return SafeArea(
        child: Scaffold(
            body: Container(
      color: AppColors.backgroundcolor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            inputTextFeild(),
            Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtils.getscreenwidth() / 55,
                  bottom: ScreenUtils.getscreenheight() / 50),
              child: resultText(
                  font: 30,
                  displaytext: outputtext,
                  txtcolor: AppColors.resultcolor),
            ),
            Container(
              color: AppColors.keycolor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  gridviewnumber(),
                  SizedBox(
                    height: ScreenUtils.getscreenheight() / 2.1,
                    width: ScreenUtils.getscreenwidth() * (1 / 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        gridviewoperator(),
                        equalToButton(),
                      ],
                    ),
                  )
                ],
              ),
            )
          ]),
    )));
  }

  Widget inputTextFeild() {
    return SizedBox(
      child: TextFormField(
          autofocus: true,
          textAlign: TextAlign.right,
          readOnly: true,
          controller: itemcontroller,
          maxLines: null,
          showCursor: true,
          style:
              TextStyle(fontSize: _fontsize, color: AppColors.inputtextColor),
          cursorColor: AppColors.secondarycolor,
          cursorHeight: 40,
          decoration: const InputDecoration(
              enabled: true,
              border: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true)),
    );
  }

  Widget resultText(
      {required double font,
      required String displaytext,
      Color? txtcolor = AppColors.primaryColor}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      padding: const EdgeInsets.only(right: 10),
      child: Text(
        maxLines: 1,
        displaytext,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: font, color: txtcolor),
      ),
    );
  }

  Widget gridviewnumber() {
    return SizedBox(
        height: ScreenUtils.getscreenheight() / 2.1,
        width: ScreenUtils.getscreenwidth() * (3 / 4),
        child: GridView.count(
            childAspectRatio: ScreenUtils.getscreenwidth() /
                ScreenUtils.getscreenheight() /
                0.38,
            crossAxisCount: 3,
            shrinkWrap: false,
            children: List.generate(15, (index) {
              return SizedBox(
                height: ScreenUtils.getscreenheight() / 10,
                width: ScreenUtils.getscreenheight() / 10,
                child: TextButton(
                  onPressed: (() {
                    setState(() {
                      _fontsize = CalculatorOperation.fontsize;
                      viewModel.operators(
                          operatorname: numbers[index],
                          itemcontroller: itemcontroller);
                      outputtext = '${CalculatorOperation.getresult()}';
                    });
                  }),
                  child: Center(
                      child: Text(
                    '${numbers[index]}',
                    style: TextStyle(
                      color: index <= 2
                          ? AppColors.secondarycolor
                          : AppColors.primaryColor,
                      fontSize: 35,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
                ),
              );
            })));
  }

  Widget gridviewoperator() {
    return SizedBox(
        height: ScreenUtils.getscreenheight() / 3.51,
        width: ScreenUtils.getscreenwidth() * (1 / 4),
        child: GridView.count(
            childAspectRatio: ScreenUtils.getscreenwidth() /
                ScreenUtils.getscreenheight() /
                0.37,
            crossAxisCount: 1,
            shrinkWrap: false,
            children: [
              operatoricons(
                  iconname: Icons.backspace_outlined, operatorname: ''),
              operatoricons(
                  iconname: Icons.horizontal_rule_rounded, operatorname: '-'),
              operatoricons(iconname: Icons.add, operatorname: '+'),
            ]));
  }

  Widget operatoricons(
      {required IconData iconname, required String operatorname}) {
    return SizedBox(
      height: ScreenUtils.getscreenheight() / 10.58,
      width: ScreenUtils.getscreenheight() / 10.58,
      child: TextButton(
        onPressed: (() {
          setState(() {
            _fontsize = CalculatorOperation.fontsize;
            viewModel.operators(
                operatorname: operatorname, itemcontroller: itemcontroller);
            outputtext = '${CalculatorOperation.getresult()}';
          });
        }),
        child: Center(
          child: Icon(
            iconname,
            color: AppColors.secondarycolor,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget equalToButton() {
    return AspectRatio(
      aspectRatio:
          ScreenUtils.getscreenwidth() / ScreenUtils.getscreenheight() / 0.7,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtils.getscreenwidth() / 22,
        ),
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.secondarycolor,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: TextButton(
              onPressed: () {
                setState(() {
                  if (CalculatorOperation.result != '') {
                    itemcontroller.clear();
                    viewModel.insertText(
                        myText: outputtext, itemcontroller: itemcontroller);
                    outputtext = '0';
                    CalculatorOperation.result = '';
                  }
                });
              },
              child: const Text(
                '=',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                ),
              )),
        ),
      ),
    );
  }
}
