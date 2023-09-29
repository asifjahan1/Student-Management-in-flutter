import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({super.key});

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final TextEditingController _courseName = TextEditingController();
  final TextEditingController _courseFee = TextEditingController();
  XFile? _courseImage;
  String? _imgUrl;
  chooseImageFromCG() async {
    ImagePicker _picker = ImagePicker();
    _courseImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  sendData() async {
    File _imageFile = File(_courseImage!.path);

    FirebaseStorage _storage = await FirebaseStorage.instance;
    UploadTask _uploadTask =
    _storage.ref('course').child(_courseImage!.name).putFile(_imageFile);

    TaskSnapshot _snapshot = await _uploadTask;
    _imgUrl = await _snapshot.ref.getDownloadURL();

    CollectionReference _course =
    await FirebaseFirestore.instance.collection('course');
    _course.add(({
      'course_Name': _courseName.text,
      'course_fee': _courseFee.text,
      'img': _imgUrl
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          )),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _courseName,
              decoration: InputDecoration(
                  hintText: 'Add Course Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _courseFee,
              decoration: InputDecoration(
                  hintText: 'Add Course Fee',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
                child: _courseImage == null
                    ? IconButton(
                  onPressed: () {
                    chooseImageFromCG();
                  },
                  icon: const Icon(Icons.camera),
                )
                    : Image.file(File(_courseImage!.path))),
            ElevatedButton(
                onPressed: () {
                  sendData();
                },
                child: const Text('Add Course'))
          ],
        ),
      ),
    );
  }
}
