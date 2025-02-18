import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import '../Controllers/UserController.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    //UserController controllerU=Get.find<UserController>();
    return Scaffold(
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
              'About Us',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff4c505b),
              ),
            ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 52,
                  backgroundColor: Colors.lightBlueAccent,
                  child: CircleAvatar(
                    radius: 50,
                    foregroundImage: AssetImage(
                        'assets/appLogo.png',
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 30,),
            Text(
              '  Local Service Provider App:',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                      "Tired of struggling to find reliable and qualified service providers in your area? We get it. That's why we created [App Name], a user-friendly app that connects you with a network of vetted and professional local service providers for all your needs.\n\nWhether you need a plumber to fix a leaky faucet, a cleaner for a fresh Home environment, or a electrician to take care of your faulty gadgets, this app has you covered. Our extensive marketplace features a wide range of services, from home repair and cleaning to internet service providing."
                  ),
                  SizedBox(height: 30,),
                  RichText(
                    text: TextSpan(
                      text: "Here's what makes this app your go-to solution for all your local service needs:\n\n",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: "Convenience: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: "Book appointments and manage your bookings on the go, 24/7, with our easy-to-use app.\n",style: TextStyle(fontWeight: FontWeight.normal,),),
                          ],
                        ),
                        TextSpan(
                          text: "Reliability: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: "All our service providers are carefully vetted and background-checked to ensure your safety and peace of mind.\n",style: TextStyle(fontWeight: FontWeight.normal,),),
                          ],
                        ),
                        TextSpan(
                          text: "Quality: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: "We only partner with experienced and qualified professionals who are passionate about delivering exceptional service.\n",style: TextStyle(fontWeight: FontWeight.normal,),),
                          ],
                        ),
                        TextSpan(
                          text: "Transparency: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: "See upfront pricing and read verified reviews from other customers before you book.\n",style: TextStyle(fontWeight: FontWeight.normal,),),
                          ],
                        ),
                        TextSpan(
                          text: "Security: ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(text: "Your payments and personal information are always protected with our secure platform.\n",style: TextStyle(fontWeight: FontWeight.normal,),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
