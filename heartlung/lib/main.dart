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
        automaticallyImplyLeading: false, // Remove the default back button
        title: const Text('Help & Instructions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Close the HelpPage
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'insert justification + disclaimer here (will be here after testing)',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
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


