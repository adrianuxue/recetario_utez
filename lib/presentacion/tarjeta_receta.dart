// Etapa 5 — La tarjeta de una receta.
// Solo dibuja: no sabe de red, de Dio ni de errores.

import 'package:flutter/material.dart';
import 'package:recetario_utez/dominio/receta.dart';

class TarjetaReceta extends StatelessWidget {
  const TarjetaReceta({super.key, required this.receta});

  final Receta receta;

  @override
  Widget build(BuildContext context) {
    final texto = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(receta.nombre, style: texto.titleMedium),
            const SizedBox(height: 4),
            Text('${receta.cocina} · ${receta.dificultad.etiqueta}'),
            Text('Tiempo: ${receta.tiempoTotal} min · '
                'Porciones: ${receta.porciones}'),
            Text('Calificación: ${receta.calificacion.toStringAsFixed(1)}'),
            if (receta.esRapida) ...[
              const SizedBox(height: 8),
              const Chip(label: Text('Rápida')),
            ],
          ],
        ),
      ),
    );
  }
}
