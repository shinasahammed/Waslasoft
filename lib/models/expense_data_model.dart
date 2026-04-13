// To parse this JSON data, do
//
//     final expensedatamodel = expensedatamodelFromJson(jsonString);

import 'dart:convert';

List<Expensedatamodel> expensedatamodelFromJson(String str) =>
    List<Expensedatamodel>.from(
      json.decode(str).map((x) => Expensedatamodel.fromJson(x)),
    );

String expensedatamodelToJson(List<Expensedatamodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Expensedatamodel {
  int? expenseId;
  String? createdBy;
  String? name;
  String? typ;
  String? clientCode;
  String? openBalance;
  dynamic description;
  DateTime? createdAt;
  bool? isCreated;
  bool? isUpdated;
  bool? isCreateSync;
  bool? isUpdateSync;

  Expensedatamodel({
    this.expenseId,
    this.createdBy,
    this.name,
    this.typ,
    this.clientCode,
    this.openBalance,
    this.description,
    this.createdAt,
    this.isCreated,
    this.isUpdated,
    this.isCreateSync,
    this.isUpdateSync,
  });

  factory Expensedatamodel.fromJson(Map<String, dynamic> json) =>
      Expensedatamodel(
        expenseId:
            json["expense_id"] ??
            (json["supplier_id"] != null
                ? int.tryParse(json["supplier_id"].toString())
                : null),
        createdBy: json["created_by"],
        name: json["name"] ?? json["supplier_name"],
        typ: json["typ"],
        clientCode: json["client_code"],
        openBalance: json["open_balance"],
        description: json["description"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        isCreated: json["is_created"],
        isUpdated: json["is_updated"],
        isCreateSync: json["is_create_sync"],
        isUpdateSync: json["is_update_sync"],
      );

  Map<String, dynamic> toJson() => {
    "expense_id": expenseId,
    "created_by": createdBy,
    "name": name,
    "typ": typ,
    "client_code": clientCode,
    "open_balance": openBalance,
    "description": description,
    "created_at": createdAt?.toIso8601String(),
    "is_created": isCreated,
    "is_updated": isUpdated,
    "is_create_sync": isCreateSync,
    "is_update_sync": isUpdateSync,
  };
}
