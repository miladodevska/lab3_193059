import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'location.dart';

class ListKolokviumi {
  final String id;
  final String imeNaPredmet;
  //final String datumVreme;
  final DateTime datumVreme;
  final Location lokacija;

  ListKolokviumi({
    required this.id,
    required this.imeNaPredmet,
    required this.datumVreme,
    required this.lokacija,
  });
}
