import 'package:cloud_firestore/cloud_firestore.dart';
class orderModel{
  String userEmail;
  String providerEmail;
  String orderLocation;
  GeoPoint orderGeopoint;
  String orderStatus;
  DateTime orderDateTime;
  DateTime? acceptingDateTime;
  DateTime? startingDateTime;
  DateTime? endingDateTime;
  String orderType;
  String orderSubType;
  String otp;
  int fee;

  orderModel({
    required this.userEmail,
    required this.providerEmail,
    required this.orderLocation,
    required this.orderGeopoint,
    required this.orderStatus,
    required this.orderDateTime,
    this.acceptingDateTime,
    this.startingDateTime,
    this.endingDateTime,
    required this.orderType,
    required this.orderSubType,
    this.otp='N/A',
    this.fee=0,
  });

  Map<String, dynamic> toMap(){
    final Map = <String, dynamic>{
      'user' : userEmail,
      'provider' : providerEmail,
      'location' : orderLocation,
      'geopoint': orderGeopoint,
      'status' : orderStatus,
      'date_time' : FieldValue.serverTimestamp(),
      'service' : orderType,
      'subType' : orderSubType,
      'otp' : otp,
      'fee' : fee
    };
    return Map;
  }

  factory orderModel.fromMap(Map<String, dynamic> map) => orderModel(
    userEmail: map['user'],
    providerEmail: map['provider'],
    orderLocation: map['location']??'location',
    orderGeopoint: map['geopoint']??GeoPoint(5.00, 6.0),
    orderStatus: map['status'],
    orderDateTime: map['date_time'].toDate(),
    acceptingDateTime: map['accept_time']==null?null:map['accept_time'].toDate(),
    startingDateTime: map['start_time']==null?null:map['start_time'].toDate(),
    endingDateTime: map['end_time']==null?null:map['end_time'].toDate(),
    orderType: map['service'],
    orderSubType: map['subType'],
    otp: map['otp']??'',
    fee: map['fee'],
  );


}