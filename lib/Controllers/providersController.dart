import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:service_provider/Models/providerModel.dart';
import '../Pages/services.dart';
import '../Pages/userHome.dart';

class ProvidersController extends GetxController{
  final _db=FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;

  late providerModel currProviderModel;
  late String currProviderDoc;
  String currProviderType='';
  Future getCurrProviderModel() async{
    currProviderDoc=await _auth.currentUser!.email!;
    await _db.collection('providers').doc(currProviderDoc).get().then((value){
      currProviderType=value.data()!['type'];
      getCurrProviderModelAssist(currProviderType);
    });
  }
  Future getCurrProviderModelAssist(String currProviderCollection) async {
    await _db.collection(currProviderCollection).doc(currProviderDoc).get().then((value) {
      currProviderModel = providerModel.fromMap(value.data() as Map<String, dynamic>);
      update();
      return;
    });
  }

  var selectedServiceProvider=-1;
  int currService=-1;

  List<providerModel> providers=[];
  List<bool> booked=[];
  Future providersInfoGetter() async {
    providers=[];
    booked=[];
    itemsAmount=0;
    await _db.collection(services[currService]).get().then((value) {
      value.docs.forEach((element) {
        providers.add(providerModel.fromMap(element.data()));
        booked.add(false);
        itemsAmount<providers.length?itemsAmount+=1:itemsAmount+=0;
      });
      isLoaded=true;
      update();
    });
  }

  currServiceSetter(int x){
    currService=x;
    update();
  }


  selectedSetter(int x){
    selectedServiceProvider=x;
    update();
  }

  int _bottomNevBarItemSelected = 1;
  int get bottomNevBarItemSelected => _bottomNevBarItemSelected;
  bottomNevBarItemSetter(int item){
    _bottomNevBarItemSelected=item;
    update();
  }


}