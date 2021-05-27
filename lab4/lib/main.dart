import 'package:flutter/material.dart';
import 'package:lab4/activity.dart';
import 'package:lab4/anomation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeParams themeParams = ThemeParams();

  @override
  void initState() {
    super.initState();
    themeParams.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var mode = themeParams.themeMode;
    print("Set mode to $mode");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeParams.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(
              title: 'What to do?',
              themeParams: themeParams,
            ),
        '/animations': (context) => AnimationPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.themeParams}) : super(key: key);
  final String title;
  final ThemeParams themeParams;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Activity> futureActivity;
  Activity activity;
  bool valid = false;

  @override
  void initState() {
    super.initState();
    futureActivity = fetchNextActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/animations'),
                child: Icon(
                  Icons.animation,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () => widget.themeParams.switchMode(),
                child: Icon(
                  widget.themeParams.themeMode == ThemeMode.light
                      ? Icons.brightness_4
                      : Icons.brightness_2,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  var edited = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditPage(activity.activity))) ??
                      activity.activity;

                  setState(() {
                    activity.activity = edited;
                  });
                },
                child: Icon(
                  Icons.edit,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            valid
                ? buildActivity(activity)
                : FutureBuilder(
                    future: futureActivity,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        valid = true;
                        activity = snapshot.data;
                        return buildActivity(activity);
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              valid = false;
              futureActivity = fetchNextActivity();
            });
          },
          tooltip: 'Switch activity',
          child: Icon(Icons.refresh)),
    );
  }
}

class ThemeParams with ChangeNotifier {
  bool _dark;

  ThemeMode get themeMode => _dark ? ThemeMode.dark : ThemeMode.light;

  ThemeParams() {
    _dark = false;
    SharedPreferences.getInstance().then((prefs) {
      _dark = prefs.getBool("darkTheme") ?? false;
      notifyListeners();
    });
  }
  void setMode(ThemeMode newMode) {
    _dark = newMode == ThemeMode.dark;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("darkTheme", _dark);
    });
    notifyListeners();
  }

  void switchMode() {
    _dark = !_dark;
    print("set dark to $_dark");
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("darkTheme", _dark);
    });
    notifyListeners();
  }
}

class EditPage extends StatefulWidget {
  final String toEdit;
  EditPage(this.toEdit);
  @override
  State<StatefulWidget> createState() {
    return EditPageState(toEdit);
  }
}

class EditPageState extends State<EditPage> {
  String toEdit;
  EditPageState(this.toEdit);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              autofocus: true,
              initialValue: toEdit,
              onChanged: (String newValue) => toEdit = newValue,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, toEdit);
                },
                child: Text('Ok'))
          ],
        ),
      ),
    );
  }
}

Widget buildActivity(Activity act) {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
      children: [
        Container(
          width: 500,
          child: Text(
            act.activity,
            softWrap: true,
            textScaleFactor: 2.0,
            textAlign: TextAlign.left,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(act.type, style: TextStyle(color: Colors.grey)),
            Container(
              child: Row(
                children: [
                  Icon(
                    Icons.group,
                    color: Colors.grey,
                  ),
                  Text("${act.participants}",
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.attach_money,
                    color: Colors.grey,
                  ),
                  Text("${act.price}", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          ],
        ),
      ],
    ),
  );
}
