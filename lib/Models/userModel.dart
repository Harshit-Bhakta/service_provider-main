  const userPhone = 'phone';
  const userName = 'name';
  const userEmail = 'email';
  const userAddress = 'address';
  const userImage = 'image';
  const userDeviceToken = 'token';

  class userModel{
    String phone;
    String name;
    String email;
    String address;
    String image;
    String deviceToken;

    userModel({
      required this.phone,
      this.name = '',
      required this.email,
      required this.address,
      this.image = '',
      this.deviceToken = '',
    });

    Map<String, dynamic> toMap(){
      final Map = <String, dynamic>{
        userPhone : phone,
        userName : name,
        userEmail : email,
        userAddress : address,
        userImage : image,
        userDeviceToken : deviceToken,
      };
      return Map;
    }

    factory userModel.fromMap(Map<String, dynamic> map) => userModel(
      phone: map[userPhone],
      name: map[userName],
      email: map[userEmail],
      address: map[userAddress],
      image: map[userImage],
      deviceToken: map[userDeviceToken]??'',
    );
  }