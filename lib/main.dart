import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/sign_in.dart';
import 'screens/sign_up.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(MyApp());
  //   MultiProvider(
  //     providers: [
  //       // ChangeNotifierProvider(create: ((context) => AuthProvider())),
  //       // ChangeNotifierProvider(create: ((context) => UserProvider())),
  //     ],
  //     child: MyApp(),
  //   )
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'AllowancePal',
      home: SignInPage(),
    );
  }
}
