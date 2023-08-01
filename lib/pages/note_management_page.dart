import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_app/generated/locale_keys.g.dart';
import 'package:note_app/note.dart';
import 'package:note_app/note_operations.dart';
import 'package:crypto/crypto.dart' as crypto;

class NoteManagementPage extends StatefulWidget {
  const NoteManagementPage(
      {Key? key, required this.note, required this.operation})
      : super(key: key);

  final Note note;
  final NoteOperations operation;

  @override
  State<NoteManagementPage> createState() => _NoteManagementPageState();
}

class _NoteManagementPageState extends State<NoteManagementPage> {
  late TextEditingController _moodController;
  late TextEditingController _contentController;
  late FocusNode _moodFocus;
  late FocusNode _contentFocus;
  late Note _currentNote;
  late DateTime _currentDate;
  late NoteOperations _operation;

  late ({Note note, NoteOperations operation}) output;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
    _operation = widget.operation;
    _moodFocus = FocusNode();
    _contentFocus = FocusNode();
    _moodController = TextEditingController();
    _contentController = TextEditingController();
    _moodController.text = _currentNote.mood;
    _contentController.text = _currentNote.content;
    _currentDate = widget.operation == NoteOperations.create
        ? DateTime.now()
        : DateTime.parse(_currentNote.date);
  }

  @override
  void dispose() {
    _moodFocus.dispose();
    _moodController.dispose();
    _contentFocus.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<DateTime> selectDate(DateTime initialDate) async {
    final selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: initialDate.subtract(const Duration(days: 365)),
        lastDate: initialDate.add(const Duration(days: 365)));
    return selectedDate ?? initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: (_operation == NoteOperations.create)
          ? Text(LocaleKeys.newNote.tr())
          : Text(LocaleKeys.updateNote.tr()),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10))),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
            onPressed: () {
              output = (note: _currentNote, operation: NoteOperations.cancel);
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pop(context, output);
            },
            icon: const Icon(Icons.cancel_outlined)),
        IconButton(
          onPressed: () {
            _currentNote.mood = _moodController.text;
            _currentNote.content = _contentController.text;
            _currentNote.date = _currentDate.toString();
            if (_operation == NoteOperations.create) {
              _currentNote.id = crypto.sha1
                  .convert(utf8.encode(_currentNote.date))
                  .toString();
            }
            output = (note: _currentNote, operation: _operation);
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context, output);
          },
          icon: const Icon(Icons.check),
        )
      ],
    );
  }

  SafeArea _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 5.0),
        child: Column(
          children: [
            TextButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  var selectedDate = await selectDate(_currentDate);
                  setState(() {
                    _currentDate = selectedDate;
                  });
                },
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(top: 32.0, bottom: 32.0)),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 35,
                    ),
                    const Padding(padding: EdgeInsets.all(6.0)),
                    Text(DateFormat.yMMMMEEEEd().format(_currentDate),
                        style: const TextStyle(color: Colors.black, fontSize: 17))
                  ],
                )),
            TextField(
              controller: _moodController,
              focusNode: _moodFocus,
              decoration: InputDecoration(
                  labelText: LocaleKeys.mood.tr(),
                  icon: const Icon(
                    Icons.mood,
                    color: Colors.amber,
                    size: 30.0,
                  )),
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            TextField(
              controller: _contentController,
              focusNode: _contentFocus,
              maxLines: null,
              decoration: InputDecoration(
                  labelText: LocaleKeys.text.tr(),
                  icon: const Icon(
                    Icons.subject,
                    color: Colors.amber,
                    size: 30.0,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
