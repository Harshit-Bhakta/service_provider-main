import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_provider/Controllers/OrderController.dart';
import 'package:service_provider/Pages/activeOrders.dart';
import 'package:service_provider/Pages/userHome.dart';
import '../Controllers/UserController.dart';
import '../Controllers/providersController.dart';
import 'History.dart';

List<Widget> pages=[
  ActiveOrdersBody(),
  ProviderHomeBody(controller: Get.find<ProvidersController>()),
  HistoryBody(monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],),];

class ProviderHomePage extends StatefulWidget {
  const ProviderHomePage({super.key});

  @override
  State<ProviderHomePage> createState() => _ProviderHomePageState();
}

class _ProviderHomePageState extends State<ProviderHomePage> {
  final _auth = FirebaseAuth.instance;
  List pagesName = ['Active Orders', 'Job Requests', 'History'];
  ProvidersController controller = Get.find<ProvidersController>();

  @override
  void initState() {
    controller.getCurrProviderModel();
    Get.find<OrderController>().getHistory();
    Get.find<OrderController>().getActiveOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: Color(0xff4c505b),
              size: 40,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Text(
          pagesName[controller.bottomNevBarItemSelected],
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff4c505b),
          ),
        ),
      ),
      body: pages[controller.bottomNevBarItemSelected],
      drawer: SideNavigationDrawer(controllerU: Get.find<UserController>(), controller: controller, auth: _auth),
      bottomNavigationBar: GetBuilder<ProvidersController>(builder: (_) {
        return BottomNavigationBar(
            onTap: (index) {
              controller.bottomNevBarItemSetter(index);
              pages[index];
              setState(() {});
            },
            currentIndex: controller.bottomNevBarItemSelected,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.work_history_outlined),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.checklist_rtl_sharp),
                label: 'History',
              ),
            ]);
      }),
    );
  }
}

class ProviderHomeBody extends StatelessWidget {
  const ProviderHomeBody({
    super.key, required ProvidersController controller,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        Get.find<OrderController>().getHistory();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03,
            ),
            Expanded(
              child: GetBuilder<OrderController>(
                builder: (oController) {
                  return Visibility(
                    visible: oController.requestedOrders.length>0,
                    replacement: Center(child: Text('No bookings available!'),),
                    child: ListView.builder(
                      itemCount: oController.requestedOrders.length,
                      itemBuilder: (context,index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
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
                              title: Text(oController.requestedOrders[index].orderSubType),
                              subtitle: Text(
                                  '${oController.requestedOrders[index].orderLocation}\n${DateFormat.yMMMMEEEEd().format(oController.requestedOrders[index].orderDateTime)}\n${DateFormat.jms().format(oController.requestedOrders[index].orderDateTime)}'
                              ),
                              trailing: Visibility(
                                visible: oController.requestedOrders[index].orderStatus=='Pending',
                                replacement: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: getStatusColor(oController.requestedOrders[index].orderStatus),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                                      child: Text(
                                        oController.requestedOrders[index].orderStatus,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.sizeOf(context).width*0.35,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: (){
                                              oController.orderCancel(oController.requestedOrders[index]);
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                              size: 35,
                                            )
                                          ),
                                          IconButton(
                                              onPressed: (){
                                                oController.orderAccept(oController.requestedOrders[index]);
                                              },
                                              icon: Icon(
                                                Icons.check,
                                                color: Colors.green.shade400,
                                                size: 35,
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
  getStatusColor(String status) {
    if(status=='Done'){
      return Colors.greenAccent[100];
    }else if(status=='Running'){
      return Colors.yellow[100];
    }else if(status=='Cancelled'){
      return Colors.red[200];
    }else{
      return Colors.grey[300];
    }
  }
}
