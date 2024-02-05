import 'package:calculator/button_value.dart';
import 'package:flutter/material.dart';

class CalulatorScreen extends StatefulWidget {
  const CalulatorScreen({super.key});

  @override
  State<CalulatorScreen> createState() => _CalulatorScreenState();
}

class _CalulatorScreenState extends State<CalulatorScreen> {
  String firstOperand = "";
  String number1 = "";
  String operand = "";
  String secondOperand = "";
  String number2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        // bottom: false,
        child: screenSize.width > screenSize.height
            ? const Center(
                child: Text("Please rotate the device"),
              )
            : Column(
                children: [
                  // output
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "$firstOperand$number1$operand$number2".isEmpty
                              ? "0"
                              : "$firstOperand$number1$operand$secondOperand$number2",
                          style: const TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                  )
                  // button
                  ,
                  Wrap(
                    children: Btn.buttonValues
                        .map((e) => SizedBox(
                            height: screenSize.width / 5,
                            width: e == Btn.n0
                                ? (screenSize.width / 2)
                                : (screenSize.width / 4),
                            child: buildButton(e)))
                        .toList(),
                  )
                ],
              ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(100)),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.clr) {
      clearAll();
      return;
    }
    if (value == Btn.del) {
      deleteValue();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
      firstOperand = "";
    });
  }

  void deleteValue() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    } else if (firstOperand.isNotEmpty) {
      firstOperand = firstOperand.substring(0, firstOperand.length - 1);
    }
    setState(() {});
  }

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  void calculate() {
    if (number1.isEmpty) return;
    if (number2.isEmpty) return;
    if (operand.isEmpty) return;

    double num1 = double.parse(firstOperand + number1);
    double num2 = double.parse(secondOperand + number2);
    var result = 0.0;

    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;

      default:
    }
    setState(() {
      firstOperand = "";
      secondOperand = "";
      number1 = "$result";
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = "";
      number2 = "";
    });
  }

  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (number1.isEmpty && (value == Btn.add || value == Btn.subtract)) {
        firstOperand = value;
      }
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      if (operand.isNotEmpty &&
          number2.isEmpty &&
          (value == Btn.add || value == Btn.subtract)) {
        secondOperand = value;
      } else if (number1.isNotEmpty) {
        operand = value;
      }
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && number1.isEmpty || number1 == Btn.n0) {
        value = '0.';
      }
      number1 += value;
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && number2.isEmpty || number2 == Btn.n0) {
        value = '0.';
      }
      number2 += value;
    }

    setState(() {});
  }
}

Color getBtnColor(String value) {
  return [Btn.clr, Btn.del].contains(value)
      ? Colors.blueGrey
      : [
          Btn.per,
          Btn.multiply,
          Btn.add,
          Btn.dot,
          Btn.divide,
          Btn.subtract,
          Btn.calculate
        ].contains(value)
          ? Colors.orange
          : Colors.black;
}
