import 'package:bucketlist/app/ui/theme/color_theme.dart';
import 'package:bucketlist/app/ui/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:get/get.dart';

import '../controllers/bucket_entry_controller.dart';

class BucketEntryView extends GetView<BucketEntryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kappBar,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          quill.QuillToolbar.basic(
            controller: controller.quillController,
            iconTheme: quill.QuillIconTheme(
                iconSelectedColor: Colors.black,
                iconSelectedFillColor: kprimaryColor),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Expanded(
              child: TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(),
                  hintText: 'Title goes here...',
                ),
              ),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: Get.width * 0.2,
                  child: TextButton(
                      onPressed: () {
                        if (controller.bucketController.newEntry) {
                          Get.back();
                        }
                        controller.addOrUpdateBucketEntry();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Raleway'),
                      ),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.15)),
                          backgroundColor: MaterialStateProperty.all(
                              ksecondaryBackgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(color: Colors.black))))),
                ),
                SizedBox(
                  width: Get.width * 0.2,
                  child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Raleway'),
                      ),
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.15)),
                          backgroundColor: MaterialStateProperty.all(
                              ksecondaryBackgroundColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(color: Colors.black))))),
                ),
              ],
            ))
          ]),

          // TextButton(onPressed: () {}, child: Text("Save!")),

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
