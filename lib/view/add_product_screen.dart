import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:sizer/sizer.dart';
import 'package:veregood_flutter/components/snack_bar_widget.dart';
import 'package:veregood_flutter/components/textfield_widget.dart';
import 'package:veregood_flutter/constant/color_const.dart';
import 'package:veregood_flutter/main.dart';
import 'package:veregood_flutter/model/product_model.dart';
import 'package:veregood_flutter/view/product_screen.dart';
import '../constant/text_const.dart';
import '../controller/add_variation_controller.dart';

class AddProductScreen extends StatefulWidget {
  final bool isVariationVisible;

  const AddProductScreen({super.key, this.isVariationVisible = false});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final title = TextEditingController();
  final chooseCategory = TextEditingController();
  final productDescription = TextEditingController();
  final quantity = TextEditingController();
  final price = TextEditingController();
  final variationGroupName = TextEditingController();
  final titleDialog = TextEditingController();
  final uom = TextEditingController();
  final priceDialog = TextEditingController();
  final pickerDialog = ImagePicker();

  List<XFile> variationCoverImage = [];

  List<String> selectedImages = [];
  AddVariationController _addVariationController =
      Get.put(AddVariationController());

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
    _addVariationController.listOfVariation.clear();
    productBox = Hive.box<ProductModel>(productBoxName);
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
                                child: coverImage == null
                                    ? Center(
                                        child: Text(
                                          TextConst.coverImage,
                                          style: TextStyle(
                                              color: greyColor2,
                                              fontSize: 13.sp),
                                        ),
                                      )
                                    : Image.file(
                                        coverImage!,
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
                                  controller: title),
                              SizedBox(
                                height: 2.h,
                              ),
                              TextFieldWidget(
                                  hintText: TextConst.chooseCategory,
                                  controller: chooseCategory),
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
                      controller: quantity,
                      keyBoardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    TextFieldWidget(
                      hintText: TextConst.price,
                      controller: price,
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
                              additionalPhoto.length,
                              (index) => Container(
                                margin: EdgeInsets.only(right: 3.w),
                                height: 51.sp,
                                width: 51.sp,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: additionalPhoto[index]
                                        .path
                                        .toString()
                                        .isEmpty
                                    ? Center(
                                        child: Text(
                                          TextConst.image,
                                          style: TextStyle(
                                              color: greyColor2,
                                              fontSize: 11.sp),
                                        ),
                                      )
                                    : Image.file(
                                        File(additionalPhoto[index].path),
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
                          GetBuilder<AddVariationController>(
                            builder: (controller) {
                              return controller.addVariation.length == 0
                                  ? SizedBox()
                                  : Container(
                                      height: 95.sp,
                                      width: double.infinity,
                                      color: Colors.white,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 4.w, right: 4.w, top: 3.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.addVariation[0]
                                                      ['title']
                                                  .toString(),
                                              style: TextStyle(
                                                color: greyColor3,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            controller.listOfVariation.length ==
                                                    0
                                                ? SizedBox()
                                                : Row(
                                                    children: List.generate(
                                                      controller.listOfVariation
                                                          .length,
                                                      (index) => Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 3.w),
                                                        child: CircleAvatar(
                                                          radius: 18.sp,
                                                          backgroundImage:
                                                              FileImage(
                                                            File(
                                                              controller
                                                                      .listOfVariation[
                                                                  index],
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              greyColor3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          firstDialog(context),
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
                          if (coverImage != null &&
                              title.text.isNotEmpty &&
                              chooseCategory.text.isNotEmpty &&
                              productDescription.text.isNotEmpty &&
                              quantity.text.isNotEmpty &&
                              price.text.isNotEmpty &&
                              additionalPhoto.length.toString().isNotEmpty) {
                            ProductModel model = ProductModel(
                                variation: _addVariationController.addVariation,
                                coverImage: coverImage!.path,
                                title: title.text,
                                chooseCategory: chooseCategory.text,
                                productDescription: productDescription.text,
                                quantity: quantity.text,
                                price: price.text,
                                availableColours: ['0xffffff'],
                                listOfImage: images,
                                isApproved: false);

                            productBox!.add(model).then((value) {
                              if (value.toString().isNotEmpty) {
                                Navigator.pop(context);
                              } else {
                                CommonSnackBar.getSnackBar(
                                    context: context, message: "Failed");
                              }
                            });
                          } else {
                            CommonSnackBar.getSnackBar(
                                context: context,
                                message:
                                    "Please enter all the required fields");
                          }
                        },
                        child: Container(
                          height: 45.sp,
                          width: 100.sp,
                          color: greenColor,
                          child: Center(
                            child: Text(
                              TextConst.add,
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

  GestureDetector firstDialog(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: blueColor1,
              insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          TextConst.createNewVariation,
                          style:
                              TextStyle(color: Colors.black, fontSize: 13.sp),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            'assets/images/close.svg',
                            height: 27.sp,
                            width: 27.sp,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    TextFieldWidget(
                        hintText: TextConst.variationGroupName,
                        controller: variationGroupName),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          'assets/images/check-square.svg',
                          height: 27.sp,
                          width: 27.sp,
                        ),
                        Text(
                          TextConst.variationGroupName,
                          style:
                              TextStyle(color: Colors.black, fontSize: 13.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (variationGroupName.text.isNotEmpty) {
                          Navigator.pop(context);
                          _addVariationController.listOfVariation.clear();
                          secondDialog(context).then((value) {
                            setState(() {});
                          });
                        } else {
                          CommonSnackBar.getSnackBar(
                              context: context,
                              message: 'Please enter variation group name');
                        }
                      },
                      child: Container(
                        height: 40.sp,
                        width: 80.sp,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            TextConst.submit,
                            style: const TextStyle(
                                color: blueColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                  ],
                ),
              )),
        );
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
    );
  }

  Future<dynamic> secondDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return GetBuilder<AddVariationController>(
            builder: (controller) {
              return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: blueColor1,
                  insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 3.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              TextConst.createNewVariation,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.sp),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(
                                'assets/images/close.svg',
                                height: 27.sp,
                                width: 27.sp,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final List<XFile>? obtainedFile =
                                await picker.pickMultiImage();

                            if (obtainedFile != null) {
                              _addVariationController.listOfVariation.clear();
                              variationCoverImage.addAll(obtainedFile);
                              obtainedFile.forEach((element) {
                                _addVariationController.listOfVariation
                                    .add(element.path);
                              });
                              // variationCoverImage.map((e) {
                              //   selectedImages.add(e.path.toString());
                              // });
                              log('image for variation ${obtainedFile} full ${_addVariationController.listOfVariation}');
                              setState(() {});
                            } else {
                              log('canceled');
                            }
                          },
                          child: Container(
                            height: 51.sp,
                            width: 75.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: RDottedLineBorder.all(
                                  width: 1, color: Colors.grey),
                            ),
                            child: Center(
                              child: controller.listOfVariation.length == 0
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                color: greyColor2,
                                                fontSize: 8.sp),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 5.w),
                                        child: Text(
                                          TextConst.imageUploaded,
                                          style: TextStyle(
                                              color: greenColor,
                                              fontSize: 11.sp),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        TextFieldWidget(
                            hintText: TextConst.title1,
                            controller: titleDialog),
                        SizedBox(
                          height: 3.h,
                        ),
                        TextFieldWidget(
                            hintText: TextConst.uom, controller: uom),
                        SizedBox(
                          height: 3.h,
                        ),
                        TextFieldWidget(
                          hintText: TextConst.price,
                          controller: priceDialog,
                          keyBoardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_addVariationController
                                        .listOfVariation.length !=
                                    0 &&
                                titleDialog.text.isNotEmpty &&
                                uom.text.isNotEmpty &&
                                priceDialog.text.isNotEmpty) {
                              _addVariationController.addVariation.add({
                                'variation_group_name': variationGroupName.text,
                                'image': selectedImages,
                                'title': titleDialog.text,
                                'uom': uom.text,
                                'price': priceDialog.text
                              });
                              Navigator.pop(context);
                            } else {
                              CommonSnackBar.getSnackBar(
                                  context: context,
                                  message:
                                      'Please enter all the required fields');
                            }
                          },
                          child: Container(
                            height: 40.sp,
                            width: 80.sp,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                TextConst.add,
                                style: const TextStyle(
                                    color: blueColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      ),
    ).then((value) {
      if (titleDialog.text.isNotEmpty &&
          uom.text.isNotEmpty &&
          priceDialog.text.isNotEmpty &&
          _addVariationController.listOfVariation.length != 0) {
        titleDialog.clear();
        uom.clear();
        priceDialog.clear();
        variationGroupName.clear();
      } else {
        _addVariationController.listOfVariation.clear();
      }
    });
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
                  TextConst.newProduct,
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

  void selectVariationCoverImage() async {
    final List<XFile>? obtainedFile = await picker.pickMultiImage();

    if (obtainedFile != null) {
      _addVariationController.listOfVariation.clear();
      variationCoverImage.addAll(obtainedFile);
      obtainedFile.forEach((element) {
        _addVariationController.listOfVariation.add(element.path);
      });
      // variationCoverImage.map((e) {
      //   selectedImages.add(e.path.toString());
      // });
      log('image for variation ${obtainedFile} full ${_addVariationController.listOfVariation}');
      setState(() {});
    } else {
      log('canceled');
    }
  }
}
