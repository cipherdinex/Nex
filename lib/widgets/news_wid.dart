import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/pages/news_detail.dart';

class NewsWid extends StatelessWidget {
  const NewsWid({
    Key? key,
    this.data,
  }) : super(key: key);

  final Map? data;
  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();
    var settingsBx = Hive.box(SETTINGS);
    String newData = jsonEncode(data);

    Size med = MediaQuery.of(context).size;

    String? getFxn(key) {
      return settingsBx.get(key);
    }

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsDetailScreen(data: newData),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: med.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data![HEADLINE],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _allBackEnds.convertToTimeAgo(data![DATETIME],
                                locale: getFxn('lang')) +
                            " • ",
                        style: TextStyle(
                          fontSize: 12,
                          color: green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data![SOURCE],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    data![SUMMARY],
                    style: TextStyle(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              width: med.width * 0.23,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(data![IMAGE]),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
