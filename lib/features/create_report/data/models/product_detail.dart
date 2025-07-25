class ProductDetail {
  bool? status;
  Msg? msg;

  ProductDetail({this.status, this.msg});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'] != null ? new Msg.fromJson(json['msg']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.msg != null) {
      data['msg'] = this.msg!.toJson();
    }
    return data;
  }
}

class Msg {
  UniqueCodeData? uniqueCodeData;
  ProductData? productData;

  Msg({this.uniqueCodeData, this.productData});

  Msg.fromJson(Map<String, dynamic> json) {
    uniqueCodeData = json['UniqueCodeData'] != null
        ? new UniqueCodeData.fromJson(json['UniqueCodeData'])
        : null;
    productData = json['ProductData'] != null
        ? new ProductData.fromJson(json['ProductData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uniqueCodeData != null) {
      data['UniqueCodeData'] = this.uniqueCodeData!.toJson();
    }
    if (this.productData != null) {
      data['ProductData'] = this.productData!.toJson();
    }
    return data;
  }
}

class UniqueCodeData {
  Attributes? attributes;
  String? sId;
  String? uniqueCode;
  String? itemCode;
  String? jobId;
  String? jobQueueId;
  String? supplier;
  String? ts;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isUsed;
  int? views;

  UniqueCodeData(
      {this.attributes,
        this.sId,
        this.uniqueCode,
        this.itemCode,
        this.jobId,
        this.jobQueueId,
        this.supplier,
        this.ts,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.isUsed,
        this.views});

  UniqueCodeData.fromJson(Map<String, dynamic> json) {
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    sId = json['_id'];
    uniqueCode = json['uniqueCode'];
    itemCode = json['ItemCode'];
    jobId = json['JobId'];
    jobQueueId = json['JobQueueId'];
    supplier = json['Supplier'];
    ts = json['ts'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isUsed = json['isUsed'];
    views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    data['_id'] = this.sId;
    data['uniqueCode'] = this.uniqueCode;
    data['ItemCode'] = this.itemCode;
    data['JobId'] = this.jobId;
    data['JobQueueId'] = this.jobQueueId;
    data['Supplier'] = this.supplier;
    data['ts'] = this.ts;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isUsed'] = this.isUsed;
    data['views'] = this.views;
    return data;
  }
}

class Attributes {
  bool? isExpired;

  Attributes({this.isExpired});

  Attributes.fromJson(Map<String, dynamic> json) {
    isExpired = json['isExpired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isExpired'] = this.isExpired;
    return data;
  }
}

class ProductData {
  String? sId;
  String? businessUnit;
  String? company;
  String? category;
  String? subCategory;
  String? description;
  String? itemCode;
  int? warrantyMonths;
  String? redirectURL;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ProductData(
      {this.sId,
        this.businessUnit,
        this.company,
        this.category,
        this.subCategory,
        this.description,
        this.itemCode,
        this.warrantyMonths,
        this.redirectURL,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ProductData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    businessUnit = json['businessUnit'];
    company = json['company'];
    category = json['category'];
    subCategory = json['subCategory'];
    description = json['description'];
    itemCode = json['itemCode'];
    warrantyMonths = json['warrantyMonths'];
    redirectURL = json['redirectURL'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['businessUnit'] = this.businessUnit;
    data['company'] = this.company;
    data['category'] = this.category;
    data['subCategory'] = this.subCategory;
    data['description'] = this.description;
    data['itemCode'] = this.itemCode;
    data['warrantyMonths'] = this.warrantyMonths;
    data['redirectURL'] = this.redirectURL;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
