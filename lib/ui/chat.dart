import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_in_production/main.dart';
import 'package:flutter_in_production/style/dark_style.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin{
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: Duration(seconds: 1),
    lowerBound: 0.25,
    upperBound: 1.0
  );

  late final _provider = GeminiProvider(
    model: GenerativeModel(
      model: 'gemini-1.5-pro', 
      apiKey: 'YOUR-API-KEY'
    )
  );

  final _galaxyMode = ValueNotifier(false);

  void _clearHistory(){
    _provider.history = [];
  }

  @override
  void initState() {
    super.initState();
    _resetAnimation();
  }

  void _resetAnimation(){
    _animationController.value = 1.0;
    _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: _galaxyMode, 
    builder: (context, halloween, child) => Scaffold(
      appBar: AppBar(
        title: Text(
          'ChatBot',
          style: TextStyle(
            color: !_galaxyMode.value
                ? (MyApp.themeMode.value == ThemeMode.dark 
                    ? Color(0xFFe0eaf5)
                    : Colors.black) 
                : Color(0xFFe0eaf5)
          ),
        ),
        backgroundColor: !_galaxyMode.value
            ? Colors.transparent
            : Color(0xFF0d2237),
        actions: [
          IconButton(
            onPressed: _clearHistory, 
            icon: Icon(
              Icons.history,
              color: !_galaxyMode.value
                  ? (MyApp.themeMode.value == ThemeMode.dark 
                    ? Color(0xFFe0eaf5)
                    : Colors.black) 
                  : Color(0xFFe0eaf5)
            )
          ),
          IconButton(
            onPressed: () => MyApp.themeMode.value =
                MyApp.themeMode.value == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light,
            tooltip: MyApp.themeMode.value == ThemeMode.light
                ? 'Dark Mode'
                : 'Light Mode',
            icon: Icon(
              Icons.brightness_4_outlined,
              color: !_galaxyMode.value
                  ? (MyApp.themeMode.value == ThemeMode.dark 
                    ? Color(0xFFe0eaf5)
                    : Colors.black) 
                  : Color(0xFFe0eaf5)
            ),
          ),
          IconButton(
            onPressed: (){
              _galaxyMode.value = !_galaxyMode.value;
              if (_galaxyMode.value) _resetAnimation();
            }, 
            tooltip: _galaxyMode.value ? 'Normal Mode' : 'Galaxy Mode',
            icon: Text(
              '🪐',
              style: TextStyle(
                fontSize: 20
              ),
            )
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController, 
        builder: (context, child) => Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/galaxy_bg.JPG',
                fit: BoxFit.cover,
                opacity: _animationController,
              ),
            ),
            LlmChatView(
              provider: _provider,
              style: style,
              welcomeMessage: 'Welcome to the Flutter AI Toolkit!',
            )
          ],
        )
      ),
    )
  );
  
  LlmChatViewStyle get style {
    if (!_galaxyMode.value){
      return MyApp.themeMode.value == ThemeMode.dark
        ? darkChatViewStyle()
        : LlmChatViewStyle.defaultStyle();
    }

    final TextStyle galaxyTextStyle = GoogleFonts.tsukimiRounded(
      color: Color(0xFFe0eaf5),
      fontSize: 13,
      fontWeight: FontWeight.w700
    );

    final galaxyActionButtonStyle = ActionButtonStyle(
      tooltipTextStyle: galaxyTextStyle,
      iconColor: Colors.black,
      iconDecoration: BoxDecoration(
        color: Color(0xFFe0eaf5),
        borderRadius: BorderRadius.circular(25)
      )
    );

    final galaxyMenuButtonStyle = ActionButtonStyle(
      tooltipTextStyle: galaxyTextStyle,
      iconColor: Colors.orange,
      iconDecoration: BoxDecoration(
        color: Color(0xFF0d2237),
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.orange)
      )
    );

    return LlmChatViewStyle(
      backgroundColor: Colors.transparent,
      progressIndicatorColor: Colors.purple,
      // suggestionStyle: SuggestionStyle(
      //   textStyle: galaxyTextStyle.copyWith(color: Colors.black),
      //   decoration: BoxDecoration(
      //     color: Colors.yellow,
      //     border: Border.all(color: Colors.orange)
      //   )
      // ),
      chatInputStyle: ChatInputStyle(
        backgroundColor: _animationController.isAnimating
            ? Colors.transparent
            : Color(0xFF0d2237),
        decoration: BoxDecoration(
          color: Color(0xFFe0eaf5),
          borderRadius: BorderRadius.circular(20)
          // border: Border.all(color: Colors.orange)
        ),
        textStyle: galaxyTextStyle.copyWith(color: Color(0xFF0d2237)),
        hintText: 'Hello...',
        hintStyle: galaxyTextStyle.copyWith(color: Color(0xFF0d2237)),
      ),
      userMessageStyle: UserMessageStyle(
        textStyle: galaxyTextStyle.copyWith(color: Colors.black),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade300,
              Colors.grey.shade400,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(128),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ]
        )
      ),
      llmMessageStyle: LlmMessageStyle(
        icon: Icons.sentiment_very_satisfied,
        iconColor: Colors.black,
        iconDecoration: BoxDecoration(
          color: Color.fromARGB(255, 203, 218, 235),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
            topRight: Radius.zero,
            bottomRight: Radius.circular(8),
          ),
          border: Border.all(color: Colors.black),
        ),
        decoration: BoxDecoration(
          color: Color(0xFF2e77ae),
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            bottomLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(76),
              blurRadius: 8,
              offset: Offset(2, 2),
            ),
          ]
        ),
        markdownStyle: MarkdownStyleSheet(
          p: galaxyTextStyle,
          listBullet: galaxyTextStyle
        ),
      ),
      recordButtonStyle: galaxyActionButtonStyle,
      stopButtonStyle: galaxyActionButtonStyle,
      // submitButtonStyle: galaxyActionButtonStyle,
      // addButtonStyle: galaxyActionButtonStyle,
      // attachFileButtonStyle: galaxyMenuButtonStyle,
      // cameraButtonStyle: galaxyMenuButtonStyle,
      // closeButtonStyle: galaxyActionButtonStyle,
      // cancelButtonStyle: galaxyActionButtonStyle,
      // closeMenuButtonStyle: galaxyActionButtonStyle,
      // copyButtonStyle: galaxyMenuButtonStyle,
      // editButtonStyle: galaxyMenuButtonStyle,
      // galleryButtonStyle: galaxyMenuButtonStyle,
      // actionButtonBarDecoration: BoxDecoration(
      //   color: Colors.orange,
      //   borderRadius: BorderRadius.circular(8),
      // ),
      // fileAttachmentStyle: FileAttachmentStyle(
      //   decoration: BoxDecoration(
      //     // color: Colors.black,
      //   ),
      //   iconDecoration: BoxDecoration(
      //     color: Colors.orange,
      //     borderRadius: BorderRadius.circular(8),
      //   ),
      //   filenameStyle: galaxyTextStyle,
      //   filetypeStyle: galaxyTextStyle.copyWith(
      //     color: Colors.green,
      //     fontSize: 18,
      //   ),
      // ),
    );
  }
}