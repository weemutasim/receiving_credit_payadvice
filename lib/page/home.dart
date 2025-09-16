import 'package:credit_payadvice_receiving/font/appFonts.dart';
import 'package:credit_payadvice_receiving/page/credit.dart';
import 'package:flutter/material.dart';
import '../font/appColor.dart';
import 'payAdvance.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
              fontSize: width * .01,
            ),
            tabs: const [
              Tab(text: 'Credit'),
              Tab(text: 'Pay Advance'),
            ],
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Receiving Credit & Pay Advance', 
                style: TextStyle(fontFamily: AppFonts.traJanPro, fontSize: width * .013, color: Colors.white)
              ),
              Text('V0.0.4', 
                style: TextStyle(fontFamily: AppFonts.traJanPro, fontSize: width * .008, color: Colors.white)
              ),
            ],
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
