import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/depense.dart';
import '../providers/depense_provider.dart';
import '../utils/constants.dart';

class AddEditDepenseScreen extends StatefulWidget {
  final Depense? depense;

  const AddEditDepenseScreen({Key? key, this.depense}) : super(key: key);

  @override
  State<AddEditDepenseScreen> createState() => _AddEditDepenseScreenState();
}

class _AddEditDepenseScreenState extends State<AddEditDepenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreController;
  late TextEditingController _montantController;
  late DateTime _selectedDate;
  late String _selectedCategorie;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.depense?.titre ?? '');
    _montantController = TextEditingController(
      text: widget.depense?.montant.toString() ?? '',
    );
    _selectedDate = widget.depense?.date ?? DateTime.now();
    _selectedCategorie = widget.depense?.categorie ?? AppConstants.categories[0];
  }

  @override
  void dispose() {
    _titreController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveDepense() {
    if (_formKey.currentState!.validate()) {
      final depense = Depense(
        id: widget.depense?.id,
        titre: _titreController.text,
        montant: double.parse(_montantController.text),
        date: _selectedDate,
        categorie: _selectedCategorie,
      );

      final provider = context.read<DepenseProvider>();
      if (widget.depense == null) {
        provider.addDepense(depense);
      } else {
        provider.updateDepense(depense);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.depense == null ? 'Nouvelle Dépense' : 'Modifier'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'Requis' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _montantController,
              decoration: const InputDecoration(
                labelText: 'Montant (FCFA)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v?.isEmpty ?? true) return 'Requis';
                if (double.tryParse(v!) == null) return 'Montant invalide';
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategorie,
              decoration: const InputDecoration(
                labelText: 'Catégorie',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items: AppConstants.categories.map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Row(
                    children: [
                      Icon(
                        AppConstants.categoryIcons[cat],
                        color: AppConstants.categoryColors[cat],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(cat),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedCategorie = v!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
  onPressed: _saveDepense,
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 0, 85, 155),
    foregroundColor: Colors.white,
    elevation: 6,
    shadowColor:Color.fromARGB(255, 0, 85, 155).withOpacity(0.4),
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    textStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  ),
  child: Text(widget.depense == null ? 'Ajouter' : 'Modifier'),
),

          ],
        ),
      ),
    );
  }
}
