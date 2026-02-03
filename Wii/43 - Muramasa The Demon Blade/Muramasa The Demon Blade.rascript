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
            && dword_be(ptr_character_details_pal() + 0x1dc) == 0x01
            && dword_be(ptr_character_details_pal() + 0x1d8) <= 0x01
    } else if (region == "NTSC") {
        return current_difficulty("NTSC") == 0x01 
            && dword_be(ptr_character_details_ntsc() + 0x1dc) == 0x01
            && dword_be(ptr_character_details_ntsc() + 0x1d8) <= 0x01
    }
} 

// $474DB0: [32-bit BE Pointer] Pointer to combat
//          +0x14 Pointer to active combat [32-bit BE Pointer]
//          ++0x6c Unsure what it is for, but it's 0x00000031 when combat is rolling [32-bit BE]
//          ++0x7c Active Combo [32-bit BE]
function combat_pointer(region) {
    if (region == "PAL") {
        return mask_ptr(mask_ptr(0x004eaef0) + 0x14)
    } else if (region == "NTSC") {
        return mask_ptr(mask_ptr(0x474DB0) + 0x14)
    }
}

// $DA7314: [32-bit Pointer] Pointer to Settings
function pointer_to_settings() => dword(0xDA7314)

// $E27038: [32-bit BE Pointer] [NTSC] Player character pointer
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
function ptr_character_details_ntsc() => mask_ptr(0x00e27038)

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
function ptr_character_details_pal() => mask_ptr(0x00e9d238)

// Get the active character currently being played.
// This is effectively a "is it 0x00 (Kisuke) or 0x01 (Momohime)" so combine this with other logic to get what you need.
function active_character(region) {
    if (region == "PAL") {
        return byte(ptr_character_details_pal() + 0x1d4)
    } else if (region == "NTSC") {
        return byte(ptr_character_details_ntsc() + 0x1d4)
    }
}

CharacterLookup = {
    0x00: "Kisuke",
    0x01: "Momohime"
}

