import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/routes/app_router.dart';


class ShellScreen extends ConsumerStatefulWidget {
  final Widget? child;
  const ShellScreen({super.key, this.child});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  int _currentIndex = 0; // State variable to track the current index
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        // set the current index
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green[700], // Color for selected item
        unselectedItemColor: Colors.grey, // Color for unselected items

        // make it active when selected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });
          
          if (index == 0) {
            // navigate to the shop screen
            context.pushNamed(AppRouter.shop.name);
          } else if(index==1){
            // navigate to the cart screen
            context.pushNamed(AppRouter.cart.name);
          }else{
            // navigate to the favorites screen
            context.pushNamed(AppRouter.favorites.name);
          }
        },
      ),
    );
  }
}
