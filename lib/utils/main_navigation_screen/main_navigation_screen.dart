import 'package:fin_track/models/transaction/transaction_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fin_track/screens/balance_screen/balance_screen.dart';
import 'package:fin_track/screens/home_screen/home_screen.dart';
import 'package:fin_track/screens/profile_screen/profile_screen.dart';

//basically we r mapping each screen with 0,1,2 and using ontap method to detect the changes
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.transactionController,
    this.userName,
  });

  final TransactionController transactionController;
  final String? userName;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}




//what i was thinking was we could have simply did if(_selectedIdx==0) than namviagator.push_ but
//that wouold require each time  the state rebuilds + UX degrades a LOT
class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0; //initially lest direct it to HomeScreen


  //MAJOR bug here these are created vefore the widget tree was created so there context was some random value
  // final List<Widget> _screens = const [
  //   HomeScreen(),
  //   BalanceScreen(),
  //   ProfileScreen(),
  // ];

  //this fxn sets the slectedidx at the tapped navigation
  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.transactionController;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        if (controller.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  controller.initError ?? 'Failed to load transactions',
                ),
              ),
            ),
          );
        }

        if (!controller.isReady) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentUser = FirebaseAuth.instance.currentUser;
        final resolvedUserName =
            widget.userName?.trim().isNotEmpty == true
                ? widget.userName!.trim()
                : currentUser?.displayName?.trim().isNotEmpty == true
                ? currentUser!.displayName!.trim()
                : currentUser?.email?.split('@').first ?? 'User';

        final List<Widget> screens = [
          HomeScreen(
            transactionController: controller,
            userName: resolvedUserName,
          ),
          BalanceScreen(transactionController: controller),
          ProfileScreen(
            transactionController: controller,
            userName: resolvedUserName,
          ),
        ];

        return Scaffold(
          body: IndexedStack(index: _selectedIndex, children: screens),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: "Balance",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
            ],
          ),
        );
      },
    );
  }
}
