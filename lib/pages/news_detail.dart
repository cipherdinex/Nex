import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/text_link.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String? data;
  @override
  Widget build(BuildContext context) {
    Map dts = jsonDecode(data!);
    AllBackEnds _allBackEnds = AllBackEnds();
    String timeAgo = _allBackEnds.convertToTimeAgo(dts[DATETIME]);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Theme.of(context).primaryColor,
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 28),
              centerTitle: true,
              title: Text(
                dts[HEADLINE],
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              background: CachedNetworkImage(
                imageUrl: dts[IMAGE],
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TrnsText(
                          title: "Source",
                          style: TextStyle(
                            fontSize: 14,
                            color: green,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          dts[SOURCE],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        TrnsText(
                          title: "Time",
                          style: TextStyle(
                            fontSize: 14,
                            color: green,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          timeAgo.capitalize()!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    TrnsText(
                      title: "Description",
                      style: TextStyle(
                        fontSize: 14,
                        color: green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      dts[SUMMARY],
                    ),
                    SizedBox(height: 10),
                    TextLinkWid(
                      title: "Read More ...",
                      onTap: () => _allBackEnds.launchUrlFxn(dts[URL]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
