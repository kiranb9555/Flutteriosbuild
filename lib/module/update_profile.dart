import 'dart:convert';

import 'package:Counselinks/core/util.dart';
import 'package:Counselinks/module/home.dart';
import 'package:Counselinks/module/profile.dart';
import 'package:Counselinks/shared/slide_left_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:intl/intl.dart';

import '../core/constant.dart';
import '../core/service_call.dart';
import '../database/shared_pred_data.dart';
import '../model/user_login_response.dart';
import '../shared/slide_right_route.dart';
import 'signin.dart';

class UpdateProfile extends StatefulWidget {
  dynamic userLoginData;

  UpdateProfile(
    this.userLoginData, {
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  FocusNode _focus = FocusNode();
  DateTime selectedDate = DateTime.now();
  final addController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final dobController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinController = TextEditingController();
  final mobileController = TextEditingController();
  final categoryController = TextEditingController();
  final categoryIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSavingData = false;
  String dropdownValue = 'Male';
  int stateCode = 0;
  int cityCode = 0;
  bool _isLoading = false;
  int counselingCategoryId = 0;

  @override
  void initState() {
    super.initState();
    _getFilledData();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    addController.dispose();
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    dobController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    stateController.dispose();
    cityController.dispose();
    pinController.dispose();
    mobileController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${_focus.hasFocus.toString()}");
  }

  _getFilledData() {
    print("userLoginData134");
    print(widget.userLoginData);
    nameController.text = widget.userLoginData['responseObject'][0]['Name'];
    emailController.text = widget.userLoginData['responseObject'][0]['EmailId'];
    genderController.text = widget.userLoginData['responseObject'][0]['Gender'];
    dobController.text = widget.userLoginData['responseObject'][0]['DOB'] != "01-01-1900" ?  widget.userLoginData['responseObject'][0]['DOB'] : "";
    addressLine1Controller.text =
        widget.userLoginData['responseObject'][0]['AddressLine1'];
    addressLine2Controller.text =
        widget.userLoginData['responseObject'][0]['AddressLine2'];
    stateController.text = widget.userLoginData['responseObject'][0]['State'];
    cityController.text = widget.userLoginData['responseObject'][0]['City'];
    cityCode = widget.userLoginData['responseObject'][0]['CityId'];
    pinController.text = widget.userLoginData['responseObject'][0]['Pincode'];
    mobileController.text =
        widget.userLoginData['responseObject'][0]['MobileNo1'];
    categoryController.text =
        widget.userLoginData['responseObject'][0]['CounselingCategory'];
    categoryIdController.text =
        widget.userLoginData['responseObject'][0]['CounselingCategoryId'].toString();
  }

  @override
  Widget build(BuildContext context) {
    double height2 = Util().getScreenHeight(context);
    double fontSize = Util().getScreenHeight(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: WillPopScope(
          onWillPop: ()async{
            Navigator.pushReplacement(
              context,
              SlideLeftRoute(
                page: Profile(),
              ),
            );
            return false;
          },
        child: Container(
          decoration: Util().boxDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: Util().getAppBar(context, 'Update Profile', fontSize, height2),
            body: _body(),
          ),
        ),
      ),
    );
  }

  _body(){
    final address =  TextField(
      // controller:  addController,
      //   onEditingComplete: (){
      //   print("addController");
      //   print(addController.text);
      //   },
    );

    double width = Util().getScreenHeight(context) * 0.25;
    double width1 = Util().getScreenHeight(context);
    double width2 = Util().getScreenHeight(context) * 0.2;
    double height = Util().getScreenHeight(context) * 0.15;
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _detailForm(
                      "Enter Name...", "Name", width1, nameController),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  _detailForm(
                      "Enter Email...", "Email", width1, emailController),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _detailForm("Enter Gender....", "Gender", width2,
                          genderController),
                      _detailForm(
                          "Enter DOB....", "DOB", width2, dobController),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),

                  _detailForm("Enter Address Line 1...", "Address Line 1",
                      width1, addressLine1Controller),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  _address2Field("Enter Address Line 2...", "Address Line 2",
                      width1, addressLine2Controller),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _detailForm("Enter State....", "State", width2,
                          stateController),
                      _detailForm(
                          "Enter City....", "City", width2, cityController),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _detailForm(
                          "Enter Pin....", "Pin", width2, pinController),
                      _detailForm("Enter Mobile No....", "Mobile No.",
                          width2, mobileController),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.06,
                  ),

