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
// $442933: [8-bit] [PAL] Difficulty
//          0x00 = Muso
//          0x01 = Shura
//          Shigurui is Shura.
function current_difficulty(region) {
    if (region == "NTSC") {
        return byte(0x3CC933)
    } else if (region == "PAL") {
        return byte(0x00442933)
    }
}

DifficultyLookup = {
    0: "Muso",
    1: "Shura"
}

// Shigurui is Shura difficulty but your HP is always 1/1
// Or 0/1 if you get hit :)
function is_shigurui(region) {
    if (region == "PAL") {
        return current_difficulty("PAL") == 0x01
            && dword_be(ptr_character_details("PAL") + 0x1dc) == 0x01
            && dword_be(ptr_character_details("PAL") + 0x1d8) <= 0x01
    } else if (region == "NTSC") {
        return current_difficulty("NTSC") == 0x01 
            && dword_be(ptr_character_details("NTSC") + 0x1dc) == 0x01
            && dword_be(ptr_character_details("NTSC") + 0x1d8) <= 0x01
    }
}

// Inverse of above to avoid excess alts.
// Why 6 alt when no alt do?
function is_not_shigurui(region) {
    if (region == "PAL") {
        return __ornext(current_difficulty(region) == 0x00 || dword_be(ptr_character_details("PAL") + 0x1dc) > 0x01)
    } else if (region == "NTSC") {
        return __ornext(current_difficulty(region) == 0x00 || dword_be(ptr_character_details("NTSC") + 0x1dc) > 0x01)
    }
}

// Not to be confused with "active combat."
// This pointer leads you to the current combat timer and the rewards screen.
// [32-bit BE Pointer] [NTSC] Pointer to combat
// +0x14 Pointer to active combat [32-bit BE Pointer]
// ++0x3c Combat timer in frames [32-bit BE]
// -- When combat is rolling, this will be incrementing. The frame combat is done, this gets copied somewhere for the results screen and resets to 0.
// ++0x6c Unsure what it is for, but it's 0x00000031 when combat is rolling [32-bit BE]
// ++0x7c Active Combo [32-bit BE]
function current_encounter_pointer(region) {
    if (region == "PAL") {
        return mask_ptr(mask_ptr(0x004eaef0) + 0x14)
    } else if (region == "NTSC") {
        // return mask_ptr(0x00474da8)
        return mask_ptr(mask_ptr(0x474DB0) + 0x14)
    }
}

// $0x00474da8: [32-bit BE] Base pointer to boss HP
//          +0x80=[32-bit BE] Current combo on boss
//          +0x84=[32-bit BE] Time left, in frames, until active combo wears out
function active_combat_pointer(region) {
    if (region == "PAL") {
        return mask_ptr(0x004eaee8)
    } else if (region == "NTSC") {
        return mask_ptr(0x00474da8)
    }
}

// $0x00474db0 for NTSC
// $0x004eaef0 for PAL
// [32-bit BE Pointer] [NTSC] Pointer to results screen
// +0x14 Pointer to active combat [32-bit BE Pointer]
// ++0x3c Timer in frames [32-bit BE]
// .. When combat is rolling, this will be incrementing. The frame combat is done, this gets copied somewhere for the results screen and resets to 0.
// ++0x6c Unsure what it is for, but it's 0x00000031 when combat is rolling [32-bit BE]
// ++0x4bc End of previous block, should be 0xffffffff [32-bit BE]
// ++0x4c0 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0x4c4 Time reported in Results screen, in frames [32-bit BE]
// ++0x664 End of previous block, should be 0xffffffff [32-bit BE]
// ++0x668 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0x66c XP reported in Results section of Win screen [32-bit BE]
// ++0x80c End of previous block, should be 0xffffffff [32-bit BE]
// ++0x810 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0x814 Ryo/mon earned in Results section of Win screen [32-bit BE]
// ++0x9b4 End of previous block, should be 0xffffffff [32-bit BE]
// ++0x9b8 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0x9bc XP from first perk in Rating [32-bit BE]
// ++0xb5c End of previous block, should be 0xffffffff [32-bit BE]
// ++0xb60 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0xb64 XP from second perk in Rating [32-bit BE]
// ++0xd04 End of previous block, should be 0xffffffff [32-bit BE]
// ++0xd08 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0xd0c XP from third perk in Rating [32-bit BE]
// ++0xeac End of previous block, should be 0xffffffff [32-bit BE]
// ++0xeb0 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0xeb4 XP from fourth perk in Rating [32-bit BE]
// ++0x1054 End of previous block, should be 0xffffffff [32-bit BE]
// ++0x1058 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0x105c XP from fifth perk in Rating [32-bit BE]
// ++0x11fc End of previous block, should be 0xffffffff [32-bit BE]
// ++0x1200 Boolean, bonus active // 0x00 = inactive, 0x01 = active [8-bit]
// ++0x1204 Total XP earned [32-bit BE]
function results_screen_ptr(region) {
    base_addr = 0
    if (region == "PAL") {
        base_addr = 0x004eaef0
    } else if (region == "NTSC") {
        base_addr = 0x00474db0
    }

    return mask_ptr(mask_ptr(base_addr) + 0x14)
}

// Helper function for every achievement where I need to ask "Is the results screen up? Did we win?"
function results_screen_present(region) {
    return dword_be(ptr_character_details(region) + 0x1d8) > 0
        // results screen timer is initialized
        && dword_be(results_screen_ptr(region) + 0x4bc) == 0xffffffff
        && dword_be(results_screen_ptr(region) + 0x80c) == 0xffffffff
        // they got some mon out of this
        && dword_be(results_screen_ptr(region) + 0x814) >= 0x00
        && dword_be(results_screen_ptr(region) + 0x814) <= 40000 // 20,000 is mostly a "is this an amount of mon could get"
        // results screen timer is now present where it wasn't before
        && prev(byte(results_screen_ptr(region) + 0x4c0)) == 0x00
        && byte(results_screen_ptr(region) + 0x4c0) == 0x01
        // && prev(dword_be(results_screen_ptr(region) + 0x4c4)) == 0x00
        // && dword_be(results_screen_ptr(region) + 0x4c4) > 0x00
}

// We know this works for a single boss. Too lazy to dig for multiple because we don't really need it!
// $474DA8: [32-bit BE] Base pointer to Boss HP
//          +0x550  = [32-bit BE] Intermediary pointer
//          ++0x14  = [32-bit BE] Intermediary pointer
//          +++0x64 = [Float BE] Boss big HP bar (as it takes damage and a red bar fills up)
//          +++0x68 = [Float BE] Boss big HP bar (when not taking damage for a while, slowly decreases to value above)
//          +++0x8c = [Float BE] Boss Small HP Bar (as it takes damage)
//          ---1.0 = No more bars left. Can use this in conjunction with 0x64=0 to determine that this boss is dead.
//          +++0x90 = [Float BE] Boss Small HP Bar (catches up to 0x8c)
// This function returns the third layer as a convenience so you can just do your +0x64 / + 0x68 / +0x8c / +0x90 on top of it for floats. 
function boss_health_ptr(region) {
    if (region == "PAL") {
        return mask_ptr(mask_ptr(mask_ptr(0x004eaee8) + 0x550) + 0x14)
    } else if (region == "NTSC") {
        return mask_ptr(mask_ptr(mask_ptr(0x474da8) + 0x550) + 0x14)
    }
}

// Check that a single boss just died.
function active_single_boss_died(region) {
    health_ptr = boss_health_ptr(region)
    return float_be(health_ptr + 0x8c) <= -1.0 && prev(float_be(health_ptr + 0x64)) > 0.0 && float_be(health_ptr + 0x64) <= 0.0
}

function active_single_boss_activated(region) {
    health_ptr = boss_health_ptr(region)
    return float_be(health_ptr + 0x8c) > -1.0 && prev(float_be(health_ptr + 0x64)) <= 0.0 && float_be(health_ptr + 0x64) > 0.0
}

// $DA7314: [32-bit Pointer] Pointer to Settings
function pointer_to_settings() => dword(0xDA7314)

// $E27038: [32-bit BE Pointer] [NTSC] Player character pointer
// $0x00e9d238: [32-bit BE Pointer] [PAL] Player character pointer
// +0x0 Beginning of the block
// +0xf2 Sword rain guard id [16-bit BE]
// +0xf4 Sword grip id [16-bit BE]
// +0x1d4 Current Character [8-bit] (KT: probably)
// 0x0=Kisuke
// 0x1=Momohime
// +0x1d8 Character Current HP [32-bit BE]
// +0x1dc Character Max HP [32-bit BE]
// +0x1ec Character Total XP [32-bit BE]
// +0x1f0 Character Money (every multiple of 10,000 = 1 ryo) [32-bit BE]
// +0x1f4 Souls [32-bit BE]
// +0x1f8 Spirit [32-bit BE]
// +0x1fc Current level - 1 (if you see 5 here you're level 6) [8-bit]
// +0x200 Base Strength [16-bit BE]
// +0x202 Base Vitality [16-bit BE]
// +0x204 ID of current blade equipped [16-bit BE]  (KT: pretty sure that's it and not 8-bit)
// (Not current blade ID, Tachigesa Muramasa and Kashagiri Hiromitsu share same value. Different skills too. Correlated with switching blade though)
// +0x22c Last height where you were "grounded" [32-bit BE Float]
// 0.0=Grounded or otherwise unaffected by gravity e.g. for a moment after dash attacks
// <0.0=Last point grounded is below e.g. while jumping
// >0.0=Last point grounded is above e.g. while falling off a ledge
// +0x244 Pointer to last enemy hit [32-bit BE]
function ptr_character_details(region) {
    if (region == "PAL") {
        return mask_ptr(0x00e9d238)
    } else if (region == "NTSC") {
        return mask_ptr(0x00e27038)
    }
}
 
// Get the active character currently being played.
// This is effectively a "is it 0x00 (Kisuke) or 0x01 (Momohime)" so combine this with other logic to get what you need.
function active_character(region) {
    if (region == "PAL") {
        return byte(ptr_character_details("PAL") + 0x1d4)
    } else if (region == "NTSC") {
        return byte(ptr_character_details("NTSC") + 0x1d4)
    }
}

function is_active_character(region, char_name) {
    if (char_name == "Kisuke") { 
        return byte(ptr_character_details(region) + 0x1d4) == 0x00
    } else if (char_name == "Momohime") {
        return byte(ptr_character_details(region) + 0x1d4) == 0x01
    }
}

CharacterLookup = {
    0x00: "Kisuke",
    0x01: "Momohime"
}

// Check the phase of hot spring visits.
// "Phase" refers to whether or not the other character shows up, really. 
function hot_spring_phase(region, character) {
    addr = 0
    if (region == "PAL") {
        addr = 0x00433c84
    } else if (region == "NTSC") {
        addr = 0x003bdc84
    }

    if (character == "Kisuke") {
        offset = 0x90
    } else if (character == "Momohime") {
        offset = 0x190
    }

    return dword_be(mask_ptr(addr) + offset)
}

// Get the current in-game time for the player.
// This seems to be measured as purely minutes. X / 60 to get hours, X % 60 to get minutes.
function in_game_timer(region, character) {
    addr = 0
    offset = 0
    if (character == "Momohime") {
        offset = 0x194
    } else if (character == "Kisuke") {
        offset = 0x94
    } else if (character == "Either") {
        offset = 0x10
    }

    if (region == "PAL") {
        addr = 0x00433c84
    } else if (region == "NTSC") {
        addr = 0x003bdc84
    }

    return dword_be(mask_ptr(addr) + offset)
}

// Get the active zone the player is in.
function active_zone(region) {
    if (region == "PAL") {
        return dword_be(0x00e1d2c4)
    } else if (region == "NTSC") {
        return dword_be(0x00da70c4)
    }
}

// Please god think about what you're doing here.
// Anyway, this returns the 32-bit BE value corresponding to the current scene.
function active_screen(region) {
    if (region == "PAL") {
        return dword_be(0x00e1d534)
    } else if (region == "NTSC") {
        return dword_be(0x00da7334)
    }
}

// $DA70C4: [32-bit BE] Current Map ID
// $DA70C8: [32-bit BE] Next Map ID
// If both are null, then you're not playing the game
function check_on_main_menu(region) {
    if (region == "PAL") {
        return dword_be(0x00e1d2c4) == 0xffffffff && dword_be(0x00e1d2c8) == 0xffffffff
    } else if (region == "NTSC") {
        return dword_be(0x00da70c4) == 0xffffffff && dword_be(0x00da70c8) == 0xffffffff
    }
}

function is_fighting_boss(region) {
    boss_values = [
        // momohime boss values
        0x00, // Blue Monk
        0x01, // Big Oni
        0x05, // "Raijin",
        0x06, // "Chimera",
        0x07, // "Ippondatara",
        0x1d, // "Giant Centipede",
        0x25, // "Dragon God",
        0x26, // "Yukinojyo",
        0x27, // "Wanyudo",
        0x34, // "Fudo-Myouu"
        0x35, // Kisuke Ending 2
        0x36, // Fudo-Myouu Ending 3
        // kisuke boss values
        0x22, // Kurozaru
        0x09, // Torahime
        0x1d, // Giant Centipede
        0x28, // Sayo
        0x1c, // Tsuchigumo
        0x29, // Chigurui Bishamon
        0x25, // Dragon God
        0x31, // Inugami Tokugawa Tsunayoshi
        0x32, // Momohime Ending 2
        0x33, // Inugami Tokugawa Tsunayoshi Ending 3
    ]

    cond = always_false()
    for boss_value in boss_values {
        cond = cond || active_zone(region) == boss_value
    }

    return cond
}

