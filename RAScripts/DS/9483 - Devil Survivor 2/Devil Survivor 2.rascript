// Devil Survivor 2
// #ID=9483
// md5: 4b1ee25404620aed63ee09f24a9a6db5

// General note for myself: DS pointers usually take the form of 0x02xxxxxx
// However, the DS only has 4MB of RAM so with RA addressing you can just take the 24 bytes denoted by xxxxxx and deref that
// Because of that, this script has two named variables per ptr until I figure out a more elegant way to reference this

in_game_clock = word(0x00284ab4)
day = byte(0x00284aba)
macca = dword(0x00284a98)
current_location = byte(0x00284da9)
current_city = byte(0x00284d85)
current_combat_event = word(0x00284abe)
// Game stores most recent 12 missions and their IDs in an array, this is the last value in the array
most_recent_mission = word(0x00284fae)
current_event = word(0x00198824)
full_combat_ptr = dword(0x001be0ac)
combat_ptr = tbyte(0x001be0ac)
full_team_array_ptr = dword(0x001be040)
team_array_ptr = tbyte(0x001be040)
// both of these are counted in frames, game runs @ 30fps
current_time_in_mission = dword(combat_ptr + 0x10)
total_time_in_mission = dword(combat_ptr + 0x28)
// yet for whatever reason this is counted at 60 fps?
in_game_time = tbyte(0x00284480)
// for now splitting into two named addresses
// maybe later we optimize but I like having both on hand
full_auction_ptr = dword(0x001be73c)
auction_ptr = tbyte(0x001be73c)
battle_tutorials = byte(0x00284ad7)
auction_unlock_eligibility = 0x00284ad0
auctions_unlocked = 0x00284acb

// Assert whether a DS pointer is valid.
// This checks that the given 32-bit value looks like a DS pointer, which takes the form of 0x02xxxxxx.
function ptr_valid(addr) => addr != 0x00 && addr >= 0x02000000 && addr <= 0x02ffffff
// This is not indicative of combat on its own. All combat happens on grids though!
function on_grid_map() => byte(0x00284abb) == 0x01
// This checks the 16-bit value at 0x00284abe to see if it's anything other than "null." 
// This is correlated with being on combat. 
// The address in question was believed to be "combat event id" or something similar but a duplicate was witnessed on a death clip combat.
// This address consistently changes to *something* when you're in a combat event though!
function in_combat() => word(0x00284abe) != 0xffff
// Whenever you're in an event (combat or otherwise) the 8-bit value at 0x00284ab8 is set to 0x1e. 
// I'm not sure why that is significant, however it is a helpful fingerprint to know if the player is doing something.
function actively_in_event() => byte(0x00284ab8) == 0x1e
active_combat_mission_id = word(0x00284abe)

// This does not confirm what combat mission you're on, just that you're in one.
// @param mission_name the String name of the mission that the player would see.
// @param event_id temporary variable to avoid mapping the events by id.
function on_mission(mission_name, event_id) {
    return actively_in_event() 
        && active_combat_mission_id == combat_missions_by_name[mission_name]
        && most_recent_mission == event_id
}

// Check if the team taking their turn is engaged in combat.
function active_unit_in_combat() {
    return bit0(combat_ptr + 0x1c) == 0
}

// Check if the team taking their turn is a friendly unit and is moving around.
function friendly_unit_moving() {
    return bit1(combat_ptr + 0x1c) == 0 && bit0(combat_ptr + 0x1c) == 1
}

// Check if the team taking their turn is a hostile unit and is moving around.
function hostile_unit_moving() {
    return bit1(combat_ptr + 0x1c) == 1 && bit0(combat_ptr + 0x1c) == 1
}

// This is checking if the player *ever* entered a free battle, not if they're currently in one.
// This is done by seeing if the player ever saw the tutorials for how Free Combat works.
function entered_free_battle() => bit0(0x00284ad7) == 0x01 || bit1(0x00284ad7) == 0x01

full_attacker_team_ptr = dword(0x001c9fd0)
attacker_team_ptr = tbyte(0x001c9fd0)
full_defender_team_ptr = dword(0x001c9fd4)
defender_ptr = tbyte(0x001c9fd4)
// Check if the enemy we're looking for is the defending team in this active combat.
// We only care about the enemy leader for the most part; side enemies are hopefully not notable enough for most achievements.
function defender_leader_is(enemy_name) => ptr_valid(full_defender_team_ptr) && word(defender_ptr + 0x0a) == enemy_id_by_name[enemy_name]

// Check if the enemy we're looking for is the attacking team in this active combat.
// We only care about the enemy leader for the most part; side enemies are hopefully not notable enough for most achievements.
function attacker_leader_is(enemy_name) => ptr_valid(full_attacker_team_ptr) && word(attacker_team_ptr + 0x0a) == enemy_id_by_name[enemy_name]

// See if the attacking leader was defeated in this particular combat.
function attacker_leader_defeated() => ptr_valid(full_attacker_team_ptr)  && unit_defeated(attacker_team_ptr + 0x18)
// See if the unit on the left side of the attacker's team was defeated in this particular combat.
function attacker_left_unit_defeated() => ptr_valid(full_attacker_team_ptr) && unit_defeated(attacker_team_ptr + 0xbc)
// See if the unit on the right side of the attacker's team was defeated in this particular combat.
function attacker_right_unit_defeated() => ptr_valid(full_attacker_team_ptr) && unit_defeated(attacker_team_ptr + 0x160)

// See if the defending leader was defeated in this particular combat.
function defender_leader_defeated() => ptr_valid(full_defender_team_ptr) && unit_defeated(defender_ptr + 0x18)
// See if the unit on the left side of the defender's team was defeated in this combat.
function defender_left_unit_defeated() => ptr_valid(full_defender_team_ptr) && unit_defeated(defender_ptr + 0xbc)
// See if the unit on the right side of the defender's team was defeated in combat.
function defender_right_unit_defeated() => ptr_valid(full_defender_team_ptr) && unit_defeated(defender_ptr + 0x160)

// Determine if the specific unit was just defeated.
// A "unit" is either a team leader or a demon. 
// Input: address of unit's current health. It is expected that the max health is directly 0x02 after and is the same size. 
function unit_defeated(addr_unit_current_health) {
    return prev(word(addr_unit_current_health)) <= word(addr_unit_current_health + 0x02) && word(addr_unit_current_health) == 0x00
}

function character_alive(char_name) {
    // for whatever reason no characters exist from 0x00 -> 0x02
    char_index = chararacter_ids_by_name[char_name] - 0x03

    return bit1(0x00284dc2 + (0x10 * char_index)) == 0
}

function team_moves_to_coord(team_offset, x, y) {
    cond = ptr_valid(full_combat_ptr)
    cond = cond && team_moves_to_x(team_offset, x)
    cond = cond && team_moves_to_y(team_offset, y)
    return cond
}

function team_moves_to_x(team_offset, x) {
    cond = ptr_valid(full_team_array_ptr)
    cond = cond && prev(byte(team_array_ptr + (0x27c * team_offset) + 0x1f2)) != x && byte(team_array_ptr + (0x27c * team_offset) + 0x1f2) == x
    return cond
}

function team_moves_to_y(team_offset, y) {
    cond = ptr_valid(full_team_array_ptr)
    cond = cond && prev(byte(team_array_ptr + (0x27c * team_offset) + 0x1f3)) != y && byte(team_array_ptr + (0x27c * team_offset) + 0x1f3) == y
    return cond
}

// macca + extra
function true_auction_cost() => dword(full_auction_ptr + 0x1cc) + dword(full_auction_ptr + 0x1e4)

