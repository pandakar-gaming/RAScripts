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
function pointer_to_combat() => dword_be(0x474DB0)

// $DA7314: [32-bit Pointer] Pointer to Settings
function pointer_to_settings() => dword(0xDA7314)

// $E67274: Pointer to active combat [32-bit BE Pointer]
//          +0x7c Active Combo
function pointer_to_active_combat() => dword_be(0xE67274)

function active_character(region) {
    if (region == "PAL") {

    } else if (region == "NTSC") {
        return byte(mask_ptr(0x00e27038) + 0x1d4)
    }
}

CharacterLookup = {
    0x00: "Kisuke",
    0x01: "Momohime"
}

function active_zone(region) {
    if (region == "PAL") {
        
    } else if (region == "NTSC") {

    }
}

ZoneLookup = {
    0x00: "PLACEHOLDER TODO REPLACE ME"
}

function active_sword(region) {
    if (region == "PAL") {
        
    } else if (region == "NTSC") {
        return word_be(mask_ptr(0x00e27038) + 0x204)
    }
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

ActiveSwordLookup = {
    0x0c: "Chizuru Muramasa",
    0x0d: "Hisui",
    0x0e: "Sazanami",
    0x0f: "Ayame Muramasa",
    0x11: "Hasebese Kunishige",
    0x12: "Botan Muramasa",
}

// can do Blue Monk boss trigger on blade get

achievement(
    title = "[TEST] Active Combo", points = 0,
    description = "x50 plz",
    trigger = prev(dword_be((dword_be((pointer_to_combat() & 0x1FFFFFFF) + 0x000014) & 0x1FFFFFFF) + 0x00007C)) < 0x32 &&
              measured(dword_be((dword_be((pointer_to_combat() & 0x1FFFFFFF) + 0x000014) & 0x1FFFFFFF) + 0x00007C) >= 0x32)
)

achievement(
    title = "TEST RP CONDITIONS",
    points = 0,
    description = "send help",
    trigger = dword_be(dword_be(0x00e27038) + 0x1d8) == 0xffffffff
)

rich_presence_display("[ {0} ] Momohime is traveling [LVL HERE] ({1} / {2}) with {3} $",
    rich_presence_lookup("Difficulty", ntsc_difficulty(), DifficultyLookup),
    rich_presence_value("Number", dword_be((dword_be(0x00e27038) & 0x1FFFFFFF) + 0x1d8)),
    rich_presence_value("Number", dword_be((dword_be(0x00e27038) & 0x1FFFFFFF) + 0x1dc)),
    rich_presence_value("Number", dword_be((dword_be(0x00e27038) & 0x1FFFFFFF) + 0x1f0))
)

// Goal RP: 
//"[${Difficulty}] lv. ${Level} ${Character} is tearing through ${Zone} with ${CurrentBlade} | ${NumCurrentSwords} / ${MaxSwords} ⚔️ |${Money}"
// Lvl is calculated on the fly, money is split into two and calculated on the fly
rich_presence_display("[{0}] {1} is tearing through PLACEHOLDER_ZONE with {2} | {3} / 108 ⚔️",
    rich_presence_lookup("Difficulty", ntsc_difficulty(), DifficultyLookup),
    rich_presence_lookup("Character", active_character("NTSC"), CharacterLookup),
    // rich_presence_lookup("Zone", active_zone("NTSC"), ZoneLookup),
    rich_presence_lookup("ActiveSword", active_sword("NTSC"), ActiveSwordLookup),
    rich_presence_value("NumCurrentSwords", num_current_swords("NTSC"))
)