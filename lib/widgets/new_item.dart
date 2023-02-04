import 'package:lab3_193059/model/list_item.dart';
import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';
import 'package:flutter/widgets.dart';
import 'package:lab3_193059/model/location.dart';

class NovoPolaganje extends StatefulWidget {
  final Function addPolaganje;

  NovoPolaganje(this.addPolaganje);

  @override
  State<StatefulWidget> createState() => _NovoPolaganjeState();
}

class _NovoPolaganjeState extends State<NovoPolaganje> {
  final _imeNaPredmetController = TextEditingController();
  final _datumVremeController = TextEditingController();
  late Location location;
  String defaultValue = 'FINKI';

  void _submitData(BuildContext context) {
    if (_imeNaPredmetController.text.isEmpty ||
        _datumVremeController.text.isEmpty) {
      return;
    }

    int datum = '-'.allMatches(_datumVremeController.text).length;
    int vreme = ':'.allMatches(_datumVremeController.text).length;

    if (_datumVremeController.text.length < 16 || datum != 2 || vreme != 1) {
      print("Date format is invalid!");
      return;
    }

    if (defaultValue == 'FINKI') {
      location = Location(latitude: 42.0043165, longitude: 21.4096452);
    } else if (defaultValue == 'FEIT') {
      location = Location(latitude: 42.004400, longitude: 21.408918);
    } else {
      location = Location(latitude: 42.004906, longitude: 21.409890);
    }

    final String vnesenoImeNaPredmet = _imeNaPredmetController.text;
    final String vnesenDatumIVreme = _datumVremeController.text + ':00';
    DateTime dateTime = DateTime.parse(vnesenDatumIVreme);

    final newExam = ListKolokviumi(
        id: nanoid(5),
        imeNaPredmet: vnesenoImeNaPredmet,
        datumVreme: dateTime,
        lokacija: location);
    widget.addPolaganje(newExam);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: _imeNaPredmetController,
            decoration: InputDecoration(labelText: "Name of the subject"),
            textInputAction: TextInputAction.next,
          ),
          TextField(
            controller: _datumVremeController,
            decoration: InputDecoration(
                labelText: "Date and time, format: 2022-01-01 15:00"),
            textInputAction: TextInputAction.next,
          ),
          // TextField(
          //   controller: _lokacijaController,
          //   decoration: InputDecoration(labelText: "Enter faculty location"),
          //   onSubmitted: (_) => _submitData(),
          // ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  "Lokacija ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              DropdownButton(
                  value: defaultValue,
                  items: <String>['FINKI', 'TMF', 'FEIT']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? novo) {
                    setState(() {
                      defaultValue = novo!;
                    });
                    print("vneseno!");
                    _submitData(context);
                  })
            ],
          ),
        ],
      ),
    );
  }
}