// Get the active zone the player is in.
function active_zone(region) {
    if (region == "PAL") {
        return dword_be(0x00e1d2c4)
    } else if (region == "NTSC") {
        return dword_be(0x00da70c4)
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

// Check if the player ever jumped.
function has_jumped(region) {
    address = 0
    if (region == "PAL") {
        address = 0x4eaee0
    } else if (region == "NTSC") {
        address = 0x474da0
    }

    return dword_be(address) - prev(dword_be(address)) == 0x01
}

function is_fighting_boss(region) {
    boss_values = [
        // momohime boss values
        0x00, // Blue Monk
        0x01, // Big Oni "Big Oni",
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

    cond = always_true()
    for boss_value in boss_values {
        cond = cond && active_zone(region) == boss_value
    }

    return cond
}

function is_fishing(region) {
    fishing_zones = [
        0x03, // Kraken
        0x04, // Mermaid,

    ]
}



// Inverse of #check_on_main_menu so that it doesn't get alt group'd when I negate it.
function is_in_game(region) {
    if (region == "PAL") {
        return is_pal() && dword_be(0x00e1d2c4) != 0xffffffff && dword_be(0x00e1d2c4) != 0xffffffff
    } else if (region == "NTSC") {
        return is_ntsc() && dword_be(0x00da70c4) != 0xffffffff && dword_be(0x00da70c8) != 0xffffffff
    }
}

function in_zone(region, zone) {
    for key in ZoneLookup {
        if (ZoneLookup[key] == zone) {
            return dword_be(0xDA70C4) == key
        }
    }
    
    return always_false()
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
    0x2f: "Sagami Mountain Road of Rokkoku Kenzan", // full name is 
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

// Get the byte indicating that a given sword is acquired.
function sword_acquired(region, sword) {
    starting_addr = 0
    if (region == "PAL") {
        starting_addr = 0x00e1d78d
    } else if (region == "NTSC") {
        starting_addr = 0x00da758d
        // return byte(sword_flags_ntsc[sword])
    }

    swords = [
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
        "Oboro Muramasa"
    ]


    for i in range(0, length(swords)) {
        if (swords[i] == sword) {
            return byte(starting_addr + i)
        }
    }
}

// Check if a specific accessory has been acquired.
function accessory_acquired(region, accessory) {
    // There are two distinct blocks of accessories to loop over
    starting_addr = 0

    if (region == "PAL") {
        starting_addr = 0x00e1d722
    } else if (region == "NTSC") {
        starting_addr = 0x00da7522
    }

    accessory_block_one = [
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


    for i in range(0, length(accessory_block_one) - 1) {
        if (accessory_block_one[i] == accessory) {
            return byte(starting_addr + i)
        }
    }

    // try the next block
    if (region == "PAL") {
        starting_addr = 0x00e1d7ff
    } else if (region == "NTSC") {
        starting_addr = 0x00da75ff
    }

    accessory_block_two = [
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

    for i in range(0, length(accessory_block_two)) {
        if (accessory_block_two[i] == accessory) {
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

function cookbook_acquired(region, book) {
    starting_book_addr = 0
    if (region == "PAL") {
        starting_book_addr = 0x00e1d73b
    } else if (region == "NTSC") {
        starting_book_addr = 0x00da753b
    }

    for i in range(0, length(cookbooks)) {
        if (cookbooks[i] == book) {
            return byte(starting_book_addr + i)
        }
    }
}

cookbooks = [
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

    } else if (region == "NTSC") {
        return byte(0x00da766b) == 0x01 || byte(0x00da768f) == 0x01 || byte(0x00da76b3) == 0x01
    }
}

function current_level(region) {
    if (region == "PAL") {
        return byte(ptr_character_details_pal() + 0x1fc) + 1
    } else if (region == "NTSC") {
        return byte(ptr_character_details_ntsc() + 0x1fc) + 1
    }
}

// Static map ranging [$0x00da758d, $0x00da75f8]
// Every flag here is 0x00 = Not acquired, 0x01 = Acquired
sword_flags_ntsc = {
    "Kagura Muramasa":      0x00da758d,
    "Shinmei":              0x00da758e,
    "Yakumo":               0x00da758f,
    "Hayate Muramasa":      0x00da7590,
    "Kagero Muramasa":      0x00da7591,
    "Nagasone Kotetsu":     0x00da7592,
    "Natsusame Muramasa":   0x00da7593,
    "Yunagi Muramasa":      0x00da7594,
    "Edauchi Muramasa":     0x00da7595,
    "Yoiyami Muramasa":     0x00da7596,
    "Iganokami Kanemichi":  0x00da7597,
    "Fumitsuki Muramasa":   0x00da7598,
    "Hazuki Muramasa":      0x00da7599,
    "Nagatsuki Muramasa":   0x00da759a,
    "Magoroku Kanemoto":    0x00da759b,
    "Kirisame Muramasa":    0x00da759c,
    "Asaarashi Muramasa":   0x00da759d,
    "Shigure Muramasa":     0x00da759e,
    "Amagiri Muramasa":     0x00da759f,
    "Kogarasumaru":         0x00da75a0,
    "Yogetsu Muramasa":     0x00da75a1,
    "Shimotsuki Muramasa":  0x00da75a2,    
    "Gokugetsu Muramasa":   0x00da75a3,
    "Kumokiri":             0x00da75a4,
    "Hibashiri Muramasa":   0x00da75a5,
    "Ishizuki Muramasa":    0x00da75a6,
    "Kazanami Muramasa":    0x00da75a7,
    "Suiran Muramasa":      0x00da75a8,
    "Osafune Kanemitsu":    0x00da75a9,
    "Hisame Muramasa":      0x00da75aa,
    "Mizutachi Muramasa":   0x00da75ab,
    "Tanahashi Muramasa":   0x00da75ac,
    "Goro Masamune":        0x00da75ad,
    "Tasogare Muramasa":    0x00da75ae,
    "Reimei Muramasa":      0x00da75af,
    "Gyoko Muramasa":       0x00da75b0,
    "Tsubamegaeshi Muramasa": 0x00da75b1,
    "Mumei Tamonoo":        0x00da75b2,
    "Iwatoshi Muramasa":    0x00da75b3,
    "Hiten Muramasa":       0x00da75b4,
    "Meikyo Muramasa":      0x00da75b5,
    "Sasanoyuki Muramasa":  0x00da75b6,
    "Shusui Muramasa":      0x00da75b7,
    "Nukehishaku Muramasa": 0x00da75b8,
    "Chizuru Muramasa":     0x00da75b9,
    "Hisui":                0x00da75ba,
    "Sazanami":             0x00da75bb,
    "Botan Muramasa":       0x00da75bc,
    "Ayame Muramasa":       0x00da75bd,
    "Hasebe Kunishige":     0x00da75be,
    "Umitsubame Muramasa":  0x00da75bf,
    "Getsuei Muramasa":     0x00da75c0,
    "Hibari Muramasa":      0x00da75c1,
    "Tachigesa Muramasa":   0x00da75c2,
    "Kashagiri Hiromitsu":  0x00da75c3,
    "Mutsuki Muramasa":     0x00da75c4,
    "Kisaragi Muramasa":    0x00da75c5,
    "Kagetsu Muramasa":     0x00da75c6,
    "Izumokami Naganori":   0x00da75c7,
    "Tamatsubaki Muramasa": 0x00da75c8,
    "Yamabuki Muramasa":    0x00da75c9,
    "Kuchinawa Muramasa":   0x00da75ca,
    "Asazakura Muramasa":   0x00da75cb,
    "Ichimonji Norimune":   0x00da75cc,
    "Uzuki Muramasa":       0x00da75cd,
    "Satsuki Muramasa":     0x00da75ce,
    "Suigetsu Muramasa":    0x00da75cf,
    "Shishiou":             0x00da75d0,
    "Seika Muramasa":       0x00da75d1,
    "Maidori Muramasa":     0x00da75d2,
    "Midarekaze Muramasa":  0x00da75d3,
    "Tsukimigiri Muramasa": 0x00da75d4,
    "Onikiri":              0x00da75d5,
    "Shiden Muramasa":      0x00da75d6,
    "Hiei Muramasa":        0x00da75d7,
    "Chisuberi Muramasa":   0x00da75d8,
    "Mutsunokami Yoshiyuki": 0x00da75d9,
    "Suiren Muramasa":      0x00da75da,
    "Muhyo Muramasa":       0x00da75db,
    "Shiratsuyu Muramasa":  0x00da75dc,
    "Tsuyuharai Muramasa":  0x00da75dd,
    "Tsukiotoshi":          0x00da75de,
    "Setsugekka Muramasa":  0x00da75df,
    "Kasai Muramasa":       0x00da75e0,
    "Takinomizu Muramasa":  0x00da75e1,
    "Oka Muramasa":         0x00da75e2,
    "Chizakura Muramasa":   0x00da75e3,
    "Torinuke Muramasa":    0x00da75e4,
    "Tsukuyomi Muramasa":   0x00da75e5,
    "Mikazuki Munechika":   0x00da75e6,
    "Amatsu Muramasa":      0x00da75e7,
    "Onimaru Kunitsuna":    0x00da75e8,
    "Seiryu Muramasa":      0x00da75e9,
    "Byakko Muramasa":      0x00da75ea,
    "Jyuzumaru Tsunetsugu": 0x00da75eb,
    "Suzaku Muramasa":      0x00da75ec,
    "Kamikazu Muramasa":    0x00da75ed,
    "Genbu Muramasa":       0x00da75ee,
    "Ouryu Muramasa":       0x00da75ef,
    "Mugen Muramasa":       0x00da75f0,
    "Kagotsurube Muramasa":  0x00da75f1,
    "Otenta Mitsuyo":       0x00da75f2,
    "Okanehira":            0x00da75f3,
    "Kyoshu Muramasa":      0x00da75f4,
    "Suisei Muramasa":      0x00da75f5,
    "Dojigiri Yasutsuna":   0x00da75f6,
    "Tokiwatari Murasa":    0x00da75f7,
    "Oboro Muramasa":       0x00da75f8
}

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

function num_momohime_swords(region) {
    exclusive_swords = [
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
        "Onimaru Kunitsuna",
        "Byakko Muramasa",
        "Suzaku Muramasa",
        "Genbu Muramasa"
    ]
    cond = 0
    if (region == "PAL") {
        for sword in exclusive_swords {
            cond = cond + byte(sword_flags_pal[sword])
        }
    } else if (region == "NTSC") {
        for sword in exclusive_swords {
            cond = cond + byte(sword_flags_ntsc[sword])
        }
    }

    return cond
}

exclusive_momohime_swords = [
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
    "Onimaru Kunitsuna",
    "Byakko Muramasa",
    "Suzaku Muramasa",
    "Genbu Muramasa"
]

exclusive_kisuke_swords = [
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
    "Mikazuki Munechika",
]

//
function num_exclusive_swords(region, character) {
    exclusive_swords = []
    if (character == "Momohime") {
        exclusive_swords = exclusive_momohime_swords
    } else if (character == "Kisuke") {
        exclusive_swords = exclusive_kisuke_swords
    }

    cond = 0
    if (region == "PAL") {
        for sword in exclusive_swords {
            cond = cond + byte(sword_flags_pal[sword])
        }
    } else if (region == "NTSC") {
        for sword in exclusive_swords {
            cond = cond + byte(sword_flags_ntsc[sword])
        }
    }

    return cond
}

//
function num_current_recipes(region) {
    cond = 0
    for book in cookbooks {
        cond = cond + cookbook_acquired(region, book)
    }

    return cond
}

//
function num_current_accessories(region) {
    cond = 0



    if (region == "PAL") {

    } else if (region == "NTSC") {
        for accessory in accessory_flags_ntsc {
            cond = cond + byte(accessory_flags_ntsc[accessory])
        }
    }

    return cond
}

function current_ryo(region) {
    if (region == "PAL") {
        return dword_be(ptr_character_details_pal() + 0x1f0) / 10000
    } else if (region == "NTSC") {
        return dword_be(ptr_character_details_ntsc() + 0x1f0) / 10000
    }
} 

function current_mon(region) {
    if (region == "PAL") {
        return dword_be(ptr_character_details_pal() + 0x1f0) % 10000
    } else if (region == "NTSC") {
        return dword_be(ptr_character_details_ntsc() + 0x1f0) % 10000
    }
}

achievement(
    id = 579985,
    title = "Haunted Once More",
    description = "Bring Momohime to Jinkuro and defend her body from the Blue Monk's assault.",
    points = 3,
    type = "progression",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && active_zone("NTSC") == 0x00
            && prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00) 
            && sword_acquired("NTSC", "Hasebe Kunishige") == 0x01)
        ||
            (is_pal()
                && is_in_game("PAL")
                && active_character("PAL") == 0x01 
                && active_zone("PAL") == 0x00
                && prev(sword_acquired("PAL", "Hasebe Kunishige") == 0x00) 
                && sword_acquired("PAL", "Hasebe Kunishige") == 0x01)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - Shigurui speedrun. Hits 72, 78, 39
// https://www.twitch.tv/videos/1501958318 - 210 
achievement(
    title = "Haunting Combo",
    description = "Achieve a combo of 75 or higher and defeat the Blue Monk on Shura or Shigurui difficulty.",
    points = 5,
    trigger = (is_ntsc() 
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && current_difficulty("NTSC") == 0x01
            && never(active_zone("NTSC") != 0x00)
            && trigger_when(once(prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x64 && (dword_be(combat_pointer("NTSC") + 0x7c)) >= 0x64))
            // the trigger as before
            && trigger_when(prev(sword_acquired("NTSC", "Hasebe Kunishige") == 0x00)) 
            && trigger_when(sword_acquired("NTSC", "Hasebe Kunishige") == 0x01))
        ||
            (is_pal() 
                && is_in_game("PAL")
                && active_character("PAL") == 0x01 
                && current_difficulty("PAL") == 0x01
                && never(active_zone("PAL") != 0x00)
                && trigger_when(once(prev(dword_be(combat_pointer("PAL") + 0x7c)) < 0x64 && (dword_be(combat_pointer("PAL") + 0x7c)) >= 0x64))
                // the trigger as before
                && trigger_when(prev(sword_acquired("PAL", "Hasebe Kunishige") == 0x00)) 
                && trigger_when(sword_acquired("PAL", "Hasebe Kunishige") == 0x01))
)

achievement(
    id = 579986,
    title = "Collateral Freedom",
    description = "Track down Momohime's soul all the way to Musashi and forcefully take it back from Wanyudo.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc() 
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01 
            && active_zone("NTSC") == 0x27
            && prev(sword_acquired("NTSC", "Kashagiri Hiromitsu")) == 0x00 
            && sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x01)
        ||
            (is_pal() 
            && is_in_game("PAL")
            && active_character("PAL") == 0x01 
            && active_zone("PAL") == 0x27
            && prev(sword_acquired("PAL", "Kashagiri Hiromitsu")) == 0x00 
            && sword_acquired("PAL", "Kashagiri Hiromitsu") == 0x01)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - Shigurui speedrun. Hits 47, 51, 2x, 47, 34
// https://www.twitch.tv/videos/1501958318 - 15, 6, 11, 52, 57, 1, 32
achievement(
    title = "Wheel Ablaze",
    description = "Achieve a combo of 50 or higher and defeat Wanyudo on Shura or Shigurui difficulty.",
    points = 5,  
    trigger = (is_ntsc() 
            && is_in_game("NTSC")
            && current_difficulty("NTSC") == 0x01
            && active_character("NTSC") == 0x01 
            && never(active_zone("NTSC") != 0x27)
            && trigger_when(once(prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x32 && (dword_be(combat_pointer("NTSC") + 0x7c)) >= 0x32))
            && trigger_when(prev(sword_acquired("NTSC", "Kashagiri Hiromitsu")) == 0x00)
            && trigger_when(sword_acquired("NTSC", "Kashagiri Hiromitsu") == 0x01))
        ||
            (is_pal() 
            && is_in_game("PAL")
            && current_difficulty("PAL") == 0x01
            && active_character("PAL") == 0x01 
            && never(active_zone("PAL") != 0x27)
            && trigger_when(once(prev(dword_be(combat_pointer("PAL") + 0x7c)) < 0x32 && (dword_be(combat_pointer("PAL") + 0x7c)) >= 0x32))
            && trigger_when(prev(sword_acquired("PAL", "Kashagiri Hiromitsu")) == 0x00)
            && trigger_when(sword_acquired("PAL", "Kashagiri Hiromitsu") == 0x01))
)

achievement(
    id = 579987,
    title = "The Princess' Plea",
    description = "Ask Yukinoyjo about the Kuromitsu blade and demonstrate the weaknesses of his Shinkage Style.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x26
        && prev(sword_acquired("NTSC", "Izumokami Naganori")) == 0x00
        && sword_acquired("NTSC", "Izumokami Naganori") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x26
        && prev(sword_acquired("PAL", "Izumokami Naganori")) == 0x00
        && sword_acquired("PAL", "Izumokami Naganori") == 0x01)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - Shigurui speedrun. Hits 14, ?, 10, 41, 13, 37, ?, 40
// https://www.twitch.tv/videos/1501958318 - 
achievement(
    title = "A One-Sided Affair",
    description = "Defeat Yukinoyjo on Shura or Shigurui without any of your blades breaking.",
    points = 5,
    type = "missable",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && current_difficulty("NTSC") == 0x01
            && active_character("NTSC") == 0x01
            && never(active_zone("NTSC") != 0x26)
            && unless(once(any_blade_broke("NTSC")))
            && trigger_when(prev(sword_acquired("NTSC", "Izumokami Naganori")) == 0x00)
            && trigger_when(sword_acquired("NTSC", "Izumokami Naganori") == 0x01))
        || 
        (is_pal()
            && is_in_game("PAL")
            && current_difficulty("PAL") == 0x01
            && active_character("PAL") == 0x01
            && never(active_zone("PAL") != 0x26)
            && unless(once(any_blade_broke("PAL")))
            && trigger_when(prev(sword_acquired("PAL", "Izumokami Naganori")) == 0x00)
            && trigger_when(sword_acquired("PAL", "Izumokami Naganori") == 0x01))
)
achievement(
    title = "Grounded for Honor",
    description = "Defeat Yukinoyjo on Shura or Shigurui without ever pressing up on your control stick or d-pad.",
    points = 5,
    type = "missable",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && current_difficulty("NTSC") == 0x01
        && active_character("NTSC") == 0x01
        && never(active_zone("NTSC") != 0x26)
        && unless(once(has_jumped("NTSC")))
        && trigger_when(prev(sword_acquired("NTSC", "Izumokami Naganori")) == 0x00)
        && trigger_when(sword_acquired("NTSC", "Izumokami Naganori") == 0x01))
    || 
    (is_pal()
        && is_in_game("PAL")
        && current_difficulty("PAL") == 0x01
        && active_character("PAL") == 0x01
        && never(active_zone("PAL") != 0x26)
        && unless(once(has_jumped("PAL")))
        && trigger_when(prev(sword_acquired("PAL", "Izumokami Naganori")) == 0x00)
        && trigger_when(sword_acquired("PAL", "Izumokami Naganori") == 0x01))
)

achievement(
    id = 579988,
    title = "The Foot of a Mystic Boar",
    description = "Travel through the mountains of Takayama and defeat Ippondatara to learn a well-guarded secret.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01
            && active_zone("NTSC") == 0x07
            && prev(sword_acquired("NTSC", "Ichimonji Norimune")) == 0x00
            && sword_acquired("NTSC", "Ichimonji Norimune") == 0x01)
        ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && active_zone("PAL") == 0x07
            && prev(sword_acquired("PAL", "Ichimonji Norimune")) == 0x00
            && sword_acquired("PAL", "Ichimonji Norimune") == 0x01)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 47, 53, 2x, 5, 5, 10
// https://www.twitch.tv/videos/1501958318 - 50, 4, 2, 3, 3, 31, 
achievement(
    title = "The Hand of a Protective Deity",
    description = "Achieve a combo of 50 or higher and defeat Ippondatara on Shura or Shigurui difficulty.",
    points = 10,
    type = "missable",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && current_difficulty("NTSC") == 0x01
            && active_character("NTSC") == 0x01
            && never(active_zone("NTSC") != 0x07)
            && trigger_when(once(prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x32 && (dword_be(combat_pointer("NTSC") + 0x7c)) >= 0x32))
            && trigger_when(prev(sword_acquired("NTSC", "Ichimonji Norimune")) == 0x00)
            && trigger_when(sword_acquired("NTSC", "Ichimonji Norimune") == 0x01))
        ||
            (is_pal()
            && is_in_game("PAL")
            && current_difficulty("PAL") == 0x01
            && active_character("PAL") == 0x01
            && never(active_zone("PAL") != 0x07)
            && trigger_when(once(prev(dword_be(combat_pointer("PAL") + 0x7c)) < 0x32 && (dword_be(combat_pointer("PAL") + 0x7c)) >= 0x32))
            && trigger_when(prev(sword_acquired("PAL", "Ichimonji Norimune")) == 0x00)
            && trigger_when(sword_acquired("PAL", "Ichimonji Norimune") == 0x01))
)

achievement(
    id = 579989,
    title = "Disgraced Traitor Exposed",
    description = "Infiltrate Narukami Castle and defeat Shikami Danjo and his chimera.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && active_character("NTSC") == 0x01
            && active_zone("NTSC") == 0x06
            && prev(sword_acquired("NTSC", "Shishiou")) == 0x00
            && sword_acquired("NTSC", "Shishiou") == 0x01)
        ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && active_zone("PAL") == 0x06
            && prev(sword_acquired("PAL", "Shishiou")) == 0x00
            && sword_acquired("PAL", "Shishiou") == 0x01)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 53, 30, 14, 
// https://www.twitch.tv/videos/1501958318 - 65, 30, 8, death, 53, 23,16, 8,4, 31, 3
achievement(
    title = "The True Form of a Traitor",
    description = "Achieve a combo of 50 or higher and defeat the Chimera on Shura or Shigurui difficulty.",
    points = 10,
    type = "missable",
    trigger = (is_ntsc()
            && is_in_game("NTSC")
            && current_difficulty("NTSC") == 0x01
            && active_character("NTSC") == 0x01
            && never(active_zone("NTSC") != 0x06)
            && trigger_when(once(prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x32 && (dword_be(combat_pointer("NTSC") + 0x7c)) >= 0x32))
            && trigger_when(prev(sword_acquired("NTSC", "Shishiou")) == 0x00)
            && trigger_when(sword_acquired("NTSC", "Shishiou") == 0x01))
        ||
            (is_pal()
            && is_in_game("PAL")
            && current_difficulty("PAL") == 0x01
            && active_character("PAL") == 0x01
            && never(active_zone("PAL") != 0x06)
            && trigger_when(once(prev(dword_be(combat_pointer("PAL") + 0x7c)) < 0x32 && (dword_be(combat_pointer("PAL") + 0x7c)) >= 0x32))
            && trigger_when(prev(sword_acquired("PAL", "Shishiou")) == 0x00)
            && trigger_when(sword_acquired("PAL", "Shishiou") == 0x01))
)

achievement(
    id = 579990,
    title = "Served Fresh",
    description = "Descend into hell and get yourself out of trouble.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x01
        && prev(sword_acquired("NTSC", "Onikiri")) == 0x00
        && sword_acquired("NTSC", "Onikiri") == 0x01)
    ||
        (is_pal()
            && is_in_game("PAL")
            && active_character("PAL") == 0x01
            && active_zone("PAL") == 0x01
            && prev(sword_acquired("PAL", "Onikiri")) == 0x00
            && sword_acquired("PAL", "Onikiri") == 0x01)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 25, 3, 37, 4, 35, 10, 32
// https://www.twitch.tv/videos/1501958318 - 38, 15, 19, 40, 14, 34
achievement(
    title = "A Meal Better Eaten Whole",
    description = "Achieve a combo of 40 or higher and defeat the Big Oni on Shura or Shigurui difficulty.",
    points = 10,
    type = "missable",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && current_difficulty("NTSC") == 0x01
        && active_character("NTSC") == 0x01
        && never(active_zone("NTSC") != 0x01)
        && trigger_when(once(prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x32 && (dword_be(combat_pointer("NTSC") + 0x7c)) >= 0x32))
        && trigger_when(prev(sword_acquired("NTSC", "Onikiri")) == 0x00)
        && trigger_when(sword_acquired("NTSC", "Onikiri") == 0x01))
    ||
        (is_pal()
        && is_in_game("PAL")
        && current_difficulty("PAL") == 0x01
        && active_character("PAL") == 0x01
        && never(active_zone("PAL") != 0x01)
        && trigger_when(once(prev(dword_be(combat_pointer("PAL") + 0x7c)) < 0x32 && (dword_be(combat_pointer("PAL") + 0x7c)) >= 0x32))
        && trigger_when(prev(sword_acquired("PAL", "Onikiri")) == 0x00)
        && trigger_when(sword_acquired("PAL", "Onikiri") == 0x01))
)

achievement(
    id = 579991,
    title = "Knockin' on Heaven's Door", // New title: Started From the Bottom, Now We Here
    description = "Seek a way into heaven and entertain the gatekeeper.",
    points = 5,
    type = "progression",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && active_character("NTSC") == 0x01
        && active_zone("NTSC") == 0x05
        && prev(sword_acquired("NTSC", "Mutsunokami Yoshiyuki")) == 0x00
        && sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x01)
    ||
        (is_pal()
        && is_in_game("PAL")
        && active_character("PAL") == 0x01
        && active_zone("PAL") == 0x05
        && prev(sword_acquired("PAL", "Mutsunokami Yoshiyuki")) == 0x00
        && sword_acquired("PAL", "Mutsunokami Yoshiyuki") == 0x01)
)

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 19, 5, 114, 55
// https://www.twitch.tv/videos/1501958318 - 53, 57, 29, 56, 27
achievement(
    title = "Thunderous Performance",
    description = "Defeat Raijin as Momohime on Shura or Shigurui and achieve a combo of 100 or higher.",
    points = 10,
    type = "missable",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && current_difficulty("NTSC") == 0x01
        && active_character("NTSC") == 0x01
        && never(active_zone("NTSC") != 0x05)
        && trigger_when(once(prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0x32 && (dword_be(combat_pointer("NTSC") + 0x7c)) >= 0x32))
        && trigger_when(prev(sword_acquired("NTSC", "Mutsunokami Yoshiyuki")) == 0x00)
        && trigger_when(sword_acquired("NTSC", "Mutsunokami Yoshiyuki") == 0x01))
    ||
        (is_pal()
        && is_in_game("PAL")
        && current_difficulty("PAL") == 0x01
        && active_character("PAL") == 0x01
        && never(active_zone("PAL") != 0x05)
        && trigger_when(once(prev(dword_be(combat_pointer("PAL") + 0x7c)) < 0x32 && (dword_be(combat_pointer("PAL") + 0x7c)) >= 0x32))
        && trigger_when(prev(sword_acquired("PAL", "Mutsunokami Yoshiyuki")) == 0x00)
        && trigger_when(sword_acquired("PAL", "Mutsunokami Yoshiyuki") == 0x01))

)

