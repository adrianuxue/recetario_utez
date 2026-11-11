import 'package:flutter/material.dart';
import 'package:recetario_utez/app.dart';
import 'package:recetario_utez/datos/cliente_http.dart';
import 'package:recetario_utez/datos/dummyjson_repositorio.dart';

void main() {
  final dio = crearDioRecetas();
  runApp(AppRecetario(repositorio: DummyJsonRepositorio(dio)));
}