// I would do by id/offset BUT THEY PUT GAPS IN BETWEEN SOME.
// They also intermingle demons you can get and demons/enemies you can't get in the Compendium
// in the compendium list itself, because internally it's probably all just entities of the same size anyway
// Instead, what I'll be doing is: 
// - for every demon that the handy Gamefaqs guides have listed as possible, note on RA
// - each one of those will be re-referenced here using the start of their block
// - for achievements, helper functions to check by name
// - which will then reference this map and apply same "did it get checked off" logic
monster_addr_by_name = {
    "Tonatiuh":      0x00285074,
    "Chernobog":     0x00285094,
    "Wu Kong":       0x002850b4,
    "Susano-o":      0x002850d4,
    "Kartikeya":     0x002850f4,
    "Shiva":         0x00285114,
    "Hathor":        0x00285134,
    "Sarasvati":     0x00285154,
    "Kikuri-Hime":   0x00285174,
    "Brigid":        0x00285194,
    "Scathach":      0x002851b4,
    "Laksmi":        0x002851d4,
    "Norn":          0x002851f4,
    "Isis":          0x00285214,
    "Amaterasu":     0x00285234,
    "Mahakala":      0x00285254,
    "Thor":          0x00285274,
    "Arahabaki":     0x00285294,
    "Odin":          0x002852b4,
    "Yama":          0x002852d4,
    "Lugh":          0x002852f4,
    "Baal":          0x00285314,
    "Asura":         0x00285334,
    "Orcus":         0x00285354,
    "Pazuzu":        0x00285374,
    "Abaddon":       0x00285394,
    "Tao Tie":       0x002853b4,
    "Arioch":        0x002853d4,
    "Tezcatlipoca":  0x002853f4,
    "Nyarlathotep":  0x00285414,
    "Makara":        0x00285434,
    "Nozuchi":       0x00285454,
    "Pendragon":     0x00285474,
    "Gui Xian":      0x00285494,
    "Quetzalcoatl":  0x002854b4,
    "Seiryuu":       0x002854d4,
    "Orochi":        0x002854f4,
    "Ananta":        0x00285514,
    "Hoyau Kamui":   0x00285534,
    "Toubyou":       0x00285554,
    "Bai Suzhen":    0x00285574,
    "Basilisk":      0x00285594,
    "Ym":            0x002855b4,
    "Python":        0x002855d4,
    "Culebre":       0x002855f4,
    "Vritra":        0x00285614,
    "Vasuki":        0x00285634,
    "Angel":         0x00285674,
    "Power":         0x00285694,
    "Lailah":        0x002856b4,
    "Aniel":         0x002856d4, 
    "Kazfiel":       0x002856f4,
    "Remiel":        0x00285714,
    "Metatron":      0x00285734,
    "Itsumade":      0x00285754,
    "Moh Shuvuu":    0x00285774,
    "Hamsa":         0x00285794,
    "Suparna":       0x002857b4,
    "Vidofnir":      0x002857d4,
    "Badb Catha":    0x002857f4,
    "Anzu":          0x00285814,
    "Feng Huang":    0x00285834,
    "Garuda":        0x00285854,
    "Gagyson":       0x00285874,
    "Abraxas":       0x00285894,
    "Flauros":       0x002858b4,
    "Nisroc":        0x002858d4,
    "Orobas":        0x002858f4,
    "Decarabia":     0x00285914,
    "Nebiros":       0x00285934,
    "Agares":        0x00285954,
    "Murmur":        0x00285974,
    "Heqet":         0x00285994,
    "Kamapua'a":     0x002859b4,
    "Shiisaa":       0x002859d4,
    "Bai Ze":        0x002859f4,
    "Baihu":         0x00285a14,
    "Airavata":      0x00285a34,
    "Ukano Mitama":  0x00285a54,
    "Barong":        0x00285a74,
    "Anubis":        0x00285a94,
    "Kabuso":        0x00285ab4,
    "Hairy Jack":    0x00285ad4,
    "Nekomata":      0x00285af4,
    "Cait Sith":     0x00285b14,
    "Nue":           0x00285b34,
    "Orthrus":       0x00285b54,
    "Myrmecolion":   0x00285b74,
    "Cerberus":      0x00285b94,
    "Fenrir":        0x00285bb4,
    "Hare of Inaba": 0x00285bd4,
    "Waira":         0x00285bf4,
    "Garm":          0x00285c14,
    "Afanc":         0x00285c34,
    "Mothman":       0x00285c54,
    "Taown":         0x00285c74,
    "Behemoth":      0x00285c94,
    "Ammut":         0x00285cb4,
    "Tam Lin":       0x00285cd4,
    "Jambavan":      0x00285cf4,
    "Tlaloc":        0x00285d14,
    "Ictinike":      0x00285d34,
    "Hanuman":       0x00285d54,
    "Cu Chulainn":   0x00285d74,
    "Kresnik":       0x00285d94,
    "Ganesha":       0x00285db4,
    "Heimdall":      0x00285dd4,
    "Pixie":         0x00285df4,
    "Knocker":       0x00285e14,
    "Kijimunaa":     0x00285e34,
    "Jack Frost":    0x00285e54,
    "Pyro Jack":     0x00285e74,
    "Silky":         0x00285e94,
    "Lorelei":       0x00285eb4,
    "Vivian":        0x00285ed4,
    "Titania":       0x00285ef4,
    "Oberon":        0x00285f14,
    "King Frost":    0x00285f34,
    "Moloch":        0x00285f54,
    "Hecate":        0x00285f74,
    "Tzitzmitl":     0x00285f94,
    "Astaroth":      0x00285fb4,
    "Mot":           0x00285fd4,
    "Loki":          0x00285ff4,
    "Lucifer":       0x00286014,
    "Ubelluris":      0x00286034,
    "Nalagiri":       0x00286054,
    "Hitokotonusi":   0x00286074,
    "Take-Mikazuchi": 0x00286094,
    "Zouchouten":    0x002860b4,
    "Jikokuten":     0x002860d4,
    "Koumokuten":    0x002860f4,
    "Bishamonten":   0x00286114,
    "Zaou Gongen":   0x00286134,
    "Kobold":        0x00286154,
    "Bilwis":        0x00286174,
    "Gozuki":        0x00286194,
    "Mezuki":        0x002861b4,
    "Ikusa":         0x002861d4,
    "Lham Dearg":    0x002861f4,
    "Berserker":     0x00286214,
    "Yaksa":         0x00286234,
    "Nata Taishi":   0x00286254,
    "Oumitsunu":     0x00286274,
    "Obariyon":      0x00286294,
    "Ogre":          0x002862b4,
    "Mokoi":         0x002862d4,
    "Ogun":          0x002862f4,
    "Wendigo":       0x00286314,
    "Legion":        0x00286334,
    "Rakshasa":      0x00286354,
    "Girimehkala":   0x00286374,
    "Grendel":       0x00286394,
    "Black Frost":   0x002863b4,
    "Kikimora":      0x002863d4,
    "Lilim":         0x002863f4,
    "Yuki Jyorou":   0x00286414,
    "Leanan Sidhe":  0x00286434,
    "Peri":          0x00286454,
    "Hariti":        0x00286474,
    "Rangda":        0x00286494,
    "Kali":          0x002864b4,
    "Lilith":        0x002864d4,
    "Poltergeist":   0x002864f4,
    "Agathion":      0x00286514,
    "Tenong Cut":    0x00286534,
    "Kumbhanda":     0x00286554,
    "Loa":           0x00286574,
    "Pisaca":        0x00286594,
    "Kudlak":        0x002865b4,
    "Purple Mirror": 0x002865d4,
    "Billiken":      0x002865f4,
    "Ghost Q":       0x00286614,
    "Sage of Time":  0x00286634,
    "Alice":         0x00286654,
    "Trumpeter":     0x00286674,
    "Neko Shogun":   0x00286694,
    "Hagen":         0x002866b4,
    "Jeanne d'Arc":  0x002866d4,
    "Yoshitsune":    0x002866f4,
    "Guan Yu":       0x00286714,
    "Flaemis":       0x00286734,
    "Aquans":        0x00286754,
    "Aeros":         0x00286774,
    "Erthys":        0x00286794,
    "Ara Mitama":    0x002867b4,
    "Nigi Mitama":   0x002867d4,
    "Kusi Mitama":   0x002867f4,
    "Saki Mitama":   0x00286814,
    "Satan":         0x00286954,
    "Beelzebub":     0x00286974,
    "Belial":        0x00286994,
    "Asp":           0x00286a74,
    "Apis":          0x00286a94,
    "Pabilsag":      0x00286ab4,
    "Sleipnir":      0x00286ad4,
    "Xiezhai":       0x00286af4,
    "Kangiten":      0x00286b14,
    "Baphomet":      0x00286b34,
    "Anat":          0x00286b54,
    "Pallas Athena": 0x00286b74,
    "Mithra":        0x00286b94,
    "Osiris":        0x00286bb4,
    "Gucumatz":      0x00286bd4,
    "Da Peng":       0x00286bf4,
    "Ometeotl":      0x00286c14,
    "Jarilo":        0x00286c34,
    "Botis":         0x00286c54,
    "Bifrons":       0x00286db4,
    "Barbatos":      0x00286dd4,
    "Dzelarhons":    0x00286df4,
    "Kama":          0x00286e14,
    "Parvati":       0x00286e34,
    "Ixtab":         0x00286e54,
    "Balor":         0x00286e74,
    "Nergal":        0x00286e94,
    "Inti":          0x00286eb4,
    "Alilat":        0x00286ed4,
    "Beiji-Weng":    0x00286ef4,
    "Lord Nan Dou":  0x00286f14,
    "Masakado":      0x00286f34
}