function is_fishing(region) {
    KRAKEN = 0x03
    MERMAID = 0x04

    return active_zone(region) >= KRAKEN && active_zone(region) <= MERMAID
}

// Inverse of #check_on_main_menu so that it doesn't get alt group'd when I negate it.
function is_in_game(region) {
    if (region == "PAL") {
        return is_pal() && dword_be(0x00e1d2c4) != 0xffffffff && dword_be(0x00e1d2c8) != 0xffffffff
    } else if (region == "NTSC") {
        return is_ntsc() && dword_be(0x00da70c4) != 0xffffffff && dword_be(0x00da70c8) != 0xffffffff
    }
}

// Check if the player is in a given zone.
function in_zone(region, zone) {
    for key in ZoneLookup {
        if (ZoneLookup[key] == zone) {
            if (region == "PAL") {
                return dword_be(0xe1d2c4) == key
            } else if (region == "NTSC") {
                return dword_be(0xDA70C4) == key
            }
        }
    }
    
    return always_false()
}

// Check if the player is on the given screen.
// This is a more forceful check that combines screen and map ids.
function on_screen(region, map_name, screen_name) {
    return in_zone(region, map_name) && RELEVANT_SCREENS[map_name][screen_name] == active_screen(region)
}

function in_total_pandemonium(region) {
    // For lazy reference:
    //         "Lair, pt. 1": 0x0c,
    //          "Lair, pt. 2": 0x0e,
    //          "Lair, pt. 3": 0x0f,
    //          "Lair, pt. 4": 0x10,
    //          "Lair, pt. 5": 0x11,
    //          "Lair, pt. 6": 0x12,
    //          "Lair, pt. 7": 0x13,
    //          "Lair, final part": 0x14,

    return in_zone(region, "Izu") 
        && active_screen(region) >= RELEVANT_SCREENS["Izu"]["Lair, pt. 1"]
        && active_screen(region) <= RELEVANT_SCREENS["Izu"]["Lair, final part"]
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
    0x15: "Foot of Mt. Bukumi", // Full name is Yamashiro Foot of Mt. Bukumi, Kii District
    0x16: "Totomi",
    0x17: "Sagami",
    0x18: "Kagami Manor", // Full name is Kagami Manor of Marukami, Mt. Ibuki
    0x19: "Suruga",
    0x1a: "Hida",
    0x1b: "Ote Gate", // full name is Musashi In front of Ote Gate, Edo Castle
    0x1c: "Tsuchigumo",
    0x1d: "Giant Centipede",
    0x1e: "Shin-Yoshiwara, Nihonzutsumi", // full name is Musashi Shin-Yoshiwara, Nihonzutsumi
    0x1f: "Narukami Castle", // Full name is Mino, In Front of Gate Ote, Narukami Castle
    0x20: "Tokatsu Eight Views of Hell", // Full name is Hell, Tokatsu Eight Views of Hell
    0x21: "Kawanakajima Battle Field", // Full name is Shinano, Hachimanbara, Kawanakajima Battle Field
    0x22: "Kurozaru",
    0x23: "Karamete Gate", // Full name is Iga In front of Karamete Gate, Skull Valley Anya Castle
    0x24: "Totomi Mountain Road", // Totomi Mountain Road of Mt. Akiha, Shuchi District
    0x25: "Dragon God",
    0x26: "Yukinojyo",
    0x27: "Wanyudo",
    0x28: "Sayo",
    0x29: "Chigurui Bishamon",
    0x2a: "Hida Byroad", // full name is Hida Byroad of Mt. Norikura, Takayama
    0x2b: "Suruga Satta Pass", // full name is Suruga Satta Pass, Byroad of Tokaido
    0x2c: "Foot of Mt. Fuji", // full name is Suruga 
    0x2d: "Buddha Statue Hall", // full name is Yamato Buddha Statue Hall in Zentoji, Nara
    0x2e: "Ise Jingu Forest", // full name is Ise Jingu Forest, Mt. Kamiji
    0x2f: "Sagami Mountain Road of Rokkoku Kenzan", // full name is Sagami Mountain Road of Rokkoku Kenzan
    0x30: "Mt. Kongo", // Full name is Yamato HQ of Shingon-Renge School, Mt. Kongo
    0x31: "Inugami Tokugawa Tsunayoshi",
    0x32: "Momohime",
    0x33: "Inugami Tokugawa Tsunayoshi", // re-fight
    0x34: "Fudo-Myoou",
    0x35: "Kisuke",
    0x36: "Fudo-Myoou", // re-fight
    0x37: "Onsen",
    0x38: "Purple waves scene",
    0x39: "Credits",
}

// Structure: RELEVANT_SCREENS[MAP_NAME][SCREEN_NAME] = SCREEN_ID
RELEVANT_SCREENS = {
    "Blue Monk": {
        "Fight": 0x00
    },
    "Yamashiro": {
        "Lair": 0x3a
    },
    "Iga": {
        "Lair": 0x13
    },
    "Yamato": {
        "Lair": 0x19
    },
    "Ise": {
        "Lair": 0x16
    },
    "Mino": {
        "Lair": 0x1d
    },
    "Omi": {
        "Lair": 0x10
    },
    "Owari": {
        "Lair": 0x0f
    },
    "Musashi": {
        "Lair": 0x1e
    },
    "Kai": {
        "Lair": 0x12
    },
    "Izu": {
        "Lair, pt. 1": 0x0c,
        "Lair, pt. 2": 0x0e,
        "Lair, pt. 3": 0x0f,
        "Lair, pt. 4": 0x10,
        "Lair, pt. 5": 0x11,
        "Lair, pt. 6": 0x12,
        "Lair, pt. 7": 0x13,
        "Lair, final part": 0x14,
    },
    "Mikawa": {
        "Lair": 0x0d
    },
    "Shinano": {
        "Lair, pt. 1": 0x15,
        "Lair, pt. 2": 0x16
    },
    "Totomi": {
        "Lair": 0x10
    },
    "Sagami": {
        "Lair": 0x11
    },
    "Suruga": {
        "Lair": 0x19
    },
    "Hida": {
        "Lair": 0x0e
    },
    // For these two keys specifically, we are relying on the fact that we do not care for the regular endings
    // These are specifically for the alternate, "Ending 3" paths
    "Inugami Tokugawa": {
        "Fight": 0x00,
        "Before Fight": 0x01,
        "Alternate Ending Start": 0x05
    },
    "Fudo-Myouu": {
        "Before Fight": 0x00,
        "Pre-Fight Room": 0x01,
        "Cutscene before fight": 0x02,
        "Fight": 0x0b,
        "Alternate Ending Cutscene Start": 0x03 
    }
}

BOSS_ZONE_MAP = {
    // Momohime bosses
    "Blue Monk": 0x00,
    "Wanyudo": 0x27,
    "Yukinojyo": 0x26,
    "Ippondatara": 0x07,
    "Chimera": 0x06,
    "Big Oni": 0x01,
    "Raijin": 0x05,
    "Fudo-Myouu": 0x34,
    "Kisuke": 0x35,
    "Fudo-Myouu (2)": 0x36,
    // Kisuke bosses
    "Kurozaru": 0x22,
    "Giant Centipede": 0x1d,
    "Torahime": 0x09,
    "Sayo": 0x28,
    "Tsuchigumo": 0x1c,
    "Chigurui Bishamon": 0x29,
    "Dragon God": 0x25,
    "Inugami Tokugawa Tsunayoshi": 0x31,
    "Momohime": 0x32,
    "Inugami Tokugawa Tsunayoshi (2)": 0x33
}

BOSS_ZONES = [
    // momohime boss values
    0x00, // Blue Monk
    0x01, // Big Oni "Big Oni",
    0x05, // "Raijin",
    0x06, // "Chimera",
    0x07, // "Ippondatara",
    0x26, // "Yukinojyo",
    0x27, // "Wanyudo",
    0x34, // "Fudo-Myouu"
    0x35, // Kisuke Ending 2
    0x36, // Fudo-Myouu Ending 3
    // kisuke boss values
    0x22, // Kurozaru
    0x09, // Torahime
    0x1d, // Giant Centipede
    0x28, // Sayo
    0x1c, // Tsuchigumo
    0x29, // Chigurui Bishamon
    0x25, // Dragon God
    0x31, // Inugami Tokugawa Tsunayoshi
    0x32, // Momohime Ending 2
    0x33, // Inugami Tokugawa Tsunayoshi Ending 3
]

// Get the byte indicating that a given sword is acquired.
function sword_acquired(region, sword) {
    starting_addr = 0
    if (region == "PAL") {
        starting_addr = 0x00e1d78d
    } else if (region == "NTSC") {
        starting_addr = 0x00da758d
    }

    for i in range(0, length(ALL_SWORDS)) {
        if (ALL_SWORDS[i] == sword) {
            return byte(starting_addr + i)
        }
    }
}

ACCESSORY_BLOCK_ONE = [
    "Ninja Gauntlet",
    "Fox Spirit Gauntlet",
    "Tengu Gauntlet",
    "Utsusemi Gauntlet",
    "Shura Gauntlet",
    "Yata Gauntlet",
    "Demon God Gauntlet",
    "Dragon God Gauntlet",
    "Ninja Belt",
    "Fox Spirit Belt",
    "Tengu Belt",
    "Utsusemi Belt",
    "Shura Belt",
    "Yata Belt",
    "Demon God Belt",
    "Dragon God Belt",
    "Tengu Mask",
    "Shura Mask",
    "Demon God Mask",
    "Dragon God Mask",
    "Hinezumi Dress",
    "Suiko Scale",
    "Oni Necklace",
    "Dragon Necklace",
    "Master's Handbook",
]

ACCESSORY_BLOCK_TWO = [
    "Kusarikatabira",
    "Wolfsbane Poison",
    "Iwami Poison",
    "Cypress Rosary",
    "Cloisonne Rosary",
    "Clove Oil",
    "Swashbuckler's Sheath",
    "Swordmaster's Sheath",
    "Ise Charm",
    "Izumo Charm",
    "Yamato Miracle Drug",
    "Toyoma Miracle Drug",
    "Hungry Devil Saucer",
    "Chowhound Saucer",
    "Lucky Mallet",
    "Straw Stalk",
    "Crystal Magatama",
    "Jade Magatama",
    "Ghoulish Seal",
    "Shura Seal",
    "Ninja Socks",
    "Ninja Socks II",
    "Clapper",
    "A Pair of Clappers",
    "Swordsmith Mallet",
    "Merchant's Abacus",
    "Imari Platter",
    "Sacred Tree Tablet",
    "Narukami Bracelet",
    "Nio Bracelet",
]


// Check if a specific accessory has been acquired.
function accessory_acquired(region, accessory) {
    // There are two distinct blocks of accessories to loop over
    starting_addr = 0

    if (region == "PAL") {
        starting_addr = 0x00e1d722
    } else if (region == "NTSC") {
        starting_addr = 0x00da7522
    }

    for i in range(0, length(ACCESSORY_BLOCK_ONE) - 1) {
        if (ACCESSORY_BLOCK_ONE[i] == accessory) {
            return byte(starting_addr + i)
        }
    }

    // try the next block
    if (region == "PAL") {
        starting_addr = 0x00e1d7ff
    } else if (region == "NTSC") {
        starting_addr = 0x00da75ff
    }

    for i in range(0, length(ACCESSORY_BLOCK_TWO)) {
        if (ACCESSORY_BLOCK_TWO[i] == accessory) {
            return byte(starting_addr + i)
        }
    }

}

