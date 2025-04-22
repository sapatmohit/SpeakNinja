// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'language.dart';
//
// class ProfilePictureScreen extends StatefulWidget {
//   @override
//   _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
// }
//
// class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//   String? _selectedAvatar;
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//         _selectedAvatar = null; // Reset avatar selection
//       });
//     }
//   }
//
//   void _selectAvatar(String avatar) {
//     setState(() {
//       _selectedAvatar = avatar;
//       _image = null; // Reset image selection
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFAF7),
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Color(0xFFE07C32), size: 40),
//           onPressed: () => Navigator.pop(context), // Fixed back navigation
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Let's set up your",
//                 style: TextStyle(fontSize: 24, color: Color(0xFFE07C32))),
//             Text("Profile Picture",
//                 style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFE07C32))),
//             SizedBox(height: 20),
//             Center(
//               child: GestureDetector(
//                 onTap: () => _pickImage(ImageSource.gallery),
//                 child: CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Color(0xFFFFD9C2),
//                   backgroundImage: _image != null
//                       ? FileImage(_image!)
//                       : (_selectedAvatar != null
//                           ? AssetImage(_selectedAvatar!)
//                           : null) as ImageProvider?,
//                   child: _image == null && _selectedAvatar == null
//                       ? Icon(Icons.add_a_photo,
//                           size: 40, color: Color(0xFFE07C32))
//                       : null,
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Text(
//               "or choose an avatar",
//               style: TextStyle(color: Color(0xFFE07C32), fontSize: 15),
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _avatarOption("assets/avatar1.png"),
//                 _avatarOption("assets/avatar2.png"),
//                 _avatarOption("assets/avatar3.png"),
//                 _avatarOption("assets/avatar4.png"),
//               ],
//             ),
//             SizedBox(height: 40),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => LanguageSelectionScreen(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFf49549),
//                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//                 child: Text(
//                   "Next",
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _avatarOption(String avatarPath) {
//     return GestureDetector(
//       onTap: () => _selectAvatar(avatarPath),
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: CircleAvatar(
//           radius: 30,
//           backgroundImage: AssetImage(avatarPath),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'language.dart';

class ProfilePictureScreen extends StatefulWidget {
  @override
  _ProfilePictureScreenState createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _selectedAvatar;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _selectedAvatar = null;
      });
    }
  }

  void _selectAvatar(String avatar) {
    setState(() {
      _selectedAvatar = avatar;
      _image = null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (int i = 1; i <= 12; i++) {
      precacheImage(AssetImage('assets/avatar$i.png'), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatars = List.generate(12, (index) => 'assets/avatar${index + 1}.png');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(3.1416),
              child: Image.asset(
                'assets/wave2.png',
                fit: BoxFit.cover,
                height: 180,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Let's set up your",
                  style: TextStyle(fontSize: 22, color: Colors.black87),
                ),
                Text(
                  "Profile Picture",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004A8F),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Color(0xFF004A8F), width: 3),
                      ),
                      child: ClipOval(
                        child: _image != null
                            ? Image.file(_image!, fit: BoxFit.cover)
                            : _selectedAvatar != null
                            ? Image.asset(_selectedAvatar!, fit: BoxFit.cover)
                            : Center(
                          child: Icon(
                            Icons.add_photo_alternate,
                            size: 50,
                            color: Color(0xFF004A8F),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "or choose an avatar",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: avatars.map((avatarPath) {
                    return GestureDetector(
                      onTap: () => _selectAvatar(avatarPath),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(avatarPath),
                        radius: 28,
                        child: _selectedAvatar == avatarPath
                            ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 3,
                            ),
                          ),
                        )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguageSelectionScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004A8F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}