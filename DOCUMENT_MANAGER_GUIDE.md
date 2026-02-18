# 📁 Document Manager Service

Complete file and document management system for KixxGPT app.

## Overview

The DocumentManager service handles:
- 📎 Managing attached files/documents
- 🖼️ Tracking image attachments
- 📊 Document metadata
- 🎯 Adding/removing documents
- 📈 Document state management

---

## Components

### 1. AttachedDocument Model

Data model representing a single attached document.

```dart
class AttachedDocument {
  final String name;        // Document name/filename
  final String type;        // Type: 'image', 'file', 'video', etc.
  final String path;        // File system path
  final DateTime addedAt;   // When document was added
  final IconData icon;      // Icon to display
}
```

**Example:**
```dart
final doc = AttachedDocument(
  name: 'budget_2026.pdf',
  type: 'file',
  path: '/downloads/budget_2026.pdf',
  icon: Icons.attach_file,
  addedAt: DateTime.now(),
);
```

---

### 2. DocumentManager Service

Main service class for managing collections of documents.

#### Methods:

##### `addDocument(String name, String type, String path, IconData icon)`
Add a new document to the collection.

```dart
_documentManager.addDocument(
  'screenshot.png',
  'image',
  '/screenshots/screenshot.png',
  Icons.image,
);
```

---

##### `removeDocument(int index)`
Remove a document by index.

```dart
_documentManager.removeDocument(0);  // Remove first document
```

---

##### `clearDocuments()`
Remove all documents from the collection.

```dart
_documentManager.clearDocuments();
```

---

##### `getDocuments()`
Get all documents (unmodifiable list).

```dart
List<AttachedDocument> docs = _documentManager.getDocuments();
```

---

##### `count` (getter)
Get the number of attached documents.

```dart
int total = _documentManager.count;
if (total > 0) {
  print('Documents attached: $total');
}
```

---

### 3. DocumentDisplay Widget

UI component to show attached documents.

```dart
DocumentDisplay(
  documents: _documentManager.documents,
  onRemove: (index) {
    setState(() {
      _documentManager.removeDocument(index);
    });
  },
)
```

**Features:**
- Responsive wrap layout
- Individual chips per document
- Icon + name display
- Remove button (X icon)
- Styled with theme colors

---

## Usage Examples

### Basic Setup

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DocumentManager _documentManager;

  @override
  void initState() {
    super.initState();
    _documentManager = DocumentManager();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DocumentDisplay(
            documents: _documentManager.documents,
            onRemove: (index) {
              setState(() => _documentManager.removeDocument(index));
            },
          ),
          ElevatedButton(
            onPressed: () {
              _documentManager.addDocument(
                'file.pdf',
                'document',
                '/path/file.pdf',
                Icons.file_download,
              );
              setState(() {});
            },
            child: const Text('Add Document'),
          ),
        ],
      ),
    );
  }
}
```

### With File Picker Integration

```dart
import 'package:file_picker/file_picker.dart';

void pickAndAddFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  
  if (result != null) {
    final file = result.files.first;
    _documentManager.addDocument(
      file.name,
      file.extension ?? 'unknown',
      file.path ?? '',
      Icons.attach_file,
    );
    setState(() {});
  }
}
```

### With Image Picker Integration

```dart
import 'package:image_picker/image_picker.dart';

void pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    _documentManager.addDocument(
      image.name,
      'image',
      image.path,
      Icons.image,
    );
    setState(() {});
  }
}
```

### Send Message with Documents

```dart
void sendMessageWithAttachments() {
  final message = _messageController.text;
  final attachments = _documentManager.getDocuments();

  // Create payload
  final payload = {
    'message': message,
    'attachments': attachments.map((doc) => {
      'name': doc.name,
      'type': doc.type,
      'path': doc.path,
    }).toList(),
  };

  // Send to API
  sendToAPI(payload);

  // Clear after sending
  _messageController.clear();
  _documentManager.clearDocuments();
}
```

---

## Integration with ChatInputBar

```dart
ChatInputBar(
  controller: _messageController,
  onSend: () {
    // Get documents before sending
    final docs = _documentManager.getDocuments();
    debugPrint('Sending ${docs.length} attachments');
    
    // Send message + documents
    sendMessage(_messageController.text, docs);
    
    // Clear
    _messageController.clear();
    _documentManager.clearDocuments();
  },
  onVoicePressed: _handleVoice,
  onAttachmentPressed: () {
    // Show attachment options
    showModalBottomSheet(
      context: context,
      builder: (context) => QuickActionMenu(
        onPhotos: () => _addPhoto(),
        onCamera: () => _addCamera(),
        onFiles: () => _addFile(),
        onCreateImage: () => _createImage(),
      ),
    );
  },
)
```

---

## Document Types

Common document type codes:

| Type | Icon | Description |
|------|------|-------------|
| `image` | 🖼️ | Photos/Images |
| `file` | 📄 | Documents (PDF, DOC, etc.) |
| `video` | 🎬 | Video files |
| `audio` | 🎵 | Audio files |
| `code` | 💻 | Source code files |
| `archive` | 📦 | Compressed files |
| `spreadsheet` | 📊 | Excel/CSV files |

---

## State Management

### Local State with setState:
```dart
void _addDocument() {
  _documentManager.addDocument(
    'file.pdf',
    'file',
    '/path/',
    Icons.attach_file,
  );
  setState(() {});  // Trigger rebuild
}
```

### With Provider (for larger apps):
```dart
class DocumentNotifier extends ChangeNotifier {
  final DocumentManager _manager = DocumentManager();

  void addDocument(String name, String type, String path, IconData icon) {
    _manager.addDocument(name, type, path, icon);
    notifyListeners();
  }

  void removeDocument(int index) {
    _manager.removeDocument(index);
    notifyListeners();
  }

  List<AttachedDocument> get documents => _manager.getDocuments();
}
```

---

## API Integration

### Sending with HTTP:
```dart
import 'package:http/http.dart' as http;

Future<void> sendWithAttachments() async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://api.kixxgpt.com/messages'),
  );

  // Add text
  request.fields['message'] = _messageController.text;

  // Add documents
  for (var doc in _documentManager.documents) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'attachments',
        doc.path,
        filename: doc.name,
      ),
    );
  }

  var response = await request.send();
  if (response.statusCode == 200) {
    _documentManager.clearDocuments();
  }
}
```

---

## Validation

Add file validation:

```dart
bool isValidFileSize(String path, int maxMB) {
  final file = File(path);
  final bytes = file.lengthSync();
  return bytes <= (maxMB * 1024 * 1024);
}

bool isValidFileType(String filename, List<String> allowedTypes) {
  final ext = filename.split('.').last.toLowerCase();
  return allowedTypes.contains(ext);
}

void addDocumentWithValidation(
  String name,
  String type,
  String path,
  IconData icon,
) {
  if (!isValidFileSize(path, 50)) {
    _showError('File too large (max 50MB)');
    return;
  }

  if (!isValidFileType(name, ['pdf', 'doc', 'docx', 'txt'])) {
    _showError('Invalid file type');
    return;
  }

  _documentManager.addDocument(name, type, path, icon);
  setState(() {});
}
```

---

## Limitations & Notes

### Current Version:
- Mock implementation (no actual file I/O)
- Max 10 documents per message (by design)
- No file size limits enforced
- No duplicate prevention
- In-memory storage (cleared on app restart)

### To Implement Real Features:
1. Add `file_picker` package
2. Add `image_picker` package
3. Add `cached_manager` for storage
4. Add validation logic
5. Implement upload progress
6. Add error handling
7. Store documents persistently

---

## Performance Considerations

- Documents stored in List (linear search for removal)
- For 100+ documents, consider using Map with IDs
- Use DocumentDisplay with Wrap (responsive, auto-layout)
- Clear documents after sending to free memory

---

## Error Handling

```dart
try {
  _documentManager.addDocument(name, type, path, icon);
  setState(() {});
} on Exception catch (e) {
  _showError('Failed to add document: $e');
}

try {
  _documentManager.removeDocument(index);
  setState(() {});
} on RangeError {
  _showError('Document not found');
}
```

---

## Complete Example

See [full implementation in main.dart](lib/main.dart)