// Static pair of arrays. One precedes swords, one is after swords.
// Each address is a byte with 0x00 = not acquired; 0x01 = acquired
accessory_flags_ntsc = {
    "Ninja Belt": 0x00da752a,
    "Fox Spirit Belt": 0x00da752b,
    "Tengu Belt": 0x00da752c,
    "Utsusemi Belt": 0x00da752d,
    "Shura Belt": 0x00da752e,
    "Yata Belt": 0x00da752f,
    "Demon God Belt": 0x00da7530,
    "Dragon God Belt": 0x00da7531,
    "Tengu Mask": 0x00da7532,
    "Shura Mask": 0x00da7533,
    "Demon God Mask": 0x00da7534,
    "Dragon God Mask": 0x00da7535,
    "Hinezumi Dress": 0x00da7536,
    "Suiko Scale": 0x00da7537,
    "Oni Necklace": 0x00da7538,
    "Dragon Necklace": 0x00da7539,
    "Master's Handbook": 0x00da753a,
    // intentional gap here
    "Kusarikatabira": 0x00da75ff,
    "Wolfsbane Poison": 0x00da7600,
    "Iwami Poison": 0x00da7601,
    "Cypress Rosary": 0x00da7602,
    "Cloisonne Rosary": 0x00da7603,
    "Clove Oil": 0x00da7604,
    "Swashbuckler's Sheath": 0x00da7605,
    "Swordmaster's Sheath": 0x00da7606,
    "Ise Charm": 0x00da7607,
    "Izumo Charm": 0x00da7608,
    "Yamato Miracle Drug": 0x00da7609,
    "Toyoma Miracle Drug": 0x00da760a,
    "Hungry Devil Saucer": 0x00da760b,
    "Chowhound Saucer": 0x00da760c,
    "Lucky Mallet": 0x00da760d,
    "Straw Stalk": 0x00da760e,
    "Crystal Magatama": 0x00da760f,
    "Jade Magatama": 0x00da7610,
    "Ghoulish Seal": 0x00da7611,
    "Shura Seal": 0x00da7612,
    "Ninja Socks": 0x00da7613,
    "Ninja Socks II": 0x00da7614,
    "Clapper": 0x00da7615,
    "A Pair of Clappers": 0x00da7616,
    "Swordsmith Mallet": 0x00da7617,
    "Merchant's Abacus": 0x00da7618,
    "Imari Platter": 0x00da7619,
    "Sacred Tree Tablet": 0x00da761a,
    "Narukami Bracelet": 0x00da761b,
    "Nio Bracelet": 0x00da761c,
}

// Check if a specific cookbook has been acquired.
// return: the byte representing the book you care about
function cookbook_acquired(region, book) {
    starting_book_addr = 0
    if (region == "PAL") {
        starting_book_addr = 0x00e1d73b
    } else if (region == "NTSC") {
        starting_book_addr = 0x00da753b
    }

    for i in range(0, length(COOKBOOKS)) {
        if (COOKBOOKS[i] == book) {
            return byte(starting_book_addr + i)
        }
    }
}

COOKBOOKS = [
    "Kitchen Secrets Vol. 1",
    "Grilled Cooking Vol. 1",
    "Grilled Cooking Vol. 2",
    "Grilled Cooking Vol. 3",
    "Culinary Tips Vol. 1",
    "Kitchen Secrets Vol. 2",
    "Kitchen Secrets Vol. 3",
    "Kitchen Secrets Vol. 4",
    "Kitchen Secrets Vol. 5",
    "Hot Pot Cooking Vol. 1",
    "Culinary Tips Vol. 2",
    "Culinary Tips Vol. 3",
    "Culinary Tips Vol. 4",
    "Culinary Tips Vol. 5",
    "Hot Pot Cooking Vol. 2",
    "Hot Pot Cooking Vol. 3",
    "The Grand Hot Pot Vol. 1",
    "The Grand Hot Pot Vol. 2",
    "The Grand Hot Pot Vol. 3",
    "The Grand Hot Pot Vol. 4",
]

// Check that any blade broke during the active combat.
function any_blade_broke(region) {
    if (region == "PAL") {
        return byte(0x00e1d85c) == 0x01 || byte(0x00e1d880) == 0x01 || byte(0x00e1d8a4) == 0x01
    } else if (region == "NTSC") {
        return byte(0x00da766b) == 0x01 || byte(0x00da768f) == 0x01 || byte(0x00da76b3) == 0x01
    }
}

// Get the current level of the player.
function current_level(region) {
    if (region == "PAL") {
        return byte(ptr_character_details("PAL") + 0x1fc) + 1
    } else if (region == "NTSC") {
        return byte(ptr_character_details("NTSC") + 0x1fc) + 1
    }
}

ALL_SWORDS = [
    "Kagura Muramasa",
    "Shinmei",
    "Yakumo",
    "Hayate Muramasa",
    "Kagero Muramasa",
    "Nagasone Kotetsu",
    "Natsusame Muramasa",
    "Yunagi Muramasa",
    "Edauchi Muramasa",
    "Yoiyami Muramasa",
    "Iganokami Kanemichi",
    "Fumitsuki Muramasa",
    "Hazuki Muramasa",
    "Nagatsuki Muramasa",
    "Magoroku Kanemoto",
    "Kirisame Muramasa",
    "Asaarashi Muramasa",
    "Shigure Muramasa",
    "Amagiri Muramasa",
    "Kogarasumaru",
    "Yogetsu Muramasa",
    "Shimotsuki Muramasa",
    "Gokugetsu Muramasa",
    "Kumokiri",
    "Hibashiri Muramasa",
    "Ishizuki Muramasa",
    "Kazanami Muramasa",
    "Suiran Muramasa",
    "Osafune Kanemitsu",
    "Hisame Muramasa",
    "Mizutachi Muramasa",
    "Tanahashi Muramasa",
    "Goro Masamune",
    "Tasogare Muramasa",
    "Reimei Muramasa",
    "Gyoko Muramasa",
    "Tsubamegaeshi Muramasa",
    "Mumei Tamonoo",
    "Iwatoshi Muramasa",
    "Hiten Muramasa",
    "Meikyo Muramasa",
    "Sasanoyuki Muramasa",
    "Shusui Muramasa",
    "Nukehishaku Muramasa",
    "Chizuru Muramasa",
    "Hisui",
    "Sazanami",
    "Botan Muramasa",
    "Ayame Muramasa",
    "Hasebe Kunishige",
    "Umitsubame Muramasa",
    "Getsuei Muramasa",
    "Hibari Muramasa",
    "Tachigesa Muramasa",
    "Kashagiri Hiromitsu",
    "Mutsuki Muramasa",
    "Kisaragi Muramasa",
    "Kagetsu Muramasa",
    "Izumokami Naganori",
    "Tamatsubaki Muramasa",
    "Yamabuki Muramasa",
    "Kuchinawa Muramasa",
    "Asazakura Muramasa",
    "Ichimonji Norimune",
    "Uzuki Muramasa",
    "Satsuki Muramasa",
    "Suigetsu Muramasa",
    "Shishiou",
    "Seika Muramasa",
    "Maidori Muramasa",
    "Midarekaze Muramasa",
    "Tsukimigiri Muramasa",
    "Onikiri",
    "Shiden Muramasa",
    "Hiei Muramasa",
    "Chisuberi Muramasa",
    "Mutsunokami Yoshiyuki",
    "Suiren Muramasa",
    "Muhyo Muramasa",
    "Shiratsuyu Muramasa",
    "Tsuyuharai Muramasa",
    "Tsukiotoshi",
    "Setsugekka Muramasa",
    "Kasai Muramasa",
    "Takinomizu Muramasa",
    "Oka Muramasa",
    "Chizakura Muramasa",
    "Torinuke Muramasa",
    "Tsukuyomi Muramasa",
    "Mikazuki Munechika",
    "Amatsu Muramasa",
    "Onimaru Kunitsuna",
    "Seiryu Muramasa",
    "Byakko Muramasa",
    "Jyuzumaru Tsunetsugu",
    "Suzaku Muramasa",
    "Kamikazu Muramasa",
    "Genbu Muramasa",
    "Ouryu Muramasa",
    "Mugen Muramasa",
    "Kagotsurube Muramasa",
    "Otenta Mitsuyo",
    "Okanehira",
    "Kyoshu Muramasa",
    "Suisei Muramasa",
    "Dojigiri Yasutsuna",
    "Tokiwatari Murasa",
    "Oboro Muramasa",    
]

// Get the current number of swords owned by the player.
function num_current_swords(region) {
    cond = 0
    sword_block_start = always_false()
    if (region == "PAL") {
        sword_block_start = 0x00e1d78d
    } else if (region == "NTSC") {
        sword_block_start = 0x00da758d
    }

    for i in range(0, 107) {
        cond = cond + byte(sword_block_start + i)
    }

    return cond
}

EXCLUSIVE_MOMOHIME_SWORDS = [
    "Chizuru Muramasa",
    "Hisui",
    "Sazanami",
    "Botan Muramasa",
    "Ayame Muramasa",
    "Hasebe Kunishige",
    "Umitsubame Muramasa",
    "Getsuei Muramasa",
    "Hibari Muramasa",
    "Tachigesa Muramasa",
    "Kashagiri Hiromitsu",
    "Mutsuki Muramasa",
    "Kisaragi Muramasa",
    "Kagetsu Muramasa",
    "Izumokami Naganori",
    "Tamatsubaki Muramasa",
    "Yamabuki Muramasa",
    "Kuchinawa Muramasa",
    "Asazakura Muramasa",
    "Ichimonji Norimune",
    "Uzuki Muramasa",
    "Satsuki Muramasa",
    "Suigetsu Muramasa",
    "Shishiou",
    "Seika Muramasa",
    "Maidori Muramasa",
    "Midarekaze Muramasa",
    "Tsukimigiri Muramasa",
    "Onikiri",
    "Shiden Muramasa",
    "Hiei Muramasa",
    "Chisuberi Muramasa",
    "Mutsunokami Yoshiyuki",
    "Suiren Muramasa",
    "Muhyo Muramasa",
    "Shiratsuyu Muramasa",
    "Tsuyuharai Muramasa",
    "Tsukiotoshi",
    "Setsugekka Muramasa",
    "Kasai Muramasa",
    "Takinomizu Muramasa",
    "Oka Muramasa",
    "Chizakura Muramasa",
    "Torinuke Muramasa",
]

EXCLUSIVE_KISUKE_SWORDS = [
    "Kagura Muramasa",
    "Shinmei",
    "Yakumo",
    "Hayate Muramasa",
    "Kagero Muramasa",
    "Nagasone Kotetsu",
    "Natsusame Muramasa",
    "Yunagi Muramasa",
    "Edauchi Muramasa",
    "Yoiyami Muramasa",
    "Iganokami Kanemichi",
    "Fumitsuki Muramasa",
    "Hazuki Muramasa",
    "Nagatsuki Muramasa",
    "Magoroku Kanemoto",
    "Kirisame Muramasa",
    "Asaarashi Muramasa",
    "Shigure Muramasa",
    "Amagiri Muramasa",
    "Kogarasumaru",
    "Yogetsu Muramasa",
    "Shimotsuki Muramasa",
    "Gokugetsu Muramasa",
    "Kumokiri",
    "Hibashiri Muramasa",
    "Ishizuki Muramasa",
    "Kazanami Muramasa",
    "Suiran Muramasa",
    "Osafune Kanemitsu",
    "Hisame Muramasa",
    "Mizutachi Muramasa",
    "Tanahashi Muramasa",
    "Goro Masamune",
    "Tasogare Muramasa",
    "Reimei Muramasa",
    "Gyoko Muramasa",
    "Tsubamegaeshi Muramasa",
    "Mumei Tamonoo",
    "Iwatoshi Muramasa",
    "Hiten Muramasa",
    "Meikyo Muramasa",
    "Sasanoyuki Muramasa",
    "Shusui Muramasa",
    "Nukehishaku Muramasa",
]

LAIR_SWORDS = [
    "Jyuzumaru Tsunetsugu",
    "Otenta Mitsuyo",
    "Okanehira",
    "Dojigiri Yasutsuna"
]

// Get the current number of swords exclusive to the given character.
// "Exclusive" means you do not have to play the other character in any circumstance to get these swords.
function num_exclusive_swords(region, character) {
    exclusive_swords = []
    if (character == "Momohime") {
        exclusive_swords = EXCLUSIVE_MOMOHIME_SWORDS
    } else if (character == "Kisuke") {
        exclusive_swords = EXCLUSIVE_KISUKE_SWORDS
    }

    sword_block_start = always_false()
    if (region == "PAL") {
        sword_block_start = 0x00e1d78d
    } else if (region == "NTSC") {
        sword_block_start = 0x00da758d
    }

    cond = 0
    for i in range(0, 107) {
        for sword in exclusive_swords {
            if (sword == ALL_SWORDS[i]) { 
                cond = cond + byte(sword_block_start + i)
            }
        }
    }

    return cond
}

// Get the current number of swords hidden behind lairs.
function num_blades_from_lairs(region) {
    sword_block_start = 0
    if (region == "PAL") {
        sword_block_start = 0x00e1d78d
    } else if (region == "NTSC") {
        sword_block_start = 0x00da758d
    }

    cond = 0
    for i in range(0, 107) {
        for sword in LAIR_SWORDS {
            if (sword == ALL_SWORDS[i]) { 
                cond = cond + byte(sword_block_start + i)
            }
        }
    }

    return cond
}

// Get the current number of recipes that the player has learned.
function num_current_recipes(region) {
    cond = 0
    for book in COOKBOOKS {
        cond = cond + cookbook_acquired(region, book)
    }

    return cond
}

// Get the current number of accessories that the player has gotten.
function num_current_accessories(region) {
    cond = 0

    for accessory in ACCESSORY_BLOCK_ONE {
        cond = cond + accessory_acquired(region, accessory)

    }

    for accessory in ACCESSORY_BLOCK_TWO {
        cond = cond + accessory_acquired(region, accessory)
    }

    return cond
}

