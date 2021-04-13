import 'package:senior_design_pd/ui/shared/ui_helpers.dart';
import 'package:senior_design_pd/ui/widgets/busy_button.dart';
import 'package:senior_design_pd/ui/widgets/input_field.dart';
import 'package:senior_design_pd/ui/widgets/text_link.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:senior_design_pd/viewmodels/login_view_model.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 120,
                  child: Image.asset('assets/mvnLogo.png'),
                ),
                SizedBox(height: 30),
                InputField(
                  placeholder: 'Email',
                  controller: emailController,
                ),
                verticalSpaceSmall,
                InputField(
                  placeholder: 'Password',
                  password: true,
                  controller: passwordController,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BusyButton(
                      title: 'Login',
                      busy: model.busy,
                      onPressed: () {
                        model.signUp(emailController.text, passwordController.text);
                      },
                    ),
                  ],
                ),
                verticalSpaceMedium,
                TextLink(
                  'Create an Account if you\'re new.',
                  onPressed: () {
                    model.navigateToSignUp();
                  },
                )
              ],
            ),
          )),
    );
  }
}
