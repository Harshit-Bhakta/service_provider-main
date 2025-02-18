import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:service_provider/Controllers/OrderController.dart';
import 'package:service_provider/Controllers/UserController.dart';
import 'package:service_provider/Controllers/providersController.dart';
import 'package:service_provider/Models/orderModel.dart';
import 'package:service_provider/Models/providerModel.dart';
import 'package:service_provider/Pages/services.dart';
import 'package:service_provider/Widgets/statusColoredContainer.dart';
ProvidersController controller = Get.find<ProvidersController>();
UserController controllerU= Get.find<UserController>();



class selectedServiceInfo extends StatefulWidget {
  const selectedServiceInfo({super.key});

  @override
  State<selectedServiceInfo> createState() => _selectedServiceInfoState();
}

class _selectedServiceInfoState extends State<selectedServiceInfo> {
  bool progressVisibility=true;
  @override
  void initState() {
    progressVisibility=true;
    progressVisibilityPause();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          color: Color(0xff4c505b),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Provider's Info",
          style: TextStyle(
            fontSize: 35,
            color: Color(0xff4c505b),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 8,
              //height: MediaQuery.of(context).size.height * 0.85,
              child: GetBuilder<ProvidersController>(
                builder: (_) {
                  return ListView(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.36,
                        foregroundColor: Colors.lightBlueAccent,
                        backgroundColor: Colors.lightBlueAccent,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.35,
                          backgroundColor: Colors.lightBlueAccent,
                          foregroundImage: NetworkImage(
                            Providers[controller.selectedServiceProvider]
                                        .image ==
                                    ''
                                ? 'https://firebasestorage.googleapis.com/v0/b/service-provider-2798f.appspot.com/o/user-male-circle.png?alt=media&token=f95cd854-6136-4118-94cd-4abfb3f48656'
                                : Providers[controller.selectedServiceProvider]
                                    .image,
                          ),
                          //backgroundImage: ,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          controller
                              .providers[controller.selectedServiceProvider]
                              .name,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 80),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Container(
                                    child: Icon(
                                  Icons.label_important_outlined,
                                  color: Colors.grey,
                                )),
                                horizontalTitleGap: 5,
                                minLeadingWidth: 20,
                                title: Text(
                                  'Expertise: ${
                                    controller
                                        .providers[
                                            controller.selectedServiceProvider]
                                        .subTypes
                                        .toString()
                                  }',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                dense: true,
                                onTap: () {},
                              ),
                              ListTile(
                                leading: Container(
                                    child: Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                )),
                                horizontalTitleGap: 5,
                                minLeadingWidth: 20,
                                title: Text(
                                  controller
                                      .providers[
                                          controller.selectedServiceProvider]
                                      .address,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                dense: true,
                              ),
                              ListTile(
                                leading: Container(
                                    child: Icon(
                                  Icons.work_history,
                                  color: Colors.grey,
                                )),
                                horizontalTitleGap: 5,
                                minLeadingWidth: 20,
                                title: Text(
                                  controller
                                          .providers[controller
                                              .selectedServiceProvider]
                                          .score
                                          .toString() +
                                      ' Serves',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                dense: true,
                              ),
                              ListTile(
                                leading: Container(
                                    child: Icon(
                                  Icons.attach_money,
                                  color: Colors.grey,
                                )),
                                horizontalTitleGap: 5,
                                minLeadingWidth: 20,
                                title: Text(
                                  '4.3 Rated',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                dense: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )),
          GetBuilder<OrderController>(
            builder: (oController) {
              return Expanded(
                flex: 2,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: !progressVisibility,
                        replacement: CircularProgressIndicator(),
                        child: Visibility(
                          visible: oController.visibility,
                          replacement: Column(
                            children: [
                              Text(
                                'Booked',
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Status: ',style: TextStyle(fontSize: 20),),
                                  StatusColoredContainer(status: oController.selectedProviderOrderStatus),
                                ],
                              )
                            ],
                          ),
                          child: MaterialButton(
                            onPressed: () async{
                              progressVisibility=true;
                              setState(() {});
                              await showSimplePickerLocation(
                                context: context,
                                isDismissible: true,
                                title: 'Pick booking location',
                                textConfirmPicker: 'Pick',
                                textCancelPicker: 'Cancel',
                                initPosition: GeoPoint(latitude: 23.597228, longitude: 89.854139),
                                zoomOption: ZoomOption(initZoom: 15),
                              ).onError((error, stackTrace) {
                                EasyLoading.showToast(error.toString());
                                return null;
                              }).then((value) {
                                showOrderConfirmDialog(context,value!);
                              });

                            },
                            color: Colors.lightBlueAccent,
                            child: Text(
                              '  Book  ',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  void createOrder(GeoPoint geopoint) async{
    providerModel selectedProvider=controller.providers[controller.selectedServiceProvider];
    OrderController oController=Get.find<OrderController>();
    orderModel order = orderModel(
        userEmail: controllerU.currUserModel.email,
        providerEmail: selectedProvider.email,
        orderLocation: controllerU.currUserModel.address,
        orderGeopoint: cf.GeoPoint(geopoint.latitude,geopoint.longitude),
        orderStatus: 'Pending',
        orderDateTime: DateTime.now(),
        orderType: selectedProvider.type,
        orderSubType: selectedProvider.subTypes[0]==''?selectedProvider.type:selectedProvider.subTypes[0],
        otp: '');
    await oController.postOrder(order).whenComplete(() async{
      await oController.bookButtonVisibility();
      await oController.orderPlacingNotifier(order,selectedProvider);
    });

  }

  Future<void> progressVisibilityPause()async{
    await Get.find<OrderController>().bookButtonVisibility().whenComplete((){
      progressVisibility=false;
      setState(() {});
    });
  }

  void showOrderConfirmDialog(BuildContext context,GeoPoint geopoint){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('Confirm Order?'),
            content: Text('Once the service provider accepts the order an OTP will be shown to you.'),
            actions: [
              MaterialButton(
                onPressed: (){
                  Navigator.pop(context);
                  progressVisibility=false;
                  setState(() {});
                },
                child: Text('Cancel'),
                color: Colors.red.shade200,
              ),
              MaterialButton(
                onPressed: (){
                  createOrder(geopoint);
                  progressVisibility=false;
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text('Confirm'),
                color: Colors.green.shade200,
              ),
            ],
            actionsAlignment: MainAxisAlignment.spaceAround,
            alignment: Alignment.center,
          );
        });
  }
}
