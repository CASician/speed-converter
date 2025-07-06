import 'package:flutter/material.dart';
import 'env.dart';

Future<void> showSettingsDialog(BuildContext context) {
  Color textColor = Env.first;

  return showDialog(
      context: context,
      builder: (context) {
        bool isOn = false;

        Widget buildSwitch() {
          return StatefulBuilder(
              builder: (context, setState) {

                void onSwitchChanged(bool value){
                  setState(() {isOn = value;});
                  // TODO create logic to change what to display km/miles
                  debugPrint("State: ${isOn ? 'miles' : 'km'}");
                }

                return GestureDetector(
                    onTap: () {onSwitchChanged(!isOn); },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration( borderRadius: BorderRadius.circular(20), color: isOn ? Env.third : Env.second),
                      alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
                      // white ball inside:
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      ),
                    )
                );
              }
          );
        }

        Widget buildChoices() {
          return Column(
            children: [
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("km",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20,
                          ),
                        ),)),
                  Flexible(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.center,
                        child: buildSwitch(),
                      )
                  ),
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("miles",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Env.fourth,
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Settings",
                style: TextStyle(
                  color: textColor,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 60),
              buildChoices(),
              const SizedBox(height: 60),
              Text("v 1.0",
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      }
  );
}