// I hate everything.
// This map is needed because enemy IDs loosely follow what the compendium lists, but there's other entities intermingled in there.
// Other entities being different variants of an enemy, human characters, other enemies that don't line up or appear otherwise in compendium
// The compendium itself also skips over some of the entries, i.e. there aren't empty slots between the following two entries
//    "Botis":         0xf0,
//    "Bifrons":       0x116,
// so we just gotta rattle 'em off.
enemy_id_by_name = {
    "Ronaldo":       0x01,
    // I have to PRESUME that other human controllable characters you can fight go here.
    // i.e. this now goes from Io -> Anguished One, placing Anguished One at 0x0d
    "Io":            0x02,
    "Yamato":        0x03,
    "Fumi":          0x04,
    "Daichi":        0x05,
    "Otome":         0x06,
    "Jungo":         0x07,
    "Makoto":        0x08,
    "Keita":         0x09,
    "Airi":          0x0a,
    "Joe":           0x0b,
    "Hinako":        0x0c,
    "Anguished One": 0x0d,
    // End of presumed character IDs 
    "Tonatiuh":      0x0e,
    "Chernobog":     0x0f,
    "Wu Kong":       0x10,
    "Susano-o":      0x11,
    "Kartikeya":     0x12,
    "Shiva":         0x13,
    "Hathor":        0x14,
    "Sarasvati":     0x15,
    "Kikuri-Hime":   0x16,
    "Brigid":        0x17,
    "Scathach":      0x18,
    "Laksmi":        0x19,
    "Norn":          0x1a,
    "Isis":          0x1b,
    "Amaterasu":     0x1c,
    "Mahakala":      0x1d,
    "Thor":          0x1e,
    "Arahabaki":     0x1f,
    "Odin":          0x20,
    "Yama":          0x21,
    "Lugh":          0x22,
    "Baal":          0x23,
    "Asura":         0x24,
    "Orcus":         0x25,
    "Pazuzu":        0x26,
    "Abaddon":       0x27,
    "Tao Tie":       0x28,
    "Arioch":        0x29,
    "Tezcatlipoca":  0x2a,
    "Nyarlathotep":  0x2b,
    "Makara":        0x2c,
    "Nozuchi":       0x2d,
    "Pendragon":     0x2e,
    "Gui Xian":      0x2f,
    "Quetzalcoatl":  0x30,
    "Seiryuu":       0x31,
    "Orochi":        0x32,
    "Ananta":        0x33,
    "Hoyau Kamui":   0x34,
    "Toubyou":       0x35,
    "Bai Suzhen":    0x36,
    "Basilisk":      0x37,
    "Ym":            0x38,
    "Python":        0x39,
    "Culebre":       0x3a,
    "Vritra":        0x3b,
    "Vasuki":        0x3c,
    // My notes indicate something called "Holy Ghost" is 0x3d, but I don't know if that's a real thing you can encounter
    "Angel":         0x3e,
    "Power":         0x3f,
    "Lailah":        0x40,
    "Aniel":         0x41, 
    "Kazfiel":       0x42,
    "Remiel":        0x43,
    "Metatron":      0x44,
    "Itsumade":      0x45,
    "Moh Shuvuu":    0x46,
    "Hamsa":         0x47,
    "Suparna":       0x48,
    "Vidofnir":      0x49,
    "Badb Catha":    0x4a,
    "Anzu":          0x4b,
    "Feng Huang":    0x4c,
    "Garuda":        0x4d,
    "Gagyson":       0x4e,
    "Abraxas":       0x4f,
    "Flauros":       0x50,
    "Nisroc":        0x51,
    "Orobas":        0x52,
    "Decarabia":     0x53,
    "Nebiros":       0x54,
    "Agares":        0x55,
    "Murmur":        0x56,
    "Heqet":         0x57,
    "Kamapua'a":     0x58,
    "Shiisaa":       0x59,
    "Bai Ze":        0x5a,
    "Baihu":         0x5b,
    "Airavata":      0x5c,
    "Ukano Mitama":  0x5d,
    "Barong":        0x5e,
    "Anubis":        0x5f,
    "Kabuso":        0x60,
    "Hairy Jack":    0x61,
    "Nekomata":      0x62,
    "Cait Sith":     0x63,
    "Nue":           0x64,
    "Orthrus":       0x65,
    "Myrmecolion":   0x66,
    "Cerberus":      0x67,
    "Fenrir":        0x68,
    "Hare of Inaba": 0x69,
    "Waira":         0x6a,
    "Garm":          0x6b,
    "Afanc":         0x6c,
    "Mothman":       0x6d,
    "Taown":         0x6e,
    "Behemoth":      0x6f,
    "Ammut":         0x70,
    "Tam Lin":       0x71,
    "Jambavan":      0x72,
    "Tlaloc":        0x73,
    "Ictinike":      0x74,
    "Hanuman":       0x75,
    "Cu Chulainn":   0x76,
    "Kresnik":       0x77,
    "Ganesha":       0x78,
    "Heimdall":      0x79,
    "Pixie":         0x7a,
    "Knocker":       0x7b,
    "Kijimunaa":     0x7c,
    "Jack Frost":    0x7d,
    "Pyro Jack":     0x7e,
    "Silky":         0x7f,
    "Lorelei":       0x80,
    "Vivian":        0x81,
    "Titania":       0x82,
    "Oberon":        0x83,
    "King Frost":    0x84,
    "Moloch":        0x85,
    "Hecate":        0x86,
    "Tzitzmitl":     0x87,
    "Astaroth":      0x88,
    "Mot":           0x89,
    "Loki":          0x8a,
    "Lucifer":       0x8b,
    "Ubelluris":     0x8c,
    "Nalagiri":       0x8d,
    "Hitokotonusi":   0x8e,
    "Take-Mikazuchi": 0x8f,
    "Zouchouten":    0x90,
    "Jikokuten":     0x91,
    "Koumokuten":    0x92,
    "Bishamonten":   0x93,
    "Zaou Gongen":   0x94,
    "Kobold":        0x95,
    "Bilwis":        0x96,
    "Gozuki":        0x97,
    "Mezuki":        0x98,
    "Ikusa":         0x99,
    "Lham Dearg":    0x9a,
    "Berserker":     0x9b,
    "Yaksa":         0x9c,
    "Nata Taishi":   0x9d,
    "Oumitsunu":     0x9e,
    "Obariyon":      0x9f,
    "Ogre":          0xa0,
    "Mokoi":         0xa1,
    "Ogun":          0xa2,
    "Wendigo":       0xa3,
    "Legion":        0xa4,
    "Rakshasa":      0xa5,
    "Girimehkala":   0xa6,
    "Grendel":       0xa7,
    "Black Frost":   0xa8,
    "Kikimora":      0xa9,
    "Lilim":         0xaa,
    "Yuki Jyorou":   0xab,
    "Leanan Sidhe":  0xac,
    "Peri":          0xad,
    "Hariti":        0xae,
    "Rangda":        0xaf,
    "Kali":          0xb0,
    "Lilith":        0xb1,
    "Poltergeist":   0xb2,
    "Agathion":      0xb3,
    "Tenong Cut":    0xb4,
    "Kumbhanda":     0xb5,
    "Loa":           0xb6,
    "Pisaca":        0xb7,
    "Kudlak":        0xb8,
    "Purple Mirror": 0xb9,
    "Billiken":      0xba,
    "Ghost Q":       0xbb,
    "Sage of Time":  0xbc,
    "Alice":         0xbd,
    "Trumpeter":     0xbe,
    "Neko Shogun":   0xbf,
    "Hagen":         0xc0,
    "Jeanne d'Arc":  0xc1,
    "Yoshitsune":    0xc2,
    "Guan Yu":       0xc3,
    "Flaemis":       0xc4,
    "Aquans":        0xc5,
    "Aeros":         0xc6,
    "Erthys":        0xc7,
    "Ara Mitama":    0xc8,
    "Nigi Mitama":   0xc9,
    "Kusi Mitama":   0xca,
    "Saki Mitama":   0xcb,
    "Megrez":        0xcf,
    "Satan":         0xd5,
    "Beelzebub":     0xd6,
    "Belial":        0xd7,
    "Asp":           0xe0,
    "Apis":          0xe1,
    "Pabilsag":      0xe2,
    "Sleipnir":      0xe3,
    "Xiezhai":       0xe4,
    "Kangiten":      0xe5,
    "Baphomet":      0xe6,
    "Anat":          0xe7,
    "Pallas Athena": 0xe8,
    "Mithra":        0xe9,
    "Osiris":        0xea,
    "Gucumatz":      0xeb,
    "Da Peng":       0xec,
    "Ometeotl":      0xed,
    "Jarilo":        0xee,
    "Botis":         0xf0,
    "Salaryman":     0xf2,  // App Abuser Amrita/Phys Up/Hustle
    "Punk":          0xf9,  // App Abuser Snipe/Mana Bonus/Hustle
    "Young Man":     0x10c, // App Abuser Extra Cancel/Extra Bonus/Hustle
    "Dubhe (Whole)": 0x114, // Dubhe that can reflect phys and null others
    "Dubhe (Half)":  0x115, 
    "Bifrons":       0x116,
    "Barbatos":      0x117,
    "Dzelarhons":    0x118,
    "Kama":          0x119,
    "Parvati":       0x11a,
    "Ixtab":         0x11b,
    "Balor":         0x11c,
    "Nergal":        0x11d,
    "Inti":          0x11e,
    "Alilat":        0x11f,
    "Beiji-Weng":    0x120,
    "Lord Nan Dou":  0x121,
    "Masakado":      0x122,
    "Tall Woman":    0x134, // Makoto in Daichi's Crisis
    "Vacant Woman":  0x164, // Fumi in Demon-Hacked
}

