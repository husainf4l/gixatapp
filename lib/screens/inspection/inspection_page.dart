import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:gixatapp/classes/inspection_note_model.dart';

class InspectionPage extends StatefulWidget {
  @override
  _InspectionPageState createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  String selectedClient = '';
  String selectedCar = '';
  final List<String> clients = ['Client A', 'Client B', 'Client C'];
  final List<String> cars = ['Car A', 'Car B', 'Car C'];

  List<InspectionNote> notes = [];
  List<String> predefinedNotes = [
    'Check engine',
    'Inspect tires',
    'Check oil level',
    'Inspect brakes',
    'Inspect lights'
  ];
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Add listener to noteController
    noteController.addListener(() {
      // Explicitly call setState to update the debug text
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Remove listener
    noteController.removeListener(() {});
    noteController.dispose();
    super.dispose();
  }

  void _addNote(String note) {
    if (note.trim().isEmpty || selectedClient.isEmpty || selectedCar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a client and car first!')),
      );
      return;
    }
    setState(() {
      if (!predefinedNotes.contains(note)) {
        predefinedNotes.add(note);
      }
      notes.add(InspectionNote(note: note, files: []));
    });
    noteController.clear();
  }

  Future<void> _selectFilesForNote(int index) async {
    final imagePicker = ImagePicker();

    // Show a modal bottom sheet with options
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Capture Image'),
                onTap: () async {
                  final pickedFile = await imagePicker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      notes[index].files.add(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Select Image from Gallery'),
                onTap: () async {
                  final pickedFile = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      notes[index].files.add(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam),
                title: const Text('Capture/Select Video'),
                onTap: () async {
                  final pickedFile = await imagePicker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      notes[index].files.add(pickedFile.path);
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildClientSelector(),
                const SizedBox(height: 16),
                _buildCarSelector(),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400, // Consistent size for the notes section
                  child: _buildInspectionNotesSection(),
                ),
                const SizedBox(height: 16),
                _buildAddNoteInput(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientSelector() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return clients.where((client) =>
            client.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selection) {
        setState(() {
          selectedClient = selection;
        });
      },
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode focusNode, VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Select Client',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildCarSelector() {
    return DropdownButtonFormField<String>(
      value: selectedCar.isEmpty ? null : selectedCar,
      items: cars.map((car) {
        return DropdownMenuItem(
          value: car,
          child: Text(car),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCar = value!;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Select Car',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildInspectionNotesSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.note),
                const SizedBox(height: 8),
                if (note.files.isNotEmpty)
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: note.files.map((file) {
                      if (file.endsWith('.mp4') || file.endsWith('.mov')) {
                        return _buildVideoThumbnail(file); // Handle videos
                      } else {
                        return _buildImageThumbnail(file); // Handle images
                      }
                    }).toList(),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.add_photo_alternate, color: Colors.blue),
                  onPressed: () => _selectFilesForNote(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      notes.removeAt(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoThumbnail(String filePath) {
    final controller = VideoPlayerController.file(File(filePath));
    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      notes.forEach((note) {
                        note.files.remove(filePath);
                      });
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          return Container(
            height: 100,
            width: 100,
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _buildImageThumbnail(String filePath) {
    return Stack(
      children: [
        Image.file(
          File(filePath),
          height: 100,
          width: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Display a fallback for invalid image data
            return Container(
              height: 100,
              width: 100,
              color: Colors.black12,
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.red),
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: const Icon(Icons.close, size: 16),
            color: Colors.red,
            onPressed: () {
              setState(() {
                notes.forEach((note) {
                  note.files.remove(filePath);
                });
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the current text of noteController
        Text("Debug: ${noteController.text}"),
        if (noteController.text.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: Card(
              child: ListView(
                padding: EdgeInsets.zero,
                children: predefinedNotes
                    .where((note) =>
                        note.toLowerCase().contains(noteController.text))
                    .map((note) => ListTile(
                          title: Text(note),
                          onTap: () {
                            _addNote(note);
                          },
                        ))
                    .toList(),
              ),
            ),
          ),
        const SizedBox(height: 8),
        TextField(
          controller: noteController,
          decoration: const InputDecoration(
            hintText: 'Add a note',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _addNote(value);
            }
          },
        ),
      ],
    );
  }
}
