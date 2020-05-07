import 'package:flutter/material.dart';

List<User> friends = [
  User('Lina', "123@gmail.com", '456', false),
  User('Karl', "123@gmail.com", '789', true),
  User('Ella', "123@gmail.com", '123', true),
  User('Marika', "123@gmail.com", '456', false),
  User('Pär', "123@gmail.com", '789', true),
  User('Mattias', "123@gmail.com", '123', true),
  User('Viktor', "123@gmail.com", '456', false),
  User('Emma', "123@gmail.com", '789', true),
  User('Daniel', "123@gmail.com", '123', true),
  User('Johanna', "123@gmail.com", '456', false),
  User('Kevin', "123@gmail.com", '789', true),
];
List<User> users = [
  User('Jakob', "123@gmail.com", '123', true),
  User('Sharon', "123@gmail.com", '123', false),
  User('Erik', "123@gmail.com", '123', true)
];

List<User> databaseUser = [
  User('Jakob', "123@gmail.com", '123', true),
  User('Sharon', "123@gmail.com", '456', false),
  User('Erik', "123@gmail.com", '789', true),
  User('Johan', "123@gmail.com", '123', true),
  User('Lina', "123@gmail.com", '456', false),
  User('Karl', "123@gmail.com", '789', true),
  User('Ella', "123@gmail.com", '123', true),
  User('Marika', "123@gmail.com", '456', false),
  User('Pär', "123@gmail.com", '789', true),
  User('Mattias', "123@gmail.com", '123', true),
  User('Viktor', "123@gmail.com", '456', false),
  User('Emma', "123@gmail.com", '789', true),
  User('Daniel', "123@gmail.com", '123', true),
  User('Johanna', "123@gmail.com", '456', false),
  User('Kevin', "123@gmail.com", '789', true),
  User('Elsa', "123@gmail.com", '123', true),
  User('Sara', "123@gmail.com", '456', false),
  User('Emil', "123@gmail.com", '789', true),
  User('Joel', "123@gmail.com", '123', true),
  User('Siri', "123@gmail.com", '456', false),
  User('Eskil', "123@gmail.com", '789', true),
  User('Simon', "123@gmail.com", '123', true),
  User('Linn', "123@gmail.com", '456', false),
  User('Linda', "123@gmail.com", '789', true),
  User('Habib', "123@gmail.com", '123', true),
  User('Ashraf', "123@gmail.com", '456', false),
  User('Lukas', "123@gmail.com", '789', true),
  User('John', "123@gmail.com", '123', true),
  User('Daniella', "123@gmail.com", '456', false),
  User('Trött', "123@gmail.com", '789', true),
  User('På', "123@gmail.com", '123', true),
  User('Namn', "123@gmail.com", '456', false),
  User('Nu', "123@gmail.com", '789', true),
];

class FriendsPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<FriendsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Decline"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Accept"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Friend Request"),
      content: Text("This user would like to add you"),
      actions: [
        cancelButton,
        continueButton,
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
      appBar: new AppBar(
        title: new Text("Friends Page"),
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
          SafeArea(
              child: Column(
            children: <Widget>[
              Text("Friendlist"),
              friends != null
                  ? Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                        itemCount: friends?.length ??
                            0, //lägga till vår egen lista på denna bör funka
                        itemBuilder: (BuildContext context, int index) {
                          User c = friends?.elementAt(index);
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProfileInfo(c)));
                            },
                            leading: CircleAvatar(child: Text("PH")),
                            title: Text(c.name ?? ""),
                          );
                        },
                      ))
                  : Center(
                      child: Text("No friends added",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17)),
                    ),
            ],
          )),
          SafeArea(
            child: users != null
                ? Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: users?.length ??
                          0, //lägga till vår egen lista på denna bör funka
                      itemBuilder: (BuildContext context, int index) {
                        User c = users?.elementAt(index);
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProfileInfo(c)));
                          },
                          leading: CircleAvatar(child: Text("PH")),
                          title: Text(c.name ?? ""),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.person_add,
                              color: Colors.green,
                              size: 37,
                            ),
                            onPressed: () {
                              showAlertDialog(context);
                            },
                          ), //onPressed Lägger till i vänner och tar bort från lista
                        );
                      },
                    ))
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          SearchUsers()
        ],
        controller: _tabController,
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String phone;
  bool friendstatus;

  User(this.name, this.email, this.phone, this.friendstatus);
}

