import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kixxgpt/models/message.dart';
import 'package:kixxgpt/pages/chat_page_widget.dart';
import 'package:kixxgpt/pages/home_page.dart';
import 'package:kixxgpt/pages/settings_page.dart';
import 'package:kixxgpt/services/document_manager.dart';
import 'package:kixxgpt/widgets/app_drawer.dart';
import 'package:kixxgpt/widgets/chat_input_bar.dart';
import 'package:kixxgpt/widgets/quick_action_menu.dart';
import 'package:path_provider/path_provider.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

enum AppPage { home, chat, settings }

enum ChatScreenType {
  general,
  createImage,
  analyzeImages,
  helpWrite,
  summarizeText,
}

class _MainAppPageState extends State<MainAppPage> {
  AppPage _currentPage = AppPage.home;
  final List<String> _chatHistory = [
    'Chat about Flutter development',
    'Learning Dart basics',
    'UI Design patterns',
  ];
  int? _selectedChatIndex;
  late TextEditingController _messageController;
  late DocumentManager _documentManager;
  bool _showQuickActions = false;
  final ImagePicker _imagePicker = ImagePicker();
  final ValueNotifier<List<Message>> _messagesNotifier = ValueNotifier([]);
  final FocusNode _chatFocusNode = FocusNode();
  final ScrollController _chatScrollController = ScrollController();
  String _selectedModel = 'GPT-5.2';

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _documentManager = DocumentManager();
    // initial AI greeting
    _messagesNotifier.value = [
      Message(
        content:
            'Hello! I\'m KixxGPT, your AI assistant. How can I help you today?',
        isUser: false,
      ),
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _navigateToChat() {
    setState(() {
      _currentPage = AppPage.chat;
      _selectedChatIndex = null;
    });
  }

  void _openChatWithType(String type) {
    setState(() {
      _currentPage = AppPage.chat;
      _selectedChatIndex = null;
    });
  }

  void _navigateToHome() {
    setState(() {
      _currentPage = AppPage.home;
    });
  }

  void _navigateToSettings() {
    setState(() {
      _currentPage = AppPage.settings;
    });
  }

  void _selectChatFromHistory(int index) {
    setState(() {
      _currentPage = AppPage.chat;
      _selectedChatIndex = index;
    });
  }

  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    final message = _messageController.text;
    final documents = _documentManager.documents;

    // Log the message and documents
    debugPrint('Message: $message');
    debugPrint('Attached documents: ${documents.length}');
    for (var doc in documents) {
      debugPrint('  - ${doc.name} (${doc.type})');
    }

    // Clear input and documents
    _messageController.clear();
    setState(() {
      _documentManager.clearDocuments();
    });

    // add user message to chat
    final userMsg = Message(content: message, isUser: true);
    _messagesNotifier.value = List.from(_messagesNotifier.value)..add(userMsg);

    // simulate AI reply after a short delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final reply = Message(
        content: 'I received: "$message" — I can help with that.',
        isUser: false,
      );
      _messagesNotifier.value = List.from(_messagesNotifier.value)..add(reply);
      // ensure we're on chat page
      if (_currentPage != AppPage.chat) _navigateToChat();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    });
    // Navigate to chat if not already there
    if (_currentPage != AppPage.chat) {
      _navigateToChat();
    }
  }

  void _onSendPressed() {
    if (_messageController.text.isEmpty) return;
    if (_currentPage != AppPage.chat) {
      // navigate to chat first, then send
      _navigateToChat();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_chatFocusNode);
      });
    }
    // send message (will clear the controller and documents)
    _sendMessage();
  }

  Future<void> _handleVoicePressed(bool isRecording) async {
    if (isRecording) {
      // start mock recording
      _showSnackBar('🎤 Recording started');
    } else {
      // stop mock recording: create an empty temporary audio file and attach it
      try {
        final dir = await getTemporaryDirectory();
        final file = File(
          '${dir.path}${Platform.pathSeparator}voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
        );
        await file.writeAsBytes(<int>[]);
        final name = file.path.split(Platform.pathSeparator).last;
        _documentManager.addDocument(name, 'audio', file.path, Icons.mic);
        setState(() {});
        _showSnackBar('🎙️ Voice note added');
        if (_currentPage != AppPage.chat) _navigateToChat();
      } catch (e) {
        _showSnackBar('Recording failed: $e');
      }
    }
  }

  void _handleAttachmentPressed() {
    setState(() {
      _showQuickActions = !_showQuickActions;
    });
    if (_showQuickActions) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: QuickActionMenu(
                  onPhotos: () {
                    Navigator.pop(context);
                    _addPhoto();
                  },
                  onCamera: () {
                    Navigator.pop(context);
                    _addCamera();
                  },
                  onFiles: () {
                    Navigator.pop(context);
                    _addFile();
                  },
                  onCreateImage: () {
                    Navigator.pop(context);
                    _createImage();
                  },
                ),
              ),
            ),
          );
        },
      ).whenComplete(() {
        setState(() {
          _showQuickActions = false;
        });
      });
    }
  }

  Future<void> _addPhoto() async {
    // pick image from gallery
    Navigator.pop(context);
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked != null) {
        _documentManager.addDocument(
          picked.name,
          'image',
          picked.path,
          Icons.image,
        );
        setState(() {});
        _showSnackBar('✅ Photo added');
      }
    } catch (e) {
      if (e is MissingPluginException) {
        _showSnackBar(
          'Image picker not available on this platform. Run on Android/iOS or use the Files action.',
        );
      } else {
        _showSnackBar('Failed to pick photo: $e');
      }
    }
  }

  Future<void> _addCamera() async {
    Navigator.pop(context);
    try {
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (picked != null) {
        _documentManager.addDocument(
          picked.name,
          'image',
          picked.path,
          Icons.camera_alt,
        );
        setState(() {});
        _showSnackBar('✅ Camera capture added');
      }
    } catch (e) {
      if (e is MissingPluginException) {
        _showSnackBar(
          'Camera not available on this platform. Run on Android/iOS to use the camera.',
        );
      } else {
        _showSnackBar('Failed to capture photo: $e');
      }
    }
  }

  Future<void> _addFile() async {
    Navigator.pop(context);
    _showSnackBar(
      'File picker plugin removed for compatibility. Use Files app or add files via drag-and-drop.',
    );
  }

  void _createImage() {
    _showSnackBar('🎨 Image generation started...');
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _handleGetPlus() {
    _showGetPlusMenu();
  }

  void _showGetPlusMenu() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor = isDark ? Colors.grey[850] : Colors.white;
        final subtitleColor = isDark ? Colors.white70 : Colors.black54;
        final models = [
          {'id': 'gpt-5.2', 'title': 'GPT-5.2', 'subtitle': 'Flagship model'},
          {'id': 'gpt-4o', 'title': 'GPT-4o', 'subtitle': 'Multimodal, fast'},
          {'id': 'gpt-4', 'title': 'GPT-4', 'subtitle': 'Advanced reasoning'},
          {'id': 'gpt-3.5', 'title': 'GPT-3.5', 'subtitle': 'Cost-effective'},
        ];
        return Dialog(
          elevation: 6,
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 36,
            vertical: 80,
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Material(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome, size: 26),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'KixxGPT Plus',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Our smartest model & more',
                                  style: TextStyle(color: subtitleColor),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showSnackBar('Upgrade flow - coming soon');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.grey[700]
                                  : Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Upgrade'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(models.length, (i) {
                          final m = models[i];
                          final isSelected = m['title'] == _selectedModel;
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              m['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              m['subtitle']!,
                              style: TextStyle(color: subtitleColor),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check,
                                    color: isDark ? Colors.white : Colors.black,
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                _selectedModel = m['title']!;
                              });
                              Navigator.pop(context);
                              _showSnackBar('${m['title']} selected');
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSignIn() {
    _showSnackBar('👤 Sign In - Authentication coming soon!');
  }

  void _handleSignOut() {
    _showSnackBar('👋 Signed out');
    _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _currentPage == AppPage.home
          ? AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              title: ElevatedButton.icon(
                onPressed: _handleGetPlus,
                icon: const Icon(Icons.star, size: 18),
                label: Text('Get Plus $_selectedModel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10A37F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: _handleSignIn,
                ),
              ],
            )
          : AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[900]
                  : Colors.white,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _navigateToHome,
              ),
              title: const Text('KixxGPT'),
              centerTitle: true,
            ),
      drawer: AppDrawer(
        onNewChat: _navigateToChat,
        onSettings: _navigateToSettings,
        chatHistory: _chatHistory,
        selectedChatIndex: _selectedChatIndex,
        onSelectChat: _selectChatFromHistory,
        userName: 'Kamil Bombe',
        userEmail: null,
        userHandle: '@kamilbombe855',
        onProfileTap: _handleSignIn,
        onLogout: _handleSignOut,
      ),
      body: Column(
        children: [
          Expanded(
            child: _currentPage == AppPage.home
                ? HomePage(
                    onOpenChat: _openChatWithType,
                    messageController: _messageController,
                    onSendMessage: (message) => _sendMessage(),
                  )
                : _currentPage == AppPage.chat
                ? ChatPageWidget(
                    onBackPressed: _navigateToHome,
                    messagesNotifier: _messagesNotifier,
                    scrollController: _chatScrollController,
                  )
                : SettingsPage(
                    onBackPressed: _navigateToHome,
                    onLogout: _handleSignOut,
                  ),
          ),
          if (_documentManager.count > 0)
            DocumentDisplay(
              documents: _documentManager.documents,
              onRemove: (index) {
                setState(() {
                  _documentManager.removeDocument(index);
                });
              },
            ),
        ],
      ),
      bottomSheet: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          top: false,
          child: ChatInputBar(
            controller: _messageController,
            onSend: _onSendPressed,
            onVoicePressed: _handleVoicePressed,
            onAttachmentPressed: _handleAttachmentPressed,
            isLoading: false,
          ),
        ),
      ),
    );
  }
}
