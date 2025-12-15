// Monster Rancher 2
// #ID = 11287

MonsterPrefixLookup = {
    0x0a: "an",
    0x1d: "an",
    0x23: "an",
}

MonsterBreedLookup = {
    0x00: "Pixie",
    0x01: "Dragon",
    0x02: "Centaur",
    0x03: "ColorPandora",
    0x04: "Beaclon",
    0x05: "Henger",
    0x06: "Wracky",
    0x07: "Golem",
    0x08: "Zuum",
    0x09: "Durahan",
    0x0a: "Arrow Head",
    0x0b: "Tiger",
    0x0c: "Hopper",
    0x0d: "Hare",
    0x0e: "Baku",
    0x0f: "Gali",
    0x10: "Kato",
    0x11: "Zilla",
    0x12: "Bajarl",
    0x13: "Mew",
    0x14: "Phoenix",
    0x15: "Ghost",
    0x16: "Metalner",
    0x17: "Suezo",
    0x18: "Jill",
    0x19: "Mocchi",
    0x1a: "Joker",
    0x1b: "Gaboo",
    0x1c: "Jell",
    0x1d: "Undine",
    0x1e: "Niton",
    0x1f: "Mock",
    0x20: "Ducken",
    0x21: "Plant",
    0x22: "Monol",
    0x23: "Ape",
    0x24: "Worm",
    0x25: "Naga",
    38: "???",
    39: "???",
    40: "???",
    41: "???",
    42: "???",
    43: "???",
}

MonthLookup = {
    0x01: "Jan",
    0x02: "Feb",
    0x03: "Mar",
    0x04: "Apr",
    0x05: "May",
    0x06: "Jun",
    0x07: "Jul",
    0x08: "Aug",
    0x09: "Sep",
    0x0a: "Oct",
    0x0b: "Nov",
    0x0c: "Dec",
}

GradeLookup = {
    0x00: "E",
    0x01: "D",
    0x02: "C",
    0x03: "B",
    0x04: "A",
    0x05: "S",
}

achievement(
    title = "Every CD Is a Monster", points = 1,
    description = "Get a Monster at the Shrine by switching CDs from Monster Rancher 2 to any other CD.",
    id = 504011, badge = "571383", published = "3/10/2025 6:05:42 PM", modified = "3/10/2025 6:05:42 PM",
    trigger = once(byte(tbyte(0x0787E0)) == 0x08) && once(byte(tbyte(0x0787E0)) == 0x0D) && dword(0x0787E0) < 0x80000000 &&
              prev(byte(0x097A18)) == 0x2E && byte(0x097A18) != 0x2E && prev(byte(0x097A1C)) == 0x2E &&
              byte(0x097A1C) != 0x2E && never(byte(tbyte(0x0787E0)) == 0x0B) && never(byte(0x097B78) != 0xFF)
)

achievement(
    title = "The First Step", points = 5, type="missable",
    description = "Win the Official E Tournament and rank up to 1st Grade.",
    id = 483089, badge = "565874", published = "12/2/2024 12:16:02 AM", modified = "2/15/2025 9:04:51 PM",
    trigger = once(byte(0x09961C) == 0x48) && prev(byte(0x098FC0)) == 0x00 && byte(0x098FC0) == 0x01 &&
              never(byte(0x097B78) == 0xFF) && never(byte(0x098FAA) == 0xFF)
)

achievement(
    title = "Still a Long Way to the Top", points = 5, type="missable",
    description = "Win the Official D Tournament and rank up to 2nd Grade.",
    id = 483209, badge = "565875", published = "12/2/2024 12:51:37 AM", modified = "2/15/2025 9:04:51 PM",
    trigger = once(byte(0x09961C) == 0x47) && (prev(byte(0x098FC0)) == 0x00 || prev(byte(0x098FC0)) == 0x01) &&
              byte(0x098FC0) == 0x02 && never(byte(0x097B78) == 0xFF) && never(byte(0x098FAA) == 0xFF)
)

achievement(
    title = "A True Professional", points = 5, type="missable",
    description = "Win the Official C Tournament and rank up to 3rd Grade.",
    id = 483378, badge = "565876", published = "12/2/2024 3:30:27 AM", modified = "2/15/2025 9:04:52 PM",
    trigger = once(byte(0x09961C) == 0x46) && (prev(byte(0x098FC0)) == 0x01 || prev(byte(0x098FC0)) == 0x02) &&
              byte(0x098FC0) == 0x03 && never(byte(0x097B78) == 0xFF) && never(byte(0x098FAA) == 0xFF)
)

achievement(
    title = "I'm Kind of a Big Deal", points = 10, type="missable",
    description = "Win the Official B Tournament and rank up to 4th Grade.",
    id = 485048, badge = "565877", published = "12/8/2024 8:13:58 PM", modified = "2/15/2025 9:04:52 PM",
    trigger = once(byte(0x09961C) == 0x45) && (prev(byte(0x098FC0)) == 0x02 || prev(byte(0x098FC0)) == 0x03) &&
              byte(0x098FC0) == 0x04 && never(byte(0x097B78) == 0xFF) && never(byte(0x098FAA) == 0xFF)
)

achievement(
    title = "Five Down, Five to Go", points = 10, type="missable",
    description = "Win the Official A Tournament and rank up to 5th Grade.",
    id = 485238, badge = "565878", published = "12/10/2024 1:41:59 AM", modified = "3/18/2025 4:44:05 AM",
    trigger = once(byte(0x09961C) == 0x44) && (prev(byte(0x098FC0)) == 0x03 || prev(byte(0x098FC0)) == 0x04) &&
              byte(0x098FC0) == 0x05 && never(byte(0x097B78) == 0xFF) && never(byte(0x098FAA) == 0xFF)
)

achievement(
    title = "The Real Fun Begins Here", points = 10, type="progression",
    description = "Win the Official S Tournament and rank up to 6th Grade.",
    id = 485400, badge = "565879", published = "12/10/2024 5:11:35 AM", modified = "2/15/2025 9:04:53 PM",
    trigger = once(byte(0x09961C) == 0x43) && (prev(byte(0x098FC0)) == 0x04 || prev(byte(0x098FC0)) == 0x05) &&
              byte(0x098FC0) == 0x06 && never(byte(0x097B78) == 0xFF) && never(byte(0x098FAA) == 0xFF)
)

achievement(
    title = "Strongest of the Four", points = 25, type="progression",
    description = "Win in the Greatest 4 Tournament and rank up to the next Grade.",
    id = 485401, badge = "565880", published = "12/10/2024 5:11:40 AM", modified = "2/15/2025 9:04:53 PM",
    trigger = byte(0x09961C) == 0x0D && byte(0x099236) == 0x02 && byte(0x099235) == 0x02 && byte(0x097B92) == 0x05 &&
              prev(byte(0x099064)) == 0x00 && byte(0x099064) == 0x01 && prev(byte(0x097A84)) == 0x00 &&
              byte(0x097A84) == 0x01
)

achievement(
    title = "My First Grand Prix", points = 25, type="progression",
    description = "Win in the M-1 Grand Prix Tournament and rank up to the next Grade.",
    id = 485615, badge = "565881", published = "12/11/2024 4:46:12 PM", modified = "2/15/2025 9:04:53 PM",
    trigger = byte(0x09961C) == 0x0A && byte(0x099236) == 0x05 && byte(0x099235) == 0x02 && byte(0x097B92) == 0x05 &&
              prev(byte(0x099060)) == 0x00 && byte(0x099060) == 0x01 && prev(byte(0x097A80)) == 0x00 &&
              byte(0x097A80) == 0x01
)

achievement(
    title = "A Winner is Your Monster", points = 25, type="progression",
    description = "Win in the Winners' Cup Tournament and rank up to the next Grade.",
    id = 485626, badge = "565882", published = "12/11/2024 6:08:23 PM", modified = "2/15/2025 9:04:54 PM",
    trigger = byte(0x09961C) == 0x0B && byte(0x099236) == 0x08 && byte(0x099235) == 0x02 && byte(0x097B92) == 0x05 &&
              prev(byte(0x09906C)) == 0x00 && byte(0x09906C) == 0x01 && prev(byte(0x097A8C)) == 0x00 &&
              byte(0x097A8C) == 0x01
)

achievement(
    title = "Inter-Regional Champion", points = 25, type="progression",
    description = "Win in the World Monsters Cup and rank up to the next Grade.",
    id = 485654, badge = "565883", published = "12/11/2024 11:35:10 PM", modified = "2/15/2025 9:04:54 PM",
    trigger = byte(0x09961C) == 0x0C && byte(0x099236) == 0x0B && byte(0x099235) == 0x02 && byte(0x097B92) == 0x05 &&
              prev(byte(0x099068)) == 0x00 && byte(0x099068) == 0x01 && prev(byte(0x097A88)) == 0x00 &&
              byte(0x097A88) == 0x01
)

achievement(
    title = "Master of IMa", points = 25, type="win_condition",
    description = "Attain Master rank after winning all of the Major 4 Tournaments.",
    id = 485655, badge = "565884", published = "12/11/2024 11:35:11 PM", modified = "3/19/2025 5:23:29 AM",
    trigger = dword(0x099060) >= 0x01 && dword(0x099064) >= 0x01 && dword(0x099068) >= 0x01 && dword(0x09906C) >= 0x01 &&
              byte(0x099235) == 0x02 &&
              (byte(0x099236) == 0x02 || byte(0x099236) == 0x05 || byte(0x099236) == 0x08 || byte(0x099236) == 0x0B) &&
              byte(0x097B92) == 0x05 && prev(byte(0x098FC0)) == 0x09 && byte(0x098FC0) == 0x0A
)

achievement(
    title = "Fimba's Finest", points = 25,
    description = "Defeat Poritoka in the Legend Cup.",
    id = 495371, badge = "565885", published = "1/30/2025 12:28:24 AM", modified = "3/16/2025 10:21:44 PM",
    trigger = byte(0x097BE4) == 0x17 && byte(0x097BE8) == 0x2A && byte(0x099235) == 0x04 && byte(0x099236) == 0x04 &&
              byte(0x09961C) == 0x4F && prev(byte(0x097A90)) == 0x00 && byte(0x097A90) == 0x01
)

achievement(
    title = "Most Wanted", points = 25,
    description = "Defeat Most in the Legend Cup.",
    id = 495757, badge = "565886", published = "2/1/2025 9:12:16 PM", modified = "3/16/2025 10:23:26 PM",
    trigger = byte(0x097BE4) == 0x19 && byte(0x097BE8) == 0x28 && byte(0x099235) == 0x04 && byte(0x099236) == 0x04 &&
              byte(0x09961C) == 0x4E && prev(byte(0x097A90)) == 0x00 && byte(0x097A90) == 0x01
)

achievement(
    title = "Dominater of the Desert", points = 25,
    description = "Defeat Sniper while on an Errantry to the Mandy Desert.",
    id = 489524, badge = "565887", published = "12/28/2024 6:15:21 PM", modified = "7/8/2025 4:49:11 AM",
    trigger = byte(0x09930A) == 0x00 && byte(0x097BE4) == 0x02 && byte(0x097BE8) == 0x28 &&
              dword(0x0EDC38) == 0x80097B78 && dword(0x0EDC80) == 0x80097D44 && word(0x0EDC2C) > 0x00 &&
              word(0x0EDC3C) > 0x00 && trigger_when(word(0x0EDC84) == 0x00) &&
              trigger_when(prev(byte(0x0EDC24)) == 0x01) && trigger_when(byte(0x0EDC24) == 0x09)
)

achievement(
    title = "One-Time Ruler of the Jungle", points = 25, type="missable",
    description = "Defeat King Ape while on an Errantry to the Parepare Jungle.",
    id = 487240, badge = "565888", published = "12/20/2024 3:50:59 AM", modified = "7/8/2025 4:49:11 AM",
    trigger = byte(0x09930A) == 0x00 && byte(0x097BE4) == 0x23 && byte(0x097BE8) == 0x27 &&
              dword(0x0EDC38) == 0x80097B78 && dword(0x0EDC80) == 0x80097D44 && word(0x0EDC2C) > 0x00 &&
              word(0x0EDC3C) > 0x00 && trigger_when(word(0x0EDC84) == 0x00) &&
              trigger_when(prev(byte(0x0EDC24)) == 0x01) && trigger_when(byte(0x0EDC24) == 0x09)
)

achievement(
    title = "Violence Begets Violence", points = 25,
    description = "Defeat Blue Phoenix while on an Errantry to Kawrea.",
    id = 490010, badge = "565889", published = "1/1/2025 12:40:09 AM", modified = "7/8/2025 4:49:11 AM",
    trigger = byte(0x09930A) == 0x00 && byte(0x097BE4) == 0x14 && byte(0x097BE8) == 0x27 &&
              dword(0x0EDC38) == 0x80097B78 && dword(0x0EDC80) == 0x80097D44 && word(0x0EDC2C) > 0x00 &&
              word(0x0EDC3C) > 0x00 && trigger_when(word(0x0EDC84) == 0x00) &&
              trigger_when(prev(byte(0x0EDC24)) == 0x01) && trigger_when(byte(0x0EDC24) == 0x09)
)

achievement(
    title = "Bounties of the Peaks", points = 5,
    description = "Obtain the enemy Monster cards for Kamui and Crescent.",
    id = 490532, badge = "565890", published = "1/4/2025 7:34:50 PM", modified = "2/15/2025 9:04:57 PM",
    trigger = (prev(byte(0x099218)) + prev(byte(0x09921A))) == 0x01 &&
              measured((byte(0x099218) + byte(0x09921A)) == 0x02)
)

achievement(
    title = "Bounties of the Desert", points = 5,
    description = "Obtain the enemy Monster cards for Burning Wall and Sand Golem.",
    id = 490561, badge = "565891", published = "1/5/2025 12:23:20 AM", modified = "2/15/2025 9:04:57 PM",
    trigger = (prev(byte(0x099215)) + prev(byte(0x09921F))) == 0x01 &&
              measured((byte(0x099215) + byte(0x09921F)) == 0x02)
)

achievement(
    title = "Bounties of the Jungle", points = 5,
    description = "Obtain the enemy Monster cards for Mad Gaboo and Wild Saurian.",
    id = 490533, badge = "565892", published = "1/4/2025 7:57:25 PM", modified = "2/15/2025 9:04:57 PM",
    trigger = (prev(byte(0x099216)) + prev(byte(0x09921E))) == 0x01 &&
              measured((byte(0x099216) + byte(0x09921E)) == 0x02)
)

achievement(
    title = "Bounties of the Sea", points = 5,
    description = "Obtain the enemy Monster cards for Bloody Eye and Silver Face.",
    id = 492452, badge = "565893", published = "1/18/2025 3:28:39 AM", modified = "2/15/2025 9:04:57 PM",
    trigger = (prev(byte(0x099217)) + prev(byte(0x099219))) == 0x01 &&
              measured((byte(0x099217) + byte(0x099219)) == 0x02)
)

achievement(
    title = "Prehistoric Bounties", points = 5,
    description = "Obtain the enemy Monster cards for Magma Heart and Punisher.",
    id = 492453, badge = "565894", published = "1/18/2025 3:32:41 AM", modified = "2/15/2025 9:04:58 PM",
    trigger = (prev(byte(0x099213)) + prev(byte(0x099221))) == 0x01 &&
              measured((byte(0x099213) + byte(0x099221)) == 0x02)
)

