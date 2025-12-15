// Monster Rancher | Monster Farm
// #ID = 16343

// NOTE: Generated script

// $0E892A: [Bitflags] Breeder Book
//          bit0=Entry 85 - Rocky
//          bit1=Entry 86 - Horn
//          bit2=Entry 87 - Pink Eye
//          bit3=Entry 88 - Fly Eye
//          bit4=Entry 82 - Stripe. Game sets this entry when obtaining via Shrine.
//          bit5=Entry 83 - Sam. Game sets this entry when obtaining via Shrine.
//          bit6=Jell but without a description
//          bit7 unused
function breeder_book_entry_82_stripe_game_sets_this_entry_when_obtaining_via_shrine() => bit4(0x0E892A)
function breeder_book_entry_83_sam_game_sets_this_entry_when_obtaining_via_shrine() => bit5(0x0E892A)

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
    0x10: "Oct",
    0x11: "Nov",
    0x12: "Dec",
}

TournamentNameLookup = {
    0x00: "Official Cup, Rank E",
    0x01: "Official Cup, Rank D",
    0x02: "Official Cup, Rank C",
    0x03: "Official Cup, Rank B",
    0x04: "Official Cup, Rank A",
    0x05: "Official Cup, Rank S",
    0x06: "Blossom Cup",
    0x07: "Spring E Cup",
    0x08: "New Leaf Cup",
    0x09: "Sun Cup",
    0x0a: "Summer E Cup",
    0x0b: "Cricket Cup",
    0x0c: "Maple Cup",
    0x0d: "Fall E Cup",
    0x0e: "X-mas Cup",
    0x0f: "Beginner Cup",
    0x10: "Winter E Cup",
    0x11: "Dandlion Cup",
    0x12: "Hartville Cup",
    0x13: "Spring D Cup",
    0x14: "VitaminC Cup",
    0x15: "Salem Cup",
    0x16: "Summer D Cup",
    0x17: "VitaminA Cup",
    0x18: "Alta Cup",
    0x19: "Fall D Cup",
    0x1a: "Barees Cup",
    0x1c: "Winter D Cup",
    0x1d: "Alta Cup",
    0x1b: "Salem Cup",
    0x1e: "Spring C Cup",
    0x1f: "VitaminB Cup",
    0x20: "Barees Cup",
    0x21: "Summer C Cup",
    0x22: "Hartville Cup",
    0x23: "Fall C Cup",
    0x24: "Fly Pill Cup",
    0x25: "Winter C Cup",
    0x26: "Trial Cup",
    0x27: "Spring B Cup",
    0x28: "Trial Cup",
    0x29: "Summer B Cup",
    0x2a: "Trial Cup",
    0x2b: "Fall B Cup",
    0x2c: "VitaminD Cup",
    0x2d: "Winter B Cup",
    0x2e: "Diamond Cup",
    0x2f: "Kings Cup",
    0x30: "Invitational for a Dragon Tusk",
    0x31: "Emerald Cup",
    0x32: "Gold Cup",
    0x33: "Pill Cup",
    0x34: "Queens Cup",
    0x35: "Invitational for a Doll Head",
    0x36: "Masters S Cup",
    0x37: "Monsters Cup",
    0x38: "Disk Cup",
    0x39: "All-Star Cup",
}

TournamentMonsterLookup = {
    1: "Barura",
    2: "Igunisu",
    3: "Michel",
    4: "Lambar",
    5: "Byoon",
    8: "Mopeto",
    10: "Ragar",
    12: "Guran",
    13: "Sem",
    14: "Jet",
    15: "Whirl",
    17: "Misha",
    18: "Abiwan",
    19: "Boran",
    21: "Makum",
    26: "Quarty",
    28: "Goregon",
    31: "Entau",
    33: "Yuno",
    36: "Brild",
    37: "Yutet",
    39: "Reno",
    42: "Suran",
    43: "Maccam",
    44: "Kwan",
    45: "Eza",
    46: "Sonmu",
    47: "Riston",
    52: "Amy",
    53: "Argu",
    54: "Garent",
    57: "Lana",
    58: "Ryusei",
    59: "Megiras",
    60: "Soro",
    61: "Gora",
    62: "Terrace",
    63: "Gardian",
    65: "Soketsu",
    66: "Baru",
    67: "Lightning",
    69: "Arngra",
    73: "Redondo",
    74: "Chuckle",
    75: "Maccam",
    76: "Caro",
    77: "Eza",
    78: "Sonmu",
    79: "Shing",
    92: "Gabarn",
    93: "Redondo",
    94: "Arbar",
    95: "Gureb",
}

MonsterPrimaryLookup = {
    0x00: "Dino",
    0x01: "Golem",
    0x02: "Tiger",
    0x03: "Pixie",
    0x04: "Worm",
    0x05: "Jell",
    0x06: "Suezo",
    0x07: "Hare",
    0x08: "Gali",
    0x09: "Monol",
    0x0a: "Naga",
    0x0b: "Plant",
    0x0c: "Dragon",
    0x0d: "Magic",
    0x0e: "Henger",
    0x0f: "Nya",
    0x10: "Ape",
    0x11: "Ghost",
    0x12: "Doodle",
    0x13: "Disk",
}

MonsterSecondaryLookup = {
    0x00: "Dino",
    0x01: "Golem",
    0x02: "Tiger",
    0x03: "Pixie",
    0x04: "Worm",
    0x05: "Jell",
    0x06: "Suezo",
    0x07: "Hare",
    0x08: "Gali",
    0x09: "Monol",
    0x0a: "Naga",
    0x0b: "Plant",
    0x0c: "Dragon",
    0x0d: "Magic",
    0x0e: "Henger",
    0x0f: "Nya",
    0x10: "Ape",
    0x11: "Ghost",
    0x12: "Doodle",
    0x13: "Disk",
    0x14: "???",
    0x15: "???",
    0x16: "???",
}

ZeroPadLookup = {
    0: "0",
    1: "0",
    2: "0",
    3: "0",
    4: "0",
    5: "0",
    6: "0",
    7: "0",
    8: "0",
    9: "0",
}

current_calendar_week = byte(0x0e6e48)
breeder_rank = byte(0x0e8544)
// 0x00 = E
// 0x01 = D
// 0x02 = C
// 0x03 = B
// 0x04 = A
// 0x05 = S
monster_rank = byte(0x0b8888)
// This is BCD. 
current_month = byte(0x0e6e4c)

current_tournament = byte(0x0e8b74)
tournament_prize_rank = byte(0x0f6ecc)
// This is really "monster 1 in tournament" but it's always you!
function player_in_tournament() => word(0x0f6efc) == 0x0100
tournament_phase = byte(0x0f6f48)

player_masters_s_cup_wins = byte(0x0e86aa)
player_monsters_cup_wins = byte(0x0e86ab)
player_disk_cup_wins = byte(0x0e86ac)
player_all_star_cup_wins = byte(0x0e86ad)

function big4_monster_flag(tournament_name) {
    if (tournament_name == "Masters S Cup") {
        return bit0(0x0b88a0)
    } else if (tournament_name == "Monsters Cup") {
        return bit1(0x0b88a0)
    } else if (tournament_name == "Disk Cup") {
        return bit2(0x0b88a0)
    } else if (tournament_name == "All-Star Cup") {
        return bit3(0x0b88a0)
    }
}

achievement(
    title = "Official E Win", points = 3, type="progression",
    description = "Win your first Official Tournament at Rank E and get to R-1 breeder rank.",
    id = 418990, badge = "496004", published = "4/19/2024 1:55:34 AM", modified = "9/2/2024 5:15:27 PM",
    trigger = current_calendar_week == 0x04 
        && breeder_rank == 0x00 
        && monster_rank == 0x00
        && current_tournament == 0x00
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
)

achievement(
    title = "Official D Win", points = 3, type="progression",
    description = "Win your first Official Tournament at Rank D and get to R-2 breeder rank.",
    id = 419006, badge = "496005", published = "4/19/2024 3:01:13 AM", modified = "9/2/2024 5:15:28 PM",
    trigger = current_calendar_week == 0x04 
        && breeder_rank == 0x01 
        && monster_rank == 0x01
        && current_tournament == 0x01
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
)

achievement(
    title = "Official C Win", points = 5, type="progression",
    description = "Win your first Official Tournament at Rank C and get to R-3 breeder rank.",
    id = 419307, badge = "496006", published = "4/20/2024 4:55:16 PM", modified = "9/2/2024 5:15:28 PM",
    trigger = current_calendar_week == 0x04 
        && breeder_rank == 0x02 
        && monster_rank == 0x02
        && current_tournament == 0x02
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
)

