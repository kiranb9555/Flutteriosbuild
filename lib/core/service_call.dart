import 'package:Counselinks/core/constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'util.dart';

class ServiceCall {
  Future<Map<String, dynamic>> apiCall(
    BuildContext context,
    String url,
    Map map,
  ) async {
    var responsejson;

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(map));
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (response.body != null) {
          responsejson = responseJson;
          return responseJson;
        } else {
          Util().displayToastMsg("Response is Empty");
        }
      } else if (response.statusCode == 400) {
        Util().displayToastMsg("Bad Request");
      } else if (response.statusCode == 404) {
        Util().displayToastMsg("Not Found");
      } else if (response.statusCode == 500) {
        Util().displayToastMsg("Internal Server Error");
      }
    } else {
      Util().displayToastMsg("Check Internet Conenction.");
    }

    return responsejson;
  }

  Future<Map<String, dynamic>> razorPayApiCall(
      BuildContext context, String url, Map map) async {
    var responsejson;

    var connectivityResult = await (Connectivity().checkConnectivity());
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('${Constant.KEY_ID}:${Constant.KEY_SECRET}'));

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authorization': basicAuth
          },
          body: jsonEncode(map));
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (response.body != null) {
          responsejson = responseJson;
          return responseJson;
        } else {
          Util().displayToastMsg("Response is Empty");
        }
      }
      // else if (response.statusCode == 400) {
      //   Util().displayToastMsg("Bad Request");
      // }
      else if (response.statusCode == 404) {
        Util().displayToastMsg("Not Found");
      } else if (response.statusCode == 500) {
        Util().displayToastMsg("Internal Server Error");
      }
    } else {
      Util().displayToastMsg("Check Internet Conenction.");
    }

    return responsejson;
  }

  Future<Map<String, dynamic>> razorPayGetApiCall(
    BuildContext context,
    String url,
  ) async {
    var responsejson;

    var connectivityResult = await (Connectivity().checkConnectivity());
    String basicAuth = 'Basic ' +
        base64Encode(utf8.encode('${Constant.KEY_ID}:${Constant.KEY_SECRET}'));

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': basicAuth
        },
      );
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (response.body != null) {
          responsejson = responseJson;
          return responseJson;
        } else {
          Util().displayToastMsg("Response is Empty");
        }
      }
      // else if (response.statusCode == 400) {
      //   Util().displayToastMsg("Bad Request");
      // }
      else if (response.statusCode == 404) {
        Util().displayToastMsg("Not Found");
      } else if (response.statusCode == 500) {
        Util().displayToastMsg("Internal Server Error");
      }
    } else {
      Util().displayToastMsg("Check Internet Conenction.");
    }

    return responsejson;
  }
}
