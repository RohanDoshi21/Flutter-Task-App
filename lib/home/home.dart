import 'dart:convert';
import 'dart:ui';

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

  bool _bool = true;

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
                  actions: [
                    IconButton(
                        onPressed: () {
                          showDialogWithFields();
                        },
                        icon: const Icon(Icons.add))
                  ],
                  leading: IconButton(
                    icon: Icon(Icons.menu_rounded),
                    splashColor: Colors.transparent,
                    onPressed: () {
                      setState(() {
                        _bool = false;
                      });
                    },
                  ),
                ),
              ),
            ),
            // drawer: const Drawer(),
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
                            return card(taskList[taskList.length - index - 1]);
                          }),
                    ),
                  ],
                ),
                CustomNavigationDrawer(),
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
              btnCancelOnPress: () async {
                Map<String, String> header = {
                  "Authorization": "Bearer ${User.token}"
                };
                try {
                  final response = await http
                      .delete(Uri.parse(deleteTask + task.id), headers: header);
                  if (response.statusCode == 200) {
                    taskList.remove(task);
                    setState(() {
                      load = false;
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Task not deleted try again later',
                      backgroundColor: Colors.red.shade600,
                    );
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Please try again later',
                    backgroundColor: Colors.red.shade600,
                  );
                }
              },
              btnOkText: task.completed ? "Mark Pending" : "Mark Complete",
              btnOkOnPress: () async {
                Map<String, String> header = {
                  "Authorization": "Bearer ${User.token}",
                  "Content-Type": "application/json"
                };
                try {
                  Map data = {
                    "completed": !task.completed,
                  };
                  final response = await http.patch(
                      Uri.parse(updateTask + task.id),
                      headers: header,
                      body: jsonEncode(data));
                  if (response.statusCode == 200) {
                    task.completed = !task.completed;
                    setState(() {
                      load = false;
                    });
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Task not updated try again later',
                      backgroundColor: Colors.red.shade600,
                    );
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Please try again later',
                    backgroundColor: Colors.red.shade600,
                  );
                }
              },
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

  void showDialogWithFields() {
    final TextEditingController _desc = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Size size = MediaQuery.of(context).size;
          return AlertDialog(
            backgroundColor: Colors.white.withOpacity(.85),
            scrollable: true,
            title: Text(
              'New Task',
              style: TextStyle(color: Colors.black.withOpacity(.9)),
            ),
            content: Container(
              // height: size.height * 0.08,
              width: size.width,
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: size.width / 30),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  controller: _desc,
                  style: TextStyle(
                    color: Colors.black.withOpacity(.9),
                  ),
                  minLines: 1,
                  maxLines: 8,
                  // allow user to enter 5 line in textfield
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "description",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                ),
              ),
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            actions: [
              InkWell(
                child: Container(
                  height: size.height * 0.04,
                  width: size.width * 0.15,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "Add",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.green, fontSize: 20),
                    ),
                  ),
                ),
                onTap: () async {
                  Map<String, String> header = {
                    "Authorization": "Bearer ${User.token}",
                    "Content-Type": "application/json"
                  };
                  try {
                    Map data = {
                      "description": _desc.text.trim(),
                    };
                    final response = await http.post(Uri.parse(createTask),
                        headers: header, body: jsonEncode(data));
                    if (response.statusCode == 201) {
                      var data = jsonDecode(response.body);
                      taskList.add(Task.fromJson(data));
                      setState(() {});
                    } else {
                      Fluttertoast.showToast(
                        msg: 'Task not created try again later',
                        backgroundColor: Colors.red.shade600,
                      );
                    }
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: 'Please try again later',
                      backgroundColor: Colors.red.shade600,
                    );
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Widget CustomNavigationDrawer() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _bool = true;
        });
        return false;
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _bool ? 0 : 10.0, sigmaY: _bool ? 0 : 10.0),
        child: Container(
          height: _bool ? 0 : _height,
          width: _bool ? 0 : _width,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: _width * .8,
              height: _height * .45,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: _height * 0.015,
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.black12,
                      radius: 45,
                      child: Icon(
                        Icons.person_outline_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.015,
                    ),
                    Flexible(
                      child: Text(
                        User.name.toString(),
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.007,
                    ),
                    Flexible(
                      child: Text(
                        User.email.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Container(
                            height: _height * 0.04,
                            width: _width * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Center(
                              child: Text(
                                "Delete",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                          ),
                          onTap: () async {},
                        ),
                        InkWell(
                          child: Container(
                            height: _height * 0.04,
                            width: _width * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Logout",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red[400], fontSize: 20),
                              ),
                            ),
                          ),
                          onTap: () async {},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _height * 0.055,
                    ),
                    const Text(
                      "This app is made by Rohan Doshi",
                      style: TextStyle(fontSize: 19),
                    ),
                    SizedBox(
                      height: _height * 0.015,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
