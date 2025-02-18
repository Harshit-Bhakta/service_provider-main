import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_provider/Controllers/UserController.dart';
import 'package:service_provider/Controllers/providersController.dart';
import 'package:service_provider/Pages/editProfile.dart';
import 'package:service_provider/Pages/launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TextEditingController _supportTEController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  var profileModel;
  bool inProgress=false;
  bool messageSent=false;
  @override
  void initState() {
    super.initState();
    inProgress=false;
    if(loginType==true){
      profileModel=Get.find<UserController>().currUserModel;
    }else{
      profileModel=Get.find<ProvidersController>().currProviderModel;
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.black87,),
          onPressed: (){
            Get.back();
          },
        ),
        centerTitle: true,
        title: Text(
          'Contact Us',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xff4c505b),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset('assets/contact.jpg'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 5,),
                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        Uri url=Uri.parse('tel:01600000000');
                        if(await canLaunchUrl(url)){
                          await launchUrl(url);
                        }else{

                        }
                      },
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).width*0.25,
                        width: MediaQuery.sizeOf(context).width*0.25,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          elevation: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.amberAccent.shade100,
                                child: Icon(
                                    Icons.call,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "Call Us",
                                style: TextStyle(
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        String url='mailto:anujitbestbd@gmail.com?subject=Service Provider Support';
                        if(await canLaunchUrlString(url)){
                          await launchUrlString(url);
                        }else{
                          await launchUrlString(url);
                        }
                      },
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).width*0.25,
                        width: MediaQuery.sizeOf(context).width*0.25,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          elevation: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.amberAccent.shade100,
                                child: Icon(
                                    Icons.alternate_email,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ) ,

                  Expanded(
                    child: InkWell(
                      onTap: ()async{
                        Uri url=Uri.parse('https://wa.me/+8801641503013');
                        await launchUrl(url);
                      },
                      child: SizedBox(
                        height: MediaQuery.sizeOf(context).width*0.25,
                        width: MediaQuery.sizeOf(context).width*0.25,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                          elevation: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.amberAccent.shade100,
                                child: Icon(
                                    Icons.chat,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "Message",
                                style: TextStyle(
                                  color: Colors.amber.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                ],
              ),
              SizedBox(height: 30,),
              Text(
                'Support Chat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _supportTEController,
                  decoration: InputDecoration(
                    fillColor: Colors.amberAccent.shade100,
                  ),
                  maxLines: 5,
                  validator: (value){
                    if(value==null || value==''){
                      return 'Enter your meassage';
                    }else return null;
                  },
                ),
              ),
              SizedBox(height: 5,),
              MaterialButton(
                onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      inProgress=true;
                    });
                    await FirebaseFirestore.instance.collection('Support').doc('${profileModel.email}_${DateTime.now().toString()}').set({'timestamp':FieldValue.serverTimestamp(),'message':_supportTEController.text}).onError((error, stackTrace) {
                      print(error.toString());
                    }).whenComplete(() {
                      setState(() {
                        _supportTEController.text='';
                        inProgress=false;
                        messageSent=true;
                      });
                    });
                  }
                },
                child: Visibility(
                  visible: !inProgress,
                  replacement: SizedBox(child: CircularProgressIndicator(color: Colors.amber.shade900,),height: 20,width: 20,),
                  child: Visibility(
                    visible: !messageSent,
                    replacement: Icon(
                      Icons.done_all_sharp,
                      color: Colors.amber.shade900,
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                color: Colors.amberAccent.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _supportTEController.dispose();
    super.dispose();
  }
}
