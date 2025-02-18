import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_provider/Controllers/OrderController.dart';
import 'package:service_provider/Models/orderModel.dart';
import 'package:service_provider/Pages/launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderInfo extends StatefulWidget {
  const OrderInfo({super.key});

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  late orderModel order;
  int currStep=2;
  bool startStepVisible=true;
  bool completeStepVisible=false;
  final _db=FirebaseFirestore.instance;
  @override
  void initState() {
    order=Get.arguments;
    Get.find<OrderController>().getOrderInfo(order);
    if(loginType==false){
      currStep=3;
      startStepVisible=false;
      completeStepVisible=true;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<Step> orderSteps=[
      Step(
        title: Text('User placed order'),
        content: Text(''),
        state: StepState.disabled,
        isActive: false,
        subtitle: Text('${DateFormat.yMd().format(order.orderDateTime)}     ${DateFormat.jms().format(order.orderDateTime)}')
      ),
      Step(
          title: Text('Provider accepted order'),
          content: Text(''),
          state: StepState.disabled,
          isActive: false,
          subtitle: Text('${DateFormat.yMd().format(order.acceptingDateTime!)}     ${DateFormat.jms().format(order.acceptingDateTime!)}')
      ),
      Step(
          title: Text('Start order'),
          content: Row(
            children: [
              Icon(Icons.warning,color: Colors.yellow[700],),
              Text('Continue only after verifying OTP'),
            ],
          ),
          state: (startStepVisible)?StepState.editing:StepState.disabled,
          isActive: (startStepVisible),
          subtitle: Text(order.startingDateTime!=null?'${DateFormat.yMd().format(order.startingDateTime!)}     ${DateFormat.jms().format(order.startingDateTime!)}':'Not started yet')
      ),
      Step(
          title: Text('End Order'),
          content: Row(
            children: [
              Icon(Icons.warning,color: Colors.yellow[700],),
              Text('Continue only after completing order'),
            ],
          ),
          state: (completeStepVisible)?StepState.editing:StepState.disabled,
          isActive: (completeStepVisible),
          subtitle: Text('${DateFormat.yMd().format(order.orderDateTime)}     ${DateFormat.jms().format(order.orderDateTime)}')
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Color(0xff4c505b),
          onPressed: (){
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Order Information",
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff4c505b),
          ),
        ),
      ),
      body: GetBuilder<OrderController>(
        builder: (oController) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent,),),
                                radius: 80,
                                backgroundColor: Colors.transparent,
                                foregroundImage: _imageProvider(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                          Icons.person
                                      ),
                                      Text(loginType==true?oController.orderProvider.name:oController.orderUser.name,style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  Visibility(
                                    visible: loginType,
                                    child: Row(
                                      children: [
                                        Icon(
                                            Icons.construction
                                        ),
                                        Text(order.orderSubType,style: TextStyle(fontSize: 20),),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                          Icons.location_on
                                      ),
                                      Text(loginType==true?oController.orderProvider.address:oController.orderUser.address,style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                          Icons.phone
                                      ),
                                      Text(loginType==true?oController.orderProvider.phone:oController.orderUser.phone,style: TextStyle(fontSize: 20),),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                onPressed: ()async{
                                  Uri url=Uri.parse('tel:${!loginType?oController.orderUser.phone:oController.orderProvider.phone}');
                                  await launchUrl(url);
                                },
                                color: Colors.lightBlueAccent.shade700,
                                child: Row(
                                  children: [
                                    Icon(Icons.call),
                                    Text(
                                      'Call',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10,),
                              Visibility(
                                visible: !loginType,
                                child: MaterialButton(
                                  onPressed: ()async{
                                    Uri url=Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${order.orderGeopoint.latitude},${order.orderGeopoint.longitude}&destination_label=${oController.orderUser.name}' );
                                    await launchUrl(url);
                                  },
                                  color: Colors.lightBlueAccent.shade700,
                                  child: Row(
                                    children: [
                                      Icon(Icons.navigation_rounded),
                                      Text(
                                        'Navigation',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  color: Colors.lightBlue.shade100,
                ),
                SizedBox(height: 20,),
                Text(
                  'OTP: ${order.otp}',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Visibility(
                  visible: loginType,
                  child: SizedBox(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.yellow[700],
                          size: 35,
                        ),
                        Expanded(
                          child: Text(
                            'Don,t let anyone enter your property without confirming the OTP first.',
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.red[200],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: order.orderStatus!='Done',
                  replacement: Center(
                    child: Text(
                      'Order Complete\nFees:${order.fee}',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  child: Stepper(
                    currentStep: currStep,
                    steps: orderSteps,
                    onStepTapped: (int stepNo){
                      setState(() {
                          currStep=stepNo;
                      });
                    },
                    onStepContinue: ()async{
                      EasyLoading.show(status: 'Updating');
                      if(order.orderStatus=='Running' && loginType){
                        await _db
                            .collection('Orders')
                            .where('user',isEqualTo: order.userEmail)
                            .where('provider',isEqualTo: order.providerEmail)
                            .where('status',isEqualTo: 'Running').get().then((value) async{
                          await _db.collection('Orders').doc(value.docs[0].id).update({'status':'Started','start_time':FieldValue.serverTimestamp()}).whenComplete(() {
                            order.orderStatus='Started';
                            order.startingDateTime=DateTime.now();
                            startStepVisible=false;
                            currStep=3;
                            EasyLoading.dismiss();
                            EasyLoading.showToast('Started');
                            setState(() {});
                          });
                        });
                      }else if(order.orderStatus=='Started' && !loginType){
                        await _db
                            .collection('Orders')
                            .where('user',isEqualTo: order.userEmail)
                            .where('provider',isEqualTo: order.providerEmail)
                            .where('status',isEqualTo: 'Started').get().then((value) async{
                          int bonus=oController.orderProvider.score~/10;
                          Duration duration=DateTime.now().difference(order.startingDateTime!);
                          duration.inHours==0?duration=1.hours:duration.inHours;
                          await _db.collection('Orders').doc(value.docs[0].id).update({'status':'Done','fee':(100+(10*bonus))*duration.inHours,'end_time':FieldValue.serverTimestamp()}).whenComplete(() async{
                            await _db.collection(oController.orderProvider.service).doc(oController.orderProvider.email).update({'score': oController.orderProvider.score + 1}).whenComplete(() {
                              oController.orderProvider.score+=1;
                            });
                            order.orderStatus='Done';
                            order.endingDateTime=DateTime.now();
                            order.fee=100+(10*bonus)*duration.inHours;
                            completeStepVisible=false;
                            EasyLoading.dismiss();
                            EasyLoading.showToast('Completed');
                            setState(() {});
                          });
                        });
                      }else if(currStep==3 && loginType){
                        EasyLoading.showToast('Provider will end order. Not you.');
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  ImageProvider _imageProvider() {
    final OrderController oController=Get.find<OrderController>();
    if(loginType==true){
      if(oController.orderProvider.image==''){
        return AssetImage('assets/provider.png');
      }else{
        return NetworkImage(oController.orderProvider.image);
      }
    }else{
      if(oController.orderUser.image==''){
        return AssetImage('assets/user.png');
      }else{
        return NetworkImage(oController.orderUser.image);
      }
    }
  }
}
