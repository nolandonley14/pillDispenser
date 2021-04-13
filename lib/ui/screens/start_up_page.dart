import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:senior_design_pd/viewmodels/startup_view_model.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 100,
                child: Image.asset("assets/mvnLogo.png"),
              ),
              SizedBox(height: 30),
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(
                  Color(0xff19c7c1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}