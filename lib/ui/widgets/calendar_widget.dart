import 'package:flutter/material.dart';
import 'package:senior_design_pd/ui/shared/ui_helpers.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../utils.dart';

class TableBasicsExample extends StatefulWidget {
  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {

  ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([]);
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime _rangeStart;
  DateTime _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Event>(

            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                int isCompleted = 0;
                events.forEach((element) {if(element.completed)isCompleted++;});
                if (isCompleted == events.length) {
                  isCompleted = 0;
                  return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                  );
                }
                else if (isCompleted > 0) {
                  isCompleted = 0;
                  return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.yellow,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                  );
                }
                isCompleted = 0;
                return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 6.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 2
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                  );
              },
            ),
          ),
          verticalSpaceSmall,
          const SizedBox(height: 8.0),
          Container(
            height: 200.0,
            width: 300.0,
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => {
                          value[index].completed = !value[index].completed,
                        },
                        title: Text('${value[index]}'),
                        trailing: value[index].completed ?
                          Icon(
                            Icons.check,
                            color: Colors.green
                          ) : Icon(
                            Icons.cancel,
                            color: Colors.red
                          )
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
      ); 
  }
}