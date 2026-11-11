// Etapa 5 — La raíz de la app: aquí se arma todo.
// Único lugar (junto con main.dart) que decide con qué repositorio trabaja
// la aplicación; las vistas nunca lo importan.

import 'package:flutter/material.dart';
import 'package:recetario_utez/datos/recetas_repositorio.dart';
import 'package:recetario_utez/presentacion/recetas_pagina.dart';
import 'package:recetario_utez/presentacion/recetas_view_model.dart';

class AppRecetario extends StatefulWidget {
  const AppRecetario({super.key, required this.repositorio});

  /// El contrato que usará la app: en producción el repositorio real, en
  /// pruebas uno falso. La app no sabe cuál es.
  final RecetasRepositorio repositorio;

  @override
  State<AppRecetario> createState() => _AppRecetarioState();
}

class _AppRecetarioState extends State<AppRecetario> {
  late final RecetasViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = RecetasViewModel(widget.repositorio);
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetario UTEZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: RecetasPagina(vm: _vm),
    );
  }
}
