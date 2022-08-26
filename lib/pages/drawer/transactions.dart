import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/widgets/cust_shimmer.dart';
import 'package:kryptonia/widgets/empty.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/lazy_load_wid.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key? key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  AllBackEnds _allBackEnds = AllBackEnds();

  List<int> lData = [];
  int currentLength = 0;

  final int increment = 10;
  bool isLoading = false;

  @override
  void initState() {
    _loadMore(true);

    super.initState();
  }

  Future _loadMore(bool isInit) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: isInit ? 0 : 2));
    for (var i = currentLength; i <= currentLength + increment; i++) {
      lData.add(i);
    }
    setState(() {
      isLoading = false;
      currentLength = lData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KHeader(
      title: ["All Transactions"],
      body: FutureBuilder<List?>(
        future: _allBackEnds.sqlgetTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustShimmer(type: 7);
          } else {
            List data = snapshot.data!;
            if (data.isEmpty) {
              return EmptyWid(
                svg: 'empty',
                title: "It's Empty Here",
                subtitle: "Get busy, carry out some transactions",
              );
            } else {
              return LazyLoadWid(
                isLoading: isLoading,
                data: data,
                lData: lData,
                onEndOfPage: () => _loadMore(false),
                itemBuilder: (context, int index) {
                  String tDate = DateFormat("HH:mm - dd/MM/yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          data[index][TIMESTAMP]));
                  String type = data[index][TYPE];
                  return DottedBorder(
                      color: accentColor,
                      dashPattern: [8, 4],
                      strokeWidth: 2,
                      borderType: BorderType.RRect,
                      radius: Radius.circular(12),
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TrnsText(
                                title: "{Arg1} Order Ref: {Arg2}",
                                args: {
                                  'Arg1': type.capitalize()!,
                                  'Arg2': data[index][REFERENCE]
                                },
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                tDate,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                data[index][CURRENCY].toUpperCase() +
                                    " " +
                                    data[index][AMOUNT],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              data[index][PAYMENT_STATUS] == COMPLETED
                                  ? Icon(
                                      Icons.check_outlined,
                                      color: green,
                                    )
                                  : data[index][PAYMENT_STATUS] == PENDING
                                      ? Icon(
                                          Icons.timer,
                                          color: blue,
                                        )
                                      : Icon(
                                          Icons.close_outlined,
                                          color: red,
                                        ),
                            ],
                          ),
                        ],
                      ));
                },
              );
            }
          }
        },
      ),
    );
  }
}
