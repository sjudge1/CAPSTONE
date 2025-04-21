import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


const List<Widget> sex = <Widget>[
  Text('Male'),
  Text('Female')
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terpiez',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomeScreen(),
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HeartCalculator(),
    LungCalculator(),
  ];

  @override
  void initState() {
    super.initState();
    _loadLastSelectedIndex();
  }

  Future<void> _loadLastSelectedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('lastSelectedIndex') ?? 0;
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSelectedIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart-Lung Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/heart.png')),
            label: 'Heart',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/images/lung.png')),
            label: 'Lung',
          ),
        ],
      ),
    );
  }
}


class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Help & Instructions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disclaimer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'This application provides sizing information to assist in thoracic transplant decision-making. The models and data presented are intended for informational purposes only and should not be used as the sole basis for clinical decisions. Transplant suitability and donor-recipient matching require comprehensive clinical evaluation, incorporating all relevant medical history, imaging, hemodynamic parameters, and expert judgment.\n\n'
              'Healthcare providers should exercise clinical discretion and consider all available patient-specific information before making transplant-related decisions. The developers of this application assume no responsibility for clinical outcomes resulting from its use.\n\n'
              'By using this application, you acknowledge that qualified healthcare professionals should make final medical decisions based on a holistic assessment of each case.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Definitions to know:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Absolute Risk - the actual chance (or probability) of an event happening in a population. It is usually expressed as a percentage.\n\n'
              'Relative Risk - compares the risk of an event occurring in one group to another group. It is a ratio that helps determine whether an exposure or intervention increases or decreases risk compared to a control group.\n\n'
              'A high relative risk can sound alarming, but the absolute risk helps put it in perspective.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Justification',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Two separate regression equations– pTLC (predicted Total Lung Capacity) and pHM (predicted Heart Mass) – are used for our application, both derived from allometric regression models based on data from 1,746 healthy patients without metabolic or cardiovascular conditions.\n\n'
              'Predicted Total Lung Capacity (pTLC):\n\n'
              'pTLC for men = [7.99 × height in meters] - 7.08\n'
              'pTLC for women = [6.60 × height in meters] - 5.79\n'
              'pTLC ratio = pTLC Donor / pTLC Recipient\n\n'
              'These equations were developed using data from nonsmokers with no diseases affecting lung function. They are applicable to adults (ages 18–70) of European descent, within the following height ranges:\n\n'
              'Men: 1.55–1.95 m\n'
              'Women: 1.45–1.80 m\n\n'
              'Predicted Heart Mass (pHM):\n\n'
              'Predicted left ventricular mass (g) = a × Height^0.54 × Weight^0.51\n'
              'a = 6.82 for women and 8.25 for men\n'
              'Predicted right ventricular mass (g) = a × Age^-0.32 × Height^1.135 × Weight^0.315\n'
              'a = 10.59 for women and 11.25 for men\n\n'
              'pHM Ratio = ((pHM Recipient - pHM Donor) / pHM recipient) × 100\n\n'
              'The equations for left and right ventricular mass were derived using multiplicative models by regressing the log-transformed ventricular mass against the log of height, weight, and (for right ventricular mass) age and sex.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'References:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Bluemke, D. A., Kronmal, R. A., Joao A.C. Lima, Liu, K., Olson, J. L., Burke, G. L., & Folsom, A. R. (2008). The Relationship of Left Ventricular Mass and Geometry to Incident Cardiovascular Events. Journal of the American College of Cardiology, 52(25), 2148–2155. https://doi.org/10.1016/j.jacc.2008.09.014\n\n'
              '2. Eberlein, M., & Reed, R. M. (2016). Donor to recipient sizing in thoracic organ transplantation. World Journal of Transplantation, 6(1), 155. https://doi.org/10.5500/wjt.v6.i1.155\n\n'
              '3. Eduard Ródenas-Alesina, Foroutan, F., Fan, C.-P., Stehlik, J., Bartlett, I., Maxime Tremblay-Gravel, Aleksova, N., Rao, V., Miller, R. J. H., Khush, K. K., Ross, H. J., & Yasbanoo Moayedi. (2023). Predicted Heart Mass: A Tale of 2 Ventricles. Circulation Heart Failure, 16(9). https://doi.org/10.1161/circheartfailure.120.008311\n\n'
              '4. Kawut, S. M., Lima, J. A. C., Barr, R. G., Chahal, H., Jain, A., Tandri, H., Praestgaard, A., Bagiella, E., Kizer, J. R., Johnson, W. C., Kronmal, R. A., & Bluemke, D. A. (2011). Sex and Race Differences in Right Ventricular Structure and Function. Circulation, 123(22), 2542–2551. https://doi.org/10.1161/circulationaha.110.985515\n\n'
              '5. Quanjer, P. H., Tammeling, G. J., Cotes, J. E., Pedersen, O. F., Peslin, R., & Yernault, J.-C. . (1993). Lung Volumes and Forced Ventilatory Flows. European Respiratory Journal, 6(Suppl 16), 21. https://doi.org/10.1183/09041950.005s1693\n\n'
              '6. Reed, R. M., Netzer, G., Hunsicker, L. G., Mitchell, B. D., Rajagopal, K., Scharf, S. M., & Eberlein, M. (2014). Cardiac Size and Sex-Matching in Heart Transplantation. JACC: Heart Failure, 2(1), 73–83. https://doi.org/10.1016/j.jchf.2013.09.005',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),
            // Add the relative risk image
            Image.asset('assets/images/relativerisknew.png'),
            const SizedBox(height: 20),
            const Text(
              'For more information, kindly refer to the following articles:\n'
              '[https://www.wjgnet.com/2220-3230/full/v6/i1/155.htm]\n'
              'Eberlein, M., & Reed, R. M. (2016). Donor to recipient sizing in thoracic organ transplantation. World journal of transplantation, 6(1), 155–164. https://doi.org/10.5500/wjt.v6.i1.155\n\n'
              'The article "Donor to recipient sizing in thoracic organ transplantation" by Dr Eberlein and Dr Reed discusses the importance of matching donor and recipient sizes, particularly focusing on the predicted total lung capacity (pTLC) ratio. This ratio is calculated by dividing the donor\'s pTLC by the recipient\'s pTLC.\n\n'
              'The authors present a graph illustrating the relationship between the pTLC ratio and relative risk (RR) of primary graft dysfunction (PGD). This graph is crucial for understanding how size mismatches between donor and recipient can influence transplant outcomes.\n\n'
              'Key Insights from the Graph:\n'
              'Optimal pTLC Ratio Range: The graph indicates that a pTLC ratio between 0.85 and 1.15 is associated with the lowest relative risk of PGD. This range suggests that donor-recipient size matching within this window is ideal for minimizing complications.\n\n'
              'Increased Risk with Mismatches: Deviations from this optimal range, either smaller or larger, lead to an increased relative risk of PGD. For instance, a pTLC ratio below 0.85 or above 1.15 corresponds to higher relative risks, indicating that both undersized and oversized grafts can compromise transplant success.\n\n'
              'Clinical implications:\n'
              'Incorporating the pTLC ratio into donor-recipient matching protocols can enhance the precision of transplant planning. By aiming for a pTLC ratio within the optimal range, clinicians can reduce the likelihood of PGD and improve overall transplant outcomes. This approach underscores the importance of personalized matching strategies in thoracic organ transplantation.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            // Add the heart graph image
            Image.asset('assets/images/heartgraph2.png'),
            const SizedBox(height: 20),
            const Text(
              'For more information, kindly refer to the following articles:\n'
              '[https://www.ahajournals.org/doi/10.1161/CIRCHEARTFAILURE.120.008311]\n'
              'Ródenas-Alesina, E., Foroutan, F., Fan, C.-P., Stehlik, J., Bartlett, I., Tremblay-Gravel, M., Aleksova, N., Rao, V., Miller, R. J. H., Khush, K. K., Ross, H. J., & Moayedi, Y. (2023). Predicted heart mass: A tale of 2 Ventricles. Circulation: Heart Failure, 16(9). https://doi.org/10.1161/circheartfailure.120.008311\n\n'
              'In the study "Predicted Heart Mass: A Tale of 2 Ventricles" by Reed et al., the authors investigate the relationship between donor-recipient heart size matching and the risk of graft failure following heart transplantation. They utilize the Predicted Heart Mass (PHM) metric, assessing both left ventricular (LV) and right ventricular (RV) contributions separately, to refine donor-recipient matching.\n\n'
              'Understanding the Hazard Ratio (HR) in This Context:\n'
              'A hazard ratio is a measure used in survival analyses to compare the risk of a particular event (in this case, graft failure) occurring at any point in time between two groups. An HR greater than 1 indicates an increased risk, while an HR less than 1 suggests a decreased risk.\n\n'
              'Key Findings Regarding LV and RV PHM Differences:\n'
              'Left Ventricular (LV) Undersizing:\n'
              'The study found that a donor LV undersized by more than 26% relative to the recipient was associated with a 1.5-fold increased risk of graft failure. This suggests that significant LV undersizing compromises transplant outcomes.\n\n'
              'Right Ventricular (RV) Oversizing:\n'
              'Similarly, a donor RV oversized by more than 40% relative to the recipient also conferred a 1.5-fold increased risk of graft failure. This highlights the risks associated with substantial RV oversizing.\n\n'
              'Clinical implications:\n'
              'The study emphasizes that both LV and RV size mismatches can independently affect transplant success. Therefore, incorporating separate assessments of LV and RV PHM differences, rather than relying solely on total heart mass, can enhance the precision of donor-recipient matching. This approach aims to minimize the risk of graft failure and improve post-transplant outcomes.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}


class HeartCalculator extends StatefulWidget {
  const HeartCalculator({super.key});

  @override
  State<HeartCalculator> createState() => _HeartCalculatorState();
}

class _HeartCalculatorState extends State<HeartCalculator> {
  // Donor Controllers
  final TextEditingController donorAgeController = TextEditingController();
  final TextEditingController donorWeightController = TextEditingController();
  final TextEditingController donorHeightController = TextEditingController();

  // Recipient Controllers
  final TextEditingController recipientAgeController = TextEditingController();
  final TextEditingController recipientWeightController = TextEditingController();
  final TextEditingController recipientHeightController = TextEditingController();

  // Toggles for gender selection
  final List<bool> _selectedSexDonor = <bool>[true, false];
  final List<bool> _selectedSexRecipient = <bool>[true, false];

  // Unit toggles for donor
  final List<bool> _selectedDonorWeightUnit = [true, false]; // 0=kg, 1=lbs
  final List<bool> _selectedDonorHeightUnit = [true, false]; // 0=cm, 1=in

  // Unit toggles for recipient
  final List<bool> _selectedRecipientWeightUnit = [true, false];
  final List<bool> _selectedRecipientHeightUnit = [true, false];

  // Helper to build larger toggle buttons for units
  Widget buildUnitToggle({
    required List<bool> isSelected,
    required ValueChanged<int> onPressed,
    required List<String> labels,
  }) {
    return ToggleButtons(
      isSelected: isSelected,
      onPressed: onPressed,
      constraints: const BoxConstraints(minWidth: 70, minHeight: 40),
      borderRadius: BorderRadius.circular(10),
      selectedColor: Colors.white,
      fillColor: Theme.of(context).primaryColor,
      textStyle: const TextStyle(fontSize: 16),
      children: labels.map((label) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(label),
      )).toList(),
    );
  }

  // Reusable row widget for "Label + TextField + (optional) Unit Toggle"
  Widget buildInputRow({
    required String label,
    required TextEditingController controller,
    String hintText = '',
    bool showUnitToggle = false,
    List<bool>? isSelected,
    ValueChanged<int>? onPressed,
    List<String>? labels,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 75,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: hintText,
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        if (showUnitToggle && isSelected != null && onPressed != null && labels != null) ...[
          const SizedBox(width: 8),
          buildUnitToggle(
            isSelected: isSelected,
            onPressed: onPressed,
            labels: labels,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Calculator'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Donor Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Donor Info',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          // Sex Toggle
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(8),
                            constraints: const BoxConstraints(minHeight: 40, minWidth: 60),
                            isSelected: _selectedSexDonor,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _selectedSexDonor.length; i++) {
                                  _selectedSexDonor[i] = (i == index);
                                }
                              });
                            },
                            children: sex,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Age
                      buildInputRow(
                        label: 'Age',
                        controller: donorAgeController,
                        hintText: 'years',
                      ),
                      const SizedBox(height: 16),
                      // Weight
                      buildInputRow(
                        label: 'Weight',
                        controller: donorWeightController,
                        hintText: 'value',
                        showUnitToggle: true,
                        isSelected: _selectedDonorWeightUnit,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedDonorWeightUnit.length; i++) {
                              _selectedDonorWeightUnit[i] = (i == index);
                            }
                          });
                        },
                        labels: const ['kg', 'lbs'],
                      ),
                      const SizedBox(height: 16),
                      // Height
                      buildInputRow(
                        label: 'Height',
                        controller: donorHeightController,
                        hintText: 'value',
                        showUnitToggle: true,
                        isSelected: _selectedDonorHeightUnit,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedDonorHeightUnit.length; i++) {
                              _selectedDonorHeightUnit[i] = (i == index);
                            }
                          });
                        },
                        labels: const ['cm', 'in'],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Recipient Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Title Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recipient Info',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          // Sex Toggle
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(8),
                            constraints: const BoxConstraints(minHeight: 40, minWidth: 60),
                            isSelected: _selectedSexRecipient,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _selectedSexRecipient.length; i++) {
                                  _selectedSexRecipient[i] = (i == index);
                                }
                              });
                            },
                            children: sex,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Age
                      buildInputRow(
                        label: 'Age',
                        controller: recipientAgeController,
                        hintText: 'years',
                      ),
                      const SizedBox(height: 16),
                      // Weight
                      buildInputRow(
                        label: 'Weight',
                        controller: recipientWeightController,
                        hintText: 'value',
                        showUnitToggle: true,
                        isSelected: _selectedRecipientWeightUnit,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedRecipientWeightUnit.length; i++) {
                              _selectedRecipientWeightUnit[i] = (i == index);
                            }
                          });
                        },
                        labels: const ['kg', 'lbs'],
                      ),
                      const SizedBox(height: 16),
                      // Height
                      buildInputRow(
                        label: 'Height',
                        controller: recipientHeightController,
                        hintText: 'value',
                        showUnitToggle: true,
                        isSelected: _selectedRecipientHeightUnit,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < _selectedRecipientHeightUnit.length; i++) {
                              _selectedRecipientHeightUnit[i] = (i == index);
                            }
                          });
                        },
                        labels: const ['cm', 'in'],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Calculate Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(140, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  // Validate that none of the fields are empty.
                  if (donorAgeController.text.trim().isEmpty ||
                      donorWeightController.text.trim().isEmpty ||
                      donorHeightController.text.trim().isEmpty ||
                      recipientAgeController.text.trim().isEmpty ||
                      recipientWeightController.text.trim().isEmpty ||
                      recipientHeightController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in all required fields."),
                      ),
                    );
                    return;
                  }

                  // Parse strings
                  final donorAgeStr = donorAgeController.text;
                  final donorWeightStr = donorWeightController.text;
                  final donorHeightStr = donorHeightController.text;
                  final recipientAgeStr = recipientAgeController.text;
                  final recipientWeightStr = recipientWeightController.text;
                  final recipientHeightStr = recipientHeightController.text;

                  final int donorAgeInt = int.tryParse(donorAgeStr) ?? 0;
                  final int recipientAgeInt = int.tryParse(recipientAgeStr) ?? 0;

                  double donorWeightInput = double.tryParse(donorWeightStr) ?? 0;
                  double donorHeightInput = double.tryParse(donorHeightStr) ?? 0;
                  double recipientWeightInput = double.tryParse(recipientWeightStr) ?? 0;
                  double recipientHeightInput = double.tryParse(recipientHeightStr) ?? 0;

                  // Convert if toggles indicate lbs/in
                  if (_selectedDonorWeightUnit[1]) donorWeightInput *= 0.453592;
                  if (_selectedDonorHeightUnit[1]) donorHeightInput *= 2.54;
                  if (_selectedRecipientWeightUnit[1]) recipientWeightInput *= 0.453592;
                  if (_selectedRecipientHeightUnit[1]) recipientHeightInput *= 2.54;

                  final int donorWeightInt = donorWeightInput.round();
                  final int donorHeightInt = donorHeightInput.round();
                  final int recipientWeightInt = recipientWeightInput.round();
                  final int recipientHeightInt = recipientHeightInput.round();

                  String donorSex = _selectedSexDonor[0] ? "Male" : "Female";
                  String recipientSex = _selectedSexRecipient[0] ? "Male" : "Female";

                  // Navigate to HeartResults (you'll need to define HeartResults)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HeartResults(
                        donorAge: donorAgeInt,
                        donorWeight: donorWeightInt,
                        donorHeight: donorHeightInt,
                        recipientAge: recipientAgeInt,
                        recipientWeight: recipientWeightInt,
                        recipientHeight: recipientHeightInt,
                        donorSex: donorSex,
                        recipientSex: recipientSex,
                      ),
                    ),
                  );
                },
                child: const Text("Calculate!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class LungCalculator extends StatefulWidget {
  const LungCalculator({super.key});

  @override
  State<LungCalculator> createState() => _LungCalculatorState();
}

