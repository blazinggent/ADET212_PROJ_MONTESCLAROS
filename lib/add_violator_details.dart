import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'db_helper.dart';
import 'violator.dart';

class AddViolatorDetails extends StatefulWidget {
  const AddViolatorDetails({Key? key, this.details}) : super(key: key);

  final Violator? details;

  @override
  State<AddViolatorDetails> createState() => _AddViolatorDetailsState();
}

class _AddViolatorDetailsState extends State<AddViolatorDetails> {
  File? image;
  String? imgString;
  final _nameController = TextEditingController();
  final _mobileNumberController = TextEditingController();

  @override
  void initState() {
    if (widget.details != null) {
      _nameController.text = widget.details!.name!;
      _mobileNumberController.text = widget.details!.mobileNumber!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Violator'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                  backgroundImage: (image != null) ? FileImage(image!) : null,
                  backgroundColor: (image != null) ? Colors.grey : Colors.white10,
                  radius: 125,
                  child: SizedBox(
                    width: 250,
                    height: 250,
                    child: Visibility(
                      visible: (image != null) ? false : true,
                      child: FloatingActionButton(
                          onPressed: () async {
                            _pickImage();
                          },
                          child: const Icon(Icons.add_a_photo, size: 60)),
                    ),
                  )),
              // ElevatedButton(
              //   style: style,
              //   onPressed: () {
              //     _pickImage();
              //   },
              //   child: const Text('Take photo of violator'),
              // ),
              SizedBox(height: 50),
              _buildTextField(_nameController, 'Name'),
              const SizedBox(
                height: 20,
              ),
              _buildTextField(_mobileNumberController, 'Mobile Number'),
              const SizedBox(
                height: 100,
              ),
              SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget.details != null) {
                        await DBHelper.updateViolator(Violator(
                          id: widget.details!.id,
                          name: _nameController.text,
                          mobileNumber: _mobileNumberController.text,
                        ));

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(true);
                      } else {
                        await DBHelper.reportViolator(Violator(
                          name: _nameController.text,
                          mobileNumber: _mobileNumberController.text,
                        ));

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: const Text('Save'),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: no_leading_underscores_for_local_identifiers
  TextField _buildTextField(TextEditingController _controller, String hint) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