achievement(
    title = "Official B Win", points = 5, type="progression",
    description = "Win your first Official Tournament at Rank B and get to R-4 breeder rank.",
    id = 419308, badge = "496007", published = "4/20/2024 4:55:16 PM", modified = "9/2/2024 5:15:29 PM",
    trigger = current_calendar_week == 0x04 
        && breeder_rank == 0x03 
        && monster_rank == 0x03
        && current_tournament == 0x03
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
)

achievement(
    title = "Official A Win", points = 10, type="progression",
    description = "Win your first Official Tournament at Rank A and get to R-5 breeder rank.",
    id = 419309, badge = "496008", published = "4/20/2024 4:55:16 PM", modified = "9/2/2024 5:15:29 PM",
    trigger = current_calendar_week == 0x04 
        && breeder_rank == 0x04 
        && monster_rank == 0x04
        && current_tournament == 0x04
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
)

// needs to be tested
achievement(
    title = "We're Done, Right? ...Right?", points = 10, type="progression",
    description = "Win your first Official Tournament at Rank S and get to R-6 breeder rank.",
    id = 419310, badge = "496009", published = "4/20/2024 4:55:17 PM", modified = "9/2/2024 5:15:30 PM",
    trigger = current_calendar_week == 0x04 
        && breeder_rank == 0x05 
        && monster_rank == 0x05
        && current_tournament == 0x05
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
)

achievement(
    title = "All-Star Cup Champion", points = 10, type="progression",
    description = "Win the All-Star Cup for the first time.",
    id = 419311, badge = "495684", published = "4/20/2024 4:55:17 PM", modified = "9/2/2024 5:15:30 PM",
    trigger = byte(0x0F6F00) == 0x5F 
        && breeder_rank >= 0x06 
        && breeder_rank <= 0x0a
        && monster_rank == 0x05
        && current_tournament == 0x39
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
        && prev(big4_monster_flag("All-Star Cup")) == 0x00
        && big4_monster_flag("All-Star Cup") == 0x01
        && prev(player_all_star_cup_wins) == 0x00
        && player_all_star_cup_wins == 0x01
)

achievement(
    title = "Monsters Cup Champion", points = 10, type="progression",
    description = "Win the Monsters Cup for the first time.",
    id = 419312, badge = "495685", published = "4/20/2024 4:55:17 PM", modified = "9/2/2024 5:15:30 PM",
    trigger = byte(0x0F6F00) == 0x5D 
        && breeder_rank >= 0x06 
        && breeder_rank <= 0x0a
        && monster_rank == 0x05
        && current_tournament == 0x37
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
        && prev(big4_monster_flag("Monsters Cup")) == 0x00
        && big4_monster_flag("Monsters Cup") == 0x01
        && prev(player_monsters_cup_wins) == 0x00
        && player_monsters_cup_wins == 0x01
)

achievement(
    title = "Masters S Cup Champion", points = 10, type="progression",
    description = "Win the Masters S Cup for the first time.",
    id = 419313, badge = "495686", published = "4/20/2024 4:55:17 PM", modified = "9/2/2024 5:15:31 PM",
    trigger = byte(0x0F6F00) == 0x5C 
        && breeder_rank >= 0x06 
        && breeder_rank <= 0x0a
        && monster_rank == 0x05
        && current_tournament == 0x36
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
        && prev(big4_monster_flag("Masters S Cup")) == 0x00
        && big4_monster_flag("Masters S Cup") == 0x01
        && prev(player_masters_s_cup_wins) == 0x00
        && player_masters_s_cup_wins == 0x01
)

achievement(
    title = "Disk Cup Champion", points = 10, type="progression",
    description = "Win the Disk Cup for the first time.",
    id = 419314, badge = "495687", published = "4/20/2024 4:55:18 PM", modified = "9/2/2024 5:15:31 PM",
    trigger = byte(0x0F6F00) == 0x5E
        && breeder_rank >= 0x06 
        && breeder_rank <= 0x0a
        && monster_rank == 0x05
        && current_tournament == 0x38
        && player_in_tournament()
        && tournament_prize_rank == 0x00
        && prev(tournament_phase) == 0x02
        && tournament_phase == 0x03
        && prev(big4_monster_flag("Disk Cup")) == 0x00
        && big4_monster_flag("Disk Cup") == 0x01
        && prev(player_disk_cup_wins) == 0x00
        && player_disk_cup_wins == 0x01
)

achievement(
    title = "Master in FIMBA", points = 10, type="win_condition",
    description = "Achieve \"Master\" rank as a Breeder.",
    id = 419306, badge = "496003", published = "4/20/2024 4:55:16 PM", modified = "9/2/2024 5:15:32 PM",
    trigger = prev(byte(0x0E8544)) == 0x09 && byte(0x0E8544) == 0x0A && byte(0x0B8878) == 0xEE
)

achievement(
    title = "Going down in the Record Books", points = 25,
    description = "Have a single Monster earn all of the Big 4 championship badges.",
    id = 439060, badge = "495003", published = "6/16/2024 9:32:07 PM", modified = "9/2/2024 5:15:32 PM",
    trigger = (prev(bit0(0x0B88A0)) + prev(bit1(0x0B88A0)) + prev(bit2(0x0B88A0)) + prev(bit3(0x0B88A0))) == 0x03 &&
              (bit0(0x0B88A0) + bit1(0x0B88A0) + bit2(0x0B88A0) + bit3(0x0B88A0)) == 0x04
)

achievement(
    title = "Check out This New Monster", points = 1,
    description = "Generate a Monster at the Shrine by switching CDs from the Monster Rancher game to any CD of your choosing.",
    id = 425975, badge = "495718", published = "5/12/2024 1:02:33 AM", modified = "9/2/2024 5:15:33 PM",
    trigger = (prior(byte(0x0F5BE4)) == 0x04 && prev(byte(0x0F5BE4)) == 0x01) && prev(byte(0x0B8878)) == 0xEE &&
              once(byte(0x0EAFF6) != 0x08) && never(byte(0x0F5BE4) == 0x02) && never(byte(0x0F5BE4) == 0x03) &&
              never(byte(0x0F5BE4) > 0x04) && never(byte(0x0EAFE1) == 0x00)
)

achievement(
    title = "Happy Birthday!", points = 2,
    description = "Celebrate your Monster's first birthday at the Ranch.",
    id = 423857, badge = "495719", published = "5/6/2024 1:39:22 AM", modified = "9/2/2024 5:15:33 PM",
    trigger = once(byte(0x0B888C) == 0x02) && once(prev(byte(0x0B88C0)) == 0x2F) && once(word(0x0B88C0) == 0x30) &&
              once(byte(0x0E73A2) == 0x0B) && once(byte(0x0E73A4) == 0x60) && never(word(0x0F5BE4) <= 0x09) &&
              never(byte(0x0B88C0) > 0x30) && never(byte(0x0B88C0) == 0x2F)
)

achievement(
    title = "Putting That One on the Fridge", points = 3,
    description = "Receive mail from an adoring fan.",
    id = 426228, badge = "495720", published = "5/12/2024 7:16:40 PM", modified = "9/2/2024 5:15:34 PM",
    trigger = once(word(0x0B88C0) > prev(word(0x0B88C0))) && never(prior(word(0x0B88C0)) == 0x00) &&
              never(byte(0x0E8530) == 0xFF) && never(byte(0x0F5BE4) < 0x0A) &&
              ((once(once(prev(byte(0x0E75BF)) == 0xFF) && byte(0x0E75BF) == 0x00)) ||
               (once(once(prev(byte(0x0E75C0)) == 0xFF) && byte(0x0E75C0) == 0x00)) ||
               (once(once(prev(byte(0x0E75C1)) == 0xFF) && byte(0x0E75C1) == 0x00)) ||
               (once(once(prev(byte(0x0E758B)) == 0xFF) && byte(0x0E758B) == 0x00)))
)

