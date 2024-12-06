import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const String _apiKey = 'Secret API key';

void main() {
  runApp(const GenerativeAISample());
}

class GenerativeAISample extends StatelessWidget {
  const GenerativeAISample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Safety Checker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xFF6200EE),
        ),
        useMaterial3: true,
      ),
      home: const ChatScreen(title: 'Product Safety Checker'),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const ChatWidget(apiKey: _apiKey),
    );
  }
}

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    required this.apiKey,
    super.key,
  });

  final String apiKey;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final List<({Image? image, TextSpan? text, bool fromUser})>
      _generatedContent = [];
  bool _loading = false;

  Map<String, String> _ingredientDatabase = {}; // Ingredient database

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: widget.apiKey,
    );
    _chat = _model.startChat();
    _loadIngredientDatabase();
  }

  // Load ingredient database from a local JSON file
  Future<void> _loadIngredientDatabase() async {
    final String data = await rootBundle.loadString('assets/ingredients.json');
    setState(() {
      _ingredientDatabase = Map<String, String>.from(json.decode(data).map(
            (key, value) => MapEntry(key.toLowerCase(), value),
          ));
    });
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _generatedContent.add((
          image: Image.file(File(pickedFile.path)),
          text: null,
          fromUser: true,
        ));
      });
      _processIngredients(File(pickedFile.path));
    }
  }

  Future<void> _processIngredients(File imageFile) async {
    setState(() {
      _loading = true;
    });

    try {
      // Extract ingredients from the image using OCR (or manual input in future).
      final extractedIngredients = await _extractIngredients(imageFile);

      // Check against the local ingredient database.
      final List<String> safeIngredients = [];
      final List<String> unsafeIngredients = [];

      for (final ingredient in extractedIngredients) {
        final normalizedIngredient = ingredient.toLowerCase();
        if (_ingredientDatabase.containsKey(normalizedIngredient)) {
          if (_ingredientDatabase[normalizedIngredient] == 'safe') {
            safeIngredients.add(ingredient);
          } else {
            unsafeIngredients.add(ingredient);
          }
        } else {
          unsafeIngredients
              .add(ingredient); // If not in database, consider unsafe
        }
      }

      // Display categorized ingredients
      _generatedContent.add((
        image: null,
        text: _categorizeIngredients(safeIngredients, unsafeIngredients),
        fromUser: false,
      ));

      _scrollDown();
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<List<String>> _extractIngredients(File imageFile) async {
    // Placeholder for OCR functionality (or manual input simulation).
    // Return mock data for testing.
    return [
      'Palm oil',
      'Refined wheat flour (Maida)',
      'Flavour enhancer (635)',
      'Water',
      'Sugar',
      'Vegetable oil'
    ];
  }

  TextSpan _categorizeIngredients(
      List<String> safeIngredients, List<String> unsafeIngredients) {
    return TextSpan(
      children: [
        const TextSpan(
          text: "Safe Ingredients:\n",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        ...safeIngredients.map(
          (e) => TextSpan(
            text: "- $e\n",
            style: const TextStyle(color: Colors.green),
          ),
        ),
        const TextSpan(
          text: "\nUnsafe Ingredients:\n",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        ...unsafeIngredients.map(
          (e) => TextSpan(
            text: "- $e\n",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _apiKey.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemBuilder: (context, idx) {
                      final content = _generatedContent[idx];
                      return MessageWidget(
                        text: content.text,
                        image: content.image,
                        isFromUser: content.fromUser,
                      );
                    },
                    itemCount: _generatedContent.length,
                  )
                : const Center(
                    child: Text('Please provide a valid API key.'),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Row(
              children: [
                IconButton(
                  onPressed:
                      !_loading ? () => _pickImage(ImageSource.gallery) : null,
                  icon: Icon(Icons.image,
                      color: _loading ? Colors.grey : Colors.blue),
                ),
                IconButton(
                  onPressed:
                      !_loading ? () => _pickImage(ImageSource.camera) : null,
                  icon: Icon(Icons.camera_alt,
                      color: _loading ? Colors.grey : Colors.blue),
                ),
                if (_loading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    this.image,
    this.text,
    required this.isFromUser,
  });

  final Image? image;
  final TextSpan? text;
  final bool isFromUser;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            decoration: BoxDecoration(
              color: isFromUser
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            margin: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null) image!,
                if (text != null)
                  RichText(
                    text: text!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
