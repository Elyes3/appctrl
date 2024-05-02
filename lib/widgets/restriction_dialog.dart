import 'package:flutter/material.dart';
import 'package:parentalctrl/models/user.dart';
import 'package:parentalctrl/providers/children_provider.dart';
import 'package:parentalctrl/services/children_service.dart';
import 'package:parentalctrl/utils/date.dart';
import 'package:provider/provider.dart';

class RestrictionDialog extends StatefulWidget {
  const RestrictionDialog({required this.child, required this.app, super.key});
  final Child child;
  final App app;
  @override
  State<RestrictionDialog> createState() => _MyDialogState();
}

late TextEditingController _time;
late bool _untilReactivation;

class _MyDialogState extends State<RestrictionDialog> {
  @override
  void initState() {
    super.initState();
    _time = TextEditingController(text: millisToTime(widget.app.time));
    _untilReactivation = widget.app.untilReactivation;
  }

  ChildrenService childrenService = ChildrenService();
  @override
  Widget build(BuildContext context) {
    final ChildrenProvider childrenProvider =
        Provider.of<ChildrenProvider>(context);
    submitRestrictions() {
      childrenProvider.updateRestrictions(
          widget.child, _untilReactivation, _time.text, widget.app);
      Navigator.of(context).pop();
    }

    return AlertDialog(
      title: const Text('Daily restrictions'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            enabled: !_untilReactivation,
            controller: _time,
            onChanged: (value) {
              setState(() {
                _time.text = value;
              });
            },
            decoration: const InputDecoration(
              hintText: 'hh:ss',
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Restrict until reactivation'),
              Switch(
                value: _untilReactivation,
                activeColor: Colors.white,
                activeTrackColor: Colors.blue,
                inactiveThumbColor: Colors.blue,
                inactiveTrackColor: Colors.white,
                trackOutlineColor: MaterialStateProperty.all(Colors.blue),
                onChanged: (value) {
                  setState(() {
                    _time.text = '';
                    _untilReactivation = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: submitRestrictions,

          // Close the dialog
          child: const Text('OK'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _time.dispose();
    super.dispose();
  }
}
