import 'package:credit_payadvice_receiving/font/appFonts.dart';
import 'package:credit_payadvice_receiving/page/credit.dart';
import 'package:flutter/material.dart';
import '../font/appColor.dart';
import 'payAdvance.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.pinkcm,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            indicatorColor: Colors.black,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontFamily: AppFonts.traJanPro,
              fontSize: 20,
            ),
            tabs: const [
              Tab(text: 'Credit'),
              Tab(text: 'Pay Advance'),
            ],
          ),
          title: Text(
            'Receiving Credit & Pay Advance', 
            style: TextStyle(
              fontFamily: AppFonts.traJanProBold,
              fontSize: 25,
              color: Colors.white
            )
          ),
        ),
        body: const TabBarView(
          children: [
            Credit(),
            Payadvance(),
          ],
        ),
      ),
    );
  }
}
