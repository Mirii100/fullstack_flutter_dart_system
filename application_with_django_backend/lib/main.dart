import 'package:application_with_django_backend/providers/auth_providers.dart';
import 'package:application_with_django_backend/providers/category_provider.dart';
import 'package:application_with_django_backend/providers/item_prov.dart';
import 'package:application_with_django_backend/providers/order_provider.dart';
import 'package:application_with_django_backend/screens/auth/login_screen.dart';
import 'package:application_with_django_backend/screens/auth/register_screen.dart';
import 'package:application_with_django_backend/screens/home/home_screen.dart';
import 'package:application_with_django_backend/screens/items/item-details.dart';
import 'package:application_with_django_backend/screens/items/item_list.dart';
import 'package:application_with_django_backend/screens/items/my_items.dart';
import 'package:application_with_django_backend/screens/order/cart_screen.dart';
import 'package:application_with_django_backend/screens/order/checkout_screen.dart';
import 'package:application_with_django_backend/screens/order/order-history.dart';
import 'package:application_with_django_backend/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import 'package:application_with_django_backend/screens/notification/notification_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MarketplaceApp());
}

class MarketplaceApp extends StatelessWidget {
  const MarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Marketplace App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthWrapper(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/items': (context) => const ItemListScreen(),
          '/item_detail': (context) => ItemDetailScreen(
            itemId: ModalRoute.of(context)!.settings.arguments as int,
          ),
          '/my_items': (context) => const MyItemsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/order_history': (context) => const OrderHistoryScreen(),
          '/notifications': (context) => const NotificationScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return authProvider.isAuthenticated ? const HomeScreen() : const LoginScreen();
  }
}