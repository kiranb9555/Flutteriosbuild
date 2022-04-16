class UserLoginResponseObject {
  String? addressLine1;
  String? addressLine2;
  Null? batchNo;
  String? city;
  int? cityId;
  String? counselingCategory;
  int? counselingCategoryId;
  int? createdBy;
  String? dOB;
  String? emailId;
  String? gender;
  int? genderId;
  Null? imagePath;
  int? isActive;
  int? isCreatedByAdmin;
  Null? machineId;
  String? mobileNo1;
  String? name;
  int? noOfChat;
  Null? oldPassword;
  String? packageTime;
  Null? password;
  String? pincode;
  String? state;
  int? stateId;
  String? termCondition;
  int? userId;
  Null? userName;
  int? appAccessTypeId;
  String? displayName;
  int? isOTPVerified;
  int? isProfileUpdated;
  int? packageExpired;

  UserLoginResponseObject(
      {this.addressLine1,
        this.addressLine2,
        this.batchNo,
        this.city,
        this.cityId,
        this.counselingCategory,
        this.counselingCategoryId,
        this.createdBy,
        this.dOB,
        this.emailId,
        this.gender,
        this.genderId,
        this.imagePath,
        this.isActive,
        this.isCreatedByAdmin,
        this.machineId,
        this.mobileNo1,
        this.name,
        this.noOfChat,
        this.oldPassword,
        this.packageTime,
        this.password,
        this.pincode,
        this.state,
        this.stateId,
        this.termCondition,
        this.userId,
        this.userName,
        this.appAccessTypeId,
        this.displayName,
        this.isOTPVerified,
        this.isProfileUpdated,
        this.packageExpired});

  UserLoginResponseObject.fromJson(Map<String, dynamic> json) {
    addressLine1 = json['AddressLine1'];
    addressLine2 = json['AddressLine2'];
    batchNo = json['BatchNo'];
    city = json['City'];
    cityId = json['CityId'];
    counselingCategory = json['CounselingCategory'];
    counselingCategoryId = json['CounselingCategoryId'];
    createdBy = json['CreatedBy'];
    dOB = json['DOB'];
    emailId = json['EmailId'];
    gender = json['Gender'];
    genderId = json['GenderId'];
    imagePath = json['ImagePath'];
    isActive = json['IsActive'];
    isCreatedByAdmin = json['IsCreatedByAdmin'];
    machineId = json['MachineId'];
    mobileNo1 = json['MobileNo1'];
    name = json['Name'];
    noOfChat = json['NoOfChat'];
    oldPassword = json['OldPassword'];
    packageTime = json['PackageTime'];
    password = json['Password'];
    pincode = json['Pincode'];
    state = json['State'];
    stateId = json['StateId'];
    termCondition = json['TermCondition'];
    userId = json['UserId'];
    userName = json['UserName'];
    appAccessTypeId = json['AppAccessTypeId'];
    displayName = json['DisplayName'];
    isOTPVerified = json['IsOTPVerified'];
    isProfileUpdated = json['IsProfileUpdated'];
    packageExpired = json['PackageExpired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AddressLine1'] = this.addressLine1;
    data['AddressLine2'] = this.addressLine2;
    data['BatchNo'] = this.batchNo;
    data['City'] = this.city;
    data['CityId'] = this.cityId;
    data['CounselingCategory'] = this.counselingCategory;
    data['CounselingCategoryId'] = this.counselingCategoryId;
    data['CreatedBy'] = this.createdBy;
    data['DOB'] = this.dOB;
    data['EmailId'] = this.emailId;
    data['Gender'] = this.gender;
    data['GenderId'] = this.genderId;
    data['ImagePath'] = this.imagePath;
    data['IsActive'] = this.isActive;
    data['IsCreatedByAdmin'] = this.isCreatedByAdmin;
    data['MachineId'] = this.machineId;
    data['MobileNo1'] = this.mobileNo1;
    data['Name'] = this.name;
    data['NoOfChat'] = this.noOfChat;
    data['OldPassword'] = this.oldPassword;
    data['PackageTime'] = this.packageTime;
    data['Password'] = this.password;
    data['Pincode'] = this.pincode;
    data['State'] = this.state;
    data['StateId'] = this.stateId;
    data['TermCondition'] = this.termCondition;
    data['UserId'] = this.userId;
    data['UserName'] = this.userName;
    data['AppAccessTypeId'] = this.appAccessTypeId;
    data['DisplayName'] = this.displayName;
    data['IsOTPVerified'] = this.isOTPVerified;
    data['IsProfileUpdated'] = this.isProfileUpdated;
    data['PackageExpired'] = this.packageExpired;
    return data;
  }
}