class _LungCalculatorState extends State<LungCalculator> {
  // Text Editing Controllers
  final TextEditingController donorHeightController = TextEditingController();
  final TextEditingController recipientHeightController = TextEditingController();

  // ToggleButtons for sex selection
  final List<bool> _selectedSexDonor = [true, false];
  final List<bool> _selectedSexRecipient = [true, false];

  // ToggleButtons for height units: index 0 = cm, index 1 = in. Default is cm.
  final List<bool> _selectedDonorHeightUnit = [true, false];
  final List<bool> _selectedRecipientHeightUnit = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lung Calculator')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Donor Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Title + Sex Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Donor Info',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ToggleButtons(
                            isSelected: _selectedSexDonor,
                            borderRadius: BorderRadius.circular(8),
                            constraints: const BoxConstraints(minHeight: 40, minWidth: 60),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _selectedSexDonor.length; i++) {
                                  _selectedSexDonor[i] = (i == index);
                                }
                              });
                            },
                            children: const [Text('Male'), Text('Female')],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Donor Height Input + Toggle
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text('Height:', style: TextStyle(fontSize: 16)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: donorHeightController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter height',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ToggleButtons(
                            isSelected: _selectedDonorHeightUnit,
                            borderRadius: BorderRadius.circular(8),
                            constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _selectedDonorHeightUnit.length; i++) {
                                  _selectedDonorHeightUnit[i] = (i == index);
                                }
                              });
                            },
                            children: const [Text('cm'), Text('in')],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Recipient Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Title + Sex Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recipient Info',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ToggleButtons(
                            isSelected: _selectedSexRecipient,
                            borderRadius: BorderRadius.circular(8),
                            constraints: const BoxConstraints(minHeight: 40, minWidth: 60),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _selectedSexRecipient.length; i++) {
                                  _selectedSexRecipient[i] = (i == index);
                                }
                              });
                            },
                            children: const [Text('Male'), Text('Female')],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Recipient Height Input + Toggle
                      Row(
                        children: [
                          const SizedBox(
                            width: 100,
                            child: Text('Height:', style: TextStyle(fontSize: 16)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: recipientHeightController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter height',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ToggleButtons(
                            isSelected: _selectedRecipientHeightUnit,
                            borderRadius: BorderRadius.circular(8),
                            constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < _selectedRecipientHeightUnit.length; i++) {
                                  _selectedRecipientHeightUnit[i] = (i == index);
                                }
                              });
                            },
                            children: const [Text('cm'), Text('in')],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Calculate Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(140, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  // Validate inputs
                  if (donorHeightController.text.trim().isEmpty ||
                      recipientHeightController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill in all required fields."),
                      ),
                    );
                    return;
                  }
                  // Read raw input values
                  final donorHeightStr = donorHeightController.text;
                  final recipientHeightStr = recipientHeightController.text;
                  
                  // Parse height values
                  double donorHeightInput = double.tryParse(donorHeightStr) ?? 0;
                  double recipientHeightInput = double.tryParse(recipientHeightStr) ?? 0;
                  
                  // Convert donor height if unit is inches to centimeters.
                  if (_selectedDonorHeightUnit[1]) {
                    donorHeightInput *= 2.54;
                  }
                  // Convert recipient height if unit is inches to centimeters.
                  if (_selectedRecipientHeightUnit[1]) {
                    recipientHeightInput *= 2.54;
                  }
                  
                  final int donorHeightInt = donorHeightInput.round();
                  final int recipientHeightInt = recipientHeightInput.round();
                  
                  // Determine sex selections
                  final String donorSex = _selectedSexDonor[0] ? "Male" : "Female";
                  final String recipientSex = _selectedSexRecipient[0] ? "Male" : "Female";
                  
                  // Navigate to LungResults with the converted height values
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LungResults(
                        donorHeight: donorHeightInt,
                        donorSex: donorSex,
                        recipientHeight: recipientHeightInt,
                        recipientSex: recipientSex,
                      ),
                    ),
                  );
                },
                child: const Text('Calculate!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

                         
class HeartResults extends StatelessWidget {
  final int donorAge;
  final int donorWeight;
  final int donorHeight; // in cm
  final int recipientAge;
  final int recipientWeight;
  final int recipientHeight; // in cm
  final String donorSex;     // "Male" or "Female"
  final String recipientSex; // "Male" or "Female"

  const HeartResults({
    Key? key,
    required this.donorAge,
    required this.donorWeight,
    required this.donorHeight,
    required this.recipientAge,
    required this.recipientWeight,
    required this.recipientHeight,
    required this.donorSex,
    required this.recipientSex,
  }) : super(key: key);

  /// Predicted Left Ventricular Mass (g)
  double predictedLeftVentricularMass({
    required int weight,
    required int heightCm,
    required String sex,
  }) {
    final double heightM = heightCm / 100.0;
    final double a = (sex == "Male") ? 8.25 : 6.82;
    return a * pow(heightM, 0.54).toDouble() * pow(weight, 0.61).toDouble();
  }

  /// Predicted Right Ventricular Mass (g)
  double predictedRightVentricularMass({
    required int age,
    required int weight,
    required int heightCm,
    required String sex,
  }) {
    final double heightM = heightCm / 100.0;
    final double a = (sex == "Male") ? 11.25 : 10.59;
    final double ageFactor = pow(age, -0.32).toDouble();
    return a * ageFactor * pow(heightM, 1.135).toDouble() * pow(weight, 0.315).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate donor values
    final double donorLVM = predictedLeftVentricularMass(
      weight: donorWeight,
      heightCm: donorHeight,
      sex: donorSex,
    );
    final double donorRVM = predictedRightVentricularMass(
      age: donorAge,
      weight: donorWeight,
      heightCm: donorHeight,
      sex: donorSex,
    );
    final double donorPHM = donorLVM + donorRVM;

    // Calculate recipient values
    final double recipientLVM = predictedLeftVentricularMass(
      weight: recipientWeight,
      heightCm: recipientHeight,
      sex: recipientSex,
    );
    final double recipientRVM = predictedRightVentricularMass(
      age: recipientAge,
      weight: recipientWeight,
      heightCm: recipientHeight,
      sex: recipientSex,
    );
    final double recipientPHM = recipientLVM + recipientRVM;

    // Calculate the pHM ratio: ((recipientPHM - donorPHM) / recipientPHM) * 100
    double ratio = 0.0;
    if (recipientPHM != 0.0) {
      ratio = ((recipientPHM - donorPHM) / recipientPHM) * 100.0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart Results'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Donor Information Card
                const Text(
                  'Donor Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text('Age: $donorAge',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                        Text('Weight: $donorWeight kg',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                        Text('Height: $donorHeight cm',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                        Text('Sex: $donorSex',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Recipient Information Card
                const Text(
                  'Recipient Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text('Age: $recipientAge',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                        Text('Weight: $recipientWeight kg',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                        Text('Height: $recipientHeight cm',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                        Text('Sex: $recipientSex',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Calculated Results Section
                const Text(
                  'Calculated Results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                Text(
                  'Donor Left Ventricular Mass: ${donorLVM.toStringAsFixed(2)} g',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Donor Right Ventricular Mass: ${donorRVM.toStringAsFixed(2)} g',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Donor Predicted Heart Mass: ${donorPHM.toStringAsFixed(2)} g',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Recipient Left Ventricular Mass: ${recipientLVM.toStringAsFixed(2)} g',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Recipient Right Ventricular Mass: ${recipientRVM.toStringAsFixed(2)} g',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Recipient Predicted Heart Mass: ${recipientPHM.toStringAsFixed(2)} g',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Emphasized pHM Ratio Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'pHM Difference: ${ratio.toStringAsFixed(2)}%',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                // Graph image
                Image.asset('assets/images/heartgraph2.png'),
                const SizedBox(height: 10),
                // Citation under the graph
                const Text(
                  'Ródenas-Alesina, E., Foroutan, F., Fan, C.-P., Stehlik, J., Bartlett, I., Tremblay-Gravel, M., Aleksova, N., Rao, V., Miller, R. J. H., Khush, K. K., Ross, H. J., & Moayedi, Y. (2023). Predicted heart mass: A tale of 2 Ventricles. Circulation: Heart Failure, 16(9). https://doi.org/10.1161/circheartfailure.120.008311',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Button to reset the calculator page
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 50),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HeartCalculator()),
                    );
                  },
                  child: const Text('Enter New Patient Info'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class LungResults extends StatelessWidget {
  final int donorHeight;    // in cm
  final String donorSex;    // "Male" or "Female"
  final int recipientHeight; // in cm
  final String recipientSex; // "Male" or "Female"

  const LungResults({
    Key? key,
    required this.donorHeight,
    required this.donorSex,
    required this.recipientHeight,
    required this.recipientSex,
  }) : super(key: key);

  /// Predicted Total Lung Capacity (pTLC)
  /// For Men: pTLC = (7.99 * height in m) - 7.08
  /// For Women: pTLC = (6.60 * height in m) - 5.79
  double predictedTLC({
    required int heightCm,
    required String sex,
  }) {
    final double heightM = heightCm / 100.0;
    if (sex == "Male") {
      return 7.99 * heightM - 7.08;
    } else {
      return 6.60 * heightM - 5.79;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double donorPTLC = predictedTLC(heightCm: donorHeight, sex: donorSex);
    final double recipientPTLC = predictedTLC(heightCm: recipientHeight, sex: recipientSex);

    double ratio = 0.0;
    if (recipientPTLC != 0.0) {
      ratio = donorPTLC / recipientPTLC;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lung Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Donor Information Card
                const Text(
                  'Donor Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Height: $donorHeight cm',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Sex: $donorSex',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Recipient Information Card
                const Text(
                  'Recipient Information',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text(
                          'Height: $recipientHeight cm',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Sex: $recipientSex',
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Calculated Results Section
                const Text(
                  'Calculated Results',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                Text(
                  'Donor pTLC: ${donorPTLC.toStringAsFixed(2)} L',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Recipient pTLC: ${recipientPTLC.toStringAsFixed(2)} L',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                // Emphasized pTLC Ratio Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'pTLC Ratio (Donor/Recipient): ${ratio.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                // Chart Title + Image
                const Text(
                  'Relative Risk Chart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Image.asset('assets/images/relativerisknew.png'),
                const SizedBox(height: 10),
                // Citation below the graph
                const Text(
                  'Eberlein M, Reed RM, Maidaa M, Bolukbas S, Arnaoutakis GJ, Orens JB, Brower RG, Merlo CA, Hunsicker LG. Donor-recipient size matching and survival after lung transplantation. A cohort study. Ann Am Thorac Soc. 2013 Oct;10(5):418-25. doi: 10.1513/AnnalsATS.201301-008OC. PMID: 23988005.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // Button to clear results and go back to the Lung Calculator page
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(140, 50),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LungCalculator()),
                    );
                  },
                  child: const Text('Enter New Patient Info'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


