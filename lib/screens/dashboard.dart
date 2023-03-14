import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 37, left: 45, right: 45, bottom: 20),
              child: Container(
                height: 117.41,
                width: 300,

                //Icon
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(
                        'lib/assets/Logo.png',
                        height: 68.41,
                        width: 150,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Dashboard',
                      style: GoogleFonts.montserrat(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
