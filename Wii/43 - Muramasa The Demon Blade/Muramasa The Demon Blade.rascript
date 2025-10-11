// Muramasa: The Demon Blade
// #ID = 43

// $000000: [32-bit BE] Game code
//          NTSC = RSFE = 0x52534645
//          PAL = RSFP = 0x52534650
function game_code() => dword_be(0x000000)

// $000004: [16-bit BE] Maker Code
//          NTSC = 0x3755
//          PAL = 0x3939
function maker_code() => word_be(0x000004)

function is_pal() => game_code() == 0x52534650 && maker_code() == 0x3939
function is_ntsc() => game_code() == 0x52534645 && maker_code() == 0x3755

// Helper function to convert addresses from RA memory scheme to real Wii memory scheme.
// RA starts memory at 0x00000000, real system starts at 0x80000000.
// Pass in the memory address with no modifiers. 
// This will return your address as AddAddress(ptr) & 0x1FFFFFFF.
function mask_ptr(ptr) => dword_be(ptr) & 0x1FFFFFFF

// $3CC933: [8-bit] [NTSC] Difficulty
// NOTE: probably need to identify full struct for settings so that this can be portable between versions.
//          0x00 = Muso
//          0x01 = Shura
//          0x02 = Shigurui?
function ntsc_difficulty() => byte(0x3CC933)

DifficultyLookup = {
    0: "Muso",
    1: "Shura",
    2: "Shigurui",
}

// $3CC934: [8-bit] [NTSC] Audio
//          0x00 = Off
//          0x01 = On
function ntsc_audio() => byte(0x3CC934)

// $3CCAB0: [32-bit BE Pointer] [NTSC] Player character pointer
// NOTE this is not completely correct. I believe it's nested further but I haven't figured out how yet
//          +0x1d8 = Character Current HP [32-bit BE]
//          +0x1dc = Character Max HP [32-bit BE]
//          +0x1f0 = Character Money [32-bit BE]
function ntsc_player_character_pointer() => dword_be(0x3CCAB0)

// $474DB0: [32-bit BE Pointer] Pointer to combat
//          Incomplete, requires something else for context or is further nested. It's sometimes correct.
//          +0x14 Pointer to active combat [32-bit BE Pointer]
//          ++0x7c Active Combo
function combat_pointer(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return mask_ptr(mask_ptr(0x474DB0) + 0x14)
    }
}

// $DA7314: [32-bit Pointer] Pointer to Settings
function pointer_to_settings() => dword(0xDA7314)

// $E27038: [32-bit BE Pointer] [NTSC] Candidate for player character pointer
// +0x0 Beginning of the block
// +0x1d4 Current Character [8-bit] (KT: probably)
// 0x0=Kisuke
// 0x1=Momohime
// +0x1d8 Character Current HP [32-bit BE]
// +0x1dc Character Max HP [32-bit BE]
// +0x1ec Character Total XP [32-bit BE]
// +0x1f0 Character Money [32-bit BE]
// +0x200 Base Strength [16-bit BE]
// +0x202 Base Vitality [16-bit BE]
// +0x204 ID of current blade equipped [16-bit BE] (KT: pretty sure that's it and not 8-bit)
// +0x22c Last height where you were "grounded" [32-bit BE Float]
// 0.0=Grounded or otherwise unaffected by gravity e.g. for a moment after dash attacks
// <0.0=Last point grounded is below e.g. while jumping
// >0.0=Last point grounded is above e.g. while falling off a ledge
function ptr_character_details_ntsc() => mask_ptr(0x00e27038)

function active_character(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return byte(ptr_character_details_ntsc() + 0x1d4)
    }
}

CharacterLookup = {
    0x00: "Kisuke",
    0x01: "Momohime"
}

function active_zone(region) {
    if (region == "PAL") {
        
    } else if (region == "NTSC") {
        return dword_be(0x00da70c4)
    }
}

