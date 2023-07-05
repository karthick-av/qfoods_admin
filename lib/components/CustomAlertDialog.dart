import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
    final String? title;
  final String? message;
  final Function() ? ok;
 
  const CustomAlertDialog({super.key, required this.title, required this.message, required this.ok});

  @override
  Widget build(BuildContext context) {
  
// set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text("ok"),
    onPressed:  this.ok
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(this?.title ?? ''),
    content: Text(this?.message ?? ''),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

     
    return alert;
   // show the dialog
 
  }
  }