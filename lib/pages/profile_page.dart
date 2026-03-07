// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ProfilePage extends StatefulWidget {
//   final String username;
//   final String email;
//   void Function()? onLogout;

//    ProfilePage({
//     super.key,
//     required this.username,
//     required this.email,
//     this.onLogout,
//   });

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   File? _image;

//   final picker = ImagePicker();

//   String getInitials(String name) {
//     List<String> names = name.trim().split(" ");
//     String initials = "";

//     for (var n in names) {
//       if (n.isNotEmpty) {
//         initials += n[0];
//       }
//     }

//     return initials.toUpperCase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Profile"), centerTitle: true),
//       body: Column(
//         children: [
//           const SizedBox(height: 30),

//           GestureDetector(
//             onTap: () => setState(() {
//               getInitials(widget.username);
//             }),
//             child: CircleAvatar(
//               radius: 60,
//               backgroundColor: const Color(0xFF1DB584),
//               backgroundImage: _image != null ? FileImage(_image!) : null,
//               child: _image == null
//                   ? Text(
//                       getInitials(widget.username),
//                       style: const TextStyle(
//                         fontSize: 40,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     )
//                   : null,
//             ),
//           ),

//           const SizedBox(height: 30),

//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text("Name"),
//             subtitle: Text(widget.username),
//           ),

//           const Divider(),

//           ListTile(
//             leading: const Icon(Icons.email),
//             title: const Text("Email"),
//             subtitle: Text(widget.email),
//           ),

//           const Divider(),

//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text("Logout"),
//             onTap: () {
//               if (widget.onLogout != null) {
//                 widget.onLogout!();
//                 Navigator.of(context).canPop()
//                     ? Navigator.of(context).pop()
//                     : null;
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
