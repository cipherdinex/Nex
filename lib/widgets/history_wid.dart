import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

class HistoryWid extends StatelessWidget {
  const HistoryWid({
    Key? key,
    required this.unit,
    required this.data,
  }) : super(key: key);

  final String unit;

  final data;

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackends = AllBackEnds();

    String title = data[TITLE];
    return ListTile(
      leading: Icon(
        data[INCOME] ? Entypo.arrow_down : Entypo.arrow_up,
        color: data[INCOME] ? green : red,
      ),
      title: Text(unit.toUpperCase() + " ${data[AMOUNT]}"),
      subtitle: Text(_allBackends.translation(context, title.capitalize()!)),
      trailing: Text(data[DATETIME]),
    );
  }
}
