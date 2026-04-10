// To parse this JSON data, do
//
//     final paymentmodel = paymentmodelFromJson(jsonString);

import 'dart:convert';

List<Paymentmodel> paymentmodelFromJson(String str) => List<Paymentmodel>.from(json.decode(str).map((x) => Paymentmodel.fromJson(x)));

String paymentmodelToJson(List<Paymentmodel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Paymentmodel {
    int? id;
    DateTime? paymentDate;
    String? paidTo;
    String? amount;
    dynamic paymentMethod;
    String? clientCode;

    Paymentmodel({
        this.id,
        this.paymentDate,
        this.paidTo,
        this.amount,
        this.paymentMethod,
        this.clientCode,
    });

    factory Paymentmodel.fromJson(Map<String, dynamic> json) => Paymentmodel(
        id: json["id"],
        paymentDate: json["payment_date"] == null ? null : DateTime.parse(json["payment_date"]),
        paidTo: json["paid_to"],
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        clientCode: json["client_code"],
    );

    Map<String, dynamic> toJson() => {
        "paid_to": paidTo,
        "amount": num.tryParse(amount ?? "0") ?? 0,
        "payment_method": paymentMethod,
    };
}