achievement(
    title = "Top Bounty Hunter", points = 50, type="missable",
    description = "Obtain all enemy Monster cards.",
    id = 495758, badge = "565895", published = "2/1/2025 9:12:31 PM", modified = "2/15/2025 9:04:58 PM",
    trigger = (prev(byte(0x099213)) + prev(byte(0x099214)) + prev(byte(0x099215)) + prev(byte(0x099216)) +
              prev(byte(0x099217)) + prev(byte(0x099218)) + prev(byte(0x099219)) + prev(byte(0x09921A)) +
              prev(byte(0x09921B)) + prev(byte(0x09921C)) + prev(byte(0x09921D)) + prev(byte(0x09921E)) +
              prev(byte(0x09921F)) + prev(byte(0x099220)) + prev(byte(0x099221)) + prev(byte(0x099222)) +
              prev(byte(0x099223))) == 0x10 &&
              measured((byte(0x099213) + byte(0x099214) + byte(0x099215) + byte(0x099216) + byte(0x099217) +
                  byte(0x099218) + byte(0x099219) + byte(0x09921A) + byte(0x09921B) + byte(0x09921C) + byte(0x09921D) +
                  byte(0x09921E) + byte(0x09921F) + byte(0x099220) + byte(0x099221) + byte(0x099222) + byte(0x099223)) == 0x11
              )
)

achievement(
    title = "'Tis the Season", points = 1,
    description = "Get a Monster from the Market that only appears in Summer, Fall, or Winter.",
    id = 486160, badge = "565896", published = "12/13/2024 6:25:19 PM", modified = "2/15/2025 9:04:58 PM",
    trigger = byte(tbyte(0x0787C0) + 0x000044) == 0x02 && prev(byte(0x097A18)) == 0x2E &&
              (byte(0x097A18) == 0x0A || byte(0x097A18) == 0x0D || byte(0x097A18) == 0x1B) &&
              prev(byte(0x097A1C)) == 0x2E &&
              (byte(0x097A1C) == 0x0A || byte(0x097A1C) == 0x0D || byte(0x097A1C) == 0x1B)
)

achievement(
    title = "Straight to the Big Leagues", points = 5,
    description = "Have a Monster win any Official Tournament above its own grade.",
    id = 495745, badge = "565897", published = "2/1/2025 7:32:00 PM", modified = "2/15/2025 9:04:59 PM",
    trigger = byte(0x099235) == 0x04 &&
              (byte(0x09961C) == 0x43 || byte(0x09961C) == 0x44 || byte(0x09961C) == 0x45 || byte(0x09961C) == 0x46 ||
                  byte(0x09961C) == 0x47 || byte(0x09961C) == 0x48
              ) && (byte(0x097B92) - prev(byte(0x097B92))) == 0x02
)

achievement(
    title = "Her Enchanting Smile", points = 3,
    description = "Obtain a Sculpture from the Artemis Cup.",
    id = 495419, badge = "565898", published = "1/30/2025 2:53:20 AM", modified = "2/15/2025 9:04:59 PM",
    trigger = byte(0x099235) == 0x02 && byte(0x099236) == 0x09 && byte(0x09961C) == 0x3F &&
              ((prev(byte(0x09923C)) == 0xB2 && byte(0x09923C) == 0x06) ||
               (prev(byte(0x099240)) == 0xB2 && byte(0x099240) == 0x06) ||
               (prev(byte(0x099244)) == 0xB2 && byte(0x099244) == 0x06) ||
               (prev(byte(0x099248)) == 0xB2 && byte(0x099248) == 0x06) ||
               (prev(byte(0x09924C)) == 0xB2 && byte(0x09924C) == 0x06) ||
               (prev(byte(0x099250)) == 0xB2 && byte(0x099250) == 0x06) ||
               (prev(byte(0x099254)) == 0xB2 && byte(0x099254) == 0x06) ||
               (prev(byte(0x099258)) == 0xB2 && byte(0x099258) == 0x06) ||
               (prev(byte(0x09925C)) == 0xB2 && byte(0x09925C) == 0x06) ||
               (prev(byte(0x099260)) == 0xB2 && byte(0x099260) == 0x06) ||
               (prev(byte(0x099264)) == 0xB2 && byte(0x099264) == 0x06) ||
               (prev(byte(0x099268)) == 0xB2 && byte(0x099268) == 0x06) ||
               (prev(byte(0x09926C)) == 0xB2 && byte(0x09926C) == 0x06) ||
               (prev(byte(0x099270)) == 0xB2 && byte(0x099270) == 0x06) ||
               (prev(byte(0x099274)) == 0xB2 && byte(0x099274) == 0x06) ||
               (prev(byte(0x099278)) == 0xB2 && byte(0x099278) == 0x06) ||
               (prev(byte(0x09927C)) == 0xB2 && byte(0x09927C) == 0x06) ||
               (prev(byte(0x099280)) == 0xB2 && byte(0x099280) == 0x06) ||
               (prev(byte(0x099284)) == 0xB2 && byte(0x099284) == 0x06) ||
               (prev(byte(0x099288)) == 0xB2 && byte(0x099288) == 0x06))
)

achievement(
    title = "Pot of the Twins", points = 3,
    description = "Obtain a Gemini's Pot.",
    id = 495418, badge = "565899", published = "1/30/2025 2:31:57 AM", modified = "2/15/2025 9:04:59 PM",
    trigger = byte(0x099235) == 0x04 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x34 &&
              ((prev(byte(0x09923C)) == 0xB2 && byte(0x09923C) == 0x07) ||
               (prev(byte(0x099240)) == 0xB2 && byte(0x099240) == 0x07) ||
               (prev(byte(0x099244)) == 0xB2 && byte(0x099244) == 0x07) ||
               (prev(byte(0x099248)) == 0xB2 && byte(0x099248) == 0x07) ||
               (prev(byte(0x09924C)) == 0xB2 && byte(0x09924C) == 0x07) ||
               (prev(byte(0x099250)) == 0xB2 && byte(0x099250) == 0x07) ||
               (prev(byte(0x099254)) == 0xB2 && byte(0x099254) == 0x07) ||
               (prev(byte(0x099258)) == 0xB2 && byte(0x099258) == 0x07) ||
               (prev(byte(0x09925C)) == 0xB2 && byte(0x09925C) == 0x07) ||
               (prev(byte(0x099260)) == 0xB2 && byte(0x099260) == 0x07) ||
               (prev(byte(0x099264)) == 0xB2 && byte(0x099264) == 0x07) ||
               (prev(byte(0x099268)) == 0xB2 && byte(0x099268) == 0x07) ||
               (prev(byte(0x09926C)) == 0xB2 && byte(0x09926C) == 0x07) ||
               (prev(byte(0x099270)) == 0xB2 && byte(0x099270) == 0x07) ||
               (prev(byte(0x099274)) == 0xB2 && byte(0x099274) == 0x07) ||
               (prev(byte(0x099278)) == 0xB2 && byte(0x099278) == 0x07) ||
               (prev(byte(0x09927C)) == 0xB2 && byte(0x09927C) == 0x07) ||
               (prev(byte(0x099280)) == 0xB2 && byte(0x099280) == 0x07) ||
               (prev(byte(0x099284)) == 0xB2 && byte(0x099284) == 0x07) ||
               (prev(byte(0x099288)) == 0xB2 && byte(0x099288) == 0x07))
)

achievement(
    title = "No Arrow Head Was Harmed For This", points = 5,
    description = "Obtain a Crab's Claw from the Crab Cup.",
    id = 495526, badge = "565900", published = "1/31/2025 1:11:35 AM", modified = "2/15/2025 9:05:00 PM",
    trigger = byte(0x099235) == 0x02 && byte(0x099236) == 0x07 && byte(0x09961C) == 0x28 &&
              ((prev(byte(0x09923C)) == 0xB2 && byte(0x09923C) == 0x16) ||
               (prev(byte(0x099240)) == 0xB2 && byte(0x099240) == 0x16) ||
               (prev(byte(0x099244)) == 0xB2 && byte(0x099244) == 0x16) ||
               (prev(byte(0x099248)) == 0xB2 && byte(0x099248) == 0x16) ||
               (prev(byte(0x09924C)) == 0xB2 && byte(0x09924C) == 0x16) ||
               (prev(byte(0x099250)) == 0xB2 && byte(0x099250) == 0x16) ||
               (prev(byte(0x099254)) == 0xB2 && byte(0x099254) == 0x16) ||
               (prev(byte(0x099258)) == 0xB2 && byte(0x099258) == 0x16) ||
               (prev(byte(0x09925C)) == 0xB2 && byte(0x09925C) == 0x16) ||
               (prev(byte(0x099260)) == 0xB2 && byte(0x099260) == 0x16) ||
               (prev(byte(0x099264)) == 0xB2 && byte(0x099264) == 0x16) ||
               (prev(byte(0x099268)) == 0xB2 && byte(0x099268) == 0x16) ||
               (prev(byte(0x09926C)) == 0xB2 && byte(0x09926C) == 0x16) ||
               (prev(byte(0x099270)) == 0xB2 && byte(0x099270) == 0x16) ||
               (prev(byte(0x099274)) == 0xB2 && byte(0x099274) == 0x16) ||
               (prev(byte(0x099278)) == 0xB2 && byte(0x099278) == 0x16) ||
               (prev(byte(0x09927C)) == 0xB2 && byte(0x09927C) == 0x16) ||
               (prev(byte(0x099280)) == 0xB2 && byte(0x099280) == 0x16) ||
               (prev(byte(0x099284)) == 0xB2 && byte(0x099284) == 0x16) ||
               (prev(byte(0x099288)) == 0xB2 && byte(0x099288) == 0x16))
)

achievement(
    title = "Horn of the Legendary Beast", points = 10,
    description = "Obtain a Taurus Horn.",
    id = 495525, badge = "565901", published = "1/31/2025 1:06:08 AM", modified = "2/15/2025 9:05:00 PM",
    trigger = byte(0x099235) == 0x03 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x11 &&
              ((prev(byte(0x09923C)) == 0xB2 && byte(0x09923C) == 0x62) ||
               (prev(byte(0x099240)) == 0xB2 && byte(0x099240) == 0x62) ||
               (prev(byte(0x099244)) == 0xB2 && byte(0x099244) == 0x62) ||
               (prev(byte(0x099248)) == 0xB2 && byte(0x099248) == 0x62) ||
               (prev(byte(0x09924C)) == 0xB2 && byte(0x09924C) == 0x62) ||
               (prev(byte(0x099250)) == 0xB2 && byte(0x099250) == 0x62) ||
               (prev(byte(0x099254)) == 0xB2 && byte(0x099254) == 0x62) ||
               (prev(byte(0x099258)) == 0xB2 && byte(0x099258) == 0x62) ||
               (prev(byte(0x09925C)) == 0xB2 && byte(0x09925C) == 0x62) ||
               (prev(byte(0x099260)) == 0xB2 && byte(0x099260) == 0x62) ||
               (prev(byte(0x099264)) == 0xB2 && byte(0x099264) == 0x62) ||
               (prev(byte(0x099268)) == 0xB2 && byte(0x099268) == 0x62) ||
               (prev(byte(0x09926C)) == 0xB2 && byte(0x09926C) == 0x62) ||
               (prev(byte(0x099270)) == 0xB2 && byte(0x099270) == 0x62) ||
               (prev(byte(0x099274)) == 0xB2 && byte(0x099274) == 0x62) ||
               (prev(byte(0x099278)) == 0xB2 && byte(0x099278) == 0x62) ||
               (prev(byte(0x09927C)) == 0xB2 && byte(0x09927C) == 0x62) ||
               (prev(byte(0x099280)) == 0xB2 && byte(0x099280) == 0x62) ||
               (prev(byte(0x099284)) == 0xB2 && byte(0x099284) == 0x62) ||
               (prev(byte(0x099288)) == 0xB2 && byte(0x099288) == 0x62))
)

achievement(
    title = "A Stimulant By Many Names", points = 10,
    description = "Obtain a Teromeann from the Telomeann Cup.",
    id = 492454, badge = "565902", published = "1/18/2025 3:41:16 AM", modified = "2/15/2025 9:05:00 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x09 && byte(0x09961C) == 0x14 &&
              ((prev(byte(0x09923C)) == 0xB2 && byte(0x09923C) == 0x22) ||
               (prev(byte(0x099240)) == 0xB2 && byte(0x099240) == 0x22) ||
               (prev(byte(0x099244)) == 0xB2 && byte(0x099244) == 0x22) ||
               (prev(byte(0x099248)) == 0xB2 && byte(0x099248) == 0x22) ||
               (prev(byte(0x09924C)) == 0xB2 && byte(0x09924C) == 0x22) ||
               (prev(byte(0x099250)) == 0xB2 && byte(0x099250) == 0x22) ||
               (prev(byte(0x099254)) == 0xB2 && byte(0x099254) == 0x22) ||
               (prev(byte(0x099258)) == 0xB2 && byte(0x099258) == 0x22) ||
               (prev(byte(0x09925C)) == 0xB2 && byte(0x09925C) == 0x22) ||
               (prev(byte(0x099260)) == 0xB2 && byte(0x099260) == 0x22) ||
               (prev(byte(0x099264)) == 0xB2 && byte(0x099264) == 0x22) ||
               (prev(byte(0x099268)) == 0xB2 && byte(0x099268) == 0x22) ||
               (prev(byte(0x09926C)) == 0xB2 && byte(0x09926C) == 0x22) ||
               (prev(byte(0x099270)) == 0xB2 && byte(0x099270) == 0x22) ||
               (prev(byte(0x099274)) == 0xB2 && byte(0x099274) == 0x22) ||
               (prev(byte(0x099278)) == 0xB2 && byte(0x099278) == 0x22) ||
               (prev(byte(0x09927C)) == 0xB2 && byte(0x09927C) == 0x22) ||
               (prev(byte(0x099280)) == 0xB2 && byte(0x099280) == 0x22) ||
               (prev(byte(0x099284)) == 0xB2 && byte(0x099284) == 0x22) ||
               (prev(byte(0x099288)) == 0xB2 && byte(0x099288) == 0x22))
)

achievement(
    title = "Certified Best Baby", points = 5,
    description = "Win the Freshmen's Cup using any Monster whose total stats are below 1400.",
    id = 495737, badge = "565903", published = "2/1/2025 6:29:59 PM", modified = "2/15/2025 9:05:01 PM",
    trigger = byte(0x099235) == 0x02 && byte(0x099236) == 0x06 && dword(0x097A14) <= 0x17 &&
              (word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)) <= 0x578 &&
              byte(0x1FFB84) == 0x00 && byte(0x1FFB94) == 0xFF && trigger_when(byte(0x1FFB80) == 0x01) &&
              trigger_when(byte(0x1FFB81) == 0x01) && trigger_when(byte(0x1FFB82) == 0x01) &&
              trigger_when(byte(0x1FFB83) == 0x01) && trigger_when(byte(0x1FFB85) == 0x01) &&
              trigger_when(byte(0x1FFB86) == 0x01) && trigger_when(byte(0x1FFB87) == 0x01) &&
              trigger_when(prev(byte(0x1FFC00)) == 0x01) && trigger_when(byte(0x1FFC00) == 0x00)
)

achievement(
    title = "Ringing In the New Year", points = 10,
    description = "Win the New Year's Cup using any Monster whose total stats are below 3000.",
    id = 496787, badge = "565904", published = "2/2/2025 7:39:02 PM", modified = "2/15/2025 9:05:01 PM",
    trigger = byte(0x099235) == 0x04 && byte(0x099236) == 0x01 &&
              (word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)) <= 0xBB8 &&
              byte(0x1FFB84) == 0x00 && byte(0x1FFB94) == 0xFF && trigger_when(byte(0x1FFB80) == 0x01) &&
              trigger_when(byte(0x1FFB81) == 0x01) && trigger_when(byte(0x1FFB82) == 0x01) &&
              trigger_when(byte(0x1FFB83) == 0x01) && trigger_when(byte(0x1FFB85) == 0x01) &&
              trigger_when(byte(0x1FFB86) == 0x01) && trigger_when(byte(0x1FFB87) == 0x01) &&
              trigger_when(prev(byte(0x1FFC00)) == 0x01) && trigger_when(byte(0x1FFC00) == 0x00)
)

