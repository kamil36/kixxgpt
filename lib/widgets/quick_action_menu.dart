import 'package:flutter/material.dart';

class QuickActionMenu extends StatelessWidget {
  final VoidCallback onPhotos;
  final VoidCallback onCamera;
  final VoidCallback onFiles;
  final VoidCallback onCreateImage;

  const QuickActionMenu({
    super.key,
    required this.onPhotos,
    required this.onCamera,
    required this.onFiles,
    required this.onCreateImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _ActionButton(
                  icon: Icons.image,
                  label: 'Photos',
                  onTap: onPhotos,
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: onCamera,
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.attach_file,
                  label: 'Files',
                  onTap: onFiles,
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  icon: Icons.image_search,
                  label: 'Create image',
                  onTap: onCreateImage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
