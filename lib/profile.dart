import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("forever", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
            SizedBox(width: 8),
            Icon(
              Icons.verified_sharp,
              size: 18,
              color: Colors.blue,
            )
          ],
        ),
        actions: const [
          Icon(Icons.add_alert),
          SizedBox(width: 15),
          Icon(Icons.more_horiz),
          SizedBox(width: 15),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Container(
          width: 420,
          height: 271,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 75,
                    width: 75,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xff512144),
                          Color(0xfff4cccc),
                          Color(0xfff5e825),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}