achievement(
    title = "All Shall Be Brought To Heel", points = 10,
    description = "Obtain the Heel Badge from the Heels Cup while using a Monster whose sum of LIF, POW, INT, SKI, SPD and DEF is equal to or below 2200.",
    id = 492455, badge = "565905", published = "1/18/2025 3:58:54 AM", modified = "2/15/2025 9:05:02 PM",
    trigger = byte(0x099235) == 0x04 && byte(0x099236) == 0x0A && byte(0x09961C) == 0x04 &&
              (word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)) <= 0x898 &&
              ((prev(byte(0x09923C)) == 0xB2 && trigger_when(byte(0x09923C) == 0x58)) ||
               (prev(byte(0x099240)) == 0xB2 && trigger_when(byte(0x099240) == 0x58)) ||
               (prev(byte(0x099244)) == 0xB2 && trigger_when(byte(0x099244) == 0x58)) ||
               (prev(byte(0x099248)) == 0xB2 && trigger_when(byte(0x099248) == 0x58)) ||
               (prev(byte(0x09924C)) == 0xB2 && trigger_when(byte(0x09924C) == 0x58)) ||
               (prev(byte(0x099250)) == 0xB2 && trigger_when(byte(0x099250) == 0x58)) ||
               (prev(byte(0x099254)) == 0xB2 && trigger_when(byte(0x099254) == 0x58)) ||
               (prev(byte(0x099258)) == 0xB2 && trigger_when(byte(0x099258) == 0x58)) ||
               (prev(byte(0x09925C)) == 0xB2 && trigger_when(byte(0x09925C) == 0x58)) ||
               (prev(byte(0x099260)) == 0xB2 && trigger_when(byte(0x099260) == 0x58)) ||
               (prev(byte(0x099264)) == 0xB2 && trigger_when(byte(0x099264) == 0x58)) ||
               (prev(byte(0x099268)) == 0xB2 && trigger_when(byte(0x099268) == 0x58)) ||
               (prev(byte(0x09926C)) == 0xB2 && trigger_when(byte(0x09926C) == 0x58)) ||
               (prev(byte(0x099270)) == 0xB2 && trigger_when(byte(0x099270) == 0x58)) ||
               (prev(byte(0x099274)) == 0xB2 && trigger_when(byte(0x099274) == 0x58)) ||
               (prev(byte(0x099278)) == 0xB2 && trigger_when(byte(0x099278) == 0x58)) ||
               (prev(byte(0x09927C)) == 0xB2 && trigger_when(byte(0x09927C) == 0x58)) ||
               (prev(byte(0x099280)) == 0xB2 && trigger_when(byte(0x099280) == 0x58)) ||
               (prev(byte(0x099284)) == 0xB2 && trigger_when(byte(0x099284) == 0x58)) ||
               (prev(byte(0x099288)) == 0xB2 && trigger_when(byte(0x099288) == 0x58)))
)

achievement(
    title = "Tournament of Heroes", points = 10,
    description = "Obtain the Hero Badge from the Heroes Cup while using a Monster whose sum of LIF, POW, INT, SKI, SPD and DEF is equal to or below 2200.",
    id = 496785, badge = "565906", published = "2/2/2025 7:24:19 PM", modified = "2/15/2025 9:05:02 PM",
    trigger = byte(0x099235) == 0x04 && byte(0x099236) == 0x0A && byte(0x09961C) == 0x03 &&
              (word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)) <= 0x898 &&
              ((prev(byte(0x09923C)) == 0xB2 && trigger_when(byte(0x09923C) == 0x57)) ||
               (prev(byte(0x099240)) == 0xB2 && trigger_when(byte(0x099240) == 0x57)) ||
               (prev(byte(0x099244)) == 0xB2 && trigger_when(byte(0x099244) == 0x57)) ||
               (prev(byte(0x099248)) == 0xB2 && trigger_when(byte(0x099248) == 0x57)) ||
               (prev(byte(0x09924C)) == 0xB2 && trigger_when(byte(0x09924C) == 0x57)) ||
               (prev(byte(0x099250)) == 0xB2 && trigger_when(byte(0x099250) == 0x57)) ||
               (prev(byte(0x099254)) == 0xB2 && trigger_when(byte(0x099254) == 0x57)) ||
               (prev(byte(0x099258)) == 0xB2 && trigger_when(byte(0x099258) == 0x57)) ||
               (prev(byte(0x09925C)) == 0xB2 && trigger_when(byte(0x09925C) == 0x57)) ||
               (prev(byte(0x099260)) == 0xB2 && trigger_when(byte(0x099260) == 0x57)) ||
               (prev(byte(0x099264)) == 0xB2 && trigger_when(byte(0x099264) == 0x57)) ||
               (prev(byte(0x099268)) == 0xB2 && trigger_when(byte(0x099268) == 0x57)) ||
               (prev(byte(0x09926C)) == 0xB2 && trigger_when(byte(0x09926C) == 0x57)) ||
               (prev(byte(0x099270)) == 0xB2 && trigger_when(byte(0x099270) == 0x57)) ||
               (prev(byte(0x099274)) == 0xB2 && trigger_when(byte(0x099274) == 0x57)) ||
               (prev(byte(0x099278)) == 0xB2 && trigger_when(byte(0x099278) == 0x57)) ||
               (prev(byte(0x09927C)) == 0xB2 && trigger_when(byte(0x09927C) == 0x57)) ||
               (prev(byte(0x099280)) == 0xB2 && trigger_when(byte(0x099280) == 0x57)) ||
               (prev(byte(0x099284)) == 0xB2 && trigger_when(byte(0x099284) == 0x57)) ||
               (prev(byte(0x099288)) == 0xB2 && trigger_when(byte(0x099288) == 0x57)))
)

achievement(
    title = "A Joyous Day Indeed", points = 1,
    description = "Celebrate your Monster's birthday on the ranch with Colt, Joy, and some delicious cake.",
    id = 486187, badge = "565907", published = "12/13/2024 8:46:12 PM", modified = "2/15/2025 9:05:03 PM",
    trigger = (dword(0x097A14) % 0x30 + 0x00) == 0x00 && prev(byte(0x07455A)) == 0xB3 && byte(0x07455A) == 0x90
)

achievement(
    title = "Time Flies When You're Ranching", points = 5,
    description = "Raise a Monster to 6 years or older and celebrate its birthday on the Ranch.",
    id = 495885, badge = "565908", published = "2/2/2025 5:01:26 AM", modified = "2/15/2025 9:05:03 PM",
    trigger = (dword(0x097A14) % 0x30 + 0x00) == 0x00 && (dword(0x097A14) / 0x30 + 0x00) >= 0x06 &&
              prev(byte(0x07455A)) == 0xB3 && byte(0x07455A) == 0x90
)

achievement(
    title = "Old Boys' Club", points = 10,
    description = "Win the Elders' Cup and obtain a Silver Peach.",
    id = 495740, badge = "565909", published = "2/1/2025 6:43:05 PM", modified = "2/15/2025 9:05:03 PM",
    trigger = byte(0x099235) == 0x02 && byte(0x099236) == 0x06 && (dword(0x097A14) / 0x30 + 0x00) >= 0x06 &&
              byte(0x09961C) == 0x01 &&
              ((prev(byte(0x09923C)) == 0xB2 && byte(0x09923C) == 0x1B) ||
               (prev(byte(0x099240)) == 0xB2 && byte(0x099240) == 0x1B) ||
               (prev(byte(0x099244)) == 0xB2 && byte(0x099244) == 0x1B) ||
               (prev(byte(0x099248)) == 0xB2 && byte(0x099248) == 0x1B) ||
               (prev(byte(0x09924C)) == 0xB2 && byte(0x09924C) == 0x1B) ||
               (prev(byte(0x099250)) == 0xB2 && byte(0x099250) == 0x1B) ||
               (prev(byte(0x099254)) == 0xB2 && byte(0x099254) == 0x1B) ||
               (prev(byte(0x099258)) == 0xB2 && byte(0x099258) == 0x1B) ||
               (prev(byte(0x09925C)) == 0xB2 && byte(0x09925C) == 0x1B) ||
               (prev(byte(0x099260)) == 0xB2 && byte(0x099260) == 0x1B) ||
               (prev(byte(0x099264)) == 0xB2 && byte(0x099264) == 0x1B) ||
               (prev(byte(0x099268)) == 0xB2 && byte(0x099268) == 0x1B) ||
               (prev(byte(0x09926C)) == 0xB2 && byte(0x09926C) == 0x1B) ||
               (prev(byte(0x099270)) == 0xB2 && byte(0x099270) == 0x1B) ||
               (prev(byte(0x099274)) == 0xB2 && byte(0x099274) == 0x1B) ||
               (prev(byte(0x099278)) == 0xB2 && byte(0x099278) == 0x1B) ||
               (prev(byte(0x09927C)) == 0xB2 && byte(0x09927C) == 0x1B) ||
               (prev(byte(0x099280)) == 0xB2 && byte(0x099280) == 0x1B) ||
               (prev(byte(0x099284)) == 0xB2 && byte(0x099284) == 0x1B) ||
               (prev(byte(0x099288)) == 0xB2 && byte(0x099288) == 0x1B))
)

achievement(
    title = "An International Brought to a Close", points = 3,
    description = "See your first IMa vs. FIMBA inter-regional meet to completion.",
    id = 496806, badge = "565910", published = "2/2/2025 8:16:53 PM", modified = "2/15/2025 9:05:04 PM",
    trigger = byte(0x09961C) >= 0x49 && byte(0x09961C) <= 0x4D && byte(0x097B92) >= 0x01 && byte(0x099235) == 0x04 &&
              byte(0x099236) == 0x08 && prev(byte(0x099312)) == 0xFF && byte(0x099312) == 0x00
)

achievement(
    title = "I'm Doing My Part!", points = 5,
    description = "Win your round in the IMA vs. FIMBA meet.",
    id = 495938, badge = "565911", published = "2/2/2025 5:37:27 AM", modified = "2/15/2025 9:05:04 PM",
    trigger = byte(0x099235) == 0x04 && byte(0x099236) == 0x08 && byte(0x09961C) >= 0x49 && byte(0x09961C) <= 0x4D &&
              ((byte(0x1FFC24) == 0xFF && prev(byte(0x1FFC33)) == 0x00 && byte(0x1FFC33) == 0x01) ||
               (byte(0x1FFC25) == 0xFF && prev(byte(0x1FFC34)) == 0x00 && byte(0x1FFC34) == 0x01) ||
               (byte(0x1FFC26) == 0xFF && prev(byte(0x1FFC35)) == 0x00 && byte(0x1FFC35) == 0x01) ||
               (byte(0x1FFC27) == 0xFF && prev(byte(0x1FFC36)) == 0x00 && byte(0x1FFC36) == 0x01) ||
               (byte(0x1FFC28) == 0xFF && prev(byte(0x1FFC37)) == 0x00 && byte(0x1FFC37) == 0x01))
)

achievement(
    title = "IMa Superiority", points = 50,
    description = "Defeat Akirel in the IMa vs. FIMBA cup by using an S-rank Monster whose Total Stats are below 4000.",
    id = 495937, badge = "565912", published = "2/2/2025 5:37:01 AM", modified = "2/15/2025 9:05:04 PM",
    trigger = byte(0x1FFC24) == 0xFF && byte(0x097B92) == 0x05 &&
              (word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)) <= 0xFA0 &&
              byte(0x1FFC29) == 0x61 && byte(0x1FFC2E) == 0x00 && trigger_when(byte(0x097BE4) == 0x0F) &&
              trigger_when(byte(0x097BE8) == 0x08) && trigger_when(word(0x097BEC) == 0x357) &&
              trigger_when(word(0x097BEE) == 0x347) && trigger_when(word(0x097BF0) == 0x336) &&
              trigger_when(word(0x097BF2) == 0x2DB) && trigger_when(word(0x097BF4) == 0x3AC) &&
              trigger_when(word(0x097BF6) == 0x33B) && trigger_when(byte(0x1FFC2E) == 0x00) &&
              trigger_when(prev(byte(0x1FFC33)) == 0x00) && trigger_when(byte(0x1FFC33) == 0x01)
)

achievement(
    title = "Skip Bread, Acquire Stable", points = 5,
    description = "Get Binto to upgrade your Stable for the first time.",
    id = 485625, badge = "565913", published = "12/11/2024 4:52:40 PM", modified = "2/15/2025 9:05:05 PM",
    trigger = prior(byte(0x099235)) == 0x03 && byte(0x099235) == 0x04 && byte(0x099236) == 0x05 &&
              prior(byte(0x098FC2)) == 0x00 && byte(0x098FC2) == 0x01 &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) == 0x3A98
)

achievement(
    title = "Man Builds House, Stable Builds Monster", points = 10,
    description = "Upgrade your stable for the second time.",
    id = 486282, badge = "565914", published = "12/14/2024 6:21:00 PM", modified = "2/15/2025 9:05:05 PM",
    trigger = prior(byte(0x099235)) == 0x03 && byte(0x099235) == 0x04 && byte(0x099236) == 0x05 &&
              prior(byte(0x098FC2)) == 0x01 && byte(0x098FC2) == 0x02 &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) == 0x7530
)

achievement(
    title = "The Might of the Trainer", points = 3,
    description = "Upgrade your house for the first time.",
    id = 485047, badge = "565915", published = "12/8/2024 7:59:03 PM", modified = "2/15/2025 9:05:05 PM",
    trigger = prior(byte(0x099235)) == 0x03 && byte(0x099235) == 0x04 && byte(0x099236) == 0x05 &&
              prior(byte(0x098FC1)) == 0x00 && byte(0x098FC1) == 0x01 &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) == 0x1388
)

achievement(
    title = "I Feel Better Already!", points = 5,
    description = "Upgrade your house for the second time.",
    id = 486188, badge = "565916", published = "12/13/2024 8:57:54 PM", modified = "2/15/2025 9:05:06 PM",
    trigger = prior(byte(0x099235)) == 0x03 && byte(0x099235) == 0x04 && byte(0x099236) == 0x05 &&
              prior(byte(0x098FC1)) == 0x01 && byte(0x098FC1) == 0x02 &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) == 0x1F40
)

achievement(
    title = "Pillar of Nurturing", points = 5,
    description = "Upgrade your house for the third time.",
    id = 486281, badge = "565917", published = "12/14/2024 4:58:09 PM", modified = "2/15/2025 9:05:06 PM",
    trigger = prior(byte(0x099235)) == 0x03 && byte(0x099235) == 0x04 && byte(0x099236) == 0x05 &&
              prior(byte(0x098FC1)) == 0x02 && byte(0x098FC1) == 0x03 &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) == 0x2EE0
)

achievement(
    title = "A Great House for a Great Trainer", points = 10,
    description = "Upgrade your house for the fourth and final time.",
    id = 489381, badge = "565918", published = "12/27/2024 11:51:19 PM", modified = "2/15/2025 9:05:06 PM",
    trigger = prior(byte(0x099235)) == 0x03 && byte(0x099235) == 0x04 && byte(0x099236) == 0x05 &&
              prior(byte(0x098FC1)) == 0x03 && byte(0x098FC1) == 0x04 &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) == 0x4E20
)

achievement(
    title = "Forklift Certification Not Included", points = 5,
    description = "Use the Pot given by Binto in Combination to create his trade secret Monster.",
    id = 489382, badge = "565919", published = "12/27/2024 11:52:49 PM", modified = "3/24/2025 6:13:40 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x12 && byte(0x097A1C) == 0x12 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x099398)) == 0x00 &&
              byte(0x099398) == 0x01
)