class SearchUsers extends StatefulWidget {
  SearchUsers({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SearchUsers> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = [
    User('Jakob', "123@gmail.com", '0763085859', true),
    User('Sharon', "123@gmail.com", '456', false),
    User('Erik', "123@gmail.com", '0763085858', true),
    User('Johan', "123@gmail.com", '123', true),
    User('Lina', "123@gmail.com", '456', false),
    User('Karl', "123@gmail.com", '789', true),
    User('Ella', "123@gmail.com", '123', true),
    User('Marika', "123@gmail.com", '456', false),
    User('Pär', "123@gmail.com", '789', true),
    User('Mattias', "123@gmail.com", '123', true),
    User('Viktor', "123@gmail.com", '456', false),
    User('Emma', "123@gmail.com", '789', true),
    User('Daniel', "123@gmail.com", '123', true),
    User('Johanna', "123@gmail.com", '456', false),
    User('Kevin', "123@gmail.com", '789', true),
    User('Elsa', "123@gmail.com", '123', true),
    User('Sara', "123@gmail.com", '456', false),
    User('Emil', "123@gmail.com", '789', true),
    User('Joel', "123@gmail.com", '123', true),
    User('Siri', "123@gmail.com", '456', false),
    User('Eskil', "123@gmail.com", '789', true),
    User('Simon', "123@gmail.com", '123', true),
    User('Linn', "123@gmail.com", '456', false),
    User('Linda', "123@gmail.com", '789', true),
    User('Habib', "123@gmail.com", '123', true),
    User('Ashraf', "123@gmail.com", '456', false),
    User('Lukas', "123@gmail.com", '789', true),
    User('John', "123@gmail.com", '123', true),
    User('Daniella', "123@gmail.com", '456', false),
    User('Trött', "123@gmail.com", '789', true),
    User('På', "123@gmail.com", '123', true),
    User('Namn', "123@gmail.com", '456', false),
    User('Nu', "123@gmail.com", '789', true),
  ];
  var items = List<User>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<User> dummySearchList = List<User>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<User> dummyListData = List<User>();
      dummySearchList.forEach((item) {
        if (item.phone.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Send Friend Request"),
      content: Text("Would You Like To Add this User?"),
      actions: [
        cancelButton,
        continueButton,
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
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search By Number",
                    hintText: "ex:0701112233",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                    itemCount: items?.length ??
                        0, //lägga till vår egen lista på denna bör funka
                    itemBuilder: (context, index) {
                      User c = items?.elementAt(index);
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProfileInfo(c)));
                        },
                        leading: CircleAvatar(child: Text("PH")),
                        title: Text(c.name ?? ""),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.person_add,
                            color: Colors.green,
                            size: 37,
                          ),
                          onPressed: () {
                            showAlertDialog(context);
                          },
                        ), //onPressed Lägger till i vänner och tar bort från lista
                      );
                    },
                  )),
            ),
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
  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
        setState(() {
          widget.user.friendstatus = false;
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("UserName"),
      content: Text("Friend request sent"),
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
                widget.user.friendstatus != false
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
                            widget.user.friendstatus = true;
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
                    child: Text(
                      "My Dogs",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    //user hundlista här
                    children: <Widget>[
                      SizedBox(
                          child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'BrewDog.jpg',
                            ),
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.asset(
                              'LeBistro.jpg',
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
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
                                      widget.user.phone,
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
