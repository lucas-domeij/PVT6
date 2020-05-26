import 'dart:convert';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/friendsAndContacts/addContactPage.dart';
import 'package:frontend/friendsAndContacts/contactsModel.dart';
import 'package:frontend/friendsAndContacts/sentRequest.dart';
import 'package:frontend/userFiles/addDogTest.dart';
import 'package:frontend/userFiles/dogProfile.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/userFiles/user.dart' as userlib;

import '../dog.dart';

List<User> friends = [];

const colorPurple = const Color(0xFF82658f);
const colorPeachPink = const Color(0xFFffdcd2);
const colorLighterPink = const Color(0xFFffe9e5);
List<SentRequest> sentRequest = [];
List<SentRequest> waitingRequest = [];

Future<void> getInfo() async {
  //sentRequests

  var url =
      'https://group6-15.pvt.dsv.su.se/contacts/sentRequests?uid=${userlib.uid}';
  var response = await http.get(Uri.parse(url));
  sentRequest = (json.decode(response.body) as List)
      .map((i) => SentRequest.fromJson(i))
      .toList();
  print(response.statusCode);

  url =
      'https://group6-15.pvt.dsv.su.se/contacts/waitingRequests?uid=${userlib.uid}';
  response = await http.get(Uri.parse(url));
  waitingRequest = (json.decode(response.body) as List)
      .map((i) => SentRequest.fromJson(i))
      .toList();
  print(response.statusCode);

  url = 'https://group6-15.pvt.dsv.su.se/contacts/all?uid=${userlib.uid}';
  response = await http.get(Uri.parse(url));
  if (response.body != "") {
    final body = json.decode(response.body);

    print("LOAD FRIENDS");
    friends = (json.decode(jsonEncode(body["user"])) as List)
        .map((i) => User.fromJson(i))
        .toList();
    print(response.statusCode);
  } else {
    print("NO FRIENDS");
    friends.clear();
  }
}

class FriendsPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  List<SentRequest> receivingRequests = [];

  @override
  void initState() {
    getInfo();
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  cancleRequestAlert(BuildContext context, phone) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    Widget acceptButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: 100,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Navigator.of(context).pop();
          var url = 'https://group6-15.pvt.dsv.su.se/contacts/cancleRequests';

          var response = await http
              .post(Uri.parse(url), body: {'uid': userlib.uid, 'phone': phone});
          print(response.statusCode);
          getInfo();
        },
        child: Text("Yes",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text("Friend Request"),
      content: Text("Do you really want to cancle this friend request"),
      actions: [
        cancelButton,
        acceptButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialog(BuildContext context, phone) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Decline"),
      onPressed: () async {
        var url = 'https://group6-15.pvt.dsv.su.se/contacts/answer';

        var response = await http.post(Uri.parse(url),
            body: {'uid': userlib.uid, 'phone': phone, 'e': 'rejcet'});
        print(response.statusCode);
        getInfo();

        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    Widget acceptButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: 100,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          var url = 'https://group6-15.pvt.dsv.su.se/contacts/answer';
          var response = await http.post(Uri.parse(url),
              body: {'uid': userlib.uid, 'phone': phone, 'e': 'accept'});
          print(response.statusCode);
          getInfo();
          Navigator.of(context).pop(); // dismiss dialog
        },
        child: Text("Accept",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text("Friend Request"),
      content: Text("This user would like to add you"),
      actions: [
        cancelButton,
        acceptButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: colorLighterPink,
      appBar: new AppBar(
        title: new Text("Friends Page"),
        centerTitle: true,
        backgroundColor: colorPurple,
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            new Tab(icon: new Icon(Icons.person)),
            new Tab(
              icon: new Icon(Icons.person_add),
            ),
            new Tab(
              icon: new Icon(Icons.search),
            )
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    // Text("My Friendlist", //snyggare font/text behövs
                    // style: TextStyle(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 18.0,
                    //           letterSpacing: 1.1),),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                friends != null
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: friends?.length ??
                            0, //lägga till vår egen lista på denna bör funka
                        itemBuilder: (BuildContext context, int index) {
                          User c = friends?.elementAt(index);
                          return Card(
                              elevation: 8.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ProfileInfo(c)));
                                },
                                leading: CircleAvatar(child: Text("PH")),
                                title: Text(c.name ?? ""),
                                subtitle: Text("Stockholm, Vällingby . 53 min"),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.person_pin,
                                    color: Colors.black,
                                    size: 37,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                InputPage()));
                                  },
                                ),
                              ));
                        },
                      )
                    : Center(
                        child: Text("No friends added",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 17)),
                      ),
              ])),
          SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(children: <Widget>[
                Row(
                  children: <Widget>[
                    //titel och Icon här
                  ],
                ),
                Divider(
                  thickness: 3,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Friend requests",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    waitingRequest != null
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: waitingRequest?.length ??
                                0, //lägga till vår egen lista på denna bör funka
                            itemBuilder: (BuildContext context, int index) {
                              SentRequest c = waitingRequest?.elementAt(index);
                              return Card(
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ProfileInfo(c.sender)));
                                      },
                                      leading: CircleAvatar(child: Text("PH")),
                                      title: Text(c.sender.name ?? ""),
                                      subtitle:
                                          Text(c.sender.phoneNumber ?? ""),
                                      trailing: (() {
                                       IconButton b;

                                        // HÄR BEHÖVS ICONER FÖR WAITING REJECTED OCH ACCEPTED
                                        if(c.status == "WAITING"){
                                        b = IconButton(
                                          icon: Icon(
                                            Icons.person_add,
                                            color: Colors.green,
                                            size: 37,
                                          ),
                                          onPressed: () {
                                            showAlertDialog(
                                                context, c.sender.phoneNumber);
                                          },
                                        );
                                        }
                                        else if(c.status == "ACCEPTED") {
                                       b =  IconButton(
                                          icon: Icon(
                                            Icons.done,
                                            color: Colors.green,
                                            size: 37,
                                          ),
                                          onPressed: () {
                                            
                                          },
                                        );
                                        }
                                         else  {
                                       b =  IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                            size: 37,
                                          ),
                                          onPressed: () {
                                            
                                          },
                                        );
                                        }
                                        return b;
                                      }())
                                      //onPressed Lägger till i vänner och tar bort från lista
                                      ));
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    Text(
                      "Pending Requests",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    sentRequest != null
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: sentRequest?.length ??
                                0, //lägga till vår egen lista på denna bör funka
                            itemBuilder: (BuildContext context, int index) {
                              SentRequest c = sentRequest?.elementAt(index);
                              return Card(
                                  elevation: 8.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ProfileInfo(c.receiver)));
                                    },
                                    leading: CircleAvatar(child: Text("PH")),
                                    title: Text(c.receiver.name ?? ""),
                                    subtitle:
                                        Text(c.receiver.phoneNumber ?? ""),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.hourglass_empty,
                                        color: Colors.yellow,
                                        size: 37,
                                      ),
                                      onPressed: () {
                                        cancleRequestAlert(
                                            context, c.receiver.phoneNumber);
                                      },
                                    ),
                                  ));
                            },
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ],
                )
              ])),
          SearchUsers()
        ],
        controller: _tabController,
      ),
    );
  }
}

class SearchUsers extends StatefulWidget {
  SearchUsers({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SearchUsers> {
  TextEditingController editingController = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _formKey = GlobalKey<FormState>();
  bool userExists = true;

  var items = List<User>();

  showAlertDialogApproved(BuildContext context) {
    // set up the buttons
    getInfo();
    Widget okButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop(); // dismiss dialog
        },
        child: Text("Ok",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text("Friend request sent"),
      content: Text(
          "When this user accept your request they will show up in your friendlist"),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogDeclined(BuildContext context) {
    getInfo();
    // set up the buttons
    Widget okButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.of(context).pop(); // dismiss dialog
        },
        child: Text("Ok",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text("No User Found"),
      content: Text(
          "Please make sure that phonenumber is correct and that the user is registered"),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String phone;
    return new Scaffold(
      backgroundColor: colorLighterPink,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Add By Number",
                            hintText: "ex:0701112233",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)))),
                        validator: (val) =>
                            val.isEmpty ? 'Enter a phonenumber.' : null,
                        onChanged: (val) {
                          phone = val;
                          //setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                          child: Text('add User'),
                          onPressed: () async {
                            if (phone != null) {
                              var url =
                                  'https://group6-15.pvt.dsv.su.se/contacts/new';

                              var response = await http.post(Uri.parse(url),
                                  body: {
                                    'sendUid': userlib.uid,
                                    'phone': phone
                                  });
                              if (response.statusCode == 200) {
                                if (response.body == "Sent friend request") {
                                  showAlertDialogApproved(context);
                                } else {
                                  showAlertDialogDeclined(context);
                                }
                              }
                            }
                          })
                    ])))
          ],
        ),
      ),
    );
  }
}

