class Dictionary {
  final List<Definitions>? definitions;
  final String? word;
  final String? pronunciation;

  const Dictionary({
    this.definitions,
    this.word,
    this.pronunciation,
  });

  factory Dictionary.fromJson(Map<String, Object?> json) => Dictionary(
        definitions: List<Map<String, Object?>>.from(
          (json['definitions'] ?? []) as List,
        ).map(Definitions.fromJson).toList(),
        word: json['word'] as String?,
        pronunciation: json['pronunciation'] as String?,
      );

  Map<String, Object?> toJson() => {
        'definitions': definitions?.map((e) => e.toJson()).toList() ?? [],
        'word': word,
        'pronunciation': pronunciation,
      };
}

class Definitions {
  final String? type;
  final String? definition;
  final String? example;
  final String? imageUrl;
  final String? emoji;

  const Definitions({
    this.type,
    this.definition,
    this.example,
    this.imageUrl,
    this.emoji,
  });

  factory Definitions.fromJson(Map<String, Object?> json) => Definitions(
        type: json['type'] as String?,
        definition: json['definition'] as String?,
        example: json['example'] as String?,
        imageUrl: json['image_url'] as String?,
        emoji: json['emoji'] as String?,
      );

  Map<String, Object?> toJson() => {
        'type': type,
        'definition': definition,
        'example': example,
        'image_url': imageUrl,
        'emoji': emoji,
      };
}
