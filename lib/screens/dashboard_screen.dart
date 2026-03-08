import 'package:flutter/material.dart';
import '../services/cotisation_service.dart';
import 'add_cotisation_screen.dart';
//import 'package:intl/intl.dart';

import '../widgets/app_background.dart';
import '../widgets/progress_card.dart';
import '../widgets/cotisation_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List cotisations = [];
  int totalUser = 0;

  int? selectedMonth;

  bool loading = true;

  final int objectifAnnuel = 240000;

  final List<String> moisFrancais = [
    "",
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre",
  ];

  @override
  void initState() {
    super.initState();
    loadCotisations();
  }

  void loadCotisations({int? month}) async {
    try {
      setState(() {
        loading = true;
      });

      var data = await CotisationService.getCotisations(month: month);
      var total = await CotisationService.getTotalUser();

      if (!mounted) return;

      setState(() {
        cotisations = data;
        totalUser = total;
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

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
            Image.asset("assets/images/logo.png", height: 30),

            const SizedBox(width: 10),

            const Text(
              "Mes cotisations",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      body: AppBackground(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    /// PROGRESSION
                    ProgressCard(total: totalUser, objectif: objectifAnnuel),

                    const SizedBox(height: 20),

                    /// FILTRE
                    Row(
                      children: [
                        const Text(
                          "Filtrer : ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A5F),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: DropdownButton<int?>(
                            value: selectedMonth,

                            hint: const Text("Tous"),

                            underline: const SizedBox(),

                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text("Tous les mois"),
                              ),

                              ...List.generate(
                                12,

                                (index) => DropdownMenuItem(
                                  value: index + 1,
                                  child: Text(moisFrancais[index + 1]),
                                ),
                              ),
                            ],

                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value;
                              });

                              loadCotisations(month: value);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// LISTE
                    Expanded(
                      child: cotisations.isEmpty
                          ? const Center(child: Text("Aucune cotisation"))
                          : ListView.builder(
                              itemCount: cotisations.length,

                              itemBuilder: (context, index) {
                                var cotisation = cotisations[index];

                                return CotisationCard(cotisation: cotisation);
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),

      /// AJOUT COTISATION
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD62828),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) => const AddCotisationScreen(),
            ),
          ).then((_) {
            loadCotisations(month: selectedMonth);
          });
        },

        child: const Icon(Icons.add),
      ),
    );
  }
}
