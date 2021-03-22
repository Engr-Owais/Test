import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_samples/utility/shrdpref.dart';
import 'package:flutter_app_samples/widgets/appBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefs.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Shared Preferences';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        home: ProfileScreen(),
      );
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File _image;
  TextEditingController _nameController;
  TextEditingController _fathername;
  TextEditingController _phnNumber;
  String name = '';
  String fatherName = "";
  String phNum = "";
  String imagePath;

  BaseAppBar _appBar = BaseAppBar();

  void saveImage(String path) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("imagepath", path);
    print(sharedPreferences.getString("imagepath"));
    print(path + "Path");
  }

  void loadImage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      imagePath = sharedPreferences.getString("imagepath");
    });
  }

  pickImage(ImageSource source) async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = image;
      });
      saveImage(_image.path);
      loadImage();
    } else {
      print('Error picking image!');
    }
  }

  @override
  void initState() {
    super.initState();
    loadImage();
    name = SharedPrefs.getUsername() ?? '';
    phNum = SharedPrefs.getPhone() ?? '';
    fatherName = SharedPrefs.getFatherName() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BaseAppBar(
        title: Text('Profile Screen'),
        appBar: AppBar(),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Container(
            height: size.height -
                _appBar.preferredSize.height -
                MediaQuery.of(context).padding.top,
            width: size.width,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  width: size.width,
                  height: size.height * 0.2,
                  child: Center(
                    child: Stack(
                      children: [
                        imagePath != null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: FileImage(File(imagePath)),
                              )
                            : CircleAvatar(
                                radius: 80,
                                backgroundImage: _image != null
                                    ? FileImage(_image)
                                    : AssetImage('assets/avatar2.png')),
                        Positioned(
                          bottom: 0.0,
                          right: 2.0,
                          child: FloatingActionButton(
                            child: Icon(Icons.add_a_photo),
                            onPressed: () {
                              modalBottom(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    initialValue: name,
                    onFieldSubmitted: (name) async {
                      setState(() => this.name = name);
                      await SharedPrefs.setUsername(name);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _fathername,
                    initialValue: fatherName,
                    onFieldSubmitted: (fathername) async {
                      setState(() => this.fatherName = fathername);
                      await SharedPrefs.setFatherName(fathername);
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      suffixIcon: Icon(Icons.edit),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onDoubleTap: () {
                      phNum == ""
                          ? print("enter phone num")
                          : launch("tel://$phNum");
                    },
                    child: TextFormField(
                      controller: _phnNumber,
                      initialValue: phNum,
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (phNum) async {
                        setState(() => this.phNum = phNum);
                        await SharedPrefs.setPhone(phNum);
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        suffixIcon: Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  child: Center(
                    child: Text("Double Tap On Phone Number To Make A Call",
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> modalBottom(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.camera),
                  title: new Text('Camera'),
                  onTap: () {
                    pickImage(ImageSource.camera);
                    // this is how you dismiss the modal bottom sheet after making a choice
                    Navigator.pop(context);
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Gallery'),
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    // dismiss the modal sheet
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
