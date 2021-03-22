import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app_samples/utility/shrdpref.dart';
import 'package:flutter_app_samples/widgets/Button.dart';
import 'package:flutter_app_samples/widgets/appBar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Image image;
  TextEditingController _nameController;
  TextEditingController _fathername;
  TextEditingController _phnNumber;
  String name = '';
  String fatherName = "";
  String phNum = "";
  String imageCheck;

  pickImage(ImageSource source) async {
    // ignore: deprecated_member_use
    final _image = await ImagePicker.pickImage(source: source);

    if (_image != null) {
      setState(() {
        image = Image.file(_image);
      });
      SharedPrefs.saveImageToPrefs(
          SharedPrefs.base64String(_image.readAsBytesSync()));
    } else {
      print('Error picking image!');
    }
  }

  loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final imageKeyValue = prefs.getString(IMAGE_KEY);
    if (imageKeyValue != null) {
      final imageString = await SharedPrefs.loadImageFromPrefs();
      setState(() {
        image = SharedPrefs.imageFrom64BaseString(imageString);
imageCheck = base64Decode.toString();
print(image.toString() + "load Image form pref");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    name = SharedPrefs.getUsername() ?? '';
    phNum = SharedPrefs.getPhone() ?? '';
    fatherName = SharedPrefs.getFatherName() ?? '';
    loadImageFromPrefs();
    print(image);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: BaseAppBar(
        title: Text('Profile Screen'),
        appBar: AppBar(),
      ),
      body: Container(
        height: size.height,
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
                    CircleAvatar(
                      radius: 80,
                      child:
                          image == null ? Icon(Icons.person, size: 50) : image,
                    ),
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
          ],
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

  Widget buildButton() => ButtonWidget(
      text: 'Save',
      onClicked: () async {
        await SharedPrefs.setUsername(name);
      });

  Widget buildTitle({
    @required String title,
    @required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}
