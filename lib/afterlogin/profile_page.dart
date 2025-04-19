import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedGoal = 'Daily Learning';
  bool _reminderEnabled = true;
  TimeOfDay _reminderTime = TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set a solid background color
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Color(0xFF00598B)),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Text(
      //     'Profile',
      //     style: TextStyle(
      //       fontSize: 22,
      //       fontWeight: FontWeight.bold,
      //       color: Colors.black,
      //     ),
      //   ),
      //   backgroundColor: Color(0xFFC7E8FF),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Stack(
        children: [
          // Wave Image Background (moved to bottom with controlled overlap)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 300, // Adjust this value to control the wave height
              child: Image.asset(
                'assets/wave.png',
                fit: BoxFit.fill, // Ensures it stretches horizontally and vertically to the SizedBox
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),

          // Main Content with solid background
          Container(
            color: Colors.transparent,// Ensures wave doesn’t bleed through
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 33.0, bottom: 18.0),
                  child: Container(
                    // margin: const EdgeInsets.only(top: 0.0, bottom: 18.0),
                    width: double.infinity,
                    height: 170,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC7E8FF),
                      // borderRadius: BorderRadius.circular(16), // rounds all 4 corners
                      // // If you only want the bottom corners rounded, use:
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(56),
                        bottomRight: Radius.circular(56),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Circle
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
                        // User Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Rahul Kumar',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00598B),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Username: @johndoe123',
                                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Joined: April 16, 2025',
                                style: TextStyle(color:  Colors.blueGrey, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tabs
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFC7E8FF), // Background color for whole tab bar
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xFF00598B),
                    indicator: BoxDecoration(
                      color: Color(0xFF00598B), // Background for selected tab
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold ),
                    tabs: [
                      Tab(text: ' Personal Info '),
                      Tab(text: '    Overview   '),
                      Tab(text: '     Goals     '),
                    ],
                  ),
                )
,
                // Tab Views
                Expanded(
                  child: Container(
                    color: Colors.transparent, // Ensures consistent background
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
  Widget _buildPersonalInfo() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'About Me',
            content: Text(
              'Enthusiastic learner with a passion for AI and technology.',
              style: TextStyle(fontSize: 16, color: Color(0xFF374151)),
            ),
          ),
          _buildInfoCard(
            title: 'Contact Info',
            content: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.email, color: Color(0xFF00598B)),
                  title: Text('john.doe@example.com', style: TextStyle(color: Color(0xFF374151))),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Color(0xFF00598B)),
                  title: Text('123 Tech Street, AI City', style: TextStyle(color: Color(0xFF374151))),
                ),
              ],
            ),
          ),
          _buildInfoCard(
            title: 'Additional Details',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Age: 28', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
                SizedBox(height: 4),
                Text('Occupation: Software Developer', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
                SizedBox(height: 4),
                Text('Interests: AI, Coding, Reading', style: TextStyle(fontSize: 16, color: Color(0xFF374151))),
              ],
            ),
          ),
          SizedBox(height: 100), // Space for wave
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget content}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFC7E8FF).withOpacity(0.5),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00598B),
            ),
          ),
          SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Stats',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00598B),
            ),
          ),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildStatCard('Day Streak', '15', Icons.local_fire_department),
              _buildStatCard('League', 'Silver', Icons.emoji_events),
              _buildStatCard('Language Level', 'B2', Icons.school),
              _buildStatCard('XP Count', '1200', Icons.star),
            ],
          ),
          SizedBox(height: 100), // Space for wave
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Color(0xFF00598B).withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Color(0xFFC7E8FF)),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFC7E8FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
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

  Widget _buildGoals() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            title: 'Set Your Goals',
            content: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.flag, color: Color(0xFF00598B)),
                  title: DropdownButton<String>(
                    value: _selectedGoal,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 'Daily Learning', child: Text('Daily Learning')),
                      DropdownMenuItem(value: 'Weekly Challenges', child: Text('Weekly Challenges')),
                      DropdownMenuItem(value: 'Project Completion', child: Text('Project Completion')),
                      DropdownMenuItem(value: 'Skill Mastery', child: Text('Skill Mastery')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGoal = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.description, color: Color(0xFF00598B)),
                  title: TextField(
                    decoration: InputDecoration(
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
                  secondary: Icon(Icons.notifications, color: Color(0xFF00598B)),
                  title: Text('Enable Reminders', style: TextStyle(color: Color(0xFF374151))),
                  value: _reminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      _reminderEnabled = value;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Color(0xFF00598B)),
                  title: Text(
                    'Reminder Time: ${_reminderTime.format(context)}',
                    style: TextStyle(color: Color(0xFF374151)),
                  ),
                  onTap: () async {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: _reminderTime,
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _reminderTime = selectedTime;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.repeat, color: Color(0xFF00598B)),
                  title: DropdownButton<String>(
                    value: 'Daily',
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                      DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                    ],
                    onChanged: (value) {
                      // Handle reminder frequency change
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 100), // Space for wave
        ],
      ),
    );
  }
}