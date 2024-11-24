class InspectionNote {
  final String note;
  final List<String> files; // List of file paths for images or videos

  InspectionNote({
    required this.note,
    this.files = const [],
  });
}
