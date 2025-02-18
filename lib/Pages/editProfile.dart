
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider/Controllers/UserController.dart';
import 'package:service_provider/Controllers/providersController.dart';
import 'package:service_provider/Pages/launcher.dart';
var profileModel;
String editedName='';
String editedPhone='';
String editedAddress='';
XFile? _imageFile;

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserController controllerU=Get.find<UserController>();
  ProvidersController controller=Get.find<ProvidersController>();

  @override
  void initState() {
    super.initState();
    profileModel=Get.arguments;
    editedAddress=profileModel.address;
    editedName=profileModel.name;
    editedPhone=profileModel.phone;
  }

  @override
  Widget build(BuildContext context) {
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
          "Profile",
          style: TextStyle(
            fontSize: 35,
            color: Color(0xff4c505b),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: ()async{
                try{
                  if (_imageFile != null) {
                    EasyLoading.show(status: 'Saving.');
                    if (profileModel.image != '') {
                      final deleteRef = await FirebaseStorage.instance
                          .refFromURL(profileModel.image);
                      deleteRef.delete();
                    }
                    String imageName =
                        profileModel.email + basename(_imageFile!.path);
                    final ref = await FirebaseStorage.instance.ref();
                    final replacementRef = await ref.child(imageName);
                    try {
                      await replacementRef.putFile(File(_imageFile!.path),
                          SettableMetadata(contentType: 'image/jpeg'));
                    } on FirebaseException catch (e) {
                      EasyLoading.showToast(e.toString(),toastPosition: EasyLoadingToastPosition.bottom);
                    }
                    await replacementRef.getDownloadURL().then((value) async {
                      if (loginType == true) {
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(profileModel.email)
                            .update({
                          'image': value,
                          'name': editedName,
                          'phone': editedPhone,
                          'address': editedAddress
                        }).then((value) {
                          EasyLoading.dismiss();
                          EasyLoading.showToast('Update Success',toastPosition: EasyLoadingToastPosition.bottom);
                          Get.back();
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection(controller.currProviderType)
                            .doc(profileModel.email)
                            .update({
                          'image': value,
                          'name': editedName,
                          'phone': editedPhone,
                          'address': editedAddress
                        }).then((value) {
                          EasyLoading.dismiss();
                          EasyLoading.showToast('Update Success',toastPosition: EasyLoadingToastPosition.bottom);
                          Get.back();
                        });
                      }
                    });
                  } else {
                    EasyLoading.show(status: 'Saving.');
                    if (loginType == true) {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(profileModel.email)
                          .update({
                        'name': editedName,
                        'phone': editedPhone,
                        'address': editedAddress
                      }).then((value) {
                        EasyLoading.dismiss();
                        EasyLoading.showToast('Update Success',toastPosition: EasyLoadingToastPosition.bottom);
                        Get.back();
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection(controller.currProviderType)
                          .doc(profileModel.email)
                          .update({
                        'name': editedName,
                        'phone': editedPhone,
                        'address': editedAddress
                      }).then((value) {
                        EasyLoading.dismiss();
                        EasyLoading.showToast('Update Success',toastPosition: EasyLoadingToastPosition.bottom);
                        Get.back();
                      });
                    }
                  }
                  if (loginType == true) {
                    controllerU.getCurrUserModel();
                  } else {
                    controller.getCurrProviderModel();
                  }
                }catch(exception){
                  EasyLoading.showToast(exception.toString(),toastPosition: EasyLoadingToastPosition.bottom);
                }
              },
              icon: Icon(Icons.save,size: 30,)
          )
        ],
      ),
      body: EditProfileBody(uController: controllerU,pController: controller,),
    );
  }
}

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({
    super.key,
    required this.uController,
    required this.pController,
  });

  final UserController uController;
  final ProvidersController pController;

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  String profileAvater='https://firebasestorage.googleapis.com/v0/b/service-provider-2798f.appspot.com/o/user-male-circle.png?alt=media&token=f95cd854-6136-4118-94cd-4abfb3f48656';
  final TextEditingController _nameTEcontroller=TextEditingController();
  final TextEditingController _addressTEcontroller=TextEditingController();
  final TextEditingController _phoneTEcontroller=TextEditingController();
  final TextEditingController _emailTEcontroller=TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameTEcontroller.text=profileModel.name;
    _phoneTEcontroller.text=profileModel.phone;
    _addressTEcontroller.text=profileModel.address;
    _emailTEcontroller.text=profileModel.email;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: GetBuilder<UserController>(
                builder: (uController){
                  return GetBuilder<ProvidersController>(
                      builder: (pController) {
                        return ListView(
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.35,
                              child: CircleAvatar(
                                backgroundColor: Colors.lightBlueAccent,
                                radius: MediaQuery.of(context).size.width * 0.35,
                                child: Center(child: CircularProgressIndicator(),),
                                foregroundImage: _imageProvider(),
                                //backgroundImage: ,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: InkWell(
                                onTap: (){
                                  pickImageGallery().then((value) {
                                    uploadToStorage();
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.lightBlueAccent.shade100
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.black54
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Upload Photo',
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Expanded(child: Text(_imageFile!=null?basename(_imageFile!.path):'',softWrap: true,)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                height: 50,
                                width: 250,
                                child: TextFormField(
                                  onChanged: (changedValue){
                                    editedName=changedValue;
                                  },
                                  controller: _nameTEcontroller,
                                  style: TextStyle(color: Color(0xff4c505b)),
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    labelText: 'Name',
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 80),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 250,
                                      child: TextFormField(
                                        onChanged: (changedValue){
                                          editedAddress=changedValue;
                                        },
                                        controller: _addressTEcontroller,
                                        style: TextStyle(color: Color(0xff4c505b)),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.edit_location_alt),
                                          labelText: 'Address',
                                          alignLabelWithHint: true,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: 250,
                                      child: TextFormField(
                                        onChanged: (changedValue){
                                          editedPhone=changedValue;
                                        },
                                        controller: _phoneTEcontroller,
                                        style: TextStyle(color: Color(0xff4c505b)),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.settings_phone_sharp),
                                          labelText: 'Phone',
                                          alignLabelWithHint: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                  );
                },)
          ),
        ],
      ),
    );
  }

  Future pickImageGallery()async {
    print('invoke');
    final image=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image!=null){
      setState(() {
        _imageFile=image;
      });
    }
  }

  Future uploadToStorage()async{

  }


  ImageProvider _imageProvider() {
    if (_imageFile!=null) {
      String filePath = _imageFile!.path; // Replace with your file path
      if (File(filePath).existsSync()) {
        return FileImage(File(filePath));
      }
    }else if(profileModel.image!=''){
      return NetworkImage(
        profileModel.image,
      );
    }
    return NetworkImage(profileAvater);
  }

  @override
  void dispose() {
    _addressTEcontroller.dispose();
    _emailTEcontroller.dispose();
    _nameTEcontroller.dispose();
    _phoneTEcontroller.dispose();
    super.dispose();
  }
}

