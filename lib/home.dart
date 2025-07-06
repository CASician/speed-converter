import 'package:flutter/material.dart';
import 'package:speed_converter/settings.dart';
import 'env.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _minPerKmController = TextEditingController();
  final TextEditingController _kmPerHourController = TextEditingController();

  bool isUserUsingMiles = false;
  bool _isMinPerKmEnabled = false;
  bool _isKmPerHourEnabled = false;
  String? _minPerKmError;

  String firstResponse = "---";
  String _conversionResult = 'Click on blank spaces';

  void _convert() {
    setState(() {
      double? minPerKm = double.tryParse(_minPerKmController.text);
      double? kmPerHour = double.tryParse(_kmPerHourController.text);

      if (_minPerKmError != null) {
        _conversionResult = 'Errore: $_minPerKmError';
      } else if (minPerKm != null && _isMinPerKmEnabled) {
        int minutes = minPerKm.floor();
        double seconds = (minPerKm - minutes) * 100;
        double totalMinutes = minutes + (seconds / 60);
        double totalHours = totalMinutes / 60;
        double kmPerHourResult = 1 / totalHours;
        _conversionResult = '${kmPerHourResult.toStringAsFixed(2)} km/h';
      } else if (kmPerHour != null && _isKmPerHourEnabled) {
        double hoursPerKm = 1 / kmPerHour;
        double totalMinutesPerKm = hoursPerKm * 60;
        int minutes = totalMinutesPerKm.floor();
        int seconds = ((totalMinutesPerKm - minutes) * 60).round();
        if (seconds == 60) {
          minutes += 1;
          seconds = 0;
        }
        _conversionResult = '$minutes\' ${seconds.toString().padLeft(2, '0')}\" \/ km';
      } else {
        _conversionResult = 'Valore non valido';
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _minPerKmController.addListener(() {
      String text = _minPerKmController.text;
      if (text.isEmpty) {
        setState(() {
          _minPerKmError = null;
          _isKmPerHourEnabled = false;
        });
      } else {
        _isKmPerHourEnabled = false;

        double? value = double.tryParse(text);
        if (value != null) {
          int minutes = value.floor();
          double seconds = (value - minutes) * 100;

          if (seconds > 59) {
            setState(() {
              _minPerKmError = "sec < 59 !!";
            });
          } else {
            setState(() {
              _minPerKmError = null;
            });
          }
        } else {
          setState(() {
            _minPerKmError = "Così no.";
          });
        }
      }
    });

    _kmPerHourController.addListener(() {
      setState(() {
        _isMinPerKmEnabled = _kmPerHourController.text.isEmpty;
      });
    });
  }

  void _onMinPerKmTap() {
    _kmPerHourController.clear();
    _conversionResult = firstResponse;
    setState(() {
      _isKmPerHourEnabled = false;
      _isMinPerKmEnabled = true;
    });
  }

  void _onKmPerHourTap() {
    _minPerKmController.clear();
    _conversionResult = firstResponse;
    setState(() {
      _isMinPerKmEnabled = false;
      _isKmPerHourEnabled = true;
    });
  }

  void _openSettings() async {
    // Rimuovi il focus prima di aprire il dialog
    FocusScope.of(context).unfocus();

    // Apri il dialog delle impostazioni
    await showSettingsDialog(context);

    // Assicurati che il focus non torni sui campi dopo aver chiuso il dialog
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 10));
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        actions: [
          IconButton(
              onPressed: _openSettings,
              icon: Icon(Icons.settings, color: Env.second))
        ],
      ),
      backgroundColor: Env.third,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // The container is needed so the Gesture Detector can work as intended:
        // without you can on focus keyboard only by clicking on actual components
        // of center, but not on the background.
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Speed Converter",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Env.first,
                  ),
                 textAlign: TextAlign.center,
                ),
                const SizedBox(height: 100),
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Env.second,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Env.sixth, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Env.sixth.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(3, 5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildConversionLabels(),
                        const SizedBox(height: 20),
                        _buildConversionInputs(),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _convert,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Env.third,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Convert', style: TextStyle(color: Env.first)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _conversionResult,
                          style: MyTextStyle.textStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 120),
                Text(
                  "Made by CASician",
                  style: TextStyle(
                    fontSize: 16,
                    color: Env.first, // più trasparente
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildConversionLabels() {
    if (!isUserUsingMiles){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("min/km", style: MyTextStyle.textStyle()),
          Text("km/h", style: MyTextStyle.textStyle()),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("min/miles", style: MyTextStyle.textStyle()),
          Text("miles/h", style: MyTextStyle.textStyle()),
        ],
      );
    }
  }

  Widget _buildConversionInputs() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minPerKmController,
            onTap: _onMinPerKmTap,
            decoration: InputDecoration(
              hintText: '',
              errorText: _minPerKmError,
              errorStyle: TextStyle(fontSize: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Env.second, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Env.third, width: 2),
              ),
              filled: true,
              fillColor: _isMinPerKmEnabled ? Env.first : Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 15,
              color: Env.sixth,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _kmPerHourController,
            onTap: _onKmPerHourTap,
            decoration: InputDecoration(
              hintText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Env.second, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Env.third, width: 2),
              ),
              filled: true,
              fillColor: _isKmPerHourEnabled ? Env.first : Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 15,
              color: Env.sixth,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}

class MyTextStyle {
  static TextStyle textStyle() {
    return TextStyle(
      fontSize: 20,
      color: Env.sixth,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none,
    );
  }
}
