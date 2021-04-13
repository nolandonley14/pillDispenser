import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:senior_design_pd/models/user.dart';
import 'package:senior_design_pd/services/firestore_service.dart';
import 'package:senior_design_pd/services/notification_service.dart';
import 'package:senior_design_pd/ui/shared/ui_helpers.dart';
import 'package:senior_design_pd/ui/widgets/busy_button.dart';
import 'package:senior_design_pd/ui/widgets/calendar_widget.dart';
import 'package:senior_design_pd/viewmodels/home_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.handleHomeViewLogic(),
      builder: (context, model, child) {

        bool hasDevice = model.hasDevice();
        String name = model.getName().split(" ")[0];

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            foregroundColor: Colors.white,
            title: Text(
              'Welcome ' + name,
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white
                ),
                onPressed: () {
                  model.signOut();
                },
              )
            ],
          ),
          body: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getWidgets(hasDevice, model),
              ],
            ),
          ),
        );
    });
  }

  // final List<String> entries = <String>['A', 'B', 'C'];
  // final List<int> colorCodes = <int>[600, 500, 100];

    Widget getWidgets(bool hasD, HomeViewModel model) {
      if (hasD)
      return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            TableBasicsExample(),
            verticalSpaceLarge,
            BusyButton(
              title: 'Add a medication',
              busy: model.busy,
              onPressed: () {
                model.navigateToAddMed();
              },
            ),
          ],
        ); 

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BusyButton(
            title: "Set Up New Device",
            busy: model.busy,
            onPressed: () => model.navigateToFindDevices(),
          ),
          verticalSpaceSmall,
          BusyButton(
            title: 'Sign Out',
            busy: model.busy,
            onPressed: () {
              model.signOut();
              model.navigateToLogin();
            },
          ),
        ]
      );
    }
  }


                // Card(
                //   clipBehavior: Clip.antiAlias,
                //   margin: const EdgeInsets.all(8.0),
                //   child: TableCalendar(
                //     firstDay: kFirstDay,
                //     lastDay: kLastDay,
                //     focusedDay: _focusedDay,
                //     weekendDays: [6],
                //     headerStyle: HeaderStyle(
                //       decoration: BoxDecoration(
                //         color: Colors.red,
                //       ),
                //       headerMargin: const EdgeInsets.only(bottom: 8),
                //       titleTextStyle: TextStyle(
                //         color: Colors.white,
                //         fontSize: 18.0,
                //       ),
                //       formatButtonTextStyle: TextStyle(
                //         color: Colors.white,
                //       ),
                //       formatButtonDecoration: BoxDecoration(
                //         border: Border.all(color: Colors.white),
                //         borderRadius: BorderRadius.circular(12.0),
                //       ),
                //       leftChevronIcon: Icon(
                //         Icons.chevron_left,
                //         color: Colors.white,
                //       ),
                //       rightChevronIcon: Icon(
                //         Icons.chevron_right,
                //         color: Colors.white,
                //       ),
                //     ),
                //   ),
                // ),
                // StreamBuilder(
                //   stream: medsDBS.streamQueryList(
                //     args: [
                //       QueryArgsV2('id',
                //           isEqualTo: model.getId(),
                //       )
                //     ],
                //   ),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasError) {
                //       return Container(
                //         child: Text("Error"),
                //       );
                //     }
                //     if (snapshot.hasData) {
                //       List<UserMedication> events = snapshot.data;
                //       events.forEach((element) {print(element.name); });
                //       return ListView.builder(
                //         itemCount: events.length,
                //         shrinkWrap: true,
                //         physics: NeverScrollableScrollPhysics(),
                //         itemBuilder: (BuildContext context, int index) {
                //           final event = events[index];
                //           return ListTile(
                //             title: Text(event.name),
                //             trailing: IconButton(
                //               icon: Icon(Icons.edit),
                //               onPressed: () {},
                //             ),
                //             subtitle: Text(event.frequency),
                //             onTap: () {},
                //           );
                //         },
                //       );
                //     }
                //     return CircularProgressIndicator();
                //   },
                // ),