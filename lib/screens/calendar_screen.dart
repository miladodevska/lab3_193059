import 'package:lab3_193059/model/list_item.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget{
  static const String id = "calendarScreen";
  final List<ListKolokviumi> _kolokviumi;

  CalendarScreen(this._kolokviumi);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        body: Container(
          child: SfCalendar(
            view: CalendarView.month,
            dataSource: MeetingDataSource(_getDataSource(_kolokviumi)),
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment
            ),
            firstDayOfWeek: 1,
            showDatePickerButton: true,
          ),
        )
    );
  }
}

List<ListKolokviumi> _getDataSource(List<ListKolokviumi> _kolokviumi) {
  final List<ListKolokviumi> scheduledExams = _kolokviumi;
  return scheduledExams;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<ListKolokviumi> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  DateTime getStartTime(int index){
    return appointments![index].date;
  }
  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

}
