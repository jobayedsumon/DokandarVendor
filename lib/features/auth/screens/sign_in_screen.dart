import 'package:dokandar_shop/features/auth/controllers/auth_controller.dart';
import 'package:dokandar_shop/features/profile/controllers/profile_controller.dart';
import 'package:dokandar_shop/features/splash/controllers/splash_controller.dart';
import 'package:dokandar_shop/helper/route_helper.dart';
import 'package:dokandar_shop/util/dimensions.dart';
import 'package:dokandar_shop/util/images.dart';
import 'package:dokandar_shop/util/styles.dart';
import 'package:dokandar_shop/common/widgets/custom_button_widget.dart';
import 'package:dokandar_shop/common/widgets/custom_snackbar_widget.dart';
import 'package:dokandar_shop/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = Get.find<AuthController>().getUserNumber();
    _passwordController.text = Get.find<AuthController>().getUserPassword();
    if(Get.find<AuthController>().getUserType() == 'employee'){
      Get.find<AuthController>().changeVendorType(1, isUpdate: false);
    }else{
      Get.find<AuthController>().changeVendorType(0, isUpdate: false);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Center(
            child: SizedBox(
              width: 1170,
              child: GetBuilder<AuthController>(builder: (authController) {

                return Column(children: [

                  Image.asset(Images.logo, width: 200),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Text('sign_in'.tr.toUpperCase(), style: robotoBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  const SizedBox(height: 50),

                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Row(children: [

                      Expanded(
                        child: InkWell(
                          onTap: () => authController.changeVendorType(0),
                          child: Column(children: [

                            Expanded(
                              child: Center(child: Text(
                                'store_owner'.tr,
                                style: robotoMedium.copyWith(color: authController.vendorTypeIndex == 0
                                    ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3)),
                              )),
                            ),

                            Container(
                              height: 2,
                              color: authController.vendorTypeIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent,
                            ),

                          ]),
                        ),
                      ),

                      Expanded(
                        child: InkWell(
                          onTap: () => authController.changeVendorType(1),
                          child: Column(children: [

                            Expanded(
                              child: Center(child: Text(
                                'store_employee'.tr,
                                style: robotoMedium.copyWith(color: authController.vendorTypeIndex == 1
                                    ? Theme.of(context).textTheme.bodyLarge!.color : Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.3)),
                              )),
                            ),

                            Container(
                              height: 2,
                              color: authController.vendorTypeIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent,
                            ),

                          ]),
                        ),
                      ),

                    ]),
                  ),
                  const SizedBox(height: 50),

                  Column(children: [

                    CustomTextFieldWidget(
                      hintText: 'email'.tr,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      nextFocus: _passwordFocus,
                      inputType: TextInputType.emailAddress,
                      prefixImage: Images.mail,
                    ),
                    const SizedBox(height: 20),

                    CustomTextFieldWidget(
                      hintText: 'password'.tr,
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock_outline_rounded,
                      iconSize: 24,
                      isPassword: true,
                      onSubmit: (text) => GetPlatform.isWeb ? _login(authController) : null,
                    ),

                  ]),
                  const SizedBox(height: 10),

                  Row(children: [

                    Expanded(
                      child: ListTile(
                        onTap: () => authController.toggleRememberMe(),
                        leading: Checkbox(
                          activeColor: Theme.of(context).primaryColor,
                          value: authController.isActiveRememberMe,
                          onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                        ),
                        title: Text('remember_me'.tr),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        horizontalTitleGap: 0,
                      ),
                    ),

                    authController.vendorTypeIndex == 1 ? const SizedBox() : TextButton(
                      onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                      child: Text('${'forgot_password'.tr}?'),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  !authController.isLoading ? CustomButtonWidget(
                    buttonText: 'sign_in'.tr,
                    onPressed: () => _login(authController),
                  ) : const Center(child: CircularProgressIndicator()),
                  SizedBox(height: Get.find<SplashController>().configModel != null && Get.find<SplashController>().configModel!.toggleStoreRegistration! ? Dimensions.paddingSizeSmall : 0),

                  Get.find<SplashController>().configModel != null && Get.find<SplashController>().configModel!.toggleStoreRegistration! ? TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1, 40),
                    ),
                    onPressed: () async {
                      Get.toNamed(RouteHelper.getRestaurantRegistrationRoute());
                    },
                    child: RichText(text: TextSpan(children: [
                      TextSpan(text: '${'join_as'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
                      TextSpan(
                        text: 'store'.tr,
                        style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color),
                      ),
                    ])),
                  ) : const SizedBox(),

                ]);
              }),
            ),
          ),
        ),
      )),
    );
  }

  void _login(AuthController authController) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String type = authController.vendorTypeIndex == 0 ? 'owner' : 'employee';
    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else {
      authController.login(email, password, type).then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(email, password, type);
          } else {
            authController.clearUserNumberAndPassword();
          }
          await Get.find<ProfileController>().getProfile();
          Get.offAllNamed(RouteHelper.getInitialRoute());
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
