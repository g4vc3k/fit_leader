import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvatarSelectionPage extends StatefulWidget {
  @override
  _AvatarSelectionPageState createState() => _AvatarSelectionPageState();
}

class _AvatarSelectionPageState extends State<AvatarSelectionPage> {
  final List<String> avatarNames = [
    'avatar1.png',
    'avatar2.png',
    'avatar3.png',
    'avatar4.png',
    'avatar5.png',
    'avatar6.png',
    'avatar7.png',
    'avatar8.png',
    'avatar9.png',
  ];

  final List<Color> baseBackgroundColors = [
    const Color(0xFFFFF8DC), // Pastel Yellow
    const Color(0xFFDCEEFF), // Pastel Blue
    const Color(0xFFFFDCE5), // Pastel Red
  ];

  final List<Color> unlockableColors = [
    const Color(0xFFC8E6C9), // Mint Green
    const Color(0xFF9FA8DA), // Lavender
    const Color(0xFFFFF59D), // Light Yellow
    const Color(0xFF90CAF9), // Sky Blue
    const Color(0xFFB3E5FC), // Light Cyan
    const Color(0xFFE1BEE7), // Light Purple
    const Color(0xFFFFCCBC), // Light Coral
    const Color(0xFF80DEEA), // Light Teal
    const Color(0xFFE57373), // Light Red
    const Color(0xFF81C784), // Light Green
    const Color(0xFFF48FB1), // Light Pink
    const Color(0xFFBBDEFB), // Light Blue
    const Color(0xFFC5E1A5), // Pale Green
    const Color(0xFFFFAB91), // Light Orange
    const Color(0xFFB39DDB), // Lavender Blue
    const Color(0xFF009688), // Teal
    const Color(0xFFFFEA00), // Green
  ];

  final List<String> stickerNames = [''] + List.generate(9, (index) => 'sticker_placeholder$index.png');

  int currentIndex = 0;
  int selectedColorIndex = 0;
  int selectedStickerIndex = 0;
  int userLevel = 0;
  bool isFetchingData = true;

  @override
  void initState() {
    super.initState();
    _fetchAvatarSettings();
  }

  Future<void> _fetchAvatarSettings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final savedAvatar = userDoc['avatar'];
          final savedBackgroundColor = userDoc['backgroundColor'];
          final points = userDoc['points'];
          final savedSticker = userDoc['sticker'] ?? '';  // Fetch the saved sticker (default to an empty string if not found)

          userLevel = points ~/ 10;

          List<Color> allColors = List.from(baseBackgroundColors)..addAll(unlockableColors);

          setState(() {
            currentIndex = avatarNames.indexOf(savedAvatar);
            selectedColorIndex = allColors.indexOf(Color(savedBackgroundColor));
            if (selectedColorIndex == -1) {
              selectedColorIndex = 0;
            }
            selectedStickerIndex = stickerNames.indexOf(savedSticker);  // Set the saved sticker index
            if (selectedStickerIndex == -1) {
              selectedStickerIndex = 0;  // Default to the first sticker if not found
            }
          });
        }
      } catch (e) {
        print("Error fetching user data: $e");
      } finally {
        setState(() {
          isFetchingData = false;
        });
      }
    }
  }

  Future<void> saveAvatar(String avatarName, Color backgroundColor, String stickerName) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'avatar': avatarName,
        'backgroundColor': backgroundColor.value,
        'sticker': stickerName != '' ? stickerName : null,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar, color, and sticker updated!')),
      );
    }
  }

  void moveToNext() {
    setState(() {
      currentIndex = (currentIndex + 1) % avatarNames.length;
    });
  }

  void moveToPrevious() {
    setState(() {
      currentIndex = (currentIndex - 1 + avatarNames.length) % avatarNames.length;
    });
  }

  int getUnlockLevelForColor(int index) {
    if (index < 3) {
      return 0;
    } else if (index == 3) {
      return 1;
    } else if (index == 4) {
      return 2;
    } else if (index == 5) {
      return 5;
    } else if (index == 6) {
      return 8;
    } else if (index == 7) {
      return 10;
    } else if (index == 8) {
      return 12;
    } else if (index == 9) {
      return 15;
    } else if (index == 10) {
      return 18;
    } else if (index == 11) {
      return 20;
    } else if (index == 12) {
      return 25;
    } else if (index == 13) {
      return 30;
    } else if (index == 14) {
      return 35;
    } else if (index == 15) {
      return 40;
    } else if (index == 16) {
      return 45;
    } else if (index == 17) {
      return 50;
    } else if (index == 18) {
      return 60;
    } else if (index == 19) {
      return 70;
    }

    return 0;
  }

  bool isColorLocked(int index) {
    if (index < 3) {
      return false;
    }

    return userLevel < getUnlockLevelForColor(index);
  }

  @override
  Widget build(BuildContext context) {
    if (isFetchingData) {
      return Scaffold(
        appBar: AppBar(title: const Text('Select Your Avatar')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    List<Color> allColors = List.from(baseBackgroundColors)..addAll(unlockableColors);

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('Select Your Avatar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Avatar and Color Pickers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, size: 40),
                onPressed: moveToPrevious,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  // Background color at the bottom
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: allColors[selectedColorIndex],
                  ),
                  // Sticker placed in front of the background, but behind the avatar
                  if (stickerNames[selectedStickerIndex] != '')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(120), // Ensuring the sticker is circular
                      child: Image.asset(
                        'lib/assets/stickers/${stickerNames[selectedStickerIndex]}',
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  // Main Avatar at the top
                  Image.asset(
                    'lib/assets/avatars/${avatarNames[currentIndex]}',
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 40),
                onPressed: moveToNext,
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Background Color Picker
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allColors.length,
              itemBuilder: (context, index) {
                Color color = allColors[index];
                bool isLocked = isColorLocked(index);
                int requiredLevel = getUnlockLevelForColor(index);

                return GestureDetector(
                  onTap: isLocked
                      ? null
                      : () {
                    setState(() {
                      selectedColorIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(
                              color: selectedColorIndex == index
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        if (isLocked)
                          Icon(
                            Icons.lock,
                            color: Colors.black.withOpacity(0.6),
                            size: 16,
                          ),
                        if (isLocked)
                          Positioned(
                            bottom: 0,
                            child: Text(
                              'Lvl $requiredLevel',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Sticker Picker
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stickerNames.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStickerIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: selectedStickerIndex == index
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        if (stickerNames[index] != '')
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25), // Rounding the corners of the sticker
                            child: Image.asset(
                              'lib/assets/stickers/${stickerNames[index]}',
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {
              await saveAvatar(
                avatarNames[currentIndex],
                allColors[selectedColorIndex],
                stickerNames[selectedStickerIndex],
              );
            },
            child: const Text('Set Avatar'),
          ),
        ],
      ),
    );
  }
}