function current_ryo(region) {
    if (region == "PAL") {
        return dword_be(ptr_character_details("PAL") + 0x1f0) / 10000
    } else if (region == "NTSC") {
        return dword_be(ptr_character_details("NTSC") + 0x1f0) / 10000
    }
} 

function current_mon(region) {
    if (region == "PAL") {
        return dword_be(ptr_character_details("PAL") + 0x1f0) % 10000
    } else if (region == "NTSC") {
        return dword_be(ptr_character_details("NTSC") + 0x1f0) % 10000
    }
}

achievement(
    id = 579985,
    title = "Haunted Once More",
    description = "[Momohime] Bring Momohime to Jinkuro and defend her body from the Blue Monk's assault to clear the Opening Act.",
    points = 3,
    type = "progression",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && in_zone("NTSC", "Blue Monk")
            && prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00) 
            && sword_acquired("NTSC", "Hasebe Kunishige") == 0x01)
        ||
            (is_pal()
                && is_in_game("PAL")
                && active_character("PAL") == 0x01 
                && in_zone("PAL", "Blue Monk")
                && prev(sword_acquired("PAL", "Hasebe Kunishige") == 0x00) 
                && sword_acquired("PAL", "Hasebe Kunishige") == 0x01)
)

achievement(
    id = 579986,
    title = "Collateral Freedom",
    description = "[Momohime] Track down Momohime's soul all the way to Musashi and forcefully take it back from Wanyudo to clear Act 2.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc() 
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && in_zone("NTSC", "Wanyudo")
            && prev(sword_acquired("NTSC", "Kashagiri Hiromitsu")) == 0x00 
            && sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x01)
        ||
            (is_pal() 
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && in_zone("PAL", "Wanyudo")
            && prev(sword_acquired("PAL", "Kashagiri Hiromitsu")) == 0x00 
            && sword_acquired("PAL", "Kashagiri Hiromitsu") == 0x01)
)

achievement(
    id = 579987,
    title = "The Princess' Plea",
    description = "[Momohime] Ask Yukinojyo about the Kuromitsu blade and survive a fight against the Shinkage Style to clear Act 3.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Yukinojyo")
        && prev(sword_acquired("NTSC", "Izumokami Naganori")) == 0x00
        && sword_acquired("NTSC", "Izumokami Naganori") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Yukinojyo")
        && prev(sword_acquired("PAL", "Izumokami Naganori")) == 0x00
        && sword_acquired("PAL", "Izumokami Naganori") == 0x01)
)

achievement(
    id = 579988,
    title = "The Foot of a Mystic Boar",
    description = "[Momohime] Travel towards Mino through the mountains of Takayama and defeat Ippondatara to learn a well guarded secret to clear Act 4.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01
            && in_zone("NTSC", "Ippondatara")
            && prev(sword_acquired("NTSC", "Ichimonji Norimune")) == 0x00
            && sword_acquired("NTSC", "Ichimonji Norimune") == 0x01)
        ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Ippondatara")
            && prev(sword_acquired("PAL", "Ichimonji Norimune")) == 0x00
            && sword_acquired("PAL", "Ichimonji Norimune") == 0x01)
)

achievement(
    id = 579989,
    title = "Disgraced Traitor Exposed",
    description = "[Momohime] Infiltrate Narukami castle and get your hands on Shikami Danjo and his chimera to clear Act 5.",
    points = 10,
    type = "progression",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01
            && in_zone("NTSC", "Chimera")
            && prev(sword_acquired("NTSC", "Shishiou")) == 0x00
            && sword_acquired("NTSC", "Shishiou") == 0x01)
        ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Chimera")
            && prev(sword_acquired("PAL", "Shishiou")) == 0x00
            && sword_acquired("PAL", "Shishiou") == 0x01)
)

achievement(
    id = 579990,
    title = "Served Fresh",
    description = "[Momohime] Descend into hell only to get swallowed raw. Get yourself out of trouble to clear Act 6.",
    points = 10,
    type = "progression",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Big Oni")
        && prev(sword_acquired("NTSC", "Onikiri")) == 0x00
        && sword_acquired("NTSC", "Onikiri") == 0x01)
    ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Big Oni")
            && prev(sword_acquired("PAL", "Onikiri")) == 0x00
            && sword_acquired("PAL", "Onikiri") == 0x01)
)

achievement(
    id = 579991,
    title = "Knock Knock Knockin' on Heaven's Door", 
    description = "[Momohime] Seek a way into heaven and entertain the gatekeeper to clear Act 7.",
    points = 10,
    type = "progression",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Raijin")
        && prev(sword_acquired("NTSC", "Mutsunokami Yoshiyuki")) == 0x00
        && sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Raijin")
        && prev(sword_acquired("PAL", "Mutsunokami Yoshiyuki")) == 0x00
        && sword_acquired("PAL", "Mutsunokami Yoshiyuki") == 0x01)
)


achievement(
    id = 579992,
    title = "A Whole Body to Yourself",
    description = "[Momohime] Climb the Buddha Statue Hall, face heavenly forces of epic proportions and have Momohime finally freed from possession to clear the Final Act.",
    points = 25,
    type = "progression",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x34
        && prev(sword_acquired("NTSC", "Tsukiotoshi")) == 0x00
        && sword_acquired("NTSC", "Tsukiotoshi") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x34
        && prev(sword_acquired("PAL", "Tsukiotoshi")) == 0x00
        && sword_acquired("PAL", "Tsukiotoshi") == 0x01)
)

achievement(
    id = 582443,
    title = "A Mysterious Foe",
    description = "Equip Mumei Tamanoo and Tsukiotoshi as Momohime and defeat the new boss in Fudo-Myoou's room.",
    points = 10,
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01
            && in_zone("NTSC", "Kisuke")
            && prev(sword_acquired("NTSC", "Onimaru Kunitsuna")) == 0x00
            && sword_acquired("NTSC", "Onimaru Kunitsuna") == 0x01) 
        || 
            (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Kisuke")
            && prev(sword_acquired("PAL", "Onimaru Kunitsuna")) == 0x00
            && sword_acquired("PAL", "Onimaru Kunitsuna") == 0x01)
)

achievement(
    id = 579995,
    title = "Deadly Oboro Arts",
    description = "Forge and collect every blade unique to Momohime.",
    points = 10,
    trigger = (is_ntsc()
            && prev(num_exclusive_swords("NTSC", "Momohime")) == length(EXCLUSIVE_MOMOHIME_SWORDS) - 1
            && measured(num_exclusive_swords("NTSC", "Momohime") == length(EXCLUSIVE_MOMOHIME_SWORDS), when=is_ntsc(), format="raw"))
    || 
        (is_pal()
            && prev(num_exclusive_swords("PAL", "Momohime")) == length(EXCLUSIVE_MOMOHIME_SWORDS) - 1
            && measured(num_exclusive_swords("PAL", "Momohime") == length(EXCLUSIVE_MOMOHIME_SWORDS), when=is_pal(), format="raw"))
)

achievement(
    id = 579996,
    title = "Blades of the Amnesiac",
    description = "Forge and collect every blade unique to Kisuke.",
    points = 10,
    trigger = (is_ntsc() 
        && prev(num_exclusive_swords("NTSC", "Kisuke")) == length(EXCLUSIVE_KISUKE_SWORDS) - 1
        && measured(num_exclusive_swords("NTSC", "Kisuke") == length(EXCLUSIVE_KISUKE_SWORDS), when=is_ntsc(), format="raw"))
    ||
        (is_pal() 
            && prev(num_exclusive_swords("PAL", "Kisuke")) == length(EXCLUSIVE_KISUKE_SWORDS) - 1
            && measured(num_exclusive_swords("PAL", "Kisuke") == length(EXCLUSIVE_KISUKE_SWORDS), when=is_pal(), format="raw"))
)

achievement(
    id = 582442,
    title = "Unlimited Muramasa Works",
    description = "Obtain all demon blades from lairs.",
    points = 5,
    trigger = (is_ntsc()
        && prev(num_blades_from_lairs("NTSC")) == length(LAIR_SWORDS) - 1
        && measured(num_blades_from_lairs("NTSC") == length(LAIR_SWORDS), when=is_ntsc(), format="raw"))
    ||
        (is_pal()
        && prev(num_blades_from_lairs("PAL")) == length(LAIR_SWORDS) - 1
        && measured(num_blades_from_lairs("PAL") == length(LAIR_SWORDS), when=is_pal(), format="raw"))
)

achievement(
    id = 579993,
    title = "The Destroyer of Fate",
    description = "Forge the Oboro Muramasa after collecting every other blade.",
    points = 25,
    trigger = (is_ntsc()
            && prev(num_current_swords("NTSC")) == length(ALL_SWORDS) - 1
            && measured(num_current_swords("NTSC") == length(ALL_SWORDS), when=is_ntsc(), format="raw")) 
    ||
        (is_pal()
            && prev(num_current_swords("PAL")) == length(ALL_SWORDS) - 1
            && measured(num_current_swords("PAL") == length(ALL_SWORDS), when=is_pal(), format="raw"))
)

achievement(
    id = 583618,
    title = "Oboro Massacre, Peach Flavored",
    description = "Equip the Oboro Muramasa as Momohime and defeat Fudo-Myoou.",
    points = 5,
    trigger = (is_ntsc() 
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x36
        && active_screen("NTSC") == 0x0b
        // character HP is above 0
        && dword_be(ptr_character_details("NTSC") + 0x1d8) > 0
        // results screen timer is initialized
        && results_screen_present("NTSC")
        // && prev(dword_be(results_screen_ptr("NTSC") + 0x4c4)) == 0x00
        // && dword_be(results_screen_ptr("NTSC") + 0x4c4) > 0x00)
    )
    || 
        (is_pal() 
        && is_in_game("PAL")
        && active_zone("PAL") == 0x36
        && active_screen("PAL") == 0x0b
        // character HP is above 0
        && dword_be(ptr_character_details("PAL") + 0x1d8) > 0
        // results screen timer is initialized
        && results_screen_present("PAL")
        // && prev(dword_be(results_screen_ptr("PAL") + 0x4c4)) == 0x00
        // && dword_be(results_screen_ptr("PAL") + 0x4c4) > 0x00)
        )
)

// *** Lairs ***
achievement(
    id = 580608,
    title = "100 Armed Monks",
    description = "Clear the red enemy lair in Musashi on Shura or Shigurui difficulty.",
    points = 3,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Musashi")
        && active_screen("NTSC") == 0x1e
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Musashi")
        && active_screen("PAL") == 0x1e
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580611,
    title = "100 Incarnations of Shadowy Ninja",
    description = "Clear the enemy lair in Yamashiro on Shura or Shigurui difficulty.",
    points = 3,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Yamashiro")
        && active_screen("NTSC") == 0x3a
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
            && in_zone("PAL", "Yamashiro")
            && active_screen("PAL") == 0x3a
            && current_difficulty("PAL") == 0x01
            // character HP is above 0
            && results_screen_present("PAL"))
)

achievement(
    id = 580612,
    title = "God of Pestilence",
    description = "Clear the enemy lair in Owari on Shura or Shigurui difficulty.",
    points = 3,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Owari")
        && active_screen("NTSC") == 0x0f
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
            && in_zone("PAL", "Owari")
            && active_screen("PAL") == 0x0f
            && current_difficulty("PAL") == 0x01
            // character HP is above 0
            && results_screen_present("PAL"))
)

achievement(
    id = 580613,
    title = "Mountain Kagura Dance, the Storm of Tengu",
    description = "Clear the enemy lair in Totomi on Shura or Shigurui difficulty.",
    points = 5,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Totomi")
        && active_screen("NTSC") == 0x10
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
            && in_zone("PAL", "Totomi")
            && active_screen("PAL") == 0x10
            && current_difficulty("PAL") == 0x01
            // character HP is above 0
            && results_screen_present("PAL"))
)

