import 'package:addmission_app/services/database.dart';
import 'package:addmission_app/styles/app_font_text.dart';
import 'package:addmission_app/styles/read_more.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:call_log/call_log.dart'; // Import the call_log package
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
 // Import your database methods

class ContactDetailPage extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String contactNumber;

  const ContactDetailPage(this.contactNumber, {super.key, required this.contactId, required this.contactName});

  @override
  _ContactDetailPageState createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  List<CallLogEntry> callHistory = []; // Call history to display
  final DatabaseMethods databaseMethods = DatabaseMethods(); // Initialize the database methods
  List<CallLogEntry>? callDetails;
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  CallLogEntry userDetails = CallLogEntry();
  int totalCalls = 0;

  @override
  void initState() {
    super.initState();
    _fetchCallLogs(); // Fetch call logs when the page initializes
  }

  // Fetch and store call logs in Firestore
  Future<void> _fetchCallLogs() async {
    // Request permission to access call logs
    var status = await Permission.phone.request();
    if (status.isGranted) {
      // If permission is granted, fetch the call logs
      Iterable<CallLogEntry> entries = await CallLog.query();
      callHistory = entries.toList();
      if (kDebugMode) {
        print(widget.contactNumber);
      }
      callDetails = callHistory.where((element) => element.number == "+91${widget.contactNumber}").toList();
      if(callDetails?.isNotEmpty ?? false){
        userDetails = callDetails![0];
        totalCalls = callDetails!.length;
      }
      isLoading.value = false;

      setState(() {
        // callHistory = entries
        //     .where((entry) => entry.number == widget.contactId) // Filter by contact number
        //     .map((entry) {
        //       // Check if timestamp is not null
        //       if (entry.timestamp != null) {
        //         // Convert timestamp to DateTime
        //         DateTime callDateTime = DateTime.fromMillisecondsSinceEpoch(entry.timestamp!);
        //
        //         // Calculate the end time based on duration (ensure entry.duration is not null)
        //         DateTime endTime = callDateTime.add(Duration(seconds: entry.duration ?? 0));
        //
        //         return Call(
        //           date: '${callDateTime.day} ${_getMonthShort(callDateTime.month)} ${callDateTime.year.toString().substring(2)}',
        //           startTime: '${callDateTime.hour > 12 ? callDateTime.hour - 12 : callDateTime.hour}:${callDateTime.minute.toString().padLeft(2, '0')} ${callDateTime.hour >= 12 ? 'PM' : 'AM'}',
        //           endTime: '${endTime.hour > 12 ? endTime.hour - 12 : endTime.hour}:${endTime.minute.toString().padLeft(2, '0')} ${endTime.hour >= 12 ? 'PM' : 'AM'}',
        //           duration: '${entry.duration != null ? entry.duration! ~/ 60 : 0} min', // Display duration in minutes
        //           isIncoming: entry.callType == CallType.incoming,
        //         );
        //       } else {
        //         return null; // Skip this entry if no timestamp
        //       }
        //     })
        //     .where((call) => call != null)
        //     .cast<Call>()
        //     .toList(); // Filter out null calls

        // Save the fetched call logs to Firestore
        _saveCallLogsToFirestore();
      });
    } else {
      // Handle the case when permission is denied
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission to access call logs denied')));
      // setState(() => isLoading = false);
    }
  }

  // Save the fetched call logs to Firestore
  Future<void> _saveCallLogsToFirestore() async {
    // List<Map<String, dynamic>> callLogsMap = callHistory.map((call) => call.toMap()).toList();
    // await databaseMethods.addCallLogs(widget.contactId, callLogsMap);
  }

  String _getMonthShort(int month) {
    const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return months[month - 1];
  }

  Widget userDetailRow(String heading, String value){
    return Row(
      children: [
        AppFontText().labelMediumText("$heading : ", Colors.black),
        AppFontText().paragraphMediumText(value, Colors.black54),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: Colors.white)),
                      SizedBox(width: 20),
                      Text('Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  IconButton(onPressed: _fetchCallLogs, icon: Icon(Icons.refresh, color: Colors.white)),
                ],
              ),
            ),
            // Loading indicator or content
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, value, child) {
             return value ? Expanded(child: Center(child: CircularProgressIndicator()))
                 : Expanded(
               child: SingleChildScrollView(
                 child: Column(
                   children: [
                     Container(
                       margin: EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         border: Border.all(),
                         borderRadius: BorderRadius.circular(12)
                       ),
                       width: MediaQuery.sizeOf(context).width,
                       child: Padding(
                         padding: const EdgeInsets.all(24.0),
                         child: Column(
                           children: [
                             userDetailRow("Name", "${userDetails.name}"),
                             userDetailRow("Contact", "${userDetails.number}"),
                             userDetailRow("Total calls", "$totalCalls"),
                           ],
                         ),
                       ),
                     ),
                     Divider(),
                     Container(
                       margin: EdgeInsets.all(16),
                       decoration: BoxDecoration(
                         border: Border.all(),
                         borderRadius: BorderRadius.circular(12)
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Column(
                           children: [
                             ListView.builder(
                               shrinkWrap: true,
                               padding: EdgeInsets.zero,
                               physics: ClampingScrollPhysics(),
                               itemCount: 2,
                               itemBuilder: (context, index) {
                                 final call = callDetails?[index] ?? CallLogEntry();
                                 if (kDebugMode) {
                                   print("call timeStamp : ${call.timestamp}");
                                 }
                                 return ListTile(
                                   contentPadding: EdgeInsets.zero,
                                   leading: (call.callType == CallType.incoming) ? Icon(Icons.call_received, color: Colors.green) : Icon(Icons.call_made, color: Colors.red),
                                   title: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       AppFontText().paragraphSmallText(DateFormat("dd MMMM yyyy, HH:mm a").format(DateTime.fromMillisecondsSinceEpoch((call.timestamp!))), Colors.black),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           AppFontText().paragraphMediumText('${(call.callType == CallType.incoming)  ? 'Incoming' : 'Outgoing'} Call', Colors.black54),
                                           // Text('${call.timestamp} - ${call.startTime} to ${call.endTime}', style: TextStyle(fontSize: 14)),
                                         ],
                                       ),
                                     ],
                                   ),
                                   subtitle: Text('Duration: ${call.duration}', style: TextStyle(fontSize: 14)
                                   ),
                                 );
                               },
                             ),
                             ReadMoreText(callDetails),
                           ],
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             );
              },
            )
          ],
        ),
      ),
    );
  }
}
