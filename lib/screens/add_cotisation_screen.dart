import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import '../services/cotisation_service.dart';
import '../widgets/app_background.dart';
import '../widgets/custom_buttom.dart';

class AddCotisationScreen extends StatefulWidget {
  const AddCotisationScreen({super.key});

  @override
  State<AddCotisationScreen> createState() => _AddCotisationScreenState();
}

class _AddCotisationScreenState extends State<AddCotisationScreen> {
  final montantController = TextEditingController();
  final descriptionController = TextEditingController();

  Uint8List? fileBytes;
  String? fileName;

  bool loading = false;

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        fileBytes = result.files.single.bytes;
        fileName = result.files.single.name;
      });
    }
  }

  void saveCotisation() async {
    if (montantController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez saisir un montant")),
      );
      return;
    }

    final montant = int.tryParse(montantController.text.trim());
    if (montant == null || montant < 5000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Le montant minimum est 5000")),
      );
      return;
    }

    if (fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez selectionner un justificatif")),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await CotisationService.addCotisation(
        montantController.text,
        descriptionController.text,
        fileBytes!,
        fileName!,
      );

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'enregistrement: $e")),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 28),
            const SizedBox(width: 10),
            const Text(
              "Ajouter une cotisation",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Nouvelle cotisation",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: montantController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Montant",
                    prefixIcon: const Icon(
                      Icons.payments,
                      color: Color(0xFF1E3A5F),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Color(0xFF1E3A5F),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: "Choisir justificatif",
                  icon: Icons.attach_file,
                  onPressed: pickFile,
                ),
                const SizedBox(height: 15),
                if (fileName != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.insert_drive_file,
                          color: Color(0xFF1E3A5F),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            fileName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: "Enregistrer",
                        icon: Icons.save,
                        onPressed: saveCotisation,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
