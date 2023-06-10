import 'package:admin/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<void> CancelDialog(BuildContext context, Function cancelHandler) async {
  TextEditingController _textFieldController = TextEditingController();
   final formGlobalKey = GlobalKey < FormState > ();
 

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: Form(
              key: formGlobalKey,
                    
            child: TextFormField(
                validator: ((value){
                          if(value == "") return "Reason is required";
                          return null;
                        }),
              maxLines: 6,
              
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Reason",
               labelText: 'Reason ',
                        errorStyle: TextStyle(color: Colors.red, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8.0)),
                       
              ),
            ),
          ),
          actions: <Widget>[
           InkWell(
            onTap: (){
               Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text("cancel"),
            ),
           ),
            InkWell(
            onTap: (){
                 if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
                        
    Navigator.of(context).pop();
    cancelHandler(_textFieldController?.value?.text);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text("Ok"),
            ),
           )
          ],
        );
      });
}