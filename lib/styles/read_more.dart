import 'package:addmission_app/styles/app_font_text.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(this.callDetails, {super.key});

  final List<CallLogEntry>? callDetails;

  @override
  State<ReadMoreText> createState() => _ReadMoreTextState();
}
class _ReadMoreTextState extends State<ReadMoreText> with SingleTickerProviderStateMixin<ReadMoreText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 150),
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: _isExpanded ? (widget.callDetails?.length ?? 0) : 0,
            itemBuilder: (context, index) {
              final call = widget.callDetails?[index] ?? CallLogEntry();
              if (kDebugMode) {
                print("call timeStamp : ${call.timestamp}");
              }
              return ((index == 0) || (index == 1)) ? const SizedBox() : ListTile(
                contentPadding: EdgeInsets.zero,
                leading: (call.callType == CallType.incoming) ? Icon(Icons.call_received, color: Colors.green) : Icon(Icons.call_made, color: Colors.red),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppFontText().paragraphSmallText(DateFormat("dd MMMM yyyy, HH:mm a").format(DateTime.fromMillisecondsSinceEpoch((call.timestamp!))), Colors.black),
                    AppFontText().paragraphMediumText('${(call.callType == CallType.incoming)  ? 'Incoming' : 'Outgoing'} Call', Colors.black54),
                  ],
                ),
                subtitle: Text('Duration: ${call.duration}', style: TextStyle(fontSize: 14)
                ),
              );
          },)
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            setState(() => _isExpanded = !_isExpanded);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppFontText().labelMediumText(!_isExpanded ? 'More about Calls ' : "Collapse", Colors.blueAccent),
              Icon(_isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.black54),
            ],
          ),
        ),
      ],
    );
  }
}