                  _detailForm("Enter Category...", "Category", width1,
                      categoryController),
                  SizedBox(
                    height: height * 0.06,
                  ),
                  _submitButton(),
                  // _signIn()
                ],
              ),
            ),
          ),
        ),
        _isLoading ? Util().loadIndicator() : Container()
      ],
    );
  }

  _detailForm(String hintText, String labelText, double width,
      TextEditingController controller) {
    double fontSize = Util().getScreenHeight(context);
    return Container(
      width: width,
      child: TextFormField(
        keyboardType: _checkInputType(labelText),
        onTap: () {
          _clearFilledData(labelText);
          _callApi(labelText);
        },
        validator: (value) {
          if (value == "") {
            return 'Please enter $labelText';
          }

          return null;
        },
        controller: controller,
        cursorColor: Colors.blueGrey.shade900,
        cursorHeight: 20.0,
        readOnly: _readOnly(labelText),
        style: TextStyle(
          color: Colors.blueGrey.shade600,
          fontSize: fontSize * 0.022,
        ),
        decoration:Util().inputDecoration(labelText, hintText, fontSize),
      ),
    );
  }

  _address2Field(String hintText, String labelText, double width, TextEditingController controller
     ) {
    double fontSize = Util().getScreenHeight(context);
    return Container(
      width: width,
      child: TextFormField(

        cursorColor: Colors.blueGrey.shade900,
        cursorHeight: 20.0,
        controller: controller,
        style: TextStyle(
          color: Colors.blueGrey.shade600,
          fontSize: fontSize * 0.022,
        ),
        decoration:Util().inputDecoration(labelText, hintText, fontSize),
      ),
    );
  }

  _checkInputType(labelText) {
    if (labelText == "State") {
      return TextInputType.none;
    } else if (labelText == "City") {
      return TextInputType.none;
    } else if (labelText == "Category") {
      return TextInputType.none;
    } else if (labelText == "DOB") {
      return TextInputType.none;
    } else if (labelText == "Mobile No.") {
      return TextInputType.number;
    } else if (labelText == "Pin") {
      return TextInputType.number;
    }else {
      return TextInputType.name;
    }
  }

  _callApi(labelText) {
    if (labelText == "State") {
      print("call State API");
      _callStateApi();
    } else if (labelText == "City") {
      print("call City API");
      if (stateCode == 0) {
        Util().displayToastMsg("Please Select State First.");
      } else {
        _callCityApi();
      }
    } else if (labelText == "Category") {
      print("call Category API");
      _callCategoryApi();
    } else if (labelText == "DOB") {
      print("call DOB API");
      _selectDate(context);
    }
    setState(() {
      // dobController.text = '1244';
    });
  }

  _clearFilledData(labelText) {
    if (labelText == "Address Line 1" &&
        addressLine1Controller.text.isNotEmpty) {
      return addressLine1Controller.clear();
    } else if (labelText == "Address Line 2" &&
        addressLine2Controller.text.isNotEmpty) {
      return addressLine2Controller.clear();
    } else if (labelText == "State" && stateController.text.isNotEmpty) {
      return stateController.clear();
    } else if (labelText == "Category" && categoryController.text.isNotEmpty) {
      return categoryController.clear();
    } else if (labelText == "DOB" && dobController.text.isNotEmpty) {
      return dobController.clear();
    }
  }

  _callStateApi() {
    setState(() {
      _isLoading = !_isLoading;
    });
    cityController.clear();
    pinController.clear();
    stateCode = 0;
    cityCode = 0;
    Map<String, dynamic> stateMap = {
      "objRequestStateMaster": {
        "CountryMasterId": 1000
      }
    };
    ServiceCall()
        .apiCall(
            context, Constant.API_BASE_URL + Constant.API_STATE_LIST, stateMap)
        .then((value) {
      // print(value);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Select State',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: Colors.blueAccent,
                ),
                content: setupAlertDialoagContainer(
                    context, value['responseObject']),
              ),
            );
          });
      // print("stateMap");
      // print(value);
    });
  }

  Widget setupAlertDialoagContainer(context, stateList) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: stateList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              setState(() {
                stateController.clear();
                print("state5646");
                print(stateController.text);
                stateCode = stateList[index]['StateMasterId'];
                // print("stateCode");
                // print(stateCode);
                stateController.text = stateList[index]['StateName'].toString();

                print("state5555");
                print(stateController.text);
                setState(() {
                  _isLoading = !_isLoading;
                });
                Navigator.pop(context);
              });
            },
            title: Text(stateList[index]['StateName']),
          );
        },
      ),
    );
  }

  _callCityApi() {
    setState(() {
      _isLoading = !_isLoading;
    });
    Map<String, dynamic> cityMap = {
      "objRequestCityMaster": {
        "StateMasterId": stateCode
      }
    };
    ServiceCall()
        .apiCall(
            context, Constant.API_BASE_URL + Constant.API_CITY_LIST, cityMap)
        .then((value) {
      // print(value);
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Container(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Select City',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  color: Colors.blueAccent,
                ),
                content: cityDialogContainer(context, value['responseObject']),
              ),
            );
          });
      // print("stateMap");
      // print(value);
    });
  }

  Widget cityDialogContainer(context, cityList) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cityList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              setState(() {
                cityController.text = cityList[index]['CityName'].toString();
                pinController.text = cityList[index]['PinCode'].toString();
                cityCode = cityList[index]['CityMasterId'];

                setState(() {
                  _isLoading = !_isLoading;
                });
                Navigator.pop(context);
              });
            },
            title: Text(cityList[index]['CityName']),
          );
        },
      ),
    );
  }

  _callCategoryApi() {
    setState(() {
      _isLoading = !_isLoading;
    });
    Map<String, dynamic> categoryMap = {
      "objRequestCounselingCategory": {
        "Action": "GETFORDROPDOWN",
        "CounselingCategoryId": 0
      }
    };
    print("categoryMap");
    print(categoryMap);
    ServiceCall()
        .apiCall(
            context,
            Constant.API_BASE_URL + Constant.API_COUNSELING_CATEGORY_LIST,
            categoryMap)
        .then((value) {
      print("category");
      print(value);
      if (value['responseCode'] == "1") {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select Category',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    color: Colors.blueAccent,
                  ),
                  content:
                      categoryDialogContainer(context, value['responseObject']),
                ),
              );
            });
        // print("stateMap");
        // print(value);
      } else {
        Util().displayToastMsg(value["responseMessage"]);
      }
    });
  }

  Widget categoryDialogContainer(context, categoryList) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categoryList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              print("categoryMap1324");
              print(categoryList);
              setState(() {
                categoryController.text =
                    categoryList[index]['CategoryName'].toString();
                categoryIdController.text = categoryList[index]['CounselingCategoryId'].toString() ;

                setState(() {
                  _isLoading = !_isLoading;
                });
                Navigator.pop(context);
              });
            },
            title: Text(categoryList[index]['CategoryName']),
          );
        },
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1947, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        final String formatted = formatter.format(selectedDate);
        dobController.text = formatted.toString();
      });
    }
  }

  _readOnly(labelText) {
    if (labelText == 'Name') {
      return true;
    } else if (labelText == 'Email') {
      return true;
    } else if (labelText == 'Gender') {
      return true;
    } else if (labelText == 'Mobile No.') {
      return true;
    } else {
      return false;
    }
  }

  _submitButton() {
    double fontSize = Util().getScreenHeight(context);
    return ElevatedButton(
      child: Util().getTextWithStyle1(
          title: "Update".toUpperCase(),
          color: Colors.black,
          fontSize: fontSize * 0.02,
          fontWeight: FontWeight.w700),
      style: Util().buttonStyle(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF91d0cc).withOpacity(0.9),
          borderColor: const Color(0xFF91d0cc).withOpacity(0.7),
          borderRadius: 18.0),
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        // String email = await SharedPrefData.getUserEmail();
        // Navigator.pushReplacement(
        //   context,
        //   SlideRightRoute(
        //     page: OtpVerification("1"),
        //   ),
        // );
        if (_formKey.currentState!.validate()) {
          setState(() {
            _isLoading = !_isLoading;
          });

          _updateUserDetail();
        }
      },
    );
  }

  _updateUserDetail() async {

    Map<String, dynamic> detailMap = {
      "objReqOutsideLogin": {
        "MachineId": 11212121,
        "UserId": widget.userLoginData['responseObject'][0]['UserId'],
        "Name": nameController.text,
        "Password": "1234",
        "GenderId": widget.userLoginData['responseObject'][0]['GenderId'],
        "CityId": cityCode,
        "AddressLine1": addressLine1Controller.text,
        "AddressLine2": addressLine2Controller.text,
        "DOB": dobController.text.toString(),
        "Pincode": pinController.text.toString(),
        "MobileNo1": mobileController.text.toString(),
        "EmailId": emailController.text,
        "CreatedBy": 0,
        "CounselingCategoryId": int.parse(categoryIdController.text)
      }
    };

    print("detailMap124"); //75459 33818, 4 :30 , 700  10   ,, 94319 76729, 85399 48322 7061809328,
    // 7004021983
    print(detailMap);
    ServiceCall()
        .apiCall(context, Constant.API_BASE_URL + Constant.API_SIGNUP_OUTSIDE,
            detailMap)
        .then((value) {
      print("userMap124");
      print(value);

      if (value["responseCode"] == "1") {
        print(value["responseMessage"]);
        Util().displayToastMsg(value["responseMessage"]);
        print("222222");
        print("222222 PackageExpired : " + value['responseObject'][0]['PackageExpired'].toString());
        print("22222223IsProfileUpdated : " + value['responseObject'][0]['IsProfileUpdated'].toString());
        setState(() {
          _removeUserData();
          UserLoginResponse userLoginResponse =
              UserLoginResponse.fromJson(value);
          String userData = jsonEncode(userLoginResponse);

          String userDetailMap = jsonEncode(detailMap);

          // String userData = jsonEncode(userData);
          SharedPrefData.setUserLoginData(userData);
          // SharedPrefData.setUserData(userDetailMap);
          setState(() {
            _isLoading = !_isLoading;
          });
        });

        // SharedPrefData.setProfileUpdate("1");
        Navigator.pushReplacement(
          context,
          SlideRightRoute(
            page: Home(),
          ),
        );
      } else if (value["responseCode"] == "0") {
        print(value["responseMessage"]);
        Util().displayToastMsg(value["responseMessage"]);
        setState(() {
          _isLoading = !_isLoading;
        });
      }
    });
  }

  _removeUserData() async {
    print("11111");
    await SharedPrefData.removeUserLoginData(SharedPrefData.userLoginDataKey);
  }
}