// This map is strictly getting enemies that can lead teams. That's it.
// too many goddamn dicts in this script already
enemy_name_by_id = {
    0x00: "Hero", // That's what the game calls him!
    0x01: "Ronaldo",
    0x02: "Io",
    // "Yamato":        0x03,
    // "Fumi":          0x04,
    0x05: "Daichi",
    // "Otome":         0x06,
    // "Jungo":         0x07,
    // "Makoto":        0x08,
    // "Keita":         0x09,
    0x09: "Keita",
    // "Airi":          0x0a,
    0x0b: "Joe",
    0x0c: "Hinako",
    // "Anguished One": 0x0d,
    // End of presumed character IDs 
    // "Tonatiuh":      0x0e,
    // "Chernobog":     0x0f,
    // "Wu Kong":       0x10,
    // "Susano-o":      0x11,
    // "Kartikeya":     0x12,
    // "Shiva":         0x13,
    // "Hathor":        0x14,
    // "Sarasvati":     0x15,
    // "Kikuri-Hime":   0x16,
    // "Brigid":        0x17,
    // "Scathach":      0x18,
    // "Laksmi":        0x19,
    // "Norn":          0x1a,
    // "Isis":          0x1b,
    // "Amaterasu":     0x1c,
    // "Mahakala":      0x1d,
    // "Thor":          0x1e,
    // "Arahabaki":     0x1f,
    // "Odin":          0x20,
    // "Yama":          0x21,
    // "Lugh":          0x22,
    // "Baal":          0x23,
    // "Asura":         0x24,
    // "Orcus":         0x25,
    // "Pazuzu":        0x26,
    // "Abaddon":       0x27,
    // "Tao Tie":       0x28,
    // "Arioch":        0x29,
    // "Tezcatlipoca":  0x2a,
    // "Nyarlathotep":  0x2b,
    // "Makara":        0x2c,
    // "Nozuchi":       0x2d,
    // "Pendragon":     0x2e,
    // "Gui Xian":      0x2f,
    // "Quetzalcoatl":  0x30,
    // "Seiryuu":       0x31,
    // "Orochi":        0x32,
    // "Ananta":        0x33,
    // "Hoyau Kamui":   0x34,
    0x35: "Toubyou",
    0x36: "Bai Suzhen",
    // "Basilisk":      0x37,
    // "Ym":            0x38,
    // "Python":        0x39,
    // "Culebre":       0x3a,
    // "Vritra":        0x3b,
    // "Vasuki":        0x3c,
    // My notes indicate something called "Holy Ghost" is 0x3d, but I don't know if that's a real thing you can encounter
    // "Angel":         0x3e,
    // "Power":         0x3f,
    // "Lailah":        0x40,
    // "Aniel":         0x41, 
    // "Kazfiel":       0x42,
    // "Remiel":        0x43,
    // "Metatron":      0x44,
    0x45: "Itsumade",
    // "Moh Shuvuu":    0x46,
    // "Hamsa":         0x47,
    // "Suparna":       0x48,
    // "Vidofnir":      0x49,
    // "Badb Catha":    0x4a,
    // "Anzu":          0x4b,
    // "Feng Huang":    0x4c,
    // "Garuda":        0x4d,
    0x4e: "Gagyson",
    // "Abraxas":       0x4f,
    // "Flauros":       0x50,
    // "Nisroc":        0x51,
    // "Orobas":        0x52,
    // "Decarabia":     0x53,
    // "Nebiros":       0x54,
    // "Agares":        0x55,
    // "Murmur":        0x56,
    // "Heqet":         0x57,
    // "Kamapua'a":     0x58,
    // "Shiisaa":       0x59,
    // "Bai Ze":        0x5a,
    // "Baihu":         0x5b,
    // "Airavata":      0x5c,
    // "Ukano Mitama":  0x5d,
    // "Barong":        0x5e,
    // "Anubis":        0x5f,
    0x60: "Kabuso",
    // "Hairy Jack":    0x61,
    // "Nekomata":      0x62,
    // "Cait Sith":     0x63,
    // "Nue":           0x64,
    // "Orthrus":       0x65,
    // "Myrmecolion":   0x66,
    // "Cerberus":      0x67,
    // "Fenrir":        0x68,
    0x69: "Hare of Inaba",
    0x6a: "Waira",
    // "Garm":          0x6b,
    // "Afanc":         0x6c,
    // "Mothman":       0x6d,
    // "Taown":         0x6e,
    // "Behemoth":      0x6f,
    // "Ammut":         0x70,
    // "Tam Lin":       0x71,
    // "Jambavan":      0x72,
    // "Tlaloc":        0x73,
    // "Ictinike":      0x74,
    // "Hanuman":       0x75,
    // "Cu Chulainn":   0x76,
    // "Kresnik":       0x77,
    // "Ganesha":       0x78,
    // "Heimdall":      0x79,
    0x7a: "Pixie",
    0x7b: "Knocker",
    // "Kijimunaa":     0x7c,
    // "Jack Frost":    0x7d,
    // "Pyro Jack":     0x7e,
    // "Silky":         0x7f,
    // "Lorelei":       0x80,
    // "Vivian":        0x81,
    // "Titania":       0x82,
    // "Oberon":        0x83,
    // "King Frost":    0x84,
    // "Moloch":        0x85,
    // "Hecate":        0x86,
    // "Tzitzmitl":     0x87,
    // "Astaroth":      0x88,
    // "Mot":           0x89,
    // "Loki":          0x8a,
    // "Lucifer":       0x8b,
    // "Ubelluris":     0x8c,
    // "Nalagiri":       0x8d,
    // "Hitokotonusi":   0x8e,
    // "Take-Mikazuchi": 0x8f,
    // "Zouchouten":    0x90,
    // "Jikokuten":     0x91,
    // "Koumokuten":    0x92,
    // "Bishamonten":   0x93,
    // "Zaou Gongen":   0x94,
    0x95: "Kobold",
    0x96: "Bilwis",
    // "Gozuki":        0x97,
    // "Mezuki":        0x98,
    // "Ikusa":         0x99,
    // "Lham Dearg":    0x9a,
    // "Berserker":     0x9b,
    // "Yaksa":         0x9c,
    // "Nata Taishi":   0x9d,
    // "Oumitsunu":     0x9e,
    0x9f: "Obariyon",
    // "Ogre":          0xa0,
    // "Mokoi":         0xa1,
    // "Ogun":          0xa2,
    // "Wendigo":       0xa3,
    // "Legion":        0xa4,
    // "Rakshasa":      0xa5,
    // "Girimehkala":   0xa6,
    // "Grendel":       0xa7,
    // "Black Frost":   0xa8,
    // "Kikimora":      0xa9,
    // "Lilim":         0xaa,
    // "Yuki Jyorou":   0xab,
    // "Leanan Sidhe":  0xac,
    // "Peri":          0xad,
    // "Hariti":        0xae,
    // "Rangda":        0xaf,
    // "Kali":          0xb0,
    // "Lilith":        0xb1,
    0xb2: "Poltergeist",
    0xb3: "Agathion",
    // "Tenong Cut":    0xb4,
    // "Kumbhanda":     0xb5,
    // "Loa":           0xb6,
    // "Pisaca":        0xb7,
    // "Kudlak":        0xb8,
    // "Purple Mirror": 0xb9,
    // "Billiken":      0xba,
    // "Ghost Q":       0xbb,
    // "Sage of Time":  0xbc,
    // "Alice":         0xbd,
    // "Trumpeter":     0xbe,
    // "Neko Shogun":   0xbf,
    // "Hagen":         0xc0,
    // "Jeanne d'Arc":  0xc1,
    // "Yoshitsune":    0xc2,
    // "Guan Yu":       0xc3,
    // "Flaemis":       0xc4,
    // "Aquans":        0xc5,
    // "Aeros":         0xc6,
    // "Erthys":        0xc7,
    // "Ara Mitama":    0xc8,
    // "Nigi Mitama":   0xc9,
    // "Kusi Mitama":   0xca,
    // "Saki Mitama":   0xcb,
    // "Megrez":        0xcf,
    // "Satan":         0xd5,
    // "Beelzebub":     0xd6,
    // "Belial":        0xd7,
    // "Asp":           0xe0,
    // "Apis":          0xe1,
    // "Pabilsag":      0xe2,
    // "Sleipnir":      0xe3,
    // "Xiezhai":       0xe4,
    // "Kangiten":      0xe5,
    // "Baphomet":      0xe6,
    // "Anat":          0xe7,
    // "Pallas Athena": 0xe8,
    // "Mithra":        0xe9,
    // "Osiris":        0xea,
    // "Gucumatz":      0xeb,
    // "Da Peng":       0xec,
    // "Ometeotl":      0xed,
    // "Jarilo":        0xee,
    // "Botis":         0xf0,
    0xf2: "Salaryman",
    0xf9: "Punk",
    0x10c: "Young Man",
    0x114: "Dubhe",
    0x115: "Dubhe",
//     // "Bifrons":       0x116,
//     // "Barbatos":      0x117,
//     // "Dzelarhons":    0x118,
//     // "Kama":          0x119,
//     // "Parvati":       0x11a,
//     // "Ixtab":         0x11b,
//     // "Balor":         0x11c,
//     // "Nergal":        0x11d,
//     // "Inti":          0x11e,
//     // "Alilat":        0x11f,
//     // "Beiji-Weng":    0x120,
//     // "Lord Nan Dou":  0x121,
//     // "Masakado":      0x122,
    0x134: "Tall Woman",  // Makoto in Daichi's Crisis
    0x164: "Vacant Woman" // Fumi in Demon-Hacked
}

function compendium_added() => bit7(0x00284cb3) == 0x01 && byte(0x00284cb3) != 0xff
// the compendium itself is in a static spot in memory
start_of_compendium = 0x00285074
// each entry is 32 bytes long
end_of_compendium = 0x00287054
function demon_registered(monster_name) {
    // there's multiple indicators for a "valid" compendium entry in the game
    // we're just using one of them. the other ones:
    // entry + 0x04 == 0xff
    // entry + 0x05 > 0 (this is what the game actually uses to toggle display of monster in compendium)
    return byte(monster_addr_by_name[monster_name] + 0x04) / 0xff
}

// I have listings of monster IDs/offsets from 0x0e ranging to 0x12b.
// That should add to 285 demons (299 - 14).
// Online lists are saying there's only 222 demons in this version though
function num_registered_compendium() {
    return sum_of(monster_addr_by_name, demon_registered)
}

// There are 4 "Element" demons in the game that cost 1000 macca to fuse
function elements_registered() {
    return demon_registered("Flaemis") + demon_registered("Aquans") + demon_registered("Aeros") + demon_registered("Erthys")
}

// this is inherently flawed, unless you want to use it for a "everyone must live" cheevo
// need a better combat is done indicator.
function player_and_neutral_last_standing(num_starting_teams, neutral_party_id) {
    // Player team indexed from 0
    max_player_id = num_starting_teams - 0x01
    only_friendlies_present = ptr_valid(full_combat_ptr)

    friendlies_ids = [neutral_party_id]

    for i in range(0, num_starting_teams) {
        array_push(friendlies_ids, i)
    }

    // first N slots should be player teams + the neutral party
    for i in range(0, num_starting_teams) {
        only_friendlies_present = only_friendlies_present && (byte(combat_ptr + 0x250 + i) <= max_player_id || (byte(combat_ptr + 0x250 + i) == neutral_party_id))
    }

    // we break the loop here because right after the final friendly group, we should see a 0xff

    // Every slot after must be 0xff
    for i in range(num_starting_teams + 1, 11) {
        only_friendlies_present = only_friendlies_present && (byte(combat_ptr + 0x250 + i)) == 0xff
    }

    return only_friendlies_present
}

// Check if any of the player-controlled teams are alive and only player-controlled teams.
function player_team_last_standing(num_starting_teams) {
    // Player team indexed from 0, so if you run 4 teams your max ID seen should be 0x03
    max_player_id = num_starting_teams - 0x01
    only_friendlies_present = ptr_valid(full_combat_ptr)
    // first N slots should be player teams
    for i in range(0, num_starting_teams) {
        only_friendlies_present = only_friendlies_present && (byte(combat_ptr + 0x250 + i)) <= max_player_id
    }

    // Every slot after must be 0xff
    for i in range(num_starting_teams + 1, 11) {
        only_friendlies_present = only_friendlies_present && (byte(combat_ptr + 0x250 + i)) == 0xff
    }

    return only_friendlies_present
}

// See if any additional teams joined the fight
function adds_spawned(num_starting_teams, threshold) {
    initial_max_team_id = num_starting_teams - 0x01
    threshold_team_id = initial_max_team_id + threshold
    
    teams_present = byte(combat_ptr + 0x250) <= threshold_team_id || byte(combat_ptr + 0x250) == 0xff
    for i in range(0, 11) {
        teams_present = teams_present 
            && ((byte(combat_ptr + 0x250 + i)) <= threshold_team_id || (byte(combat_ptr + 0x250 + i)) == 0xff)
    }
    return teams_present
}

