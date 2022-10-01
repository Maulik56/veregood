import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:sizer/sizer.dart';
import 'package:veregood_flutter/components/textfield_widget.dart';

import '../constant/color_const.dart';
import '../constant/text_const.dart';

/// First Dialog
class CreateVariationDialog extends StatefulWidget {
  const CreateVariationDialog({Key? key}) : super(key: key);

  @override
  State<CreateVariationDialog> createState() => _CreateVariationDialogState();
}

class _CreateVariationDialogState extends State<CreateVariationDialog> {
  final variationGroupName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
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
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: blueColor1,
                    insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: CreateVariationDialog2()),
              );
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
    );
  }
}

/// Second Dialog
class CreateVariationDialog2 extends StatefulWidget {
  const CreateVariationDialog2({Key? key}) : super(key: key);

  @override
  State<CreateVariationDialog2> createState() => _CreateVariationDialog2State();
}

class _CreateVariationDialog2State extends State<CreateVariationDialog2> {
  final title = TextEditingController();
  final uom = TextEditingController();
  final price = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
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
          Container(
            height: 51.sp,
            width: 75.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              border: RDottedLineBorder.all(width: 1, color: Colors.grey),
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
                      style: TextStyle(color: greyColor2, fontSize: 8.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          TextFieldWidget(hintText: TextConst.title1, controller: title),
          SizedBox(
            height: 3.h,
          ),
          TextFieldWidget(hintText: TextConst.uom, controller: uom),
          SizedBox(
            height: 3.h,
          ),
          TextFieldWidget(hintText: TextConst.price, controller: price),
          SizedBox(
            height: 3.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
    );
  }
}
