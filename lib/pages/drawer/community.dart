import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/helpers/app_config.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/social_tile_wid.dart';

class JoinCommunity extends StatelessWidget {
  const JoinCommunity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KHeader(
      title: ["Join Community"],
      body: Column(
        children: [
          SocialWid(
            icon: FontAwesome.facebook_official,
            title: FACEBOOK,
            url: FACEBOOK_URL,
          ),
          SocialWid(
            icon: FontAwesome.instagram,
            title: INSTAGRAM,
            url: INSTAGRAM_URL,
          ),
          SocialWid(
            icon: FontAwesome.twitter,
            title: TWITTER,
            url: TWITTER_URL,
          ),
          SocialWid(
            icon: FontAwesome.telegram,
            title: TELEGRAM,
            url: TELEGRAM_URL,
          ),
          SocialWid(
            icon: FontAwesome.reddit,
            title: REDDIT,
            url: REDDIT_URL,
          ),
          SocialWid(
            icon: FontAwesome.youtube,
            title: YOUTUBE,
            url: YOUTUBE_URL,
          ),
          SocialWid(
            icon: FontAwesome.medium,
            title: MEDIUM,
            url: MEDIUM_URL,
          ),
        ],
      ),
    );
  }
}