achievement(
    id = 579992,
    title = "A Whole Body to Yourself",
    description = "Climb the Buddha Hall Statue and free Momohime of possession.",
    points = 5,
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

// Helper data points:
// https://www.nicovideo.jp/watch/sm44851300?via=thumb_watch&at=title&state=unplayed - 0, they just cheese the everliving fuck out of it :)
// https://www.twitch.tv/videos/1501958318 - 
// Could try to highlight the speedrun strat - never achieve a combo and defeat Fudo-Myouu. 
// Probably an UWC though so maybe just highlight the tech in the forum and call it a day.
achievement(
    title = "Surpassing Buddha's Protector",
    description = "Defeat Fudo-Myoou on Shura or Shigurui difficulty without any of your blades breaking.",
    points = 10,
    type = "missable",
    trigger = (is_ntsc()
        && is_in_game("NTSC")
        && current_difficulty("NTSC") == 0x01
        && active_character("NTSC") == 0x01
        && never(active_zone("NTSC") != 0x34) // todo also allow this for other fudo-myoou
        && unless(once(any_blade_broke("NTSC")))
        && trigger_when(prev(sword_acquired("NTSC", "Tsukiotoshi")) == 0x00)
        && trigger_when(sword_acquired("NTSC", "Tsukiotoshi") == 0x01))
    ||
        (is_pal()
        && is_in_game("PAL")
        && current_difficulty("PAL") == 0x01
        && active_character("PAL") == 0x01
        && never(active_zone("PAL") != 0x34) // todo also allow this for other fudo-myoou
        && unless(once(any_blade_broke("PAL")))
        && trigger_when(prev(sword_acquired("PAL", "Tsukiotoshi")) == 0x00)
        && trigger_when(sword_acquired("PAL", "Tsukiotoshi") == 0x01))
)

// *** Lairs ***
// All of these need a stronger fingerprint, I believe I could pop them from a save file currently. 
// Probably not a good look
achievement(
    title = "100 Armed Monks",
    description = "Clear the red enemy lair in Musashi.",
    points = 3,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Musashi")
        && prev(accessory_acquired("NTSC", "Kusarikatabira")) == 0x00
        && accessory_acquired("NTSC", "Kusarikatabira") == 0x01
)

achievement(
    title = "100 Incarnations of Shadowy Ninja",
    description = "Clear the enemy lair in Yamashiro.",
    points = 3,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Yamashiro")
        && prev(accessory_acquired("NTSC", "Chowhound Saucer")) == 0x00
        && accessory_acquired("NTSC", "Chowhound Saucer") == 0x01
)

achievement(
    title = "God of Pestilence",
    description = "Clear the enemy lair in Owari.",
    points = 3,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Owari")
        && prev(accessory_acquired("NTSC", "Cypress Rosary")) == 0x00
        && accessory_acquired("NTSC", "Cypress Rosary") == 0x01
)

achievement(
    title = "Mountain Kagura Dance, the Storm of Tengu",
    description = "Clear the enemy lair in Totomi.",
    points = 5,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Totomi")
        && prev(accessory_acquired("NTSC", "Lucky Mallet")) == 0x00
        && accessory_acquired("NTSC", "Lucky Mallet") == 0x01
)

achievement(
    title = "Toad of Yoro Falls",
    description = "Clear the enemy lair in Mino.",
    points = 5,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Mino")
        && prev(accessory_acquired("NTSC", "Ise Charm")) == 0x00
        && accessory_acquired("NTSC", "Ise Charm") == 0x01
)

achievement(
    title = "Seven Samurai",
    description = "Clear the enemy lair in Mikawa.",
    points = 5,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Mikawa")
        && prev(accessory_acquired("NTSC", "Yamato Miracle Drug")) == 0x00
        && accessory_acquired("NTSC", "Yamato Miracle Drug") == 0x01
)

achievement(
    title = "Snow Woman, Oiran Procession",
    description = "Clear the enemy lair in Hida.",
    points = 5,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Hida")
        && prev(accessory_acquired("NTSC", "Wolfsbane Poison")) == 0x00
        && accessory_acquired("NTSC", "Wolfsbane Poison") == 0x01
)

achievement(
    title = "Courage in the Ghostly Hour",
    description = "Clear the enemy lair in Sagami.",
    points = 5,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Sagami")
        && prev(accessory_acquired("NTSC", "Clapper")) == 0x00
        && accessory_acquired("NTSC", "Clapper") == 0x01
)

achievement(
    title = "Ozaru Stealth Army",
    description = "Clear the enemy lair in Iga.",
    points = 5,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Iga")
        && prev(accessory_acquired("NTSC", "Ninja Socks")) == 0x00
        && accessory_acquired("NTSC", "Ninja Socks") == 0x01
)

achievement(
    title = "Wildlife Caricature",
    description = "Clear the enemy lair in Kai.",
    points = 10,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Kai")
        && prev(accessory_acquired("NTSC", "Hungry Devil Saucer")) == 0x00
        && accessory_acquired("NTSC", "Hungry Devil Saucer") == 0x01
)

achievement(
    title = "The Scheming Yagyuu Clan",
    description = "Clear the enemy lair in Yamato.",
    points = 10,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Yamato")
        && prev(sword_acquired("NTSC", "Jyuzumaru Tsunetsugu")) == 0x00
        && sword_acquired("NTSC", "Jyuzumaru Tsunetsugu") == 0x01
)

achievement(
    title = "Giant Centipede of the Suzuka Pass",
    description = "Clear the enemy lair in Ise.",
    points = 10,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Ise")
        && prev(sword_acquired("NTSC", "Otenta Mitsuyo")) == 0x00
        && sword_acquired("NTSC", "Otenta Mitsuyo") == 0x01
)

achievement(
    title = "Rising Dragon, Lying Dragon",
    description = "Clear the enemy lair in Suruga.",
    points = 10,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Suruga")
        && prev(sword_acquired("NTSC", "Okanehira")) == 0x00
        && sword_acquired("NTSC", "Okanehira") == 0x01
)

achievement(
    title = "Lair of the Oni",
    description = "Clear the enemy lair in Omi.",
    points = 10,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Omi")
        && prev(sword_acquired("NTSC", "Dojigiri Yasutsuna")) == 0x00
        && sword_acquired("NTSC", "Dojigiri Yasutsuna") == 0x01
)

achievement(
    title = "Ghost of the Battle Field",
    description = "Clear the enemy lair in Shinano.",
    points = 10,
    trigger = is_in_game("NTSC")
        && in_zone("NTSC", "Shinano")
        && prev(accessory_acquired("NTSC", "Toyoma Miracle Drug")) == 0x00
        && accessory_acquired("NTSC", "Toyoma Miracle Drug") == 0x01
)

achievement(
    id = 579995,
    title = "Deadly Oboro Arts",
    description = "Forge and collect every blade unique to Momohime.",
    points = 10,
    trigger = (is_ntsc()
        && prev(num_exclusive_swords("NTSC", "Momohime")) == 0x2f
        && measured(num_exclusive_swords("NTSC", "Momohime") == 0x30, when=always_true(), format="raw"))
    || (is_pal()
        && prev(num_exclusive_swords("PAL", "Momohime")) == 0x2f
        && measured(num_exclusive_swords("PAL", "Momohime") == 0x30, when=always_true(), format="raw"))
)

achievement(
    id = 579996,
    title = "Blades of the Amnesiac",
    description = "Forge and collect every blade unique to Kisuke.",
    points = 10,
    trigger = (is_ntsc() 
        && prev(num_exclusive_swords("NTSC", "Kisuke")) == 0x2c
        && measured(num_exclusive_swords("NTSC", "Kisuke") == 0x2d, when=always_true(), format="raw"))
    ||
        (is_pal() 
            && prev(num_exclusive_swords("PAL", "Kisuke")) == 0x2c
            && measured(num_exclusive_swords("PAL", "Kisuke") == 0x2d, when=always_true(), format="raw"))
)

achievement(
    id = 579993,
    title = "Unlimited Muramasa Works",
    description = "Forge and collect all 108 blades.",
    points = 25,
    trigger = (is_ntsc()
        && prev(num_current_swords("NTSC")) == 0x6b
        && measured(num_current_swords("NTSC") == 0x6c, when=always_true(), format="raw")) ||
        (is_pal()
        && prev(num_current_swords("PAL")) == 0x6b
        && measured(num_current_swords("PAL") == 0x6c, when=always_true(), format="raw"))
)

achievement(
    title = "Accessories of Edo",
    description = "Collect every accessory across both characters.",
    points = 10,
    trigger = (is_ntsc()
        && prev(num_current_accessories("NTSC")) == 0x00
        && num_current_accessories("NTSC") == 0x01)
    || 
        (is_pal()
            && prev(num_current_accessories("PAL")) == 0x00
            && num_current_accessories("PAL") == 0x01)
)

achievement(
    id = 579994,
    title = "You'll Never Go Hungry Again",
    description = "Learn all 20 recipes.",
    points = 10,
    trigger = (is_ntsc()
        && prev(num_current_recipes("NTSC") == 0x13)
        && num_current_recipes("NTSC") == 0x14)
    ||
        (is_pal()
        && prev(num_current_recipes("PAL") == 0x13)
        && num_current_recipes("PAL") == 0x14)
)

achievement(
    title = "A Combo of Deadly Proportions", 
    points = 10,
    description = "Achieve a combo of 200 or higher in any fight.",
    trigger =  is_in_game("NTSC") &&
            dword_be(combat_pointer("NTSC") + 0x6c) == 0xc7 &&
            dword_be(combat_pointer("NTSC") + 0x7c) < 0x3e8 &&
            prev(dword_be(combat_pointer("NTSC") + 0x7c)) < 0xc8 &&
            dword_be(combat_pointer("NTSC") + 0x7c) >= 0xc8
)

// absolutely need more RAM digging for this
achievement(
    title = "Total Pandemonium",
    description = "Clear the enemy lair in Izu on Shigurui difficulty.",
    points = 100,
    trigger = always_false()
)

// TODO here we need to fix our "difficulty" function so that we can reduce duplication here
// branches we want:
// - Onsen
// - Credits
// - Fighting a boss
// - Running in any other zone
// - Fishing
// - On the main menu
// Default is 

rich_presence_conditional_display(check_on_main_menu("NTSC"), "On the title screen")
rich_presence_conditional_display(check_on_main_menu("PAL"), "On the title screen")

rich_presence_conditional_display(
    is_ntsc() && in_zone("NTSC", "Onsen"),
    "[{0}] lv. {1} {2} is relaxing in an onsen | {3} / 108 ⚔️ | {4} / 19 📖 | {5} ryo, {6} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_pal() && in_zone("PAL", "Onsen"),
    "[{0}] lv. {1} {2} is resting in an onsen | {3} / 108 ⚔️ | {4} / 19 📖 | {5} ryo, {6} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
) 

rich_presence_conditional_display(
    in_zone("NTSC", "Purple waves scene") || in_zone("NTSC", "Credits"),
    "[{0}] lv. {0} {1} is enjoying the credits | {2} / 108 ⚔️ | {3} / 19 📖 | {4} ryo, {5} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    in_zone("PAL", "Purple waves scene") || in_zone("PAL", "Credits"),
    "[{0}] lv. {0} {1} is enjoying the credits | {2} / 108 ⚔️ | {3} / 19 📖 | {4} ryo, {5} mon",
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    is_shigurui("NTSC"),
    "[Shigurui] lv. {0} {1} is fighting {2} | {3} / 108 ⚔️ | {4} / 19 📖 | {5} ryo, {6} mon",
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_shigurui("PAL"),
    "[Shigurui] lv. {0} {1} is fighting {2} | {3} / 108 ⚔️ | {4} / 19 📖 | {5} ryo, {6} mon",
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    is_fighting_boss("NTSC"), 
    "[{0}] lv. {1} {2} is fighting {3} | {4} / 108 ⚔️ | {5} / 19 📖 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_fighting_boss("PAL"), 
    "[{0}] lv. {1} {2} is fighting {3} | {4} / 108 ⚔️ | {5} / 19 📖 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

rich_presence_conditional_display(
    is_in_game("NTSC"),
    "[{0}] lv. {1} {2} is exploring {3} | {4} / 108 ⚔️ | {5} / 20 📖 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("NTSC"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("NTSC"), "VALUE"),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("NTSC"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("NTSC"), "VALUE"),
    rich_presence_value("Mon", current_mon("NTSC"), "VALUE")
)

rich_presence_conditional_display(
    is_in_game("PAL"),
    "[{0}] lv. {1} {2} is traversing {3} | {4} / 108 ⚔️ | {5} / 20 📖 | {6} ryo, {7} mon",
    rich_presence_lookup("Difficulty", current_difficulty("PAL"), DifficultyLookup),
    rich_presence_value("CurrLevel", current_level("PAL"), "VALUE"),
    rich_presence_lookup("Character", active_character("PAL"), CharacterLookup),
    rich_presence_lookup("Zone", active_zone("PAL"), ZoneLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("PAL"), "VALUE"),
    rich_presence_value("NumCurrentBooks", num_current_recipes("PAL"), "VALUE"),
    rich_presence_value("Ryo", current_ryo("PAL"), "VALUE"),
    rich_presence_value("Mon", current_mon("PAL"), "VALUE")
)

// This is the fallback if everything else fails due to region shenanigans
rich_presence_display("Playing Muramasa: The Demon Blade")