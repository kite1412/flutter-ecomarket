import 'package:flutter/material.dart';
import 'dart:io';

class ProductCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String price;
  final String? subtitle;
  final int? quantity;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.subtitle,
    this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final soldOut = (quantity ?? 1) == 0;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Opacity(
            opacity: soldOut ? 0.55 : 1.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Container
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Container(
                    height: 100, // reduced to prevent overflow
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: imageUrl == null
                        ? Container(
                            color: Colors.grey[300],
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey[500],
                            ),
                          )
                        : (imageUrl!.startsWith('http')
                            ? Image.network(
                                imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey[500],
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                File(imageUrl!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.grey[500],
                                    ),
                                  );
                                },
                              )),
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: soldOut ? Colors.grey[500] : Colors.green[700],
                          decoration: soldOut ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      // Removed inline 'Habis' label to save vertical space; badge already indicates sold out.
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (soldOut)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'HABIS',
                style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
      ],
    );
  }
}
