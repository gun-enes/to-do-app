import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/constants/app_theme.dart';
import 'package:to_do_app/utils/providers/program_provider.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ProgramProvider programProvider = Provider.of<ProgramProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Text(
              "My Tasks",
              style: TextStyle(
                color: AppColors.secondaryBlue,
                fontSize: 30,
              ),
            ),
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if(programProvider.isAgenda)
              programProvider.toggleIsAgenda(false);
            else
              programProvider.toggleIsAgenda(true);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Icon(
              Icons.calendar_month,
              color: AppColors.mainWhite,
            ),
          ),
        ),
      ],
    );
  }
}
