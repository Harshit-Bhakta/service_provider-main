  import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
  import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_provider/Controllers/OrderController.dart';
  import 'package:service_provider/Pages/launcher.dart';
  import 'package:firebase_core/firebase_core.dart';
import 'Controllers/providersController.dart';
import 'firebase_options.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundNotificationHandler);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    runApp(const MyApp());
  }

  @pragma('vm:entry-point')
  Future<void> _firebaseBackgroundNotificationHandler(RemoteMessage message)async{
    await Firebase.initializeApp();
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      Get.put(ProvidersController());
      Get.put(OrderController());
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        builder: EasyLoading.init(),
        home: const launcherPage(),
        theme: ThemeData(
          buttonTheme: ButtonThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.lightBlueAccent.shade100,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(45),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(45),
              borderSide: BorderSide(
                  color: Colors.black,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(45),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.lightBlueAccent,
            selectedIconTheme: IconThemeData(
              size: 30,
            ),
            unselectedItemColor: Colors.grey,
            unselectedIconTheme: IconThemeData(
              size: 20,
            )
          )
        ),
      );
    }
  }