achievement(
    title = "I'd Rather Not Relive That...", points = 3,
    description = "Have an enemy Monster forfeit the match.",
    id = 426229, badge = "495721", published = "5/12/2024 7:17:08 PM", modified = "9/2/2024 5:15:34 PM",
    trigger = once(word(0x0F6F0C) == 0x100) && once(prev(word(0x0F6F0E)) > 0x00) && once(byte(0x0F6F4C) == 0x10) &&
              once(prev(word(0x0F6F0C)) < 0x100) && never(byte(0x0F6F4C) == 0x0C) &&
              never(prior(byte(0x0F6F4C)) == 0x14) && never(byte(0x0F6F4C) == 0x06) &&
              ((once(prev(byte(0x0F6F55)) == 0xFF) && once(byte(0x0F6F55) == 0x01) && never(byte(0x0F6F55) == 0x00)) ||
               (once(prev(byte(0x0F6F56)) == 0xFF) && once(byte(0x0F6F56) == 0x01) && never(byte(0x0F6F56) == 0x00)) ||
               (once(prev(byte(0x0F6F57)) == 0xFF) && once(byte(0x0F6F57) == 0x01) && never(byte(0x0F6F57) == 0x00)) ||
               (once(prev(byte(0x0F6F58)) == 0xFF) && once(byte(0x0F6F58) == 0x01) && never(byte(0x0F6F58) == 0x00)) ||
               (once(prev(byte(0x0F6F59)) == 0xFF) && once(byte(0x0F6F59) == 0x01) && never(byte(0x0F6F59) == 0x00)) ||
               (once(prev(byte(0x0F6F5A)) == 0xFF) && once(byte(0x0F6F5A) == 0x01) && never(byte(0x0F6F5A) == 0x00)) ||
               (once(prev(byte(0x0F6F5B)) == 0xFF) && once(byte(0x0F6F5B) == 0x01) && never(byte(0x0F6F5B) == 0x00)))
)

achievement(
    title = "Full Sweep", points = 10,
    description = "In a Tournament with 8 Monsters (including yours), win all matches.",
    id = 420462, badge = "495722", published = "4/25/2024 4:43:33 AM", modified = "9/2/2024 5:15:34 PM",
    trigger = byte(0x0F6F55) == 0x01 && byte(0x0F6F56) == 0x01 && byte(0x0F6F57) == 0x01 && byte(0x0F6F58) == 0x01 &&
              byte(0x0F6F59) == 0x01 && byte(0x0F6F5A) == 0x01 && byte(0x0F6F5B) == 0x01 && prev(byte(0x0F6F48)) == 0x03
)

achievement(
    title = "One-Hit Wonder", points = 10,
    description = "Deal a single hit of damage that exceeds the enemy Monster's LIF total.",
    id = 425976, badge = "495723", published = "5/12/2024 1:17:34 AM", modified = "9/4/2024 3:33:36 PM",
    trigger = byte(0x0E8530) == 0xEE && word(0x0F6EFC) == 0x100 && word(0x1BAA94) >= word(0x0C5E96) &&
              word(0x1BAA94) == word(0x0C05C4) && word(0x0EB2E8) != 0xFFFF && prev(word(0x0DDE96)) > 0x01 &&
              word(0x0DDE96) == 0x00
)

achievement(
    title = "We're Better Together", points = 10,
    description = "Perform any Combination that results in one of LIF, POW, DEF, SKI, SPD, or INT being at or above 300.",
    id = 420779, badge = "495724", published = "4/25/2024 11:58:26 PM", modified = "9/2/2024 5:15:35 PM",
    trigger = prev(byte(0x0F5BE4)) == 0x03 && byte(0x0F5BE4) == 0x01 && byte(0x0F5B90) == 0x00 && word(0x0F5C00) >= 0x63 &&
              word(0x0F5C00) <= 0x65 && byte(0x0B8878) == 0xEE &&
              ((prev(word(0x0E7F9A)) >= 0x12C) ||
               (prev(word(0x0E7F9E)) >= 0x12C) ||
               (prev(word(0x0E7FA0)) >= 0x12C) ||
               (prev(word(0x0E7FA2)) >= 0x12C) ||
               (prev(word(0x0E7FA6)) >= 0x12C) ||
               (prev(word(0x0E7FA8)) >= 0x12C))
)

achievement(
    title = "Would You Love Me If I Wasn't A Worm?", points = 25,
    description = "Have a worm cocoon while on the ranch.",
    id = 421220, badge = "495725", published = "4/26/2024 5:07:01 PM", modified = "9/2/2024 5:15:36 PM",
    trigger = byte(0x0B8888) <= 0x02 && byte(0x0B888C) == 0x04 && byte(0x0E6E4C) == 0x06 && byte(0x0E6E48) == 0x04 &&
              byte(0x0F5BE4) > 0x09 && prev(byte(0x0B8890)) == 0x04 && byte(0x0B8894) == 0x04
)

achievement(
    title = "Training Complete", points = 10,
    description = "Get all techniques for a monster.",
    id = 420780, badge = "495726", published = "4/26/2024 12:09:45 AM", modified = "9/2/2024 5:15:36 PM",
    trigger = (prev(bit0(0x0B88A4)) + prev(bit1(0x0B88A4)) + prev(bit2(0x0B88A4)) + prev(bit3(0x0B88A4)) +
              prev(bit4(0x0B88A4)) + prev(bit5(0x0B88A4)) + prev(bit6(0x0B88A4)) + prev(bit7(0x0B88A4)) +
              prev(bit0(0x0B88A5)) + prev(bit1(0x0B88A5)) + prev(bit2(0x0B88A5)) + prev(bit3(0x0B88A5))) == 0x0B &&
              (bit0(0x0B88A4) + bit1(0x0B88A4) + bit2(0x0B88A4) + bit3(0x0B88A4) + bit4(0x0B88A4) + bit5(0x0B88A4) +
              bit6(0x0B88A4) + bit7(0x0B88A4) + bit0(0x0B88A5) + bit1(0x0B88A5) + bit2(0x0B88A5) + bit3(0x0B88A5)) == 0x0C
              
)

achievement(
    title = "A Bigger House", points = 5,
    description = "Upgrade your Breeder's House for the first time.",
    id = 420258, badge = "495727", published = "4/23/2024 6:18:17 AM", modified = "3/16/2025 6:01:26 AM",
    trigger = byte(0x0E6E48) == 0x01 && byte(0x0E6E4C) == 0x07 && prev(byte(0x0E85BC)) == 0x05 && byte(0x0E85BC) == 0x01
)

achievement(
    title = "A Bigger Stable", points = 5,
    description = "Upgrade your Monster's Stable for the first time.",
    id = 420259, badge = "495728", published = "4/23/2024 6:18:17 AM", modified = "3/16/2025 6:01:27 AM",
    trigger = byte(0x0E6E48) == 0x01 && byte(0x0E6E4C) == 0x07 && prev(byte(0x0E85BD)) == 0x05 && byte(0x0E85BD) == 0x01
)

achievement(
    title = "Renovations Complete", points = 10,
    description = "Upgrade your Rancher house to its maximum level.",
    id = 420827, badge = "495729", published = "4/26/2024 4:22:08 AM", modified = "3/16/2025 6:01:27 AM",
    trigger = byte(0x0E6E48) == 0x01 && byte(0x0E6E4C) == 0x07 && prev(byte(0x0E85BC)) == 0x05 &&
              measured(byte(0x0E85BC) == 0x04)
)

achievement(
    title = "Fully Stabilized", points = 10,
    description = "Upgrade your Monster's stable to its maximum level.",
    id = 420828, badge = "495730", published = "4/26/2024 4:22:09 AM", modified = "3/16/2025 6:01:27 AM",
    trigger = byte(0x0E6E48) == 0x01 && byte(0x0E6E4C) == 0x07 && prev(byte(0x0E85BD)) == 0x05 && byte(0x0E85BD) == 0x02
)

achievement(
    title = "The Next Knick Killer", points = 10,
    description = "Get a Dino, Magic, or Doodle to Rank S.",
    id = 420840, badge = "495731", published = "4/26/2024 6:23:45 AM", modified = "9/2/2024 5:15:39 PM",
    trigger = prev(byte(0x0B8888)) == 0x04 && byte(0x0B8888) == 0x05 &&
              ((byte(0x0B8890) == 0x00) ||
               (byte(0x0B8890) == 0x0D) ||
               (byte(0x0B8890) == 0x12))
)

achievement(
    title = "Healthy Lifestyle", points = 10,
    description = "Get a Worm, Plant, or Ape to Rank S.",
    id = 420841, badge = "495732", published = "4/26/2024 6:23:46 AM", modified = "9/2/2024 5:15:40 PM",
    trigger = prev(byte(0x0B8888)) == 0x04 && byte(0x0B8888) == 0x05 &&
              ((byte(0x0B8890) == 0x04) ||
               (byte(0x0B8890) == 0x0B) ||
               (byte(0x0B8890) == 0x10))
)

achievement(
    title = "Power Overwhelming", points = 10,
    description = "Get a Golem, Hare, Naga, or Dragon to Rank S.",
    id = 420842, badge = "495733", published = "4/26/2024 6:23:46 AM", modified = "9/2/2024 5:15:40 PM",
    trigger = prev(byte(0x0B8888)) == 0x04 && byte(0x0B8888) == 0x05 &&
              ((byte(0x0B8890) == 0x01) ||
               (byte(0x0B8890) == 0x07) ||
               (byte(0x0B8890) == 0x0A) ||
               (byte(0x0B8890) == 0x0C))
)

