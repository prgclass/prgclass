// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   late Timer _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkInternetAndNavigate();
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }
//
//   void _checkInternetAndNavigate() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi) {
//       _timer = Timer(const Duration(seconds: 5), () {
//         Navigator.of(context).pushReplacementNamed('/home');
//       });
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('خطا'),
//             content: const Text('اتصال اینترنت وجود ندارد.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('باشه'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               height: 160,
//               width: 160,
//               child: Image.asset(
//                 'assets/img/logo/logo.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'بلک مووی',
//               style: TextStyle(
//                 color: Colors.orange,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             CircularProgressIndicator(
//               color: Colors.orange.shade400,
//               backgroundColor: Colors.yellowAccent.shade700,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _checkInternetAndNavigate();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('خطای اتصال'),
            content: const Text('اتصال اینترنت وجود ندارد.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('باشه'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _checkInternetAndNavigate() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = await _isConnectedToInternet();

    if ((connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.vpn) &&
        isConnected) {
      _timer = Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    } else {
      _showNoInternetDialog();
      await Future.delayed(const Duration(seconds: 2)); // انتظار 2 ثانیه
      connectivityResult = await Connectivity().checkConnectivity();
      isConnected = await _isConnectedToInternet();
      if ((connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.vpn) &&
          isConnected) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }


  Future<bool> _isConnectedToInternet() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://www.google.com');
      dio.close();

      return response.statusCode == 200;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 403) {
        return true;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 160,
              width: 160,
              child: Image.asset(
                'assets/img/logo/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'بلک مووی',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                'برای اتصال بهتر فیلترشکن خود را خاموش کنید.',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CircularProgressIndicator(
              color: Colors.orange.shade400,
              backgroundColor: Colors.yellowAccent.shade700,
            ),
          ],
        ),
      ),
    );
  }
}
