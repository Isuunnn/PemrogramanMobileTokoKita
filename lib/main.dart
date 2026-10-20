import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/product.dart';
import 'controllers/cart_controller.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

void main() {
  Get.put(CartController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TokoKita',
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MainPage(),
        ),
        GetPage(
          name: '/detail',
          page: () {
            final product = Get.arguments as Product;

            return ProductDetailPage(
              product: product,
            );
          },
        ),
      ],
    );
  }
}