import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:veregood_flutter/components/select_option_dialog.dart';
import 'package:veregood_flutter/constant/color_const.dart';
import 'package:veregood_flutter/constant/text_const.dart';
import 'package:veregood_flutter/model/product_model.dart';
import 'package:veregood_flutter/view/edit_product_screen.dart';
import '../main.dart';

Box<ProductModel>? productBox;

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

enum ProductFilter { drafts, approved }

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  List<String> items = [
    "DRAFTS",
    "APPROVED",
  ];

  int tabSelected = 0;

  ProductFilter productFilter = ProductFilter.drafts;

  @override
  void initState() {
    productBox = Hive.box<ProductModel>(productBoxName);
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: SafeArea(
        child: Column(
          children: [
            appHeader(),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  draftedProducts(),
                  approvedProducts(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: addButton(context),
    );
  }

  Padding addButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h, right: 4.w),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
              child: const SelectOptionDialog(),
            ),
          );
        },
        child: Container(
          height: 50.sp,
          width: 50.sp,
          decoration: BoxDecoration(
              color: blueColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  blurRadius: 3,
                  spreadRadius: 0.5,
                  offset: const Offset(2, 2),
                ),
              ]),
          child: Icon(
            Icons.add,
            size: 40.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  ValueListenableBuilder<Box<ProductModel>> approvedProducts() {
    return ValueListenableBuilder(
      valueListenable: productBox!.listenable(),
      builder: (context, Box<ProductModel> products, _) {
        List<int> keys = products.keys.cast<int>().toList();
        List<int>? key;
        if (productFilter == ProductFilter.approved) {
          key = products.keys
              .cast<int>()
              .where((element) => products.get(element)!.isApproved!)
              .toList();
        }
        log('====$key');
        try {
          if (products.isNotEmpty) {
            return key!.length == 0
                ? const Center(
                    child: Text("No Products Approved Yet"),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final int key = keys[index];
                      final ProductModel? product = products.get(key);
                      return product!.isApproved == false
                          ? const SizedBox()
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7.w, vertical: 2.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProductScreen(
                                            index: index,
                                            coverImage: product.coverImage,
                                            title: product.title,
                                            category: product.chooseCategory,
                                            decription:
                                                product.productDescription,
                                            quantity: product.quantity,
                                            price: product.price,
                                            images: product.listOfImage!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 110.sp,
                                              width: 100.sp,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                    image: FileImage(
                                                      File(
                                                        product.coverImage
                                                            .toString(),
                                                      ),
                                                    ),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            SizedBox(
                                              width: 45.sp,
                                              child: Center(
                                                child: Text(
                                                  TextConst.sku,
                                                  style: TextStyle(
                                                    color: greyColor1,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "GFK50522515556SS",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 45.sp,
                                                    child: Text(
                                                      TextConst.title,
                                                      style: TextStyle(
                                                        color: greyColor1,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        product.title
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 45.sp,
                                                    child: Text(
                                                      TextConst.category,
                                                      style: TextStyle(
                                                        color: greyColor1,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        product.chooseCategory
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 45.sp,
                                                    child: Text(
                                                      TextConst.productType,
                                                      style: TextStyle(
                                                        color: greyColor1,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        product
                                                            .productDescription
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 5,
                                  color: Colors.white,
                                ),
                              ],
                            );
                    },
                  );
          } else {
            return const Center(
              child: Text("No Products Added Yet"),
            );
          }
        } catch (e) {
          return const Center(
            child: Text("No Products Added Yet"),
          );
        }
      },
    );
  }

  ValueListenableBuilder<Box<ProductModel>> draftedProducts() {
    return ValueListenableBuilder(
      valueListenable: productBox!.listenable(),
      builder: (context, Box<ProductModel> products, _) {
        List<int> keys = products.keys.cast<int>().toList();

        List<int>? key;
        if (productFilter == ProductFilter.drafts) {
          key = products.keys
              .cast<int>()
              .where((element) => products.get(element)!.isApproved!)
              .toList();
        }

        log('==>>$key');
        try {
          if (products.isNotEmpty) {
            return key!.length == products.length
                ? const Center(
                    child: Text("All Product Approved"),
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final int key = keys[index];
                      final ProductModel? product = products.get(key);

                      return product!.isApproved!
                          ? const SizedBox()
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 7.w, vertical: 2.h),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProductScreen(
                                            index: index,
                                            coverImage: product.coverImage,
                                            title: product.title,
                                            category: product.chooseCategory,
                                            decription:
                                                product.productDescription,
                                            quantity: product.quantity,
                                            price: product.price,
                                            images: product.listOfImage!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              height: 110.sp,
                                              width: 100.sp,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                    image: FileImage(
                                                      File(
                                                        product.coverImage
                                                            .toString(),
                                                      ),
                                                    ),
                                                    fit: BoxFit.cover),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            SizedBox(
                                              width: 45.sp,
                                              child: Center(
                                                child: Text(
                                                  TextConst.sku,
                                                  style: TextStyle(
                                                    color: greyColor1,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "GFK50522515556SS",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 45.sp,
                                                    child: Text(
                                                      TextConst.title,
                                                      style: TextStyle(
                                                        color: greyColor1,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        product.title
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 45.sp,
                                                    child: Text(
                                                      TextConst.category,
                                                      style: TextStyle(
                                                        color: greyColor1,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        product.chooseCategory
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 45.sp,
                                                    child: Text(
                                                      TextConst.productType,
                                                      style: TextStyle(
                                                        color: greyColor1,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 3.w,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        product
                                                            .productDescription
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  thickness: 5,
                                  color: Colors.white,
                                ),
                              ],
                            );
                    },
                  );
          } else {
            return const Center(
              child: Text("No Products Added Yet"),
            );
          }
        } catch (e) {
          return const Center(
            child: Text("No Products Added Yet"),
          );
        }
      },
    );
  }

  Container appHeader() {
    return Container(
      height: 145.sp,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                InkResponse(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/images/arrow_back.svg',
                      height: 27.sp,
                      width: 27.sp,
                    )),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  TextConst.product,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 30.sp,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: TabBar(
              onTap: (value) {
                setState(() {
                  tabSelected = value;
                });
                if (value == 0) {
                  productFilter = ProductFilter.drafts;
                } else {
                  productFilter = ProductFilter.approved;
                }
              },
              indicator: const BoxDecoration(color: Colors.transparent),
              controller: tabController,
              tabs: List.generate(
                items.length,
                (index) => Container(
                  height: 40.sp,
                  width: 145.sp,
                  decoration: BoxDecoration(
                    color: tabSelected == index
                        ? const Color(0xff265EAB)
                        : const Color(0xff30B55C),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(
                      items[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
