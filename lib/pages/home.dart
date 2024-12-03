import 'package:addmission_app/pages/contact_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:addmission_app/pages/student.dart';
import 'package:addmission_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Added import

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Controllers for form fields
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController contactcontroller = TextEditingController();
  TextEditingController datetimecontroller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  Stream? StudentStream;



  // Set to keep track of expanded items
  Set<String> expandedItems = {};

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  // Fetch student details on load
  getontheload() async {
    DatabaseMethods().getStudentDetails();
    StudentStream = await DatabaseMethods().getStudentDetails();
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose all controllers
    namecontroller.dispose();
    emailcontroller.dispose();
    addresscontroller.dispose();
    contactcontroller.dispose();
    datetimecontroller.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // Widget to display all student details
  Widget allStudentDetails() {
    return StreamBuilder(
      stream: StudentStream,
      builder: (context, AsyncSnapshot snapshot) {
        return ((!snapshot.hasData)||(snapshot.data.docs.isEmpty))
            ? Center(
                child: Text("No data found"),
              )
            : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  String studentId = ds["id"];
                  bool isExpanded = expandedItems.contains(studentId);

                  return Column(
                    children: [
                      // Main student detail container
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedItems.remove(studentId);
                            } else {
                              expandedItems.add(studentId);
                            }
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
                            children: [
                              // CircleAvatar wrapped with GestureDetector
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the ContactDetailPage with contact details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContactDetailPage(ds["contact"], contactId: studentId, contactName: ds["name"]),
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blueAccent,
                                  child: Text(
                                    getInitials(ds["name"]),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // If you have a profile picture URL, use the following instead:
                                  // backgroundImage: ds["profilePicUrl"] != null
                                  //     ? NetworkImage(ds["profilePicUrl"])
                                  //     : null,
                                ),
                              ),
                              SizedBox(width: 10), // Space between avatar and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name and Call Icon in a Row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Name: ${ds["name"]}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        // Call Icon
                                        GestureDetector(
                                          onTap: () async {
                                            final phoneNumber = ds["contact"];
                                            final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
                                            if (await canLaunchUrl(callUri)) {
                                              await launchUrl(callUri);
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Cannot launch phone dialer')),
                                              );
                                            }
                                          },
                                          child: Icon(
                                            Icons.call,
                                            color: Colors.black,
                                            size: 28,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    // Contact Text
                                    Text(
                                      "Contact: ${ds["contact"]}",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Expanded action options
                      if (isExpanded)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Message Action
                              GestureDetector(
                                onTap: () async {
                                  final phoneNumber = ds["contact"];
                                  final Uri smsUri = Uri(
                                    scheme: 'sms',
                                    path: phoneNumber,
                                    // Optionally, add a pre-filled message
                                    // queryParameters: {'body': 'Hello!'}
                                  );
                                  if (await canLaunchUrl(smsUri)) {
                                    await launchUrl(smsUri);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Cannot launch SMS app')),
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.message, color: Colors.black, size: 30),
                                    SizedBox(height: 5),
                                    Text(
                                      'Message',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),

                              // Video Call Action
                              GestureDetector(
                                onTap: () async {
                                  // Replace with your video call URL or integrate with a video call service
                                  final videoCallUrl = 'https://your-video-call-link.com';
                                  final Uri videoCallUri = Uri.parse(videoCallUrl);
                                  if (await canLaunchUrl(videoCallUri)) {
                                    await launchUrl(videoCallUri);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Cannot launch video call')),
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.videocam, color: Colors.black, size: 30),
                                    SizedBox(height: 5),
                                    Text(
                                      'Video Call',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),

                              // WhatsApp Share Action
                              GestureDetector(
                                onTap: () async {
                                  final phoneNumber = ds["contact"];
                                  final text = Uri.encodeComponent('Hello ${ds["name"]},');
                                  final whatsappUrl = "https://wa.me/$phoneNumber?text=$text";
                                  final Uri whatsappUri = Uri.parse(whatsappUrl);
                                  if (await canLaunchUrl(whatsappUri)) {
                                    await launchUrl(whatsappUri);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Cannot launch WhatsApp')),
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.messenger_outline_sharp, color: Colors.black, size: 30),
                                    SizedBox(height: 5),
                                    Text(
                                      'WhatsApp',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),

                              // Edit Action
                              GestureDetector(
                                onTap: () {
                                  // Populate controllers with existing data
                                  namecontroller.text = ds["name"];
                                  emailcontroller.text = ds["email"];
                                  countryController.text = ds["country"];
                                  stateController.text = ds["state"];
                                  cityController.text = ds["city"];
                                  addresscontroller.text = ds["address"];
                                  contactcontroller.text = ds["contact"];
                                  datetimecontroller.text = ds["date_time"] ?? DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());

                                  // Open edit dialog
                                  EditStudentDetail(ds["id"], ds["date_time"]);
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.edit, color: Colors.black, size: 30),
                                    SizedBox(height: 5),
                                    Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),

                              // Delete Action
                              GestureDetector(
                                onTap: () async {
                                  // Await user confirmation
                                  bool shouldDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.grey[800],
                                        title: Text(
                                          'Delete Confirmation',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        content: Text(
                                          'Are you sure you want to delete this detail?',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancel', style: TextStyle(color: Colors.white)),
                                            onPressed: () {
                                              Navigator.of(context).pop(false); // Return false if Cancel is pressed
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
                                            onPressed: () {
                                              Navigator.of(context).pop(true); // Return true if Delete is pressed
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  // Check the result and perform deletion if confirmed
                                  if (shouldDelete) {
                                    // Perform delete operation here
                                    // Example: Call your delete function
                                    // await deleteContact(contactId);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Contact deleted successfully!')),
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.delete, color: Colors.black, size: 30),
                                    SizedBox(height: 5),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Student()));
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Admission",
            style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          Text(
            " App",
            style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ]),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: Column(
          children: [
            Expanded(child: allStudentDetails()),
          ],
        ),
      ),
    );
  }

  // Method to show the edit dialog
  Future EditStudentDetail(String id, String? initialDateTime) => showDialog(
        context: context,
        builder: (content) => AlertDialog(
          backgroundColor: Colors.grey[850],
          content: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with cancel icon
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel, color: Colors.white),
                      ),
                      SizedBox(width: 60),
                      Text(
                        "Edit",
                        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        " Details",
                        style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Name Field
                  Text(
                    "Name:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: namecontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Email Field
                  Text(
                    "Email:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: emailcontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Location Fields
                  Text(
                    "Location:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Country Field
                  Text(
                    "Country:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: countryController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // State Field
                  Text(
                    "State:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: stateController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // City Field
                  Text(
                    "City:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: cityController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Address Field
                  Text(
                    "Address:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: addresscontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Contact Field
                  Text(
                    "Contact:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: contactcontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Date and Time Field
                  Text(
                    "Date and Time:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: datetimecontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                      readOnly: true,
                    ),
                  ),
                  // Update Button
                  GestureDetector(
                    onTap: () {
                      Map<String, dynamic> newStudentDetail = {
                        "Name": namecontroller.text,
                        "Email": emailcontroller.text,
                        "Country": countryController.text,
                        "State": stateController.text,
                        "City": cityController.text,
                        "Address": addresscontroller.text,
                        "Contact": contactcontroller.text,
                        "Date and Time": DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now()), // Update to current time
                      };

                      DatabaseMethods().updateStudentDetail(id, newStudentDetail);
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Update Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
// Helper method to get initials from name
  String getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    for (var part in names) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }
    return initials;
  }
}
