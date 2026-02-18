import 'package:flutter/material.dart';

class AttachedDocument {
  final String name;
  final String type;
  final String path;
  final DateTime addedAt;
  final IconData icon;

  AttachedDocument({
    required this.name,
    required this.type,
    required this.path,
    required this.icon,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();
}

class DocumentManager {
  final List<AttachedDocument> documents = [];

  void addDocument(String name, String type, String path, IconData icon) {
    documents.add(
      AttachedDocument(name: name, type: type, path: path, icon: icon),
    );
  }

  void removeDocument(int index) {
    if (index >= 0 && index < documents.length) {
      documents.removeAt(index);
    }
  }

  void clearDocuments() {
    documents.clear();
  }

  int get count => documents.length;

  List<AttachedDocument> getDocuments() => List.unmodifiable(documents);
}

class DocumentDisplay extends StatelessWidget {
  final List<AttachedDocument> documents;
  final Function(int) onRemove;

  const DocumentDisplay({
    super.key,
    required this.documents,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(documents.length, (index) {
          final doc = documents[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  doc.icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    doc.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => onRemove(index),
                  child: Icon(Icons.close, size: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
