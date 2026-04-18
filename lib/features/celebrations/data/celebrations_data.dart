import 'package:flutter/material.dart';

import '../../../core/models/celebration_item.dart';

// Colour values inline – no dependency on AppTheme to keep data files pure.

const celebrationItems = <CelebrationItem>[
  // ── 1 ──────────────────────────────────────────────────────────────────────
  CelebrationItem(
    id: 'sinhala_new_year',
    nameSinhala: 'සිංහල ආලෝකය (අලුත් අවුරුද්ද)',
    nameEnglish: 'Sinhala & Tamil New Year',
    descriptionSinhala:
        'සිංහල හා දෙමළ ජනයාගේ ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී.',
    descriptionEnglish:
        'Sri Lanka\'s most joyful festival, celebrating the Sinhala and Tamil New Year. '
        'Families gather to light the hearth, prepare milk rice, and play traditional games.',
    monthSinhala: 'අප්‍රේල් — බකමාස',
    monthEnglish: 'April — Bak Māsa',
    emoji: '🎊',
    gradientColors: [Color(0xFFFF9800), Color(0xFFC41F19)],
    activitySinhala: 'කිරිබත් ඉකමන් ය!',
    activityEnglish: 'Cook milk rice with your family!',
    cultureFacts: [
      'The New Year begins at an auspicious time set by astrologers.',
      'Boiling milk until it overflows signals prosperity.',
      'Traditional games include pora (pillow fight), kamba adeema (tug of war).',
      'New clothes in lucky colours are worn at the auspicious moment.',
    ],
  ),

  // ── 2 ──────────────────────────────────────────────────────────────────────
  CelebrationItem(
    id: 'vesak',
    nameSinhala: 'වෙසක් පොය',
    nameEnglish: 'Vesak Poya',
    descriptionSinhala:
        'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'The holiest Buddhist festival, commemorating the birth, enlightenment, and passing '
        'of the Buddha. Streets glow with lanterns and dansalas offer free food to all.',
    monthSinhala: 'මැයි — වෙසකමාස',
    monthEnglish: 'May — Vesak Māsa',
    emoji: '🪔',
    gradientColors: [Color(0xFFFFEB3B), Color(0xFFFF9800)],
    activitySinhala: 'වෙසක් කූඩාරම් ශ්‍රී ශ්‍රේෂ්ඨ!',
    activityEnglish: 'Make a Vesak lantern with your family!',
    cultureFacts: [
      'Vesak lanterns (vesak kuudurams) are handcrafted in beautiful shapes.',
      'Dansalas are free food stalls set up along roads for pilgrims.',
      'Buddhist temples hold all-night pirith chanting ceremonies.',
      'The full moon in May marks this special day.',
    ],
  ),

  // ── 3 ──────────────────────────────────────────────────────────────────────
  CelebrationItem(
    id: 'poson',
    nameSinhala: 'පොසොන් පොය',
    nameEnglish: 'Poson Poya',
    descriptionSinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'Commemorates the arrival of Buddhism in Sri Lanka through Arahat Mahinda '
        'on the sacred Mihintale hill. Thousands of pilgrims climb the 1,843 steps.',
    monthSinhala: 'ජූනි — පොසොන්මාස',
    monthEnglish: 'June — Pōson Māsa',
    emoji: '⛰️',
    gradientColors: [Color(0xFF0067AD), Color(0xFF004D8A)],
    activitySinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ!',
    activityEnglish: 'Visit a Buddhist temple to learn about Mahinda Thero!',
    cultureFacts: [
      'Mihintale near Anuradhapura is the main pilgrimage site for Poson.',
      'White-clad pilgrims climb 1,843 stone steps to reach the summit.',
      'Poson marks over 2,300 years of Buddhism in Sri Lanka.',
      'White lanterns are associated with Poson, unlike the colourful Vesak ones.',
    ],
  ),

  // ── 4 ──────────────────────────────────────────────────────────────────────
  CelebrationItem(
    id: 'esala_perahera',
    nameSinhala: 'ඇසල පෙරහැර',
    nameEnglish: 'Esala Perahera',
    descriptionSinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී.',
    descriptionEnglish:
        'The grand procession of the Sacred Tooth Relic of the Buddha in Kandy. '
        'Drummers, dancers, acrobats, and decorated elephants parade through the city streets.',
    monthSinhala: 'ජූලි / අගෝස්තු — ඇසලමාස',
    monthEnglish: 'July / August — Āsāḷha Māsa',
    emoji: '🐘',
    gradientColors: [Color(0xFF6A1B9A), Color(0xFFC41F19)],
    activitySinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී!',
    activityEnglish: 'Watch traditional kandyan dancing!',
    cultureFacts: [
      'The Perahera runs for 10 nights ending on the Esala full moon.',
      'The lead elephant adorned in golden robes carries the Sacred Tooth casket.',
      'Kandyan dancers wear elaborate costumes with spinning plates.',
      'Over 100 elephants participate in the grand procession.',
    ],
  ),

  // ── 5 ──────────────────────────────────────────────────────────────────────
  CelebrationItem(
    id: 'deepavali',
    nameSinhala: 'දීපාවලිය',
    nameEnglish: 'Deepavali',
    descriptionSinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'The festival of lights celebrated by Hindus. Homes and streets are lit with '
        'oil lamps and colourful kolam rangoli patterns decorate doorways.',
    monthSinhala: 'ඔක්තෝබර් / නොවැම්බර්',
    monthEnglish: 'October / November',
    emoji: '✨',
    gradientColors: [Color(0xFFE65100), Color(0xFFFFEB3B)],
    activitySinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී!',
    activityEnglish: 'Draw a kolam rangoli pattern!',
    cultureFacts: [
      'Deepavali celebrates the victory of light over darkness.',
      'Traditional sweets called mithai are shared between families.',
      'Kolam are intricate geometric patterns drawn with white rice flour.',
      'Oil lamps (vilakku) are lit inside and outside homes.',
    ],
  ),

  // ── 6 ──────────────────────────────────────────────────────────────────────
  CelebrationItem(
    id: 'christmas',
    nameSinhala: 'නත්තල්',
    nameEnglish: 'Christmas',
    descriptionSinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී ශ්‍රේෂ්ඨ.',
    descriptionEnglish:
        'Christmas in Sri Lanka is a colourful celebration enjoyed by all communities. '
        'Churches light up, cribs are displayed, and carol singers visit homes at night.',
    monthSinhala: 'දෙසැම්බර්',
    monthEnglish: 'December',
    emoji: '🎄',
    gradientColors: [Color(0xFF2E7D32), Color(0xFFC41F19)],
    activitySinhala: 'ශ්‍රී ශ්‍රේෂ්ඨ ශ්‍රී!',
    activityEnglish: 'Sing a Christmas carol with your friends!',
    cultureFacts: [
      'Sri Lankan Christmas cribs (puthu kaadaya) are artistic scenes of the nativity.',
      'Love cake and breudher are traditional Sri Lankan Christmas treats.',
      'Carol singers called "carol groups" perform door-to-door.',
      'Midnight mass is a beloved tradition for Christian families.',
    ],
  ),
];
