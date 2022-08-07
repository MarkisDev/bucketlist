import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:bucketlist/app/ui/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:tuple/tuple.dart';

import 'package:get/get.dart';

import '../controllers/bucket_entry_controller.dart';

class BucketEntryView extends GetView<BucketEntryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kappBar,
      body: Column(
        children: [
          quill.QuillToolbar.basic(
            controller: controller.quillController,
            iconTheme: quill.QuillIconTheme(
                iconSelectedColor: Colors.black,
                iconSelectedFillColor: kprimaryColor),
          ),
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)),
              border: OutlineInputBorder(),
              hintText: 'Click here to enter a title!',
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.white,
            child: quill.QuillEditor(
              controller: controller.quillController,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: FocusNode(),
              autoFocus: false,
              readOnly: false,
              placeholder: 'Add content',
              expands: false,
              padding: EdgeInsets.all(18),
              // customStyles: quill.DefaultStyles(
              //   paragraph: quill.DefaultTextBlockStyle(
              //       const TextStyle(
              //         fontSize: 18,
              //         color: Colors.white,
              //         fontWeight: FontWeight.w300,
              //       ),
              //       const Tuple2(0, 0),
              //       const Tuple2(0, 0),
              //       null),
              //   h1: quill.DefaultTextBlockStyle(
              //       const TextStyle(
              //         color: Colors.white,
              //       ),
              //       const Tuple2(0, 0),
              //       const Tuple2(0, 0),
              //       null),
              // ),
            ),
          ))
        ],
      ),
    );
  }
}
