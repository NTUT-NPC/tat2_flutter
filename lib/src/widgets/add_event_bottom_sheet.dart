import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/local_calendar_event.dart';
import '../l10n/app_localizations.dart';

/// 新增/編輯事件 Bottom Sheet
class AddEventBottomSheet extends StatefulWidget {
  final LocalCalendarEvent? event; // 如果為 null 則是新增，否則是編輯
  final DateTime? initialDate; // 初始日期

  const AddEventBottomSheet({
    super.key,
    this.event,
    this.initialDate,
  });

  @override
  State<AddEventBottomSheet> createState() => _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends State<AddEventBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  late DateTime _startDate;
  TimeOfDay? _startTime;
  late DateTime _endDate;
  TimeOfDay? _endTime;
  bool _isAllDay = false;
  RecurrenceType _recurrenceType = RecurrenceType.none;
  DateTime? _recurrenceEndDate;
  String _selectedColor = '#2196F3';
  bool _isAdvancedMode = false;

  // 顏色選項將在 build 時動態生成以支援國際化
  List<Map<String, dynamic>> _getColorOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      {'name': l10n.colorBlue, 'value': '#2196F3'},
      {'name': l10n.colorRed, 'value': '#F44336'},
      {'name': l10n.colorGreen, 'value': '#4CAF50'},
      {'name': l10n.colorOrange, 'value': '#FF9800'},
      {'name': l10n.colorPurple, 'value': '#9C27B0'},
      {'name': l10n.colorPink, 'value': '#E91E63'},
      {'name': l10n.colorTeal, 'value': '#00BCD4'},
      {'name': l10n.colorYellow, 'value': '#FFEB3B'},
    ];
  }

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      // 編輯模式
      final event = widget.event!;
      _titleController.text = event.title;
      _descriptionController.text = event.description ?? '';
      _locationController.text = event.location ?? '';
      _startDate = event.startTime;
      _endDate = event.endTime;
      _isAllDay = event.isAllDay;
      _recurrenceType = event.recurrenceType;
      _recurrenceEndDate = event.recurrenceEndDate;
      _selectedColor = event.color;
      
      if (!event.isAllDay && (event.startTime.hour != 0 || event.startTime.minute != 0)) {
        _startTime = TimeOfDay.fromDateTime(event.startTime);
      }
      if (!event.isAllDay && (event.endTime.hour != 0 || event.endTime.minute != 0)) {
        _endTime = TimeOfDay.fromDateTime(event.endTime);
      }
    } else {
      // 新增模式
      final selectedDate = widget.initialDate ?? DateTime.now();
      _startDate = selectedDate;
      _endDate = selectedDate;
      _startTime = null;
      _endTime = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 拖動手柄
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // 標題欄
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.event == null 
                            ? AppLocalizations.of(context).addEvent 
                            : AppLocalizations.of(context).editEvent,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // 表單內容
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleField(),
                        const SizedBox(height: 16),
                        _buildDateField(),
                        const SizedBox(height: 12),
                        _buildAdvancedToggle(),
                        const SizedBox(height: 8),
                        if (_isAdvancedMode) ...[
                          _buildDescriptionField(),
                          const SizedBox(height: 16),
                          _buildLocationField(),
                          const SizedBox(height: 16),
                          _buildAllDaySwitch(),
                          const SizedBox(height: 8),
                          if (!_isAllDay) ...[
                            _buildTimeSection(),
                            const SizedBox(height: 16),
                          ],
                          _buildRecurrenceSection(),
                          const SizedBox(height: 16),
                          _buildColorPicker(),
                          const SizedBox(height: 16),
                        ],
                        _buildSaveButton(),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleField() {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: l10n.titleRequired,
        prefixIcon: const Icon(Icons.title),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.pleaseEnterTitle;
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.date,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectStartDate,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
              child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 12),
                Text(
                  DateFormat(l10n.dateFormatWithWeekday, Localizations.localeOf(context).toString()).format(_startDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: l10n.description,
        prefixIcon: const Icon(Icons.description),
        border: const OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildLocationField() {
    final l10n = AppLocalizations.of(context);
    return TextFormField(
      controller: _locationController,
      decoration: InputDecoration(
        labelText: l10n.location,
        prefixIcon: const Icon(Icons.location_on),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAllDaySwitch() {
    final l10n = AppLocalizations.of(context);
    return SwitchListTile(
      title: Text(l10n.allDayEvent),
      value: _isAllDay,
      onChanged: (value) {
        setState(() {
          _isAllDay = value;
        });
      },
      secondary: const Icon(Icons.event_available),
    );
  }

  Widget _buildTimeSection() {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _buildTimeButton(
            label: l10n.startTime,
            time: _startTime,
            onTap: _selectStartTime,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTimeButton(
            label: l10n.endTime,
            time: _endTime,
            onTap: _selectEndTime,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeButton({
    required String label,
    TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 8),
                Text(
                  time != null ? time.format(context) : l10n.notSet,
                  style: TextStyle(
                    color: time != null ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedToggle() {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          _isAdvancedMode = !_isAdvancedMode;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              _isAdvancedMode ? Icons.expand_less : Icons.expand_more,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.moreOptions,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    final l10n = AppLocalizations.of(context);
    final colorOptions = _getColorOptions(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.color,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colorOptions.map((colorOption) {
            final colorValue = colorOption['value'] as String;
            final isSelected = _selectedColor == colorValue;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colorValue;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _parseColor(colorValue),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecurrenceSection() {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recurrence,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<RecurrenceType>(
          value: _recurrenceType,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.repeat),
            border: OutlineInputBorder(),
          ),
          items: RecurrenceType.values.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(_getRecurrenceText(type)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _recurrenceType = value!;
            });
          },
        ),
        if (_recurrenceType != RecurrenceType.none) ...[
          const SizedBox(height: 8),
          InkWell(
            onTap: _selectRecurrenceEndDate,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_busy),
                  const SizedBox(width: 8),
                  Text(
                    _recurrenceEndDate == null
                        ? l10n.selectEndDateOptional
                        : l10n.endOn(DateFormat('yyyy/MM/dd').format(_recurrenceEndDate!)),
                  ),
                  const Spacer(),
                  if (_recurrenceEndDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _recurrenceEndDate = null;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getRecurrenceText(RecurrenceType type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case RecurrenceType.none:
        return l10n.noRecurrence;
      case RecurrenceType.daily:
        return l10n.daily;
      case RecurrenceType.weekly:
        return l10n.weekly;
      case RecurrenceType.monthly:
        return l10n.monthly;
      case RecurrenceType.yearly:
        return l10n.yearly;
    }
  }

  Widget _buildSaveButton() {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _saveEvent,
        icon: const Icon(Icons.check),
        label: Text(widget.event == null ? l10n.add : l10n.save),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: Localizations.localeOf(context),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _endDate = picked; // 結束日期跟著開始日期
      });
    }
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> _selectRecurrenceEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _recurrenceEndDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2030),
      locale: Localizations.localeOf(context),
    );
    if (picked != null) {
      setState(() {
        _recurrenceEndDate = picked;
      });
    }
  }

  void _saveEvent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 組合日期和時間
    DateTime startDateTime = _startDate;
    DateTime endDateTime = _endDate;

    if (!_isAllDay && _startTime != null) {
      startDateTime = DateTime(
        _startDate.year,
        _startDate.month,
        _startDate.day,
        _startTime!.hour,
        _startTime!.minute,
      );
    }

    if (!_isAllDay && _endTime != null) {
      endDateTime = DateTime(
        _endDate.year,
        _endDate.month,
        _endDate.day,
        _endTime!.hour,
        _endTime!.minute,
      );
    }

    // 驗證時間
    if (endDateTime.isBefore(startDateTime)) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.endTimeBeforeStart),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final event = LocalCalendarEvent(
      id: widget.event?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      startTime: startDateTime,
      endTime: endDateTime,
      isAllDay: _isAllDay,
      color: _selectedColor,
      recurrenceType: _recurrenceType,
      recurrenceEndDate: _recurrenceEndDate,
      createdAt: widget.event?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, event);
  }

  Color _parseColor(String colorString) {
    try {
      final hex = colorString.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      // 解析失敗，返回預設藍色
    }
    return Colors.blue;
  }
}
