import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:sizer/sizer.dart';
import 'package:veregood_flutter/components/textfield_widget.dart';
import 'package:veregood_flutter/constant/color_const.dart';
import 'package:veregood_flutter/main.dart';
import 'package:veregood_flutter/model/product_model.dart';
import 'package:veregood_flutter/view/product_screen.dart';

import '../constant/text_const.dart';

class EditProductScreen extends StatefulWidget {
  final coverImage;
  final title;
  final category;
  final decription;
  final quantity;
  final price;
  final List<String> images;
  final int index;
  final bool isVariationVisible;

  const EditProductScreen(
      {super.key,
      required this.coverImage,
      required this.title,
      required this.category,
      required this.quantity,
      required this.price,
      required this.images,
      this.isVariationVisible = false,
      required this.index,
      this.decription});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  TextEditingController? title;
  TextEditingController? chooseCategory;
  TextEditingController? productDescription;
  TextEditingController? quantity;
  TextEditingController? price;

  bool isApproved = false;

  File? coverImage;

  final picker = ImagePicker();

  void selectCoverImage() async {
    final obtainedFile = await picker.pickImage(source: ImageSource.gallery);

    if (obtainedFile != null) {
      setState(() {
        coverImage = File(obtainedFile.path);
      });
    } else {
      log('canceled');
    }
  }

  List<XFile> additionalPhoto = [];

  List<String> images = [];

  void selectAdditionalPhotos() async {
    final List<XFile>? selectedImages = await picker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      additionalPhoto.addAll(selectedImages);

      selectedImages.map((e) {
        images.add(e.path.toString());
      });
    }
    print("Image List Length:${additionalPhoto.length}");
    setState(() {});
  }

  @override
  void initState() {
    productBox = Hive.box<ProductModel>(productBoxName);
    title = TextEditingController(text: widget.title);
    chooseCategory = TextEditingController(text: widget.category);
    price = TextEditingController(text: widget.price);
    quantity = TextEditingController(text: widget.quantity);
    productDescription = TextEditingController(text: widget.decription);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor3,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              appHeader(),
              SizedBox(
                height: 3.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            selectCoverImage();
                          },
                          child: Container(
                              height: 105.sp,
                              width: 90.sp,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: widget.coverImage == null
                                    ? Center(
                                        child: Text(
                                          TextConst.coverImage,
                                          style: TextStyle(
                                              color: greyColor2,
                                              fontSize: 13.sp),
                                        ),
                                      )
                                    : Image.file(
                                        File(widget.coverImage.toString()),
                                        fit: BoxFit.cover,
                                      ),
                              )),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 52.w,
                          child: Column(
                            children: [
                              TextFieldWidget(
                                  hintText: TextConst.title1,
                                  controller: title!),
                              SizedBox(
                                height: 2.h,
                              ),
                              TextFieldWidget(
                                  hintText: TextConst.chooseCategory,
                                  controller: chooseCategory!),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    SizedBox(
                      height: 130.sp,
                      child: TextFormField(
                        maxLines: 15,
                        controller: productDescription,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: TextConst.description,
                            hintStyle: const TextStyle(color: greyColor2),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    TextFieldWidget(
                      hintText: TextConst.quantity,
                      controller: quantity!,
                      keyBoardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    TextFieldWidget(
                      hintText: TextConst.price,
                      controller: price!,
                      keyBoardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              widget.images.length,
                              (index) => Container(
                                margin: EdgeInsets.only(right: 3.w),
                                height: 51.sp,
                                width: 51.sp,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: widget.images.isEmpty
                                    ? Center(
                                        child: Text(
                                          TextConst.image,
                                          style: TextStyle(
                                              color: greyColor2,
                                              fontSize: 11.sp),
                                        ),
                                      )
                                    : Image.file(
                                        File(widget.images[index] ??
                                            additionalPhoto[index].path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              selectAdditionalPhotos();
                            },
                            child: Container(
                              height: 51.sp,
                              width: 68.sp,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: RDottedLineBorder.all(
                                    width: 1, color: Colors.grey),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/upload_image.png',
                                      height: 15.sp,
                                      width: 15.sp,
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                    Center(
                                      child: Text(
                                        TextConst.uploadImage,
                                        style: TextStyle(
                                            color: greyColor2, fontSize: 8.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isApproved,
                          activeColor: blueColor,
                          onChanged: (bool? value) {
                            setState(() {
                              isApproved = value!;
                            });
                          },
                        ),
                        Text("Approved the Product")
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Visibility(
                      visible: widget.isVariationVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            TextConst.variation,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 10.sp,
                          ),
                          Container(
                            height: 95.sp,
                            width: double.infinity,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 4.w, right: 4.w, top: 3.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Available Colours",
                                    style: TextStyle(
                                      color: greyColor3,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(right: 3.w),
                                        child: CircleAvatar(
                                          backgroundColor: greyColor3,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (context) => Dialog(
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(20),
                              //       ),
                              //       backgroundColor: blueColor1,
                              //       insetPadding:
                              //           EdgeInsets.symmetric(horizontal: 15.w),
                              //       child: CreateVariationDialog()),
                              // );
                            },
                            child: Container(
                              height: 50.sp,
                              width: double.infinity,
                              color: blueColor,
                              child: Center(
                                child: Text(
                                  TextConst.addAnotherVariation,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          ProductModel model = ProductModel(
                            coverImage: coverImage == null
                                ? widget.coverImage
                                : coverImage!.path,
                            title: title!.text.isEmpty
                                ? widget.title
                                : title!.text,
                            chooseCategory: chooseCategory!.text.isEmpty
                                ? widget.category
                                : chooseCategory!.text,
                            productDescription: productDescription!.text.isEmpty
                                ? widget.decription
                                : title!.text,
                            quantity: quantity!.text.isEmpty
                                ? widget.quantity
                                : title!.text,
                            price: price!.text.isEmpty
                                ? widget.price
                                : title!.text,
                            availableColours: ['0xffffff'],
                            listOfImage:
                                images.isEmpty ? widget.images : images,
                            isApproved: isApproved,
                          );

                          productBox!.put(widget.index, model);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 45.sp,
                          width: 100.sp,
                          color: greenColor,
                          child: Center(
                            child: Text(
                              TextConst.edit,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container appHeader() {
    return Container(
      height: 65.sp,
      width: double.infinity,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            height: 3.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                  TextConst.editProduct,
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
        ],
      ),
    );
  }
}
