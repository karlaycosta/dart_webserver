class Alimento {
  final int? id; // Chave primária do alimeto
  final String nome; // Nome do alimento
  final double qtdBase; // Quantidade em gramas do alimeto
  final int categoria; // Chave estrangeira da categoria do alimento
  final double proteina; // Quantidade em gramas de proteína
  final double carboidrato; // Quantidade em gramas de carboidrato
  final double gordura; // Quantidade em gramas de gordura
  final double? gSaturada; // Quantidade em gramas de gordura sturada
  final double? gTrans; // Quantidade em gramas de gordura trans
  final double? fibra; // Quantidade em gramas de fibra
  final double? sodio; // Quantidade em miligramas de sódio
  final DateTime criacao; // Data e hora da criação do registro
  final DateTime? atualizacao; // Data e hora da última atualização do registro

  double get calorias {
    final p = proteina == 0 ? 1.0 : proteina;
    final c = carboidrato == 0 ? 1.0 : carboidrato;
    final g = gordura == 0 ? 1.0 : gordura;
    return double.parse(((p + c * 4) + (g * 9)).toStringAsFixed(2));
  }

  String get info {
    return 'Pro: ${proteina}g | Car: ${carboidrato}g | Gor: ${gordura}g';
  }

  Alimento({
    this.id,
    required this.nome,
    this.qtdBase = 100,
    required this.categoria,
    this.proteina = 0,
    this.carboidrato = 0,
    this.gordura = 0,
    this.gSaturada,
    this.gTrans,
    this.fibra,
    this.sodio,
    required this.criacao,
    this.atualizacao,
  });

  Map<String, dynamic> toJson() {
    final res = <String, dynamic>{};
    res.addAll(id != null ? {'id': id} : {});
    res.addAll({
      'nome': nome,
      'qtd_base': qtdBase,
      'categoria': categoria,
      'proteina': proteina,
      'carboidrato': carboidrato,
      'gordura': gordura,
      'g_saturada': gSaturada,
      'g_trans': gTrans,
      'fibra': fibra,
      'sodio': sodio,
      'criacao': criacao.toIso8601String(),
      'atualizacao': atualizacao?.toIso8601String(),
    });
    return res;
  }

  factory Alimento.fromJson(Map<String, dynamic> json) {
    return Alimento(
      id: json['id'],
      nome: json['nome'],
      qtdBase: json['qtd_base'].toDouble(),
      categoria: json['categoria'],
      proteina: json['proteina'].toDouble(),
      carboidrato: json['carboidrato'].toDouble(),
      gordura: json['gordura'].toDouble(),
      gSaturada: json['g_saturada']?.toDouble(),
      gTrans: json['g_trans']?.toDouble(),
      fibra: json['fibra']?.toDouble(),
      sodio: json['sodio']?.toDouble(),
      criacao: DateTime.parse(json['criacao']),
      atualizacao: json['atualizacao'] != null
          ? DateTime.parse(json['atualizacao'])
          : null,
    );
  }

  @override
  String toString() {
    return 'ID: ${id ?? '*'} - $nome\nQuantidade: ${qtdBase}g\nProteina: ${proteina}g\nCarboidrato: ${carboidrato}g\nGordura: ${gordura}g\ng - Saturada: ${gSaturada}g\n - Trans: ${gTrans}g\nFibra: ${fibra}g\nSódio: ${sodio}mg\n';
  }
}
