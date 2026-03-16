import 'package:flutter/material.dart';

class Nivel {
  const Nivel({
    required this.id,
    required this.startImage,
    required this.endImage,
    this.height = 200,
    required this.title,
    this.stars = 0,
    this.color = const Color.fromARGB(255, 13, 22, 78),
    this.locked = true,
  });

  final String startImage;
  final String endImage;
  final double height;
  final String title;
  final int stars;
  final Color color;
  final String id;
  final bool locked;

  Nivel copyWith({
    String? id,
    String? startImage,
    String? endImage,
    double? height,
    String? title,
    int? stars,
    Color? color,
    bool? locked,
  }) {
    return Nivel(
      id: id ?? this.id,
      startImage: startImage ?? this.startImage,
      endImage: endImage ?? this.endImage,
      height: height ?? this.height,
      title: title ?? this.title,
      stars: stars ?? this.stars,
      color: color ?? this.color,
      locked: locked ?? this.locked,
    );
  }
}