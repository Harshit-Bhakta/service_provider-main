import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_provider/Controllers/providersController.dart';
import 'package:service_provider/Pages/selectedServiceInfo.dart';
import 'package:service_provider/Pages/userHome.dart';
import 'package:service_provider/Models/providerModel.dart';
List<providerModel> Providers=[];
bool isLoaded = false;
int itemsAmount=0;


class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  void initState() {
    Get.find<ProvidersController>().providersInfoGetter().then((value) {
      Providers=[];
      Providers=Get.find<ProvidersController>().providers;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff4c505b),
            size: 30,
          ),
          onPressed: (){isLoaded=false;Get.back();},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 1,
            ),
            Text(
              services[controller.currService == -1 ? 0 : controller.currService] + 's',
              style: TextStyle(
                fontSize: 35,
                color: Color(0xff4c505b),
              ),
            ),
            SizedBox(
              width: 50,
              child: IconButton(
                onPressed: () {},
                color: Color(0xff4c505b),
                icon: Icon(
                  Icons.edit_location_alt,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<ProvidersController>(builder: (pController){
        return isLoaded == true
            ? Providers.length>0? _body(context)
            : _noDataFound(pController)
            : _loading();
      },),
    );
  }

   _body(BuildContext context){
    EasyLoading.dismiss();
    return ListView.builder(
      itemCount: itemsAmount,
      itemBuilder: (BuildContext, int index) {
        return GestureDetector(
          onTap: (){
            Get.find<ProvidersController>().selectedSetter(index);
            Get.to(()=>selectedServiceInfo());
            print(Providers[index].name);
          },
          child: Container(
            height: 150,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(65),
              ),
              elevation: 7,
              margin: EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      child: CircularProgressIndicator(),
                      foregroundImage: NetworkImage(
                        Providers[index].image==''?'https://firebasestorage.googleapis.com/v0/b/service-provider-2798f.appspot.com/o/user-male-circle.png?alt=media&token=f95cd854-6136-4118-94cd-4abfb3f48656':Providers[index].image,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: MediaQuery.of(context).orientation==Orientation.portrait?2:5,
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 5,bottom: 6,top: 10),
                        child: Text(
                          Providers[index].name,
                          style: TextStyle(
                            color: Colors.lightBlueAccent.shade700,
                            fontSize: 23,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              Text(
                                Providers[index].address,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.label_important_outlined,
                                size: 20,
                              ),
                              Text(
                                Providers[index].type,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),

                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },);
  }

  Widget _noDataFound(ProvidersController controller){
    EasyLoading.dismiss();
    return Center(
      child: Text(
        "No " +services[controller.currService]+ " found nearby",
        style: TextStyle(
            fontSize: 20
        ),
      ),
    );
  }

  Widget _loading(){
    return Center(child: CircularProgressIndicator());
  }
}
