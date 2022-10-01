import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:veregood_flutter/model/product_model.dart';
import 'package:veregood_flutter/model/product_model_adapter.dart';
import 'package:veregood_flutter/view/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

const String productBoxName = "products";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  Hive.registerAdapter(ProductModelAdapter());
  await Hive.openBox<ProductModel>(productBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'VereGood',
          home: HomePage(),
        );
      },
    );
  }
}
