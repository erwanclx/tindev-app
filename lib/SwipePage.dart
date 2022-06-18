import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tindev/main.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:tindev/PersonDetail.dart';
import 'package:tindev/PersonImg.dart';

import 'login.dart';

class DetailPageAll extends StatelessWidget {
  final DocumentSnapshot post;
  DetailPageAll({Key? key, required this.post}) : super(key: key);
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
      body: DetailPage(post: post,),
    );
  }
}


class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  DetailPage({required this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin{
  final CardController controller = CardController();
  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Personnes').where('region', isEqualTo: widget.post["region"]).get();
    return qn.docs;
  }

  navigateToDetail(DocumentSnapshot post){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PersonImgAll(post: post,)));
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
          child: TinderSwapCard(
            orientation: AmassOrientation.TOP,
            totalNum: snapshot.data.length,
            stackNum: 3,
            maxHeight: screenHeight * 0.7,
            maxWidth: screenWidth * 0.9,
            minWidth: screenWidth * 0.8,
            minHeight: screenHeight * 0.65,

          cardBuilder: (context, index){
              return Card(
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
                      child: Image.network(snapshot.data[index].data()["img"], fit: BoxFit.cover,),
                      onTap: () {
                        navigateToDetail(snapshot.data[index]);
                      },
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
                  snapshot.data[index].data()["prenom"],
                  style: TextStyle(color: Theme.of(context).colorScheme.primary,
                    fontSize: 22.0,),
                ),
                  SizedBox(width: 5),
                  Text(
                    snapshot.data[index].data()["nom"],
                    style: TextStyle(color: Theme.of(context).colorScheme.primary,
                      fontSize: 22.0,),
                  ),
                ]
              ),
              Text(
                snapshot.data[index].data()["ville"],
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
                      controller.triggerLeft();
                    },
                    child: Icon(Icons.close, color: Colors.red, size: 40,),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                      primary: Theme.of(context).colorScheme.background, // <-- Splash color
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // const SnackBar(
                      //   backgroundColor: Colors.green,
                      //   content: Text("J'aime"),
                      //   duration: Duration(milliseconds: 200));
                      controller.triggerRight();
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Icon(Icons.favorite, color: Colors.green, size: 40,),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(10),
                      primary: Theme.of(context).colorScheme.background, // <-- Splash color
                    ),
                  ),
                ],
              ),
                              ]), elevation: 10.0,
              );
              },
              cardController: controller,
              swipeCompleteCallback:
    (CardSwipeOrientation orientation, int index) {
    if (orientation == CardSwipeOrientation.LEFT) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    backgroundColor: Colors.red,
    content: Text("Je n'aime pas"),
    duration: Duration(milliseconds: 200),
    ),
    );
    } else if (orientation == CardSwipeOrientation.RIGHT) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    backgroundColor: Colors.green,
    content: Text("J'aime"),
    duration: Duration(milliseconds: 200),
          ),
    );
    }
            })));});}}