// Total of 67 skills
function num_learned_command_skills() {
    return
        bit2(0x00284a56) + // Agi
        bit3(0x00284a56) + // Agidyne
        bit4(0x00284a56) + // Maragi
        bit5(0x00284a56) + // Maragidyne
        bit6(0x00284a56) + // Bufu
        bit7(0x00284a56) + // Bufudyne
        bit0(0x00284a57) + // Mabufu
        bit1(0x00284a57) + // Mabufudyne
        bit2(0x00284a57) + // Zio
        bit3(0x00284a57) + // Ziodyne
        bit4(0x00284a57) + // Mazio
        bit5(0x00284a57) + // Maziodyne
        bit6(0x00284a57) + // Zan
        bit7(0x00284a57) + // Zandyne
        bit0(0x00284a58) + // Mazan
        bit1(0x00284a58) + // Mazandyne
        bit2(0x00284a58) + // Megido
        bit3(0x00284a58) + // Megidolaon
        bit4(0x00284a58) + // Fire Dance
        bit5(0x00284a58) + // Ice Dance
        bit6(0x00284a58) + // Elec Dance
        bit7(0x00284a58) + // Force Dance
        bit0(0x00284a59) + // Holy Dance
        bit1(0x00284a59) + // Drain
        bit2(0x00284a59) + // Judgement
        bit3(0x00284a59) + // Petra Eyes
        bit5(0x00284a59) + // Paral Eyes
        bit6(0x00284a59) + // Death Call
        bit7(0x00284a59) + // Power Hit
        bit0(0x00284a5a) + // Berserk
        bit1(0x00284a5a) + // Mighty Hit
        bit2(0x00284a5a) + // Anger Hit
        bit3(0x00284a5a) + // Brutal Hit
        bit4(0x00284a5a) + // Hassohappa
        bit5(0x00284a5a) + // Deathbound
        bit6(0x00284a5a) + // Weak Kill
        bit1(0x00284a5b) + // Gigajama
        bit3(0x00284a5b) + // Makarakarn
        bit4(0x00284a5b) + // Tetrakarn
        bit5(0x00284a5b) + // Might Call
        bit6(0x00284a5b) + // Shield Call
        bit7(0x00284a5b) + // Taunt
        bit0(0x00284a5c) + // Dia
        bit1(0x00284a5c) + // Diarahan
        bit2(0x00284a5c) + // Media
        bit3(0x00284a5c) + // Mediarahan
        bit4(0x00284a5c) + // Amrita
        bit5(0x00284a5c) + // Prayer
        bit6(0x00284a5c) + // Recarm
        bit7(0x00284a5c) + // Samarecarm
        bit2(0x00284a5e) + // Piercing Hit 
        bit3(0x00284a5e) + // Multi-Hit
        bit4(0x00284a5e) + // Holy Strike
        bit5(0x00284a5e) + // Power Charge
        bit6(0x00284a5e) + // Sexy Gaze
        bit7(0x00284a5e) + // Marin Karin
        bit0(0x00284a5f) + // Extra Cancel
        bit1(0x00284a5f) + // Assassinate
        bit2(0x00284a5f) + // Fatal Strike
        bit3(0x00284a5f) + // Diarama
        bit4(0x00284a5f) + // Nagayomogi
        bit5(0x00284a5f) + // Recarmloss
        bit6(0x00284a5f) + // Mow Down
        bit7(0x00284a5f) + // Snipe
        bit1(0x00284a60) + // Multi-Strike
        bit2(0x00284a60) + // Inferno
        bit3(0x00284a60) // Life Drain
}

// Total of 76 skills
function num_learned_passive_skills() {
    return 
        bit2(0x00284a64) + // +Poison
        bit3(0x00284a64) + // +Paralyze
        bit4(0x00284a64) + // +Stone
        bit5(0x00284a64) + // Life Bonus
        bit6(0x00284a64) + // Mana Bonus
        bit7(0x00284a64) + // Life Surge
        bit0(0x00284a65) + // Mana Surge
        bit1(0x00284a65) + // Hero Aid
        bit2(0x00284a65) + // Ares Aid
        bit3(0x00284a65) + // Drain Hit
        bit4(0x00284a65) + // Attack All
        bit5(0x00284a65) + // Counter
        bit6(0x00284a65) + // Retaliate
        bit7(0x00284a65) + // Avenge
        bit0(0x00284a66) + // Phys Boost
        bit1(0x00284a66) + // Phys Amp
        bit2(0x00284a66) + // Fire Boost
        bit3(0x00284a66) + // Fire Amp
        bit4(0x00284a66) + // Ice Boost
        bit5(0x00284a66) + // Ice Amp
        bit6(0x00284a66) + // Elec Boost
        bit7(0x00284a66) + // Elec Amp
        bit0(0x00284a67) + // Force Boost
        bit1(0x00284a67) + // Force Amp
        bit2(0x00284a67) + // Anti-Phys
        bit3(0x00284a67) + // Anti-Fire
        bit4(0x00284a67) + // Anti-Ice
        bit5(0x00284a67) + // Anti-Elec
        bit6(0x00284a67) + // Anti-Force
        bit7(0x00284a67) + // Anti-Curse
        bit0(0x00284a68) + // Anti-Most
        bit1(0x00284a68) + // Anti-All
        bit2(0x00284a68) + // Null Phys
        bit3(0x00284a68) + // Null Fire
        bit4(0x00284a68) + // Null Ice
        bit5(0x00284a68) + // Null Elec
        bit6(0x00284a68) + // Null Force
        bit7(0x00284a68) + // Null Curse
        bit0(0x00284a69) + // Phys Drain
        bit1(0x00284a69) + // Fire Drain
        bit2(0x00284a69) + // Ice Drain
        bit3(0x00284a69) + // Elec Drain
        bit4(0x00284a69) + // Force Drain
        bit5(0x00284a69) + // Phys Repel
        bit6(0x00284a69) + // Fire Repel
        bit7(0x00284a69) + // Ice Repel
        bit0(0x00284a6a) + // Elec Repel
        bit1(0x00284a6a) + // Force Repel
        bit2(0x00284a6a) + // Watchful
        bit3(0x00284a6a) + // Endure
        bit4(0x00284a6a) + // Life Aid
        bit5(0x00284a6a) + // Life Lift
        bit6(0x00284a6a) + // Mana Aid
        bit7(0x00284a6a) + // Victory Cry
        bit0(0x00284a6b) + // Pierce
        bit1(0x00284a6b) + // Race-O
        bit2(0x00284a6b) + // Race-D
        bit3(0x00284a6b) + // Dual Shadow
        bit4(0x00284a6b) + // Extra One
        bit3(0x00284a6c) + // Crit Up
        bit4(0x00284a6c) + // Dodge
        bit5(0x00284a6c) + // Moneybags
        bit6(0x00284a6c) + // Quick Move
        bit7(0x00284a6c) + // Vigilant
        bit0(0x00284a6d) + // Grimoire
        bit1(0x00284a6d) + // Double Strike
        bit2(0x00284a6d) + // Preserve Extra
        bit3(0x00284a6d) + // Anti-Ailment
        bit4(0x00284a6d) + // +Forget
        bit5(0x00284a6d) + // Extra Bonus
        bit6(0x00284a6d) + // Swift Step
        bit7(0x00284a6d) + // Life Stream
        bit0(0x00284a6e) + // Mana Stream
        bit1(0x00284a6e) + // Ultimate Hit
        bit2(0x00284a6e) + // Anti-Almighty
        bit3(0x00284a6e) // Phys Up
}

// Total of 32 skills
function num_learned_auto_skills() {
    return
        bit1(0x00284a70) + // Blitzkrieg
        bit2(0x00284a70) + // Hustle
        bit3(0x00284a70) + // Fortify
        bit4(0x00284a70) + // Barrier
        bit5(0x00284a70) + // Wall
        bit6(0x00284a70) + // Full Might
        bit7(0x00284a70) + // Ban Phys
        bit0(0x00284a71) + // Ban Fire
        bit1(0x00284a71) + // Ban Ice
        bit2(0x00284a71) + // Ban Elec
        bit3(0x00284a71) + // Ban Force
        bit4(0x00284a71) + // Ban Curse
        bit5(0x00284a71) + // Rage Soul
        bit6(0x00284a71) + // Grace
        bit7(0x00284a71) + // Marksman
        bit0(0x00284a72) + // Tailwind
        bit1(0x00284a72) + // Magic Yin
        bit2(0x00284a72) + // Battle Aura
        bit3(0x00284a72) + // Revive
        bit4(0x00284a72) + // Magic Yang
        bit5(0x00284a72) + // Healing
        bit6(0x00284a72) + // Alter Pain
        bit7(0x00284a72) + // Weaken
        bit0(0x00284a73) + // Debilitate
        bit1(0x00284a73) + // Health Save
        bit2(0x00284a73) + // Strengthen
        bit3(0x00284a73) + // Grimoire +
        bit4(0x00284a73) + // Desperation
        bit5(0x00284a73) + // Rejuvenate
        bit6(0x00284a73) + // Null Auto
        bit7(0x00284a73) + // Pierce +
        bit0(0x00284a74) // Endure + 
}

// Check the total number of skills learned by the player.
// There is a total of 32 auto + 67 command + 76 passive skills to learn.
function num_learned_skills() => num_learned_auto_skills() + num_learned_command_skills() + num_learned_passive_skills()

chararacter_ids_by_name = {
    "Ronaldo": 0x03,
    "Io": 0x04,
    "Yamato": 0x05,
    "Fumi": 0x06,
    "Daichi": 0x07,
    "Otome": 0x08,
    "Jungo": 0x09,
    "Makoto": 0x0a,
    "Keita": 0x0b,
    "Airi": 0x0c,
    "Joe": 0x0d,
    "Hinako": 0x0e,
    "Anguished One": 0x0f
}

// Characters are stored in an array that is sorted based on who's in party.
// Protag always leads array and is fixed at 0x002844c2.
// Other characters that aren't protag start array at 0x002844e4 and end array at 0x002846b8.
// Fate stage is 0x21 into block.
function char_fate_stage_maxed(char_name) {
    array_positions = [
        0x002844e4,
        0x00284508,
        0x0028452c,
        0x00284550,
        0x00284574,
        0x00284598,
        0x002845bc,
        0x002845e0,
        0x00284604,
        0x00284628,
        0x0028464c,
        0x00284670,
        0x00284694,
        0x002846b8
    ]

    cond = always_false()
    for char_addr in array_positions {
        cond = cond || (word(char_addr) == chararacter_ids_by_name[char_name] 
                && prev(byte(char_addr + 0x21)) == 0x04 
                && byte(char_addr + 0x21) == 0x05)
    }
    return cond
}

