import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task_app/Urls/urls.dart';
import 'package:flutter_task_app/UserInfo/task.dart';
import 'package:flutter_task_app/UserInfo/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter_task_app/UserInfo/info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Task> taskList = [];
  bool load = true;

  Future getTasks() async {
    // print("${User.token}");
    Map<String, String> headers = {"Authorization": "Bearer ${User.token}"};
    taskList.clear();
    try {
      final response = await http.get(Uri.parse(getTasksUrl), headers: headers);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        for (var item in data) {
          taskList.add(Task.fromJson(item));
        }
        setState(() {
          load = false;
        });
      } else {
        Fluttertoast.showToast(
          msg: 'Tasks are not available',
          backgroundColor: Colors.red.shade600,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Please try again later',
        backgroundColor: Colors.red.shade600,
      );
    }
  }

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    return load
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                Column(
                  children: [
                    SizedBox(height: _w / 40.1),
                    Expanded(
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: taskList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return card(taskList[index]);
                          }),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  Widget card(Task task) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Opacity(
      opacity: 0.95,
      child: Container(
        width: _w,
        padding: EdgeInsets.fromLTRB(_w / 20, 0, _w / 20, _w / 20),
        child: GestureDetector(
          onLongPress: () {
            HapticFeedback.lightImpact();
            AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              headerAnimationLoop: false,
              title: 'Update Task',
              desc: 'Select the follow to proceed or back button to cancel',
              btnCancelText: "Delete",
              btnCancelOnPress: () {
                getTasks();
              },
              btnOkText: task.completed ? "Mark Pending" : "Mark Complete",
              btnOkOnPress: () {},
              dismissOnTouchOutside: true,
            ).show();
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
                    task.title,
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
                    task.completed ? "Completed" : "Remaining",
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: task.completed
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
