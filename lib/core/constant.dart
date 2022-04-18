class Constant {
  static const double padding =20;

  static const String APP_TITLE_NAME = "Counselinks";

  static const String WEBSITE_LINK = "https://counselinks.com/";

  static const String API_BASE_URL = "https://api.counselinks.com/Examinsider/EIService.svc/";

  static const String API_LOGIN_OUTSIDE = "LoginOutside";
  /*
  * {    "objReqOutsideLogin":   {                "MachineId":1                    ,"Password":"1234"                 ,"UserName":"kamra.yogi@gmail.com"          }}
  * */

  static const String API_LOGIN_SCHOOL = "LoginSchoolUser";
  /*
  * {"objReqSchoolUserLogin":{"MachineId":1,"Password":"Enrollment No","UserName":"1-1-Enrollment No","CompanyCode":"GDG"}}
  * */

  static const String API_COMPANY_INFO = "GetCompanyBasicInfo";
  /*
  * {"objRequestCompanyBasicInfo":{"CompanyCode":"GDG"}}
  * */

  static const String API_SIGNUP_OUTSIDE = "SignUpOutside";
  /*
  * {"objReqOutsideLogin":       {               "MachineId":12121212121212  ,"UserId":0  ,"Name":"Anil soni"            ,"Password":"1234"                 "GenderId":101001                  ,"MobileNo1":1232135678                ,"EmailId":"kamra.yogi1234@gmail.com"                  ,"CreatedBy":1                  }}
  * */

  static const String API_SET_USER_OTP_VERIFIED = "SetUserOTPVerified";
  /*
  * {"objReqSetOTPVerified":{"CompanyCode":"","UserId":52}}
  * */

  static const String API_STATE_LIST = "GetDeleteStateList";
  /*
  * {"objRequestStateMaster":{"CountryMasterId":1000}}
  * */

  static const String API_CITY_LIST = "GetDeleteCityList";
  /*
  * {"objRequestCityMaster":{"StateMasterId":1000}}
  * */

  static const String API_COUNSELING_CATEGORY_LIST = "GetDeleteCounselingCategoryList";
  /*
  * {"objRequestCounselingCategory":{"Action":"GETFORDROPDOWN","CounselingCategoryId":0}}
  * */

  static const String API_PURCHASE_PACKAGE_LIST = "PurchasePackageByUser";
  /*
  * {"objRequestPackageMaster":{"PackageMasterId":1,"UserId":1,"Amount":1000}}
  * */

  static const String API_PACKAGE_DETAIL_LIST = "GetPackageDetailForUserPurchase";
  /*
  * {"objRequestPackageMaster":{"Action":"GETFORNEWPACKAGE","UserId":1}}
  * */

  static const String API_VALIDATE_GENERATE_OTP = "ValidateAndGenrateOTP";
  /*
  * {"objReqValidateAndGenrateOTP":{"CompanyCode":"","UserName":"4444444444"}}
  * */

  static const String API_GET_ALL_CHAT = "GetMyChat";
  /*
  * {"objRequestMyChat":{"UserId":"1","AppAccessTypeId": "126","FromDate":"10-10-2010","ToDate":"10-10-2022"}}
  * */

  static const String API_REPLY_BY_USER = "RplyByUser";
  /*
  * {"objRequestReplyQueryChatDetail":{"UserChatDetailId":"0","Answer": "Yogesh","UserChatId":"22","UserId":"50"}}
  * */

  static const String API_RESET_PASSWORD = "ResetAppUserPassword";
  /*
  * {"objReqValidateAndGenrateOTP":{"CompanyCode":"","UserId":"35","OTP": "9751","Password":"1234"}}
  * */
  static const String API_CHANGE_PASSWORD = "ChangePasswordOutsideUser";
  /*
  * {"objReqOutsideLogin":{"OldPassword":"1234","Password":"123456","UserId":1}}
  * */

  static const String API_APP_VERSION = "GetDeleteVersionDetail";
  /*
  * 1 For Minor,2 for  Normal,3 For urgent
  * */
  static const String CHAT_WEB_LINK = "https://counselinks.com/CounseLink/CouselinkChat/?AppAccessId=55&LanguageId=1&AppAccessTypeId=126";

/*
* Razorpay information
* */
  static const String KEY = "GetDeleteVersionDetail";
  static const String Name = "GetDeleteVersionDetail";
  static const String  DESCRIPTION= "GetDeleteVersionDetail";
  static const String  TIMEDOUT= "GetDeleteVersionDetail";
  static const String  CONTACTNUMBER= "GetDeleteVersionDetail";
  static const String  EMAIL= "GetDeleteVersionDetail";

//Counselink test
//   static const String  KEY_ID= "rzp_test_nXZBqNIoIodSnS";
//   static const String  KEY_SECRET= "NdBhsROLmOo3CfQQ7iNjS12v";

//Counselink live
  static const String  KEY_ID= "rzp_live_fY85iAkB2z9jav";
  static const String  KEY_SECRET= "L3nxK6LsnvTzQB292H6xwRxh";

  //lucky
  // static const String  KEY_ID1= "rzp_test_vyGqvff8gJRfMC";
  // static const String  KEY_SECRET1= "vX7mSZr3nCFYP11g6FeYVVHw";
  static const String  TIMED_OUT= "300";

  static const String  RAZOR_PAY_BASE_URL= "https://api.razorpay.com/v1/";
  static const String  API_CREATE_CUSTOMER= "customers";
  static const String  API_CREATE_ORDER= "orders";
  static const String  API_PAYMENT_LINKS= "payment_links";
  static const String  API_PAYMENTS= "payments/";
  static const String  API_CAPTURE_PAYMENT= "/capture";


}