achievement(
    title = "It's A Terrible Day For Rain...", points = 4,
    description = "Make an Altar to honour a fallen Monster.",
    id = 489407, badge = "565920", published = "12/28/2024 3:27:56 AM", modified = "2/15/2025 9:05:07 PM",
    trigger = dword(0x097A14) == 0x00 && prior(byte(0x099050)) == 0x00 && byte(0x099050) == 0x01 &&
              prior(byte(0x0992E2)) == 0xFF && byte(0x0992E2) == 0x8C &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) > 0x00
)

achievement(
    title = "Standing On the Shoulders of Giants", points = 5,
    description = "Upgrade your Altar to the max rank.",
    id = 495417, badge = "565921", published = "1/30/2025 2:21:00 AM", modified = "3/24/2025 6:26:31 AM",
    trigger = byte(0x09933D) == 0x00 && (dword(0x098FBC) + 0x1F40 - prior(dword(0x098FBC))) == 0x00 &&
              prev(byte(0x099050)) == 0x02 && measured(byte(0x099050) == 0x03)
)

achievement(
    title = "Heavenly Gift", points = 2,
    description = "Unlock the Ghost by using a Stick in Combination.",
    id = 495759, badge = "565922", published = "2/1/2025 9:49:37 PM", modified = "3/24/2025 6:12:50 AM",
    trigger = byte(0x09933E) == 0x00 && byte(0x097B78) == 0xFF && byte(0x097A18) == 0x15 && byte(0x097A1C) == 0x15 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x09939B)) == 0x00 &&
              byte(0x09939B) == 0x01
)

achievement(
    title = "Number One Cup Jelly Fan", points = 10,
    description = "Have a 4-year old Worm cocoon into a Beaclon.",
    id = 487220, badge = "565923", published = "12/20/2024 2:43:38 AM", modified = "2/15/2025 9:05:08 PM",
    trigger = byte(0x099236) == 0x06 && word(0x097A14) >= 0xC0 && word(0x097A14) < 0xF0 && byte(0x097B92) <= 0x02 &&
              byte(0x097A36) >= 0x50 && byte(0x097AC5) >= 0x1E && trigger_when(prior(byte(0x099235)) == 0x03) &&
              trigger_when(byte(0x099235) == 0x04) && trigger_when(prev(byte(0x097A18)) == 0x24) &&
              trigger_when(byte(0x097A18) == 0x04) && trigger_when(prev(byte(0x097A1C)) != 0x04) &&
              trigger_when(byte(0x097A1C) == 0x04)
)

achievement(
    title = "Treasure in the Sands", points = 3,
    description = "Obtain a Spear after an errantry into the Mandy Desert.",
    id = 485051, badge = "565924", published = "12/8/2024 9:44:45 PM", modified = "3/17/2025 10:26:59 PM",
    trigger = byte(0x099359) == 0x00 && byte(0x09935A) == 0xFF && prev(byte(0x07455A)) == 0xB3 && byte(0x07455A) == 0xAF &&
              byte(0x099388) == 0x00
)

achievement(
    title = "Get Off My Lawn", points = 10, type="missable",
    description = "Defeat the Centaur that attempts to invade your Ranch after obtaining the Spear.",
    id = 485050, badge = "565925", published = "12/8/2024 9:44:45 PM", modified = "2/15/2025 9:05:08 PM",
    trigger = byte(0x097BE4) == 0x02 && byte(0x097BE8) == 0x02 && byte(0x09935A) == 0xFF && word(0x097BEC) == 0x1BF &&
              word(0x097BEE) == 0x207 && word(0x097BF0) == 0xE9 && word(0x097BF2) == 0x32E && word(0x097BF4) == 0xF5 &&
              word(0x097BF6) == 0x2B5 && word(0x0EDC3C) > 0x00 && prev(word(0x0EDC84)) > 0x00 && word(0x0EDC84) == 0x00
)

achievement(
    title = "Descendant of the Great Escapees", points = 3,
    description = "Unlock the Centaur by using a Spear in Combination.",
    id = 485052, badge = "565926", published = "12/8/2024 9:44:56 PM", modified = "3/24/2025 6:11:51 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x02 && byte(0x097A1C) == 0x02 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x099388)) == 0x00 &&
              byte(0x099388) == 0x01
)

achievement(
    title = "Learning FIMBA's Secrets", points = 10,
    description = "Win the B-Rank Invitational that is held on week 2 of August.",
    id = 487004, badge = "565927", published = "12/19/2024 7:17:30 AM", modified = "3/18/2025 3:54:31 PM",
    trigger = byte(0x099235) == 0x02 && byte(0x099236) == 0x08 && byte(0x097BE4) == 0x01 && byte(0x097BE8) == 0x01 &&
              word(0x097BEC) == 0x184 && word(0x097BEE) == 0x1BA && word(0x097BF0) == 0x174 && word(0x097BF2) == 0x24E &&
              word(0x097BF4) == 0x186 && word(0x097BF6) == 0x21F && word(0x0EDC86) == 0x184 && word(0x0EDC3C) > 0x00 &&
              (prev(byte(0x09923C)) == 0xB2 || prev(byte(0x099244)) == 0xB2 || prev(byte(0x099248)) == 0xB2 ||
                  prev(byte(0x09924C)) == 0xB2 || prev(byte(0x099250)) == 0xB2 || prev(byte(0x099254)) == 0xB2 ||
                  prev(byte(0x099258)) == 0xB2 || prev(byte(0x09925C)) == 0xB2 || prev(byte(0x099260)) == 0xB2 ||
                  prev(byte(0x099264)) == 0xB2 || prev(byte(0x099268)) == 0xB2 || prev(byte(0x09926C)) == 0xB2 ||
                  prev(byte(0x099270)) == 0xB2 || prev(byte(0x099274)) == 0xB2 || prev(byte(0x099278)) == 0xB2 ||
                  prev(byte(0x09927C)) == 0xB2 || prev(byte(0x099280)) == 0xB2 || prev(byte(0x099284)) == 0xB2 ||
                  prev(byte(0x099288)) == 0xB2
              ) &&
              (byte(0x09923C) == 0x5A || byte(0x099244) == 0x5A || byte(0x099248) == 0x5A || byte(0x09924C) == 0x5A ||
                  byte(0x099250) == 0x5A || byte(0x099254) == 0x5A || byte(0x099258) == 0x5A || byte(0x09925C) == 0x5A ||
                  byte(0x099260) == 0x5A || byte(0x099264) == 0x5A || byte(0x099268) == 0x5A || byte(0x09926C) == 0x5A ||
                  byte(0x099270) == 0x5A || byte(0x099274) == 0x5A || byte(0x099278) == 0x5A || byte(0x09927C) == 0x5A ||
                  byte(0x099280) == 0x5A || byte(0x099284) == 0x5A || byte(0x099288) == 0x5A
              )
)

achievement(
    title = "Known by All, Raised by Few", points = 3,
    description = "Unlock the Dragon by using a Dragon Tusk in Combination.",
    id = 487006, badge = "565928", published = "12/19/2024 7:32:45 AM", modified = "3/24/2025 6:10:31 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x01 && byte(0x097A1C) == 0x01 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x099387)) == 0x00 &&
              byte(0x099387) == 0x01
)

achievement(
    title = "The First of Many Adventures", points = 3,
    description = "Investigate the volcano at the center of Phoenix Volcano with Dr. Talico.",
    id = 496811, badge = "565929", published = "2/2/2025 8:54:02 PM", modified = "2/15/2025 9:05:10 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x06 && byte(0x09932C) == 0x00 && byte(0x0D5564) == 0x00 &&
              word(0x0D55C0) == 0xFFFF && word(0x0D55C2) == 0x04 && prev(byte(0x0993CE)) == 0x00 &&
              byte(0x0993CE) == 0x01
)

achievement(
    title = "This Might Have Been A Success", points = 10, type="missable",
    description = "Be rewarded with additional money after getting exactly two unique \"Rare\" items on any expedition and finishing with more than 0 Energy.",
    id = 504009, badge = "571381", published = "3/10/2025 5:10:57 PM", modified = "3/24/2025 10:38:25 PM",
    trigger = (byte(0x0D5564) == 0x01 || byte(0x0D5564) == 0x02 || byte(0x0D5564) == 0x03) &&
              word(0x0D55BC) < word(0x0D55BE) && word(0x0D55EA) == word(0x0D5612) && byte(0x0D55E6) >= 0x02 &&
              prev(byte(0x07455A)) == 0xB3 && (byte(0x07455A) == 0xAB || byte(0x07455A) == 0xAC)
)

achievement(
    title = "Remnants of a Legendary Monster", points = 5,
    description = "Obtain a Fire Feather while on an expedition to the Phoenix Volcano or to Kawrea.",
    id = 496812, badge = "565930", published = "2/2/2025 8:54:37 PM", modified = "2/15/2025 9:05:10 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x06 && word(0x0D55BC) < word(0x0D55BE) &&
              prev(byte(0x0D55E4)) != 0x61 && byte(0x0D55E4) == 0x61
)

achievement(
    title = "A Legend Reborn", points = 3,
    description = "Unlock the Phoenix by using a Fire Feather in Combination.",
    id = 496813, badge = "565931", published = "2/2/2025 8:57:22 PM", modified = "3/24/2025 6:09:46 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x14 && byte(0x097A1C) == 0x14 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x09939A)) == 0x00 &&
              byte(0x09939A) == 0x01
)

achievement(
    title = "Childhood Dream Fulfilled", points = 5,
    description = "Get your first Quack Doll by collecting 5 Diamond Marks.",
    id = 486189, badge = "565932", published = "12/13/2024 9:19:51 PM", modified = "2/15/2025 9:05:11 PM",
    trigger = byte(0x09931A) == 0x00 && byte(0x09931B) == 0x00 && byte(0x09931C) == 0x00 && byte(0x09931D) == 0x00 &&
              byte(0x09931E) == 0x00 && prev(byte(0x07455A)) == 0xB3 && byte(0x07455A) == 0xB1
)

achievement(
    title = "It Really Sticks With You", points = 5,
    description = "Obtain Strong Glue while on an expedition to the Torles Mountains.",
    id = 496814, badge = "565933", published = "2/2/2025 9:04:12 PM", modified = "2/15/2025 9:05:12 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x02 && byte(0x0D5564) == 0x02 &&
              word(0x0D55BC) < word(0x0D55BE) && prev(byte(0x0D55E4)) != 0x66 && byte(0x0D55E4) == 0x66
)

achievement(
    title = "Second Time's the Charm", points = 5,
    description = "Get another Quack Doll and glue it together.",
    id = 496815, badge = "565934", published = "2/2/2025 9:04:29 PM", modified = "2/15/2025 9:05:12 PM",
    trigger = byte(0x09931A) == 0x00 && byte(0x09931B) == 0x00 && byte(0x09931C) == 0x00 && byte(0x09931D) == 0x00 &&
              byte(0x09931E) == 0x00 && prev(byte(0x07455A)) == 0xB3 && byte(0x07455A) == 0x67
)

achievement(
    title = "Duct Glue Brings Dreams to Life", points = 3,
    description = "Unlock the Ducken by using a Quack Doll in Combination.",
    id = 488983, badge = "565935", published = "12/24/2024 7:52:33 PM", modified = "3/24/2025 6:08:52 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x20 && byte(0x097A1C) == 0x20 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x0993A6)) == 0x00 &&
              byte(0x0993A6) == 0x01
)

achievement(
    title = "Torokatin XX", points = 5,
    description = "Obtain Paradoxine while on an expedition to the Torles Mountains.",
    id = 500213, badge = "566742", published = "2/20/2025 1:21:21 AM", modified = "2/20/2025 1:21:21 AM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x02 && byte(0x0D5564) == 0x02 &&
              word(0x0D55BC) < word(0x0D55BE) && prev(byte(0x0D55E4)) != 0x29 && byte(0x0D55E4) == 0x29
)

achievement(
    title = "Abominable Tracks", points = 5,
    description = "Locate the Big Footstep in Torles.",
    id = 489402, badge = "565936", published = "12/28/2024 2:10:43 AM", modified = "2/15/2025 9:05:13 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x02 && byte(0x0D5564) == 0x02 &&
              word(0x0D55BC) < word(0x0D55BE) && prev(byte(0x0D55E4)) != 0x5F && byte(0x0D55E4) == 0x5F
)

achievement(
    title = "Big Hands to Accompany Big Tracks", points = 25,
    description = "Defeat Bighand while on an Errantry to Papas.",
    id = 489487, badge = "565937", published = "12/28/2024 5:41:37 PM", modified = "7/8/2025 4:49:05 AM",
    trigger = byte(0x09930A) == 0x00 && byte(0x097BE4) == 0x18 && byte(0x097BE8) == 0x27 &&
              dword(0x0EDC38) == 0x80097B78 && dword(0x0EDC80) == 0x80097D44 && word(0x0EDC2C) > 0x00 &&
              word(0x0EDC3C) > 0x00 && trigger_when(word(0x0EDC84) == 0x00) &&
              trigger_when(prev(byte(0x0EDC24)) == 0x01) && trigger_when(byte(0x0EDC24) == 0x09)
)

achievement(
    title = "Filling In Those Shoes Nicely", points = 3,
    description = "Unlock the Jill by using the Big Boots in Combination.",
    id = 489488, badge = "565938", published = "12/28/2024 5:56:54 PM", modified = "3/24/2025 6:07:56 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x18 && byte(0x097A1C) == 0x18 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x09939E)) == 0x00 &&
              byte(0x09939E) == 0x01
)

achievement(
    title = "To The Monster, The Spoils", points = 5,
    description = "Obtain a Gold Peach while on an expedition to the Parepare Jungle.",
    id = 500212, badge = "566741", published = "2/20/2025 1:21:20 AM", modified = "2/20/2025 1:21:20 AM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x0A && byte(0x0D5564) == 0x01 &&
              word(0x0D55BC) < word(0x0D55BE) && prev(byte(0x0D55E4)) != 0x1A && byte(0x0D55E4) == 0x1A
)

achievement(
    title = "A Sheath Without a Sword", points = 5,
    description = "Obtain an Old Sheath while on an expedition to the Parepare Jungle.",
    id = 486280, badge = "565939", published = "12/14/2024 3:58:58 PM", modified = "2/15/2025 9:05:14 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x0A && byte(0x0D5564) == 0x01 &&
              word(0x0D55BC) < word(0x0D55BE) && prev(byte(0x0D55E4)) != 0x5B && byte(0x0D55E4) == 0x5B
)

achievement(
    title = "Once Ill-Begotten Gains", points = 10,
    description = "Win the A-Rank Invitational that is held on week 4 of February.",
    id = 489530, badge = "565940", published = "12/28/2024 6:42:18 PM", modified = "3/18/2025 3:54:38 PM",
    trigger = byte(0x099235) == 0x04 && byte(0x099236) == 0x02 && byte(0x097BE4) == 0x09 && byte(0x097BE8) == 0x09 &&
              word(0x097BEC) == 0x19B && word(0x097BEE) == 0x15A && word(0x097BF0) == 0xDF && word(0x097BF2) == 0x1A3 &&
              word(0x097BF4) == 0x113 && word(0x097BF6) == 0x124 && word(0x0EDC86) == 0x19B && word(0x0EDC3C) > 0x00 &&
              prev(byte(0x09933B)) == 0xFF && byte(0x09933B) == 0x00
)

achievement(
    title = "Ancient Armor", points = 3,
    description = "Unlock the Durahan by using a Double-Edged in Combination.",
    id = 489558, badge = "565941", published = "12/28/2024 8:24:52 PM", modified = "3/24/2025 6:06:15 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x09 && byte(0x097A1C) == 0x09 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x09938F)) == 0x00 &&
              byte(0x09938F) == 0x01
)

