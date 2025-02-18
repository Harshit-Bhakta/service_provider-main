import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_provider/Controllers/OrderController.dart';
import 'package:service_provider/Pages/orderInfo.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({super.key});

  @override
  State<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Active Orders'),),
      body: ActiveOrdersBody(),
    );
  }
}

class ActiveOrdersBody extends StatefulWidget {
  const ActiveOrdersBody({super.key});

  @override
  State<ActiveOrdersBody> createState() => _ActiveOrdersBodyState();
}

class _ActiveOrdersBodyState extends State<ActiveOrdersBody> {
  final OrderController controllerO=Get.find<OrderController>();
  @override
  void initState() {
    super.initState();
    controllerO.getActiveOrders();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        controllerO.getActiveOrders();
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GetBuilder<OrderController>(
          builder: (oController) {
            return Visibility(
              visible: oController.activeOrders.length>0,
              replacement: Center(
                child: Text(
                  'No active orders',
                ),
              ),
              child: ListView.builder(
                itemCount: oController.activeOrders.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: GestureDetector(
                      onTap: ()async{
                        EasyLoading.show(status: 'please wait');
                        await oController.getOrderInfo(oController.activeOrders[index]).whenComplete(() {
                          EasyLoading.dismiss();
                          Get.to(()=>OrderInfo(),arguments: oController.activeOrders[index]);
                        });
                      },

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ListTile(
                          //isThreeLine: true,
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.work_history_outlined),
                            ],
                          ),
                          title: Text(oController.activeOrders[index].orderSubType),
                          subtitle: Text(
                              '${oController.activeOrders[index].orderLocation}\n${DateFormat.yMd().format(oController.activeOrders[index].orderDateTime)}\n${DateFormat.jms().format(oController.activeOrders[index].orderDateTime)}'
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }
}