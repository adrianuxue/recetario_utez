// Etapa 5 — La pantalla de recetas.
// Escucha al ViewModel y dibuja su estado. No importa de lib/datos y no
// muestra detalles técnicos: solo los textos ya traducidos.

import 'package:flutter/material.dart';
import 'package:recetario_utez/dominio/receta.dart';
import 'package:recetario_utez/presentacion/recetas_view_model.dart';
import 'package:recetario_utez/presentacion/tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  final TextEditingController _control = TextEditingController();

  @override
  void dispose() {
    _control.dispose();
    super.dispose();
  }

  void _buscar() => widget.vm.buscar(_control.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetario UTEZ')),
      body: ListenableBuilder(
        listenable: widget.vm,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const Key('busqueda'),
                  controller: _control,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _buscar(),
                  decoration: const InputDecoration(
                    labelText: 'Receta',
                    hintText: 'pasta, pizza, pollo…',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  key: const Key('buscar'),
                  onPressed: widget.vm.cargando ? null : _buscar,
                  child: const Text('Buscar recetas'),
                ),
                const SizedBox(height: 16),
                Expanded(child: _contenido(context, widget.vm.estado)),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Dibuja el estado actual. El switch es exhaustivo: si mañana aparece un
  /// estado nuevo, el compilador obliga a darle pantalla.
  Widget _contenido(BuildContext context, EstadoRecetas estado) {
    return switch (estado) {
      RecetasInicial() =>
      const Center(
        child: Text('Escribe una receta o déjalo vacío y toca '
            'Buscar recetas.'),
      ),
      RecetasCargando() => const Center(child: CircularProgressIndicator()),
      RecetasListas(:final recetas, :final total) => _listado(recetas, total),
      RecetasVacias(:final busqueda) => Center(
        child: Text(
          busqueda.isEmpty
              ? 'No hay recetas disponibles.'
              : 'No encontramos recetas para "$busqueda".',
        ),
      ),
      RecetasFallidas(:final mensaje) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: widget.vm.reintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    };
  }

  Widget _listado(List<Receta> recetas, int total) {
    return Column(
      children: [
        Text('Mostrando ${recetas.length} de $total recetas · '
            'Rápidas: ${widget.vm.rapidas}'),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: recetas.length,
            itemBuilder: (context, i) => TarjetaReceta(receta: recetas[i]),
          ),
        ),
      ],
    );
  }
}
