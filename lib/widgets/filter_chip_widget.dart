import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const FilterChipWidget({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          title,
          style: TextStyle(color: selected ? Colors.white : Colors.black),
        ),
        selected: selected,
        selectedColor: Colors.black,
        backgroundColor: Colors.white,
        onSelected: (_) => onTap(),
      ),
    );
  }
}
