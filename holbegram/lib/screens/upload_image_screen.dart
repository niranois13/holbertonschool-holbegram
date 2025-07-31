import 'dart:typed_data';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../methods/auth_methods.dart';

class AddPicture extends StatefulWidget{
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  void selectImageFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List bytesFile = await File(pickedFile.path).readAsBytes();
      setState(() {
        _image = bytesFile;
      });
    }
  }

  void selectImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final Uint8List bytesFile = await File(pickedFile.path).readAsBytes();
      setState(() {
        _image = bytesFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // Holbegram Headline:
            const SizedBox(
              height: 28,
            ),
            const Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 50)
            ),

            // Holberton Logo:
            Image.asset(
              'assets/images/logo.webp',
              width: 80,
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [

                  // Paragaph Container:
                  const SizedBox(
                    height: 28,
                  ),

                  // Paragraph Welcomings:
                  Text('Hello, ${widget.username}, Welcome to Holbegram',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  
                  // Paragraph Indications:
                  Text('choose an image from your gallery or take a new one',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Image PlaceHolder:
                  _image == null ? Image.asset(
                    'assets/images/img.png',
                    height: 250,
                    width: 250,

                  // Image from Gallery or Camera:
                  ) : Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(_image!),
                      )
                    ),
                  ),

                  // Gallery / Camera buttons:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Gallery:
                      IconButton(
                        icon: Icon(Icons.photo_outlined),
                        onPressed: (() => selectImageFromGallery()),
                        color: Colors.orangeAccent,
                      ),
                      // Camera:
                      IconButton(
                        icon: Icon(Icons.camera_alt_outlined),
                        onPressed: (() => selectImageFromCamera()),
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  
                  // Next button + signup validation:
                  const SizedBox(
                    height: 28,
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          const Color.fromARGB(218, 226, 37, 24),
                        ),
                      ),
                      onPressed: () async {
                        final authMethods = AuthMethode();
                        String result = await authMethods.signUpUser(
                          email: widget.email,
                          password: widget.password,
                          username: widget.username,
                          file: _image,
                        );
                        if (!context.mounted) {
                          return;
                        }
                        if (result == 'success') {
                          userProvider.refreshUser();
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result),
                            )
                          );
                        }
                      },
                      child: const Text(
                        'next',
                        style: TextStyle(
                          color: Colors.white,
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