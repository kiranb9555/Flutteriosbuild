import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefData {
  static String userLoggedInKey = "ISLOGGEDIN";
  static String userEmailKey = "USEREMAIL";
  static String userPasswordKey = "USERPASSWORD";
  static String machineIDKey = "MACHINEID";
  static String termsConditionKey = "ISTERMCONDITION";
  static String tcAcceptedKey = "ISTCACCEPTED";
  static String userLoginDataKey = "USERLOGINDATAKEY";
  static String profileUpdateKey = "PROFILEUPDATEKEY";
  static String packagePurchasedKey = "PACKAGEPURCHASEDKEY";

  //set, get and remove of user logged in.

  static Future<bool> setUserLoggedIn(bool isLoggedIn) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setBool(userLoggedInKey, isLoggedIn);
  }

  static Future<bool?> getUserLoggedIn() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getBool(userLoggedInKey);
  }

  static Future<bool> removeUserLoggedIn(isUserLoggedInKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(isUserLoggedInKey);
  }


  //set, get and remove of user name data.

  static Future<bool> setUserEmail(String userEmail) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setString(userEmailKey, userEmail);
  }

  static Future<String?> getUserEmail() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getString(userEmailKey);
  }

  static Future<bool> removeUserEmail(userEmailKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(userEmailKey);
  }

  //set, get and remove of user password data.

  static Future<bool> setUserPassword(String userPassword) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setString(userPasswordKey, userPassword);
  }

  static Future<String?> getUserPassword() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getString(userPasswordKey);
  }

  static Future<bool> removeUserPassword(userPasswordKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(userPasswordKey);
  }

  //set, get and remove of user machine id data.

  static Future<bool> setMachineID(String machineID) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setString(machineIDKey, machineID);
  }

  static Future<String?> getMachineID() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getString(machineIDKey);
  }

  static Future<bool> removeMachineID(machineIDKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(machineIDKey);
  }











  //set, get and remove of TermCondition.

  static Future<bool> setTermCondition(String termCondition) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setString(termsConditionKey, termCondition);
  }

  static Future<String?> getTermCondition() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getString(termsConditionKey);
  }

  static Future<bool> removeTermCondition(termsConditionKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(termsConditionKey);
  }

  //set, get and remove terms & conditions accepted in.

  static Future<bool> setTcAccepted(bool isTcAccepted) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setBool(tcAcceptedKey, isTcAccepted);
  }

  static Future<bool?> getTcAccepted() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getBool(tcAcceptedKey);
  }

  static Future<bool> removeTcAccepted(tcAcceptedKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(tcAcceptedKey);
  }

  //set, get and remove of user login data.

  static Future<bool> setUserLoginData(String userLoginData) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setString(userLoginDataKey, userLoginData);
  }

  static Future<String?> getUserLoginData() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getString(userLoginDataKey);
  }

  static Future<bool> removeUserLoginData(userLoginDataKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(userLoginDataKey);
  }

  //set, get and remove of profile update data.

  static Future<bool> setProfileUpdate(String profileUpdate) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setString(profileUpdateKey, profileUpdate);
  }

  static Future<String?> getProfileUpdate() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getString(profileUpdateKey);
  }

  static Future<bool> removeProfileUpdate(profileUpdateKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(profileUpdateKey);
  }

  //set, get and remove of Package Purchase data.

  static Future<bool> setPackagesPurchaseData(bool isPackagePurchases) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.setBool(packagePurchasedKey, isPackagePurchases);
  }

  static Future<bool?> getPackagesPurchaseData() async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.getBool(packagePurchasedKey);
  }

  static Future<bool> removePackagesPurchaseData(packagePurchasedKey) async{
    SharedPreferences preferences =  await SharedPreferences.getInstance();
    return await preferences.remove(packagePurchasedKey);
  }

}