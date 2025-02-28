import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:islamic_event_admin/controller/initialStatuaController.dart';
import 'package:islamic_event_admin/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islamic_event_admin/custom_widgets/toast.dart';
import 'package:islamic_event_admin/screen/pdf/pdfScreen.dart';
import 'package:islamic_event_admin/widgets/app_bar/appbar_leading_image.dart';
import 'package:islamic_event_admin/widgets/custom_elevated_button.dart';
import 'package:islamic_event_admin/widgets/custom_text_form_field.dart';
import 'package:dio/dio.dart' as Deo;

import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class AddBook extends StatefulWidget {
  const AddBook({
    super.key,
  });

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  final InitialStatusController _initialStatusController =
      Get.find<InitialStatusController>();
  File? _pdfFile;
  TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfFile = File(result.files.single.path!);
      });
    }
  }

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 20.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Text(
                      "Add Islamic Book",
                      style: TextStyle(
                        fontSize: 15.v,
                        color: appTheme.blackheading,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    _pdfFile == null
                        ? const Text('No PDF selected.')
                        : TextButton(
                            onPressed: () {
                              Get.to(() => PDFScreen(
                                    path: _pdfFile!.path,
                                  ));
                            },
                            child: SizedBox(
                              width: 100.v,
                              child: Text(
                                  'Open Selected PDF: ${_pdfFile!.path.split('/').last}'),
                            )),
                    TextButton(
                        onPressed: () {
                          _pickPdf();
                        },
                        child: const Text("Select PDF")),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    _image == null
                        ? Container(
                            width: 140.v,
                            height: 190.h,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.v),
                                color: appTheme.lightbackground),
                            child: CustomImageView(
                              imagePath: ImageConstant.book,
                            ),
                          )
                        : Container(
                            width: 140.v,
                            height: 190.h,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.v),
                                color: appTheme.lightbackground),
                            child: Image.file(
                              _image!,
                              height: 100.h,
                              width: 200,
                            ),
                          ),
                    TextButton(
                        onPressed: () {
                          _pickImage();
                        },
                        child: const Text("Change Book Image")),
                  ],
                ),
                SizedBox(height: 15.v),
                CustomTextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter book title';
                      }
                      return null;
                    },
                    hintText: "Book Name",
                    hintStyle: CustomTextStyles.bodySmall10,
                    textInputType: TextInputType.text),
                SizedBox(height: 15.v),
                SizedBox(height: 30.v),
                CustomElevatedButton(
                  onPressed: () async {
                    if (_pdfFile != null) {
                      var fileName = _pdfFile!.path.split('/').last;
                      var file = await Deo.MultipartFile.fromFile(
                        _pdfFile!.path,
                        filename: fileName,
                      );
                      var fileBookImage = _image!.path.split('/').last;
                      var fileimage = await Deo.MultipartFile.fromFile(
                        _image!.path,
                        filename: fileBookImage,
                      );
                      if (_formKey.currentState!.validate()) {
                        _initialStatusController.addBook({
                          "book": file,
                          "title": titleController.text,
                          "bookImage": fileimage
                        });
                      }
                    } else {
                      flutterToast("Please Upload Pdf");
                    }
                  },
                  text: "Add Bøger",
                  width: 200.v,
                  buttonTextStyle: CustomTextStyles.bodySmallOnPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      centerTitle: true,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.back,
        onTap: () {
          Get.back();
        },
        margin: EdgeInsets.only(
          left: 21.h,
          top: 14.v,
          bottom: 14.v,
        ),
      ),
      title: AppbarTitle(
        text: "Book",
      ),
      styleType: Style.bgFill,
    );
  }
}