location = {
    0x00: "??? 0x00",
    0x01: "??? 0x01",
    0x02: "??? 0x02",
    0x03: "??? 0x03",
    0x04: "Sensouji",
    0x05: "Toyo Anzu",
    0x06: "Sunset Blvd",
    0x07: "??? 0x07",
    0x08: "Fukutoshin Line Platform",
    0x09: "Omotesando",
    0x0a: "Shinbashi Special Platform",
    0x0b: "??? 0x0b",
    0x0c: "Sengakuji",
    0x0d: "Tokyo Tower",
    0x0e: "Shiba Park",
    0x0f: "Shibuya Q-TRONT",
    0x10: "Hanzoumon Line Platform",
    0x11: "Shibuya 901",
    0x12: "Shibuya Station",
    0x13: "??? 0x13",
    0x14: "??? 0x14",
    0x15: "??? 0x15",
    0x16: "Miyashita Park",
    0x17: "Cine City Plaza",
    0x18: "Kannagi-cho",
    0x19: "SL Plaza",
    0x1a: "??? 0x1a",
    0x1b: "Stadium",
    0x1c: "Diet Building",
    0x1d: "Nagata-cho, Tokyo Branch",
    0x1e: "Hibiya Park",
    0x1f: "??? 0x1f",
    0x20: "??? 0x20",
    0x21: "99 Plaza",
    0x22: "??? 0x22",
    0x23: "Tokyo Station, Central Exit",
    0x24: "??? 0x24",
    0x25: "Multipurpose Hall",
    0x26: "??? 0x26",
    0x27: "??? 0x27",
    0x28: "Room ",
    0x29: "??? 0x29",
    0x2a: "??? 0x2a",
    0x2b: "??? 0x2b",
    0x2c: "??? 0x2c",
    0x2d: "??? 0x2d",
    0x2e: "Sankyu Line",
    0x2f: "Bickman",
    0x30: "Sankyu 3rd District",
    0x31: "Shin-Osaka Special Platform",
    0x32: "Triangle Plaza",
    0x33: "the Festgate", // The real name is "Festival Gate" but one of the characters calls it Festgate
    0x34: "??? 0x34",
    0x35: "Shinsekai",
    0x36: "??? 0x36",
    0x37: "Akasaka Mall",
    0x38: "Ebisu Bridge",
    0x39: "OCUT Plaza",
    0x3a: "Ten 7 Mall",
    0x3b: "??? 0x3b",
    0x3c: "??? 0x3c",
    0x3d: "Osaka Castle Park Square",
    0x3e: "??? 0x3e",
    0x3f: "??? 0x3f", 
    0x41: "??? 0x41",
    0x42: "Centering Park",
    0x43: "Gold Clock",
    0x44: "Mei Station, Special Platform",
    0x45: "Parking Garage",
    0x46: "Electric Museum",
    0x47: "Nagoya TV Tower",
    0x48: "Hisaya Odori, Nagoya Branch",
    0x49: "Science Museum",
    0x4a: "Osiris 41",
    0x4b: "Mei Station, Permina",
    0x4c: "Crystal Court",
    0x4d: "Shine Sun Sakae",
    0x4e: "Shabaton",
    0x4f: "Yamada Park",
    0x50: "Fumi's Lab",
    0x51: "Planetarium",
    0x52: "??? 0x52",
    0x53: "Oosu Akamon Crosswalk"
}

// This does not include Free Battle as there are several different Free Battles you can go to
combat_missions_by_name = {
    "Death Clip":       0x0002,
    "Daichi's Crisis":  0x0003,
    "A Man Named Joe":  0x0004,
    "Daichi's Resolve": 0x0005,
    "App Abuser":       0x000b,
    "Osaka Soul":       0x000c,
    "Never Say Die":    0x000d,
    "Demon-Hacked":     0x000e,
}

combat_missions_by_id = {
    0x0002: "Death Clip",
    0x0003: "Daichi's Crisis",
    0x0004: "A Man Named Joe",
    0x0005: "Daichi's Resolve",
    0x0009: "Free Battle",
    0x000a: "Free Battle",
    0x000b: "App Abuser",
    0x000c: "Osaka Soul",
    0x000d: "Never Say Die",
    0x000e: "Demon-Hacked",
    0x0019: "Free Battle"
}

missions = {
    // Exclusively Sunday Missions
    0x3e9: "Death Clip",
    0x3ea: "Shinjuku Crisis",
    0x3eb: "Silent Transit",
    0x3ec: "Refugee Camp",
    0x3ed: "Dubhe",
    0x3ee: "Io Reunion",
    0x3ef: "Unknown Woman",
    0x3f0: "Strange Man",
    0x3f1: "Daichi's Crisis",
    0x3f2: "Tokyo Branch",
    0x3f3: "A Man Named Joe",
    0x3f4: "Daichi's Worth",
    0x3f5: "Bedtime (Day 1)",
    0x403: "SDF Evac",
    0x404: "Retraced Steps",
    // Exclusively Monday
    0x7d1: "Io in Despair",
    0x7d2: "Sleepy Joe",
    0x7d3: "Daichi's Report",
    0x7d4: "App Abuser",
    0x7d5: "Osaka Meeting",
    0x7d6: "Demon Witness",
    0x7d7: "To Osaka",
    0x7d8: "Never Say Die",
    0x7d9: "Rumors",
    0x7da: "Demon-Hacked",
    0x7db: "Immense Damage",
    0x7dc: "Osaka Soul",
    0x7dd: "Too Late",
    0x7df: "Uneasy Daichi",
    0x7e0: "Io's Worry",
    0x7e1: "Joe's Life",
    0x7e2: "Merak Arrives",
    0x7e3: "Enemy Inquiry",
    0x7e4: "Back to Toyko",
    0x7e5: "Bedtime (Day 2)",
    0x7ec: "Daichi's Report",
    // Exclusively Tuesday
    0xbb9: "Fading Wish",
    0xbba: "Pensive Joe",
    0xbbb: "Vs. Q",
    0xbbc: "To Nagoya",
    0xbbd: "Girl in Pursuit",
    0xbbe: "Boy in Combat",
    0xbbf: "Mystery Hacker Revealed",
    0xbc0: "Nicaea Mystery",
    0xbc1: "The Server",
    0xbc2: "Saving Daichi",
    0xbc3: "Goodbye Jungo",
    0xbc4: "Man of Fury",
    0xbc5: "Outlaw",
    0xbc6: "Faint Suspicion",
    0xbc7: "Target: Tower",
    0xbc8: "Back to Tokyo",
    0xbd3: "Memory Search",
    // Wed
    0xfa1: "Bud of Malice",
    0xfa2: "Health Exam",
    0xfa3: "Secret Garden",
    0xfa5: "Anguished One",
    0xfa7: "A Hard Choice",
    0xfa8: "Megrez Meeting",
    0xfa9: "Interrigation",
    0xfaa: "Demon Inquiry",
    0xfab: "The Terminal",
    0xfac: "Demon Origins",
    0xfad: "Nicaea's Master",
    0xfae: "Confrontation",
    0xfaf: "App and Muggers",
    0xfb0: "Power Outage",
    0xfb1: "RIP Joe",
    0xfb2: "A Surprise",
    0xfb3: "Gumshoe Memento",
    0xfb4: "Secret Plan",
    0xfb5: "Delta Battle",
    0xfd7: "Joe Lost",
    // Thurs
    // Fri
    // Sat
    // Misc (side plots to world build or build FATE)
    0x2329: "Tokyo in Ruins",
    0x232a: "An Idle Man",
    0x232b: "Hard Bargain",
    0x232c: "Weary Daichi",
    0x232d: "Job Request",
    0x2333: "Osaka Woman",
    0x233d: "Io and Nicaea",
    0x233e: "Ladies' Man",
    0x233f: "After the News",
    0x2341: "Job Request",
    0x2347: "901 Collapse",
    0x2348: "The Shepherd",
    0x2351: "Joe the Flake",
    0x2352: "The New World",
    0x2353: "Joe's Lady",
    0x2354: "Joe's Gift",
    0x235d: "Hungry Joe",
    0x2366: "Adult Woman",
    0x2367: "Shaken Makoto",
    0x2369: "Makoto's Pride",
    0x2379: "The Public",
    0x237a: "Chief's Chagrin",
    0x2383: "JP's Chief",
    0x2384: "Nagoya Failure",
    0x238f: "Dance Practice",
    0x238d: "Osaka Spirit",
    0x238e: "Osaka Efforts",
    0x2397: "Happy Hinako",
    0x23b5: "In Search Of...", // My notes also suggest this is Twisted Airi. Reconfirm.
    0x23b6: "Airi's Dream",
    0x23b7: "Airi's Thoughts",
    0x23bf: "Sullen Airi",
    0x23c9: "An Odd Duck",
    0x23ca: "Jungo and Cat",
    0x23dd: "Fumi's Research",
    0x23e7: "Fumi's Health",
    0x23f1: "For Justice",
    0x23f2: "Suspected Spy",
    0x23f6: "Priorities",
    0x2405: "JP's Doctor",
    0x2419: "An Awful World",
    0x242d: "Mystery Man",
    0x242e: "The Victim"
}

day_of_week = {
    0x01: "Sunday",
    0x02: "Monday",
    0x03: "Tuesday",
    0x04: "Wednesday",
    0x05: "Thursday",
    0x06: "Friday",
    0x07: "Saturday",
    0x08: "Final Day"
}

// *** Achievements ***

// Progression

