import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tindev/main.dart';

import 'package:tindev/SecondPage.dart';

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

class _DetailPageState extends State<DetailPage> {

  Future getPosts() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('Personnes').where('region', isEqualTo: widget.post["region"]).get();
    return qn.docs;
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
    return ListView(
       children: <Widget>[
     GridView.builder(
       physics: const NeverScrollableScrollPhysics(),
       shrinkWrap: true,
       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount:2,
         crossAxisSpacing: 25.0,
         mainAxisSpacing: 25.0,
       ),
       itemCount: snapshot.data.length,
       itemBuilder: (context, index) {
         var ville = snapshot.data[index].data()["ville"];
         var nom = snapshot.data[index].data()["nom"];
         var prenom = snapshot.data[index].data()["prenom"];
         var img = snapshot.data[index].data()["img"];
         return Stack(
           children: <Widget>[
             Container(
               alignment: Alignment.center,
               child: ClipRRect (
               borderRadius: BorderRadius.circular(20.0),
               child: Image.network(
                 img,
                 height: 250,
                 width: double.infinity,
                 fit: BoxFit.cover,
               ),
             ),
             ),
         Container(
             margin: const EdgeInsets.only(right: 2.0),
               alignment: Alignment.bottomRight,
               child: Text(
               nom,
               style: TextStyle(color: Theme.of(context).colorScheme.primary,
               fontSize: 22.0),
         )),
             Container(
                 margin: const EdgeInsets.only(bottom: 25.0, right: 2.0),
                 alignment: Alignment.bottomRight,
                 child: Text(
                   prenom,
                   style: TextStyle(color: Theme.of(context).colorScheme.primary,
                       fontSize: 22.0),
                 )),
             Container(
                 margin: const EdgeInsets.only(left: 2.0),
                 alignment: Alignment.bottomLeft,
                 child: Text(
                   ville,
                   style: TextStyle(color: Theme.of(context).colorScheme.primary,
                       fontSize: 22.0,
                     fontStyle: FontStyle.italic,),
                 )),
           ],
         );
       },
   )]);
});}}