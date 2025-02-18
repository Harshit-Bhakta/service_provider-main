import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_provider/Models/providerModel.dart';
import 'package:service_provider/Models/userModel.dart';
import 'package:service_provider/Pages/launcher.dart';
import '../Models/orderModel.dart';
import '../Pages/selectedServiceInfo.dart';
import 'package:http/http.dart' as http;


class OrderController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  var random = Random(DateTime.now().millisecondsSinceEpoch);

  bool historyProgressVisibility=true;
  void historyProgressVisibilitySetter(bool value){
    historyProgressVisibility=value;
    update();
  }
  List<orderModel> history = [];
  List<orderModel> requestedOrders = [];
  Future<void> getHistory() async {
    await _db
        .collection('Orders')
        .orderBy('date_time')
        .where(loginType == true ? 'user' : 'provider',
            isEqualTo: _auth.currentUser!.email)
        .get()
        .then((value) {
      history.clear();
      requestedOrders.clear();
      value.docs.forEach((element) {
        history.insert(0, orderModel.fromMap(element.data()));
        if (element.data()['status'] == 'Pending') {
          requestedOrders.add(history[0]);
        }
      });
      historyProgressVisibility=false;
      update();
    });
  }

  List<orderModel> activeOrders=[];
  Future<void> getActiveOrders()async{
    await _db
        .collection('Orders')
        .orderBy('date_time')
        .where(loginType == true ? 'user' : 'provider',
        isEqualTo: _auth.currentUser!.email)
        .get()
        .then((value) {
      activeOrders.clear();
      value.docs.forEach((element) {
        if(element.data()['status']=='Running' || element.data()['status']=='Started'){
          activeOrders.add(orderModel.fromMap(element.data()));
        }
      });
      update();
    });
  }

  Future postOrder(orderModel order) async {
    await _db.collection('Orders').add(order.toMap()).whenComplete(() {
      visibility=false;
      update();
    });
  }

  late userModel orderUser;
  late providerModel orderProvider;
  Future getOrderInfo(orderModel order)async{
    await _db.collection('providers').doc(order.providerEmail).get().then((value) async{
      await _db.collection(value.data()!['type']).doc(order.providerEmail).get().then((val) {
        orderProvider=providerModel.fromMap(val.data()!);
      });
    });
    await _db.collection('Users').doc(order.userEmail).get().then((value) {
      orderUser=userModel.fromMap(value.data()!);
    });
  }


  Future orderAccept(orderModel order)async{
    EasyLoading.show(
      status: 'Accepting Order...',
      dismissOnTap: false,
    );
    await _db.collection('Orders')
        .where('provider',isEqualTo: order.providerEmail)
        .where('user',isEqualTo: order.userEmail)
        .where('status',isEqualTo: 'Pending')
        .orderBy('date_time',descending: true)
        .get().then((value) async{
          String otp=(100000 + random.nextInt(900000)).toString();
          _db.collection('Orders').doc(value.docs[0].id).update({'status':'Running','accept_time':FieldValue.serverTimestamp(),'otp':otp}).whenComplete(() {
            orderConfirmingNotifier(order);
            getHistory();
            getActiveOrders();
            EasyLoading.dismiss();
            EasyLoading.showToast('Accepted✅',toastPosition: EasyLoadingToastPosition.bottom);
          });
    });
  }
  Future orderCancel(orderModel order)async{
    EasyLoading.show(
      status: 'Cancelling Order...',
      dismissOnTap: false,
    );
    await _db.collection('Orders')
        .where('provider',isEqualTo: order.providerEmail)
        .where('user',isEqualTo: order.userEmail)
        .where('status',isEqualTo: 'Pending')
        .orderBy('date_time',descending: true)
        .get().then((value) async{
      _db.collection('Orders').doc(value.docs[0].id).update({'status':'Cancelled'}).whenComplete(() {
        orderCancellationNotifier(order);
        getHistory();
        EasyLoading.dismiss();
        EasyLoading.showToast('Cancelled❌',toastPosition: EasyLoadingToastPosition.bottom);
      });
    });
  }


  Future orderPlacingNotifier(orderModel order,providerModel provider) async{
    Uri url=Uri.parse('https://fcm.googleapis.com/fcm/send');
    var notificationMsg={
      'to': provider.deviceToken,
      'priority':'high',
      'notification': {
        'title':'Hello ${provider.name}',
        'body':'You got a new order on our app.',
      }
    };
    await http.post(
      url,
      body: jsonEncode(notificationMsg),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=AAAA9SpLlhs:APA91bGX9Ny4IwWVlyDZs-rwVKBHcnUb95JY53VakLaV25xj7IBuYDcP5ff7dWRt5fBu62HsPsChroNUn249UguX_6esuZkjgFFRuh8eM89jt4Uu71hEt-fxlz6RTU9OFF-ZgyoQ8hYm',
      },
    );
  }

  Future orderConfirmingNotifier(orderModel order) async{
    Uri url=Uri.parse('https://fcm.googleapis.com/fcm/send');
    await _db.collection('Users').doc(order.userEmail).get().then((value) async{
      var notificationMsg={
        'to': value.data()!['token'],
        'priority':'high',
        'notification': {
          'title':'Hello ${value.data()!['name']}',
          'body':'You order for ${order.orderType} just got accepted.',
        }
      };
      await http.post(
        url,
        body: jsonEncode(notificationMsg),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAA9SpLlhs:APA91bGX9Ny4IwWVlyDZs-rwVKBHcnUb95JY53VakLaV25xj7IBuYDcP5ff7dWRt5fBu62HsPsChroNUn249UguX_6esuZkjgFFRuh8eM89jt4Uu71hEt-fxlz6RTU9OFF-ZgyoQ8hYm',
        },
      );
    });
  }

  Future orderCancellationNotifier(orderModel order) async{
    Uri url=Uri.parse('https://fcm.googleapis.com/fcm/send');
    await _db.collection('Users').doc(order.userEmail).get().then((value) async{
      var notificationMsg={
        'to': value.data()!['token'],
        'priority':'high',
        'notification': {
          'title':'Sorry ${value.data()!['name']}',
          'body':"You order for ${order.orderType} can't be accepted.Try for another provider",
        }
      };
      await http.post(
        url,
        body: jsonEncode(notificationMsg),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=AAAA9SpLlhs:APA91bGX9Ny4IwWVlyDZs-rwVKBHcnUb95JY53VakLaV25xj7IBuYDcP5ff7dWRt5fBu62HsPsChroNUn249UguX_6esuZkjgFFRuh8eM89jt4Uu71hEt-fxlz6RTU9OFF-ZgyoQ8hYm',
        },
      );
    });
  }

  bool visibility=true;
  bool progressVisibility=true;
  String selectedProviderOrderStatus='';
  Future<void> bookButtonVisibility() async {
    print('invoked');
    await FirebaseFirestore.instance.collection('Orders').where('user' ,isEqualTo: controllerU.currUserModel.email ).where('provider',isEqualTo: controller.providers[controller.selectedServiceProvider].email).get().then((value) {
      bool willBreak=false;
      if(value.docs.length!=0){
        value.docs.forEach((element) {
          if (!willBreak) {
            if ((element['status'] == 'Pending' ||
                element['status'] == 'Running')) {
              selectedProviderOrderStatus = element['status'];
              visibility = false;
              print('booked2');
              willBreak = true;
            } else {
              visibility = true;
              print('not booked');
            }
          }
        });
      }else{
        visibility = true;
        print('not booked');
      }
      update();
    });
  }
}
