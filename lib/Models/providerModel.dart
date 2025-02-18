const providerPhone = 'phone';
const providerName = 'name';
const providerEmail = 'email';
const providerAddress = 'address';
const providerImage = 'image';
const providerService = 'service';
const providerType = 'type';
const providerSubTypes = 'subTypes';
const providerScore='score';
const providerDeviceToken = 'token';


class providerModel{
  String address;
  String email;
  String image;
  String name;
  String phone;
  String service;
  String type;
  List subTypes;
  int score;
  String deviceToken;

  providerModel({
    required this.phone,
    this.name = '',
    required this.email,
    required this.address,
    this.image = '',
    required this.service,
    required this.type,
    required this.subTypes,
    this.score=0,
    this.deviceToken='',
  });

  Map<String, dynamic> toMap(){
    final Map = <String, dynamic>{
      providerPhone : phone,
      providerName : name,
      providerEmail : email,
      providerAddress : address,
      providerImage : image,
      providerService : service,
      providerType : type,
      providerSubTypes: subTypes,
      providerScore: score,
      providerDeviceToken: deviceToken,
    };
    return Map;
  }

  factory providerModel.fromMap(Map<String, dynamic> map) => providerModel(
    phone: map[providerPhone],
    name: map[providerName],
    email: map[providerEmail],
    address: map[providerAddress],
    image: map[providerImage],
    service: map[providerService],
    type: map[providerType],
    subTypes: map[providerSubTypes] is Iterable ? List.from(map[providerSubTypes]) : [],
    score: map[providerScore]??0,
    deviceToken: map[providerDeviceToken]??'',
  );
}