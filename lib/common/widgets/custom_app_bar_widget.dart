import 'package:dokandar_shop/util/dimensions.dart';
import 'package:dokandar_shop/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Widget? menuWidget;
  final Function? onTap;
  const CustomAppBarWidget({super.key, required this.title, this.isBackButtonExist = true, this.menuWidget, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyLarge!.color)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyLarge!.color,
        onPressed: onTap as void Function()? ?? () => Get.back(),
      ) : const SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      actions: menuWidget != null ? [menuWidget!] : null,
    );
  }

  @override
  Size get preferredSize => Size(1170, GetPlatform.isDesktop ? 70 : 50);
}
