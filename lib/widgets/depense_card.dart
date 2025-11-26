import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/depense.dart';
import '../utils/constants.dart';

class DepenseCard extends StatelessWidget {
  final Depense depense;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const DepenseCard({
    Key? key,
    required this.depense,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final montantColor = colors.error;
    final iconBg = AppConstants.categoryColors[depense.categorie]?.withOpacity(0.15);
    final iconColor = AppConstants.categoryColors[depense.categorie];

    return Material(
      color: colors.surface,
      elevation: 2,
      shadowColor: colors.shadow.withOpacity(0.12),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Icône catégorie ---
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppConstants.categoryIcons[depense.categorie],
                  color: iconColor,
                  size: 26,
                ),
              ),

              const SizedBox(width: 18),

              // --- Titre + détails ---
              Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // --- Titre ---
      Text(
        depense.titre,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
          height: 1.1,
        ),
      ),

      const SizedBox(height: 6),

      // --- Catégorie ---
      Text(
        depense.categorie,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),

      const SizedBox(height: 4),

      // --- Date ---
      Row(
        children: [
          Icon(Icons.calendar_today_outlined, size: 14, color: colors.outline),
          const SizedBox(width: 6),
          Text(
            DateFormat('dd MMM yyyy').format(depense.date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.outline,
            ),
          ),
        ],
      ),
    ],
  ),
),

              const SizedBox(width: 12),

              // --- Montant + bouton delete ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${depense.montant.toStringAsFixed(2)} FCFA',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: montantColor,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),

                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Supprimer'),
                          content: const Text('Voulez-vous supprimer cette dépense ?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Annuler'),
                            ),
                            TextButton(
                              onPressed: () {
                                onDelete();
                                Navigator.pop(ctx);
                              },
                              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.errorContainer.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: colors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
