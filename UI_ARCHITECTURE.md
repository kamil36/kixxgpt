# KixxGPT UI Architecture

## Application Flow Diagram

```
Application Start
       │
       ▼
┌──────────────────┐
│   KixxGPTApp     │  (Material App)
│  (Theme Config)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────────┐
│  MainAppPage         │  (Navigation Hub)
│  ├─ currentPage      │
│  ├─ chatHistory      │
│  └─ selectedChat     │
└────────┬─────────────┘
         │
    ┌────┴────┬──────────┬─────────────┐
    │          │          │             │
    ▼          ▼          ▼             ▼
┌────────┐ ┌────────┐ ┌────────┐ ┌──────────┐
│ Home   │ │ Chat   │ │Setting │ │AppDrawer │
│ Page   │ │ Page   │ │ Page   │ │(Sidebar) │
└────────┘ └────────┘ └────────┘ └──────────┘
```

## Page Structure

### HomePage
```
┌─────────────────────────────────────┐
│         KixxGPT (AppBar)            │
├─────────────────────────────────────┤
│                                     │
│        🤖 (Icon)                    │
│                                     │
│   What can I help with?             │
│   (Headline)                        │
│                                     │
│  ┌────────────┬────────────┐        │
│  │ Create     │  Analyze   │        │
│  │ Image      │  Images    │        │
│  ├────────────┼────────────┤        │
│  │ Help me    │ Summarize  │        │
│  │ Write      │ Text       │        │
│  └────────────┴────────────┘        │
│                                     │
│        [🍔 Drawer Menu]             │
└─────────────────────────────────────┘
```

### ChatPageWidget
```
┌──────────────────────────────────────┐
│  ◄  KixxGPT              🗑️ ⋯       │  AppBar
├──────────────────────────────────────┤
│                                      │
│  AI: Hello! I'm KixxGPT...          │ ◄─ Message List
│                                      │
│                  User: Hi there!     │
│                                      │
│  AI: How can I help?                │
│                                      │
├──────────────────────────────────────┤
│                                      │
│  [⌛ KixxGPT is thinking...]        │ ◄─ Loading
│                                      │
├──────────────────────────────────────┤
│  ┌──────────────────────────┐   [⬆]│  Message Input
│  │ Ask KixxGPT...           │   Button
│  └──────────────────────────┘       │
└──────────────────────────────────────┘
```

### SettingsPage
```
┌──────────────────────────────────────┐
│  ◄  Settings                         │  AppBar
├──────────────────────────────────────┤
│                                      │
│        ┌──────────┐                  │
│        │    JA    │  (Avatar)        │
│        └──────────┘                  │
│                                      │
│          jack                        │
│     misirt098@gmail.com              │
│        [Edit profile]                │
│                                      │
│ ────────────────────────────         │
│                                      │
│  My ChatGPT                          │
│  ☺️  Personalization                │
│  🎨 Apps                            │
│                                      │
│ ────────────────────────────         │
│                                      │
│  Account                             │
│  📂 Workspace        Personal        │
│  ⭐ Upgrade to Plus                 │
│  👨‍👧 Parental controls               │
│  ✉️  Email           ...gmail.com    │
│                                      │
│ ────────────────────────────         │
│                                      │
│  General                             │
│  ☀️  Appearance      System          │
│  🎨 Accent color     Default         │
│  ⚙️  General                        │
│  🎤 Voice                           │
│  🔒 Data controls                   │
│  🛡️  Security                       │
│  🐛 Report bug                      │
│  ℹ️  About                          │
│                                      │
│ ────────────────────────────         │
│                                      │
│  🚪 Log out  (Red)                  │
│                                      │
└──────────────────────────────────────┘
```