achievement(
    title = "Built like a Tank", points = 10,
    description = "Get a Jell, Monol, or Disk to Rank S.",
    id = 420843, badge = "495708", published = "4/26/2024 6:23:46 AM", modified = "9/2/2024 5:15:40 PM",
    trigger = prev(byte(0x0B8888)) == 0x04 && byte(0x0B8888) == 0x05 &&
              ((byte(0x0B8890) == 0x05) ||
               (byte(0x0B8890) == 0x09) ||
               (byte(0x0B8890) == 0x13))
)

achievement(
    title = "Mach 1", points = 10,
    description = "Get a Tiger, Henger, Nya, or Ghost to Rank S.",
    id = 420844, badge = "495709", published = "4/26/2024 6:23:46 AM", modified = "9/2/2024 5:15:41 PM",
    trigger = prev(byte(0x0B8888)) == 0x04 && byte(0x0B8888) == 0x05 &&
              ((byte(0x0B8890) == 0x02) ||
               (byte(0x0B8890) == 0x0E) ||
               (byte(0x0B8890) == 0x0F) ||
               (byte(0x0B8890) == 0x11))
)

achievement(
    title = "Outsmarted", points = 10,
    description = "Get a Pixie, Suezo, or Gali to Rank S.",
    id = 420845, badge = "495710", published = "4/26/2024 6:23:47 AM", modified = "9/2/2024 5:15:41 PM",
    trigger = prev(byte(0x0B8888)) == 0x04 && byte(0x0B8888) == 0x05 &&
              ((byte(0x0B8890) == 0x03) ||
               (byte(0x0B8890) == 0x06) ||
               (byte(0x0B8890) == 0x08))
)

achievement(
    title = "Your First Exploration", points = 5,
    description = "Begin your first expedition.",
    id = 420839, badge = "495711", published = "4/26/2024 6:11:16 AM", modified = "9/2/2024 5:15:42 PM",
    trigger = byte(0x0E6E4C) == 0x01 && byte(0x0E6E48) == 0x02 && prior(byte(0x0E75B9)) == 0xFF &&
              word(0x195D18) == 0x00 && prev(byte(0x195D5E)) == 0x00 && byte(0x195D5E) > 0x00
)

achievement(
    title = "The Magic Mirror", points = 5,
    description = "Find a Magic Mirror during an expedition to Titus Temple.",
    id = 426924, badge = "495712", published = "5/14/2024 1:42:11 PM", modified = "9/2/2024 5:15:42 PM",
    trigger = byte(0x0E6E4C) == 0x01 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(word(0x195D18)) != 0x30 && word(0x195D18) == 0x30
)

achievement(
    title = "Gold Cup Champion", points = 10,
    description = "Be invited to the A-Rank Gold Cup Tournament, held on wk. 4 of November, and win against Soro.",
    id = 426923, badge = "495713", published = "5/14/2024 1:38:17 PM", modified = "9/2/2024 5:15:43 PM",
    trigger = byte(0x0F6F0E) == 0x3C && prev(byte(0x0F6F55)) == 0xFF && byte(0x0F6F55) == 0x01
)

achievement(
    title = "Come on and Slam!", points = 10,
    description = "Use an Old Mirror in Combination to create a Magic.",
    id = 420646, badge = "495714", published = "4/25/2024 5:01:41 PM", modified = "9/2/2024 5:15:43 PM",
    trigger = byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00 && byte(0x0F5C00) == 0x65 && byte(0x0F56F4) == 0x30 &&
              prev(byte(0x0E7FB0)) != 0x0D && byte(0x0E7FB0) == 0x0D
)

achievement(
    title = "Trial of the Ape", points = 10,
    description = "Defeat Sonmu in the Trial Cup on wk.4 of October.",
    id = 426981, badge = "495715", published = "5/14/2024 6:41:58 PM", modified = "9/2/2024 5:15:44 PM",
    trigger = byte(0x0F6F00) == 0x4E && prev(byte(0x0F6F56)) == 0xFF && byte(0x0F6F56) == 0x01
)

achievement(
    title = "Conquering the Ape", points = 10,
    description = "Using a Monster whose sum of LIF, POW, DEF, SKI, SPD, and INT do not exceed 1700, defeat Sonmu in the Trial Cup on wk.4 of October.",
    id = 426982, badge = "495716", published = "5/14/2024 6:41:58 PM", modified = "9/2/2024 5:15:44 PM",
    trigger = (word(0x0E7F9A) + word(0x0E7F9E) + word(0x0E7FA0) + word(0x0E7FA2) + word(0x0E7FA6) + word(0x0E7FA8)) <= 0x6A4 &&
              byte(0x0F6F00) == 0x4E && word(0x0F6F0E) == 0x4E && prev(byte(0x0F6F56)) == 0xFF &&
              trigger_when(byte(0x0F6F56) == 0x01)
)

achievement(
    title = "Potassium Is Magic", points = 5,
    description = "Find a Magic Banana during an Expedition to Hartville Ruins.",
    id = 426926, badge = "495717", published = "5/14/2024 1:48:07 PM", modified = "9/2/2024 5:15:45 PM",
    trigger = byte(0x0E6E4C) == 0x07 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(word(0x195D18)) != 0x38 && word(0x195D18) == 0x38
)

achievement(
    title = "Spoiled beyond Belief", points = 10,
    description = "Use a Magic Banana in Combination to create an Ape.",
    id = 420781, badge = "495688", published = "4/26/2024 12:29:04 AM", modified = "9/2/2024 5:15:45 PM",
    trigger = byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00 && byte(0x0F56F4) == 0x38 && byte(0x0F5C00) >= 0x63 &&
              byte(0x0F5C00) <= 0x65 && prev(byte(0x0E7FB0)) != 0x10 && byte(0x0E7FB0) == 0x10
)

achievement(
    title = "Trial of the Dragon", points = 10,
    description = "Defeat Maccam in the Trial Cup on wk.4 of April.",
    id = 426989, badge = "495689", published = "5/14/2024 7:10:03 PM", modified = "9/2/2024 5:15:46 PM",
    trigger = byte(0x0F6F00) == 0x4B && prev(byte(0x0F6F56)) == 0xFF && byte(0x0F6F56) == 0x01
)

achievement(
    title = "Conquering the Dragon", points = 10,
    description = "Using a Monster whose sum of LIF, POW, DEF, SKI, SPD, and INT do not exceed 2100, defeat Maccam in the Trial Cup on wk.4 of April.",
    id = 426990, badge = "495690", published = "5/14/2024 7:11:02 PM", modified = "9/2/2024 5:15:46 PM",
    trigger = (word(0x0E7F9A) + word(0x0E7F9E) + word(0x0E7FA0) + word(0x0E7FA2) + word(0x0E7FA6) + word(0x0E7FA8)) <= 0x834 &&
              byte(0x0F6F00) == 0x4B && word(0x0F6F0E) == 0x4B && prev(byte(0x0F6F56)) == 0xFF &&
              trigger_when(byte(0x0F6F56) == 0x01)
)

achievement(
    title = "Dragon Tusk Invitational Champion", points = 10,
    description = "Be invited to the A-Rank Invitational, held on wk.4 of August, and win against Megiras.",
    id = 426927, badge = "495691", published = "5/14/2024 1:57:53 PM", modified = "9/2/2024 5:15:47 PM",
    trigger = byte(0x0F6F0E) == 0x3B && prev(byte(0x0F6F55)) == 0xFF && byte(0x0F6F55) == 0x01
)

achievement(
    title = "How to Combine Your Dragon", points = 5,
    description = "Use a Dragon Tusk in Combination to create a Dragon.",
    id = 420837, badge = "495692", published = "4/26/2024 5:43:38 AM", modified = "9/2/2024 5:15:47 PM",
    trigger = byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00 && byte(0x0F56F4) == 0x2F && byte(0x0F5C00) >= 0x63 &&
              byte(0x0F5C00) <= 0x65 && prev(byte(0x0E7FB0)) != 0x0C && byte(0x0E7FB0) == 0x0C
)

achievement(
    title = "We're All Trying to Find the Guy Who Did This", points = 10,
    description = "Unlock the \"Scribble\" Monster.",
    id = 420664, badge = "495693", published = "4/25/2024 5:44:51 PM", modified = "9/2/2024 5:15:47 PM",
    trigger = byte(0x0E7FB0) == 0x09 && prev(byte(0x0E7FB2)) == 0x09 && byte(0x0E7FB2) == 0x16 &&
              prev(byte(0x0F5BE4)) != 0x03
)