achievement(
    title = "Shrine of the Gods", points = 5,
    description = "Find the Gods Slate while on an expedition to the Kawrea Volcano.",
    id = 489421, badge = "565942", published = "12/28/2024 4:02:39 AM", modified = "2/15/2025 9:05:15 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x06 && byte(0x0D5564) == 0x03 &&
              word(0x0D55BC) < word(0x0D55BE) && prev(byte(0x0D55E4)) != 0x56 && byte(0x0D55E4) == 0x56
)

achievement(
    title = "Don't Mess With the Unknown", points = 5,
    description = "Obtain a Mask during an expedition to Kawrea.",
    id = 489422, badge = "565943", published = "12/28/2024 4:02:40 AM", modified = "2/15/2025 9:05:16 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x06 && byte(0x0D5564) == 0x03 &&
              word(0x0D55BC) < word(0x0D55BE) && prev(byte(0x0D55E4)) != 0x5E && byte(0x0D55E4) == 0x5E
)

achievement(
    title = "Looks Dangerous", points = 3,
    description = "Unlock the Joker by using a Mask during Combination.",
    id = 489424, badge = "565944", published = "12/28/2024 4:13:01 AM", modified = "3/24/2025 6:07:05 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x1A && byte(0x097A1C) == 0x1A &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x0993A0)) == 0x00 &&
              byte(0x0993A0) == 0x01
)

achievement(
    title = "Embrace Your Inner Clown", points = 4,
    description = "Obtain a Monster from Combination that is not a Joker but has its sub-breed as Joker.",
    id = 489561, badge = "565945", published = "12/28/2024 10:44:10 PM", modified = "2/15/2025 9:05:16 PM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) != 0x1A && byte(0x097A1C) == 0x1A &&
              (prev(dword(0x098FBC)) - dword(0x098FBC)) == 0x1F4
)

achievement(
    title = "Nobody Will Ever Believe Us", points = 3,
    description = "Obtain a gift from extraterrestrial visitors.",
    id = 489973, badge = "565946", published = "12/31/2024 3:39:49 PM", modified = "2/15/2025 9:05:17 PM",
    trigger = prev(byte(0x09935E)) == 0x00 && byte(0x09935E) == 0x00 && prev(byte(0x09935F)) == 0x00 &&
              byte(0x09935F) == 0x00 && prev(byte(0x099360)) == 0xFF && byte(0x099360) == 0x00
)

achievement(
    title = "We Still Don't Know How This Works", points = 2,
    description = "Present a Crystal to Chaille and unlock the Metalner monster.",
    id = 489974, badge = "565947", published = "12/31/2024 3:47:06 PM", modified = "2/15/2025 9:05:17 PM",
    trigger = byte(0x099360) == 0x00 && prev(byte(0x099367)) == 0x00 && byte(0x099367) == 0x00 &&
              prev(byte(0x09936C)) == 0xFF && byte(0x09936C) == 0x00 && prev(byte(0x09939C)) == 0x00 &&
              byte(0x09939C) == 0x01
)

achievement(
    title = "The Start of Something Beautiful", points = 3, type="missable",
    description = "Obtain some mysterious seeds from the Shop.",
    id = 488980, badge = "565948", published = "12/24/2024 7:37:37 PM", modified = "2/15/2025 9:05:18 PM",
    trigger = byte(0x099348) == 0xFF && byte(0x0993AC) == 0x00 && prior(byte(0x07455A)) == 0x68 &&
              prev(byte(0x099302)) == 0x00 && byte(0x099302) == 0xFF
)

achievement(
    title = "That's As Big As They Get", points = 5,
    description = "Have a tree grow to its maximum height after planting some seeds on the Ranch.",
    id = 490018, badge = "565949", published = "1/1/2025 8:02:59 AM", modified = "2/15/2025 9:05:18 PM",
    trigger = prev(byte(0x099348)) == 0x00 && byte(0x099348) == 0x00 && prev(byte(0x0993AC)) == 0x05 &&
              byte(0x0993AC) == 0x05 && prev(byte(0x09934E)) == 0xFF && byte(0x09934E) == 0x00
)

achievement(
    title = "Trees Can't Move, Silly!", points = 5,
    description = "Watch as a tree blooms on your Ranch.",
    id = 495751, badge = "565950", published = "2/1/2025 8:47:42 PM", modified = "2/15/2025 9:05:18 PM",
    trigger = byte(0x099235) == 0x01 && byte(0x099236) == 0x04 && byte(0x0992E5) == 0x00 && byte(0x09934E) == 0x00 &&
              prior(byte(0x09934F)) == 0x00 && byte(0x09934F) == 0xFF && prev(byte(0x0993AC)) == 0x0B &&
              byte(0x0993AC) == 0x0B
)

achievement(
    title = "Ranch's Haunted", points = 5,
    description = "Find a Mock on your Ranch following a Monster's death.",
    id = 495762, badge = "565951", published = "2/1/2025 10:59:42 PM", modified = "2/15/2025 9:05:19 PM",
    trigger = word(0x097A20) == 0x00 && word(0x097A22) == 0x00 && word(0x097A24) == 0x00 && word(0x097A26) == 0x00 &&
              word(0x097A28) == 0x00 && word(0x097A2A) == 0x00 && prev(byte(0x097A18)) != 0x2E && byte(0x097A18) == 0x1F &&
              prev(byte(0x097A1C)) != 0x2E && byte(0x097A1C) == 0x1F && prev(byte(0x0993A5)) == 0x00 &&
              byte(0x0993A5) == 0x01
)

achievement(
    title = "Hop To It", points = 10,
    description = "Get any Hopper to Rank B.",
    id = 489395, badge = "565952", published = "12/28/2024 1:27:44 AM", modified = "2/15/2025 9:05:19 PM",
    trigger = byte(0x097A18) == 0x0C && byte(0x099235) == 0x04 &&
              (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
              (prev(byte(0x097B92)) == 0x01 || prev(byte(0x097B92)) == 0x02) && byte(0x097B92) == 0x03
)

achievement(
    title = "Great Discoveries", points = 5,
    description = "Have your active monster excavate hot springs and associated treasures on your Ranch.",
    id = 489396, badge = "565953", published = "12/28/2024 1:28:08 AM", modified = "2/15/2025 9:05:20 PM",
    trigger = byte(0x097A18) == 0x0C && byte(0x097B92) >= 0x03 && prior(byte(0x0993A4)) == 0x00 &&
              byte(0x0993A4) == 0x01 && prior(byte(0x099343)) == 0xFF && byte(0x099343) == 0x00 &&
              prior(byte(0x07455A)) == 0xAA && byte(0x07455A) == 0xB3 && prev(byte(0x099356)) == 0xFF &&
              byte(0x099356) == 0x00
)

achievement(
    title = "Goddess of Water", points = 5,
    description = "Use the Slate found on your Ranch in Combination to unlock the Undine.",
    id = 489397, badge = "565954", published = "12/28/2024 1:31:54 AM", modified = "3/24/2025 5:51:50 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x1D && byte(0x097A1C) == 0x1D &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x0993A3)) == 0x00 &&
              byte(0x0993A3) == 0x01
)

achievement(
    title = "Some Call Him the Whaley King", points = 25,
    description = "Defeat the Zilla King while on an Errantry to the Torble Sea.",
    id = 489560, badge = "565955", published = "12/28/2024 9:58:33 PM", modified = "7/8/2025 4:49:02 AM",
    trigger = byte(0x099340) == 0x00 && byte(0x09930A) == 0x00 && byte(0x097BE4) == 0x11 && byte(0x097BE8) == 0x27 &&
              dword(0x0EDC38) == 0x80097B78 && dword(0x0EDC80) == 0x80097D44 && word(0x0EDC2C) > 0x00 &&
              word(0x0EDC3C) > 0x00 && trigger_when(word(0x0EDC84) == 0x00) &&
              trigger_when(prev(byte(0x0EDC24)) == 0x01) && trigger_when(byte(0x0EDC24) == 0x09)
)

achievement(
    title = "The New King of Ocean", points = 3,
    description = "Unlock the Zilla by using a Zilla Beard in Combination.",
    id = 489562, badge = "565956", published = "12/28/2024 11:05:35 PM", modified = "3/24/2025 6:05:26 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x11 && byte(0x097A1C) == 0x11 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x099397)) == 0x00 &&
              byte(0x099397) == 0x01
)

achievement(
    title = "Can We Just Forget About This?", points = 5, type="missable",
    description = "Be forced to accept a spooky gift from a loving fan.",
    id = 487671, badge = "565957", published = "12/22/2024 7:20:36 PM", modified = "2/15/2025 9:05:22 PM",
    trigger = byte(0x099351) == 0xFF && byte(0x0992E6) <= 0x04 && trigger_when(byte(0x099352) == 0x00) &&
              trigger_when(byte(0x099353) == 0x00) && prev(byte(0x099350)) == 0xFF &&
              trigger_when(byte(0x099350) == 0x00)
)

achievement(
    title = "Bearer of Bad Luck", points = 10,
    description = "Have a gift doll come to life following a Monster's death on the Ranch.",
    id = 489977, badge = "565958", published = "12/31/2024 4:23:07 PM", modified = "2/15/2025 9:05:23 PM",
    trigger = word(0x097A20) == 0x00 && word(0x097A22) == 0x00 && word(0x097A24) == 0x00 && word(0x097A26) == 0x00 &&
              word(0x097A28) == 0x00 && word(0x097A2A) == 0x00 && prev(byte(0x097A18)) != 0x2E && byte(0x097A18) == 0x06 &&
              prev(byte(0x097A1C)) != 0x2E && byte(0x097A1C) == 0x06 && prev(byte(0x09938C)) == 0x00 &&
              byte(0x09938C) == 0x01
)

achievement(
    title = "Time To Raid the CD Rack", points = 25,
    description = "Unlock all Monster breeds.",
    id = 495763, badge = "565959", published = "2/1/2025 11:00:02 PM", modified = "2/15/2025 9:05:23 PM",
    trigger = (prev(byte(0x099386)) + prev(byte(0x099387)) + prev(byte(0x099388)) + prev(byte(0x099389)) +
              prev(byte(0x09938A)) + prev(byte(0x09938B)) + prev(byte(0x09938C)) + prev(byte(0x09938D)) +
              prev(byte(0x09938E)) + prev(byte(0x09938F)) + prev(byte(0x099390)) + prev(byte(0x099391)) +
              prev(byte(0x099392)) + prev(byte(0x099393)) + prev(byte(0x099394)) + prev(byte(0x099395)) +
              prev(byte(0x099396)) + prev(byte(0x099397)) + prev(byte(0x099398)) + prev(byte(0x099399)) +
              prev(byte(0x09939A)) + prev(byte(0x09939B)) + prev(byte(0x09939C)) + prev(byte(0x09939D)) +
              prev(byte(0x09939E)) + prev(byte(0x09939F)) + prev(byte(0x0993A0)) + prev(byte(0x0993A1)) +
              prev(byte(0x0993A2)) + prev(byte(0x0993A3)) + prev(byte(0x0993A4)) + prev(byte(0x0993A5)) +
              prev(byte(0x0993A6)) + prev(byte(0x0993A7)) + prev(byte(0x0993A8)) + prev(byte(0x0993A9)) +
              prev(byte(0x0993AA)) + prev(byte(0x0993AB))) == 0x25 &&
              measured((byte(0x099386) + byte(0x099387) + byte(0x099388) + byte(0x099389) + byte(0x09938A) +
                  byte(0x09938B) + byte(0x09938C) + byte(0x09938D) + byte(0x09938E) + byte(0x09938F) + byte(0x099390) +
                  byte(0x099391) + byte(0x099392) + byte(0x099393) + byte(0x099394) + byte(0x099395) + byte(0x099396) +
                  byte(0x099397) + byte(0x099398) + byte(0x099399) + byte(0x09939A) + byte(0x09939B) + byte(0x09939C) +
                  byte(0x09939D) + byte(0x09939E) + byte(0x09939F) + byte(0x0993A0) + byte(0x0993A1) + byte(0x0993A2) +
                  byte(0x0993A3) + byte(0x0993A4) + byte(0x0993A5) + byte(0x0993A6) + byte(0x0993A7) + byte(0x0993A8) +
                  byte(0x0993A9) + byte(0x0993AA) + byte(0x0993AB)) == 0x26
              )
)

achievement(
    title = "Breadth First Trainer", points = 25,
    description = "Train at least one of each Monster breed.",
    id = 490560, badge = "565960", published = "1/5/2025 12:03:22 AM", modified = "2/15/2025 9:05:23 PM",
    trigger = prev(byte(0x098FAA)) != 0xFF &&
              (prev(word(0x098FDE)) == 0x00 || prev(word(0x098FE0)) == 0x00 || prev(word(0x098FE2)) == 0x00 ||
                  prev(word(0x098FE4)) == 0x00 || prev(word(0x098FE6)) == 0x00 || prev(word(0x098FE8)) == 0x00 ||
                  prev(word(0x098FEA)) == 0x00 || prev(word(0x098FEC)) == 0x00 || prev(word(0x098FEE)) == 0x00 ||
                  prev(word(0x098FF0)) == 0x00 || prev(word(0x098FF2)) == 0x00 || prev(word(0x098FF4)) == 0x00 ||
                  prev(word(0x098FF6)) == 0x00 || prev(word(0x098FF8)) == 0x00 || prev(word(0x098FFA)) == 0x00 ||
                  prev(word(0x098FFC)) == 0x00 || prev(word(0x098FFE)) == 0x00 || prev(word(0x099000)) == 0x00 ||
                  prev(word(0x099002)) == 0x00 || prev(word(0x099004)) == 0x00 || prev(word(0x099006)) == 0x00 ||
                  prev(word(0x099008)) == 0x00 || prev(word(0x09900A)) == 0x00 || prev(word(0x09900C)) == 0x00 ||
                  prev(word(0x09900E)) == 0x00 || prev(word(0x099010)) == 0x00 || prev(word(0x099012)) == 0x00 ||
                  prev(word(0x099014)) == 0x00 || prev(word(0x099016)) == 0x00 || prev(word(0x099018)) == 0x00 ||
                  prev(word(0x09901A)) == 0x00 || prev(word(0x09901C)) == 0x00 || prev(word(0x09901E)) == 0x00 ||
                  prev(word(0x099020)) == 0x00 || prev(word(0x099022)) == 0x00 || prev(word(0x099024)) == 0x00 ||
                  prev(word(0x099026)) == 0x00 || prev(word(0x099028)) == 0x00
              ) 
              && measured(
                word(0x098FDE) / word(0x098FDE) + 
                word(0x098FE0) / word(0x098FE0) +
                word(0x098FE2) / word(0x098FE2) + 
                word(0x098FE4) / word(0x098FE4) +
                word(0x098FE6) / word(0x098FE6) +
                word(0x098FE8) / word(0x098FE8) + 
                word(0x098FEA) / word(0x098FEA) +
                word(0x098FEC) / word(0x098FEC) +
                word(0x098FEE) / word(0x098FEE) + 
                word(0x098FF0) / word(0x098FF0) + 
                word(0x098FF2) / word(0x098FF2) + 
                word(0x098FF4) / word(0x098FF4) + 
                word(0x098FF6) / word(0x098FF6) + 
                word(0x098FF8) / word(0x098FF8) + 
                word(0x098FFA) / word(0x098FFA) + 
                word(0x098FFC) / word(0x098FFC) +
                word(0x098FFE) / word(0x098FFE) + 
                word(0x099000) / word(0x099000) + 
                word(0x099002) / word(0x099002) + 
                word(0x099004) / word(0x099004) +
                word(0x099006) / word(0x099006) +
                word(0x099008) / word(0x099008) + 
                word(0x09900A) / word(0x09900A) +
                word(0x09900C) / word(0x09900C) +
                word(0x09900E) / word(0x09900E) + 
                word(0x099010) / word(0x099010) +   
                word(0x099012) / word(0x099012) + 
                word(0x099014) / word(0x099014) +
                word(0x099016) / word(0x099016) +
                word(0x099018) / word(0x099018) + 
                word(0x09901A) / word(0x09901A) +
                word(0x09901C) / word(0x09901C) +
                word(0x09901E) / word(0x09901E) +
                word(0x099020) / word(0x099020) +
                word(0x099022) / word(0x099022) +
                word(0x099024) / word(0x099024) +
                word(0x099026) / word(0x099026) +
                word(0x099028) / word(0x099028) == 0x26,
                when=always_true(),
                format="raw"
              )
)

achievement(
    title = "Going Out on a High Note", points = 3,
    description = "Win any Official Tournament with a Sueki Suezo and have it rank up.",
    id = 490009, badge = "565961", published = "1/1/2025 12:26:24 AM", modified = "2/15/2025 9:05:24 PM",
    trigger = byte(0x099235) == 0x04 &&
              (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
              (byte(0x09961C) == 0x47 || byte(0x09961C) == 0x48) && byte(0x097A18) == 0x17 && byte(0x097A1C) == 0x2B &&
              prev(byte(0x097B92)) == 0x00 && (byte(0x097B92) == 0x01 || byte(0x097B92) == 0x02)
)

achievement(
    title = "I Play to Win", points = 3,
    description = "Win against your Monster in a round of Mudball Fight or Snowball Fight.",
    id = 498055, badge = "563508", published = "2/8/2025 8:36:05 PM", modified = "3/20/2025 10:26:32 PM",
    trigger = byte(tbyte(0x093520)) == 0x19 && word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000E8) == 0x00 &&
              once((word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000E8) == 0x708) &&
                  word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA) == 0x02
              ) &&
              once((word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000E8) == 0x708) &&
                  word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA) == 0x05
              ) && prev(word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA)) > 0x00 &&
              word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA) == 0x00 &&
              byte(tbyte(tbyte(0x093520) + 0x000010) + 0x0000AC) > byte(tbyte(tbyte(0x093520) + 0x000010) + 0x0000C8) &&
              never(prev(dword(0x099228)) < dword(0x099228))
)

