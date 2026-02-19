// total
import 'package:digital_shop/screens/signup_screen.dart';
import 'package:digital_shop/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/products_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/user_provider.dart';
import 'providers/category_provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/contact_us_screen.dart';

// Admin Screens
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/add_product_screen.dart';
import 'screens/admin/edit_product_screen.dart';
import 'screens/admin/admin_product_list_screen.dart';
import 'screens/manage_categories_screen.dart';
import 'screens/manage_orders_screen.dart';
import 'package:digital_shop/screens/admin/manage_user_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userProvider = UserProvider();
  final productProvider = ProductProvider();
  final categoryProvider = CategoryProvider();

  await userProvider.loadUserData();
  await productProvider.loadProducts();
  await categoryProvider.loadCategories();

  runApp(MyApp(
    productProvider: productProvider,
    categoryProvider: categoryProvider,
    userProvider: userProvider,
  ));
}

class MyApp extends StatelessWidget {
  final ProductProvider productProvider;
  final CategoryProvider categoryProvider;
  final UserProvider userProvider;

  const MyApp({
    Key? key,
    required this.productProvider,
    required this.categoryProvider,
    required this.userProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
        ChangeNotifierProvider<CategoryProvider>.value(value: categoryProvider),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'فروشگاه دیجیتال',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          fontFamily: 'Vazir',
          scaffoldBackgroundColor: const Color(0xFFFDF6F0),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
        ),
        home: SplashScreen(),
        locale: const Locale('fa'), // تنظیماات مربوط به پشتیبانی از فارسی
        supportedLocales: const [
          Locale('fa'), // فارسی
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        routes: {
          //  تنظیم روت ها
          '/login': (ctx) => LoginScreen(),
          '/signup': (_) => SignupScreen(),
          // روت ها کاربر
          '/home': (ctx) => HomeScreen(),
          '/cart': (ctx) => const CartScreen(),
          '/orders': (ctx) => const OrdersScreen(),
          '/profile': (ctx) => const ProfileScreen(),
          '/contact': (ctx) => const ContactUsScreen(),
          '/product-detail': (ctx) => const ProductDetailScreen(),

          // روت های مربوط به ادمین
          '/admin': (ctx) => const AdminDashboard(),
          '/add-product': (ctx) => const AddProductScreen(),
          '/manage-categories': (ctx) => const ManageCategoriesScreen(),
          '/manage-orders': (ctx) => const ManageOrdersScreen(),
          '/manage-users': (ctx) => ManageUsersScreen(),
          '/admin-product-list': (ctx) => const AdminProductListScreen(),

          UserProfileScreen.routeName: (_) => UserProfileScreen(),
        },
      ),
    );
  }
}
