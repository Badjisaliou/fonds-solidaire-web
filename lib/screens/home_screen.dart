import 'package:flutter/material.dart';
import '../services/dashboard_service.dart';

import '../widgets/app_background.dart';
import '../widgets/dashboard_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int total = 0;
  List mensuel = [];
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
    loadDashboard();
  }

  void loadDashboard() async {
    try {
      var totalGlobal = await DashboardService.getTotalGlobal();
      var dataMensuel = await DashboardService.getMensuel();

      if (!mounted) return;

      setState(() {
        total = totalGlobal;
        mensuel = dataMensuel;
        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
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
              "Fond Solidaire",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      body: AppBackground(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    /// TOTAL GLOBAL
                    DashboardCard(
                      title: "Total du fond solidaire",
                      value: "$total FCFA",
                      icon: Icons.account_balance_wallet,
                      color: const Color(0xFF1E3A5F),
                    ),

                    const SizedBox(height: 30),

                    /// TITRE
                    const Text(
                      "Cotisations par mois",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// LISTE MENSUELLE
                    Expanded(
                      child: mensuel.isEmpty
                          ? const Center(
                              child: Text("Aucune cotisation trouvée"),
                            )
                          : ListView.builder(
                              itemCount: mensuel.length,

                              itemBuilder: (context, index) {
                                var item = mensuel[index];

                                int montant =
                                    (double.tryParse(
                                              item["total"].toString(),
                                            ) ??
                                            0)
                                        .toInt();

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),

                                  padding: const EdgeInsets.all(14),

                                  decoration: BoxDecoration(
                                    color: Colors.white,

                                    borderRadius: BorderRadius.circular(14),

                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),

                                  child: Row(
                                    children: [
                                      /// ICON
                                      Container(
                                        padding: const EdgeInsets.all(10),

                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF1E3A5F,
                                          ).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),

                                        child: const Icon(
                                          Icons.calendar_month,
                                          color: Color(0xFF1E3A5F),
                                        ),
                                      ),

                                      const SizedBox(width: 15),

                                      /// MOIS
                                      Expanded(
                                        child: Text(
                                          moisFrancais[item["mois"]],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),

                                      /// MONTANT
                                      Text(
                                        "$montant FCFA",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFD62828),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