class ProfileInfo extends StatefulWidget {
  final User user;

  ProfileInfo(this.user);

  @override
  ProfileInfoState createState() => new ProfileInfoState();
}

class ProfileInfoState extends State<ProfileInfo> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  showAlertDialog(BuildContext context) {
    Widget okButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          Navigator.of(context).pop(); // dismiss dialog
           var url = 'https://group6-15.pvt.dsv.su.se/contacts/remove';

          var response = await http
              .post(Uri.parse(url), body: {'uid': userlib.uid, 'phone': widget.user.phoneNumber});
          print(response.statusCode);
          getInfo();
        },
        child: Text("Ok",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text("Remove as friend"),
      content: Text("You are no longer friends"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeader(
              avatar: new AssetImage("profilePH.png"), //userData
              coverImage: new AssetImage("backgroundStockholm.png"), //userData
              title: widget.user.name, //userData
              subtitle: "Dog lover",
              actions: <Widget>[
                //Row med items

                SizedBox(
                  width: 230,
                ),
                true
                    // CONTACTS
                    ? MaterialButton(
                        color: Colors.green,
                        shape: BeveledRectangleBorder(),
                        elevation: 0,
                        child: Icon(Icons.person_add),
                        onPressed: () {
                          showAlertDialog(context);
                        },
                      )
                    : MaterialButton(
                        color: Colors.red,
                        shape: BeveledRectangleBorder(),
                        elevation: 0,
                        child: Icon(Icons.remove_circle),
                        onPressed: () {
                          setState(() {
                            //widget.user.friendstatus = true;
                          });
                        },
                      ),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                   Container(
              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
              alignment: Alignment.topLeft,
              child: BorderedText(
                strokeWidth: 5.0,
                strokeColor: colorPurple,
                child: Text(
                  "My Dogs",
                  style: TextStyle(
                    color: colorLighterPink,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
              )),
          SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                height: 70,
                child: widget.user.ownedDog != null
                    ? ListView.builder(
                        //https://pusher.com/tutorials/flutter-listviews

                        shrinkWrap: true,
                        itemCount: widget.user.ownedDog?.length ?? 0,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          Dog c = widget.user.ownedDog?.elementAt(index);
                          return (c.name != null && c.name.length > 0)
                              ? SizedBox(
                                  child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DogProfile(c)),
                                    );
                                  },
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset(
                                        'BrewDog.jpg',
                                      ),
                                    ),
                                  ),
                                ))
                              : SizedBox(
                                  child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DogProfile(c)),
                                    );
                                  },
                                  child: Container(
                                    width: 75,
                                    height: 75,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.asset(
                                        'BrewDog.jpg',
                                      ),
                                    ),
                                  ),
                                ));
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              )),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "User Information", //userData
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              ...ListTile.divideTiles(
                                color: Colors.grey,
                                tiles: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    leading: Icon(Icons.my_location),
                                    title: Text(
                                      "Location",
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                    subtitle: Text(
                                      "Stockholm",
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.email),
                                    title: Text(
                                      "Email",
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                    subtitle: Text(
                                      widget.user.email,
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.phone),
                                    title: Text(
                                      "Phone",
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                    subtitle: Text(
                                      widget.user.phoneNumber,
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(
                                      "About Me",
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                    subtitle: Text(
                                      "I love big fluffy dogs. Proud owner of a Bernese Mountain Dog",
                                      style: TextStyle(
                                          color: Colors.blue.shade300),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      @required this.coverImage,
      @required this.avatar,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 60,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      @required this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image,
        ),
      ),
    );
  }
}
