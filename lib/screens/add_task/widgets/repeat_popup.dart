import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/providers/repeat_provider.dart';

import '../../../constants/app_theme.dart';

class RepeatPopUp extends StatefulWidget {
  const RepeatPopUp({Key? key}) : super(key: key);

  @override
  State<RepeatPopUp> createState() => _RepeatPopUpState();
}

class _RepeatPopUpState extends State<RepeatPopUp> {
  String selectedData = "";
  List<String> actionList = [
    "None",
    "Once a day",
    "Once in a week",
    "Once in a month",
    "Once in a year"
  ];
  List<String> daysOfWeek = [
    "M",
    "T",
    "W",
    "T",
    "F",
    "S",
    "S",
  ];
  TextEditingController dayController = TextEditingController();

  int count = 0;
  @override
  Widget build(BuildContext context) {
    RepeatProvider repeatProvider = Provider.of<RepeatProvider>(context);
    //dayController.text = "1";
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      backgroundColor: AppColors.mainBlue,
      content: SizedBox(
        width: 300,
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(count == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        count > 0 ? count--: count = 4;
                      });
                    }, icon: const Icon(Icons.arrow_back_ios),color: AppColors.mainWhite),
                    Text(actionList[count], style: const TextStyle(color:AppColors.mainWhite, fontSize: 20),),
                    IconButton(onPressed: (){
                      setState(() {
                        count < 5 ? count++: count = 0;
                      });
                    }, icon: const Icon(Icons.arrow_forward_ios), color: AppColors.mainWhite,),
                  ],
                ),
              ),
            if(count == 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        count > 0 ? count--: count = 4;
                      });
                    }, icon: const Icon(Icons.arrow_back_ios),color: AppColors.mainWhite),
                    const Text("Once in ", style: TextStyle(color:AppColors.mainWhite, fontSize: 20),),
                    SizedBox(
                      width: 35,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: TextField(
                          showCursor: false,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey[800],
                          cursorHeight: 20,
                          controller: dayController,
                          style: const TextStyle(color: AppColors.mainWhite, fontSize: 20),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 12)
                          ),
                        ),
                      ),
                    ),
                    const Text("days",style: TextStyle(color:AppColors.mainWhite, fontSize: 20)),
                    IconButton(onPressed: (){
                      setState(() {
                        count < 5 ? count++: count = 0;
                      });
                    }, icon: const Icon(Icons.arrow_forward_ios), color: AppColors.mainWhite,),
                  ],
                ),
              ),
            if(count == 2)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){
                        setState(() {
                          count > 0 ? count--: count = 4;
                        });
                      }, icon: const Icon(Icons.arrow_back_ios),color: AppColors.mainWhite),
                      const Text("Once in ", style: TextStyle(color:AppColors.mainWhite, fontSize: 20),),
                      SizedBox(
                        width: 27,
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: TextField(
                            showCursor: false,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.grey[800],
                            cursorHeight: 20,
                            controller: dayController,
                            style: const TextStyle(color: AppColors.mainWhite, fontSize: 20),
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 12)
                            ),
                          ),
                        ),
                      ),
                      const Text(" weeks",style: TextStyle(color:AppColors.mainWhite, fontSize: 20)),

                      IconButton(onPressed: (){
                        setState(() {
                          count < 4 ? count++: count = 0;
                        });
                      }, icon: const Icon(Icons.arrow_forward_ios), color: AppColors.mainWhite,),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(repeatProvider.colors[0] == AppColors.mainBlue){
                                repeatProvider.setColor(AppColors.primaryBlue, 0);
                                repeatProvider.setDay(0);
                            }
                            else{
                                repeatProvider.setColor(AppColors.mainBlue, 0);
                                repeatProvider.unsetDay(0);
                            }
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: repeatProvider.colors[0],
                              child: Text(daysOfWeek[0],style: const TextStyle(color: AppColors.mainWhite),)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(repeatProvider.colors[1] == AppColors.mainBlue){
                                repeatProvider.setColor(AppColors.primaryBlue, 1);
                                repeatProvider.setDay(1);
                            }
                            else{
                                repeatProvider.setColor(AppColors.mainBlue, 1);
                                repeatProvider.unsetDay(1);
                            }
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: repeatProvider.colors[1],
                              child: Text(daysOfWeek[1],style: const TextStyle(color: AppColors.mainWhite),)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(repeatProvider.colors[2] == AppColors.mainBlue){
                                repeatProvider.setColor(AppColors.primaryBlue, 2);
                                repeatProvider.setDay(2);
                            }
                            else{
                                repeatProvider.setColor(AppColors.mainBlue, 2);
                                repeatProvider.unsetDay(2);
                            }
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: repeatProvider.colors[2],
                              child: Text(daysOfWeek[2],style: const TextStyle(color: AppColors.mainWhite),)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(repeatProvider.colors[3] == AppColors.mainBlue){
                                repeatProvider.setColor(AppColors.primaryBlue, 3);
                                repeatProvider.setDay(3);
                            }
                            else{
                                repeatProvider.setColor(AppColors.mainBlue, 3);
                                repeatProvider.unsetDay(3);
                            }
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: repeatProvider.colors[3],
                              child: Text(daysOfWeek[3],style: const TextStyle(color: AppColors.mainWhite),)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(repeatProvider.colors[4] == AppColors.mainBlue){
                                repeatProvider.setColor(AppColors.primaryBlue, 4);
                                repeatProvider.setDay(4);
                            }
                            else{
                                repeatProvider.setColor(AppColors.mainBlue, 4);
                                repeatProvider.unsetDay(4);
                            }
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: repeatProvider.colors[4],
                              child: Text(daysOfWeek[4],style:const  TextStyle(color: AppColors.mainWhite),)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(repeatProvider.colors[5] == AppColors.mainBlue){
                                repeatProvider.setColor(AppColors.primaryBlue, 5);
                                repeatProvider.setDay(5);
                            }
                            else{
                                repeatProvider.setColor(AppColors.mainBlue, 5);
                                repeatProvider.unsetDay(5);
                            }
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: repeatProvider.colors[5],
                              child: Text(daysOfWeek[5],style: const TextStyle(color: AppColors.mainWhite),)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            if(repeatProvider.colors[6] == AppColors.mainBlue){
                                repeatProvider.setColor(AppColors.primaryBlue, 6);
                                repeatProvider.setDay(6);
                            }
                            else{
                                repeatProvider.setColor(AppColors.mainBlue, 6);
                                repeatProvider.unsetDay(6);
                            }
                          },
                          child: CircleAvatar(
                              radius: 16,
                              backgroundColor: repeatProvider.colors[6],
                              child: Text(daysOfWeek[6],style: const TextStyle(color: AppColors.mainWhite),)
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            if(count == 3)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        count > 0 ? count--: count = 4;
                      });
                    }, icon: const Icon(Icons.arrow_back_ios),color: AppColors.mainWhite),
                    const Text("Once in ", style: TextStyle(color:AppColors.mainWhite, fontSize: 20),),
                    SizedBox(
                      width: 35,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: TextField(
                          showCursor: false,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey[800],
                          cursorHeight: 20,
                          controller: dayController,
                          style: const TextStyle(color: AppColors.mainWhite, fontSize: 20),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 12)
                          ),
                        ),
                      ),
                    ),
                    const Text("months",style: TextStyle(color:AppColors.mainWhite, fontSize: 20)),
                    IconButton(onPressed: (){
                      setState(() {
                        count < 4 ? count++: count = 0;
                      });
                    }, icon: const Icon(Icons.arrow_forward_ios), color: AppColors.mainWhite,),
                  ],
                ),
              ),
            if(count == 4)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        count > 0 ? count--: count = 4;
                      });
                    }, icon: const Icon(Icons.arrow_back_ios),color: AppColors.mainWhite),
                    const Text("Once in ", style: TextStyle(color:AppColors.mainWhite, fontSize: 20),),
                    SizedBox(
                      width: 35,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: TextField(
                          showCursor: false,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.grey[800],
                          cursorHeight: 20,
                          controller: dayController,
                          style: const TextStyle(color: AppColors.mainWhite, fontSize: 20),
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 12)
                          ),
                        ),
                      ),
                    ),
                    const Text("years",style: TextStyle(color:AppColors.mainWhite, fontSize: 20)),
                    IconButton(onPressed: (){
                      setState(() {
                        count < 4 ? count++: count = 0;
                      });
                    }, icon: const Icon(Icons.arrow_forward_ios), color: AppColors.mainWhite,),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          onTap:() {
            repeatProvider.setData(actionList[count]);
            repeatProvider.setCount(int.parse(dayController.text));
            Navigator.pop(context);
          },
          child: const Card(
            color: AppColors.primaryBlue,
            child: SizedBox(
                height: 50,
                child: Center(
                  child: Text("Set", style: TextStyle(fontSize: 15,),),
                )
            ),
          )
      ),
      ]
    );
  }
}
