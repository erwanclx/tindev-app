import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tindev/SwipePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

ColorScheme defaultColorScheme = const ColorScheme(
  primary: Color(0xffdeb5be),
  secondary: Color(0xfff4d1cd),
  surface: Color(0xffffffff),
  background: Color(0xffffffff),
  error: Color(0xffCF6679),
  onPrimary: Color(0xffffffff),
  onSecondary: Color(0xffffffff),
  onSurface: Color(0xff000000),
  onBackground: Color(0xff000000),
  onError: Color(0xff000000),
  brightness: Brightness.light,
);



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: defaultColorScheme,
        primarySwatch: Colors.pink,
      ),
      title: 'Tindev',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final codepostal = TextEditingController();
  final region = TextEditingController();
  final ville = TextEditingController();
  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centers horizontally
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.heart,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(
              width: 3,
            ),
            Text(
              " Tindev",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 25,
              ),
            )
          ],
        ),
      ),
      body: const ArticleData(),
    );
  }
}

class ArticleData extends StatefulWidget {
  const ArticleData({Key? key}) : super(key: key);

  @override
  _ArticleDataState createState() => _ArticleDataState();
}

class _ArticleDataState extends State<ArticleData> {
  // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Locations').snapshots();
  // ValueNotifier<int> index = ValueNotifier(0);
  
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Locations').get();
    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPageAll(post: post,)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getPosts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var codepostal = snapshot.data[index].data()["codepostal"];
              var region = snapshot.data[index].data()["region"];
              var ville = snapshot.data[index].data()["ville"];
              return InkWell(
                onTap: (){
                  navigateToDetail(snapshot.data[index]);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(post:snapshot.data!.docs[index])));
               },
                child: Card(
                elevation: 3.0,
                margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background),
                  child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: const EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(
                                    width: 1.0, color: Colors.grey.shade400))),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            codepostal,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      title: Text(
                        ville,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(region,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.secondary))
                        ],
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right,
                          color: Colors.grey, size: 30.0)),
                ),
              ),
              );


            },

          );

        }
    );
  }
  }


