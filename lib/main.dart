
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/scheduleprovider.dart';
import 'utils/colorconstants.dart';
import 'utils/utils.dart';
import 'view/pages/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScheduleProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: canvasColor,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: primaryColor,
          ),
          textTheme: TextTheme(
            headline1: Utils().textStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: scheduleTextColor),
            headline2:
                Utils().textStyle(fontSize: 13, color: addScheduleSubtitle),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