### AppDrawer (Sidebar)
```
┌──────────────────────────────────────┐
│         KixxGPT                      │  Header
│  🤖 KixxGPT                          │
├──────────────────────────────────────┤
│                                      │
│  [✏️  New chat]                     │  Button
│                                      │
│ ────────────────────────────         │
│                                      │
│  Recent                              │
│  📝 Chat about Flutter dev           │  Selectable
│  📝 Learning Dart basics             │
│  📝 UI Design patterns               │
│                                      │
│ ────────────────────────────         │
│  (Spacer)                            │
│ ────────────────────────────         │
│                                      │
│  ⚙️  Settings                       │
│  ❓ Help & FAQ                      │
│                                      │
└──────────────────────────────────────┘
```

## Component Hierarchy

```
KixxGPTApp (MaterialApp)
    │
    ├─ Theme Configuration
    │   ├─ Light Theme (Primary: #10A37F)
    │   └─ Dark Theme (Primary: #10A37F)
    │
    └─ MainAppPage (Main UI Container)
        │
        ├─ AppDrawer (Sidebar)
        │   ├─ New Chat Button
        │   ├─ Chat History List
        │   └─ Navigation Options
        │
        └─ Page Router (based on _currentPage)
            ├─ HomePage
            │   └─ GridView (2x2)
            │       └─ _SuggestionCard (×4)
            │
            ├─ ChatPageWidget
            │   ├─ AppBar
            │       ├─ Back Button
            │       ├─ Title
            │       └─ Clear Button
            │   ├─ Message ListView
            │   │   └─ ChatMessageBubble (repeated)
            │   ├─ Loading Indicator (conditional)
            │   └─ Message Input Row
            │       ├─ TextField
            │       └─ Send Button
            │
            └─ SettingsPage
                ├─ AppBar
                ├─ ScrollView
                ├─ Profile Section
                ├─ Settings Categories
                │   ├─ My ChatGPT
                │   ├─ Account
                │   └─ General
                └─ Logout Button
```

## Data Flow

```
User Input
    │
    ├─ HomePage: Tap Suggestion Card
    │   └─ Call onNewChat()
    │       └─ setState(_currentPage = AppPage.chat)
    │           └─ ChatPageWidget renders
    │
    ├─ ChatPage: Send Message
    │   └─ _sendMessage(text)
    │       ├─ Add to _messages List
    │       ├─ Call ChatService.sendMessage()
    │       └─ setState() to rebuild with response
    │
    ├─ Drawer: Select Chat
    │   └─ Call onSelectChat(index)
    │       └─ setState(_selectedChatIndex = index)
    │
    └─ Any Page: Settings
        └─ Call onSettings()
            └─ setState(_currentPage = AppPage.settings)
```

## State Management

```
MainAppPage (_MainAppPageState)
    │
    ├─ _currentPage (enum)
    │   ├─ AppPage.home
    │   ├─ AppPage.chat
    │   └─ AppPage.settings
    │
    ├─ _chatHistory (List<String>)
    │   └─ Mock chat titles
    │
    └─ _selectedChatIndex (int?)
        └─ Current selected chat (null = new)

ChatPageWidget (_ChatPageWidgetState)
    │
    ├─ _chatService (ChatService)
    │   └─ API communication
    │
    ├─ _messages (List<Message>)
    │   └─ All chat messages
    │
    ├─ _messageController (TextEditingController)
    │   └─ Input field text
    │
    ├─ _scrollController (ScrollController)
    │   └─ Auto-scroll to bottom
    │
    └─ _isLoading (bool)
        └─ Show/hide loading indicator

SettingsPage (_SettingsPageState)
    │
    ├─ _appearance (String)
    │   └─ Theme selection
    │
    └─ _accentColor (String)
        └─ Color selection
```

## Navigation States

```
Initial State: HomePage
        ↓ (User clicks suggestion)
Chat State: ChatPageWidget
        ↓ (Back button or drawer)
Home or Settings State
        
Drawer Menu: Always Available
├─ Tap "New chat" → Chat State
├─ Tap Chat History → Chat State (different chat)
├─ Tap "Settings" → Settings State
└─ Tap "Help & FAQ" → Help Dialog
```

This architecture provides:
- ✅ Clean separation of concerns
- ✅ Easy navigation between screens
- ✅ Reusable components
- ✅ Scalable state management
- ✅ Professional UI/UX