// $DA70C4: [32-bit BE] Current Map ID
// $DA70C8: [32-bit BE] Next Map ID
// If both are null, then you're not playing the game
function check_on_main_menu(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return dword_be(0x00da70c4) == 0xffffffff && dword_be(0x00da70c8) == 0xffffffff
    }
}

// $DA70C4: [32-bit BE] Current Map ID
ZoneLookup = {
    0x0: "Blue Monk",
    0x1: "Big Oni",
    0x2: "Fishing mini-game",
    0x3: "Kraken",
    0x4: "Mermaid",
    0x5: "Raijin",
    0x6: "Chimera",
    0x7: "Ippondatara",
    0x8: "Yamashiro",
    0x9: "Torahime",
    0xa: "Iga",
    0xb: "Yamato",
    0xc: "Ise",
    0xd: "Mino",
    0xe: "Omi",
    0xf: "Owari",
    0x10: "Musashi",
    0x11: "Kai",
    0x12: "Izu",
    0x13: "Mikawa",
    0x14: "Shinano",
    0x15: "Yamashiro Foot of Mt. Bukumi, Kii District",
    0x16: "Totomi",
    0x17: "Sagami",
    0x18: "Kagami Manor of Marukami, Mt. Ibuki",
    0x19: "Suruga",
    0x1a: "Hida",
    0x1b: "Musashi In front of Ote Gate, Edo Castle",
    0x1c: "Tsuchigumo",
    0x1d: "Giant Centipede",
    0x1e: "Musashi Shin-Yoshiwara, Nihonzutsumi",
    0x1f: "Mino, In Front of Ote Gate, Narukami Castle",
    0x20: "Hell, Tokatsu Eight Views of Hell",
    0x21: "Shinano, Hachimanbara, Kawanakajima Battle Field",
    0x22: "Kurozaru",
    0x23: "Iga In front of Karamete Gate, Skull Valley Anya Castle",
    0x24: "Totomi Mountain Road of Mt. Akiha, Shuchi District",
    0x25: "Dragon God",
    0x26: "Yukinojyo",
    0x27: "Wanyudo",
    0x28: "Sayo",
    0x29: "Chigurui Bishamon",
    0x2a: "Hida Byroad of Mt. Norikura, Takayama",
    0x2b: "Suruga Satta Pass, Byroad of Tokaido",
    0x2c: "Suruga Foot of Mt. Fuji",
    0x2d: "Yamato Buddha Statue Hall in Zentoji, Nara",
    0x2e: "Ise Jingu Forest, Mt. Kamiji",
    0x2f: "Sagami Mountain Road of Rokkoku Kenzan",
    0x30: "Yamato HQ of Shingon-Renge School, Mt. Kongo",
    0x31: "Inugami Tokugawa Tsunayoshi",
    0x32: "Momohime",
    0x33: "Inugami Tokugawa Tsunayoshi again",
    0x34: "Fudo-Myoou",
    0x35: "Kisuke",
    0x36: "Fudo-Myoou again",
    0x37: "Onsen",
    0x38: "Purple waves scene",
    0x39: "Credits",
}

function active_sword(region) {
    if (region == "PAL") {
        
    } else if (region == "NTSC") {
        return word_be(mask_ptr(0x00e27038) + 0x204)
    }
}

// Get the byte indicating that a given sword is acquired.
// 
function sword_acquired(region, sword) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return byte(sword_flags_ntsc[sword])
    }
}

function any_blade_broke(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return byte(0x00da766b) == 0x01 || byte(0x00da768f) == 0x01 || byte(0x00da76b3) == 0x01
    }
}

function current_level(region) {
    if (region == "PAL") {
    } else if (region == "NTSC") {
        return byte(ptr_character_details_ntsc() + 0x1fc) + 1
    }
}