achievement(
    id = 580614,
    title = "Toad of Yoro Falls",
    description = "Clear the enemy lair in Mino on Shura or Shigurui difficulty.",
    points = 5,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Mino")
        && active_screen("NTSC") == 0x1d
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Mino")
        && active_screen("PAL") == 0x1d
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580615,
    title = "Seven Samurai",
    description = "Clear the enemy lair in Mikawa on Shura or Shigurui difficulty.",
    points = 5,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Mikawa")
        && active_screen("NTSC") == 0x0d
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Mikawa")
        && active_screen("PAL") == 0x0d
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580610,
    title = "Snow Woman, Oiran Procession",
    description = "Clear the enemy lair in Hida on Shura or Shigurui difficulty.",
    points = 5,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Hida")
        && active_screen("NTSC") == 0x0e
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Hida")
        && active_screen("PAL") == 0x0e
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580616,
    title = "Courage in the Ghostly Hour",
    description = "Clear the enemy lair in Sagami on Shura or Shigurui difficulty.",
    points = 5,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Sagami")
        && active_screen("NTSC") == 0x11
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Sagami")
        && active_screen("PAL") == 0x11
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580618,
    title = "Ozaru Stealth Army",
    description = "Clear the enemy lair in Iga on Shura or Shigurui difficulty.",
    points = 5,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Iga")
        && active_screen("NTSC") == 0x13
        && current_difficulty("NTSC") == 0x01
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Iga")
        && active_screen("PAL") == 0x13
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580617,
    title = "Wildlife Caricature",
    description = "Clear the enemy lair in Kai on Shura or Shigurui difficulty.",
    points = 10,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Kai")
        && active_screen("NTSC") == 0x12
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Kai")
        && active_screen("PAL") == 0x12
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580619,
    title = "The Scheming Yagyuu Clan",
    description = "Clear the enemy lair in Yamato on Shura or Shigurui difficulty.",
    points = 10,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Yamato")
        && active_screen("NTSC") == 0x19
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Yamato")
        && active_screen("PAL") == 0x19
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580620,
    title = "Giant Centipede of the Suzuka Pass",
    description = "Clear the enemy lair in Ise on Shura or Shigurui difficulty.",
    points = 3,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Ise")
        && active_screen("NTSC") == 0x16
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Ise")
        && active_screen("PAL") == 0x16
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580621,
    title = "Rising Dragon, Lying Dragon",
    description = "Clear the enemy lair in Suruga on Shura or Shigurui difficulty.",
    points = 10,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Suruga")
        && active_screen("NTSC") == 0x19
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Suruga")
        && active_screen("PAL") == 0x19
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580622,
    title = "Lair of the Oni",
    description = "Clear the enemy lair in Omi on Shura or Shigurui difficulty.",
    points = 10,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Omi")
        && active_screen("NTSC") == 0x10
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Omi")
        && active_screen("PAL") == 0x10
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

// Two-phase lair, first screen is 0x15 and second is 0x16
// This achievement checks for the reward screen on the second screen
achievement(
    id = 580623,
    title = "Ghost of the Battle Field",
    description = "Clear the enemy lair in Shinano on Shura or Shigurui difficulty.",
    points = 10,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Shinano")
        && active_screen("NTSC") == 0x16
        && current_difficulty("NTSC") == 0x01
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Shinano")
        && active_screen("PAL") == 0x16
        && current_difficulty("PAL") == 0x01
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580624,
    title = "Total Pandemonium",
    description = "Clear the enemy lair in Izu on any difficulty.",
    points = 25,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Izu")
        && active_screen("NTSC") == 0x14
        // character HP is above 0
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Izu")
        && active_screen("PAL") == 0x14
        // character HP is above 0
        && results_screen_present("PAL"))
)

achievement(
    id = 580609,
    title = "Accessories of Edo",
    description = "Collect all 55 accessories on either character.",
    points = 25,
    trigger = (is_ntsc()
        && prev(num_current_accessories("NTSC")) == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO) - 1
        && measured(num_current_accessories("NTSC") == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO), when=is_ntsc()))
    || 
        (is_pal()
            && prev(num_current_accessories("PAL")) == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO) - 1
            && measured(num_current_accessories("PAL") == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO), when=is_pal()))
)

achievement(
    id = 579994,
    title = "You'll Never Go Hungry Again",
    description = "Learn all 20 recipes on either character.",
    points = 10,
    trigger = (is_ntsc()
        && prev(num_current_recipes("NTSC")) == length(COOKBOOKS) - 1
        && measured(num_current_recipes("NTSC") == length(COOKBOOKS), when=is_ntsc()))
    ||
        (is_pal()
        && prev(num_current_recipes("PAL") == length(COOKBOOKS) - 1)
        && measured(num_current_recipes("PAL") == length(COOKBOOKS), when=is_pal()))
)

achievement(
    id = 584165,
    title = "Sealing the Cyclops Away",
    description = "As either character, return to the Blue Monk's boss arena and defeat him again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Blue Monk")
            && prev(accessory_acquired("NTSC", "Shura Seal")) == 0x00
            && accessory_acquired("NTSC", "Shura Seal") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Blue Monk")
            && prev(accessory_acquired("PAL", "Shura Seal")) == 0x00
            && accessory_acquired("PAL", "Shura Seal") == 0x01)
)

achievement(
    id = 584166,
    title = "Stopping the Wheel in Its Tracks",
    description = "As either character, return to Wanyudo's boss arena and defeat it again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Wanyudo")
            && prev(accessory_acquired("NTSC", "A Pair of Clappers")) == 0x00
            && accessory_acquired("NTSC", "A Pair of Clappers") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Wanyudo")
            && prev(accessory_acquired("PAL", "A Pair of Clappers")) == 0x00
            && accessory_acquired("PAL", "A Pair of Clappers") == 0x01)
)

achievement(
    id = 584167,
    title = "Long-Awaited Rematch",
    description = "As either character, return to Yukinojyo's boss arena and defeat him again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Yukinojyo")
            && prev(accessory_acquired("NTSC", "Dragon God Gauntlet")) == 0x00
            && accessory_acquired("NTSC", "Dragon God Gauntlet") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Yukinojyo")
            && prev(accessory_acquired("PAL", "Dragon God Gauntlet")) == 0x00
            && accessory_acquired("PAL", "Dragon God Gauntlet") == 0x01)
)

achievement(
    id = 584168,
    title = "Hot Springs World Tour",
    description = "As either character, return to Ippondatara's boss arena and defeat him again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Ippondatara")
            && prev(accessory_acquired("NTSC", "Izumo Charm")) == 0x00
            && accessory_acquired("NTSC", "Izumo Charm") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Ippondatara")
            && prev(accessory_acquired("PAL", "Izumo Charm")) == 0x00
            && accessory_acquired("PAL", "Izumo Charm") == 0x01)
)

achievement(
    id = 584169,
    title = "Taming the Rogue Beast",
    description = "As either character, return to the Chimera's boss arena and defeat it again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Chimera")
            && prev(accessory_acquired("NTSC", "Jade Magatama")) == 0x00
            && accessory_acquired("NTSC", "Jade Magatama") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Chimera")
            && prev(accessory_acquired("PAL", "Jade Magatama")) == 0x00
            && accessory_acquired("PAL", "Jade Magatama") == 0x01)
)

achievement(
    id = 584170,
    title = "Forgot Something Down Here",
    description = "As either character, return to the Big Oni's boss arena and defeat it again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Big Oni")
            && prev(accessory_acquired("NTSC", "Dragon God Mask")) == 0x00
            && accessory_acquired("NTSC", "Dragon God Mask") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Big Oni")
            && prev(accessory_acquired("PAL", "Dragon God Mask")) == 0x00
            && accessory_acquired("PAL", "Dragon God Mask") == 0x01)
)

achievement(
    id = 584171,
    title = "Casually Ascending, Once Again",
    description = "As either character, return to Raijin's boss arena and defeat her again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Raijin")
            && prev(accessory_acquired("NTSC", "Sacred Tree Tablet")) == 0x00
            && accessory_acquired("NTSC", "Sacred Tree Tablet") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Raijin")
            && prev(accessory_acquired("PAL", "Sacred Tree Tablet")) == 0x00
            && accessory_acquired("PAL", "Sacred Tree Tablet") == 0x01)
)

achievement(
    id = 584172,
    title = "Could Always Use More Socks",
    description = "As either character, return to Kurozaru's boss arena and defeat him again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Kurozaru")
            && prev(accessory_acquired("NTSC", "Ninja Socks II")) == 0x00
            && accessory_acquired("NTSC", "Ninja Socks II") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Kurozaru")
            && prev(accessory_acquired("PAL", "Ninja Socks II")) == 0x00
            && accessory_acquired("PAL", "Ninja Socks II") == 0x01)
)

achievement(
    id = 584173,
    title = "The Exterminator's In Town",
    description = "As either character, return to the Giant Centipede's boss arena and defeat them again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Giant Centipede")
            && prev(accessory_acquired("NTSC", "Imari Platter")) == 0x00
            && accessory_acquired("NTSC", "Imari Platter") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Giant Centipede")
            && prev(accessory_acquired("PAL", "Imari Platter")) == 0x00
            && accessory_acquired("PAL", "Imari Platter") == 0x01)
)

achievement(
    id = 584174,
    title = "Bringing the Spectral Steed to Heel",
    description = "As either character, return to Torahime's boss arena and defeat her again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Torahime")
            && prev(accessory_acquired("NTSC", "Dragon God Belt")) == 0x00
            && accessory_acquired("NTSC", "Dragon God Belt") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Torahime")
            && prev(accessory_acquired("PAL", "Dragon God Belt")) == 0x00
            && accessory_acquired("PAL", "Dragon God Belt") == 0x01)
)

achievement(
    id = 584175,
    title = "Excising These Hills",
    description = "As either character, return to Sayo's boss arena and defeat her again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Sayo")
            && prev(accessory_acquired("NTSC", "Merchant's Abacus")) == 0x00
            && accessory_acquired("NTSC", "Merchant's Abacus") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Sayo")
            && prev(accessory_acquired("PAL", "Merchant's Abacus")) == 0x00
            && accessory_acquired("PAL", "Merchant's Abacus") == 0x01)
)

achievement(
    id = 584176,
    title = "Controlling the Arachnid Population",
    description = "As either character, return to Tsuchigumo's boss arena and defeat it again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Tsuchigumo")
            && prev(accessory_acquired("NTSC", "Cloisonne Rosary")) == 0x00
            && accessory_acquired("NTSC", "Cloisonne Rosary") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Tsuchigumo")
            && prev(accessory_acquired("PAL", "Cloisonne Rosary")) == 0x00
            && accessory_acquired("PAL", "Cloisonne Rosary") == 0x01)
)

achievement(
    id = 584177,
    title = "Clearing the Battlefield of Stragglers",
    description = "As either character, return to Chigurui Bishamon's boss arena and defeat it again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Chigurui Bishamon")
            && prev(accessory_acquired("NTSC", "Iwami Poison")) == 0x00
            && accessory_acquired("NTSC", "Iwami Poison") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Chigurui Bishamon")
            && prev(accessory_acquired("PAL", "Iwami Poison")) == 0x00
            && accessory_acquired("PAL", "Iwami Poison") == 0x01)
)

achievement(
    id = 584178,
    title = "Throwing Down with a God For Fun",
    description = "As either character, return to the Dragon God's boss arena and defeat it again.",
    points = 3,
    trigger = (is_ntsc() 
            && in_zone("NTSC", "Dragon God")
            && prev(accessory_acquired("NTSC", "Nio Bracelet")) == 0x00
            && accessory_acquired("NTSC", "Nio Bracelet") == 0x01)
    ||
            (is_pal() 
            && in_zone("PAL", "Dragon God")
            && prev(accessory_acquired("PAL", "Nio Bracelet")) == 0x00
            && accessory_acquired("PAL", "Nio Bracelet") == 0x01)
)

achievement(
    id = 580609,
    title = "Accessories of Edo",
    description = "Collect all 55 accessories on either character.",
    points = 25,
    trigger = (is_ntsc()
        && prev(num_current_accessories("NTSC")) == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO) - 1
        && measured(num_current_accessories("NTSC") == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO), when=is_ntsc()))
    || 
        (is_pal()
            && prev(num_current_accessories("PAL")) == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO) - 1
            && measured(num_current_accessories("PAL") == length(ACCESSORY_BLOCK_ONE) + length(ACCESSORY_BLOCK_TWO), when=is_pal()))
)

achievement(
    id = 583619,
    title = "Fated Meeting in an Unlikely Place",
    description = "As Momohime, find Kisuke in a hot spring.",
    points = 1,
    trigger = (is_ntsc()
        && is_active_character("NTSC", "Momohime")
        && in_zone("NTSC", "Onsen")
        && (
            (prev(hot_spring_phase("NTSC", "Momohime")) == 0x01 && hot_spring_phase("NTSC", "Momohime") == 0x02)
            || (prev(hot_spring_phase("NTSC", "Momohime")) == 0x02 && hot_spring_phase("NTSC", "Momohime") == 0x03)
            || (prev(hot_spring_phase("NTSC", "Momohime")) == 0x03 && hot_spring_phase("NTSC", "Momohime") == 0x04)
        )
    ) || 
    (is_pal()
        && is_active_character("PAL", "Momohime")
        && in_zone("PAL", "Onsen")
        && (
            (prev(hot_spring_phase("PAL", "Momohime")) == 0x01 && hot_spring_phase("PAL", "Momohime") == 0x02)
            || (prev(hot_spring_phase("PAL", "Momohime")) == 0x02 && hot_spring_phase("PAL", "Momohime") == 0x03)
            || (prev(hot_spring_phase("PAL", "Momohime")) == 0x03 && hot_spring_phase("PAL", "Momohime") == 0x04)
        )
    )
)

achievement(
    id = 583620,
    title = "Onsen Surprise",
    description = "As Kisuke, find Momohime in a hot spring.",
    points = 1,
    trigger = (is_ntsc()
        && is_active_character("NTSC", "Kisuke")
        && in_zone("NTSC", "Onsen")
        && (
            (prev(hot_spring_phase("NTSC", "Kisuke")) == 0x01 && hot_spring_phase("NTSC", "Kisuke") == 0x02)
            || (prev(hot_spring_phase("NTSC", "Kisuke")) == 0x03 && hot_spring_phase("NTSC", "Kisuke") == 0x04)
        )
    )
    || (is_pal()
        && is_active_character("PAL", "Kisuke")
        && in_zone("PAL", "Onsen")
        && (
            (prev(hot_spring_phase("PAL", "Kisuke")) == 0x01 && hot_spring_phase("PAL", "Kisuke") == 0x02) 
            || (prev(hot_spring_phase("PAL", "Kisuke")) == 0x03 && hot_spring_phase("PAL", "Kisuke") == 0x04) 
        )
    )
)