achievement(
    title = "I Made This!", points = 5,
    description = "Use the \"Scribble\" Monster in a Combination to create a Doodle.",
    id = 420778, badge = "495694", published = "4/25/2024 11:43:11 PM", modified = "9/2/2024 5:15:48 PM",
    trigger = byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00 && prior(byte(0x0F5C00)) == 0x61 &&
              prev(byte(0x0E7FB0)) == 0x12 && byte(0x0F5C00) >= 0x63 && byte(0x0F5C00) <= 0x65 &&
              ((prior(byte(byte(0x0F56F0) * 0x184 + 0x0E1010)) == 0x09 &&
                prior(byte(byte(0x0F56F0) * 0x184 + 0x0E1012)) == 0x16) ||
               (prior(byte(byte(0x0F56F2) * 0x184 + 0x0E1010)) == 0x09 &&
                prior(byte(byte(0x0F56F2) * 0x184 + 0x0E1012)) == 0x16))
)

achievement(
    title = "Left Arm of the Robotic One", points = 3,
    description = "Find a Doll Hand L during an expedition to Reno Ruins.",
    id = 426930, badge = "495695", published = "5/14/2024 2:23:05 PM", modified = "9/2/2024 5:15:48 PM",
    trigger = byte(0x0E6E4C) == 0x10 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(word(0x195D18)) != 0x34 && word(0x195D18) == 0x34
)

achievement(
    title = "Right Arm of the Robotic One", points = 3,
    description = "Find a Doll Hand R during an expedition to Reno Ruins.",
    id = 426931, badge = "495696", published = "5/14/2024 2:23:05 PM", modified = "9/2/2024 5:15:49 PM",
    trigger = byte(0x0E6E4C) == 0x10 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(word(0x195D18)) != 0x35 && word(0x195D18) == 0x35
)

achievement(
    title = "Left Leg of the Robotic One", points = 3,
    description = "Find a Doll Leg L during an expedition to Reno Ruins.",
    id = 426932, badge = "495697", published = "5/14/2024 2:23:06 PM", modified = "9/2/2024 5:15:49 PM",
    trigger = byte(0x0E6E4C) == 0x10 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(word(0x195D18)) != 0x36 && word(0x195D18) == 0x36
)

achievement(
    title = "Right Leg of the Robotic One", points = 3,
    description = "Find a Doll Leg R during an expedition to Reno Ruins.",
    id = 426933, badge = "495698", published = "5/14/2024 2:23:06 PM", modified = "9/2/2024 5:15:50 PM",
    trigger = byte(0x0E6E4C) == 0x10 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(word(0x195D18)) != 0x37 && word(0x195D18) == 0x37
)

achievement(
    title = "Obliterate Gora", points = 10,
    description = "Be invited to the Henger Invitational, held on wk.4 of February, and win against Gora.",
    id = 426929, badge = "495699", published = "5/14/2024 2:23:05 PM", modified = "9/2/2024 5:15:50 PM",
    trigger = byte(0x0F6F0E) == 0x3D && prev(byte(0x0F6F55)) == 0xFF && byte(0x0F6F55) == 0x01
)

achievement(
    title = "Henger, the Forbidden One", points = 10,
    description = "Use a Clay Doll in Combination to create a Henger.",
    id = 420829, badge = "495700", published = "4/26/2024 5:00:59 AM", modified = "9/2/2024 5:15:51 PM",
    trigger = byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00 && byte(0x0F56F4) == 0x32 && byte(0x0F5C00) >= 0x63 &&
              byte(0x0F5C00) <= 0x65 && prev(byte(0x0E7FB0)) != 0x0E && byte(0x0E7FB0) == 0x0E
)

achievement(
    title = "Secretly a Blessing", points = 25,
    description = "Use a cursed monster in Combination to create a Ghost.",
    id = 420823, badge = "495701", published = "4/26/2024 3:35:41 AM", modified = "9/25/2024 4:46:31 PM",
    trigger = byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00 && byte(0x0F5C00) >= 0x63 && byte(0x0F5C00) <= 0x65 &&
              prev(byte(0x0E7FB0)) != 0x11 && byte(0x0E7FB0) == 0x11 &&
              ((prior(byte(byte(0x0F56F0) * 0x184 + 0x0E0F6F)) < 0xFF &&
                prior(byte(byte(0x0F56F0) * 0x184 + 0x0E0F6F)) > 0x00) ||
               (prior(byte(byte(0x0F56F2) * 0x184 + 0x0E0F6F)) < 0xFF &&
                prior(byte(byte(0x0F56F2) * 0x184 + 0x0E0F6F)) > 0x00))
)

achievement(
    title = "Nyaow You've Done It", points = 50,
    description = "Use a Cat Doll in Combination to create a Nya.",
    id = 420691, badge = "495702", published = "4/25/2024 8:17:01 PM", modified = "9/2/2024 5:15:51 PM",
    trigger = byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00 && byte(0x0F56F4) == 0x31 && byte(0x0F5C00) >= 0x63 &&
              byte(0x0F5C00) <= 0x65 && prev(byte(0x0E7FB0)) != 0x0F && byte(0x0E7FB0) == 0x0F
)

achievement(
    title = "I'm Feline a New Trial", points = 10,
    description = "Defeat Eza in the Trial Cup on wk.4 of July.",
    id = 426991, badge = "495703", published = "5/14/2024 7:23:08 PM", modified = "9/2/2024 5:15:52 PM",
    trigger = byte(0x0F6F00) == 0x4D && prev(byte(0x0F6F56)) == 0xFF && byte(0x0F6F56) == 0x01
)

achievement(
    title = "Eza Game", points = 10,
    description = "Using a Monster whose sum of LIF, POW, DEF, SKI, SPD, and INT do not exceed 2000, defeat Eza in the Trial Cup on wk.4 of July.",
    id = 426992, badge = "495704", published = "5/14/2024 7:23:08 PM", modified = "9/2/2024 5:15:52 PM",
    trigger = (word(0x0E7F9A) + word(0x0E7F9E) + word(0x0E7FA0) + word(0x0E7FA2) + word(0x0E7FA6) + word(0x0E7FA8)) <= 0x7D0 &&
              byte(0x0F6F00) == 0x4D && word(0x0F6F0E) == 0x4D && prev(byte(0x0F6F56)) == 0xFF &&
              trigger_when(byte(0x0F6F56) == 0x01)
)

achievement(
    title = "An Egg From What Now?", points = 25,
    description = "Find a Plant Egg during an expedition to Hartville Ruins.",
    id = 421295, badge = "495705", published = "4/26/2024 7:53:36 PM", modified = "9/4/2024 3:33:37 PM",
    trigger = byte(0x0E6E4C) == 0x07 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(byte(0x0E75BD)) == 0xFF && byte(0x0B8888) >= 0x02 && byte(0x0E75B9) == 0x00 &&
              trigger_when(byte(0x0E75BD) == 0x00) && trigger_when(word(0x195D18) == 0x11)
)

achievement(
    title = "Life-Extending Fruit?!", points = 25,
    description = "Find a Golden Peach during an expedition to Reno Ruins.",
    id = 421294, badge = "495706", published = "4/26/2024 7:44:53 PM", modified = "9/4/2024 3:33:37 PM",
    trigger = byte(0x0E6E4C) == 0x10 && byte(0x0E6E48) == 0x02 && byte(0x195D5E) <= 0x8B && byte(0x195D5E) > 0x00 &&
              prev(byte(0x0E75BC)) == 0xFF && byte(0x0B8888) >= 0x02 && byte(0x0E75B9) == 0x00 &&
              trigger_when(byte(0x0E75BC) == 0x00) && trigger_when(word(0x195D18) == 0x10)
)

achievement(
    title = "Jurassic Park", points = 5,
    description = "Record every unique breed of Dino in your Book.",
    id = 419862, badge = "495983", published = "4/21/2024 11:03:29 PM", modified = "9/2/2024 5:15:54 PM",
    trigger = (prev(bit1(0x0E8914)) + prev(bit2(0x0E8914)) + prev(bit3(0x0E8914)) + prev(bit4(0x0E8914)) +
              prev(bit5(0x0E8914)) + prev(bit6(0x0E8914)) + prev(bit7(0x0E8914)) + prev(bit0(0x0E8915)) +
              prev(bit1(0x0E8915)) + prev(bit2(0x0E8915)) + prev(bit3(0x0E8915)) + prev(bit4(0x0E8916)) +
              prev(bit5(0x0E8916)) + prev(bit6(0x0E8916))) == 0x0D &&
              measured((bit1(0x0E8914) + bit2(0x0E8914) + bit3(0x0E8914) + bit4(0x0E8914) + bit5(0x0E8914) +
                  bit6(0x0E8914) + bit7(0x0E8914) + bit0(0x0E8915) + bit1(0x0E8915) + bit2(0x0E8915) + bit3(0x0E8915) +
                  bit4(0x0E8916) + bit5(0x0E8916) + bit6(0x0E8916)) == 0x0E
              )
)

