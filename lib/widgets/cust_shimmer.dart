import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/utils/asset_pie_chart.dart';
import 'package:kryptonia/utils/price_chart.dart';
import 'package:shimmer/shimmer.dart';

class CustShimmer extends StatelessWidget {
  final int type;

  const CustShimmer({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: accentColor,
      highlightColor: red,
      child: switchShimmer(type, med),
    );
  }

  Widget coinListTemp(Size med) {
    return Container(
      height: 100,
      width: med.width * 0.9,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Container(
        height: 100,
        width: med.width * 0.9,
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 45,
                      height: 15,
                      color: red,
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 95,
                      height: 15,
                      color: red,
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 50,
              width: 95,
              child: PriceChart(
                sparkline: [],
                color: red,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 95,
                  height: 15,
                  color: red,
                ),
                SizedBox(height: 5),
                Container(
                  width: 45,
                  height: 15,
                  color: red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget coinListHome(med) {
    return coinListTemp(med);
  }

  Widget coinListShimmer(med) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 7,
      itemBuilder: (context, i) {
        return coinListTemp(med);
      },
    );
  }

  Widget moversShimmer() {
    return Container(
      width: 180,
      height: 200,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: red,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 20,
                  color: red,
                ),
                SizedBox(width: 5),
                Container(
                  width: 40,
                  height: 20,
                  color: red.withOpacity(0.4),
                ),
                SizedBox(width: 10),
                Container(
                  width: 55,
                  height: 20,
                  color: red.withOpacity(0.4),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: 45,
              height: 15,
              color: red,
            ),
            SizedBox(height: 10),
            Container(
              width: 85,
              height: 30,
              color: red,
            ),
          ],
        ),
      ),
    );
  }

  Widget newsShimmer() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (context, i) {
        return Container(
          height: 100,
          width: double.infinity,
          child: Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 245,
                          height: 30,
                          color: red,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 15,
                              color: red.withOpacity(0.5),
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 100,
                              height: 15,
                              color: red.withOpacity(0.5),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 245,
                          height: 25,
                          color: red.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: red.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget portfolioShimmer() {
    return ListTile(
      leading: CircleAvatar(),
      title: Container(
        height: 15,
        color: red,
      ),
      subtitle: Container(
        height: 15,
        color: red.withOpacity(0.5),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 50,
            height: 15,
            color: red,
          ),
          SizedBox(height: 5),
          Container(
            width: 50,
            height: 15,
            color: red,
          ),
        ],
      ),
    );
  }

  Widget portfolioShimmer2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Portfolio balance",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: red.withOpacity(0.5),
          ),
        ),
        Text(
          "USD 0.00",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        AssetPieChart(),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, int i) {
            return ListTile(
              leading: CircleAvatar(),
              title: Container(
                height: 15,
                color: red,
              ),
              subtitle: Container(
                height: 15,
                color: red.withOpacity(0.5),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 50,
                    height: 15,
                    color: red,
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 50,
                    height: 15,
                    color: red,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget coinHistoryShimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Entypo.arrow_up,
                color: red,
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 15,
                    color: red,
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: 50,
                    height: 12,
                    color: red,
                  ),
                ],
              )
            ],
          ),
          Container(
            width: 50,
            height: 15,
            color: red,
          ),
        ],
      ),
    );
  }

  Widget switchShimmer(int type, Size med, {isHorizontal}) {
    switch (type) {
      case 1:
        return coinListHome(med);

      case 2:
        return coinListShimmer(med);

      case 3:
        return moversShimmer();

      case 4:
        return newsShimmer();

      case 5:
        return portfolioShimmer();

      case 6:
        return portfolioShimmer2();

      case 7:
        return coinHistoryShimmer();

      default:
        return coinListHome(med);
    }
  }
}
