import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/models/database.dart';
import 'package:to_do_app/utils/providers/program_provider.dart';

import '../../../constants/app_theme.dart';
class DeletePopup extends StatefulWidget {
  final TodoItem todoItem;
  const DeletePopup({Key? key, required this.todoItem}) : super(key: key);

  @override
  State<DeletePopup> createState() => _DeletePopupState();
}

class _DeletePopupState extends State<DeletePopup> {
  @override
  Widget build(BuildContext context) {
    ProgramProvider programProvider = Provider.of<ProgramProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 20,
        ),
        GestureDetector(
            onTap:() {
              programProvider.deleteTodoItem(widget.todoItem);
              Navigator.pop(context);
            },
            child: const Card(
              color: AppColors.primaryBlue,
              child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Text("Delete only this event", style: TextStyle(
                      fontWeight: FontWeight.w600
                    ),)
                  )
              ),
            )
        ),
        SizedBox(height: 10,),
        GestureDetector(
            onTap:() {
              programProvider.deleteFutureEvents(widget.todoItem);
              Navigator.pop(context);
            },
            child: const Card(
              color: AppColors.primaryBlue,
              child: SizedBox(
                  height: 50,
                  child: Center(
                      child: Text("Delete only future events", style: TextStyle(
                          fontWeight: FontWeight.w600
                      ),)
                  )
              ),
            )
        ),
        SizedBox(height: 10,),
        GestureDetector(
            onTap:() {
              programProvider.deleteAllEvents(widget.todoItem);
              Navigator.pop(context);
            },
            child: const Card(
              color: AppColors.primaryBlue,
              child: SizedBox(
                  height: 50,
                  child: Center(
                      child: Text("Delete all events", style: TextStyle(
                          fontWeight: FontWeight.w600
                      ),)
                  )
              ),
            )
        ),
      ],
    );
  }
}