// Static array ranging [$0x00da758d, $0x00da75f8]
// Every flag here is 0x00 = Not acquired, 0x01 = Acquired
sword_flags_ntsc = {
    "Kagura Muramasa": 0x00da758d,
    "Shinmei": 0x00da758e,
    "Yakumo": 0x00da758f,
    "Hasebe Kunishige": 0x00da75be,
    "Kashagiri Hiromitsu": 0x00da75c3,
}

function num_current_swords(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        cond = 0
        for i in range(0, 108) {
            cond = cond + byte(0x00da758d + i)
        }
        return cond
    }
}

function current_ryo(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return dword_be(ptr_character_details_ntsc() + 0x1f0) / 10000
    }
} 

function current_mon(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return dword_be(ptr_character_details_ntsc() + 0x1f0) % 10000
    }
}

// Swords are indexed differently in their on/off array and what the game actually looks them up as.
ActiveSwordLookup = {
    0x0c: "Chizuru Muramasa",
    0x0d: "Hisui",
    0x0e: "Sazanami",
    0x0f: "Ayame Muramasa",
    0x11: "Hasebese Kunishige",
    0x12: "Botan Muramasa",
    0x13: "Umitsubame Muramasa",
    0x17: "Getsuei Muramasa",
    0x1e: "Hibari Muramasa",
}

// can do Blue Monk boss trigger on blade get

achievement(
    title = "[TEST] Active Combo", points = 0,
    description = "x50 plz",
    trigger = dword_be(combat_pointer("NTSC")) + 0x6c == 0x31 &&
            prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x32 &&
            dword_be(combat_pointer("NTSC") + 0x7c) >= 0x32
)

achievement(
    title = "Haunted Once More",
    description = "Bring Momohime to Jinkuro and defend her body from the Blue Monk's assault.",
    points = 5,
    type = "progression",
    trigger = is_ntsc() 
            && active_character("NTSC") == 0x01 
            && active_zone("NTSC") == 0x00
            && prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00) 
            && sword_acquired("NTSC", "Hasebe Kunishige") == 0x01
)

achievement(
    title = "[TEST]Combo Haunted Again",
    description = "Defeat Blue Monk as Momohime on Shura or Shigurui and achieve a combo of 100 or higher.",
    points = 5,
    trigger = is_ntsc() 
            && active_character("NTSC") == 0x01 
            && __ornext((ntsc_difficulty() == 0x01 || ntsc_difficulty() == 0x02))
            && never(active_zone("NTSC") != 0x00)
            && once(prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x64 && (dword_be(combat_pointer("NTSC") + 0x7c)) >= 0x64)
            // the trigger as before
            && trigger_when(prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00)) 
            && trigger_when(sword_acquired("NTSC", "Hasebe Kunishige") == 0x01)
)

achievement(
    title = "[TEST]Blades Not Haunted",
    description = "Defeat Blue Monk as Momohime on Shura or Shigurui without any blades breaking.",
    points = 5,
    trigger = is_ntsc() 
            && active_character("NTSC") == 0x01 
            && __ornext(ntsc_difficulty() == 0x01 || ntsc_difficulty() == 0x02)
            && disable_when(any_blade_broke("NTSC"))
            && never(active_zone("NTSC") != 0x00)
            // the trigger as before
            && trigger_when(prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00)) 
            && trigger_when(sword_acquired("NTSC", "Hasebe Kunishige") == 0x01)
)

achievement(
    title = "Collateral Freedom",
    description = "Track down Momohime's soul all the way to Musashi and forcefully take it back from Wanyudo.",
    points = 5,
    type = "progression",
    trigger = is_ntsc() 
            && active_character("NTSC") == 0x01 
            && active_zone("NTSC") == 0x27
            && prev(sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x00) 
            && sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x01
)

rich_presence_conditional_display(check_on_main_menu("NTSC"), "On the title screen")

rich_presence_display("[{0}] lv. {1} {2} is tearing through {3} equipped with {4} | {5} / 108 ⚔️ | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", ntsc_difficulty(), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_lookup("ActiveSword", active_sword("NTSC"), ActiveSwordLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)