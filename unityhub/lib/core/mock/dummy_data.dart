class DummyData {
  static const userName = "Unity User";

  static final stories = [
    {"name": "You", "isMe": true},
    {"name": "Alex", "isMe": false},
    {"name": "Sara", "isMe": false},
    {"name": "Rafi", "isMe": false},
    {"name": "Nila", "isMe": false},
    {"name": "Arif", "isMe": false},
  ];

  static final posts = [
    {
      "name": "Alex",
      "time": "2m",
      "content": "Welcome to UnityHub 🚀 Frontend first, backend later!",
      "likes": 12,
      "comments": 3,
      "shares": 1,
    },
    {
      "name": "Sara",
      "time": "1h",
      "content": "Facebook-style feed done ✅ Next: chat features 😄",
      "likes": 48,
      "comments": 9,
      "shares": 5,
    },
    {
      "name": "Rafi",
      "time": "Yesterday",
      "content": "UnityHub UI looks clean 🔥 Add dark mode later!",
      "likes": 6,
      "comments": 0,
      "shares": 0,
    },
  ];

  static final chats = [
    {"name": "Alex", "last": "Bro UI done?", "time": "10:21 PM", "unread": 2},
    {"name": "Sara", "last": "Feed screen looks nice!", "time": "9:05 PM", "unread": 0},
    {"name": "Rafi", "last": "Tomorrow continue?", "time": "Yesterday", "unread": 1},
  ];

  static final messages = [
    {"fromMe": false, "text": "Hi! UnityHub kemon cholche?", "time": "10:20 PM"},
    {"fromMe": true, "text": "UI almost ready 😄", "time": "10:20 PM"},
    {"fromMe": false, "text": "Nice! Chat UI o banai", "time": "10:21 PM"},
  ];
  // dummy photos
  static final dummyMedia = [
    "https://picsum.photos/seed/uh1/400/400",
    "https://picsum.photos/seed/uh2/400/400",
    "https://picsum.photos/seed/uh3/400/400",
  ];
}
