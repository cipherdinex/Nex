import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';

class TileCard extends StatelessWidget {
  const TileCard({
    Key? key,
    required this.color,
    required this.icon,
    required this.title,
    this.page,
    this.onTap,
  }) : super(key: key);

  final String? title;
  final IconData? icon;
  final Color? color;
  final String? page;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();

    return InkWell(
      onTap: page != null ? () => Navigator.pushNamed(context, page!) : onTap,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.0,
        child: ListTile(
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: color!.withOpacity(0.5),
            child: CircleAvatar(
              radius: 12,
              backgroundColor: color,
              foregroundColor: white,
              child: Icon(
                icon,
                size: 15,
              ),
            ),
          ),
          title: Text(_allBackEnds.translation(context, title!)),
          trailing: Icon(
            CupertinoIcons.forward,
            size: 15,
          ),
        ),
      ),
    );
  }
}
