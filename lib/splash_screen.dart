import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:music_player/home_screen.dart';
import 'package:music_player/songs_list.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() async {
    Permission.audio.request();

    // TODO: implement initState
    if (await Permission.speech.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
      openAppSettings();
    }
    super.initState();
  }

  var height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return AnimatedSplashScreen(
      splash: Container(
        height: height * 0.2,
        width: width * 0.21,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("images/icon.png"))),
      ),

      nextScreen: SongList(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 1,
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.black,
      // pageTransitionType: ,
    );
  }
}
