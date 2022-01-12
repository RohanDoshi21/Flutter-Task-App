import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_task_app/UserInfo/info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white.withOpacity(.5),
            elevation: 0,
            title: Text(
              "Flutter Task App",
              style: TextStyle(
                fontSize: _w / 17,
                color: Colors.black.withOpacity(.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
      drawer: const Drawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bgimage.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          ListView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            children: [
              SizedBox(height: _w / 40.1),
              card('This is the first task that I created!', false),
              card('Example example example', true),
              card('Example example example', false),
              card('Example example example', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget card(String title, bool status) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Opacity(
      opacity: 0.95,
      child: Container(
        width: _w,
        padding: EdgeInsets.fromLTRB(_w / 20, 0, _w / 20, _w / 20),
        child: GestureDetector(
          // highlightColor: Colors.transparent,
          // splashColor: Colors.transparent,
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserInfo()));
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                border:
                Border.all(color: Colors.white.withOpacity(.1), width: 1)),
            child: Padding(
              padding: EdgeInsets.all(_w / 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _w / 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      wordSpacing: 1,
                    ),
                  ),
                  SizedBox(
                    height: _h * 0.0052,
                  ),
                  Text(
                    status ? "Completed" : "Remaining",
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: status
                          ? Colors.green.withOpacity(1)
                          : Colors.red.withOpacity(1),
                      fontSize: _w / 23,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: _h * 0.0052,
                  ),
                  Text(
                    'Hold to for more options!',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: _w / 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
