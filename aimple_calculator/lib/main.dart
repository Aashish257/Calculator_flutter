import 'package:flutter/material.dart';

void main() => runApp(const StylishCalculatorApp());

class StylishCalculatorApp extends StatelessWidget {
  const StylishCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // removes yellow debug banner
      title: 'Stylish Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '0';
  String input = '';
  double num1 = 0;
  String operator = '';
  bool resetInput = false;

  void press(String value) {
    setState(() {
      if (value == 'C') {
        display = '0';
        input = '';
        num1 = 0;
        operator = '';
        resetInput = false;
      } else if (value == '⌫') {
        if (input.isNotEmpty) {
          input = input.substring(0, input.length - 1);
          display = input.isEmpty ? '0' : input;
        }
      } else if (value == '±') {
        if (input.startsWith('-')) {
          input = input.substring(1);
        } else {
          input = '-$input';
        }
        display = input;
      } else if (value == '%') {
        if (input.isNotEmpty) {
          double val = double.parse(input) / 100;
          input = val.toString();
          display = input;
        }
      } else if (['+', '-', '×', '÷'].contains(value)) {
        num1 = double.tryParse(input.isEmpty ? display : input) ?? 0;
        operator = value;
        input = '';
      } else if (value == '=') {
        double num2 = double.tryParse(input.isEmpty ? display : input) ?? 0;
        double result = 0;
        switch (operator) {
          case '+':
            result = num1 + num2;
            break;
          case '-':
            result = num1 - num2;
            break;
          case '×':
            result = num1 * num2;
            break;
          case '÷':
            result = num2 == 0 ? double.nan : num1 / num2;
            break;
        }
        display = result.isNaN
            ? 'Error'
            : result.toStringAsFixed(6).replaceAll(RegExp(r'\.?0+$'), '');
        input = display;
        operator = '';
        resetInput = true;
      } else {
        if (resetInput) {
          input = '';
          resetInput = false;
        }
        if (value == '.' && input.contains('.')) return;
        input += value;
        display = input;
      }
    });
  }

  Widget calcButton(String text, {Color? color, double flex = 1}) {
    final bool isOperator = ['÷', '×', '-', '+', '='].contains(text);
    final Color btnColor = color ??
        (isOperator ? Colors.orangeAccent : const Color(0xFF2D2D2D));
    return Expanded(
      flex: flex.toInt(),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Ink(
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                offset: const Offset(3, 3),
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.05),
                offset: const Offset(-3, -3),
                blurRadius: 5,
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => press(text),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: isOperator ? Colors.white : Colors.grey[200],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(4, 4),
                      blurRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      offset: const Offset(-4, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    display,
                    style: const TextStyle(
                      fontSize: 56,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Button grid
              Column(
                children: [
                  Row(
                    children: [
                      calcButton('C', color: Colors.redAccent),
                      calcButton('±'),
                      calcButton('%'),
                      calcButton('÷', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      calcButton('7'),
                      calcButton('8'),
                      calcButton('9'),
                      calcButton('×', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      calcButton('4'),
                      calcButton('5'),
                      calcButton('6'),
                      calcButton('-', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      calcButton('1'),
                      calcButton('2'),
                      calcButton('3'),
                      calcButton('+', color: Colors.orange),
                    ],
                  ),
                  Row(
                    children: [
                      calcButton('0', flex: 2),
                      calcButton('.'),
                      calcButton('=', color: Colors.greenAccent),
                    ],
                  ),
                  // ✅ Removed the bottom "Backspace" or extra divider row
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
