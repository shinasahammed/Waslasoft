// To parse this JSON data, do
//
//     final salesdatamodel = salesdatamodelFromJson(jsonString);

import 'dart:convert';

Salesdatamodel salesdatamodelFromJson(String str) =>
    Salesdatamodel.fromJson(json.decode(str));

String salesdatamodelToJson(Salesdatamodel data) => json.encode(data.toJson());

class Salesdatamodel {
  int? statuscode;
  String? title;
  List<Datum>? data;
  dynamic errors;
  String? message;

  Salesdatamodel({
    this.statuscode,
    this.title,
    this.data,
    this.errors,
    this.message,
  });

  factory Salesdatamodel.fromJson(Map<String, dynamic> json) => Salesdatamodel(
    statuscode: json["statuscode"],
    title: json["title"],
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "statuscode": statuscode,
    "title": title,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "errors": errors,
    "message": message,
  };
}

class Datum {
  int? id;
  int? tmpId;
  String? companyName;
  int? companyId;
  dynamic invSequence;
  String? clientCode;
  bool? isCreated;
  bool? isUpdated;
  bool? isCreateSync;
  bool? isUpdateSync;
  DateTime? createdAt;
  int? orderId;
  String? orderNo;
  dynamic orderTrnNo;
  DateTime? saleDate;
  DateTime? orderDate;
  String? orderType;
  dynamic tableNo;
  dynamic waiterName;
  String? invoiceAmount;
  String? paymentModeCash;
  String? paymentModeCreditcard;
  String? creditTotal;
  String? grandTotal;
  String? cashier;
  String? salespersonName;
  DateTime? entryDate;
  int? deliveryCustomerId;
  String? name;
  dynamic billClosedBy;
  DateTime? billClosedTime;
  dynamic customerBillNo;
  List<SaleItem>? saleItems;

