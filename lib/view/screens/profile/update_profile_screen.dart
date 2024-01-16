import 'dart:io';

import 'package:efood_multivendor_driver/controller/auth_controller.dart';
import 'package:efood_multivendor_driver/controller/splash_controller.dart';
import 'package:efood_multivendor_driver/data/model/response/profile_model.dart';
import 'package:efood_multivendor_driver/util/dimensions.dart';
import 'package:efood_multivendor_driver/util/images.dart';
import 'package:efood_multivendor_driver/util/styles.dart';
import 'package:efood_multivendor_driver/view/base/custom_button.dart';
import 'package:efood_multivendor_driver/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_driver/view/base/custom_text_field.dart';
import 'package:efood_multivendor_driver/view/base/my_text_field.dart';
import 'package:efood_multivendor_driver/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatefulWidget {
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }
    Get.find<AuthController>().initData();
  }
  final double circleRadius = 100.0;
  final double circleBorderWidth = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<AuthController>(builder: (authController) {
        if(authController.profileModel != null && _firstNameController.text.isEmpty) {
          _firstNameController.text = authController.profileModel.fName ?? '';
          _lastNameController.text = authController.profileModel.lName ?? '';
          _phoneController.text = authController.profileModel.phone ?? '';
          _emailController.text = authController.profileModel.email ?? '';
        }

        // return authController.profileModel != null ? ProfileBgWidget(
        //   backButton: true,
        //   circularImage: Center(child: Stack(children: [
        //     ClipOval(child: authController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
        //       authController.pickedFile.path, width: 100, height: 100, fit: BoxFit.cover,
        //     ) : Image.file(
        //       File(authController.pickedFile.path), width: 100, height: 100, fit: BoxFit.cover,
        //     ) : FadeInImage.assetNetwork(
        //       placeholder: Images.placeholder,
        //       image: '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}/${authController.profileModel.image}',
        //       height: 100, width: 100, fit: BoxFit.cover,
        //       imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
        //     )),
        //     Positioned(
        //       bottom: 0, right: 0, top: 0, left: 0,
        //       child: InkWell(
        //         onTap: () => authController.pickImage(),
        //         child: Container(
        //           decoration: BoxDecoration(
        //             color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
        //             border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        //           ),
        //           child: Container(
        //             margin: EdgeInsets.all(25),
        //             decoration: BoxDecoration(
        //               border: Border.all(width: 2, color: Colors.white),
        //               shape: BoxShape.circle,
        //             ),
        //             child: Icon(Icons.camera_alt, color: Colors.white),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ])),
        //   mainWidget: Column(children: [
        //
        //     Expanded(child: Scrollbar(child: SingleChildScrollView(
        //       physics: BouncingScrollPhysics(),
        //       padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        //       child: Center(child: SizedBox(width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //
        //         Text(
        //           'first_name'.tr,
        //           style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
        //         ),
        //         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //         MyTextField(
        //           hintText: 'first_name'.tr,
        //           controller: _firstNameController,
        //           focusNode: _firstNameFocus,
        //           nextFocus: _lastNameFocus,
        //           inputType: TextInputType.name,
        //           capitalization: TextCapitalization.words,
        //         ),
        //         SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        //
        //         Text(
        //           'last_name'.tr,
        //           style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
        //         ),
        //         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //         MyTextField(
        //           hintText: 'last_name'.tr,
        //           controller: _lastNameController,
        //           focusNode: _lastNameFocus,
        //           nextFocus: _emailFocus,
        //           inputType: TextInputType.name,
        //           capitalization: TextCapitalization.words,
        //         ),
        //         SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        //
        //         Text(
        //           'email'.tr,
        //           style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
        //         ),
        //         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //         MyTextField(
        //           hintText: 'email'.tr,
        //           controller: _emailController,
        //           focusNode: _emailFocus,
        //           inputAction: TextInputAction.done,
        //           inputType: TextInputType.emailAddress,
        //         ),
        //         SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
        //
        //         Row(children: [
        //           Text(
        //             'phone'.tr,
        //             style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor),
        //           ),
        //           SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //           Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
        //             fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).errorColor,
        //           )),
        //         ]),
        //         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //         MyTextField(
        //           hintText: 'phone'.tr,
        //           controller: _phoneController,
        //           focusNode: _phoneFocus,
        //           inputType: TextInputType.phone,
        //           isEnabled: false,
        //         ),
        //
        //       ]))),
        //     ))),
        //
        //     !authController.isLoading ? CustomButton(
        //       onPressed: () => _updateProfile(authController),
        //       margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        //       buttonText: 'update'.tr,
        //     ) : Center(child: CircularProgressIndicator()),
        //
        //   ]),
        // ) : Center(child: CircularProgressIndicator());

        return authController.profileModel !=null ?
        Container(
          // decoration: BoxDecoration(
          //     image:DecorationImage(
          //         image: AssetImage("assets/image/profile_bg_new.png"),
          //         fit: BoxFit.fill
          //     )
          // ),

          child:
          Column(
            children: [

              Align(
                  alignment: Alignment.topLeft,
                  child:
                  Padding(
                    padding: EdgeInsets.fromLTRB(50,50,0,0),
                    child: Text('Account'.tr,style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20,fontWeight: FontWeight.bold),),
                  )

              ),
              Column(
                // alignment: Alignment.topCenter,
                children: [
                  ClipOval(child: authController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                    authController.pickedFile.path, width: 100, height: 100, fit: BoxFit.cover,
                  ) : Image.file(
                    File(authController.pickedFile.path), width: 100, height: 100, fit: BoxFit.cover,
                  ) : FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    image: '${Get.find<SplashController>().configModel.baseUrls?.deliveryManImageUrl}/${authController.profileModel.image}',
                    height: 100, width: 100, fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
                  )),


                  Padding(padding: EdgeInsets.all(20),
                  child: Text('Enter Your Personal Information And  Then Click On The Save Button Below',style: TextStyle(color: Colors.black38,fontSize: 13),textAlign: TextAlign.center),
                  ),
                  Center(
                    child:
                    Container(
                        margin: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 300] ??Color(0xFF000000), blurRadius: 5, spreadRadius: 1)],
                            color: Colors.white
                        ),
                        padding:EdgeInsets.only(top:10,left: 5,right: 5,bottom: 5),
                        child:
//             Scrollbar(child: SingleChildScrollView(
//               physics: BouncingScrollPhysics(),
//               padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//               child:
// ,
//             ))
                        Center(child: Container(
                            padding:EdgeInsets.all(10),
                            width: 1170, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


                          // SizedBox(height: 30,),
                          CustomTextField(
                            hintText: 'first_name'.tr,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            inputType: TextInputType.name,
                            capitalization:TextCapitalization.words,
                            prefixIcon: Images.user,
                          ),
                          // MyTextField(
                          //   hintText: 'first_name'.tr,
                          //   controller: _firstNameController,
                          //   focusNode: _firstNameFocus,
                          //   nextFocus: _lastNameFocus,
                          //   inputType: TextInputType.name,
                          //   capitalization: TextCapitalization.words,
                          // ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // MyTextField(
                          //   hintText: 'last_name'.tr,
                          //   controller: _lastNameController,
                          //   focusNode: _lastNameFocus,
                          //   nextFocus: _phoneFocus,
                          //   inputType: TextInputType.name,
                          //   capitalization: TextCapitalization.words,
                          // ),
                          CustomTextField(
                            hintText: 'last_name'.tr,
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            nextFocus: _phoneFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                            prefixIcon:Images.user,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // MyTextField(
                          //   hintText: 'phone'.tr,
                          //   controller: _phoneController,
                          //   focusNode: _phoneFocus,
                          //   inputType: TextInputType.phone,
                          //   inputAction: TextInputAction.done,
                          // ),
                          CustomTextField(
                            hintText: 'phone'.tr,
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            inputType: TextInputType.phone,
                            inputAction: TextInputAction.done,
                            prefixIcon: Images.call,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // MyTextField(
                          //   hintText: 'email'.tr,
                          //   controller: _emailController,
                          //   focusNode: _emailFocus,
                          //   inputAction: TextInputAction.done,
                          //   inputType: TextInputType.emailAddress,
                          //   isEnabled: false,
                          // ),
                          CustomTextField(
                            hintText: 'email'.tr,
                            controller: _emailController,
                            focusNode: _emailFocus,
                            inputAction: TextInputAction.done,
                            inputType: TextInputType.emailAddress,
                            isEnabled: false,
                            prefixIcon: Images.mail,
                          ),

                        ])
                        ))
                    ),

                  ),
                  !authController.isLoading ?
                      Align(
                        alignment: Alignment.bottomRight,
                        child:
                        CustomButton(
                          width: 20,
                          onPressed: () => _updateProfile(authController),
                          margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          buttonText: 'update'.tr,
                        ),
                      ) : Center(child: CircularProgressIndicator())
                  // Center(child: Stack(children: [
                  //   ClipOval(child: authController.pickedFile != null ? GetPlatform.isWeb ? Image.network(
                  //     authController.pickedFile.path, width: 100, height: 100, fit: BoxFit.cover,
                  //   ) : Image.file(
                  //     File(authController.pickedFile.path), width: 100, height: 100, fit: BoxFit.cover,
                  //   ) : FadeInImage.assetNetwork(
                  //     placeholder: Images.placeholder,
                  //     image: '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}/${authController.profileModel.image}',
                  //     height: 100, width: 100, fit: BoxFit.cover,
                  //     imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
                  //   )),
                  //   Positioned(
                  //     bottom: 0, right: 0, top: 0, left: 0,
                  //     child: InkWell(
                  //       onTap: () => authController.pickImage(),
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           color: Colors.black.withOpacity(0.3), shape: BoxShape.circle,
                  //           border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                  //         ),
                  //         child: Container(
                  //           margin: EdgeInsets.all(25),
                  //           decoration: BoxDecoration(
                  //             border: Border.all(width: 2, color: Colors.white),
                  //             shape: BoxShape.circle,
                  //           ),
                  //           child: Icon(Icons.camera_alt, color: Colors.white),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ]))
                ],
              )
            ],
          )
          ,
        ):Center(child: CircularProgressIndicator());

      }),

    );
  }

  void _updateProfile(AuthController authController) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _phoneNumber = _phoneController.text.trim();
    if (authController.profileModel.fName == _firstName &&
        authController.profileModel.lName == _lastName && authController.profileModel.phone == _phoneNumber &&
        authController.profileModel.email == _emailController.text && authController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    }else if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    }else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (_phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (_phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      ProfileModel _updatedUser = ProfileModel(fName: _firstName, lName: _lastName, email: _email, phone: _phoneNumber);
      bool _isSuccess = await authController.updateUserInfo(_updatedUser, Get.find<AuthController>().getUserToken());
      if(_isSuccess) {
        authController.getProfile();
      }
    }
  }
}