achievement(
    title = "Rock, Paper, Sumo!", points = 10,
    description = "Win in a sumo match against your Monster.",
    id = 503928, badge = "571372", published = "3/10/2025 4:26:16 AM", modified = "3/20/2025 10:26:31 PM",
    trigger = byte(tbyte(0x093520)) == 0x19 &&
              once((prev(byte(tbyte(tbyte(0x093520) + 0x000010))) == 0x09) && byte(tbyte(tbyte(0x093520) + 0x000010)) == 0x0A) &&
              once((prev(word(tbyte(tbyte(0x093520) + 0x000010) + 0x00006C)) == 0x708) &&
                  word(tbyte(tbyte(0x093520) + 0x000010) + 0x00006C) < 0x708
              ) && dword(tbyte(tbyte(0x093520) + 0x000010) + 0x000070) >= 0xFFFFFFAC &&
              prev(byte(tbyte(tbyte(0x093520) + 0x000010))) >= 0x0C &&
              prev(byte(tbyte(tbyte(0x093520) + 0x000010))) <= 0x0F && byte(tbyte(tbyte(0x093520) + 0x000010)) == 0x10 &&
              never(byte(0x098FAA) == 0xFF) && never(prev(dword(0x099228)) < dword(0x099228))
)

achievement(
    title = "You Might Be a Bully", points = 5,
    description = "Win against your monster in a sparring match.",
    id = 503934, badge = "571378", published = "3/10/2025 6:15:18 AM", modified = "3/21/2025 4:36:49 AM",
    trigger = byte(tbyte(0x093520)) == 0x19 &&
              ((word(tbyte(tbyte(0x06B91C)) + 0x000098) == 0x12C && word(tbyte(tbyte(0x06B91C)) + 0x00009C) > 0x00 &&
                word(tbyte(tbyte(0x06B91C)) + 0x00009C) <= word(tbyte(tbyte(0x06B91C)) + 0x000098) &&
                word(tbyte(tbyte(0x06B91C)) + 0x0000EC) > 0x00 && prev(word(tbyte(tbyte(0x06B91C)) + 0x00006C)) > 0x00 &&
                word(tbyte(tbyte(0x06B91C)) + 0x00006C) == 0x00) ||
               (word(tbyte(tbyte(0x06B91C)) + 0x000098) == 0x12C && word(tbyte(tbyte(0x06B91C)) + 0x00009C) > 0x00 &&
                word(tbyte(tbyte(0x06B91C)) + 0x00009C) <= word(tbyte(tbyte(0x06B91C)) + 0x000098) &&
                (0.0 + (word(tbyte(tbyte(0x06B91C)) + 0x00006C) / word(0x000068)) + 0x00 - (word(tbyte(tbyte(0x06B91C))
                + 0x00009C) / word(0x000098))) <= 0.0 && prev(word(tbyte(tbyte(0x06B91C)) + 0x0000EC)) > 0x00 &&
                word(tbyte(tbyte(0x06B91C)) + 0x0000EC) == 0x00) ||
               (word(tbyte(tbyte(tbyte(0x06B91C))) + 0x000098) == 0x12C &&
                word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00009C) > 0x00 &&
                word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00009C) <= word(tbyte(tbyte(tbyte(0x06B91C))) + 0x000098) &&
                word(tbyte(tbyte(tbyte(0x06B91C))) + 0x0000EC) > 0x00 &&
                prev(word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00006C)) > 0x00 &&
                word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00006C) == 0x00) ||
               (word(tbyte(tbyte(tbyte(0x06B91C))) + 0x000098) == 0x12C &&
                word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00009C) > 0x00 &&
                word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00009C) <= word(tbyte(tbyte(tbyte(0x06B91C))) + 0x000098) &&
                (0.0 + (word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00006C) / word(0x000068)) + 0x00 -
                (word(tbyte(tbyte(tbyte(0x06B91C))) + 0x00009C) / word(0x000098))) <= 0.0 &&
                prev(word(tbyte(tbyte(tbyte(0x06B91C))) + 0x0000EC)) > 0x00 &&
                word(tbyte(tbyte(tbyte(0x06B91C))) + 0x0000EC) == 0x00))
)

achievement(
    title = "Strangely Anticlimactic", points = 1,
    description = "Find the one mountain you can walk into while on an expedition to Kawrea.",
    id = 489423, badge = "565962", published = "12/28/2024 4:02:40 AM", modified = "2/15/2025 9:05:25 PM",
    trigger = byte(0x0D5564) == 0x03 && word(0x0D55C0) == 0x07 && prev(word(0x0D55C2)) == 0x0D && word(0x0D55C2) == 0x0E
)

achievement(
    title = "The Pot's a Safe Place to Hide", points = 5,
    description = "Slate a Magic from Monster Rancher 1.",
    id = 504040, badge = "571410", published = "3/10/2025 9:53:17 PM", modified = "3/10/2025 9:53:17 PM",
    trigger = byte(0x099316) == 0x00 && byte(0x099398) == 0x01 && byte(tbyte(0x078720)) == 0x12 &&
              byte(tbyte(0x078720) + 0x000004) == 0x27 && prev(byte(0x097A18)) == 0x2E && byte(0x097A18) == 0x12 &&
              prev(byte(0x097A1C)) == 0x2E && byte(0x097A1C) == 0x27
)

achievement(
    title = "Back on the Wall With You", points = 5,
    description = "Slate a Doodle from Monster Rancher 1.",
    id = 504041, badge = "571411", published = "3/10/2025 9:53:18 PM", modified = "3/10/2025 9:53:18 PM",
    trigger = byte(tbyte(0x078720)) == 0x22 && byte(tbyte(0x078720) + 0x000004) == 0x28 && prev(byte(0x097A18)) == 0x2E &&
              byte(0x097A18) == 0x22 && prev(byte(0x097A1C)) == 0x2E && byte(0x097A1C) == 0x28
)

achievement(
    title = "Is That Disc Walking?", points = 5,
    description = "Slate a Disk from Monster Rancher 1.",
    id = 504042, badge = "571412", published = "3/10/2025 9:53:18 PM", modified = "3/10/2025 9:53:18 PM",
    trigger = byte(0x099343) == 0x00 && byte(0x0993A4) == 0x01 && byte(tbyte(0x078720)) == 0x1E &&
              byte(tbyte(0x078720) + 0x000004) == 0x28 && prev(byte(0x097A18)) == 0x2E && byte(0x097A18) == 0x1E &&
              prev(byte(0x097A1C)) == 0x2E && byte(0x097A1C) == 0x28
)

achievement(
    title = "2 Plus 3... Turns Out It's 1", points = 3,
    description = "Produce a Gold Suezo via Combination at the Lab.",
    id = 505353, badge = "572654", published = "3/13/2025 7:34:53 PM", modified = "3/24/2025 6:15:37 AM",
    trigger = byte(0x097A18) == 0x17 && byte(0x097A1C) == 0x26 &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x09918F)) == 0x00 &&
              byte(0x09918F) == 0x01
)

achievement(
    title = "What If I Did That Two Times?", points = 10,
    description = "Learn a tech from Errantry that requires your Monster to have used a specific tech 25 or 30 times (excludes the x50 usage chains).",
    id = 503804, badge = "571305", published = "3/9/2025 7:50:50 PM", modified = "3/21/2025 2:17:36 AM",
    trigger = byte(tbyte(0x078808) + 0x0000C3) == 0x01 &&
              ((byte(0x097A18) == 0x00 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x00 && byte(0x097BA0) == 0x01 && byte(0x097BA1) >= 0x1E &&
                prev(byte(0x097BA2)) == 0x00 && byte(0x097BA2) == 0x01) ||
               (byte(0x097A18) == 0x01 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x01 && byte(0x097B9E) == 0x01 && byte(0x097B9F) >= 0x1E &&
                prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x02 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x04 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x04 && byte(0x097B9C) == 0x01 && byte(0x097B9D) >= 0x1E &&
                prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x05 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x05 && byte(0x097BA0) == 0x01 && byte(0x097BA1) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x06 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x07 && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x1E &&
                prev(byte(0x097B9A)) == 0x00 && byte(0x097B9A) == 0x01) ||
               (byte(0x097A18) == 0x07 && byte(0x097B9C) == 0x01 && byte(0x097B9D) >= 0x1E &&
                prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x08 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x08 && byte(0x097B9C) == 0x01 && byte(0x097B9D) >= 0x1E &&
                prev(byte(0x097BA2)) == 0x00 && byte(0x097BA2) == 0x01) ||
               (byte(0x097A18) == 0x08 && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x1E &&
                prev(byte(0x097BA8)) == 0x00 && byte(0x097BA8) == 0x01) ||
               (byte(0x097A18) == 0x08 && byte(0x097BA8) == 0x01 && byte(0x097BA9) >= 0x1E &&
                prev(byte(0x097BAA)) == 0x00 && byte(0x097BAA) == 0x01) ||
               (byte(0x097A18) == 0x08 && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x19 &&
                prev(byte(0x097BB0)) == 0x00 && byte(0x097BB0) == 0x01) ||
               (byte(0x097A18) == 0x09 && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x1E &&
                prev(byte(0x097B9A)) == 0x00 && byte(0x097B9A) == 0x01) ||
               (byte(0x097A18) == 0x09 && byte(0x097BB2) == 0x01 && byte(0x097BB3) >= 0x1E &&
                prev(byte(0x097BB4)) == 0x00 && byte(0x097BB4) == 0x01) ||
               (byte(0x097A18) == 0x0A && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097BA6)) == 0x00 && byte(0x097BA6) == 0x01) ||
               (byte(0x097A18) == 0x10 && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x15 && byte(0x097BBE) == 0x01 && byte(0x097BBF) >= 0x19 &&
                prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x15 && byte(0x097BA8) == 0x01 && byte(0x097BA9) >= 0x19 &&
                prev(byte(0x097BAA)) == 0x00 && byte(0x097BAA) == 0x01) ||
               (byte(0x097A18) == 0x15 && byte(0x097B9E) == 0x01 && byte(0x097B9F) >= 0x19 &&
                prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x1B && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x1E &&
                prev(byte(0x097BA8)) == 0x00 && byte(0x097BA8) == 0x01) ||
               (byte(0x097A18) == 0x1C && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x1C && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x1E &&
                prev(byte(0x097BA8)) == 0x00 && byte(0x097BA8) == 0x01) ||
               (byte(0x097A18) == 0x1D && byte(0x097B9A) == 0x01 && byte(0x097B9B) >= 0x1E &&
                prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x1E && byte(0x097B9C) == 0x01 && byte(0x097B9D) >= 0x1E &&
                prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x1E && byte(0x097B9E) == 0x01 && byte(0x097B9F) >= 0x1E &&
                prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x20 && byte(0x097BB4) == 0x01 && byte(0x097BB5) >= 0x19 &&
                prev(byte(0x097BB6)) == 0x00 && byte(0x097BB6) == 0x01) ||
               (byte(0x097A18) == 0x21 && byte(0x097BBE) == 0x01 && byte(0x097BBF) >= 0x19 &&
                prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x21 && byte(0x097B9C) == 0x01 && byte(0x097B9D) >= 0x19 &&
                prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x22 && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x1E &&
                prev(byte(0x097BB2)) == 0x00 && byte(0x097BB2) == 0x01) ||
               (byte(0x097A18) == 0x22 && byte(0x097BB2) == 0x01 && byte(0x097BB3) >= 0x1E &&
                prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x25 && byte(0x097BB4) == 0x01 && byte(0x097BB5) >= 0x19 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01))
)

