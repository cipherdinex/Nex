import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/widgets/cust_prog_ind.dart';
import 'package:kryptonia/widgets/tile_wid.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CustScafWid extends StatelessWidget {
  const CustScafWid({
    Key? key,
    required this.body,
    this.isLoading = false,
    this.onRefresh,
  }) : super(key: key);

  final Widget body;
  final bool isLoading;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();

    var userBx = Hive.box(SETTINGS);

    String fName = _allBackEnds.getUser(FIRST_NAME);
    String lName = _allBackEnds.getUser(LAST_NAME);
    String? profilePic = _allBackEnds.getUser(PROFILEPIC);
    int? identified = _allBackEnds.getUser(IDENTIFIED);
    Size med = MediaQuery.of(context).size;
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CustProgIndicator(),
      child: RefreshIndicator(
        onRefresh: onRefresh ?? () async => null,
        color: accentColor,
        displacement: 100.0,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            iconTheme: IconThemeData(
                color: Theme.of(context).textTheme.bodyText1!.color),
            actions: [
              ValueListenableBuilder(
                valueListenable: userBx.listenable(),
                builder: (_, Box snapshot, child) {
                  bool notificationStatus = snapshot.get(NOTIFICATION) ?? false;
                  return Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          FlutterIcons.bell_fea,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/notifications/'),
                      ),
                      notificationStatus
                          ? Positioned(
                              top: 13,
                              right: 13,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: red,
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  FlutterIcons.activity_fea,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, '/activities-history/'),
              ),
            ],
          ),
          drawer: Container(
            height: med.height,
            width: 300,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    CircleAvatar(
                      radius: 43,
                      backgroundColor:
                          Theme.of(context).textTheme.bodyText1!.color,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: profilePic != null
                              ? CachedNetworkImageProvider(profilePic)
                              : null,
                          child: profilePic == null
                              ? Icon(
                                  CupertinoIcons.person_fill,
                                  size: 35,
                                )
                              : null,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fName.capitalize()! + " " + lName.capitalize()!,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(width: 10),
                        identified == 2
                            ? Icon(
                                Icons.verified_rounded,
                                size: 20,
                                color: green,
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    Text(
                      _allBackEnds.translation(context, "ID:") +
                          ' ' +
                          _allBackEnds.getUser(UID).hashCode.toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            TileCard(
                                color: accentColor,
                                icon: Icons.person,
                                title: "Profile",
                                page: '/profile/'),
                            TileCard(
                                color: c2,
                                icon: Icons.person,
                                title: 'Limits & Verification',
                                page: '/limits-verification/'),
                            TileCard(
                                color: c4,
                                icon: FlutterIcons.coin_mco,
                                title: "Transactions",
                                page: '/transactions/'),
                            TileCard(
                                color: pink,
                                icon: Foundation.wrench,
                                title: "Preferences",
                                page: '/preferences/'),
                            TileCard(
                                color: green,
                                icon: Feather.shield,
                                title: "Security",
                                page: '/security/'),
                            TileCard(
                              color: blue,
                              icon: FontAwesome.group,
                              title: "Join Commnunity",
                              page: '/join-community/',
                            ),
                            TileCard(
                              color: amber,
                              icon: Entypo.info,
                              title: "About",
                              page: '/about/',
                            ),
                            SizedBox(height: 20),
                            TileCard(
                              color: red,
                              icon: Entypo.log_out,
                              title: "Log Out",
                              page: null,
                              onTap: () => _allBackEnds.sqlSignOut(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: body,
            ),
          ),
        ),
      ),
    );
  }
}