achievement(
    title = "A Full Gali-lery", points = 5,
    description = "Record every unique breed of Gali in your Book.",
    id = 419896, badge = "495984", published = "4/22/2024 1:51:18 AM", modified = "9/8/2024 6:02:23 PM",
    trigger = (prev(bit0(0x0E8934)) + prev(bit1(0x0E8934)) + prev(bit2(0x0E8934)) + prev(bit3(0x0E8934)) +
              prev(bit4(0x0E8934)) + prev(bit5(0x0E8934)) + prev(bit6(0x0E8934)) + prev(bit7(0x0E8934)) +
              prev(bit0(0x0E8935)) + prev(bit1(0x0E8935)) + prev(bit2(0x0E8935)) + prev(bit3(0x0E8935)) +
              prev(bit4(0x0E8936)) + prev(bit5(0x0E8936)) + prev(bit6(0x0E8936))) == 0x0E &&
              measured((bit0(0x0E8934) + bit1(0x0E8934) + bit2(0x0E8934) + bit3(0x0E8934) + bit4(0x0E8934) +
                  bit5(0x0E8934) + bit6(0x0E8934) + bit7(0x0E8934) + bit0(0x0E8935) + bit1(0x0E8935) + bit2(0x0E8935) +
                  bit3(0x0E8935) + bit4(0x0E8936) + bit5(0x0E8936) + bit6(0x0E8936)) == 0x0F
              )
)

achievement(
    title = "No Stone Unturned", points = 5,
    description = "Record every unique breed of Golem in your Book.",
    id = 420375, badge = "495985", published = "4/24/2024 3:12:34 AM", modified = "9/7/2024 9:29:14 PM",
    trigger = (prev(bit0(0x0E8918)) + prev(bit1(0x0E8918)) + prev(bit2(0x0E8918)) + prev(bit3(0x0E8918)) +
              prev(bit4(0x0E8918)) + prev(bit5(0x0E8918)) + prev(bit6(0x0E8918)) + prev(bit7(0x0E8918)) +
              prev(bit0(0x0E8919)) + prev(bit1(0x0E8919)) + prev(bit2(0x0E8919)) + prev(bit3(0x0E8919)) +
              prev(bit4(0x0E891A))) == 0x0C &&
              measured((bit0(0x0E8918) + bit1(0x0E8918) + bit2(0x0E8918) + bit3(0x0E8918) + bit4(0x0E8918) +
                  bit5(0x0E8918) + bit6(0x0E8918) + bit7(0x0E8918) + bit0(0x0E8919) + bit1(0x0E8919) + bit2(0x0E8919) +
                  bit3(0x0E8919) + bit4(0x0E891A)) == 0x0D
              )
)

achievement(
    title = "Records of an Ambush", points = 5,
    description = "Record every unique breed of Tiger in your Book.",
    id = 420376, badge = "495986", published = "4/24/2024 3:58:49 AM", modified = "9/2/2024 5:15:55 PM",
    trigger = (prev(bit0(0x0E891C)) + prev(bit1(0x0E891C)) + prev(bit3(0x0E891C)) + prev(bit4(0x0E891C)) +
              prev(bit5(0x0E891C)) + prev(bit6(0x0E891C)) + prev(bit7(0x0E891C)) + prev(bit0(0x0E891D)) +
              prev(bit1(0x0E891D)) + prev(bit2(0x0E891D)) + prev(bit3(0x0E891D)) + prev(bit4(0x0E891E))) == 0x0B &&
              measured((bit0(0x0E891C) + bit1(0x0E891C) + bit3(0x0E891C) + bit4(0x0E891C) + bit5(0x0E891C) +
                  bit6(0x0E891C) + bit7(0x0E891C) + bit0(0x0E891D) + bit1(0x0E891D) + bit2(0x0E891D) + bit3(0x0E891D) +
                  bit4(0x0E891E)) == 0x0C
              )
)

achievement(
    title = "A Mischevious Bunch", points = 5,
    description = "Record every unique breed of Pixie in your Book.",
    id = 420377, badge = "495987", published = "4/24/2024 4:34:47 AM", modified = "9/2/2024 5:15:55 PM",
    trigger = (prev(bit0(0x0E8920)) + prev(bit1(0x0E8920)) + prev(bit2(0x0E8920)) + prev(bit3(0x0E8920)) +
              prev(bit4(0x0E8920)) + prev(bit5(0x0E8920)) + prev(bit6(0x0E8920)) + prev(bit7(0x0E8920)) +
              prev(bit0(0x0E8921)) + prev(bit1(0x0E8921)) + prev(bit2(0x0E8921)) + prev(bit3(0x0E8921)) +
              prev(bit4(0x0E8922)) + prev(bit5(0x0E8922)) + prev(bit6(0x0E8922))) == 0x0E &&
              measured((bit0(0x0E8920) + bit1(0x0E8920) + bit2(0x0E8920) + bit3(0x0E8920) + bit4(0x0E8920) +
                  bit5(0x0E8920) + bit6(0x0E8920) + bit7(0x0E8920) + bit0(0x0E8921) + bit1(0x0E8921) + bit2(0x0E8921) +
                  bit3(0x0E8921) + bit4(0x0E8922) + bit5(0x0E8922) + bit6(0x0E8922)) == 0x0F
              )
)

achievement(
    title = "Welcome to the Clew", points = 5,
    description = "Record every unique breed of Worm in your Book.",
    id = 420420, badge = "495988", published = "4/24/2024 4:52:57 PM", modified = "9/2/2024 5:15:56 PM",
    trigger = (prev(bit0(0x0E8924)) + prev(bit1(0x0E8924)) + prev(bit2(0x0E8924)) + prev(bit3(0x0E8924)) +
              prev(bit4(0x0E8924)) + prev(bit5(0x0E8924)) + prev(bit6(0x0E8924)) + prev(bit7(0x0E8924)) +
              prev(bit0(0x0E8925)) + prev(bit1(0x0E8925)) + prev(bit2(0x0E8925)) + prev(bit3(0x0E8925)) +
              prev(bit4(0x0E8926))) == 0x0C &&
              measured((bit0(0x0E8924) + bit1(0x0E8924) + bit2(0x0E8924) + bit3(0x0E8924) + bit4(0x0E8924) +
                  bit5(0x0E8924) + bit6(0x0E8924) + bit7(0x0E8924) + bit0(0x0E8925) + bit1(0x0E8925) + bit2(0x0E8925) +
                  bit3(0x0E8925) + bit4(0x0E8926)) == 0x0D
              )
)

achievement(
    title = "Jellatinous", points = 5,
    description = "Record every unique breed of Jell in your Book.",
    id = 420449, badge = "594208", published = "4/24/2024 10:49:43 PM", modified = "6/5/2025 2:18:58 AM",
    trigger = (prev(bit0(0x0E8928)) + prev(bit1(0x0E8928)) + prev(bit2(0x0E8928)) + prev(bit3(0x0E8928)) +
              prev(bit4(0x0E8928)) + prev(bit5(0x0E8928)) + prev(bit6(0x0E8928)) + prev(bit7(0x0E8928)) +
              prev(bit0(0x0E8929)) + prev(bit1(0x0E8929)) + prev(bit2(0x0E8929)) + prev(bit3(0x0E8929)) +
              prev(breeder_book_entry_82_stripe_game_sets_this_entry_when_obtaining_via_shrine()) +
              prev(breeder_book_entry_83_sam_game_sets_this_entry_when_obtaining_via_shrine())) == 0x0D &&
              measured((bit0(0x0E8928) + bit1(0x0E8928) + bit2(0x0E8928) + bit3(0x0E8928) + bit4(0x0E8928) +
                  bit5(0x0E8928) + bit6(0x0E8928) + bit7(0x0E8928) + bit0(0x0E8929) + bit1(0x0E8929) + bit2(0x0E8929) +
                  bit3(0x0E8929) + breeder_book_entry_82_stripe_game_sets_this_entry_when_obtaining_via_shrine() +
                  breeder_book_entry_83_sam_game_sets_this_entry_when_obtaining_via_shrine()) == 0x0E
              )
)

