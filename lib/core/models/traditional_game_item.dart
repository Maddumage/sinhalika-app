// ─────────────────────────────────────────────────────────────────────────────
// TraditionalGameItem — data model for Sri Lankan traditional cultural items
// ─────────────────────────────────────────────────────────────────────────────

enum GameCategory {
  games, // ක්‍රීඩා
  arts, // කලා
  food, // ආහාර
  dance, // නැටුම්
  ritual, // චාරිත්‍ර
}

class TraditionalGameItem {
  const TraditionalGameItem({
    required this.id,
    required this.titleSinhala,
    required this.titleEnglish,
    required this.descriptionSinhala,
    required this.category,
    required this.viewCount,
    required this.isFeatured,
    this.imageAsset,
  });

  final String id;
  final String titleSinhala;
  final String titleEnglish;
  final String descriptionSinhala;
  final GameCategory category;
  final int viewCount;
  final bool isFeatured;
  final String? imageAsset;

  String get categoryLabelSinhala {
    switch (category) {
      case GameCategory.games:
        return 'ක්‍රීඩා';
      case GameCategory.arts:
        return 'කලා';
      case GameCategory.food:
        return 'ආහාර';
      case GameCategory.dance:
        return 'නැටුම්';
      case GameCategory.ritual:
        return 'චාරිත්‍ර';
    }
  }

  String get viewCountLabel {
    if (viewCount >= 1000) {
      final k = viewCount / 1000;
      return '${k.toStringAsFixed(k == k.truncateToDouble() ? 0 : 1)}k';
    }
    return viewCount.toString();
  }
}
