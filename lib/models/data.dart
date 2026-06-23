class Listing {
  final String id;
  final String title;
  final String category;
  final int price;
  final String condition;
  final String description;
  final String sellerName;
  final String sellerInitials;
  final double sellerRating;
  final int sellerReviews;
  final bool isVerified;
  final String meetupLocation;
  final String imageUrl;
  final bool isNegotiable;

  const Listing({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.condition,
    required this.description,
    required this.sellerName,
    required this.sellerInitials,
    required this.sellerRating,
    required this.sellerReviews,
    required this.isVerified,
    required this.meetupLocation,
    required this.imageUrl,
    this.isNegotiable = false,
  });
}

class Message {
  final String id;
  final String senderName;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final bool hasUnread;
  final List<ChatMessage> messages;

  const Message({
    required this.id,
    required this.senderName,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.isOnline = false,
    this.hasUnread = false,
    this.messages = const [],
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;

  const ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String? subtitle;
  final String time;
  final String type; // 'message', 'listing', 'review', 'view', 'interest'
  final bool isUnread;
  final String? linkText;

  const AppNotification({
    required this.id,
    required this.title,
    this.subtitle,
    required this.time,
    required this.type,
    this.isUnread = false,
    this.linkText,
  });
}

// ---- Sample Data ----

final List<Listing> sampleListings = [
  Listing(
    id: '1',
    title: 'Calculus: Early Transcendentals Vol. 2',
    category: 'Textbooks',
    price: 3500,
    condition: 'Good condition',
    description:
        'Slightly used, no highlights. From STEM 102 course last semester. Pages clean & intact. Can meet at library or student lounge between classes on MWF. A great resource for anyone taking advanced mathematics!',
    sellerName: 'Amina Uwase',
    sellerInitials: 'AU',
    sellerRating: 4.8,
    sellerReviews: 12,
    isVerified: true,
    meetupLocation: 'Kigali Campus, Student Lounge North',
    imageUrl:
        'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=400&h=300&fit=crop',
    isNegotiable: true,
  ),
  Listing(
    id: '2',
    title: 'HP Charger 65W',
    category: 'Electronics',
    price: 8000,
    condition: 'Like New',
    description:
        'Barely used HP 65W USB-C charger. Compatible with most HP laptops. No fraying or damage.',
    sellerName: 'Kwame Osei',
    sellerInitials: 'KO',
    sellerRating: 4.5,
    sellerReviews: 7,
    isVerified: true,
    meetupLocation: 'ALU Main Gate',
    imageUrl:
        'https://images.unsplash.com/photo-1609091839311-d5365f9ff1c5?w=400&h=300&fit=crop',
  ),
  Listing(
    id: '3',
    title: 'ALU Hoodie M',
    category: 'Clothing',
    price: 6000,
    condition: 'Good',
    description:
        'Official ALU hoodie, size Medium. Worn a few times, still in great shape. Forest green.',
    sellerName: 'Tariq Abdi',
    sellerInitials: 'TA',
    sellerRating: 4.2,
    sellerReviews: 4,
    isVerified: true,
    meetupLocation: 'Student Lounge',
    imageUrl:
        'https://images.unsplash.com/photo-1556821840-3a63f15732ce?w=400&h=300&fit=crop',
  ),
  Listing(
    id: '4',
    title: 'JBL Earbuds',
    category: 'Electronics',
    price: 12000,
    condition: 'Like New',
    description:
        'JBL Tune 125 TWS earbuds. Excellent sound, comes with original case and all ear tips. Purchased 3 months ago.',
    sellerName: 'Amina Uwase',
    sellerInitials: 'AU',
    sellerRating: 4.8,
    sellerReviews: 12,
    isVerified: true,
    meetupLocation: 'Library Entrance',
    imageUrl:
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400&h=300&fit=crop',
  ),
  Listing(
    id: '5',
    title: 'Econ 101',
    category: 'Textbooks',
    price: 2500,
    condition: 'Fair',
    description:
        'Introduction to Economics textbook. Some highlighting but all content readable. Required for first-year students.',
    sellerName: 'Pierre Angelo',
    sellerInitials: 'PA',
    sellerRating: 4.9,
    sellerReviews: 14,
    isVerified: true,
    meetupLocation: 'ALU Library',
    imageUrl:
        'https://images.unsplash.com/photo-1592496431122-2349e0fbc666?w=400&h=300&fit=crop',
  ),
  Listing(
    id: '6',
    title: 'USB Mouse',
    category: 'Electronics',
    price: 4000,
    condition: 'Good',
    description: 'Logitech wired USB mouse. Works perfectly, no issues.',
    sellerName: 'Kwame Osei',
    sellerInitials: 'KO',
    sellerRating: 4.5,
    sellerReviews: 7,
    isVerified: true,
    meetupLocation: 'Engineering Block',
    imageUrl:
        'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=400&h=300&fit=crop',
  ),
  Listing(
    id: '7',
    title: 'Design Thinking',
    category: 'Textbooks',
    price: 4000,
    condition: 'Like New',
    description: 'Design Thinking by IDEO. Perfect condition, never annotated.',
    sellerName: 'Tariq Abdi',
    sellerInitials: 'TA',
    sellerRating: 4.2,
    sellerReviews: 4,
    isVerified: true,
    meetupLocation: 'Student Lounge',
    imageUrl:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400&h=300&fit=crop',
  ),
  Listing(
    id: '8',
    title: 'Statistics',
    category: 'Textbooks',
    price: 3000,
    condition: 'Good',
    description: 'Business Statistics textbook. Some notes in pencil, erasable.',
    sellerName: 'Amina Uwase',
    sellerInitials: 'AU',
    sellerRating: 4.8,
    sellerReviews: 12,
    isVerified: true,
    meetupLocation: 'Kigali Campus Library',
    imageUrl:
        'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=300&fit=crop',
  ),
];

final List<Message> sampleMessages = [
  Message(
    id: '1',
    senderName: 'Amina Uwase',
    avatarUrl:
        'https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=100&h=100&fit=crop',
    lastMessage: 'Deal! Can we meet at the librar...',
    time: '10:29 AM',
    isOnline: true,
    hasUnread: true,
    messages: [
      ChatMessage(text: 'Hi! Is the book still available?', isMe: false, time: '10:23 AM'),
      ChatMessage(text: 'Yes it is! Good condition.', isMe: true, time: '10:25 AM', isRead: true),
      ChatMessage(text: 'Can you do RWF 3,000?', isMe: false, time: '10:27 AM'),
      ChatMessage(text: 'I can do 3,200 — final offer :)', isMe: true, time: '10:28 AM', isRead: true),
      ChatMessage(text: 'Deal! Meet at library 2pm today?', isMe: false, time: '10:29 AM'),
    ],
  ),
  Message(
    id: '2',
    senderName: 'Kwame Osei',
    avatarUrl:
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop',
    lastMessage: "Okay, I'll bring it to class tomorrow. S...",
    time: 'Yesterday',
    isOnline: false,
    messages: [
      ChatMessage(text: 'Is the hoodie still available?', isMe: false, time: 'Yesterday 2:00 PM'),
      ChatMessage(text: "Yes! It's a medium.", isMe: true, time: 'Yesterday 2:05 PM', isRead: true),
      ChatMessage(text: "Okay, I'll bring it to class tomorrow. See you!", isMe: false, time: 'Yesterday 2:10 PM'),
    ],
  ),
  Message(
    id: '3',
    senderName: 'Tariq Abdi',
    avatarUrl:
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop',
    lastMessage: 'Thanks! The earbuds work great. Ap...',
    time: 'Monday',
    isOnline: false,
    messages: [
      ChatMessage(text: 'Got the earbuds, thanks!', isMe: false, time: 'Monday 4:00 PM'),
      ChatMessage(text: 'Great! Enjoy them 🎧', isMe: true, time: 'Monday 4:02 PM', isRead: true),
      ChatMessage(text: 'Thanks! The earbuds work great. Appreciate it!', isMe: false, time: 'Monday 4:05 PM'),
    ],
  ),
];

final List<AppNotification> sampleNotifications = [
  AppNotification(
    id: '1',
    title: 'Amina Uwase sent you a message about ',
    linkText: 'Calculus Vol. 2',
    subtitle: '"Hey, is this still available for pickup today?"',
    time: '10 min ago',
    type: 'message',
    isUnread: true,
  ),
  AppNotification(
    id: '2',
    title: 'New listing in Electronics: Dell Laptop — RWF 120,000',
    time: '1 hr ago',
    type: 'listing',
    isUnread: true,
  ),
  AppNotification(
    id: '3',
    title: 'Kwame Osei left you a 5-star review',
    time: '3 hrs ago',
    type: 'review',
  ),
  AppNotification(
    id: '4',
    title: 'Your listing ALU Hoodie has been viewed 24 times',
    time: 'Yesterday 2:15 PM',
    type: 'view',
  ),
  AppNotification(
    id: '5',
    title: 'Tariq Abdi is interested in your JBL Earbuds listing',
    time: 'Yesterday 11:00 AM',
    type: 'interest',
  ),
];