achievement(
    title = "We Fight With Honor", points = 5,
    description = "Learn a tech from Errantry that requires your Monster's nature to be Good or Best.",
    id = 505352, badge = "572638", published = "3/13/2025 7:19:08 PM", modified = "3/17/2025 8:47:29 PM",
    trigger = byte(tbyte(0x078808) + 0x0000C3) == 0x01 &&
              ((byte(0x097A18) == 0x00 && prev(byte(0x097BBA)) == 0x00 && byte(0x097BBA) == 0x01) ||
               (byte(0x097A18) == 0x00 && byte(0x097BC6) == 0x01 && byte(0x097BC7) >= 0x32 &&
                prev(byte(0x097BC8)) == 0x00 && byte(0x097BC8) == 0x01) ||
               (byte(0x097A18) == 0x01 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x02 && prev(byte(0x097BAC)) == 0x00 && byte(0x097BAC) == 0x01) ||
               (byte(0x097A18) == 0x02 && byte(0x097BAC) == 0x01 && byte(0x097BAD) >= 0x32 &&
                prev(byte(0x097BA2)) == 0x00 && byte(0x097BA2) == 0x01) ||
               (byte(0x097A18) == 0x03 && byte(0x097BB6) == 0x01 && byte(0x097BB7) >= 0x32 &&
                prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x04 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x05 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x05 && byte(0x097BC0) == 0x01 && byte(0x097BC1) >= 0x32 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x05 && byte(0x097BC2) == 0x01 && byte(0x097BC3) >= 0x32 &&
                prev(byte(0x097BC4)) == 0x00 && byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x06 && prev(byte(0x097BB4)) == 0x00 && byte(0x097BB4) == 0x01) ||
               (byte(0x097A18) == 0x06 && byte(0x097BB4) == 0x01 && byte(0x097BB5) >= 0x32 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x07 && prev(byte(0x097BC4)) == 0x00 && byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x07 && byte(0x097BC4) == 0x01 && byte(0x097BC5) >= 0x32 &&
                prev(byte(0x097BC6)) == 0x00 && byte(0x097BC6) == 0x01) ||
               (byte(0x097A18) == 0x08 && prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x08 && byte(0x097BBE) == 0x01 && byte(0x097BBF) >= 0x32 &&
                prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x09 && prev(byte(0x097BBA)) == 0x00 && byte(0x097BBA) == 0x01) ||
               (byte(0x097A18) == 0x09 && prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x09 && byte(0x097BB8) == 0x01 && byte(0x097BB9) >= 0x32 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x0A && prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x0A && byte(0x097BA0) == 0x01 && byte(0x097BA1) >= 0x32 &&
                prev(byte(0x097BA2)) == 0x00 && byte(0x097BA2) == 0x01) ||
               (byte(0x097A18) == 0x0C && byte(0x097B9E) == 0x01 && byte(0x097B9F) >= 0x32 &&
                prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x0D && byte(0x097BB0) == 0x01 && byte(0x097BB1) >= 0x32 &&
                prev(byte(0x097BB6)) == 0x00 && byte(0x097BB6) == 0x01) ||
               (byte(0x097A18) == 0x0E && prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x0F && prev(byte(0x097BB6)) == 0x00 && byte(0x097BB6) == 0x01) ||
               (byte(0x097A18) == 0x0F && prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x0F && byte(0x097BB0) == 0x01 && byte(0x097BB1) >= 0x32 &&
                prev(byte(0x097BBC)) == 0x00 && byte(0x097BBC) == 0x01) ||
               (byte(0x097A18) == 0x10 && byte(0x097BAC) == 0x01 && byte(0x097BAD) >= 0x32 &&
                prev(byte(0x097BAE)) == 0x00 && byte(0x097BAE) == 0x01) ||
               (byte(0x097A18) == 0x10 && prev(byte(0x097BC6)) == 0x00 && byte(0x097BC6) == 0x01) ||
               (byte(0x097A18) == 0x11 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x12 && byte(0x097BB4) == 0x01 && byte(0x097BB5) >= 0x32 &&
                prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x12 && byte(0x097BAA) == 0x01 && byte(0x097BAB) >= 0x32 &&
                prev(byte(0x097BB2)) == 0x00 && byte(0x097BB2) == 0x01) ||
               (byte(0x097A18) == 0x12 && byte(0x097BB0) == 0x01 && byte(0x097BB1) >= 0x32 &&
                prev(byte(0x097BB6)) == 0x00 && byte(0x097BB6) == 0x01) ||
               (byte(0x097A18) == 0x13 && prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x13 && byte(0x097B9C) == 0x01 && byte(0x097B9D) >= 0x32 &&
                prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x14 && byte(0x097BB6) == 0x01 && byte(0x097BB7) >= 0x32 &&
                prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x16 && prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x18 && prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x19 && byte(0x097BC0) == 0x01 && byte(0x097BC1) >= 0x32 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x19 && byte(0x097BB6) == 0x01 && byte(0x097BB7) >= 0x32 &&
                prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x1B && prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x1B && byte(0x097BAC) == 0x01 && byte(0x097BAD) >= 0x32 &&
                prev(byte(0x097BAE)) == 0x00 && byte(0x097BAE) == 0x01) ||
               (byte(0x097A18) == 0x1C && prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x1D && prev(byte(0x097BAE)) == 0x00 && byte(0x097BAE) == 0x01) ||
               (byte(0x097A18) == 0x1D && byte(0x097BAE) == 0x01 && byte(0x097BAF) >= 0x32 &&
                prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x1D && prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x1D && byte(0x097BB8) == 0x01 && byte(0x097BB9) >= 0x32 &&
                prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x1D && prev(byte(0x097BC4)) == 0x00 && byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x1E && byte(0x097BAE) == 0x01 && byte(0x097BAF) >= 0x32 &&
                prev(byte(0x097BB0)) == 0x00 && byte(0x097BB0) == 0x01) ||
               (byte(0x097A18) == 0x20 && byte(0x097BBE) == 0x01 && byte(0x097BBF) >= 0x32 &&
                prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x20 && prev(byte(0x097BC6)) == 0x00 && byte(0x097BC6) == 0x01) ||
               (byte(0x097A18) == 0x20 && byte(0x097BB6) == 0x01 && byte(0x097BB7) >= 0x32 &&
                prev(byte(0x097BB9)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x21 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x22 && byte(0x097BC6) == 0x01 && byte(0x097BC7) >= 0x32 &&
                prev(byte(0x097BC8)) == 0x00 && byte(0x097BC8) == 0x01) ||
               (byte(0x097A18) == 0x23 && prev(byte(0x097BC6)) == 0x00 && byte(0x097BC6) == 0x01) ||
               (byte(0x097A18) == 0x25 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01))
)

achievement(
    title = "That's A Real Dirty Trick There", points = 5,
    description = "Learn a tech from Errantry that requires your Monster's nature to be Bad or Worst.",
    id = 505503, badge = "572826", published = "3/14/2025 5:16:27 PM", modified = "3/17/2025 8:47:29 PM",
    trigger = byte(tbyte(0x078808) + 0x0000C3) == 0x01 &&
              ((byte(0x097A18) == 0x00 && byte(0x097BBE) == 0x01 && byte(0x097BBF) >= 0x32 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x00 && prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x01 && prev(byte(0x097BAC)) == 0x00 && byte(0x097BAC) == 0x01) ||
               (byte(0x097A18) == 0x01 && byte(0x097BAC) == 0x01 && byte(0x097BAD) >= 0x32 &&
                prev(byte(0x097BAE)) == 0x00 && byte(0x097BAE) == 0x01) ||
               (byte(0x097A18) == 0x02 && byte(0x097BA0) == 0x01 && byte(0x097BA1) >= 0x32 &&
                prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x03 && prev(byte(0x097BAC)) == 0x00 && byte(0x097BAC) == 0x01) ||
               (byte(0x097A18) == 0x04 && prev(byte(0x097BA6)) == 0x00 && byte(0x097BA6) == 0x01) ||
               (byte(0x097A18) == 0x05 && prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x06 && prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x07 && prev(byte(0x097BA4)) == 0x00 && byte(0x097BA4) == 0x01) ||
               (byte(0x097A18) == 0x07 && byte(0x097BA4) == 0x01 && byte(0x097BA5) >= 0x32 &&
                prev(byte(0x097BAA)) == 0x00 && byte(0x097BAA) == 0x01) ||
               (byte(0x097A18) == 0x08 && prev(byte(0x097BAC)) == 0x00 && byte(0x097BAC) == 0x01) ||
               (byte(0x097A18) == 0x09 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x09 && byte(0x097BC0) == 0x01 && byte(0x097BC1) >= 0x32 &&
                prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x09 && prev(byte(0x097BAA)) == 0x00 && byte(0x097BAA) == 0x01) ||
               (byte(0x097A18) == 0x0A && prev(byte(0x097BC4)) == 0x00 && byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x0A && prev(byte(0x097BC6)) == 0x00 && byte(0x097BC6) == 0x01) ||
               (byte(0x097A18) == 0x0A && prev(byte(0x097B9E)) == 0x00 && byte(0x097B9E) == 0x01) ||
               (byte(0x097A18) == 0x0C && byte(0x097BBE) == 0x01 && byte(0x097BBF) >= 0x32 &&
                prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x0D && prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x0E && prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x0F && prev(byte(0x097BC8)) == 0x00 && byte(0x097BC8) == 0x01) ||
               (byte(0x097A18) == 0x10 && byte(0x097BB2) == 0x01 && byte(0x097BB3) >= 0x32 &&
                prev(byte(0x097BB4)) == 0x00 && byte(0x097BB4) == 0x01) ||
               (byte(0x097A18) == 0x10 && prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x10 && prev(byte(0x097BA8)) == 0x00 && byte(0x097BA8) == 0x01) ||
               (byte(0x097A18) == 0x11 && prev(byte(0x097BB4)) == 0x00 && byte(0x097BB4) == 0x01) ||
               (byte(0x097A18) == 0x12 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x12 && byte(0x097BC0) == 0x01 && byte(0x097BC1) >= 0x32 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x12 && byte(0x097BC2) == 0x01 && byte(0x097BC3) >= 0x32 &&
                prev(byte(0x097BC4)) == 0x00 && byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x13 && prev(byte(0x097BAA)) == 0x00 && byte(0x097BAA) == 0x01) ||
               (byte(0x097A18) == 0x14 && byte(0x097BB2) == 0x01 && byte(0x097BB3) >= 0x32 &&
                prev(byte(0x097BB4)) == 0x00 && byte(0x097BB4) == 0x01) ||
               (byte(0x097A18) == 0x16 && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x18 && prev(byte(0x097BAA)) == 0x00 && byte(0x097BAA) == 0x01) ||
               (byte(0x097A18) == 0x19 && byte(0x097BB6) == 0x01 && byte(0x097BB7) >= 0x32 &&
                prev(byte(0x097BBA)) == 0x00 && byte(0x097BBA) == 0x01) ||
               (byte(0x097A18) == 0x1A && prev(byte(0x097BA6)) == 0x00 && byte(0x097BA6) == 0x01) ||
               (byte(0x097A18) == 0x1A && prev(byte(0x097BB2)) == 0x00 && byte(0x097BB2) == 0x01) ||
               (byte(0x097A18) == 0x1A && prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x1A && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x1B && prev(byte(0x097BC0)) == 0x00 && byte(0x097BC0) == 0x01) ||
               (byte(0x097A18) == 0x1B && prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x1B && byte(0x097BA2) == 0x01 && byte(0x097BA3) >= 0x32 &&
                prev(byte(0x097BB0)) == 0x00 && byte(0x097BB0) == 0x01) ||
               (byte(0x097A18) == 0x1C && prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x1D && prev(byte(0x097BA6)) == 0x00 && byte(0x097BA6) == 0x01) ||
               (byte(0x097A18) == 0x1D && byte(0x097BA6) == 0x01 && byte(0x097BA7) >= 0x32 &&
                prev(byte(0x097BA8)) == 0x00 && byte(0x097BA8) == 0x01) ||
               (byte(0x097A18) == 0x1E && prev(byte(0x097BB8)) == 0x00 && byte(0x097BB8) == 0x01) ||
               (byte(0x097A18) == 0x1F && prev(byte(0x097BBE)) == 0x00 && byte(0x097BBE) == 0x01) ||
               (byte(0x097A18) == 0x20 && byte(0x097BBE) == 0x01 && byte(0x097BBF) >= 0x32 &&
                prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x20 && prev(byte(0x097B9C)) == 0x00 && byte(0x097B9C) == 0x01) ||
               (byte(0x097A18) == 0x21 && prev(byte(0x097BA0)) == 0x00 && byte(0x097BA0) == 0x01) ||
               (byte(0x097A18) == 0x22 && prev(byte(0x097BC2)) == 0x00 && byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x23 && prev(byte(0x097BA8)) == 0x00 && byte(0x097BA8) == 0x01) ||
               (byte(0x097A18) == 0x23 && byte(0x097BC2) == 0x01 && byte(0x097BC3) >= 0x32 &&
                prev(byte(0x097BC4)) == 0x00 && byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x25 && prev(byte(0x097BAC)) == 0x00 && byte(0x097BAC) == 0x01))
)

achievement(
    title = "It's In the Blood", points = 5,
    description = "Learn a tech from Errantry that requires your Monster's sub-breed to be a specific one.",
    id = 505578, badge = "572908", published = "3/15/2025 12:54:46 AM", modified = "3/15/2025 12:54:46 AM",
    trigger = byte(tbyte(0x078808) + 0x0000C3) == 0x01 &&
              ((byte(0x097A18) == 0x00 && byte(0x097A1C) == 0x01 && prev(byte(0x097BBC)) == 0x00 &&
                byte(0x097BBC) == 0x01) ||
               (byte(0x097A18) == 0x00 && byte(0x097A1C) == 0x10 && prev(byte(0x097BAE)) == 0x00 &&
                byte(0x097BAE) == 0x01) ||
               (byte(0x097A18) == 0x00 && byte(0x097A1C) == 0x1A && prev(byte(0x097BB0)) == 0x00 &&
                byte(0x097BB0) == 0x01) ||
               (byte(0x097A18) == 0x04 && byte(0x097A1C) == 0x05 && prev(byte(0x097BC8)) == 0x00 &&
                byte(0x097BC8) == 0x01) ||
               (byte(0x097A18) == 0x04 && byte(0x097A1C) == 0x07 && prev(byte(0x097BBC)) == 0x00 &&
                byte(0x097BBC) == 0x01) ||
               (byte(0x097A18) == 0x04 && byte(0x097A1C) == 0x20 && prev(byte(0x097BAC)) == 0x00 &&
                byte(0x097BAC) == 0x01) ||
               (byte(0x097A18) == 0x09 && (byte(0x097A1C) == 0x01 || byte(0x097A1C) == 0x0B || byte(0x097A1C) == 0x28) &&
                prev(byte(0x097BAE)) == 0x00 && byte(0x097BAE) == 0x01) ||
               (byte(0x097A18) == 0x09 && byte(0x097A1C) == 0x27 && prev(byte(0x097BB0)) == 0x00 &&
                byte(0x097BB0) == 0x01) ||
               (byte(0x097A18) == 0x09 && (byte(0x097A1C) == 0x00 || byte(0x097A1C) == 0x1A || byte(0x097A1C) == 0x26) &&
                prev(byte(0x097BC6)) == 0x00 && byte(0x097BC6) == 0x01) ||
               (byte(0x097A18) == 0x0A && byte(0x097A1C) == 0x05 && prev(byte(0x097BC8)) == 0x00 &&
                byte(0x097BC8) == 0x01) ||
               (byte(0x097A18) == 0x0A && byte(0x097A1C) == 0x07 && prev(byte(0x097BBC)) == 0x00 &&
                byte(0x097BBC) == 0x01) ||
               (byte(0x097A18) == 0x0A && byte(0x097A1C) == 0x09 && prev(byte(0x097BA4)) == 0x00 &&
                byte(0x097BA4) == 0x01) ||
               (byte(0x097A18) == 0x0A && byte(0x097A1C) == 0x1A && prev(byte(0x097BB0)) == 0x00 &&
                byte(0x097BB0) == 0x01) ||
               (byte(0x097A18) == 0x0C && byte(0x097A1C) == 0x00 && prev(byte(0x097BC2)) == 0x00 &&
                byte(0x097BC2) == 0x01) ||
               (byte(0x097A18) == 0x0C && byte(0x097A1C) == 0x00 && prev(byte(0x097BC4)) == 0x00 &&
                byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x0C && byte(0x097A1C) == 0x10 && prev(byte(0x097BB4)) == 0x00 &&
                byte(0x097BB4) == 0x01) ||
               (byte(0x097A18) == 0x10 && byte(0x097A1C) == 0x0B && prev(byte(0x097BC8)) == 0x00 &&
                byte(0x097BC8) == 0x01) ||
               (byte(0x097A18) == 0x10 && byte(0x097A1C) == 0x17 && prev(byte(0x097BA2)) == 0x00 &&
                byte(0x097BA2) == 0x01) ||
               (byte(0x097A18) == 0x10 && byte(0x097A1C) == 0x19 && prev(byte(0x097BA4)) == 0x00 &&
                byte(0x097BA4) == 0x01) ||
               (byte(0x097A18) == 0x19 && byte(0x097A1C) == 0x01 && prev(byte(0x097BC4)) == 0x00 &&
                byte(0x097BC4) == 0x01) ||
               (byte(0x097A18) == 0x06 && byte(0x097A1C) == 0x01 && prev(byte(0x097BB0)) == 0x00 &&
                byte(0x097BB0) == 0x01))
)

achievement(
    title = "Goddess of Water (unofficial debug)", points = 5,
    description = "Use the Slate found on your Ranch in Combination to unlock the Undine.",
    id = 507327, badge = "565954", published = "3/24/2025 5:27:06 AM", modified = "3/24/2025 5:43:14 AM",
    trigger = byte(0x097B78) == 0xFF && byte(0x097A18) == 0x1D && byte(0x097A1C) == 0x1D &&
              (dword(0x098FBC) + 0x1F4 - prior(dword(0x098FBC))) == 0x00 && prev(byte(0x0993A3)) == 0x00 &&
              byte(0x0993A3) == 0x01
)

leaderboard(
    id = 127058, title = "Lowest Total Stats - Official E Tournament",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Official E Tournament and having your Monster rank up.",
    start  = byte(0x099235) == 0x04 &&
             (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
             prev(byte(0x09961C)) != 0x48 && byte(0x09961C) == 0x48,
    cancel = (byte(0x099235) != 0x04 || byte(0x097B78) == 0xFF),
    submit = byte(0x1FFC00) == 0x00 && prev(byte(0x097B92)) == 0x00 && byte(0x097B92) == 0x01,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127059, title = "Lowest Total Stats - Official D Tournament",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Official D Tournament and having your Monster rank up.",
    start  = byte(0x099235) == 0x04 &&
             (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
             prev(byte(0x09961C)) != 0x47 && byte(0x09961C) == 0x47,
    cancel = (byte(0x099235) != 0x04 || byte(0x097B78) == 0xFF),
    submit = byte(0x1FFC00) == 0x00 && (prev(byte(0x097B92)) == 0x00 || prev(byte(0x097B92)) == 0x01) &&
             byte(0x097B92) == 0x02,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127060, title = "Lowest Total Stats - Official C Tournament",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Official C Tournament and having your Monster rank up.",
    start  = byte(0x099235) == 0x04 &&
             (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
             prev(byte(0x09961C)) != 0x46 && byte(0x09961C) == 0x46,
    cancel = (byte(0x099235) != 0x04 || byte(0x097B78) == 0xFF),
    submit = byte(0x1FFC00) == 0x00 && (prev(byte(0x097B92)) == 0x01 || prev(byte(0x097B92)) == 0x02) &&
             byte(0x097B92) == 0x03,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127061, title = "Lowest Total Stats - Official B Tournament",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Official B Tournament and having your Monster rank up.",
    start  = byte(0x099235) == 0x04 &&
             (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
             prev(byte(0x09961C)) != 0x45 && byte(0x09961C) == 0x45,
    cancel = (byte(0x099235) != 0x04 || byte(0x097B78) == 0xFF),
    submit = byte(0x1FFC00) == 0x00 && (prev(byte(0x097B92)) == 0x02 || prev(byte(0x097B92)) == 0x03) &&
             byte(0x097B92) == 0x04,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127062, title = "Lowest Total Stats - Official A Tournament",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Official A Tournament and having your Monster rank up.",
    start  = byte(0x099235) == 0x04 &&
             (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
             prev(byte(0x09961C)) != 0x44 && byte(0x09961C) == 0x44,
    cancel = (byte(0x099235) != 0x04 || byte(0x097B78) == 0xFF),
    submit = byte(0x1FFC00) == 0x00 && (prev(byte(0x097B92)) == 0x03 || prev(byte(0x097B92)) == 0x04) &&
             byte(0x097B92) == 0x05,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127063, title = "Lowest Total Stats - Official S Tournament",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Official S Tournament and becoming Major 4 eligible.",
    start  = byte(0x097A94) == 0x00 && byte(0x099235) == 0x04 &&
             (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
             prev(byte(0x09961C)) != 0x43 && byte(0x09961C) == 0x43,
    cancel = (byte(0x099235) != 0x04 || byte(0x097B78) == 0xFF),
    submit = prev(byte(0x097A94)) == 0x00 && byte(0x097A94) == 0x01,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127064, title = "Lowest Total Stats - Greatest 4",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Greatest 4 Tournament.",
    start  = byte(0x097A84) == 0x00 && byte(0x097A94) == 0x01 && byte(0x099235) == 0x02 && byte(0x099236) == 0x02 &&
             prev(byte(0x09961C)) != 0x0D && byte(0x09961C) == 0x0D,
    cancel = (byte(0x099235) != 0x02 || byte(0x097B78) == 0xFF),
    submit = prev(byte(0x097A84)) == 0x00 && byte(0x097A84) == 0x01,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127065, title = "Lowest Total Stats - World Monsters Cup",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the World Monsters Cup.",
    start  = byte(0x097A88) == 0x00 && byte(0x097A94) == 0x01 && byte(0x099235) == 0x02 && byte(0x099236) == 0x0B &&
             prev(byte(0x09961C)) != 0x0C && byte(0x09961C) == 0x0C,
    cancel = (byte(0x099235) != 0x02 || byte(0x097B78) == 0xFF),
    submit = prev(byte(0x097A88)) == 0x00 && byte(0x097A88) == 0x01,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127066, title = "Lowest Total Stats - M-1 Grand Prix",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the M-1 Grand Prix.",
    start  = byte(0x097A80) == 0x00 && byte(0x097A94) == 0x01 && byte(0x099235) == 0x02 && byte(0x099236) == 0x05 &&
             prev(byte(0x09961C)) != 0x0A && byte(0x09961C) == 0x0A,
    cancel = (byte(0x099235) != 0x02 || byte(0x097B78) == 0xFF),
    submit = prev(byte(0x097A80)) == 0x00 && byte(0x097A80) == 0x01,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127067, title = "Lowest Total Stats - Winners Cup",
    description = "Sum of LIF, POW, DEF, SKI, SPD, INT on winning the Winners Cup.",
    start  = byte(0x097A8C) == 0x00 && byte(0x097A94) == 0x01 && byte(0x099235) == 0x02 && byte(0x099236) == 0x08 &&
             prev(byte(0x09961C)) != 0x0B && byte(0x09961C) == 0x0B,
    cancel = (byte(0x099235) != 0x02 || byte(0x097B78) == 0xFF),
    submit = prev(byte(0x097A8C)) == 0x00 && byte(0x097A8C) == 0x01,
    value  = measured((word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A))),
    format = "VALUE", lower_is_better = true
)

leaderboard(
    id = 127068, title = "Snowball / Mud Ball Fight High Score",
    description = "Number of times you hit your Monster with a ball during Snowball or Mud Ball Fight.",
    start  = byte(tbyte(0x093520)) == 0x19 && word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000E8) == 0x708 &&
             once(word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA) == 0x02) &&
             once(word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA) == 0x05) &&
             prev(word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA)) > 0x00 &&
             word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000EA) == 0x00 &&
             word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000AC) == 0x00 &&
             word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000C8) == 0x00 &&
             never(prev(dword(0x099228)) < dword(0x099228)),
    cancel = (prev(dword(0x099228)) < dword(0x099228) || byte(0x097B78) == 0xFF),
    submit = prev(dword(0x099228)) == dword(0x099228) && prev(word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000E8)) > 0x00 &&
             word(tbyte(tbyte(0x093520) + 0x000010) + 0x0000E8) == 0x00,
    value  = measured(byte(tbyte(tbyte(0x093520) + 0x000010) + 0x0000AC)),
    format = "VALUE"
)

