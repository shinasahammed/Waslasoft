import 'dart:convert';

Purchasemodel purchasemodelFromJson(String str) =>
    Purchasemodel.fromJson(json.decode(str));

String purchasemodelToJson(Purchasemodel data) =>
    json.encode(data.toJson());

class Purchasemodel {
  int id;
  String clientCode;
  bool isCreated;
  bool isUpdated;
  bool isCreateSync;
  bool isUpdateSync;
  DateTime createdAt;
  String itemName;
  dynamic itemNameArabic;
  dynamic printingName;
  String barcode;
  String unitName;
  String salePrice;
  String costPrice;
  String purchasePrice;
  String currentStock;
  dynamic remarks;
  dynamic brandId;
  dynamic groupId;
  dynamic groupName;
  dynamic itemDepartmentId;
  dynamic itemDepartmentName;
  dynamic itemCode;
  dynamic discountAmount;
  dynamic discountPercentage;
  String taxPercentage;
  dynamic taxAmount;
  bool isInclusiveTax;
  List<dynamic> unitItems;

  Purchasemodel({
    required this.id,
    required this.clientCode,
    required this.isCreated,
    required this.isUpdated,
    required this.isCreateSync,
    required this.isUpdateSync,
    required this.createdAt,
    required this.itemName,
    required this.itemNameArabic,
    required this.printingName,
    required this.barcode,
    required this.unitName,
    required this.salePrice,
    required this.costPrice,
    required this.purchasePrice,
    required this.currentStock,
    required this.remarks,
    required this.brandId,
    required this.groupId,
    required this.groupName,
    required this.itemDepartmentId,
    required this.itemDepartmentName,
    required this.itemCode,
    required this.discountAmount,
    required this.discountPercentage,
    required this.taxPercentage,
    required this.taxAmount,
    required this.isInclusiveTax,
    required this.unitItems,
  });

  factory Purchasemodel.fromJson(Map<String, dynamic> json) =>
      Purchasemodel(
        id: json["id"] ?? 0,
        clientCode: json["client_code"] ?? "",
        isCreated: json["is_created"] ?? false,
        isUpdated: json["is_updated"] ?? false,
        isCreateSync: json["is_create_sync"] ?? false,
        isUpdateSync: json["is_update_sync"] ?? false,
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        itemName: json["item_name"] ?? "",
        itemNameArabic: json["item_name_arabic"],
        printingName: json["printing_name"],
        barcode: json["barcode"] ?? "",
        unitName: json["unit_name"] ?? "",
        salePrice: json["sale_price"]?.toString() ?? "0",
        costPrice: json["cost_price"]?.toString() ?? "0",
        purchasePrice: json["purchase_price"]?.toString() ?? "0",
        currentStock: json["current_stock"]?.toString() ?? "0",
        remarks: json["remarks"],
        brandId: json["brand_id"],
        groupId: json["group_id"],
        groupName: json["group_name"],
        itemDepartmentId: json["item_department_id"],
        itemDepartmentName: json["item_department_name"],
        itemCode: json["item_code"],
        discountAmount: json["discount_amount"],
        discountPercentage: json["discount_percentage"],
        taxPercentage: json["tax_percentage"]?.toString() ?? "0",
        taxAmount: json["tax_amount"],
        isInclusiveTax: json["is_inclusive_tax"] ?? false,
        unitItems: json["unit_items"] == null
            ? []
            : List<dynamic>.from(json["unit_items"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_code": clientCode,
        "is_created": isCreated,
        "is_updated": isUpdated,
        "is_create_sync": isCreateSync,
        "is_update_sync": isUpdateSync,
        "created_at": createdAt.toIso8601String(),
        "item_name": itemName,
        "item_name_arabic": itemNameArabic,
        "printing_name": printingName,
        "barcode": barcode,
        "unit_name": unitName,
        "sale_price": salePrice,
        "cost_price": costPrice,
        "purchase_price": purchasePrice,
        "current_stock": currentStock,
        "remarks": remarks,
        "brand_id": brandId,
        "group_id": groupId,
        "group_name": groupName,
        "item_department_id": itemDepartmentId,
        "item_department_name": itemDepartmentName,
        "item_code": itemCode,
        "discount_amount": discountAmount,
        "discount_percentage": discountPercentage,
        "tax_percentage": taxPercentage,
        "tax_amount": taxAmount,
        "is_inclusive_tax": isInclusiveTax,
        "unit_items": unitItems,
      };
}