achievement(
    title = "Getting an Eyeful", points = 5,
    description = "Record every unique breed of Suezo in your Book.",
    id = 420450, badge = "495990", published = "4/24/2024 11:21:42 PM", modified = "9/2/2024 5:15:57 PM",
    trigger = (prev(bit0(0x0E892C)) + prev(bit1(0x0E892C)) + prev(bit2(0x0E892C)) + prev(bit3(0x0E892C)) +
              prev(bit4(0x0E892C)) + prev(bit5(0x0E892C)) + prev(bit7(0x0E892C)) + prev(bit0(0x0E892D)) +
              prev(bit1(0x0E892D)) + prev(bit2(0x0E892D)) + prev(bit3(0x0E892D)) + prev(bit4(0x0E892E)) +
              prev(bit5(0x0E892E)) + prev(bit6(0x0E892E))) == 0x0D &&
              measured((bit0(0x0E892C) + bit1(0x0E892C) + bit2(0x0E892C) + bit3(0x0E892C) + bit4(0x0E892C) +
                  bit5(0x0E892C) + bit7(0x0E892C) + bit0(0x0E892D) + bit1(0x0E892D) + bit2(0x0E892D) + bit3(0x0E892D) +
                  bit4(0x0E892E) + bit5(0x0E892E) + bit6(0x0E892E)) == 0x0E
              )
)

achievement(
    title = "Some Hare-y Recordings", points = 5,
    description = "Record every unique breed of Hare in your Book.",
    id = 420451, badge = "495991", published = "4/24/2024 11:44:11 PM", modified = "9/2/2024 5:15:57 PM",
    trigger = (prev(bit0(0x0E8930)) + prev(bit1(0x0E8930)) + prev(bit2(0x0E8930)) + prev(bit3(0x0E8930)) +
              prev(bit4(0x0E8930)) + prev(bit5(0x0E8930)) + prev(bit6(0x0E8930)) + prev(bit7(0x0E8930)) +
              prev(bit0(0x0E8931)) + prev(bit1(0x0E8931)) + prev(bit2(0x0E8931)) + prev(bit3(0x0E8931)) +
              prev(bit4(0x0E8932)) + prev(bit5(0x0E8932))) == 0x0D &&
              measured((bit0(0x0E8930) + bit1(0x0E8930) + bit2(0x0E8930) + bit3(0x0E8930) + bit4(0x0E8930) +
                  bit5(0x0E8930) + bit6(0x0E8930) + bit7(0x0E8930) + bit0(0x0E8931) + bit1(0x0E8931) + bit2(0x0E8931) +
                  bit3(0x0E8931) + bit4(0x0E8932) + bit5(0x0E8932)) == 0x0E
              )
)

achievement(
    title = "An Aggressive Bunch", points = 5,
    description = "Record every unique breed of Naga in your Book.",
    id = 420452, badge = "495992", published = "4/25/2024 12:05:31 AM", modified = "9/2/2024 5:15:58 PM",
    trigger = (prev(bit0(0x0E893C)) + prev(bit1(0x0E893C)) + prev(bit2(0x0E893C)) + prev(bit3(0x0E893C)) +
              prev(bit4(0x0E893C)) + prev(bit5(0x0E893C)) + prev(bit6(0x0E893C)) + prev(bit7(0x0E893C)) +
              prev(bit0(0x0E893D)) + prev(bit1(0x0E893D)) + prev(bit2(0x0E893D)) + prev(bit3(0x0E893D)) +
              prev(bit4(0x0E893E)) + prev(bit5(0x0E893E))) == 0x0D &&
              measured((bit0(0x0E893C) + bit1(0x0E893C) + bit2(0x0E893C) + bit3(0x0E893C) + bit4(0x0E893C) +
                  bit5(0x0E893C) + bit6(0x0E893C) + bit7(0x0E893C) + bit0(0x0E893D) + bit1(0x0E893D) + bit2(0x0E893D) +
                  bit3(0x0E893D) + bit4(0x0E893E) + bit5(0x0E893E)) == 0x0E
              )
)

achievement(
    title = "Home Gardening", points = 5,
    description = "Record every unique breed of Plant in your Book.",
    id = 420455, badge = "495993", published = "4/25/2024 2:20:16 AM", modified = "9/2/2024 5:15:58 PM",
    trigger = (prev(bit0(0x0E8940)) + prev(bit1(0x0E8940)) + prev(bit2(0x0E8940)) + prev(bit3(0x0E8940)) +
              prev(bit4(0x0E8940)) + prev(bit5(0x0E8940)) + prev(bit6(0x0E8940)) + prev(bit7(0x0E8940)) +
              prev(bit0(0x0E8941)) + prev(bit1(0x0E8941)) + prev(bit2(0x0E8941)) + prev(bit3(0x0E8941)) +
              prev(bit4(0x0E8942)) + prev(bit5(0x0E8942))) == 0x0D &&
              measured((bit0(0x0E8940) + bit1(0x0E8940) + bit2(0x0E8940) + bit3(0x0E8940) + bit4(0x0E8940) +
                  bit5(0x0E8940) + bit6(0x0E8940) + bit7(0x0E8940) + bit0(0x0E8941) + bit1(0x0E8941) + bit2(0x0E8941) +
                  bit3(0x0E8941) + bit4(0x0E8942) + bit5(0x0E8942)) == 0x0E
              )
)

achievement(
    title = "Your Own Monol-opoly", points = 5,
    description = "Record every unique breed of Monol in your Book.",
    id = 420457, badge = "495994", published = "4/25/2024 3:21:37 AM", modified = "9/7/2024 9:29:14 PM",
    trigger = (prev(bit0(0x0E8938)) + prev(bit1(0x0E8938)) + prev(bit2(0x0E8938)) + prev(bit3(0x0E8938)) +
              prev(bit4(0x0E8938)) + prev(bit5(0x0E8938)) + prev(bit6(0x0E8938)) + prev(bit7(0x0E8938)) +
              prev(bit0(0x0E8939)) + prev(bit1(0x0E8939)) + prev(bit2(0x0E8939)) + prev(bit3(0x0E8939)) +
              prev(bit4(0x0E893A)) + prev(bit5(0x0E893A)) + prev(bit6(0x0E893A))) == 0x0E &&
              measured((bit0(0x0E8938) + bit1(0x0E8938) + bit2(0x0E8938) + bit3(0x0E8938) + bit4(0x0E8938) +
                  bit5(0x0E8938) + bit6(0x0E8938) + bit7(0x0E8938) + bit0(0x0E8939) + bit1(0x0E8939) + bit2(0x0E8939) +
                  bit3(0x0E8939) + bit4(0x0E893A) + bit5(0x0E893A) + bit6(0x0E893A)) == 0x0F
              )
)

achievement(
    title = "They're Placeholders, We Can Replace Them Later", points = 5,
    description = "Record every unique breed of Doodle in your Book.",
    id = 420782, badge = "495995", published = "4/26/2024 12:40:17 AM", modified = "9/2/2024 5:15:59 PM",
    trigger = (prev(bit2(0x0E895E)) + prev(bit4(0x0E895E)) + prev(bit5(0x0E895E)) + prev(bit6(0x0E895E))) == 0x03 &&
              measured((bit2(0x0E895E) + bit4(0x0E895E) + bit5(0x0E895E) + bit6(0x0E895E)) == 0x04)
)

achievement(
    title = "Spectral Duo", points = 5,
    description = "Record every unique breed of Ghost in your Book.",
    id = 420824, badge = "495996", published = "4/26/2024 3:42:57 AM", modified = "9/2/2024 5:16:00 PM",
    trigger = (prev(bit1(0x0E895A)) + prev(bit4(0x0E895A))) == 0x01 && (bit1(0x0E895A) + bit4(0x0E895A)) == 0x02
)

achievement(
    title = "They're Real Meowthfuls", points = 10,
    description = "Record every unique breed of Nya in your Book.",
    id = 420825, badge = "495997", published = "4/26/2024 3:48:58 AM", modified = "3/27/2025 2:15:08 AM",
    trigger = (prev(bit2(0x0E8950)) + prev(bit3(0x0E8950)) + prev(bit5(0x0E8950)) + prev(bit7(0x0E8950)) +
              prev(bit7(0x0E8951)) + prev(bit4(0x0E8952)) + prev(bit5(0x0E8952)) + prev(bit6(0x0E8952))) == 0x07 &&
              measured((bit2(0x0E8950) + bit3(0x0E8950) + bit5(0x0E8950) + bit7(0x0E8950) + bit7(0x0E8951) +
                  bit4(0x0E8952) + bit5(0x0E8952) + bit6(0x0E8952)) == 0x08
              )
)

achievement(
    title = "The Laziest Bunch", points = 10,
    description = "Record every unique breed of Ape in your Book.",
    id = 420826, badge = "495998", published = "4/26/2024 4:08:20 AM", modified = "9/2/2024 5:16:01 PM",
    trigger = (prev(bit1(0x0E8954)) + prev(bit7(0x0E8954)) + prev(bit0(0x0E8955)) + prev(bit3(0x0E8955)) +
              prev(bit0(0x0E8956)) + prev(bit4(0x0E8956)) + prev(bit5(0x0E8956)) + prev(bit6(0x0E8956))) == 0x07 &&
              measured((bit1(0x0E8954) + bit7(0x0E8954) + bit0(0x0E8955) + bit3(0x0E8955) + bit0(0x0E8956) +
                  bit4(0x0E8956) + bit5(0x0E8956) + bit6(0x0E8956)) == 0x08
              )
)