rich_presence_conditional_display(byte(0x097A18) == 0x2E && byte(0x098FAA) == 0xFF, "Learning about the origin of Disc Stones")

rich_presence_conditional_display(byte(0x097A18) < 0x2E && byte(0x098FAA) == 0xFF, "Watching a Demo Battle between {0} {1} and {2} {3}",
    rich_presence_lookup("MonsterPrefix", byte(0x097A18), MonsterPrefixLookup, fallback="a"),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterPrefix", byte(0x097BE4), MonsterPrefixLookup, fallback="a"),
    rich_presence_lookup("MonsterBreed", byte(0x097BE4), MonsterBreedLookup, fallback="Unmapped")
)

rich_presence_conditional_display((byte(0x097A18) > 0x2E || byte(0x097A1C) > 0x2E || word(0x099230) == 0x00), "Starting Monster Rancher 2")

rich_presence_conditional_display(byte(0x098FAA) != 0xFF && word(0x099230) < 0x44C && dword(0x098FBC) > 0x895440, "[wk. {0} {1}, {2}] Checking out Monster Rancher 2 using a friend's save with 💰 {3}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x097A18) == 0x2E && byte(0x098FAA) != 0xFF, "[wk. {0} {1}, {2}] Thinking about what Monster to raise next",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230))
)

rich_presence_conditional_display(byte(0x097BE4) == 0x02 && byte(0x097BE8) == 0x02 && byte(0x09935A) == 0xFF, "[wk. {0} {1}, {2}] Defending the Ranch from an invading Monster",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x06 && byte(0x09961C) == 0x00 && word(0x097A14) < 0x18, "[wk. {0} {1}, {2}] Participating in Freshmen's Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x06 && byte(0x09961C) == 0x01, "[wk. {0} {1}, {2}] Participating in Elders Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 && byte(0x099236) == 0x0A && byte(0x09961C) == 0x03, " [wk. {0} {1}, {2}] Participating in Heroes Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 && byte(0x099236) == 0x0A && byte(0x09961C) == 0x04, " [wk. {0} {1}, {2}] Participating in Heels Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 && byte(0x099236) == 0x01 && byte(0x09961C) == 0x05, "[wk. {0} {1}, {2}] Participating in New Year Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x0A, "[wk. {0} {1}, {2}] Participating in M-1 Grand Prix with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x08 && byte(0x09961C) == 0x0B, "[wk. {0} {1}, {2}] Participating in Winners Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x0B && byte(0x09961C) == 0x0C, "[wk. {0} {1}, {2}] Participating in World Monsters Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x02 && byte(0x09961C) == 0x0D, "[wk. {0} {1}, {2}] Participating in Greatest 4 with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x04 && byte(0x09961C) == 0x10, "[wk. {0} {1}, {2}] Participating in Phoenix Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x11, "[wk. {0} {1}, {2}] Participating in Taurus Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x01 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x13, "[wk. {0} {1}, {2}] Participating in IMa Chairman Cup (SPRING) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x01 && byte(0x099236) == 0x09 && byte(0x09961C) == 0x14, "[wk. {0} {1}, {2}] Participating in Telomeann Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x02 && byte(0x09961C) == 0x16 && byte(0x097B92) == 0x04, "[wk. {0} {1}, {2}] Fighting for a Double-edged with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 && byte(0x099236) == 0x04 && byte(0x09961C) == 0x19, "[wk. {0} {1}, {2}] Participating in Spring Carnival (B) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x07 && byte(0x09961C) == 0x1B, "[wk. {0} {1}, {2}] Participating in Papas Cup (SUMMER) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x08 && byte(0x09961C) == 0x1C && byte(0x097B92) == 0x03, "[wk. {0} {1}, {2}] Fighting for a Dragon Tusk with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x08 && byte(0x09961C) == 0x1D, "[wk. {0} {1}, {2}] Participating in Summer Carnival with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x09 && byte(0x09961C) == 0x1E, "[wk. {0} {1}, {2}] Participating in Manseitan Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x01 && byte(0x09961C) == 0x22, "[wk. {0} {1}, {2}] Participating in Sirius Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x02 && byte(0x09961C) == 0x23, "[wk. {0} {1}, {2}] Participating in Poannka Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x04 && byte(0x09961C) == 0x26, "[wk. {0} {1}, {2}] Participating in Spring Carnival (C) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x07 && byte(0x09961C) == 0x28, "[wk. {0} {1}, {2}] Participating in Crab Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x01 && byte(0x099236) == 0x08 && byte(0x09961C) == 0x29, "[wk. {0} {1}, {2}] Participating in Torble Sea Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x2A, "[wk. {0} {1}, {2}] Participating in Colart Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x01 && byte(0x09961C) == 0x2D, "[wk. {0} {1}, {2}] Participating in Torble Univ. Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x02 && byte(0x09961C) == 0x2E, "[wk. {0} {1}, {2}] Participating in Kawrea Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x03 && byte(0x09961C) == 0x2F, "[wk. {0} {1}, {2}] Participating in Troron Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x04 && byte(0x09961C) == 0x32, "[wk. {0} {1}, {2}] Participating in Spring Carnival (D) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x34, "[wk. {0} {1}, {2}] Participating in Gemini Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x07 && byte(0x09961C) == 0x35, "[wk. {0} {1}, {2}] Participating in Nageel Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x08 && byte(0x09961C) == 0x36, "[wk. {0} {1}, {2}] Participating in Desert Moon Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x02 && byte(0x09961C) == 0x39, "[wk. {0} {1}, {2}] Participating in Torles Tourney with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x03 && byte(0x09961C) == 0x3A, "[wk. {0} {1}, {2}] Participating in Parepare Cup (Spring) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x05 && byte(0x09961C) == 0x3D, "[wk. {0} {1}, {2}] Participating in Blue Sky Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x08 && byte(0x09961C) == 0x3E, "[wk. {0} {1}, {2}] Participating in Monster Pups Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x02 && byte(0x099236) == 0x09 && byte(0x09961C) == 0x3F, "[wk. {0} {1}, {2}] Participating in Artemis Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x03 && byte(0x099236) == 0x02 && byte(0x09961C) == 0x42, "[wk. {0} {1}, {2}] Participating in Blizzard Cup with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 &&
    (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
    byte(0x09961C) == 0x43, "[wk. {0} {1}, {2}] Participating in IMa Official Cup (S) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 &&
    (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
    byte(0x09961C) == 0x44, "[wk. {0} {1}, {2}] Participating in IMa Official Cup (A) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 &&
    (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
    byte(0x09961C) == 0x45, "[wk. {0} {1}, {2}] Participating in IMa Official Cup (B) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 &&
    (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
    byte(0x09961C) == 0x46, "[wk. {0} {1}, {2}] Participating in IMa Official Cup (C) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 &&
    (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
    byte(0x09961C) == 0x47, "[wk. {0} {1}, {2}] Participating in IMa Official Cup (D) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 &&
    (byte(0x099236) == 0x03 || byte(0x099236) == 0x06 || byte(0x099236) == 0x09 || byte(0x099236) == 0x0C) &&
    byte(0x09961C) == 0x48, "[wk. {0} {1}, {2}] Participating in IMa Official Cup (E) with {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 && byte(0x099236) == 0x08 && byte(0x09961C) == 0x49, "[wk. {0} {1}, {2}] Captaining the IMa team with a {3}-Rank {4} / {5} vs. FIMBA | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_conditional_display(byte(0x099235) == 0x04 && byte(0x099236) == 0x08 && byte(0x09961C) >= 0x4A && byte(0x09961C) <= 0x4D, "[wk. {0} {1}, {2}] Representing IMa with a {3}-Rank {4} / {5} vs. FIMBA | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)

rich_presence_display("[wk. {0} {1}, {2}] Raising {3}-Rank {4} / {5} | Total Stats = {6} | 💰 {7}",
    rich_presence_value("Number", byte(0x099235)),
    rich_presence_lookup("Month", byte(0x099236), MonthLookup),
    rich_presence_value("Number", word(0x099230)),
    rich_presence_lookup("Grade", byte(0x097B92), GradeLookup),
    rich_presence_lookup("MonsterBreed", byte(0x097A18), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_lookup("MonsterBreed", byte(0x097A1C), MonsterBreedLookup, fallback="Unmapped"),
    rich_presence_value("Number", word(0x097A20) + word(0x097A22) + word(0x097A24) + word(0x097A26) + word(0x097A28) + word(0x097A2A)),
    rich_presence_value("Number", dword(0x098FBC))
)
