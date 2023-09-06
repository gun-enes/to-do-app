import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/database.dart';
import 'package:to_do_app/screens/upgrade_task/upgrade_task_screen.dart';
import 'package:to_do_app/services/isar_services.dart';
import 'package:to_do_app/utils/providers/program_provider.dart';

import '../../../constants/app_theme.dart';
import '../../../main.dart';
import '../../../notifications/notifications.dart';
import 'delete_popup.dart';

class ListTileHomePage extends StatefulWidget {

  const ListTileHomePage({
    Key? key,
    required this.todoItem ,
  }) : super(key: key);
  final TodoItem todoItem;

  @override
  State<ListTileHomePage> createState() => _ListTileHomePageState();
}

class _ListTileHomePageState extends State<ListTileHomePage> {
  final service = IsarService();
  @override
  Widget build(BuildContext context) {
    return Consumer<ProgramProvider>(
      builder: (context,programProvider,child) {
        return Dismissible(
          background: const Center(child: Text("Deleted",style: TextStyle(color: AppColors.secondaryBlue),)),
          onDismissed: (DismissDirection direction) {
            programProvider.deleteTodoItem(widget.todoItem);
          },
          key: UniqueKey(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: SizedBox(
              height: 100,
              child: Card(
                color: widget.todoItem.isDone ? AppColors.doneTaskColor:AppColors.deepButtonColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: OpenContainer(
                      closedElevation: 0,
                      closedColor: Colors.transparent,
                      transitionDuration: const Duration(milliseconds: 300),
                      transitionType: ContainerTransitionType.fade,
                      closedBuilder: (_, openContainer) {
                        return ListTile(
                          onTap: openContainer,
                          leading: IconButton(
                            icon: widget.todoItem.isDone ? const Icon(Icons.check_box, color: AppColors.mainWhite,):const Icon(Icons.check_box_outline_blank,color: AppColors.mainWhite,),
                          onPressed: (){
                            if(widget.todoItem.isDone) {
                              programProvider.setIsDone(widget.todoItem, false);
                              programProvider.moveToStart(widget.todoItem);
                            }
                            else{
                              programProvider.setIsDone(widget.todoItem, true);
                              programProvider.moveToEnd(widget.todoItem);
                            }
                           },
                          ),
                          title: Text(
                            widget.todoItem.title,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              decoration: widget.todoItem.isDone ? TextDecoration.lineThrough:TextDecoration.none,
                              fontSize: 20,
                              color: const Color(0xffdadaf0),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              !programProvider.isAlarmSet(widget.todoItem) ? const Icon(Icons.alarm,color: AppColors.mainWhite,): const Text(""),
                              programProvider.isRepeatSet(widget.todoItem) ?
                              IconButton(
                                  icon: Icon(Icons.delete ,color: AppColors.mainWhite),
                                  onPressed: (){
                                    showModalBottomSheet(
                                        backgroundColor: AppColors.mainBlue,
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(height: 250, child: DeletePopup(todoItem: widget.todoItem));
                                        });
                                  },
                              ):
                              const Text("")
                            ],
                          ),
                          );
                              //
                      },
                      openBuilder: (_, closeContainer) {
                        return UpgradeTask(widget.todoItem);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
Widget _buildItem(String item, Animation<double> animation) {
  return SizeTransition(
    sizeFactor: animation,
    child: ListTile(
      title: Text(item),
    ),
  );
}