achievement(
    title = "A Magical Experience", points = 25,
    description = "Record every unique breed of Magic in your Book.",
    id = 420830, badge = "495999", published = "4/26/2024 5:02:39 AM", modified = "9/2/2024 5:16:01 PM",
    trigger = (prev(bit6(0x0E8948)) + prev(bit2(0x0E8949)) + prev(bit3(0x0E8949)) + prev(bit5(0x0E8949)) +
              prev(bit4(0x0E894A)) + prev(bit6(0x0E8949)) + prev(bit5(0x0E894A)) + prev(bit6(0x0E894A))) == 0x07 &&
              measured((bit6(0x0E8948) + bit2(0x0E8949) + bit3(0x0E8949) + bit5(0x0E8949) + bit4(0x0E894A) +
                  bit6(0x0E8949) + bit5(0x0E894A) + bit6(0x0E894A)) == 0x08
              )
)

achievement(
    title = "Accepting Our New Robot Overlords", points = 10,
    description = "Record every unique breed of Henger in your Book.",
    id = 420831, badge = "496000", published = "4/26/2024 5:15:09 AM", modified = "9/2/2024 5:16:02 PM",
    trigger = (prev(bit0(0x0E894C)) + prev(bit1(0x0E894C)) + prev(bit0(0x0E894D)) + prev(bit1(0x0E894D)) +
              prev(bit6(0x0E894D)) + prev(bit4(0x0E894E))) == 0x05 &&
              measured((bit0(0x0E894C) + bit1(0x0E894C) + bit0(0x0E894D) + bit1(0x0E894D) + bit6(0x0E894D) + bit4(0x0E894E)) == 0x06)
)

achievement(
    title = "Rolling Deep", points = 5,
    description = "Record every unique breed of Disk in your Book.",
    id = 420832, badge = "496001", published = "4/26/2024 5:25:06 AM", modified = "9/2/2024 5:16:02 PM",
    trigger = (prev(bit3(0x0E8962)) + prev(bit4(0x0E8962)) + prev(bit5(0x0E8962))) == 0x02 &&
              measured((bit3(0x0E8962) + bit4(0x0E8962) + bit5(0x0E8962)) == 0x03)
)

achievement(
    title = "Mythical Creatures", points = 25,
    description = "Record every unique breed of Dragon in your Book.",
    id = 420838, badge = "496002", published = "4/26/2024 5:59:56 AM", modified = "9/2/2024 5:16:02 PM",
    trigger = (prev(bit1(0x0E8944)) + prev(bit0(0x0E8945)) + prev(bit1(0x0E8945)) + prev(bit4(0x0E8945)) +
              prev(bit6(0x0E8945)) + prev(bit4(0x0E8946))) == 0x05 &&
              measured((bit1(0x0E8944) + bit0(0x0E8945) + bit1(0x0E8945) + bit4(0x0E8945) + bit6(0x0E8945) + bit4(0x0E8946)) == 0x06)
)

achievement(
    title = "He's Learned His Lesson", points = 3,
    description = "Record a star of Tecmo's Deception: Invitation to Darkness, Ardebaren, in your Book.",
    id = 426995, badge = "495541", published = "5/14/2024 7:26:37 PM", modified = "9/2/2024 5:16:03 PM",
    trigger = prev(bit4(0x0E894A)) == 0x00 && bit4(0x0E894A) == 0x01 && byte(0x0F5BE4) == 0x04
)

achievement(
    title = "[VOID] You Are Broke", points = 0,
    description = "Have Holly tell you that the Game is Over.",
    id = 418786, badge = "473104", published = "4/18/2024 6:34:17 AM", modified = "4/26/2024 11:55:47 PM",
    trigger = dword(0x0E8540) == 0x00 && prior(byte(0x0E6E4C)) != 0x00
)

leaderboard(
    id = 104930, title = "Top Tournament Prize Earner",
    description = "Highest Prize money a single Monster has earned from Tournaments.",
    start  = byte(0x0B8878) == 0xEE && prev(byte(0x0F5BE4)) > 0x09 && word(0x0F6EFC) == 0x100 && word(0x0F6F40) > 0x00,
    cancel = (byte(0x0B8878) == 0xFF || byte(0x0E8530) == 0xFF || prev(byte(0x0F5BE4)) <= 0x09),
    submit = prior(word(0x0F6F40)) > 0x00 && prev(word(0x0F6F40)) == 0x00 && prior(word(0x0F6EFC)) == 0x100 &&
             prev(word(0x0F6EFC)) == 0x00,
    value  = measured(dword(0x0B88BC)),
    format = "VALUE"
)

rich_presence_conditional_display(byte(0x0E8530) == 0x00, "Watching the Intro Movie")

rich_presence_conditional_display(byte(0x0E8530) == 0xFF && word(0x0EB2E8) < 0x384 && word(0x0EB2E8) > 0x00, "Watching a Demonstration Battle")

rich_presence_conditional_display(byte(0x0E8530) == 0xFF, "On the Title Screen")

rich_presence_conditional_display(byte(0x0F5BE4) == 0x01, "wk.{0} {1}, {2}{3}{4} | 💰{5} | In Town",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x02, "wk.{0} {1}, {2}{3}{4} | 💰{5} | At the Market",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x00, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Combining Monsters at the Lab",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x01, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Freezing a Monster",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x03 && byte(0x0F5B90) == 0x02, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Reviving an old Monster from the Lab",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x04, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Using a 💿 to get a new Monster!",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0E73A2) >= 0x01 && byte(0x0E73A2) == word(0x0000B4), "wk.{0} {1}, {2}{3}{4} | 💰{5} | Checking out their Book",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x06, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Taking a look at their Data",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x07, "wk.{0} {1}, {2}{3}{4} | 💰{5} | In Town",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x08, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Thinking about going back to their Ranch",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(byte(0x0F5BE4) == 0x09, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Checking out details of their Monster",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540))
)

rich_presence_conditional_display(word(0x0E7F9A) == 0x00, "Setting up to get started on a new Ranch")

rich_presence_conditional_display(word(0x0F6F0C) == 0x100 && byte(0x0F6EFD) == 0x01, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Using a {6} / {7} to fight {8} in the {9}",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540)),
    rich_presence_lookup("MonsterPrimary", word(0x0B8890), MonsterPrimaryLookup),
    rich_presence_lookup("MonsterSecondary", word(0x0B8894), MonsterSecondaryLookup),
    rich_presence_lookup("TournamentMonster", word(0x0F6F0E), TournamentMonsterLookup),
    rich_presence_lookup("TournamentName", word(0x0E8B74), TournamentNameLookup)
)

rich_presence_conditional_display(byte(0x0F6EFD) == 0x01, "wk.{0} {1}, {2}{3}{4} | 💰{5} | Using a {6} / {7} in the {8}",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540)),
    rich_presence_lookup("MonsterPrimary", word(0x0B8890), MonsterPrimaryLookup),
    rich_presence_lookup("MonsterSecondary", word(0x0B8894), MonsterSecondaryLookup),
    rich_presence_lookup("TournamentName", word(0x0E8B74), TournamentNameLookup)
)

rich_presence_display("wk.{0} {1}, {2}{3}{4} | 💰{5} | Raising a {6} / {7} [ {8} LIF | {9} POW | {10} DEF | {11} SKI | {12} SPD | {13} INT ]",
    rich_presence_value("Number", byte(0x0E6E48)),
    rich_presence_lookup("Month", byte(0x0E6E4C), MonthLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E54))),
    rich_presence_lookup("ZeroPad", bcd(byte(0x0E6E50)), ZeroPadLookup),
    rich_presence_value("Number", bcd(byte(0x0E6E50))),
    rich_presence_value("Number", dword(0x0E8540)),
    rich_presence_lookup("MonsterPrimary", word(0x0B8890), MonsterPrimaryLookup),
    rich_presence_lookup("MonsterSecondary", word(0x0B8894), MonsterSecondaryLookup),
    rich_presence_value("Number", word(0x0E7F9A)),
    rich_presence_value("Number", word(0x0E7F9E)),
    rich_presence_value("Number", word(0x0E7FA0)),
    rich_presence_value("Number", word(0x0E7FA2)),
    rich_presence_value("Number", word(0x0E7FA6)),
    rich_presence_value("Number", word(0x0E7FA8))
)
