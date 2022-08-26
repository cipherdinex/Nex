import 'package:flutter/material.dart';
import 'package:kryptonia/widgets/cust_container.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/trns_text.dart';

//TODOTranslations
class ActivtyCont extends StatelessWidget {
  const ActivtyCont({
    Key? key,
    required this.activity,
    required this.message,
    required this.tDate,
    required this.icon,
    this.isNoti = false,
  }) : super(key: key);

  final String activity;
  final String message;
  final String tDate;
  final Icon icon;
  final bool isNoti;

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return CustContainer(
      child: Row(
        children: [
          icon,
          SizedBox(width: 10),
          Container(
            width: med.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isNoti
                    ? Text(
                        activity.capitalize()!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    : TrnsText(
                        title: activity.capitalize()!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                isNoti
                    ? Expanded(
                        child: Text(
                          message,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.8),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      )
                    : Expanded(
                        child: TrnsText(
                          title: message,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.8),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                Text(
                  tDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
