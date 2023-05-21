// ignore_for_file: deprecated_member_use, prefer_interpolation_to_compose_strings, unused_local_variable, sized_box_for_whitespace, import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';
  File? image;
  ImagePicker? imagePicker;

  pickImageFromGallery() async {
    PickedFile? pickedFile =
        await imagePicker!.getImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  pickImageFromCamera() async {
    PickedFile? pickedFile =
        await imagePicker!.getImage(source: ImageSource.camera);
    image = File(pickedFile!.path);
    setState(() {
      image;
      performImageLabeling();
    });
  }

  performImageLabeling() async {
    final FirebaseVisionImage firebaseVisionImage =
        FirebaseVisionImage.fromFile(image!);
    final TextRecognizer recognizer = FirebaseVision.instance.textRecognizer();

    VisionText visionText = await recognizer.processImage(firebaseVisionImage);
    result = '';
    setState(() {
      for (TextBlock block in visionText.blocks) {
        final String txt = block.text!;
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            result += (element.text! + " ");
          }
        }
        result += "\n\n";
      }
    });
  }

  @override
  void initState() {
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back.jpg'), fit: BoxFit.cover)),
        child: Column(
          children: [
            const SizedBox(
              width: 60,
            ),
            Container(
              height: 370,
              width: 320,
              margin: const EdgeInsets.only(top: 50),
              padding: const EdgeInsets.only(left: 28, bottom: 5, right: 18),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/note.jpg'),
                fit: BoxFit.cover,
              )),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, right: 140),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/pin.png',
                          height: 240,
                          width: 260,
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        pickImageFromGallery();
                      },
                      onLongPress: () {
                        pickImageFromCamera();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: image != null
                            ? Image.file(
                                image!,
                                width: 140,
                                height: 192,
                                fit: BoxFit.fill,
                              )
                            : Container(
                                width: 240,
                                height: 200,
                                child: const Icon(
                                  Icons.camera_enhance_sharp,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
