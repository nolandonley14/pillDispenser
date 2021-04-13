import 'package:senior_design_pd/ui/shared/ui_helpers.dart';
import 'package:senior_design_pd/ui/widgets/busy_button.dart';
import 'package:senior_design_pd/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:senior_design_pd/viewmodels/add_medication_view_model.dart';

class AddMedication extends StatefulWidget {
  @override
  _AddMedicationState createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final nameController = TextEditingController();
  String _currentSelectedFrequency = "Daily";
  var curTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddMedicationViewModel>.reactive(
      viewModelBuilder: () => AddMedicationViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add new medication',
                style: TextStyle(
                  fontSize: 38,
                ),
              ),
              verticalSpaceLarge,
              // TODO: Add additional user data here to save (episode 2)
              InputField(
                placeholder: 'Medication Name',
                controller: nameController,
              ),
              verticalSpaceSmall,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DropdownButton<String>(
                    value: _currentSelectedFrequency,
                    items: [
                      DropdownMenuItem(
                        child: Text("Daily"),
                        value: "Daily",
                      ),
                      DropdownMenuItem(
                        child: Text("Twice a Day"),
                        value: "Bi-Daily",
                      ),
                      DropdownMenuItem(
                        child: Text("Weekly"),
                        value: "Weekly",
                      ),
                      DropdownMenuItem(
                        child: Text("Bi-Weekly"),
                        value: "Bi-Weekly",
                      ),
                      DropdownMenuItem(
                        child: Text("Monthly"),
                        value: "Monthly",
                      ),
                    ],
                    onChanged: (value) {
                      setState(() { 
                        _currentSelectedFrequency = value;
                      });
                    },
                  ),
                  horizontalSpaceMedium,
                  TextButton(
                    child: Text(
                      (curTime.hour % 12 == 0 ? "12" : (curTime.hour%12).toString()) + ':' + curTime.minute.toString() + " " + (curTime.hour < 13 ? "AM" : "PM"),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                      ),
                    ),
                    onPressed: () async {
                      var tmp = await showTimePicker(
                        context: context,
                        initialTime: curTime
                      );
                      setState(() {
                        curTime = tmp;
                      });
                    }
                  ),
                ],
              ),
              verticalSpaceMedium,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BusyButton(
                    title: 'Cancel',
                    onPressed: () {

                      model.returnToHomeScreen();
                    },
                  ),
                  horizontalSpaceSmall,
                  BusyButton(
                    title: 'Add New Medication',
                    busy: model.busy,
                    onPressed: () {

                      model.addMedication(nameController.text, _currentSelectedFrequency);
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