achievement(
    id = 583621,
    title = "A Combo of Deadly Proportions", 
    points = 3,
    description = "Achieve a combo of 200 or higher in any fight.",
    trigger = (is_in_game("NTSC")
            && dword_be(active_combat_pointer("NTSC") + 0x80) < 0x3e8
            // Combo counter can go up by more than 1 at once, so we just want to be in the ballpark
            // For now, ballpark is [185, 215]
            && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0xb9
            && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0xc8
            && dword_be(active_combat_pointer("NTSC") + 0x80) >= 0xc8
            && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0xd7)
        ||
            (is_in_game("PAL")
                && dword_be(active_combat_pointer("PAL") + 0x80) < 0x3e8
                // Combo counter can go up by more than 1 at once, so we just want to be in the ballpark
                // For now, ballpark is [185, 215]
                && prev(dword_be(active_combat_pointer("PAL") + 0x80)) >= 0xb9
                && prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0xc8
                && dword_be(active_combat_pointer("PAL") + 0x80) >= 0xc8
                && dword_be(active_combat_pointer("PAL") + 0x80) <= 0xd7)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - Shigurui speedrun. Hits 72, 78, 39
// https://www.twitch.tv/videos/1501958318 - 210 
achievement(
    id = 582475,
    title = "Haunting Combo",
    description = "Achieve a combo of 75 or higher and defeat the Blue Monk to clear Act 1 on Shura or Shigurui difficulty.",
    type = "missable",
    points = 3,
    trigger = (never(is_ntsc() && !in_zone("NTSC", "Blue Monk"))
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && current_difficulty("NTSC") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0x4b 
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0x4b
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) <= 0x55 // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00)
            && trigger_when(sword_acquired("NTSC", "Hasebe Kunishige") == 0x01))
        ||
            (never(is_pal() && !in_zone("PAL", "Blue Monk"))
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && current_difficulty("PAL") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0x4b 
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) >= 0x4b
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) <= 0x55 // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("PAL", "Hasebe Kunishige") == 0x00)
            && trigger_when(sword_acquired("PAL", "Hasebe Kunishige") == 0x01))
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - Shigurui speedrun. Hits 47, 51, 2x, 47, 34
// https://www.twitch.tv/videos/1501958318 - 15, 6, 11, 52, 57, 1, 32
achievement(
    id = 583622,
    title = "Freewheeling",
    description = "Achieve a combo of 75 or higher and defeat Wanyudo to clear Act 2 on Shura or Shigurui difficulty.",
    points = 5, 
    type = "missable",
    trigger = (never(is_ntsc() && !in_zone("NTSC", "Wanyudo"))
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && current_difficulty("NTSC") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0x4b 
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0x4b
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) <= 0x55 // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x00)
            && trigger_when(sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x01))
        ||
            (never(is_pal() && !in_zone("PAL", "Wanyudo"))
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && current_difficulty("PAL") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0x4b 
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) >= 0x4b
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) <= 0x55 // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("PAL", "Kashagiri Hiromitsu") == 0x00)
            && trigger_when(sword_acquired("PAL", "Kashagiri Hiromitsu") == 0x01))
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - Shigurui speedrun. Hits 14, ?, 10, 41, 13, 37, ?, 40
// https://www.twitch.tv/videos/1501958318 - 
achievement(
    id = 583623,
    title = "Sending Swords Swimming",
    description = "Achieve a combo of 50 or higher and defeat Yukinojyo to clear Act 3 on Shura or Shigurui difficulty.",
    points = 5,
    type = "missable",
    trigger = (never(is_ntsc() && !in_zone("NTSC", "Yukinojyo"))
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && current_difficulty("NTSC") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0x32 
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0x32
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) <= 0x3c // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("NTSC", "Izumokami Naganori") == 0x00)
            && trigger_when(sword_acquired("NTSC", "Izumokami Naganori") == 0x01))
        ||
            (never(is_pal() && !in_zone("PAL", "Yukinojyo"))
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && current_difficulty("PAL") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0x32 
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) >= 0x32
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) <= 0x3c // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("PAL", "Izumokami Naganori") == 0x00)
            && trigger_when(sword_acquired("PAL", "Izumokami Naganori") == 0x01))
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 47, 53, 2x, 5, 5, 10
// https://www.twitch.tv/videos/1501958318 - 50, 4, 2, 3, 3, 31, 
// https://www.youtube.com/watch?v=bYkpF9zNyUI - 25, 26, 11, 19, 29
// https://www.youtube.com/watch?v=wQEnYBohJzY - 20, 21, 
achievement(
    id = 583860,
    title = "The Hand of a Protective Deity",
    description = "Achieve a combo of 50 or higher and defeat Ippondatara to clear Act 4 on Shura or Shigurui difficulty.",
    points = 5,
    type = "missable",
    trigger = (never(is_ntsc() && !in_zone("NTSC", "Ippondatara"))
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && current_difficulty("NTSC") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0x32 
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0x32
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) <= 0x3c // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("NTSC", "Ichimonji Norimune") == 0x00)
            && trigger_when(sword_acquired("NTSC", "Ichimonji Norimune") == 0x01))
        ||
            (never(is_pal() && !in_zone("PAL", "Ippondatara"))
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && current_difficulty("PAL") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0x32 
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) >= 0x32
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) <= 0x3c // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("PAL", "Ichimonji Norimune") == 0x00)
            && trigger_when(sword_acquired("PAL", "Ichimonji Norimune") == 0x01))
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 53, 30, 14, 
// https://www.twitch.tv/videos/1501958318 - 65, 30, 8, death, 53, 23,16, 8,4, 31, 3
achievement(
    id = 583862,
    title = "Truly Traitorous Form",
    description = "Achieve a combo of 50 or higher and defeat the Chimera to clear Act 5 on Shura or Shigurui difficulty.",
    points = 5,
    type = "missable",
    trigger = (never(is_ntsc() && !in_zone("NTSC", "Chimera"))
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && current_difficulty("NTSC") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0x32 
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0x32
                    && (dword_be(active_combat_pointer("NTSC") + 0x80)) <= 0x3c // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("NTSC", "Shishiou") == 0x00)
            && trigger_when(sword_acquired("NTSC", "Shishiou") == 0x01))
        ||
            (never(is_pal() && !in_zone("PAL", "Chimera"))
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && current_difficulty("PAL") == 0x01
            && trigger_when(
                once(
                    prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0x32 
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) >= 0x32
                    && (dword_be(active_combat_pointer("PAL") + 0x80)) <= 0x3c // buffer in case somehow 2+ hits in a combo are registered at once
                )
            )
            // the trigger as before
            && prev(sword_acquired("PAL", "Shishiou") == 0x00)
            && trigger_when(sword_acquired("PAL", "Shishiou") == 0x01))
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 25, 3, 37, 4, 35, 10, 32
// https://www.twitch.tv/videos/1501958318 - 38, 15, 19, 40, 14, 34
// https://www.youtube.com/watch?v=44JoHndPWto - 71
achievement(
    id = 583863,
    title = "A Meal Better Eaten Whole",
    // 60 is too low because of the adds, find a video to corroborate that isn't a speedrun but you can probably float 66-70
    // maybe 66 as a "haha funny hell ish number"
    description = "Achieve a combo of 66 or higher and defeat the Big Oni to clear Act 6 on Shura or Shigurui difficulty.",
    points = 5,
    type = "missable",
    trigger = (never(is_ntsc() && !in_zone("NTSC", "Big Oni"))
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01 
        && current_difficulty("NTSC") == 0x01
        && trigger_when(
            once(
                prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0x42 
                && (dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0x42
                && (dword_be(active_combat_pointer("NTSC") + 0x80)) <= 0x4c // buffer in case somehow 2+ hits in a combo are registered at once
            )
        )
        // the trigger as before
        && prev(sword_acquired("NTSC", "Onikiri") == 0x00)
        && trigger_when(sword_acquired("NTSC", "Onikiri") == 0x01))

    ||
        (never(is_pal() && !in_zone("PAL", "Big Oni"))
        && is_in_game("PAL")
        && active_character("PAL") == 0x01 
        && current_difficulty("PAL") == 0x01
        && trigger_when(
            once(
                prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0x42 
                && (dword_be(active_combat_pointer("PAL") + 0x80)) >= 0x42
                && (dword_be(active_combat_pointer("PAL") + 0x80)) <= 0x4c // buffer in case somehow 2+ hits in a combo are registered at once
            )
        )
        // the trigger as before
        && prev(sword_acquired("PAL", "Onikiri") == 0x00)
        && trigger_when(sword_acquired("PAL", "Onikiri") == 0x01))
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 19, 5, 114, 55
// https://www.twitch.tv/videos/1501958318 - 53, 57, 29, 56, 27
achievement(
    id = 583888,
    title = "Thunderous Performance",
    description = "Achieve a combo of 100 or higher and defeat Raijin to clear Act 7 on Shura or Shigurui difficulty.",
    points = 10,
    type = "missable",
    trigger = (never(is_ntsc() && !in_zone("NTSC", "Raijin"))
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01 
        && current_difficulty("NTSC") == 0x01
        && trigger_when(
            once(
                prev(dword_be(active_combat_pointer("NTSC") + 0x80)) < 0x64 
                && (dword_be(active_combat_pointer("NTSC") + 0x80)) >= 0x64
                && (dword_be(active_combat_pointer("NTSC") + 0x80)) <= 0x6e // buffer in case somehow 2+ hits in a combo are registered at once
            )
        )
        // the trigger as before
        && prev(sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x00)
        && trigger_when(sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x01))
    ||
        (never(is_pal() && !in_zone("PAL", "Raijin"))
        && is_in_game("PAL")
        && active_character("PAL") == 0x01 
        && current_difficulty("PAL") == 0x01
        && trigger_when(
            once(
                prev(dword_be(active_combat_pointer("PAL") + 0x80)) < 0x64 
                && (dword_be(active_combat_pointer("PAL") + 0x80)) >= 0x64
                && (dword_be(active_combat_pointer("PAL") + 0x80)) <= 0x6e // buffer in case somehow 2+ hits in a combo are registered at once
            )
        )
        // the trigger as before
        && prev(sword_acquired("PAL", "Mutsunokami Yoshiyuki") == 0x00)
        && trigger_when(sword_acquired("PAL", "Mutsunokami Yoshiyuki") == 0x01))
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 0, they just cheese the everliving fuck out of it :)
// https://www.twitch.tv/videos/1501958318 - 
// Could try to highlight the speedrun strat - never achieve a combo and defeat Fudo-Myouu. 
// Probably an UWC though so maybe just highlight the tech in the forum and call it a day.
// If we switch this to combo, helper videos:
// https://www.youtube.com/watch?v=vhCtutaqKgU - 52, 18, 47, 49, 
achievement(
    id = 583889,
    title = "Surpassing Buddha's Protector",
    description = "Defeat Fudo-Myoou on Shura or Shigurui difficulty without any of your blades breaking and obtain Tsukiotoshi.",
    points = 5,
    type = "missable",
    trigger = (never(is_ntsc() && active_zone("NTSC") != 0x34)
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01 
        && current_difficulty("NTSC") == 0x01
        && disable_when(once(any_blade_broke("NTSC")), until=active_zone("NTSC") != 0x34)
        // the trigger as before
        && prev(sword_acquired("NTSC", "Tsukiotoshi") == 0x00)
        && trigger_when(sword_acquired("NTSC", "Tsukiotoshi") == 0x01))
    ||
        (never(is_pal() && active_zone("PAL") != 0x34)
        && is_in_game("PAL")
        && active_character("PAL") == 0x01 
        && current_difficulty("PAL") == 0x01
        && disable_when(once(any_blade_broke("PAL")), until=active_zone("PAL") != 0x34)
        // the trigger as before
        && prev(sword_acquired("PAL", "Tsukiotoshi") == 0x00)
        && trigger_when(sword_acquired("PAL", "Tsukiotoshi") == 0x01))
)

achievement(
    id = 580625,
    title = "Furious Haunting",
    description = "Defeat the Blue Monk as Momohime on Shigurui difficulty.",
    points = 5,
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && in_zone("NTSC", "Blue Monk")
            && is_shigurui("NTSC")
            && prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00) 
            && sword_acquired("NTSC", "Hasebe Kunishige") == 0x01)
        ||
            (is_pal()
                && is_in_game("PAL")
                && active_character("PAL") == 0x01 
                && in_zone("PAL", "Blue Monk")
                && is_shigurui("PAL")
                && prev(sword_acquired("PAL", "Hasebe Kunishige") == 0x00) 
                && sword_acquired("PAL", "Hasebe Kunishige") == 0x01)
)

