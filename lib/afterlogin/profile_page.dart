// // lib/profile_page.dart
//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage>
//     with SingleTickerProviderStateMixin {
//   // Tab controller
//   late TabController _tabController;
//
//   // Profile state
//   String _username = 'Guest';
//   String _selectedGoal = 'Daily Learning';
//   bool _reminderEnabled = true;
//   TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
//
//   // Text controllers
//   final _aboutMeCtrl    = TextEditingController();
//   final _emailCtrl      = TextEditingController();
//   final _locationCtrl   = TextEditingController();
//   final _ageCtrl        = TextEditingController();
//   final _occupationCtrl = TextEditingController();
//   final _interestsCtrl  = TextEditingController();
//   final _goalDescCtrl   = TextEditingController();
//
//   // Firebase RTDB ref
//   final _dbRef = FirebaseDatabase.instance
//       .refFromURL('https://test-d5189-default-rtdb.firebaseio.com')
//       .child('profiles');
//
//   // Local notifications plugin
//   final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Timezone & local notifications setup
//     tz.initializeTimeZones();
//     const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initSettings = InitializationSettings(android: androidInit);
//     _localNotificationsPlugin.initialize(initSettings);
//
//     // (Optional) get FCM token for server pushes later
//     FirebaseMessaging.instance.getToken().then((t) {
//       if (t != null) print('FCM token: $t');
//     });
//
//     // Tabs
//     _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
//
//     // Load prefs + push to Firebase
//     _loadAllPrefs();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _aboutMeCtrl.dispose();
//     _emailCtrl.dispose();
//     _locationCtrl.dispose();
//     _ageCtrl.dispose();
//     _occupationCtrl.dispose();
//     _interestsCtrl.dispose();
//     _goalDescCtrl.dispose();
//     super.dispose();
//   }
//
//   Future<void> _loadAllPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _username        = prefs.getString('username')        ?? _username;
//       _selectedGoal    = prefs.getString('selectedGoal')    ?? _selectedGoal;
//       _reminderEnabled = prefs.getBool('reminderEnabled')   ?? _reminderEnabled;
//       final t = prefs.getString('reminderTime');
//       if (t != null) {
//         final p = t.split(':');
//         _reminderTime = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
//       }
//       _aboutMeCtrl.text    = prefs.getString('aboutMe')         ?? '';
//       _emailCtrl.text      = prefs.getString('email')           ?? '';
//       _locationCtrl.text   = prefs.getString('location')        ?? '';
//       _ageCtrl.text        = prefs.getString('age')             ?? '';
//       _occupationCtrl.text = prefs.getString('occupation')      ?? '';
//       _interestsCtrl.text  = prefs.getString('interests')       ?? '';
//       _goalDescCtrl.text   = prefs.getString('goalDescription') ?? '';
//     });
//     await _pushProfileToFirebase();
//   }
//
//   Future<void> _savePrefsAndPush() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedGoal', _selectedGoal);
//     await prefs.setBool('reminderEnabled', _reminderEnabled);
//     await prefs.setString('reminderTime',
//         '${_reminderTime.hour}:${_reminderTime.minute}');
//     await prefs.setString('aboutMe', _aboutMeCtrl.text);
//     await prefs.setString('email', _emailCtrl.text);
//     await prefs.setString('location', _locationCtrl.text);
//     await prefs.setString('age', _ageCtrl.text);
//     await prefs.setString('occupation', _occupationCtrl.text);
//     await prefs.setString('interests', _interestsCtrl.text);
//     await prefs.setString('goalDescription', _goalDescCtrl.text);
//
//     if (_reminderEnabled) {
//       await _scheduleDailyNotification();
//     } else {
//       await _localNotificationsPlugin.cancelAll();
//     }
//
//     await _pushProfileToFirebase();
//   }
//
//   Future<void> _scheduleDailyNotification() async {
//     final now = tz.TZDateTime.now(tz.local);
//     var scheduled = tz.TZDateTime(
//       tz.local,
//       now.year,
//       now.month,
//       now.day,
//       _reminderTime.hour,
//       _reminderTime.minute,
//     );
//     if (scheduled.isBefore(now)) {
//       scheduled = scheduled.add(const Duration(days: 1));
//     }
//
//     await _localNotificationsPlugin.zonedSchedule(
//       0,
//       'Learning Reminder',
//       'Time for your goal: $_selectedGoal',
//       scheduled,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_reminder_channel',
//           'Daily Reminders',
//           channelDescription: 'Daily reminder notifications',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );
//   }
//
//   Future<void> _pushProfileToFirebase() async {
//     final data = {
//       'username'        : _username,
//       'aboutMe'         : _aboutMeCtrl.text,
//       'email'           : _emailCtrl.text,
//       'location'        : _locationCtrl.text,
//       'age'             : _ageCtrl.text,
//       'occupation'      : _occupationCtrl.text,
//       'interests'       : _interestsCtrl.text,
//       'selectedGoal'    : _selectedGoal,
//       'goalDescription' : _goalDescCtrl.text,
//       'reminderEnabled' : _reminderEnabled,
//       'reminderTime'    : _reminderTime.format(context),
//       'lastUpdated'     : DateTime.now().toIso8601String(),
//     };
//     await _dbRef.child(_username).set(data);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(children: [
//         // Wave background
//         Positioned(
//           bottom: 0, left: 0, right: 0,
//           child: SizedBox(
//             height: 300,
//             child: Image.asset(
//               'assets/wave.png',
//               fit: BoxFit.fill,
//               alignment: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//
//         // Main column
//         Column(children: [
//           // Header
//           Padding(
//             padding: const EdgeInsets.only(top: 33.0, bottom: 18.0),
//             child: Container(
//               width: double.infinity,
//               height: 170,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFC7E8FF),
//                 borderRadius: const BorderRadius.only(
//                   bottomLeft: Radius.circular(56),
//                   bottomRight: Radius.circular(56),
//                 ),
//               ),
//               child: Row(children: [
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.black,
//                   child: const Icon(Icons.person, size: 50, color: Color(0xFFC7E8FF)),
//                 ),
//                 const SizedBox(width: 20),
//                 Expanded(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(_username,
//                           style: const TextStyle(
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF00598B))),
//                       const SizedBox(height: 5),
//                       Text('Username: @$_username',
//                           style: const TextStyle(
//                               color: Colors.blueGrey, fontSize: 16)),
//                       const SizedBox(height: 5),
//                       const Text('Joined: April 16, 2025',
//                           style: TextStyle(
//                               color: Colors.blueGrey, fontSize: 16)),
//                     ],
//                   ),
//                 )
//               ]),
//             ),
//           ),
//
//           // Tab bar
//           Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFFC7E8FF),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: TabBar(
//               controller: _tabController,
//               labelColor: Colors.white,
//               unselectedLabelColor: const Color(0xFF00598B),
//               indicator: BoxDecoration(
//                 color: const Color(0xFF00598B),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               labelStyle: const TextStyle(
//                   fontSize: 14.0, fontWeight: FontWeight.bold),
//               unselectedLabelStyle: const TextStyle(
//                   fontSize: 14.0, fontWeight: FontWeight.bold),
//               tabs: const [
//                 Tab(text: ' Personal Info '),
//                 Tab(text: '    Overview   '),
//                 Tab(text: '     Goals     '),
//               ],
//             ),
//           ),
//
//           // Tab views
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildPersonalInfo(),
//                 _buildOverview(),
//                 _buildGoals(),
//               ],
//             ),
//           ),
//         ]),
//       ]),
//     );
//   }
//
//   Widget _buildPersonalInfo() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(children: [
//         _buildInfoCard(
//           title: 'About Me',
//           content: TextField(
//             controller: _aboutMeCtrl,
//             decoration: const InputDecoration(
//                 hintText: 'Tell us about yourself',
//                 border: OutlineInputBorder()),
//             maxLines: null,
//             onChanged: (_) => _savePrefsAndPush(),
//           ),
//         ),
//         _buildInfoCard(
//           title: 'Contact Info',
//           content: Column(children: [
//             TextField(
//               controller: _emailCtrl,
//               decoration: const InputDecoration(
//                   labelText: 'Email', border: OutlineInputBorder()),
//               onChanged: (_) => _savePrefsAndPush(),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _locationCtrl,
//               decoration: const InputDecoration(
//                   labelText: 'Location', border: OutlineInputBorder()),
//               onChanged: (_) => _savePrefsAndPush(),
//             ),
//           ]),
//         ),
//         _buildInfoCard(
//           title: 'Additional Details',
//           content: Column(children: [
//             TextField(
//               controller: _ageCtrl,
//               decoration: const InputDecoration(
//                   labelText: 'Age', border: OutlineInputBorder()),
//               onChanged: (_) => _savePrefsAndPush(),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _occupationCtrl,
//               decoration: const InputDecoration(
//                   labelText: 'Occupation', border: OutlineInputBorder()),
//               onChanged: (_) => _savePrefsAndPush(),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _interestsCtrl,
//               decoration: const InputDecoration(
//                   labelText: 'Interests', border: OutlineInputBorder()),
//               onChanged: (_) => _savePrefsAndPush(),
//             ),
//           ]),
//         ),
//         const SizedBox(height: 100),
//       ]),
//     );
//   }
//
//   Widget _buildInfoCard({required String title, required Widget content}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFFC7E8FF).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF00598B))),
//           const SizedBox(height: 8),
//           content,
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOverview() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         const Text('User Stats',
//             style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF00598B))),
//         const SizedBox(height: 16),
//         GridView.count(
//           crossAxisCount: 2,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisSpacing: 10,
//           mainAxisSpacing: 10,
//           children: [
//             _buildStatCard('Day Streak', '15', Icons.local_fire_department),
//             _buildStatCard('League', 'Silver', Icons.emoji_events),
//             _buildStatCard('Language Level', 'B2', Icons.school),
//             _buildStatCard('XP Count', '1200', Icons.star),
//           ],
//         ),
//         const SizedBox(height: 100),
//       ]),
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon) {
//     return Card(
//       color: const Color(0xFF00598B).withOpacity(0.8),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(icon, size: 30, color: const Color(0xFFC7E8FF)),
//           const SizedBox(height: 8),
//           Text(title,
//               style: const TextStyle(
//                   fontSize: 16,
//                   color: Color(0xFFC7E8FF),
//                   fontWeight: FontWeight.w500),
//               textAlign: TextAlign.center),
//           const SizedBox(height: 8),
//           Text(value,
//               style: const TextStyle(
//                   fontSize: 20,
//                   color: Color(0xFFC7E8FF),
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center),
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildGoals() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(children: [
//         _buildInfoCard(
//           title: 'Set Your Goals',
//           content: Column(children: [
//             ListTile(
//               leading: const Icon(Icons.flag, color: Color(0xFF00598B)),
//               title: DropdownButton<String>(
//                 value: _selectedGoal,
//                 isExpanded: true,
//                 items: const [
//                   DropdownMenuItem(
//                       value: 'Daily Learning',
//                       child: Text('Daily Learning')),
//                   DropdownMenuItem(
//                       value: 'Weekly Challenges',
//                       child: Text('Weekly Challenges')),
//                   DropdownMenuItem(
//                       value: 'Project Completion',
//                       child: Text('Project Completion')),
//                   DropdownMenuItem(
//                       value: 'Skill Mastery',
//                       child: Text('Skill Mastery')),
//                 ],
//                 onChanged: (v) {
//                   setState(() => _selectedGoal = v!);
//                   _savePrefsAndPush();
//                 },
//               ),
//             ),
//             const SizedBox(height: 8),
//             TextField(
//               controller: _goalDescCtrl,
//               decoration: const InputDecoration(
//                   hintText: 'Goal Description',
//                   border: OutlineInputBorder()),
//               maxLines: null,
//               onChanged: (_) => _savePrefsAndPush(),
//             ),
//           ]),
//         ),
//         _buildInfoCard(
//           title: 'Reminder Settings',
//           content: Column(children: [
//             SwitchListTile(
//               secondary:
//               const Icon(Icons.notifications, color: Color(0xFF00598B)),
//               title: const Text('Enable Reminders',
//                   style: TextStyle(color: Color(0xFF374151))),
//               value: _reminderEnabled,
//               onChanged: (v) {
//                 setState(() => _reminderEnabled = v);
//                 _savePrefsAndPush();
//               },
//             ),
//             ListTile(
//               leading:
//               const Icon(Icons.access_time, color: Color(0xFF00598B)),
//               title: Text(
//                 'Reminder Time: ${_reminderTime.format(context)}',
//                 style: const TextStyle(color: Color(0xFF374151)),
//               ),
//               onTap: () async {
//                 final t = await showTimePicker(
//                     context: context, initialTime: _reminderTime);
//                 if (t != null) {
//                   setState(() => _reminderTime = t);
//                   _savePrefsAndPush();
//                 }
//               },
//             ),
//           ]),
//         ),
//         const SizedBox(height: 100),
//       ]),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_database/firebase_database.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   // --- Profile state ---
//   String _username = 'Guest';
//   String _selectedGoal = 'Daily Learning';
//   bool _reminderEnabled = true;
//   TimeOfDay _reminderTime = TimeOfDay(hour: 9, minute: 0);
//
//   // --- Firebase RTDB reference ---
//   final DatabaseReference _dbRef = FirebaseDatabase.instance
//       .refFromURL('https://test-d5189-default-rtdb.firebaseio.com')
//       .child('profiles');
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
//     _loadAllPrefs();
//   }
//
//   /// Load username, goal, reminder settings from SharedPreferences
//   Future<void> _loadAllPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       _username        = prefs.getString('username')        ?? _username;
//       _selectedGoal    = prefs.getString('selectedGoal')    ?? _selectedGoal;
//       _reminderEnabled = prefs.getBool('reminderEnabled')   ?? _reminderEnabled;
//       final timeStr    = prefs.getString('reminderTime');
//       if (timeStr != null) {
//         final parts = timeStr.split(':');
//         _reminderTime = TimeOfDay(
//           hour: int.parse(parts[0]),
//           minute: int.parse(parts[1]),
//         );
//       }
//     });
//
//     // Sync the loaded profile to Firebase
//     await _pushProfileToFirebase();
//   }
//
//   /// Save changed prefs and push to Firebase
//   Future<void> _savePrefsAndPush() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('selectedGoal', _selectedGoal);
//     await prefs.setBool('reminderEnabled', _reminderEnabled);
//     await prefs.setString(
//       'reminderTime',
//       '${_reminderTime.hour}:${_reminderTime.minute}',
//     );
//     await _pushProfileToFirebase();
//   }
//
//   /// Write current profile state under /profiles/<username> in RTDB
//   Future<void> _pushProfileToFirebase() async {
//     final profileData = {
//       'username'       : _username,
//       'selectedGoal'   : _selectedGoal,
//       'reminderEnabled': _reminderEnabled,
//       'reminderTime'   : _reminderTime.format(context),
//       'lastUpdated'    : DateTime.now().toIso8601String(),
//     };
//     await _dbRef.child(_username).set(profileData);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//
//       body: Stack(
//         children: [
//           // 1) Wave background at bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SizedBox(
//               height: 300,
//               child: Image.asset(
//                 'assets/wave.png',
//                 fit: BoxFit.fill,
//                 alignment: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//
//           // 2) Main content
//           Container(
//             color: Colors.transparent,
//             child: Column(
//               children: [
//                 // --- Header with avatar & user info ---
//                 Padding(
//                   padding: const EdgeInsets.only(top: 33.0, bottom: 18.0),
//                   child: Container(
//                     width: double.infinity,
//                     height: 170,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFC7E8FF),
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(56),
//                         bottomRight: Radius.circular(56),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 50,
//                           backgroundColor: Colors.black,
//                           child: const Icon(
//                             Icons.person,
//                             size: 50,
//                             color: Color(0xFFC7E8FF),
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 _username,
//                                 style: const TextStyle(
//                                   fontSize: 22,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF00598B),
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(
//                                 'Username: @$_username',
//                                 style: const TextStyle(
//                                   color: Colors.blueGrey,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 5),
//                               const Text(
//                                 'Joined: April 16, 2025',
//                                 style: TextStyle(
//                                   color: Colors.blueGrey,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 // --- Tab Bar ---
//                 Container(
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFC7E8FF),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: TabBar(
//                     controller: _tabController,
//                     labelColor: Colors.white,
//                     unselectedLabelColor: const Color(0xFF00598B),
//                     indicator: BoxDecoration(
//                       color: const Color(0xFF00598B),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     labelStyle: const TextStyle(
//                         fontSize: 14.0, fontWeight: FontWeight.bold),
//                     unselectedLabelStyle: const TextStyle(
//                         fontSize: 14.0, fontWeight: FontWeight.bold),
//                     tabs: const [
//                       Tab(text: ' Personal Info '),
//                       Tab(text: '    Overview   '),
//                       Tab(text: '     Goals     '),
//                     ],
//                   ),
//                 ),
//
//                 // --- Tab Views ---
//                 Expanded(
//                   child: Container(
//                     color: Colors.transparent,
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildPersonalInfo(),
//                         _buildOverview(),
//                         _buildGoals(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ----------- Personal Info Tab -----------
//   Widget _buildPersonalInfo() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildInfoCard(
//             title: 'About Me',
//             content: const Text(
//               'Enthusiastic learner with a passion for AI and technology.',
//               style: TextStyle(fontSize: 16, color: Color(0xFF374151)),
//             ),
//           ),
//           _buildInfoCard(
//             title: 'Contact Info',
//             content: Column(
//               children: const [
//                 ListTile(
//                   leading: Icon(Icons.email, color: Color(0xFF00598B)),
//                   title: Text('john.doe@example.com',
//                       style: TextStyle(color: Color(0xFF374151))),
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.location_on, color: Color(0xFF00598B)),
//                   title: Text('123 Tech Street, AI City',
//                       style: TextStyle(color: Color(0xFF374151))),
//                 ),
//               ],
//             ),
//           ),
//           _buildInfoCard(
//             title: 'Additional Details',
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text('Age: 28',
//                     style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
//                 SizedBox(height: 4),
//                 Text('Occupation: Software Developer',
//                     style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
//                 SizedBox(height: 4),
//                 Text('Interests: AI, Coding, Reading',
//                     style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
//               ],
//             ),
//           ),
//           const SizedBox(height: 100), // space for wave
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoCard({required String title, required Widget content}) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFFC7E8FF).withOpacity(0.5),
//         borderRadius: BorderRadius.circular(28),
//         boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF00598B),
//             ),
//           ),
//           const SizedBox(height: 8),
//           content,
//         ],
//       ),
//     );
//   }
//
//   // ----------- Overview Tab -----------
//   Widget _buildOverview() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'User Stats',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF00598B),
//             ),
//           ),
//           const SizedBox(height: 16),
//           GridView.count(
//             crossAxisCount: 2,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             children: [
//               _buildStatCard('Day Streak', '15', Icons.local_fire_department),
//               _buildStatCard('League', 'Silver', Icons.emoji_events),
//               _buildStatCard('Language Level', 'B2', Icons.school),
//               _buildStatCard('XP Count', '1200', Icons.star),
//             ],
//           ),
//           const SizedBox(height: 100), // space for wave
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, IconData icon) {
//     return Card(
//       color: const Color(0xFF00598B).withOpacity(0.8),
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 30, color: const Color(0xFFC7E8FF)),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Color(0xFFC7E8FF),
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 20,
//                 color: Color(0xFFC7E8FF),
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ----------- Goals Tab -----------
//   Widget _buildGoals() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           _buildInfoCard(
//             title: 'Set Your Goals',
//             content: Column(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.flag, color: Color(0xFF00598B)),
//                   title: DropdownButton<String>(
//                     value: _selectedGoal,
//                     isExpanded: true,
//                     items: const [
//                       DropdownMenuItem(
//                           value: 'Daily Learning',
//                           child: Text('Daily Learning')),
//                       DropdownMenuItem(
//                           value: 'Weekly Challenges',
//                           child: Text('Weekly Challenges')),
//                       DropdownMenuItem(
//                           value: 'Project Completion',
//                           child: Text('Project Completion')),
//                       DropdownMenuItem(
//                           value: 'Skill Mastery',
//                           child: Text('Skill Mastery')),
//                     ],
//                     onChanged: (value) {
//                       setState(() => _selectedGoal = value!);
//                       _savePrefsAndPush();
//                     },
//                   ),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.description,
//                       color: Color(0xFF00598B)),
//                   title: TextField(
//                     decoration: const InputDecoration(
//                       hintText: 'Goal Description',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildInfoCard(
//             title: 'Reminder Settings',
//             content: Column(
//               children: [
//                 SwitchListTile(
//                   secondary:
//                   const Icon(Icons.notifications, color: Color(0xFF00598B)),
//                   title: const Text('Enable Reminders',
//                       style: TextStyle(color: Color(0xFF374151))),
//                   value: _reminderEnabled,
//                   onChanged: (value) {
//                     setState(() => _reminderEnabled = value);
//                     _savePrefsAndPush();
//                   },
//                 ),
//                 ListTile(
//                   leading:
//                   const Icon(Icons.access_time, color: Color(0xFF00598B)),
//                   title: Text(
//                     'Reminder Time: ${_reminderTime.format(context)}',
//                     style: const TextStyle(color: Color(0xFF374151)),
//                   ),
//                   onTap: () async {
//                     final selectedTime = await showTimePicker(
//                       context: context,
//                       initialTime: _reminderTime,
//                     );
//                     if (selectedTime != null) {
//                       setState(() => _reminderTime = selectedTime);
//                       _savePrefsAndPush();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // --- Profile state ---
  String _username = 'Guest';
  String _selectedGoal = 'Daily Learning';
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = TimeOfDay(hour: 9, minute: 0);

  // --- Firebase RTDB reference ---
  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .refFromURL('https://test-d5189-default-rtdb.firebaseio.com')
      .child('profiles');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _loadAllPrefs();
  }

  /// Load username, goal, reminder settings from SharedPreferences
  Future<void> _loadAllPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _username = prefs.getString('username') ?? _username;
      _selectedGoal = prefs.getString('selectedGoal') ?? _selectedGoal;
      _reminderEnabled = prefs.getBool('reminderEnabled') ?? _reminderEnabled;
      final timeStr = prefs.getString('reminderTime');
      if (timeStr != null) {
        final parts = timeStr.split(':');
        _reminderTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    });

    // Sync the loaded profile to Firebase
    await _pushProfileToFirebase();
  }

  /// Save changed prefs and push to Firebase
  Future<void> _savePrefsAndPush() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedGoal', _selectedGoal);
    await prefs.setBool('reminderEnabled', _reminderEnabled);
    await prefs.setString(
      'reminderTime',
      '${_reminderTime.hour}:${_reminderTime.minute}',
    );
    await _pushProfileToFirebase();
  }

  /// Write current profile state under /profiles/<username> in RTDB
  Future<void> _pushProfileToFirebase() async {
    final profileData = {
      'username': _username,
      'selectedGoal': _selectedGoal,
      'reminderEnabled': _reminderEnabled,
      'reminderTime': _reminderTime.format(context),
      'lastUpdated': DateTime.now().toIso8601String(),
    };
    await _dbRef.child(_username).set(profileData);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1) Wave background at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300,
              child: Image.asset(
                'assets/wave.png',
                fit: BoxFit.fill,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),

          // 2) Main content
          Container(
            color: Colors.transparent,
            child: Column(
              children: [
                // --- Header with avatar & user info ---
                Padding(
                  padding: const EdgeInsets.only(top: 33.0, bottom: 18.0),
                  child: Container(
                    width: double.infinity,
                    height: 170,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7E8FF),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(56),
                        bottomRight: Radius.circular(56),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFFC7E8FF),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _username,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00598B),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Username: @$_username',
                                style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Joined: April 16, 2025',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Tab Bar ---
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7E8FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF00598B),
                    indicator: BoxDecoration(
                      color: const Color(0xFF00598B),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold),
                    tabs: const [
                      Tab(text: ' Personal Info '),
                      Tab(text: '    Overview   '),
                      Tab(text: '     Goals     '),
                    ],
                  ),
                ),

                // --- Tab Views ---
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildPersonalInfo(),
                        _buildOverview(),
                        _buildGoals(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------- Personal Info Tab -----------
  Widget _buildPersonalInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'About Me',
            content: const Text(
              'Enthusiastic learner with a passion for AI and technology.',
              style: TextStyle(fontSize: 16, color: Color(0xFF374151)),
            ),
          ),
          _buildInfoCard(
            title: 'Contact Info',
            content: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.email, color: Color(0xFF00598B)),
                  title: Text('john.doe@example.com',
                      style: TextStyle(color: Color(0xFF374151))),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Color(0xFF00598B)),
                  title: Text('123 Tech Street, AI City',
                      style: TextStyle(color: Color(0xFF374151))),
                ),
              ],
            ),
          ),
          _buildInfoCard(
            title: 'Additional Details',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Age: 28',
                    style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
                SizedBox(height: 4),
                Text('Occupation: Software Developer',
                    style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
                SizedBox(height: 4),
                Text('Interests: AI, Coding, Reading',
                    style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
              ],
            ),
          ),
          SizedBox(height: 23,),
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              padding:
                  const EdgeInsets.symmetric(vertical: 2.0, horizontal: 1.0),
              decoration: BoxDecoration(
                color: const Color(0xFFC7E8FF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: SizedBox(
                width: 120, // Smaller width for the button
                child: TextButton(
                  onPressed: () {
                    // Implement logout functionality here
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00598B),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 100), // space for wave
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFC7E8FF).withOpacity(0.5),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00598B),
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  // ----------- Overview Tab -----------
  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00598B),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildStatCard('Day Streak', '15', Icons.local_fire_department),
              _buildStatCard('League', 'Silver', Icons.emoji_events),
              _buildStatCard('Language Level', 'B2', Icons.school),
              _buildStatCard('XP Count', '1200', Icons.star),
            ],
          ),
          const SizedBox(height: 100), // space for wave
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: const Color(0xFF00598B).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color(0xFFC7E8FF)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFC7E8FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFFC7E8FF),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ----------- Goals Tab -----------
  Widget _buildGoals() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoCard(
            title: 'Set Your Goals',
            content: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.flag, color: Color(0xFF00598B)),
                  title: DropdownButton<String>(
                    value: _selectedGoal,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                          value: 'Daily Learning',
                          child: Text('Daily Learning')),
                      DropdownMenuItem(
                          value: 'Weekly Challenges',
                          child: Text('Weekly Challenges')),
                      DropdownMenuItem(
                          value: 'Project Completion',
                          child: Text('Project Completion')),
                      DropdownMenuItem(
                          value: 'Skill Mastery', child: Text('Skill Mastery')),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedGoal = value!);
                      _savePrefsAndPush();
                    },
                  ),
                ),
                ListTile(
                  leading:
                      const Icon(Icons.description, color: Color(0xFF00598B)),
                  title: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Goal Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildInfoCard(
            title: 'Reminder Settings',
            content: Column(
              children: [
                SwitchListTile(
                  secondary:
                      const Icon(Icons.notifications, color: Color(0xFF00598B)),
                  title: const Text('Enable Reminders',
                      style: TextStyle(color: Color(0xFF374151))),
                  value: _reminderEnabled,
                  onChanged: (value) {
                    setState(() => _reminderEnabled = value);
                    _savePrefsAndPush();
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Icons.access_time, color: Color(0xFF00598B)),
                  title: Text(
                    'Reminder Time: ${_reminderTime.format(context)}',
                    style: const TextStyle(color: Color(0xFF374151)),
                  ),
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: _reminderTime,
                    );
                    if (selectedTime != null) {
                      setState(() => _reminderTime = selectedTime);
                      _savePrefsAndPush();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

//
//
// //
// //
// // import 'package:flutter/material.dart';
// //
// // class ProfilePage extends StatefulWidget {
// //   @override
// //   _ProfilePageState createState() => _ProfilePageState();
// // }
// //
// // class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
// //   late TabController _tabController;
// //   String _selectedGoal = 'Daily Learning';
// //   bool _reminderEnabled = true;
// //   TimeOfDay _reminderTime = TimeOfDay(hour: 9, minute: 0);
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _tabController.dispose();
// //     super.dispose();
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white, // Set a solid background color
// //       // appBar: AppBar(
// //       //   leading: IconButton(
// //       //     icon: Icon(Icons.arrow_back, color: Color(0xFF00598B)),
// //       //     onPressed: () => Navigator.pop(context),
// //       //   ),
// //       //   title: Text(
// //       //     'Profile',
// //       //     style: TextStyle(
// //       //       fontSize: 22,
// //       //       fontWeight: FontWeight.bold,
// //       //       color: Colors.black,
// //       //     ),
// //       //   ),
// //       //   backgroundColor: Color(0xFFC7E8FF),
// //       //   centerTitle: true,
// //       //   elevation: 0,
// //       // ),
// //       body: Stack(
// //         children: [
// //           // Wave Image Background (moved to bottom with controlled overlap)
// //           Positioned(
// //             bottom: 0,
// //             left: 0,
// //             right: 0,
// //             child: SizedBox(
// //               height: 300, // Adjust this value to control the wave height
// //               child: Image.asset(
// //                 'assets/wave.png',
// //                 fit: BoxFit.fill, // Ensures it stretches horizontally and vertically to the SizedBox
// //                 alignment: Alignment.bottomCenter,
// //               ),
// //             ),
// //           ),
// //
// //           // Main Content with solid background
// //           Container(
// //             color: Colors.transparent,// Ensures wave doesn’t bleed through
// //             child: Column(
// //               children: [
// //
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 33.0, bottom: 18.0),
// //                   child: Container(
// //                     // margin: const EdgeInsets.only(top: 0.0, bottom: 18.0),
// //                     width: double.infinity,
// //                     height: 170,
// //                     padding: const EdgeInsets.all(20),
// //                     decoration: BoxDecoration(
// //                       color: const Color(0xFFC7E8FF),
// //                       // borderRadius: BorderRadius.circular(16), // rounds all 4 corners
// //                       // // If you only want the bottom corners rounded, use:
// //                       borderRadius: BorderRadius.only(
// //                         bottomLeft: Radius.circular(56),
// //                         bottomRight: Radius.circular(56),
// //                       ),
// //                     ),
// //                     child: Row(
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: [
// //                         // Profile Circle
// //                         CircleAvatar(
// //                           radius: 50,
// //                           backgroundColor: Colors.black,
// //                           child: const Icon(
// //                             Icons.person,
// //                             size: 50,
// //                             color: Color(0xFFC7E8FF),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 20),
// //                         // User Details
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             mainAxisSize: MainAxisSize.min,
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: const [
// //                               Text(
// //                                 'Rahul Kumar',
// //                                 style: TextStyle(
// //                                   fontSize: 22,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Color(0xFF00598B),
// //                                 ),
// //                               ),
// //                               SizedBox(height: 5),
// //                               Text(
// //                                 'Username: @johndoe123',
// //                                 style: TextStyle(color: Colors.blueGrey, fontSize: 16),
// //                               ),
// //                               SizedBox(height: 5),
// //                               Text(
// //                                 'Joined: April 16, 2025',
// //                                 style: TextStyle(color:  Colors.blueGrey, fontSize: 16),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //
// //                 // Tabs
// //                 Container(
// //                   decoration: BoxDecoration(
// //                     color: Color(0xFFC7E8FF), // Background color for whole tab bar
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: TabBar(
// //                     controller: _tabController,
// //                     labelColor: Colors.white,
// //                     unselectedLabelColor: Color(0xFF00598B),
// //                     indicator: BoxDecoration(
// //                       color: Color(0xFF00598B), // Background for selected tab
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                     labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
// //                     unselectedLabelStyle: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold ),
// //                     tabs: [
// //                       Tab(text: ' Personal Info '),
// //                       Tab(text: '    Overview   '),
// //                       Tab(text: '     Goals     '),
// //                     ],
// //                   ),
// //                 )
// // ,
// //                 // Tab Views
// //                 Expanded(
// //                   child: Container(
// //                     color: Colors.transparent, // Ensures consistent background
// //                     child: TabBarView(
// //                       controller: _tabController,
// //                       children: [
// //                         _buildPersonalInfo(),
// //                         _buildOverview(),
// //                         _buildGoals(),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //   Widget _buildPersonalInfo() {
// //     return SingleChildScrollView(
// //       padding: EdgeInsets.all(16.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildInfoCard(
// //             title: 'About Me',
// //             content: Text(
// //               'Enthusiastic learner with a passion for AI and technology.',
// //               style: TextStyle(fontSize: 16, color: Color(0xFF374151)),
// //             ),
// //           ),
// //           _buildInfoCard(
// //             title: 'Contact Info',
// //             content: Column(
// //               children: [
// //                 ListTile(
// //                   leading: Icon(Icons.email, color: Color(0xFF00598B)),
// //                   title: Text('john.doe@example.com', style: TextStyle(color: Color(0xFF374151))),
// //                 ),
// //                 ListTile(
// //                   leading: Icon(Icons.location_on, color: Color(0xFF00598B)),
// //                   title: Text('123 Tech Street, AI City', style: TextStyle(color: Color(0xFF374151))),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           _buildInfoCard(
// //             title: 'Additional Details',
// //             content: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text('Age: 28', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
// //                 SizedBox(height: 4),
// //                 Text('Occupation: Software Developer', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
// //                 SizedBox(height: 4),
// //                 Text('Interests: AI, Coding, Reading', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 100), // Space for wave
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildInfoCard({required String title, required Widget content}) {
// //     return Container(
// //       margin: EdgeInsets.only(bottom: 16.0),
// //       padding: EdgeInsets.all(16.0),
// //       decoration: BoxDecoration(
// //         color: Color(0xFFC7E8FF).withOpacity(0.5),
// //         borderRadius: BorderRadius.circular(28),
// //         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             title,
// //             style: TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFF00598B),
// //             ),
// //           ),
// //           SizedBox(height: 8),
// //           content,
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildOverview() {
// //     return SingleChildScrollView(
// //       padding: EdgeInsets.all(16.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             'User Stats',
// //             style: TextStyle(
// //               fontSize: 20,
// //               fontWeight: FontWeight.bold,
// //               color: Color(0xFF00598B),
// //             ),
// //           ),
// //
// //           GridView.count(
// //             crossAxisCount: 2,
// //             shrinkWrap: true,
// //             physics: NeverScrollableScrollPhysics(),
// //             crossAxisSpacing: 10,
// //             mainAxisSpacing: 10,
// //             children: [
// //               _buildStatCard('Day Streak', '15', Icons.local_fire_department),
// //               _buildStatCard('League', 'Silver', Icons.emoji_events),
// //               _buildStatCard('Language Level', 'B2', Icons.school),
// //               _buildStatCard('XP Count', '1200', Icons.star),
// //             ],
// //           ),
// //           SizedBox(height: 100), // Space for wave
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildStatCard(String title, String value, IconData icon) {
// //     return Card(
// //       color: Color(0xFF00598B).withOpacity(0.8),
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(icon, size: 30, color: Color(0xFFC7E8FF)),
// //             SizedBox(height: 8),
// //             Text(
// //               title,
// //               style: TextStyle(
// //                 fontSize: 16,
// //                 color: Color(0xFFC7E8FF),
// //                 fontWeight: FontWeight.w500,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               value,
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 color: Color(0xFFC7E8FF),
// //                 fontWeight: FontWeight.bold,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildGoals() {
// //     return SingleChildScrollView(
// //       padding: EdgeInsets.all(16.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           _buildInfoCard(
// //             title: 'Set Your Goals',
// //             content: Column(
// //               children: [
// //                 ListTile(
// //                   leading: Icon(Icons.flag, color: Color(0xFF00598B)),
// //                   title: DropdownButton<String>(
// //                     value: _selectedGoal,
// //                     isExpanded: true,
// //                     items: [
// //                       DropdownMenuItem(value: 'Daily Learning', child: Text('Daily Learning')),
// //                       DropdownMenuItem(value: 'Weekly Challenges', child: Text('Weekly Challenges')),
// //                       DropdownMenuItem(value: 'Project Completion', child: Text('Project Completion')),
// //                       DropdownMenuItem(value: 'Skill Mastery', child: Text('Skill Mastery')),
// //                     ],
// //                     onChanged: (value) {
// //                       setState(() {
// //                         _selectedGoal = value!;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //                 ListTile(
// //                   leading: Icon(Icons.description, color: Color(0xFF00598B)),
// //                   title: TextField(
// //                     decoration: InputDecoration(
// //                       hintText: 'Goal Description',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           _buildInfoCard(
// //             title: 'Reminder Settings',
// //             content: Column(
// //               children: [
// //                 SwitchListTile(
// //                   secondary: Icon(Icons.notifications, color: Color(0xFF00598B)),
// //                   title: Text('Enable Reminders', style: TextStyle(color: Color(0xFF374151))),
// //                   value: _reminderEnabled,
// //                   onChanged: (value) {
// //                     setState(() {
// //                       _reminderEnabled = value;
// //                     });
// //                   },
// //                 ),
// //                 ListTile(
// //                   leading: Icon(Icons.access_time, color: Color(0xFF00598B)),
// //                   title: Text(
// //                     'Reminder Time: ${_reminderTime.format(context)}',
// //                     style: TextStyle(color: Color(0xFF374151)),
// //                   ),
// //                   onTap: () async {
// //                     final selectedTime = await showTimePicker(
// //                       context: context,
// //                       initialTime: _reminderTime,
// //                     );
// //                     if (selectedTime != null) {
// //                       setState(() {
// //                         _reminderTime = selectedTime;
// //                       });
// //                     }
// //                   },
// //                 ),
// //                 ListTile(
// //                   leading: Icon(Icons.repeat, color: Color(0xFF00598B)),
// //                   title: DropdownButton<String>(
// //                     value: 'Daily',
// //                     isExpanded: true,
// //                     items: [
// //                       DropdownMenuItem(value: 'Daily', child: Text('Daily')),
// //                       DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
// //                       DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
// //                     ],
// //                     onChanged: (value) {
// //                       // Handle reminder frequency change
// //                     },
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 100), // Space for wave
// //         ],
// //       ),
// //     );
// //   }
// // }
