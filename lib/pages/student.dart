import 'package:addmission_app/pages/home.dart';
import 'package:addmission_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:intl/intl.dart';

class Student extends StatefulWidget {
  const Student({super.key});

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  TextEditingController contactcontroller = TextEditingController();
  TextEditingController datetimecontroller = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    datetimecontroller.text =
        DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());
  }

  @override
  void dispose() {
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

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a contact number';
    } else if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit contact number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set scaffold background to white
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // AppBar background to black
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Student",
              style: TextStyle(
                  color: Colors.white, // Text color to white
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "  Form",
              style: TextStyle(
                  color: Colors.white, // Text color to white
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true, // Center the title
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name Field
                Text(
                  "Name:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black), // Text color to black
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Email Field
                Text(
                  "Email:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: emailcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black), // Text color to black
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
               
              SizedBox(height: 20),
              Text(
                  "Location:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                

                SizedBox(height: 10),


                // CSCPicker
                CSCPicker(
                  layout: Layout.horizontal,
                  showStates: true,
                  showCities: true,
                  dropdownDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    border: Border.all(color: Colors.black), // Border to black
                  ),
                  selectedItemStyle: TextStyle(
                    color: Colors.black, // Selected item text color to black
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  onCountryChanged: (country) {
                    setState(() {
                      countryController.text = country;
                    });
                  },
                  onStateChanged: (state) {
                    setState(() {
                      stateController.text = state ?? "";
                    });
                  },
                  onCityChanged: (city) {
                    setState(() {
                      cityController.text = city ?? "";
                    });
                  },
                ),

                SizedBox(height: 20),
                  // Location Section
                

                // Country Field
                Text(
                  "Country:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: countryController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black), // Text color to black
                  ),
                ),
                SizedBox(height: 20),

                // State Field
                Text(
                  "State:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: stateController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black), // Text color to black
                  ),
                ),
                SizedBox(height: 20),

                // City Field
                Text(
                  "City:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: cityController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black), // Text color to black
                  ),
                ),

                // Address Field
                Text(
                  "Address:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: addresscontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.black), // Text color to black
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),

                // Contact Field
                Text(
                  "Contact:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: contactcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.black), // Text color to black
                    validator: _validateContact,
                  ),
                ),
                SizedBox(height: 20),

                // Date and Time Field
                Text(
                  "Date and Time:",
                  style: TextStyle(
                    color: Colors.black, // Label color to black
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Border to black
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: datetimecontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                    style: TextStyle(color: Colors.black), // Text color to black
                  ),
                ),
                SizedBox(height: 20),

                // Add Button
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.black, // Button background color to black
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded edges
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')),
                        );
                        String id = randomAlphaNumeric(10);
                        Map<String, dynamic> studentInfoMap = {
                          "name": namecontroller.text,
                          "email": emailcontroller.text,
                          "country": countryController.text,
                          "state": stateController.text,
                          "city": cityController.text,
                          "address": addresscontroller.text,
                          "id": id,
                          "contact": contactcontroller.text,
                          "date_time": datetimecontroller.text,
                        };

                        await DatabaseMethods()
                            .addStudentDetails(studentInfoMap, id)
                            .then((value) {
                          Fluttertoast.showToast(
                            msg: "Student Details have been uploaded",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                                Colors.black, // Toast background to black
                            textColor: Colors.white, // Toast text color to white
                            fontSize: 16.0,
                          );

                          Navigator.push(
                            context,
                           
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        });
                      }
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.white, // Button text color to white
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
  }
}
