// Etapa 1 — Dominio: Dart puro.
// Ni Flutter, ni Dio, ni JSON: aquí solo viven las reglas del negocio.

/// Minutos totales a partir de los cuales una receta deja de ser "rápida".
const int umbralRapidaMinutos = 30;

/// Dificultad de la receta, con su etiqueta lista para mostrar.
enum Dificultad {
  facil('Fácil'),
  media('Media'),
  dificil('Difícil'),
  desconocida('Sin dato');

  const Dificultad(this.etiqueta);

  final String etiqueta;
}

class Receta {
  const Receta({
    required this.id,
    required this.nombre,
    required this.cocina,
    required this.dificultad,
    required this.minutosPreparacion,
    required this.minutosCoccion,
    required this.porciones,
    required this.calificacion,
    this.etiquetas = const [],
    this.ingredientes = const [],
  });

  final int id;
  final String nombre;
  final String cocina;
  final Dificultad dificultad;
  final int minutosPreparacion;
  final int minutosCoccion;
  final int porciones;
  final double calificacion;
  final List<String> etiquetas;
  final List<String> ingredientes;

  /// Preparación + cocción, en minutos.
  int get tiempoTotal => minutosPreparacion + minutosCoccion;

  /// Una receta es rápida si no supera el umbral.
  bool get esRapida => tiempoTotal <= umbralRapidaMinutos;
}

/// Una página de resultados: lo que vino y cuántas recetas hay en total.
class PaginaRecetas {
  const PaginaRecetas({required this.recetas, required this.total});

  final List<Receta> recetas;
  final int total;
}


