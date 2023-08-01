import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_app/generated/locale_keys.g.dart';
import 'package:note_app/note.dart';
import 'package:note_app/note_operations.dart';

import 'note_management_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10))),
        centerTitle: true,
        title: Text(LocaleKeys.myNotes.tr()),
      ),
      floatingActionButton: const _HomePageFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
          color: Colors.amber,
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Padding(padding: EdgeInsets.only(top: 40))),
      body: homePageBody,
    );
  }

  SafeArea get homePageBody {
    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: Hive.box<Note>('notes').listenable(),
          builder: (BuildContext context, Box<Note> box, _) {
            return box.isEmpty
                ? Center(
                    child: Text(
                      LocaleKeys.noNotes.tr(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.separated(
                      itemCount: box.values.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        thickness: 1,
                        color: Colors.white,
                        height: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerLeft,
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 26.0),
                                  child: Icon(Icons.delete_rounded,
                                      color: Colors.white),
                                )),
                            secondaryBackground: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 26.0),
                                  child: Icon(Icons.delete_rounded,
                                      color: Colors.white),
                                )),
                            onDismissed: (direction) {
                              setState(() {
                                box.delete(
                                    _sortNotesInBoxByDateDesc(box)[index].id);
                              });
                            },
                            child: ListTile(
                              tileColor: Colors.amberAccent.shade100,
                              leading: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(DateFormat.MMM().format(DateTime.parse(
                                      _sortNotesInBoxByDateDesc(box)[index]
                                          .date))),
                                  Text(DateFormat.d().format(DateTime.parse(
                                      _sortNotesInBoxByDateDesc(box)[index]
                                          .date))),
                                ],
                              ),
                              title: Text(
                                  _sortNotesInBoxByDateDesc(box)[index].mood),
                              subtitle: Text(
                                  _sortNotesInBoxByDateDesc(box)[index].content,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18)),
                              onTap: () async {
                                final noteChanges = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NoteManagementPage(
                                                note: _sortNotesInBoxByDateDesc(
                                                    box)[index],
                                                operation:
                                                    NoteOperations.update)));
                                _acceptNotesChanges(noteChanges);
                              },
                            ));
                      },
                    ),
                  );
          }),
    );
  }
}

class _HomePageFloatingActionButton extends StatelessWidget {
  const _HomePageFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final noteChanges = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NoteManagementPage(
                      note: Note.empty(),
                      operation: NoteOperations.create,
                    )));
        _acceptNotesChanges(noteChanges);
      },
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

void _acceptNotesChanges(
    ({Note note, NoteOperations operation}) updatedNoteData) async {
  if (updatedNoteData.operation != NoteOperations.cancel) {
    await Hive.box<Note>('notes')
        .put(updatedNoteData.note.id, updatedNoteData.note);
  }
}

List<Note> _sortNotesInBoxByDateDesc(Box<Note> box) {
  final notes = box.values.toList();
  notes.sort((a, b) => b.date.compareTo(a.date));
  return notes;
}