achievement(
    id = 580626,
    title = "The Wheel Burns Once More",
    description = "Defeat Wanyudo as Momohime on Shigurui difficulty.",
    points = 10,
    trigger = (is_ntsc() 
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && in_zone("NTSC", "Wanyudo")
            && is_shigurui("NTSC")
            && prev(sword_acquired("NTSC", "Kashagiri Hiromitsu")) == 0x00 
            && sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x01)
        ||
            (is_pal() 
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && in_zone("PAL", "Wanyudo")
            && is_shigurui("PAL")
            && prev(sword_acquired("PAL", "Kashagiri Hiromitsu")) == 0x00 
            && sword_acquired("PAL", "Kashagiri Hiromitsu") == 0x01)
)

achievement(
    id = 580627,
    title = "Shinkage Style Still Inferior",
    description = "Defeat Yukinojyo as Momohime on Shigurui difficulty.",
    points = 10,
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Yukinojyo")
        && is_shigurui("NTSC")
        && prev(sword_acquired("NTSC", "Izumokami Naganori")) == 0x00
        && sword_acquired("NTSC", "Izumokami Naganori") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Yukinojyo")
        && is_shigurui("PAL")
        && prev(sword_acquired("PAL", "Izumokami Naganori")) == 0x00
        && sword_acquired("PAL", "Izumokami Naganori") == 0x01)
)

achievement(
    id = 580628,
    title = "The Eye of a Springly Guardian",
    description = "Defeat Ippondatara as Momohime on Shigurui difficulty.",
    points = 10,
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01
            && in_zone("NTSC", "Ippondatara")
            && is_shigurui("NTSC")
            && prev(sword_acquired("NTSC", "Ichimonji Norimune")) == 0x00
            && sword_acquired("NTSC", "Ichimonji Norimune") == 0x01)
        ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Ippondatara")
            && is_shigurui("PAL")
            && prev(sword_acquired("PAL", "Ichimonji Norimune")) == 0x00
            && sword_acquired("PAL", "Ichimonji Norimune") == 0x01)
)

achievement(
    id = 580629,
    title = "Justice Served",
    description = "Defeat the Chimera as Momohime on Shigurui difficulty.",
    points = 10,
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01
            && in_zone("NTSC", "Chimera")
            && is_shigurui("NTSC")
            && prev(sword_acquired("NTSC", "Shishiou")) == 0x00
            && sword_acquired("NTSC", "Shishiou") == 0x01)
        ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Chimera")
            && is_shigurui("PAL")
            && prev(sword_acquired("PAL", "Shishiou")) == 0x00
            && sword_acquired("PAL", "Shishiou") == 0x01)
)

achievement(
    id = 580630,
    title = "To Hell and Back, Again",
    description = "Defeat the Big Oni as Momohime on Shigurui difficulty.",
    points = 10,
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Big Oni")
        && is_shigurui("NTSC")
        && prev(sword_acquired("NTSC", "Onikiri")) == 0x00
        && sword_acquired("NTSC", "Onikiri") == 0x01)
    ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Big Oni")
            && is_shigurui("PAL")
            && prev(sword_acquired("PAL", "Onikiri")) == 0x00
            && sword_acquired("PAL", "Onikiri") == 0x01)
)

achievement(
    id = 580631,
    title = "Putting On a Clinic for Fujin",
    description = "Defeat Raijin as Momohime on Shigurui difficulty.",
    points = 10,
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Raijin")
        && is_shigurui("NTSC")
        && prev(sword_acquired("NTSC", "Mutsunokami Yoshiyuki")) == 0x00
        && sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Raijin")
        && is_shigurui("PAL")
        && prev(sword_acquired("PAL", "Mutsunokami Yoshiyuki")) == 0x00
        && sword_acquired("PAL", "Mutsunokami Yoshiyuki") == 0x01)
)

achievement(
    id = 580632,
    title = "Buddhist Death Frenzy",
    description = "Defeat Fudo-Myoou as Momohime on Shigurui difficulty.",
    points = 25,
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x34
        && is_shigurui("NTSC")
        && prev(sword_acquired("NTSC", "Tsukiotoshi")) == 0x00
        && sword_acquired("NTSC", "Tsukiotoshi") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x34
        && is_shigurui("PAL")
        && prev(sword_acquired("PAL", "Tsukiotoshi")) == 0x00
        && sword_acquired("PAL", "Tsukiotoshi") == 0x01)
)

achievement(
    id = 580633,
    title = "No Life No Problems",
    description = "Clear the enemy lair in Izu on Shigurui difficulty.",
    points = 100,
    trigger = (is_in_game("NTSC")
        && in_zone("NTSC", "Izu")
        && active_screen("NTSC") == 0x14
        && current_difficulty("NTSC") == 0x01
        && is_shigurui("NTSC")
        && accessory_acquired("NTSC", "Narukami Bracelet") == 0x00
        && results_screen_present("NTSC"))
    ||
        (is_in_game("PAL")
        && in_zone("PAL", "Izu")
        && active_screen("PAL") == 0x14
        && current_difficulty("PAL") == 0x01
        && is_shigurui("PAL")
        && accessory_acquired("PAL", "Narukami Bracelet") == 0x00
        && results_screen_present("PAL"))
)

// We do this because the toolkit can't answer the following question:
// "Can I record the highest X the game has seen in an address and submit only that?"
// So instead, we check if the player hit 1..999 combo and submit that. As hits.
// In theory, this should work! In practice I can't get RATools to load this.
// It will either run Remember each time, or, better yet, the entire script won't be able to load properly.
// For the time being, there is a file alongside this script: "current-leaderboard-value-block.txt".
// It contains the optimized size version of this. Have this be intentionally small and paste that into the leaderboard instead.
function lb_combo_adder(region) {
    return always_true()
    // This will adjust the combo pointer automatically depending on region
    // Basically, NTSC has a game code that has bit0=1 in its least significant address and PAL does not! 

    // combo_address_regional_offset = 0x76140 * (bit0(0x03) & 0x01)

    // combo_address = dword_be((combo_address_regional_offset + active_combat_pointer("NTSC")) + 0x80)

    // possible_combo_values = []

    // for i in range(1, 999) {
    //     array_push(possible_combo_values, i)
    // }

    // return unless(combo_address == 0xffffffff) && measured(tally_of(possible_combo_values, 0, c => once(combo_address >= c)))
}

leaderboard(
    id = 156157,
    title = "Momohime - Blue Monk - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating the Blue Monk in Act 1.",
    start = (is_ntsc()
            && active_character("NTSC") == 0x01
            && in_zone("NTSC", "Blue Monk")
            && sword_acquired("NTSC", "Hasebe Kunishige") == 0x00
            && current_difficulty("NTSC") == 0x01
            && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
            && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
        ||
            (is_pal()
            && active_character("PAL") == 0x01
            && in_zone("PAL", "Blue Monk")
            && sword_acquired("PAL", "Hasebe Kunishige") == 0x00
            && current_difficulty("PAL") == 0x01
            && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
            && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Blue Monk")) || (is_pal() && !in_zone("PAL", "Blue Monk")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00) 
        && sword_acquired("NTSC", "Hasebe Kunishige") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Hasebe Kunishige")  == 0x00)
            && sword_acquired("PAL", "Hasebe Kunishige") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

// tested PAL
leaderboard(
    id = 156243,
    title = "Momohime - Wanyudo - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Wanyudo in Act 2.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Wanyudo")
        && sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Wanyudo")
        && sword_acquired("PAL", "Kashagiri Hiromitsu")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Wanyudo")) || (is_pal() && !in_zone("PAL", "Wanyudo")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x00) 
        && sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Kashagiri Hiromitsu")  == 0x00)
            && sword_acquired("PAL", "Kashagiri Hiromitsu") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

// tested PAL
leaderboard(
    id = 156242,
    title = "Momohime - Yukinojyo - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Yukinojyo in Act 3.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Yukinojyo")
        && sword_acquired("NTSC", "Izumokami Naganori") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Yukinojyo")
        && sword_acquired("PAL", "Izumokami Naganori")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Yukinojyo")) || (is_pal() && !in_zone("PAL", "Yukinojyo")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Izumokami Naganori") == 0x00) 
        && sword_acquired("NTSC", "Izumokami Naganori") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Izumokami Naganori")  == 0x00)
            && sword_acquired("PAL", "Izumokami Naganori") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

// tested PAL
leaderboard(
    id = 156241,
    title = "Momohime - Ippondatara - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Ippondatara in Act 4.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Ippondatara")
        && sword_acquired("NTSC", "Ichimonji Norimune") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Ippondatara")
        && sword_acquired("PAL", "Ichimonji Norimune")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Ippondatara")) || (is_pal() && !in_zone("PAL", "Ippondatara")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Ichimonji Norimune") == 0x00) 
        && sword_acquired("NTSC", "Ichimonji Norimune") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Ichimonji Norimune")  == 0x00)
            && sword_acquired("PAL", "Ichimonji Norimune") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

// tested on PAL
leaderboard(
    id = 156240,
    title = "Momohime - Chimera - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating the Chimera in Act 5.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Chimera")
        && sword_acquired("NTSC", "Shishiou") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Chimera")
        && sword_acquired("PAL", "Shishiou")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Chimera")) || (is_pal() && !in_zone("PAL", "Chimera")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Shishiou") == 0x00) 
        && sword_acquired("NTSC", "Shishiou") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Shishiou")  == 0x00)
            && sword_acquired("PAL", "Shishiou") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

// Tested on PAL
leaderboard(
    id = 156239,
    title = "Momohime - Big Oni - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating the Big Oni in Act 6.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Big Oni")
        && sword_acquired("NTSC", "Onikiri") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Big Oni")
        && sword_acquired("PAL", "Onikiri")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Big Oni")) || (is_pal() && !in_zone("PAL", "Big Oni")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Onikiri") == 0x00) 
        && sword_acquired("NTSC", "Onikiri") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Onikiri")  == 0x00)
            && sword_acquired("PAL", "Onikiri") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Momohime - Raijin - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Raijin in Act 7.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && in_zone("NTSC", "Raijin")
        && sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x01
        && in_zone("PAL", "Raijin")
        && sword_acquired("PAL", "Mutsunokami Yoshiyuki")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Raijin")) || (is_pal() && !in_zone("PAL", "Raijin")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x00) 
        && sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Mutsunokami Yoshiyuki")  == 0x00)
            && sword_acquired("PAL", "Mutsunokami Yoshiyuki") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Momohime - Fudo-Myouu - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Fudo-Myouu in the Final Act.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x34
        && sword_acquired("NTSC", "Tsukiotoshi") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x34
        && sword_acquired("PAL", "Tsukiotoshi")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && active_zone("NTSC") != 0x34) || (is_pal() && active_zone("PAL") != 0x34),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Tsukiotoshi") == 0x00) 
        && sword_acquired("NTSC", "Tsukiotoshi") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Tsukiotoshi")  == 0x00)
            && sword_acquired("PAL", "Tsukiotoshi") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Momohime - New Game Time (Muso/Shura)",
    description = "Finish Momohime's story as fast as possible on Muso or Shura.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x34
        && prev(sword_acquired("NTSC", "Tsukiotoshi") == 0x00)
        && sword_acquired("NTSC", "Tsukiotoshi") == 0x01
        && is_not_shigurui("NTSC"))
    || 
        (is_pal()
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x34
        && prev(sword_acquired("PAL", "Tsukiotoshi") == 0x00)
        && sword_acquired("PAL", "Tsukiotoshi") == 0x01
        && is_not_shigurui("PAL")),
    cancel = (is_ntsc() && active_zone("NTSC") != 0x34) || (is_pal() && active_zone("PAL") != 0x34),
    submit = always_true(),
    value = max_of(
        measured(in_game_timer("NTSC", "Momohime"), when=is_ntsc()), 
        measured(in_game_timer("PAL", "Momohime"), when=is_pal())
    ),
    format="MINUTES" 
)

leaderboard(
    title = "Momohime - New Game Time (Shigurui)",
    description = "Finish Momohime's story as fast as possible on Shigurui.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x34
        && prev(sword_acquired("NTSC", "Tsukiotoshi") == 0x00)
        && sword_acquired("NTSC", "Tsukiotoshi") == 0x01
        && is_shigurui("NTSC"))
    || 
        (is_pal()
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x34
        && prev(sword_acquired("PAL", "Tsukiotoshi") == 0x00)
        && sword_acquired("PAL", "Tsukiotoshi") == 0x01
        && is_shigurui("PAL")),
    cancel = (is_ntsc() && active_zone("NTSC") != 0x34) || (is_pal() && active_zone("PAL") != 0x34),
    submit = always_true(),
    value = max_of(
        measured(in_game_timer("NTSC", "Momohime"), when=is_ntsc()), 
        measured(in_game_timer("PAL", "Momohime"), when=is_pal())
    ),
    format="MINUTES" 
)

