import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:service_provider/Controllers/OrderController.dart';
import 'package:service_provider/Widgets/statusColoredContainer.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  @override
  void initState() {
    super.initState();
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
        centerTitle: true,
        title: Text(
          "History",
          style: TextStyle(
            fontSize: 35,
            color: Color(0xff4c505b),
          ),
        ),
      ),
      body: GetBuilder<OrderController>(
        builder: (oController) {
          return HistoryBody(monthNames: monthNames);
        }
      ),
    );
  }


}

class HistoryBody extends StatefulWidget {
  const HistoryBody({
    super.key,
    required this.monthNames,
  });

  final List<String> monthNames;

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {
  @override
  void initState() {
    Get.find<OrderController>().getHistory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final OrderController controllerO=Get.find<OrderController>();
    return RefreshIndicator(
      onRefresh: ()async{
        controllerO.getHistory();
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: GetBuilder<OrderController>(
          builder: (_) {
            return Visibility(
              visible: !controllerO.historyProgressVisibility,
              replacement: Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlueAccent,
                ),
              ),
              child: Visibility(
                visible: controllerO.history.length>0,
                replacement: RefreshIndicator(
                  onRefresh: ()async{
                    controllerO.getHistory();
                  },
                  child: Center(
                    child: Text(
                      'Empty',
                    ),
                  ),
                ),
                child: ListView.builder(
                  //reverse: true,
                  itemCount: controllerO.history.length,
                  itemBuilder: (context,index){
                    DateTime dateTime=controllerO.history[index].orderDateTime;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.lightBlue[50],
                          child: Text(
                            (index+1).toString(),
                          ),
                        ),
                        title: Text(controllerO.history[index].orderType),
                        subtitle: Text('${DateFormat.yMMMMEEEEd().format(dateTime)}\n${DateFormat.jms().format(dateTime)}'),
                        trailing: StatusColoredContainer(status: controllerO.history[index].orderStatus),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
