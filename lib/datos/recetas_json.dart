// Etapa 2 — Del JSON de DummyJSON a objetos del dominio.
// Aquí se traduce y se valida: lo que no tiene la forma esperada produce
// FormatException, y quien llama decide qué mostrar.

import 'package:recetario_utez/dominio/receta.dart';

/// Easy/Medium/Hard → enum. Cualquier otra cosa (o ausencia) es "Sin dato":
/// una dificultad rara nunca debe tumbar la receta.
Dificultad dificultadDesdeTexto(Object? valor) {
  switch (valor) {
    case 'Easy':
      return Dificultad.facil;
    case 'Medium':
      return Dificultad.media;
    case 'Hard':
      return Dificultad.dificil;
    default:
      return Dificultad.desconocida;
  }
}

/// Campo obligatorio de tipo entero.
int _entero(Map<String, dynamic> json, String campo) {
  final valor = json[campo];
  if (valor is! int) {
    throw FormatException('Falta o no es entero: $campo');
  }
  return valor;
}

/// Campo obligatorio de tipo texto.
String _texto(Map<String, dynamic> json, String campo) {
  final valor = json[campo];
  if (valor is! String) {
    throw FormatException('Falta o no es texto: $campo');
  }
  return valor;
}

/// Campo obligatorio numérico; la API manda `5` y nosotros queremos `5.0`.
double _numerico(Map<String, dynamic> json, String campo) {
  final valor = json[campo];
  if (valor is! num) {
    throw FormatException('Falta o no es numérico: $campo');
  }
  return valor.toDouble();
}

/// Lista opcional de textos: ausente o null → vacía; si existe, debe ser
/// una lista donde todo elemento sea texto.
List<String> _listaDeTextos(Map<String, dynamic> json, String campo) {
  final valor = json[campo];
  if (valor == null) return const [];
  if (valor is! List) {
    throw FormatException('No es una lista: $campo');
  }
  for (final elemento in valor) {
    if (elemento is! String) {
      throw FormatException('Elemento que no es texto en: $campo');
    }
  }
  return List<String>.from(valor);
}

Receta recetaDesdeJson(Map<String, dynamic> json) {
  return Receta(
    id: _entero(json, 'id'),
    nombre: _texto(json, 'name'),
    cocina: _texto(json, 'cuisine'),
    dificultad: dificultadDesdeTexto(json['difficulty']),
    minutosPreparacion: _entero(json, 'prepTimeMinutes'),
    minutosCoccion: _entero(json, 'cookTimeMinutes'),
    porciones: _entero(json, 'servings'),
    calificacion: _numerico(json, 'rating'),
    etiquetas: _listaDeTextos(json, 'tags'),
    ingredientes: _listaDeTextos(json, 'ingredients'),
  );
}

/// Convierte `{"recipes": [...], "total": n}`. Sin resultados es una página
/// vacía, no un error; lo que sí es error es un cuerpo con otra forma.
PaginaRecetas paginaDesdeJson(Map<String, dynamic> json) {
  final recetas = json['recipes'];
  final total = json['total'];
  if (recetas is! List) {
    throw const FormatException('Falta o no es lista: recipes');
  }
  if (total is! int) {
    throw const FormatException('Falta o no es entero: total');
  }

  final lista = <Receta>[];
  for (final item in recetas) {
    if (item is! Map<String, dynamic>) {
      throw const FormatException('Elemento de recipes que no es un objeto');
    }
    lista.add(recetaDesdeJson(item));
  }
  return PaginaRecetas(recetas: lista, total: total);
}
