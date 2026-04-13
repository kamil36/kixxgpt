// ginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _obscurePassword = true;
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   static const Color _loginBackground = Color(0xFF1A1A1A);
//   static const Color _accentGreen = Color(0xFF18B18A);
//   static const Color _softInput = Color(0xFFDCE5F1);
//   static const Color _labelColor = Color(0xFFB7A99B);
//   static const Color _subtitleColor = Color(0xFF7B746D);
//   static const Color _alertFill = Color(0xFF3A2020);
//   static const Color _alertBorder = Color(0xFF9F3434);
//   static const Color _alertText = Color(0xFFFF8E86);

//   @override
//   void initState() {
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF0d0d0d),
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 30),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo Circle
//                   Container(
//                     width: 80,
//                     height: 80,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Color(0xFF1DB584),
//                     ),
//                     child: Icon(Icons.smart_toy, color: Colors.white, size: 40),
//                   ),
//                   SizedBox(height: 30),

//                   // KixxGPT Title
//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Kixx',
//                           style: TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         TextSpan(
//                           text: 'GPT',
//                           style: TextStyle(
//                             fontSize: 36,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1DB584),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 8),

//                   // Subtitle
//                   Text(
//                     "Employee AI Assistant Portal",
//                     style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
//                   ),
//                   SizedBox(height: 50),

//                   // Email Field
//                   Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.email_outlined,
//                               color: Color(0xFF888888),
//                               size: 16,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               "Email Address",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xFFAAAAAA),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         TextField(
//                           controller: emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           style: TextStyle(color: Colors.black, fontSize: 14),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFFFFFFFF),
//                             hintText: "Enter your email",
//                             hintStyle: TextStyle(color: Color(0xFF999999)),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24),

//                   // Password Field
//                   Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.lock_outline,
//                               color: Color(0xFF888888),
//                               size: 16,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               "Password",
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color(0xFFAAAAAA),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 12),
//                         TextField(
//                           controller: passwordController,
//                           obscureText: _obscurePassword,
//                           style: TextStyle(color: Colors.black, fontSize: 14),
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Color(0xFFFFFFFF),
//                             hintText: "Enter your password",
//                             hintStyle: TextStyle(color: Color(0xFF999999)),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                               borderSide: BorderSide.none,
//                             ),
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 14,
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.visibility_outlined,
//                                 color: Color(0xFF666666),
//                                 size: 20,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword = !_obscurePassword;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 32),

//                   // Sign In Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: handleSignIn,
//                       icon: Icon(Icons.arrow_forward, color: Colors.white),
//                       label: Text(
//                         "Sign In",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF1DB584),
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _loginBackground,
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 18,
//                       vertical: 16,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _alertFill,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: _alertBorder),
//                     ),
//                     child: Row(
//                       children: const [
//                         Icon(
//                           Icons.warning_amber_rounded,
//                           color: _alertText,
//                           size: 20,
//                         ),
//                         SizedBox(width: 10),
//                         Text(
//                           'Please login to continue.',
//                           style: TextStyle(
//                             color: _alertText,
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 46),
//                   Container(
//                     width: 74,
//                     height: 74,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: _accentGreen,
//                     ),
//                     child: const Icon(
//                       Icons.smart_toy_rounded,
//                       color: Colors.white,
//                       size: 38,
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         const TextSpan(
//                           text: 'Kixx',
//                           style: TextStyle(
//                             fontSize: 34,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         TextSpan(
//                           text: 'GPT',
//                           style: TextStyle(
//                             fontSize: 34,
//                             fontWeight: FontWeight.bold,
//                             color: _accentGreen,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 10),

//                   const Text(
//                     "Employee AI Assistant Portal",
//                     style: TextStyle(fontSize: 14, color: _subtitleColor),
//                   ),
//                   const SizedBox(height: 56),

//                   _buildLabel(Icons.email_outlined, 'Email Address'),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     decoration: _buildInputDecoration(
//                       hintText: 'Enter your email',
//                     ),
//                   ),
//                   const SizedBox(height: 28),

//                   _buildLabel(Icons.lock_outline, 'Password'),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: passwordController,
//                     obscureText: _obscurePassword,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     decoration: _buildInputDecoration(
//                       hintText: 'Enter your password',
//                       suffixIcon: Container(
//                         width: 52,
//                         margin: const EdgeInsets.all(1.5),
//                         decoration: const BoxDecoration(
//                           color: Color(0xFF2B2B2B),
//                           borderRadius: BorderRadius.horizontal(
//                             right: Radius.circular(14),
//                           ),
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             _obscurePassword
//                                 ? Icons.visibility_outlined
//                                 : Icons.visibility_off_outlined,
//                             color: const Color(0xFF6E695F),
//                             size: 22,
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _obscurePassword = !_obscurePassword;
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 38),

//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: handleSignIn,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _accentGreen,
//                         elevation: 0,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.login_rounded, color: Colors.white, size: 24),
//                           SizedBox(width: 12),
//                           Text(
//                             "Sign In",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabel(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, color: _labelColor, size: 18),
//         const SizedBox(width: 10),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.w700,
//             color: _labelColor,
//           ),
//         ),
//       ],
//     );
//   }

//   InputDecoration _buildInputDecoration({
//     required String hintText,
//     Widget? suffixIcon,
//   }) {
//     return InputDecoration(
//       filled: true,
//       fillColor: _softInput,
//       hintText: hintText,
//       hintStyle: const TextStyle(
//         color: Color(0xFF7D8791),
//         fontSize: 15,
//       ),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(color: _accentGreen, width: 1.2),
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
//       suffixIcon: suffixIcon,
//     );
//   }
// }
