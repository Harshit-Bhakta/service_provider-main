import 'package:flutter/material.dart';
class StatusColoredContainer extends StatelessWidget {
  final String status;
  const StatusColoredContainer({super.key,required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: getStatusColor(status),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
      child: Text(
        status,
        style: TextStyle(
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  getStatusColor(String status) {
    if(status=='Done'){
      return Colors.greenAccent[100];
    }else if(status=='Running'){
      return Colors.yellow[200];
    }else if(status=='Cancelled'){
      return Colors.red[200];
    }else if(status=='Started'){
      return Colors.green[100];
    }else{
      return Colors.grey[300];
    }
  }
}