achievement(
    title = "False Alarm",
    description = "Avert the crisis shown in your death clip.",
    points = 1,
    trigger =  day == 0x01 && most_recent_mission == 0x3e9 && player_team_last_standing(3),
    type = "progression"
)
achievement(
    title = "She's Sealed Away for a Reason",
    description = "Avert the crisis shown in the second death clip on Sunday.",
    points = 1,
    // Note that Makoto's unit is 0x0b
    // but she actually disappears from the (stagnant) active turn order as the mission resolves
    trigger = on_mission("Daichi's Crisis", 0x3f1) && player_team_last_standing(3),
    type = "progression"
)
// Note to self: This is a lot of setup.
// It requires that Daichi's Poltergeist is kept alive and that Makoto reduces Bai Suzhen's HP to 1 via Fatal Strike
achievement(
    title = "Just Needed Moral Support",
    description = "Have Daichi's team land the killing blow on Bai Suzhen in Daichi's Crisis.",
    points = 5,
    trigger = most_recent_mission == 0x3f1 
        && (
            (attacker_leader_is("Daichi") && defender_leader_is("Bai Suzhen") && defender_leader_defeated()) || 
            (defender_leader_is("Daichi") && attacker_leader_is("Bai Suzhen") && attacker_leader_defeated())
        ),
    type = "missable"
)
achievement(
    title = "[NEEDS_TEST]Taking on Troublesome Contracts",
    description = "Help Joe resolve his outstanding contract.",
    points = 2,
    // need a better "combat is done" indicator
    // next thought: can check how many times a defeated leader is recorded
    trigger = on_mission("A Man Named Joe", 0x3f3) && most_recent_mission == 0x3f3 && current_combat_event == 0x0004 && player_and_neutral_last_standing(3, 0x0b),
    type = "progression"
)
achievement(
    title = "No Demon Left Behind",
    description = "Get all allies to the escape area in Daichi's Worth without Dubhe killing any demons.",
    points = 5,
    trigger = never(most_recent_mission != 0x3f4)
        && ptr_valid(full_team_array_ptr)
        && trigger_when(prev(word(team_array_ptr + (0x27c * 0x04) + 0x0a)) == 0x114 && word(team_array_ptr + (0x27c * 0x04) + 0x0a) == 0x115)
        && never((attacker_leader_is("Dubhe (Whole)") && defender_left_unit_defeated())
        || (attacker_leader_is("Dubhe (Whole)") && defender_right_unit_defeated())
        || (defender_leader_is("Dubhe (Whole)") && attacker_left_unit_defeated())
        || (defender_leader_is("Dubhe (Whole)") && attacker_right_unit_defeated())),
    type = "missable"
)
achievement(
    title = "Dubious Dubhe",
    description = "Defeat Dubhe.",
    points = 5,
    trigger = most_recent_mission == 0x3f4
        && ((attacker_leader_is("Dubhe (Half)") && attacker_leader_defeated()) || defender_leader_is("Dubhe (Half)") && defender_leader_defeated()),
    type = "progression"
)
achievement(
    title = "I Take My Volunteer Work Seriously",
    description = "Defeat all human enemies in App Abuser before any have a chance to escape.",
    points = 3,
    trigger = never(most_recent_mission != 0x7d4)
        && most_recent_mission == 0x7d4
        && on_grid_map()
        && trigger_when(once(defender_leader_is("Punk") && defender_leader_defeated())) 
        && trigger_when(once(defender_leader_is("Salaryman") && defender_leader_defeated()))
        && trigger_when(once(defender_leader_is("Young Man") && defender_leader_defeated()))
        && disable_when(team_moves_to_x(0x04, 0x0e), until=most_recent_mission != 0x7d4)
        && disable_when(team_moves_to_x(0x05, 0x0e), until=most_recent_mission != 0x7d4)
        && disable_when(team_moves_to_x(0x06, 0x0e), until=most_recent_mission != 0x7d4),
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]Busting the 'valgate Party",
    description = "Defeat the Vacant Woman in Demon-Hacked before a second wave of demons joins the fight.",
    points = 5,
    trigger = most_recent_mission == 0x7da
        && defender_leader_is("Vacant Woman") && defender_leader_defeated()
        // this is an odd mission, it leaves some gaps in teams assigned 
        // and kind of forces a set of adds to spawn if you get too close to Fumi
        // the goal here is to prevent any *further* adds after team_id = 0x0a
        // there are some addresses indicated by "Flag Hunt" that seem to flip as an enemy gets spawned in
        // you might be able to use that to determine what's going on here
        && disable_when(adds_spawned(0x0a, 1), until=most_recent_mission != 0x7da),
    type = "missable"
)
// simple achievement here, just recruit hinako
achievement(
    title = "[NEEDS_DEV]Hinako Recruitment",
    description = "Recruit Hinako to JPs.",
    points = 3,
    trigger = day == 0x09,
    type = "progression"

)
achievement(
    title = "[NEEDS_DEV]Miasma Maestro",
    description = "Clear all of the miasma in either of 'Osaka Soul' or 'Too Late' before any additional enemy teams are summoned.",
    points = 5,
    trigger = day == 0x09, // TODO needs battle team information
    type = "missable"
)
// badge should be picture of Waira at top of stairs that kills Keita
achievement(
    title = "[NEEDS_DEV]Savior of the Angry",
    description = "Prevent the death foretold by Monday's death clip.",
    points = 3,
    trigger = most_recent_mission == 0x7dc && character_alive("Keita") && prev(on_grid_map()) && !on_grid_map(),
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]Treading Carefully",
    description = "Defeat Merak without it ever using Circumpolarity.",
    points = 3,
    trigger = day == 0x09,
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]Meticulous Merak",
    description = "Defeat Merak.",
    points = 0,
    trigger = most_recent_mission == 0x7e2 
        && ((attacker_leader_is("Merak") && attacker_leader_defeated()) || defender_leader_is("Merak") && defender_leader_defeated()),
    type = "progression"
)
// This should be "Defeat Ghost Q" because it seems like this is the only instance of Ghost Q actually comin around
// TODO consider level cap after testing
achievement(
    title = "[IN DEV]Vs. Q",
    description = "Defeat Ghost Q.",
    points = 5,
    trigger = day == 0x03 && most_recent_mission == 0xbbb
        && ((defender_leader_is("Ghost Q") && defender_leader_defeated()) || (attacker_leader_is("Ghost Q") && attacker_leader_defeated()))
)

// help airi - progression
// help jungo - progression
// Mystery-Hacking Woman or whatever it's called: just win, the mission is hard enough. but guaranteed cheev
achievement(
    title = "[NEEDS_DEV]Untie Me Already!",
    description = "Escort Daichi to the rescue point in the mission where he gets tied up",
    points = 5,
    trigger = day == 0x09,
    type = "missable"
)
// Badge should be picture of rioters in Planetarium that gang up on Jungo
achievement(
    title = "[NEEDS_DEV]Savior of the Strong",
    description = "Prevent the death foretold by Tuesday's death clip.",
    points = 0,
    // probably needs a bit more in case of game over
    trigger = most_recent_mission == 0xbc2 && character_alive("Jungo") && prev(on_grid_map()) && !on_grid_map(),
    type = "missable"
)
// Man of Fury: Defeat Ronaldo before any supporter has a chance to escape. "Go for the Head"
achievement(
    title = "[NEEDS_DEV]Brutal Efficiency",
    description = "Defeat only Ronaldo in the Man of Fury mission without any allies dying.",
    points = 10,
    // Loose high level idea here:
    // you detect when Ronaldo's HP hits 0, this is the trigger
    // you verify that the first N slots in the turn order are != 0xff. that's it
    trigger = day == 0x09,
    type = "missable"
)
// Phecda Challenge: Defeat Phecda in under ? player turns
achievement(
    title = "[NEEDS_DEV]Partitioned Phecda",
    description = "Defeat Phecda.",
    points = 5,
    trigger = most_recent_mission == 0xbc4 
    // This will actually need a pair of clauses
    // There's multiple Phecda forms and you can defeat one or the other
    // Phecda (Whole)
    // Phecda (Phys Immune)
    // Phecda (Magic Immune)
        && ((attacker_leader_is("Phecda") && attacker_leader_defeated()) || defender_leader_is("Phecda") && defender_leader_defeated()),
    type = "progression"
)
achievement(
    title = "[NEEDS_DEV]Having Wings Seems Pretty Cool",
    description = "On any team, have only the team leader get hit by Diastrophism.",
    points = 5,
    trigger = day == 0x09,
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]Y'all Gotta Cool It",
    description = "Fight both the civilians and JP members in Confrontation and win.",
    points = 3,
    trigger = day == 0x09,
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]Truly a Hard Choice",
    description = "Defeat Neko Shogun in A Hard Choice",
    points = 5,
    trigger = day == 0x09
    // unsure if progression or missable, needs more testing
)
achievement(
    title = "[NEEDS_DEV]Don't Work Him Too Hard",
    description = "Ensure Ronaldo lives through the Power Outage mission.",
    points = 0,
    trigger = day == 0x09
)
// Badge should be picture of Pyro Jack
achievement(
    title = "[NEEDS_DEV]Savior of the Aloof",
    description = "Prevent the death foretold by Wednesday's death clip.",
    points = 0,
    trigger = most_recent_mission == 0xfb0 && character_alive("Joe") && prev(on_grid_map()) && !on_grid_map(),
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]No Time To Mess Around On My Phone",
    description = "Win the Delta Battle mission without clearing any of the miasma.",
    points = 5,
    trigger = day == 0x09,
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]Marooned Megrez",
    description = "Defeat Megrez.",
    points = 5,
    trigger = day == 0x09,
    type = "progression"
)

// *** Avoidable Deaths ***
// Otome
// Makoto

// Never Say Die: probably just a "meet Hinako" OR Complete "Never Say Die" with Hinako's team getting 0 team kills.
// Girl in Pursuit: Prevent any rioters from escaping and win.
// Boy in Combat: Nothing notable in mission probably just a "meet Jungo"
// Saving Daichi OR Goodbye Jungo: Actually save Daichi by bringing him to a rescue point. Do what the mission says!!!
// Man of Fury pt. 2: Defeat Phecda
// Megrez missions: Have only the team leader on any team get hit when Megrez's Bud uses its Diastrophism skill.
// ^ above can be either Megrez bud or refight
// Confrontation: Fight both the JP members and civilians and clear everyone out.
// App and Muggers:
// A Hard Choice: Defeat all the demons / Neko Shogun
// Power Outage: Ronaldo survives fight as well
// Mystery Man
// Delta Battle: Win the fight without clearing any Miasma.

// no Free Battle progression

// day 1
achievement(
    title = "[IN DEV]Uncool to Grind in Tokyo",
    description = "Complete Day 1 without ever entering any Free Battle on a New Game file.",
    points = 5,
    trigger = !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x01) && day == 0x02,
    type = "missable"
)
// day 2
achievement(
    title = "[IN DEV]Uncool to Grind in Osaka",
    description = "Complete Day 2 without ever entering any Free Battle on a New Game file.",
    points = 5,
    trigger = !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x02) && day == 0x03,
    type = "missable"
)
// day 3
achievement(
    title = "[IN DEV]Uncool to Grind in Nagoya",
    description = "Complete Day 3 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x03) && day == 0x04,
    type = "missable"
)
// day 4
achievement(
    title = "[IN DEV] Survived Day 4",
    description = "Complete Day 4 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x04) && day == 0x05,
    type = "missable"
)
// day 5
achievement(
    title = "[IN DEV] Survived Day 5",
    description = "Complete Day 5 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x05) && day == 0x06,
    type = "missable"
)
// day 6
achievement(
    title = "[IN DEV] Survived Day 6",
    description = "Complete Day 6 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x06) && day == 0x07,
    type = "missable"
)
// day 7
achievement(
    title = "[IN DEV]Wait, You Can Just... Grind?",
    description = "Complete any ending without ever entering any Free Battle on a New Game file.",
    points = 25,
    trigger = !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x07) && day == 0x08,
    type = "missable"
)

