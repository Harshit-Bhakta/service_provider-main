import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:service_provider/Controllers/providersController.dart';
import 'package:service_provider/Models/providerModel.dart';
import 'package:service_provider/Pages/launcher.dart';
import 'package:service_provider/Pages/login.dart';
import 'package:service_provider/Pages/provider_home.dart';
import 'package:service_provider/Pages/userHome.dart';
import 'package:service_provider/Models/userModel.dart';
import 'package:service_provider/Services/notification_services.dart';

import '../Controllers/UserController.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _db= FirebaseFirestore.instance;
  final _auth= FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  FocusNode one=FocusNode();
  final _nameController = TextEditingController();
  FocusNode two=FocusNode();
  final _emailController = TextEditingController();
  FocusNode three=FocusNode();
  final _phoneController = TextEditingController();
  FocusNode four=FocusNode();
  final _addressController = TextEditingController();
  FocusNode five=FocusNode();
  final _passwordController = TextEditingController();
  final _subTypeController = TextEditingController();
  bool error=false;
  String errorCode= '';
  bool providerCheckboxChecked=false;
  String providerServiceSelection='Select one';
  String providerTypeSelection='provider';
  List<String> providerSubTypes=[];
  late String deviceToken;

  @override
  void initState() {
    super.initState();
    NotificationServices().getDeviceToken().then((value) {deviceToken=value;});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/register.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              createAccountText(),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            nameField(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015,
                            ),
                            emailField(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015,
                            ),
                            phoneField(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015,
                            ),
                            addressField(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.015,
                            ),
                            passwordField(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.005,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    value: providerCheckboxChecked,
                                    onChanged: (changedBoolValue){
                                      setState(() {
                                        providerCheckboxChecked= changedBoolValue!;
                                      });
                                    },
                                ),
                                Text(
                                  'Register as Service Provider?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: error==false?5:MediaQuery.of(context).size.height * 0.05,
                              child: Text(errorCode,style: TextStyle(fontSize: 17,color: Colors.redAccent),),
                            ),
                            signupButton(),
                            signinAsk(context)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row signinAsk(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        TextButton(
          onPressed: () {
            Get.to(() =>LoginPage());
          },
          child: Text(
            'Sign in',
            style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color(0xff4c505b),
                fontSize: 20),
          ),
          style: ButtonStyle(),
        ),
      ],
    );
  }

  Row signupButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sign Up',
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.w700),
        ),
        CircleAvatar(
          radius: 30,
          backgroundColor: Color(0xff4c505b),
          child: IconButton(
              color: Colors.white,
              onPressed: (){
                if(providerCheckboxChecked){
                  if(_formKey.currentState!.validate()){
                    providerServiceSelectingDialog();
                  }
                }else{
                  registerButtonAction();
                }
              },
              icon: Icon(
                Icons.arrow_forward,
              )),
        )
      ],
    );
  }

  void registerButtonAction() async{
    if (_formKey.currentState!.validate()){
      EasyLoading.show(
        dismissOnTap: false,
        status: 'Signing Up',
      );
      final user= userModel(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          image: '',
          deviceToken: deviceToken,
      );
        await _auth
            .createUserWithEmailAndPassword(email: user.email, password: _passwordController.text).whenComplete(() async {
              Get.find<UserController>().currUserModel=user;
              Get.find<UserController>().currUserDoc=user.email;
              await _auth.signInWithEmailAndPassword(email: user.email, password: _passwordController.text).whenComplete(() {loginType=true;});
        });
        await _db
            .collection('Users')
            .doc(user.email)
            .set(user.toMap()).onError((errorcode , stackTrace) {setState(() {error=true;errorCode=errorcode.toString();});})
            .whenComplete(()  {
              EasyLoading.dismiss(animation: true);
              Get.offAll(() =>userHomePage());
        });
      EasyLoading.dismiss(animation: true);
    }
  }
  void registerButtonActionProvider() async{
      EasyLoading.show(
        dismissOnTap: false,
        status: 'Signing Up',
      );
      final provider= providerModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        image: '',
        deviceToken: deviceToken,
        service: providerServiceSelection,
        type: providerTypeSelection,
        subTypes: providerSubTypes,
      );
      await _auth
          .createUserWithEmailAndPassword(email: provider.email, password: _passwordController.text).whenComplete(() async {
        Get.find<ProvidersController>().currProviderModel=provider;
        Get.find<ProvidersController>().currProviderDoc=provider.email;
        Get.find<ProvidersController>().currProviderType=provider.service;
        await _auth.signInWithEmailAndPassword(email: provider.email, password: _passwordController.text).whenComplete(() {loginType = false;});
      });
      await _db
          .collection(provider.service)
          .doc(provider.email)
          .set(provider.toMap()).onError((errorcode , stackTrace) {setState(() {error=true;errorCode=errorcode.toString();});})
          .whenComplete(()  async{
        if(providerCheckboxChecked){
          await _db.collection('providers').doc(provider.email).set({'type':provider.service});
        }
        EasyLoading.dismiss(animation: true);
        Get.offAll(() =>ProviderHomePage());
      });
      EasyLoading.dismiss(animation: true);
  }

  Future<void> providerServiceSelectingDialog() async{
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Provider Confirmation'),
            content: Text('If you want to register your account as a provider than some extra information about your service type will be need. Do you confirm that?'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  EasyLoading.showToast('Uncheck the "Register as Service Provider" checkbox to register as normal user',toastPosition: EasyLoadingToastPosition.bottom,duration: Duration(seconds: 4));
                },
                color: Colors.red[100],
                child: const Text('Cancel'),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  providerSubTypes=[];
                  showServiceSelectionSheet();
                },
                color: Colors.green[100],
                child: const Text('Confirm'),
              ),
            ],
          );
        });
  }

  showServiceSelectionSheet(){
    showModalBottomSheet(context: context,enableDrag: false,isDismissible: false,isScrollControlled: true,backgroundColor: Colors.lightBlueAccent, builder: (BuildContext context){
      return StatefulBuilder(
        builder: (context,setState) {
          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text(
                  'Provider Information',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30,),
                DropdownMenu(
                  onSelected: (selectedValue){
                    setState(() {
                      providerServiceSelection=selectedValue!;
                    });
                  },
                  width: MediaQuery.sizeOf(context).width*0.7,
                  hintText: 'Select Service Account Type',
                  dropdownMenuEntries: <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(value: services[0], label: services[0]),
                    DropdownMenuEntry(value: services[1], label: services[1]),
                    DropdownMenuEntry(value: services[2], label: services[2]),
                    DropdownMenuEntry(value: services[3], label: services[3]),
                    DropdownMenuEntry(value: services[4], label: services[4]),
                  ],
                ),
                SizedBox(height: 30,),
                DropdownMenu(
                  onSelected: (String? selectedValue){
                    setState(() {
                      providerTypeSelection=selectedValue!;
                    });
                  },
                  width: MediaQuery.sizeOf(context).width*0.7,
                  hintText: 'Select subtype in service',
                  helperText: 'Only between service type',
                  dropdownMenuEntries: <DropdownMenuEntry<String>>[
                    DropdownMenuEntry(value: 'Home appliance', label: 'Electrician: Home appliance'),
                    DropdownMenuEntry(value: 'Gadgets', label: 'Electrician: Gadgets'),
                    DropdownMenuEntry(value: 'Home wiring', label: 'Electrician: Home wiring'),
                    DropdownMenuEntry(value: 'Gas line', label: 'Plumber:Gas line'),
                    DropdownMenuEntry(value: 'Water line', label: 'Plumber: Water line'),
                    DropdownMenuEntry(value: 'Interior Cleaner', label: 'Cleaner: Interior'),
                    DropdownMenuEntry(value: 'Exterior Cleaner', label: 'Cleaner: Exterior'),
                    DropdownMenuEntry(value: 'Wall painter', label: 'Painter: Home'),
                    DropdownMenuEntry(value: 'Furniture painter', label: 'Painter: Furniture'),
                    DropdownMenuEntry(value: 'Nationwide ISP', label: 'ISP: Nationwide'),
                    DropdownMenuEntry(value: 'Local ISP', label: 'ISP:  Local'),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 30,),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width*0.6,
                      child: TextField(
                        controller: _subTypeController,
                        decoration: InputDecoration(
                          labelText: 'Expertise',
                          hintText: 'Add your expertise'
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: (){
                        if(!providerSubTypes.contains(_subTypeController.text) && _subTypeController.text!=''){
                          providerSubTypes.add(_subTypeController.text);
                          setState(() {});
                        }
                        _subTypeController.clear();
                      },
                      color: Colors.lightGreen[100],
                      child: Text('Add more'),
                    ),
                  ],
                ),
                SizedBox(height: 15,),
                Text('Added: ${providerSubTypes.toString()}'),
                SizedBox(height: 30,),
                MaterialButton(
                  onPressed: (){
                    registerButtonActionProvider();
                  },
                  color: Colors.lightGreen[200],
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        }
      );
    });
  }


  TextFormField passwordField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      obscureText: true,
      controller: _passwordController,
      focusNode: five,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.key,color: Colors.blueGrey.shade600,),
          labelText: 'Password',
          ),
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return 'Provide a password';
        }else if(value.trim().length<6){
          return 'Minimum 6 characters';
        }
        return null;
      },
      onFieldSubmitted: (value){_formKey.currentState!.validate();},
    );
  }

  TextFormField addressField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _addressController,
      focusNode: four,
      keyboardType: TextInputType.streetAddress,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.location_on),
          labelText: 'Address',
        ),
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return 'Provide your address';
        }
        return null;
      },
      onFieldSubmitted: (value){FocusScope.of(context).requestFocus(five);},
    );
  }

  TextFormField phoneField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _phoneController,
      focusNode: three,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.phone),
          labelText: 'Phone',
      ),
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return 'Provide your phone number';
        }else if(!RegExp(r"^(?:[+0][1-9])?[0-9]{9}$").hasMatch(value.trim())){
          return 'Invalid phone number';
        }
        return null;
      },
      onFieldSubmitted: (value){FocusScope.of(context).requestFocus(four);},
    );
  }

  TextFormField emailField() {
    return TextFormField(
      controller: _emailController,
      focusNode: two,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
          labelText: 'Email',
        ),
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return 'Provide an email address';
        }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value.trim())){
          return 'Invalid email address';
        }
        return null;
      },
      onFieldSubmitted: (value){FocusScope.of(context).requestFocus(three);},
    );
  }

  TextFormField nameField() {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: _nameController,
      focusNode: one,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          labelText: 'Username',
          ),
      validator: (value) {
        if(value == null || value.trim().isEmpty) {
          return 'Provide your name';
        }
        return null;
      },
      onFieldSubmitted: (value){FocusScope.of(context).requestFocus(two);},
    );
  }

  Container createAccountText() {
    return Container(
      padding: EdgeInsets.only(
          left: 35, top: MediaQuery.of(context).size.height * 0.10),
      child: Text(
        'Create\nAccount',
        style: TextStyle(color: Colors.white, fontSize: 50),
      ),
    );
  }
  @override
  void dispose() {
    _subTypeController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
