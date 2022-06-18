import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tindev/PersonDetail.dart';

import 'package:loading/loading.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';

import 'SecondPage.dart';

class PersonImgAll extends StatelessWidget {
  final DocumentSnapshot post;
  PersonImgAll({Key? key, required this.post}) : super(key: key);
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
      body: PersonImg(post: post,),
    );
  }
}


class PersonImg extends StatefulWidget {
  final DocumentSnapshot post;
  PersonImg({required this.post});

  @override
  _PersonImgState createState() => _PersonImgState();
}

class _PersonImgState extends State<PersonImg>{

  bool isLiked = false;
  bool isHeartAnimating = false;

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
    return FutureBuilder(
        future: getPosts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.pink));
          }

          return
            Center(
                child: Container(
                    height: MediaQuery.of(context).size.height*0.42,
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
          borderRadius: BorderRadius.circular(20),// Image radius
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [ Row(
                children: [
                  Flexible(
                    child: Image.network(snapshot.data[0].data()["img"], fit: BoxFit.contain,),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Image.network(snapshot.data[0].data()["imgbis"], fit: BoxFit.contain,),
                  ),              ],
              ), 
                Opacity(
                  opacity: isHeartAnimating ? 1 : 0,
                child : HearthAnimationWidget (
                    isAnimating: isHeartAnimating,
                    duration: Duration(milliseconds: 700),
                    child: Icon(Icons.favorite, color: Colors.red, size: 80),
                  onEnd: () => setState(() =>isHeartAnimating = false,)
                ),
              )

                    
                ],
            ), onDoubleTap: () {
              setState(() {
                isHeartAnimating = true;
                isLiked = true;
              });
              navigateToDetail(snapshot.data[0]);
          }
          )
          )),
                            const SizedBox(height: 15),
                            Row (
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(FontAwesomeIcons.xmark,
                                            color: Colors.white),
                                        Text("  Passer", style: TextStyle(color: Colors.white),),
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
                    )));});}}

class HearthAnimationWidget extends StatefulWidget{
  final Widget child;
  final bool isAnimating;
  final Duration duration;
  final VoidCallback? onEnd;

  const HearthAnimationWidget({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
}) : super(key: key);
  @override
  _HearthAnimationWidgetState createState() => _HearthAnimationWidgetState();
}

class _HearthAnimationWidgetState extends State<HearthAnimationWidget> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation<double> scale;
  @override
  void initState() {
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: halfDuration));

    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(HearthAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  Future doAnimation() async {
    await controller.forward();
    await controller.reverse();

    if (widget.onEnd != null){
      widget.onEnd!();
    }
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: scale, child: widget.child);
}