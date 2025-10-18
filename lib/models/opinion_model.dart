import 'user_model.dart';

class Opinion {
  final int id;
  final String opinionText;
  final double estrellas;
  final int usuarioId;
  final User? user;

  Opinion({
    required this.id,
    required this.opinionText,
    required this.estrellas,
    required this.usuarioId,
    this.user,
  });

  factory Opinion.fromJson(Map<String, dynamic> json) {
    return Opinion(
      id: json['id'] ?? 0,
      opinionText: json['opiniontext'] ?? '',
      estrellas: double.tryParse(json['estrellas'].toString()) ?? 0.0,
      usuarioId: json['usuario_id'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'opiniontext': opinionText,
        'estrellas': estrellas,
        'usuario_id': usuarioId,
      };
}
