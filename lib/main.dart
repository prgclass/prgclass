
import 'package:blackmovies/ui/Search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blackmovies/ui/Movies.dart';
import 'package:blackmovies/ui/Home.dart';
import 'package:blackmovies/ui/Series.dart';
import 'package:blackmovies/ui/splashscreen.dart';
void main() {
  runApp(MaterialApp(

    initialRoute: '/splash',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/home': (context) => const MyApp(),
    },
  ));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final Color colorAppBar = const Color(0xff161616);
  final defaultTextStyle = const TextStyle(fontFamily: 'IranSans');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Movie',
      theme: ThemeData(
        textTheme: TextTheme(
            bodyMedium: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
            titleLarge: defaultTextStyle.copyWith(fontWeight: FontWeight.bold)),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: TextStyle(shadows: <Shadow>[
            Shadow(
              color: Colors.orange.shade400,
              blurRadius: 20,
            )
          ]),
          selectedItemColor: Colors.orange.shade800,
          unselectedItemColor: Colors.orange,
          backgroundColor: colorAppBar,
          selectedIconTheme: IconThemeData(color: Colors.orange.shade800,shadows: <Shadow>[
            Shadow(
              color: Colors.orange.shade400,
              blurRadius: 30,
            )
          ]),
          unselectedIconTheme: IconThemeData(color: Colors.orange.shade500),
        ),
        appBarTheme: AppBarTheme(
          titleSpacing: 2,
          color: colorAppBar,
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl,
          child: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> listOptions = <Widget>[Home(), Movies(), Series()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: IconButton(
            color: Colors.orange.shade500,
            icon: Icon(CupertinoIcons.bars,
                size: MediaQuery.of(context).size.width * 0.1),
            onPressed: () {

            },
          ),
        ),
        actions:[
          Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: IconButton(
            color: Colors.orange.shade500,
            icon: Icon(CupertinoIcons.search_circle_fill,
                size: MediaQuery.of(context).size.width * 0.09),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(

                  builder: (context) => const SearchPage())
              );

            },
          ),
        ),],
        title: const Center(
            child: Text("بلک مووی", style: TextStyle(color: Colors.orange))),
      ),
      //==============================(Navbar)==================================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: "خانه"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.movie_creation_outlined), label: "فیلم ها"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.play_rectangle), label: "سریال ها"),
            ],
          ),
        ),
      ),
      //============================(END /Navbar)===============================
      body: listOptions.elementAt(_currentIndex),
    );
  }
}


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
//     _timer = Timer(const Duration(seconds: 5), () {
//       Navigator.of(context).pushReplacementNamed('/home');
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel(); // لغو تایمر در صورت خروج از ویجت
//     super.dispose();
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
//                 'assets/img/logo/logo.jpg',
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
//              CircularProgressIndicator(
//               color: Colors.orange.shade400,
//               backgroundColor: Colors.yellowAccent.shade700,
//               // valueColor:  AlwaysStoppedAnimation<Color>(Colors.yellowAccent.shade200),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
