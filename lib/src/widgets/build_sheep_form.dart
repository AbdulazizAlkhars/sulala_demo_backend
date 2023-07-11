import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class BuildSheepFormFields extends StatelessWidget {
  const BuildSheepFormFields({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Sheep Breed',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the sheep breed';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Sheep Image',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the sheep image URL';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Sheep Sex',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the sheep sex';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Sheep Tags',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the sheep tags';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Sheep Notes',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Sheep Custom Fields',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Date of Mate',
            border: OutlineInputBorder(),
          ),
          onTap: () {
            _showDatePicker(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the date of mate';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Date of Dead or Sell',
            border: OutlineInputBorder(),
          ),
          onTap: () {
            _showDatePicker(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the date of dead or sell';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Date of Weaning',
            border: OutlineInputBorder(),
          ),
          onTap: () {
            _showDatePicker(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the date of weaning';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
            border: OutlineInputBorder(),
          ),
          onTap: () {
            _showDatePicker(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the date of birth';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? pickedDate = await showRoundedDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      theme: ThemeData(primarySwatch: Colors.green),
    );
    if (pickedDate != null) {
      // Do something with the pickedDate
    }
  }
}
