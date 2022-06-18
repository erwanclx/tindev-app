import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tindev/main.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:tindev/PersonDetail.dart';

import 'login.dart';

class PersonDetailAll extends StatelessWidget {
  final DocumentSnapshot post;
  PersonDetailAll({Key? key, required this.post}) : super(key: key);
  final codepostal = TextEditingController();
  final region = TextEditingController();
  final ville = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisSize: MainAxisSize.min,
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
      body: PersonDetail(post: post,),
    );
  }
}

class PersonDetail extends StatefulWidget {
  final DocumentSnapshot post;
  PersonDetail({required this.post});

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

class _PersonDetailState extends State<PersonDetail> with TickerProviderStateMixin{

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Personnes').where('nom', isEqualTo: widget.post["nom"]).get();
    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetailAll(post: post,)));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getPosts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return
            Center(
                child: Container(
                    height: MediaQuery.of(context).size.height*0.6,
                    child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),

                            // color: Colors.grey[300],
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,

                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20), // Image border
                                      child: SizedBox.fromSize(
                                          size: Size.fromRadius(150), // Image radius
                                          child: GestureDetector(
                                            child: Image.network(snapshot.data[0].data()["img"], fit: BoxFit.cover,)
                                          )
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Row (
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [

                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [Text(
                                              snapshot.data[0].data()["prenom"],
                                              style: TextStyle(color: Theme.of(context).colorScheme.primary,
                                                fontSize: 22.0,),
                                            ),
                                              SizedBox(width: 5),
                                              Text(
                                                snapshot.data[0].data()["nom"],
                                                style: TextStyle(color: Theme.of(context).colorScheme.primary,
                                                  fontSize: 22.0,),
                                              ),
                                            ]
                                        ),
                                        Text(
                                          snapshot.data[0].data()["ville"],
                                          style: TextStyle(color: Theme.of(context).colorScheme.primary,
                                            fontSize: 22.0,
                                            fontStyle: FontStyle.italic,),
                                        )

                                      ]),
                                  SizedBox(height: 15),
                                  Row (
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                        },
                                        child: Row(
                                          children: [
                                            Icon(FontAwesomeIcons.telegram,
                                                color: Colors.white),
                                            Text("  Me contacter", style: TextStyle(color: Colors.white),),
                                          ],
                                        ),
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0)
                                        ),
                                      )
                                            ))],
                                  ),
                                ]), elevation: 10.0,
                          )));
                        },
                        );}}