// FATE stages

achievement(
    title = "[IN DEV]Ronaldo's Best Friend",
    description = "Reach FATE stage 5 with Ronaldo.",
    points = 10,
    trigger = char_fate_stage_maxed("Ronaldo")
)
achievement(
    title = "[IN DEV]IO's Best Friend",
    description = "Reach FATE stage 5 with Io.",
    points = 10,
    trigger = char_fate_stage_maxed("Io")
)
achievement(
    title = "[IN DEV]Yamato's Best Friend",
    description = "Reach FATE stage 5 with Yamato.",
    points = 10,
    trigger = char_fate_stage_maxed("Yamato")
)
achievement(
    title = "[IN DEV]Fumi's Best Friend",
    description = "Reach FATE stage 5 with Fumi.",
    points = 10,
    trigger = char_fate_stage_maxed("Fumi")
)
achievement(
    title = "[IN DEV]Daichi's Best Friend",
    description = "Reach FATE stage 5 with Daichi.",
    points = 10,
    trigger = char_fate_stage_maxed("Daichi") 
)
achievement(
    title = "[IN DEV]Otome's Best Friend",
    description = "Reach FATE stage 5 with Otome.",
    points = 10,
    trigger = char_fate_stage_maxed("Otome") 
)
achievement(
    title = "[IN DEV]Jungo's Best Friend",
    description = "Reach FATE stage 5 with Jungo.",
    points = 10,
    trigger = char_fate_stage_maxed("Jungo") 
)
achievement(
    title = "[IN DEV]Makoto's Best Friend",
    description = "Reach FATE stage 5 with Makoto.",
    points = 10,
    trigger = char_fate_stage_maxed("Makoto") 
)
achievement(
    title = "[IN DEV]Keita's Best Friend",
    description = "Reach FATE stage 5 with Keita.",
    points = 10,
    trigger = char_fate_stage_maxed("Keita") 
)
achievement(
    title = "[IN DEV]Airi's Best Friend",
    description = "Reach FATE stage 5 with Airi.",
    points = 10,
    trigger = character_alive("Airi") && char_fate_stage_maxed("Airi") 
)
achievement(
    title = "[IN DEV]Joe's Best Friend",
    description = "Reach FATE stage 5 with Joe.",
    points = 10,
    trigger = char_fate_stage_maxed("Joe") 
)
achievement(
    title = "[IN DEV]Hinako's Best Friend",
    description = "Reach FATE stage 5 with Hinako.",
    points = 10,
    trigger = char_fate_stage_maxed("Hinako") 
)
achievement(
    title = "[IN DEV]Anguished One's Best Friend",
    description = "Reach FATE stage 5 with the Anguished One.",
    points = 10,
    trigger = char_fate_stage_maxed("Anguished One") 
)
// *** Auctions ***
// Upgrade to Gold Rank
achievement(
    "Blind Bidder",
    description = "In an auction with 3 other bidders, place a successful bid and pay for the demon before seeing any of the reactions from other bidders.",
    points = 2,
    trigger = ptr_valid(full_auction_ptr) 
        && (ptr_valid(dword(auction_ptr + 0x168)) && byte(auction_ptr + 0x185) == 0xff)
        && (ptr_valid(dword(auction_ptr + 0x188)) && byte(auction_ptr + 0x1a5) == 0xff)
        && (ptr_valid(dword(auction_ptr + 0x1a8)) && byte(auction_ptr + 0x1c5) == 0xff)
        && byte(auction_ptr) == 0x1c
        && prev(macca) > macca
)
achievement(
    title = "Math Is Not its Strong Suit",
    description = "Have a demon give you back more Macca than the Extra it demanded.",
    points = 2,
    trigger = ptr_valid(full_auction_ptr)
        && macca < prev(macca)
        && byte(auction_ptr) == 0x1c
        && byte(auction_ptr + 0x214) == 0x01
        && (dword(auction_ptr + 0x1cc) + dword(auction_ptr + 0x1e4) + macca) > prev(macca)
)
achievement(
    title = "Clearance Sale",
    description = "Win 3 bids during a Special Auction.",
    points = 3,
    trigger = never(!ptr_valid(full_auction_ptr))
        && never(byte(auction_ptr) == 0x0c)
        && repeated(3, (prev(byte(auction_ptr)) == 0x12 || prev(byte(auction_ptr)) == 0x14) && byte(auction_ptr) == 0x17)
)
achievement(
    title="All That Glitters Is Macca, Actually",
    description = "Unlock the Gold tier of demon auctions.",
    points = 5,
    trigger = bit5(auction_unlock_eligibility) == 0x01
        && ptr_valid(full_auction_ptr)
        && prev(bit2(auctions_unlocked) == 0x00) 
        && bit2(auctions_unlocked) == 0x01
)
achievement(
    title = "The Holy Grail of Demon Auctions",
    description = "Unlock the Platinum tier of demon auctions.",
    points = 5,
    trigger = ptr_valid(full_auction_ptr)
        && prev(bit3(auctions_unlocked) == 0x00) 
        && bit3(auctions_unlocked) == 0x01
)
achievement(
    title = "Embracing the Occult",
    description = "Unlock the Occult tier of demon auctions.",
    points = 5,
    trigger = ptr_valid(full_auction_ptr)
        && prev(bit4(auctions_unlocked) == 0x00) 
        && bit4(auctions_unlocked) == 0x01
)

// Compendium and Demon Recruitment
// *** Unique Teams and Fusion Things ***
// Daichi with two Bai Suzhens
// Fumi with Botis and ?
// Sleipnir and Odin
// Fuse any Element monster
// get any advanced race skill

achievement(
    title = "[IN DEV]25% Compendium",
    description = "Complete 25% of the Demon compendium.",
    points = 5,
    trigger = prev(num_registered_compendium() == 0x37) && measured(num_registered_compendium() == 0x38, when=always_true(), format="raw")
)

achievement(
    title = "[IN DEV]50% Compendium",
    description = "Complete 50% of the Demon compendium.",
    points = 10,
    trigger = prev(num_registered_compendium() == 0x6e) && measured(num_registered_compendium() == 0x6f, when=always_true(), format="raw")
)

achievement(
    title = "[IN DEV]75% Compendium",
    description = "Complete 75% of the Demon compendium.",
    points = 25,
    trigger = prev(num_registered_compendium() == 0xa6) && measured(num_registered_compendium() == 0xa7, when=always_true(), format="raw")
)

achievement(
    title = "[IN DEV]100% Compendium",
    description = "Complete 100% of the Demon compendium.",
    points = 50,
    trigger = prev(num_registered_compendium() == 0xdc) && measured(num_registered_compendium() == 0xdd, when=always_true(), format="raw")
)
achievement(
    title = "[IN DEV]The Purest of Form",
    description = "Register all four element demons in your compendium.",
    points = 5,
    trigger = prev(elements_registered() == 0x03) && measured(elements_registered() == 0x04, when=always_true(), format="raw") 
)

// Skill-Adjacent Achievements
achievement(
    title = "Fast-tracked Learning",
    description = "Learn 4 different skills in a single combat.",
    points = 5,
    trigger = repeated(4, (num_learned_skills() - prev(num_learned_skills()) == 0x01 && never(!on_grid_map())))
)

achievement(
    title = "The Power to Do Anything",
    description = "Learn all Command skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_command_skills()) == 0x42 && measured(num_learned_command_skills() == 0x43, when=always_true(), format="raw")
)

achievement(
    title = "Sedentary Strength",
    description = "Learn all Passive Skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_passive_skills()) == 0x4b && measured(num_learned_passive_skills() == 0x4c, when=always_true(), format="raw")
)

achievement(
    title = "Automating the Helpful Things",
    description = "Learn all Auto Skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_auto_skills()) == 0x1f && measured(num_learned_auto_skills() == 0x20, when=always_true(), format="raw")
)

// New Game + Stuff
achievement(
    title = "[NEEDS_TEST]Super Fast Dubhe",
    description = "Defeat Dubhe before it enters its second phase.",
    points = 0,
    trigger = most_recent_mission == 0x3f4
        && ((attacker_leader_is("Dubhe (Whole)") && attacker_leader_defeated()) || defender_leader_is("Dubhe (Whole)") && defender_leader_defeated()) 
)

// *** Leaderboards ***
leaderboard(
    title = "Biggest Chump", // please don't actually call it this.
    description = "Highest Extra you've ever agreed to pay during a Demon auction.",
    start = ptr_valid(full_auction_ptr) 
        && byte(auction_ptr) == 0x1c 
        && prev(byte(auction_ptr + 0x214)) == 0x00 && byte(auction_ptr + 0x214) == 0x01,
    cancel = byte(auction_ptr) == 0x04 && prev(macca) == macca,
    submit = prev(dword(auction_ptr + 0x1ec) == 0x00) && dword(auction_ptr + 0x1ec) > dword(auction_ptr + 0x1cc),
    value = dword(auction_ptr + 0x1e4),
    format="VALUE",
    lower_is_better=false
)

// *** Rich Presence ***

rich_presence_conditional_display(day == 0x01 && in_game_clock == 0x00 && macca == 0x00, "On the title screen")
rich_presence_conditional_display(ptr_valid(full_auction_ptr), "{0} {1} | Getting more Demons from the Auction",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS")
)

rich_presence_conditional_display(in_combat() && active_unit_in_combat(), "{0} {1} | At {2} | {3} ⚔️ {4} | Time on Mission={5}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_lookup("Unit", word(attacker_team_ptr + 0x0a), enemy_name_by_id),
    rich_presence_lookup("Unit", word(defender_ptr + 0x0a), enemy_name_by_id),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

// TODO redo the below format

rich_presence_conditional_display(on_grid_map() && friendly_unit_moving(), "{0} {1} | In Combat at {2} | Time on Turn={3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Time on Turn", current_time_in_mission / 30, "SECS"),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)


rich_presence_display("{0} {1} 💰 {2} | At {3} | IGT={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_value("Macca", macca),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("In-Game Time", in_game_time / 60, "SECS")
)
