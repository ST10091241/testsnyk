import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/data%20classes/LeaderboardDataClass.dart';

class leaderboard extends StatefulWidget {
  @override
  _leaderboardState createState() => _leaderboardState();
}

class _leaderboardState extends State<leaderboard> {
  final databaseReference =
      FirebaseDatabase.instance.ref().child('LeaderboardInfo');

  List<LeaderboardInfo> leaderboardList = [];

  @override
  void initState() {
    super.initState();
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    try {
      databaseReference.once().then((snapshot) {
        DataSnapshot dataSnapshot = snapshot.snapshot;
        if (dataSnapshot.value != null) {
          Map<String, dynamic>? data =
              dataSnapshot.value as Map<String, dynamic>?;
          if (data != null) {
            List<LeaderboardInfo> tempLeaderboardList = [];
            data.forEach((key, value) {
              try {
                var info = LeaderboardInfo.fromJson(value);
                tempLeaderboardList.add(info);
              } catch (e) {
                print(e);
              }
            });
            tempLeaderboardList
                .sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
            setState(() {
              leaderboardList = tempLeaderboardList;
            });
          }
        }
      }).catchError((error) {
        print("Error fetching leaderboard data: $error");
        // Handle error state here
      });
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: leaderboardList.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'There might be no records available',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Leaderboard',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (leaderboardList.length > 0) _buildHorizontalLeaders(),
                  SizedBox(height: 20),
                  if (leaderboardList.length > 3) _buildVerticalLeaders(),
                ],
              ),
            ),
    );
  }

 Widget _buildHorizontalLeaders() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: leaderboardList
        .take(leaderboardList.length > 3 ? 3 : leaderboardList.length)
        .map<Widget>((leader) => Expanded(child: _buildLeaderTile(leader)))
        .toList(),
  );
}

  Widget _buildVerticalLeaders() {
    return Expanded(
        child:Container(
        width: double.infinity,
        child: ListView.builder(
          itemCount: leaderboardList.length - 3,
          itemBuilder: (BuildContext context, int index) {
            final leader = leaderboardList[index + 3];
            return _buildVTile(leader);
          },
        ),
      ), 
    );   
  }

  Widget _buildLeaderTile(LeaderboardInfo leader) {
    return Card(
    elevation: 4.0,
    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Container(
    // Set a finite width for the ListTile
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        leading: CircleAvatar(
          child: Text('${leaderboardList.indexOf(leader) + 1}'),
        ),
        title: Text('${leader.name}'),
        subtitle: Text('Points: ${leader.score}'),
        trailing: Icon(Icons.star), // You can use any icon here
        onTap: () {
          // Add functionality for tapping on leaderboard items
        },
      ),
    ),
  );
  }
  
  Widget _buildVTile(LeaderboardInfo leader) {
    return Card(
    elevation: 4.0,
    margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    child: Container(
    // Set a finite width for the ListTile
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        leading: CircleAvatar(
          child: Text('${leaderboardList.indexOf(leader) + 1}'),
        ),
        title: Text('${leader.name}'),
        subtitle: Text('Points: ${leader.score}'),         // You can use any icon here
        onTap: () {
          // Add functionality for tapping on leaderboard items
        },
      ),
    ),
  );
  }
}
