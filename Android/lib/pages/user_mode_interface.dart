import 'package:android/pages/rfid_cards_page.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color myColor = Color(0xFFADD8E6);
    return Scaffold(
      appBar: AppBar(

        title: Row(
          children: [
            Image.asset(
              'assets/electrical_vehicle.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'EVCharge',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: myColor,
      ),
      drawer: const YourSideMenuWidget(),
      body: Container(
        color: myColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      Text(
                        'Ivan Horvat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/autich.png'),
                ),
              ),
            ),
            const Spacer(),
            Container(
              height: 100.0,
              decoration: const BoxDecoration(
                color: myColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Container(
                color: myColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, 'chargeHistoryPage');
                          },
                          icon: const Icon(Icons.history,
                              size: 30, color: Colors.black),
                        ),
                        const Text(
                          'Charging History',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RfidCardsPage()),
                            );
                          },
                          icon: const Icon(Icons.credit_card,
                              size: 30, color: Colors.black),
                        ),
                        const Text(
                          'My Cards',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                          },
                          icon: const Icon(Icons.add, size: 30, color: Colors.black),
                        ),
                        const Text(
                          'Add Card',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
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

class YourSideMenuWidget extends StatelessWidget {
  const YourSideMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color myColor = Color(0xFFADD8E6);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: myColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Charging History'),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'chargeHistoryPage');
            },
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('My Cards'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Card'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}