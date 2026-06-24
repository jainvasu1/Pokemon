import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF2F3F7), // light grey like image
        borderRadius: BorderRadius.circular(8), // pill shape
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => onChanged(value),
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, size: 20, color: Color(0xffB8BEC8)),
          hintText: "Search name or number",
          hintStyle: TextStyle(color: Color(0xffB8BEC8), fontSize: 14),
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
