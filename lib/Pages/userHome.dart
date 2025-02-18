import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:service_provider/Controllers/UserController.dart';
import 'package:service_provider/Controllers/providersController.dart';
import 'package:service_provider/Pages/About.dart';
import 'package:service_provider/Pages/History.dart';
import 'package:service_provider/Pages/activeOrders.dart';
import 'package:service_provider/Pages/profile.dart';
import 'package:service_provider/Pages/services.dart';
import 'package:service_provider/Models/userModel.dart';
import 'package:get/get.dart';
import '../Controllers/OrderController.dart';
import 'Contact.dart';
import 'launcher.dart';

List<String> services = ['Electrician', 'Plumber', 'Cleaner', 'Painter', 'ISP'];
List servicesImage = [
  'assets/electrician.png',
  'assets/plumber.png',
  'assets/cleaner.png',
  'assets/painter.png',
  'assets/ISP.png'
];

List<Widget> pages=[
  ActiveOrdersBody(),
  userHomeBody(controller: Get.find<ProvidersController>()),
  HistoryBody(monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],),
];
List pagesName=['Active','Services','History'];


class userHomePage extends StatefulWidget {
  const userHomePage({super.key});

  @override
  State<userHomePage> createState() => _userHomePageState();
}

class _userHomePageState extends State<userHomePage> {
  @override
  void initState() {
    Get.find<UserController>().getCurrUserModel();
    Get.find<OrderController>().historyProgressVisibilitySetter(true);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    UserController controllerU = Get.find<UserController>();
    ProvidersController controller = Get.find<ProvidersController>();
    final _auth = FirebaseAuth.instance;
    // controllerU.getCurrUserModel();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 1,
            ),
            Text(
              pagesName[controllerU.bottomNevBarItemSelected],
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff4c505b),
              ),
            ),
            SizedBox(
              width: 50,
              child: Icon(
                Icons.add,
                color: Colors.transparent,
              ),
            )
          ],
        ),
      ),
      body: pages[controllerU.bottomNevBarItemSelected],

      drawer: SideNavigationDrawer(controllerU: controllerU, controller: controller, auth: _auth),

      bottomNavigationBar: GetBuilder<UserController>(builder: (_) {
      return BottomNavigationBar(
        onTap: (index) {
          controllerU.bottomNevBarItemSetter(index);
          setState(() {});
        },
        currentIndex: controllerU.bottomNevBarItemSelected,

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

class SideNavigationDrawer extends StatefulWidget {
  const SideNavigationDrawer({
    super.key,
    required this.controllerU,
    required this.controller,
    required FirebaseAuth auth,
  }) : _auth = auth;

  final UserController controllerU;
  final ProvidersController controller;
  final FirebaseAuth _auth;

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  @override
  void initState() {
    loginType?Get.find<UserController>().getCurrUserModel():Get.find<ProvidersController>().getCurrProviderModel();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      backgroundColor: Colors.grey.shade200,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightBlueAccent.shade200,
          ),
          padding:
          EdgeInsets.only(top: MediaQuery
              .of(context)
              .padding
              .top),
          height: MediaQuery
              .of(context)
              .orientation == Orientation.portrait ? MediaQuery
              .of(context)
              .size
              .height * 0.30 : MediaQuery
              .of(context)
              .size
              .width * 0.30,
          child: GetBuilder<UserController>(builder: (_){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.transparent,
                  child: CircularProgressIndicator(),
                  foregroundImage: NetworkImage(loginType==true?widget.controllerU.currUserModel.image == ''
                      ? 'https://firebasestorage.googleapis.com/v0/b/service-provider-2798f.appspot.com/o/user-male-circle.png?alt=media&token=f95cd854-6136-4118-94cd-4abfb3f48656'
                      : widget.controllerU.currUserModel.image
                  :widget.controller.currProviderModel.image == ''
                      ? 'https://firebasestorage.googleapis.com/v0/b/service-provider-2798f.appspot.com/o/user-male-circle.png?alt=media&token=f95cd854-6136-4118-94cd-4abfb3f48656'
                      : widget.controller.currProviderModel.image),
                ),
                Text(
                  loginType==true?widget.controllerU.currUserModel.name:widget.controller.currProviderModel.name,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            );
          },),
        ),
        ListTile(
          contentPadding: EdgeInsets.only(
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.08,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.02,
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005),
          minLeadingWidth: 5,
          leading: Icon(Icons.home),
          title: Text(
            'Home',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Get.to(() => userHomePage());
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.08,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005,
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005),
          minLeadingWidth: 5,
          leading: Icon(Icons.person),
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Get.to(() => Profile());
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.08,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005,
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005),
          minLeadingWidth: 5,
          leading: Icon(Icons.history),
          title: Text(
            'History',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Get.to(()=>History());
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.08,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005,
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005),
          minLeadingWidth: 5,
          leading: Icon(Icons.info_outline),
          title: Text(
            'About Us',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Get.to(()=>About());
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.08,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005,
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.005),
          minLeadingWidth: 5,
          leading: Icon(Icons.contact_mail_outlined),
          title: Text(
            'Contact Us',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            Get.to(()=>Contact());
          },
        ),
        GetBuilder<UserController>(builder: (_) {
          return GetBuilder<ProvidersController>(builder: (_) {
            return ListTile(
              contentPadding: EdgeInsets.only(
                  left: MediaQuery
                      .of(context)
                      .size
                      .width * 0.08,
                  top: MediaQuery
                      .of(context)
                      .size
                      .height * 0.005,
                  bottom: MediaQuery
                      .of(context)
                      .size
                      .height * 0.005),
              minLeadingWidth: 5,
              leading: Icon(Icons.logout_outlined),
              title: Text(
                'Sign out',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                widget.controllerU.currUserModel = userModel(phone: '', email: '', address: '',name: '',image: '');
                widget.controller.currServiceSetter(-1);
                widget.controllerU.currUserDoc = '';
                widget._auth.signOut();
                Get.to(() => launcherPage());
              },
            );
          },);
        },),
        SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.1,
        ),
      ],
    );
  }
}

class userHomeBody extends StatelessWidget {
  const userHomeBody({
    super.key,
    required this.controller,
  });

  final ProvidersController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03,
            ),
            Expanded(
              child: GetBuilder<ProvidersController>(builder: (_) {
                return GridView.builder(
                    gridDelegate: MediaQuery
                        .of(context)
                        .orientation == Orientation.portrait
                        ? SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery
                          .of(context)
                          .size
                          .width * 0.41,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    )
                        : SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery
                          .of(context)
                          .size
                          .width * 0.25,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: services.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          EasyLoading.dismiss();
                          controller.currService=index;
                          Get.to(() => Services());
                        },
                        child: Container(
                          padding: EdgeInsets.all(1.0),
                          decoration: BoxDecoration(
                            color: controller.currService == index
                                ? Colors.blueGrey
                                : Colors.lightBlueAccent.shade100,
                            border: Border.all(
                              color: controller.currService == index
                                  ? Colors.blueGrey
                                  : Colors.blueGrey.withOpacity(0),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(servicesImage[index]),
                                SizedBox(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.015,
                                ),
                                Text(
                                  services[index],
                                  style: TextStyle(fontSize: 25),
                                )
                              ]),
                        ),
                      );
                    });
              },),
            ),
          ]),
    );
  }
}
