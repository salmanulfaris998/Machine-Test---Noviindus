import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.label,
    this.isActive = false,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2B0B0B) : const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isActive ? const Color(0xFFFF3B30) : Colors.white24,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFFBBBBBB),
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