  Datum({
    this.id,
    this.tmpId,
    this.companyName,
    this.companyId,
    this.invSequence,
    this.clientCode,
    this.isCreated,
    this.isUpdated,
    this.isCreateSync,
    this.isUpdateSync,
    this.createdAt,
    this.orderId,
    this.orderNo,
    this.orderTrnNo,
    this.saleDate,
    this.orderDate,
    this.orderType,
    this.tableNo,
    this.waiterName,
    this.invoiceAmount,
    this.paymentModeCash,
    this.paymentModeCreditcard,
    this.creditTotal,
    this.grandTotal,
    this.cashier,
    this.salespersonName,
    this.entryDate,
    this.deliveryCustomerId,
    this.name,
    this.billClosedBy,
    this.billClosedTime,
    this.customerBillNo,
    this.saleItems,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    tmpId: json["tmp_id"],
    companyName: json["company_name"],
    companyId: json["company_id"],
    invSequence: json["inv_sequence"],
    clientCode: json["client_code"],
    isCreated: json["is_created"],
    isUpdated: json["is_updated"],
    isCreateSync: json["is_create_sync"],
    isUpdateSync: json["is_update_sync"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    orderId: json["order_id"],
    orderNo: json["order_no"],
    orderTrnNo: json["order_trn_no"],
    saleDate: json["sale_date"] == null
        ? null
        : DateTime.parse(json["sale_date"]),
    orderDate: json["order_date"] == null
        ? null
        : DateTime.parse(json["order_date"]),
    orderType: json["order_type"],
    tableNo: json["table_no"],
    waiterName: json["waiter_name"],
    invoiceAmount: json["invoice_amount"],
    paymentModeCash: json["payment_mode_cash"],
    paymentModeCreditcard: json["payment_mode_creditcard"],
    creditTotal: json["credit_total"],
    grandTotal: json["grand_total"],
    cashier: json["cashier"],
    salespersonName: json["salesperson_name"],
    entryDate: json["entry_date"] == null
        ? null
        : DateTime.parse(json["entry_date"]),
    deliveryCustomerId: json["delivery_customer_id"],
    name: json["name"],
    billClosedBy: json["bill_closed_by"],
    billClosedTime: json["bill_closed_time"] == null
        ? null
        : DateTime.parse(json["bill_closed_time"]),
    customerBillNo: json["customer_bill_no"],
    saleItems: json["sale_items"] == null
        ? []
        : List<SaleItem>.from(
            json["sale_items"]!.map((x) => SaleItem.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tmp_id": tmpId,
    "company_name": companyName,
    "company_id": companyId,
    "inv_sequence": invSequence,
    "client_code": clientCode,
    "is_created": isCreated,
    "is_updated": isUpdated,
    "is_create_sync": isCreateSync,
    "is_update_sync": isUpdateSync,
    "created_at": createdAt?.toIso8601String(),
    "order_id": orderId,
    "order_no": orderNo,
    "order_trn_no": orderTrnNo,
    "sale_date": saleDate?.toIso8601String(),
    "order_date": orderDate?.toIso8601String(),
    "order_type": orderType,
    "table_no": tableNo,
    "waiter_name": waiterName,
    "invoice_amount": invoiceAmount,
    "payment_mode_cash": paymentModeCash,
    "payment_mode_creditcard": paymentModeCreditcard,
    "credit_total": creditTotal,
    "grand_total": grandTotal,
    "cashier": cashier,
    "salesperson_name": salespersonName,
    "entry_date": entryDate?.toIso8601String(),
    "delivery_customer_id": deliveryCustomerId,
    "name": name,
    "bill_closed_by": billClosedBy,
    "bill_closed_time": billClosedTime?.toIso8601String(),
    "customer_bill_no": customerBillNo,
    "sale_items": saleItems == null
        ? []
        : List<dynamic>.from(saleItems!.map((x) => x.toJson())),
  };
}

class SaleItem {
  int? id;
  int? orderDetId;
  int? orderId;
  int? itemId;
  dynamic itemCode;
  String? product;
  String? packageName;
  String? clientCode;
  String? price;
  String? discountPercentage;
  String? discount;
  String? qty;
  String? returnQty;
  String? itemPrice;
  String? subtotal;
  String? subPrice;
  String? taxPercentage;
  String? taxAmount;
  dynamic enteredBy;
  DateTime? entryDate;
  String? arabicName;
  bool? isEnabledTax;

  SaleItem({
    this.id,
    this.orderDetId,
    this.orderId,
    this.itemId,
    this.itemCode,
    this.product,
    this.packageName,
    this.clientCode,
    this.price,
    this.discountPercentage,
    this.discount,
    this.qty,
    this.returnQty,
    this.itemPrice,
    this.subtotal,
    this.subPrice,
    this.taxPercentage,
    this.taxAmount,
    this.enteredBy,
    this.entryDate,
    this.arabicName,
    this.isEnabledTax,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) => SaleItem(
    id: json["id"],
    orderDetId: json["order_det_id"],
    orderId: json["order_id"],
    itemId: json["item_id"],
    itemCode: json["item_code"],
    product: json["product"],
    packageName: json["package_name"],
    clientCode: json["client_code"],
    price: json["price"],
    discountPercentage: json["discount_percentage"],
    discount: json["discount"],
    qty: json["qty"],
    returnQty: json["return_qty"],
    itemPrice: json["item_price"],
    subtotal: json["subtotal"],
    subPrice: json["sub_price"],
    taxPercentage: json["tax_percentage"],
    taxAmount: json["tax_amount"],
    enteredBy: json["entered_by"],
    entryDate: json["entry_date"] == null
        ? null
        : DateTime.parse(json["entry_date"]),
    arabicName: json["arabic_name"],
    isEnabledTax: json["is_enabled_tax"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_det_id": orderDetId,
    "order_id": orderId,
    "item_id": itemId,
    "item_code": itemCode,
    "product": product,
    "package_name": packageName,
    "client_code": clientCode,
    "price": price,
    "discount_percentage": discountPercentage,
    "discount": discount,
    "qty": qty,
    "return_qty": returnQty,
    "item_price": itemPrice,
    "subtotal": subtotal,
    "sub_price": subPrice,
    "tax_percentage": taxPercentage,
    "tax_amount": taxAmount,
    "entered_by": enteredBy,
    "entry_date": entryDate?.toIso8601String(),
    "arabic_name": arabicName,
    "is_enabled_tax": isEnabledTax,
  };
}
