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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.indigo[800]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[800],
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // User Info (top area with curved edges)
          ClipPath(
            clipper: CustomCurvedClipper(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.indigo[700],
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.indigo[600],
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Rahul Naam Tu Suna Hoga',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Username: @johndoe123',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Joined: April 16, 2025',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // Tabs
          Container(
            color: Colors.grey[200],
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.indigo[800],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.indigo[800],
              tabs: [
                Tab(text: 'Personal Info'),
                Tab(text: 'Overview'),
                Tab(text: 'Goals'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: Container(
              color: Colors.grey[100],
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
    );
  }

  Widget _buildPersonalInfo() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(38),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Me',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Enthusiastic learner with a passion for AI and technology.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(38),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.indigo[600]),
                  title: Text('john.doe@example.com', style: TextStyle(color: Colors.grey[700])),
                ),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.indigo[600]),
                  title: Text('123 Tech Street, AI City', style: TextStyle(color: Colors.grey[700])),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Age: 28',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  'Occupation: Software Developer',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 4),
                Text(
                  'Interests: AI, Coding, Reading',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
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
              color: Colors.indigo[800],
            ),
          ),
          SizedBox(height: 12),
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
          SizedBox(height: 20),
          Text(
            'Badges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[800],
            ),
          ),
          SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAchievementCard('Achievement 1', Icons.circle),
                _buildAchievementCard('Achievement 2', Icons.circle),
                _buildAchievementCard('Achievement 3', Icons.circle),
                _buildAchievementCard('Achievement 4', Icons.circle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.indigo[800],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(String name, IconData icon) {
    return Card(
      color: Colors.indigo[800],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(right: 10),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
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
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Your Goals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.flag, color: Colors.indigo[600]),
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
                  leading: Icon(Icons.description, color: Colors.indigo[600]),
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
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminder Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[800],
                  ),
                ),
                SizedBox(height: 8),
                SwitchListTile(
                  secondary: Icon(Icons.notifications, color: Colors.indigo[600]),
                  title: Text('Enable Reminders', style: TextStyle(color: Colors.grey[700])),
                  value: _reminderEnabled,
                  onChanged: (value) {
                    setState(() {
                      _reminderEnabled = value;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Colors.indigo[600]),
                  title: Text(
                    'Reminder Time: ${_reminderTime.format(context)}',
                    style: TextStyle(color: Colors.grey[700]),
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
                  leading: Icon(Icons.repeat, color: Colors.indigo[600]),
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
        ],
      ),
    );
  }
}

// Custom clipper for curved edges
class CustomCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final curveHeight = 65.0; // Height of the curve
    final curveWidth = 90.0;  // Width of the curve at each end

    // Start at top-left
    path.moveTo(0, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right curve (bottom-right corner)
    path.lineTo(size.width, size.height - curveHeight);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - curveWidth,
      size.height,
    );

    // Bottom edge with curve
    path.lineTo(curveWidth, size.height);

    // Left curve (bottom-left corner)
    path.quadraticBezierTo(
      0,
      size.height,
      0,
      size.height - curveHeight,
    );

    // Back to start
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}