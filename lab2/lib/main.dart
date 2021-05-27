import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Chat {
  String name;
  String msg;
  String time;
  String url;
  bool isRead;

  Chat({this.name, this.msg, this.time, this.url, this.isRead});

  static List<List<Chat>> dummy = [
    // Personal
    [
      Chat(
          name: "Drend Miller",
          msg: "Are u not ready?",
          time: "11:37 AM",
          url: "https://i.pravatar.cc/150?img=51",
          isRead: false),
      Chat(
          name: "Bobik",
          msg: "Fershtein",
          time: "12:00 AM",
          url: "https://i.pravatar.cc/150?img=52",
          isRead: false),
    ],

    // Groups
    [
      Chat(
          name: "IP-83",
          msg: "You: hi",
          time: "11:54 AM",
          url: 'https://i.pravatar.cc/150?img=21',
          isRead: true),
      Chat(
          name: "Rozrobotchik",
          msg: "Roma: В мене згорів компютер",
          time: "11:55 AM",
          url: 'https://i.pravatar.cc/150?img=22',
          isRead: true),
      Chat(
          name: "Lesa",
          msg: "You: Коли ?",
          time: "09:08 PM",
          url: 'https://i.pravatar.cc/150?img=23',
          isRead: true),
    ],
    // Channels
    [
      Chat(
          name: "IP-83-channel",
          msg: "Link to zoom...",
          time: "13:09 AM",
          url: 'https://i.pravatar.cc/150?img=33',
          isRead: true),
      Chat(
          name: "KPI-LIVE",
          msg: "[Photo]",
          time: "15:42 PM",
          url: 'https://i.pravatar.cc/150?img=34',
          isRead: true),
    ],
    // Bots
    [
      Chat(
          name: "Stickers",
          msg: "Stats for the sticker pack...",
          time: "Jan 14",
          url: 'https://i.pravatar.cc/150?img=36',
          isRead: true),
  ];
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Telegram'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer() {
    return Drawer(
        child: ListView(children: [
      UserAccountsDrawerHeader(
        accountName: Text('Міша Валігура'),
        accountEmail: Text('+380 ** *** ****'),
        onDetailsPressed: () {},
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.group),
        title: Text("New Group", style: TextStyle(fontSize: 16)),
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.person),
        title: Text("Contacts and Groups", style: TextStyle(fontSize: 16)),
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.settings),
        title: Text("Settings", style: TextStyle(fontSize: 16)),
      ),
      ListTile(
        dense: true,
        leading: Icon(Icons.info),
        title: Text("FAQ", style: TextStyle(fontSize: 16)),
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    var tab = Chat.dummy[_selectedIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: tab.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int i) =>
            _buildChatList(context, tab[i]),
      ),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
      bottomNavigationBar: _buildBar(),
    );
  }

  BottomNavigationBar _buildBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Personal',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb),
          label: 'Channels',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bug_report_outlined),
          label: 'Bots',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Widget _buildChatList(BuildContext context, Chat chat) {
    var theme = Theme.of(context);
    var icon = chat.isRead ? Icons.done_all : Icons.done;
    var firstRow = [
      Expanded(
          child: Text(chat.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      Icon(icon, color: Colors.green, size: 20),
      SizedBox(width: 5),
      Text(chat.time, style: theme.textTheme.caption.copyWith(fontSize: 14)),
    ];

    var secondRow = [
      Expanded(
          child: Text(
        chat.msg,
        style: theme.textTheme.subtitle1.copyWith(color: Colors.grey[600]),
      ))
    ];

    return InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 75,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(chat.url),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(mainAxisSize: MainAxisSize.max, children: firstRow),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            children: secondRow),
                      ],
                    ),
                  ))
                ],
              )),
          Divider(indent: 72, height: 0, color: Colors.grey[400]),
        ],
      ),
      onTap: () {},
    );
  }
}
