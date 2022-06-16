import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:tindev/main.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:tindev/PersonDetail.dart';

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