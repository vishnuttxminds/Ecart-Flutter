import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
   final double radius;
   final File? initialImage;
   final void Function(File file) onImageSelected;
   final String? imageUrl;

   const ImagePickerWidget({
     super.key,
     this.radius = 60,
     this.initialImage,
     this.imageUrl,
     required this.onImageSelected,
   });

  @override
  State<ImagePickerWidget> createState() => _PicturePickerState();
}

class _PicturePickerState extends State<ImagePickerWidget> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.initialImage;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
      });
      widget.onImageSelected(imageFile);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Pick from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take a Picture'),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child:   Container(
        height: 130,
        width: 130,
        decoration: BoxDecoration(
          border: const Border.fromBorderSide(
            BorderSide(color: Colors.amber, width: 1),
          ),
          shape: BoxShape.circle,
          color: Colors.cyan,
          image: DecorationImage(
            image: _image != null
                ? FileImage(_image!) : widget.imageUrl != null
                    ? NetworkImage(widget.imageUrl!)
                    // If no image is selected, use the default asset image
                : const AssetImage('assets/images/sunil.jpg') as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      )





      // CircleAvatar(
      //   radius: widget.radius,
      //   backgroundImage: _image != null
      //       ? FileImage(_image!)
      //       : const AssetImage('assets/images/sunil.jpg') as ImageProvider,
      //   child: _image == null
      //       ? null
      //       : null,
      // ),
    );
  }
}