leaderboard(
    title = "Kisuke - Kurozaru - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Kurozaru in Act 1.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && in_zone("NTSC", "Kurozaru")
        && sword_acquired("NTSC", "Nagasone Kotetsu") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && in_zone("PAL", "Kurozaru")
        && sword_acquired("PAL", "Nagasone Kotetsu")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Kurozaru")) || (is_pal() && !in_zone("PAL", "Kurozaru")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Nagasone Kotetsu") == 0x00) 
        && sword_acquired("NTSC", "Nagasone Kotetsu") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Nagasone Kotetsu")  == 0x00)
            && sword_acquired("PAL", "Nagasone Kotetsu") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

// Tested on NTSC
leaderboard(
    id = 156238,
    title = "Kisuke - Giant Centipede - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating the Giant Centipedes in Act 2.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && in_zone("NTSC", "Giant Centipede")
        && sword_acquired("NTSC", "Iganokami Kanemichi") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && in_zone("PAL", "Giant Centipede")
        && sword_acquired("PAL", "Iganokami Kanemichi")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Giant Centipede")) || (is_pal() && !in_zone("PAL", "Giant Centipede")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Iganokami Kanemichi") == 0x00) 
        && sword_acquired("NTSC", "Iganokami Kanemichi") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Iganokami Kanemichi")  == 0x00)
            && sword_acquired("PAL", "Iganokami Kanemichi") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Kisuke - Torahime - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Torahime in Act 3.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && in_zone("NTSC", "Torahime")
        && sword_acquired("NTSC", "Magoroku Kanemoto") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && in_zone("PAL", "Torahime")
        && sword_acquired("PAL", "Magoroku Kanemoto")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Torahime")) || (is_pal() && !in_zone("PAL", "Torahime")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Magoroku Kanemoto") == 0x00) 
        && sword_acquired("NTSC", "Magoroku Kanemoto") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Magoroku Kanemoto")  == 0x00)
            && sword_acquired("PAL", "Magoroku Kanemoto") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Kisuke - Sayo - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Sayo in Act 4.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && in_zone("NTSC", "Sayo")
        && sword_acquired("NTSC", "Kogarasumaru") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && in_zone("PAL", "Sayo")
        && sword_acquired("PAL", "Kogarasumaru")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Sayo")) || (is_pal() && !in_zone("PAL", "Sayo")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Kogarasumaru") == 0x00) 
        && sword_acquired("NTSC", "Kogarasumaru") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Kogarasumaru")  == 0x00)
            && sword_acquired("PAL", "Kogarasumaru") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Kisuke - Tsuchigumo - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Tsuchigumo in Act 5.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && in_zone("NTSC", "Tsuchigumo")
        && sword_acquired("NTSC", "Kumokiri") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && in_zone("PAL", "Tsuchigumo")
        && sword_acquired("PAL", "Kumokiri")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Tsuchigumo")) || (is_pal() && !in_zone("PAL", "Tsuchigumo")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Kumokiri") == 0x00) 
        && sword_acquired("NTSC", "Kumokiri") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Kumokiri")  == 0x00)
            && sword_acquired("PAL", "Kumokiri") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Kisuke - Chigurui Bishamon - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Chigurui Bishamon in Act 6.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && in_zone("NTSC", "Chigurui Bishamon")
        && sword_acquired("NTSC", "Osafune Kanemitsu") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && in_zone("PAL", "Chigurui Bishamon")
        && sword_acquired("PAL", "Osafune Kanemitsu")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Chigurui Bishamon")) || (is_pal() && !in_zone("PAL", "Chigurui Bishamon")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Osafune Kanemitsu") == 0x00) 
        && sword_acquired("NTSC", "Osafune Kanemitsu") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Osafune Kanemitsu")  == 0x00)
            && sword_acquired("PAL", "Osafune Kanemitsu") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Kisuke - Dragon God - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Dragon God in Act 7.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && in_zone("NTSC", "Dragon God")
        && sword_acquired("NTSC", "Goro Masamune") == 0x00
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && in_zone("PAL", "Dragon God")
        && sword_acquired("PAL", "Goro Masamune")  == 0x00
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && !in_zone("NTSC", "Dragon God")) || (is_pal() && !in_zone("PAL", "Dragon God")),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Goro Masamune") == 0x00) 
        && sword_acquired("NTSC", "Goro Masamune") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Goro Masamune")  == 0x00)
            && sword_acquired("PAL", "Goro Masamune") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Kisuke - Inugama Tokugawa Tsunayoshi - Highest Combo",
    description = "(Shura or Shigurui) Highest combo over the entire fight after defeating Inugama Tokugawa Tsunayoshi in the Final Act.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && active_zone("NTSC") == 0x31
        && current_difficulty("NTSC") == 0x01
        && prev(dword_be(active_combat_pointer("NTSC") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("NTSC") + 0x80) <= 0x10)
    ||
        (is_pal()
        && active_character("PAL") == 0x00
        && active_zone("PAL") == 0x31
        && current_difficulty("PAL") == 0x01
        && prev(dword_be(active_combat_pointer("PAL") + 0x80)) == 0xffffffff
        && dword_be(active_combat_pointer("PAL") + 0x80) <= 0x10),
    cancel = (is_ntsc() && active_zone("NTSC") != 0x31) || (is_pal() && active_zone("PAL") != 0x31),
    submit = (is_ntsc() 
        && prev(sword_acquired("NTSC", "Mumei Tamonoo") == 0x00) 
        && sword_acquired("NTSC", "Mumei Tamonoo") == 0x01)
        ||
            (is_pal()
            && prev(sword_acquired("PAL", "Mumei Tamonoo")  == 0x00)
            && sword_acquired("PAL", "Mumei Tamonoo") == 0x01),
    value = lb_combo_adder("NTSC"),
    format = "VALUE"
)

leaderboard(
    title = "Kisuke - New Game Time (Muso/Shura)",
    description = "Finish Kisuke's story as fast as possible on Muso or Shura.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && active_zone("NTSC") == 0x31
        && prev(sword_acquired("NTSC", "Mumei Tamonoo") == 0x00)
        && sword_acquired("NTSC", "Mumei Tamonoo") == 0x01
        && is_not_shigurui("NTSC"))
    || 
        (is_pal()
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x31
        && prev(sword_acquired("PAL", "Mumei Tamonoo") == 0x00)
        && sword_acquired("PAL", "Mumei Tamonoo") == 0x01
        && is_not_shigurui("PAL")),
    cancel = (is_ntsc() && active_zone("NTSC") != 0x31) || (is_pal() && active_zone("PAL") != 0x31),
    submit = always_true(),
    value = max_of(
        measured(in_game_timer("NTSC", "Kisuke"), when=is_ntsc()), 
        measured(in_game_timer("PAL", "Kisuke"), when=is_pal())
    ),
    format="MINUTES" 
)

leaderboard(
    title = "Kisuke - New Game Time (Shigurui)",
    description = "Finish Kisuke's story as fast as possible on Shigurui.",
    start = (is_ntsc()
        && active_character("NTSC") == 0x00
        && active_zone("NTSC") == 0x31
        && prev(sword_acquired("NTSC", "Mumei Tamonoo") == 0x00)
        && sword_acquired("NTSC", "Mumei Tamonoo") == 0x01
        && is_shigurui("NTSC"))
    || 
        (is_pal()
        && active_character("PAL") == 0x00
        && active_zone("PAL") == 0x31
        && prev(sword_acquired("PAL", "Mumei Tamonoo") == 0x00)
        && sword_acquired("PAL", "Mumei Tamonoo") == 0x01
        && is_shigurui("PAL")),
    cancel = (is_ntsc() && active_zone("NTSC") != 0x31) || (is_pal() && active_zone("PAL") != 0x31),
    submit = always_true(),
    value = max_of(
        measured(in_game_timer("NTSC", "Kisuke"), when=is_ntsc()),
        measured(in_game_timer("PAL", "Kisuke"), when=is_pal())
    ),
    format="MINUTES" 
)

rich_presence_conditional_display(check_on_main_menu("NTSC"), "On the title screen")
rich_presence_conditional_display(check_on_main_menu("PAL"), "On the title screen")

// Onsen

rich_presence_conditional_display(
    is_ntsc() && in_zone("NTSC", "Onsen") && is_shigurui("NTSC"),
    "[Shigurui] lv. {0} {1} is relaxing in an onsen | {2} / 108 ⚔️ | {3} / 20 📖 | {4} / 55 💍 | {5} ryo, {6} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_pal() && in_zone("PAL", "Onsen") && is_shigurui("PAL"),
    "[Shigurui] lv. {0} {1} is resting in an onsen | {2} / 108 ⚔️ | {3} / 20 📖 | {4} / 55 💍 | {5} ryo, {6} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
) 

rich_presence_conditional_display(
    is_ntsc() && in_zone("NTSC", "Onsen"),
    "[{0}] lv. {1} {2} is relaxing in an onsen | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_pal() && in_zone("PAL", "Onsen"),
    "[{0}] lv. {1} {2} is resting in an onsen | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
) 

// Credits
rich_presence_conditional_display(
    (in_zone("NTSC", "Purple waves scene") || in_zone("NTSC", "Credits")) && is_shigurui("NTSC"),
    "[Shigurui] lv. {0} {1} is enjoying the credits | {2} / 108 ⚔️ | {3} / 20 📖 | {4} / 55 💍 | {5} ryo, {6} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    (in_zone("PAL", "Purple waves scene") || in_zone("PAL", "Credits")) && is_shigurui("PAL"),
    "[Shigurui] lv. {0} {1} is enjoying the credits | {2} / 108 ⚔️ | {3} / 20 📖 | {4} / 55 💍 | {5} ryo, {6} mon",
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    in_zone("NTSC", "Purple waves scene") || in_zone("NTSC", "Credits"),
    "[{0}] lv. {1} {2} is enjoying the credits | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    in_zone("PAL", "Purple waves scene") || in_zone("PAL", "Credits"),
    "[{0}] lv. {0} {1} is enjoying the credits | {2} / 108 ⚔️ | {3} / 20 📖 | {4} / 55 💍 | {5} ryo, {6} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    is_fighting_boss("NTSC") && is_shigurui("NTSC"), 
    "[Shigurui] lv. {0} {1} is fighting {2} | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_fighting_boss("PAL") && is_shigurui("PAL"), 
    "[Shigurui] lv. {0} {1} is battling {2} | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    is_fighting_boss("NTSC"), 
    "[{0}] lv. {1} {2} is fighting {3} | {4} / 108 ⚔️ | {5} / 20 📖 | {6} / 55 💍 | {7} ryo, {8} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_fighting_boss("PAL"), 
    "[{0}] lv. {1} {2} is battling {3} | {4} / 108 ⚔️ | {5} / 20 📖 | {6} / 55 💍 | {7} ryo, {8} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

// Total Pandemonium
rich_presence_conditional_display(
    is_shigurui("NTSC") && in_total_pandemonium("NTSC"),
    "[Shigurui] lv. {0} {1} is surviving Total Pandemonium | {2} / 108 ⚔️ | {3} / 20 📖 | {4} / 55 💍 | {5} ryo, {6} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_shigurui("PAL") && in_total_pandemonium("PAL"),
    "[Shigurui] lv. {0} {1} is withstanding Total Pandemonium | {2} / 108 ⚔️ | {3} / 20 📖 | {4} / 55 💍 | {5} ryo, {6} mon",
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    in_total_pandemonium("NTSC"),
    "[{0}] lv. {1} {2} is surviving Total Pandemonium | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    in_total_pandemonium("PAL"),
    "[{0}] lv. {1} {2} is withstanding Total Pandemonium | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

// Fishing
rich_presence_conditional_display(
    is_shigurui("NTSC") && is_fishing("NTSC"),
    "[Shigurui] lv. {0} {1} is braving the {2}'s waters | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_shigurui("PAL") && is_fishing("PAL"),
    "[Shigurui] lv. {0} {1} is braving the {2}'s sea | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    is_fishing("NTSC"),
    "[{0}] lv. {1} {2} is braving the {3}'s waters | {4} / 108  ⚔️ | {5} / 20 📖 | {6} / 55 💍 | {7} ryo, {8} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_fishing("PAL"),
    "[{0}] lv. {1} {2} is braving the {3}'s sea | {4} / 108  ⚔️ | {5} / 20 📖 | {6} / 55 💍 | {7} ryo, {8} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

// Exploring

rich_presence_conditional_display(
    is_shigurui("NTSC"),
    "[Shigurui] lv. {0} {1} is exploring {2} | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_shigurui("PAL"),
    "[Shigurui] lv. {0} {1} is traversing {2} | {3} / 108 ⚔️ | {4} / 20 📖 | {5} / 55 💍 | {6} ryo, {7} mon",
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    is_in_game("NTSC"),
    "[{0}] lv. {1} {2} is exploring {3} | {4} / 108 ⚔️ | {5} / 20 📖 | {6} / 55 💍 | {7} ryo, {8} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_in_game("PAL"),
    "[{0}] lv. {1} {2} is traversing {3} | {4} / 108 ⚔️ | {5} / 20 📖 | {6} / 55 💍 | {7} ryo, {8} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("NumCurrentAccessories", num_current_accessories("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

// This is the fallback if everything else fails due to region shenanigans
rich_presence_display("Playing Muramasa: The Demon Blade")