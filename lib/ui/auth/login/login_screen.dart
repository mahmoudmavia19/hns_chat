import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hns_chat/app/utils/routes/app_routes.dart';
import 'package:hns_chat/app/widgets/costum_text_form.dart';
import 'package:hns_chat/app/widgets/custom_text_password.dart';
import 'package:hns_chat/ui/auth/login/controller/login_controller.dart';
import '../../../app/utils/constants/constant.dart';
import '../../../app/utils/theme/light_theme.dart';
import '../../../app/widgets/custom_btn.dart';

class LoginScreen extends GetWidget<LogInController> {
final GlobalKey<FormState> _key =GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return Scaffold(
          appBar: AppBar(
            title: Text('Login',style: appBarTitleStyle,),
          ),
          body: controller.loading.value? const Center(child: CircularProgressIndicator(),) :_body()

        );
      }
    );
  }

  _body(){
    return Form(
      key: _key,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomTextForm(
                title: 'Email',
                labelText: 'Email',
                onChanged: (p0) {
                  controller.email = p0 ;
                },
                validator:(value) => validateEmail(value),
              ),
              CustomTextPassword(title: 'Password',
                labelText: 'Password',
                onChanged: (p0) {
                controller.password = p0 ;
                },noValidate: true,),
              const SizedBox(height: 20.0,),
              CustomBtn(onPressed: ()  {
                if (_key.currentState!.validate()) {
                    controller.login();

                }
              }, title: 'Login'),
              const SizedBox(height: 20.0,),
              TextButton(onPressed: () {
                Get.toNamed(AppRoutes.registerScreen);
              }, child: const Text('I don\'t have an Account'))
            ],
          ),
        ),
      ),
    );
  }
}

