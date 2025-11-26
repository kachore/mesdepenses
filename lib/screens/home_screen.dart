import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/depense_provider.dart';
import '../widgets/depense_card.dart';
import 'add_edit_depense_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<DepenseProvider>().loadDepenses(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text('Mes Dépenses'),
        elevation: 0,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsScreen()),
              );
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: Icon(
                  provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => provider.toggleTheme(),
              );
            },
          ),
        ],
      ),

      body: Consumer<DepenseProvider>(
        builder: (context, provider, child) {
          if (provider.depenses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 100,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucune dépense enregistrée',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.outline,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final total = provider.depenses.fold<double>(
            0,
            (sum, d) => sum + d.montant,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primaryContainer.withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total des dépenses',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.onPrimaryContainer.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${total.toStringAsFixed(2)} FCFA',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView.separated(
                  itemCount: provider.depenses.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final depense = provider.depenses[index];
                    return DepenseCard(
                      depense: depense,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditDepenseScreen(depense: depense),
                          ),
                        );
                        if (mounted) {
                          context.read<DepenseProvider>().loadDepenses();
                        }
                      },
                      onDelete: () {
                        provider.deleteDepense(depense.id!);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditDepenseScreen()),
          );
          if (mounted) {
            context.read<DepenseProvider>().loadDepenses();
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
