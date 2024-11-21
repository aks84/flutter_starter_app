// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Mode Toggle
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Switch between light and dark themes'),
              value: themeProvider.currentTheme.brightness == Brightness.dark,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Font Size Customization
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Font Size: ${themeProvider.fontSize.toStringAsFixed(1)}', 
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Slider(
                  value: themeProvider.fontSize,
                  min: 12.0,
                  max: 24.0,
                  divisions: 12,
                  label: themeProvider.fontSize.toStringAsFixed(1),
                  onChanged: (double value) {
                    themeProvider.setFontSize(value);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          
          // Accent Color Picker
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Accent Color', 
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _colorButton(Colors.deepPurple, themeProvider),
                      _colorButton(Colors.blue, themeProvider),
                      _colorButton(Colors.green, themeProvider),
                      _colorButton(Colors.red, themeProvider),
                      _colorButton(Colors.orange, themeProvider),
                      _colorButton(Colors.pink, themeProvider),
                      _colorButton(Colors.teal, themeProvider),
                      _colorButton(Colors.indigo, themeProvider),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Custom Color Picker
          Card(
            child: ListTile(
              title: const Text('Custom Color'),
              subtitle: const Text('Pick a custom accent color'),
              trailing: const Icon(Icons.color_lens),
              onTap: () => _showColorPickerDialog(context, themeProvider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorButton(Color color, ThemeProvider themeProvider) {
    return GestureDetector(
      onTap: () => themeProvider.setAccentColor(color),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: themeProvider.accentColor == color 
              ? Colors.white 
              : Colors.grey.withOpacity(0.5),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPickerDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color? selectedColor = themeProvider.accentColor;
        return AlertDialog(
          title: const Text('Pick a Custom Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Select'),
              onPressed: () {
                if (selectedColor != null) {
                  themeProvider.setAccentColor(selectedColor!);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Simple color picker widget (you might want to use a more advanced package)
class ColorPicker extends StatefulWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
  });

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color Sliders
        _colorSlider(
          label: 'Red',
          value: _currentColor.red,
          onChanged: (value) {
            setState(() {
              _currentColor = Color.fromRGBO(
                value.round(),
                _currentColor.green,
                _currentColor.blue,
                1,
              );
              widget.onColorChanged(_currentColor);
            });
          },
        ),
        _colorSlider(
          label: 'Green',
          value: _currentColor.green,
          onChanged: (value) {
            setState(() {
              _currentColor = Color.fromRGBO(
                _currentColor.red,
                value.round(),
                _currentColor.blue,
                1,
              );
              widget.onColorChanged(_currentColor);
            });
          },
        ),
        _colorSlider(
          label: 'Blue',
          value: _currentColor.blue,
          onChanged: (value) {
            setState(() {
              _currentColor = Color.fromRGBO(
                _currentColor.red,
                _currentColor.green,
                value.round(),
                1,
              );
              widget.onColorChanged(_currentColor);
            });
          },
        ),
        const SizedBox(height: 20),
        // Color Preview
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: _currentColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _colorSlider({
    required String label,
    required int value,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(label),
        ),
        Expanded(
          flex: 4,
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            divisions: 255,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}