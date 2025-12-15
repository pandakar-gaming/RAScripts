// Devil Survivor 2
// #ID=9483
// md5: 4b1ee25404620aed63ee09f24a9a6db5
// #MinimumVersion=1.3.1

// General note for myself: DS pointers usually take the form of 0x02xxxxxx
// However, the DS only has 4MB of RAM so with RA addressing you can just take the 24 bytes denoted by xxxxxx and deref that
// Because of that, this script has two named variables per ptr until I figure out a more elegant way to reference this

IN_GAME_CLOCK = word(0x00284ab4)
DAY = byte(0x00284aba)
MACCA = dword(0x00284a98)
CURRENT_LOCATION = byte(0x00284da9)
// Game stores most recent 12 missions and their IDs in an array, this is the last value in the array
MOST_RECENT_MISSION = word(0x00284fae)
FULL_COMBAT_PTR = dword(0x001be0ac)
COMBAT_PTR = tbyte(0x001be0ac)
FULL_TEAM_ARRAY_PTR = dword(0x001be040)
TEAM_ARRAY_PTR = tbyte(0x001be040)
// both of these are counted in frames, game runs @ 30fps
current_time_in_mission = dword(COMBAT_PTR + 0x10)
TOTAL_TIME_IN_MISSION = dword(COMBAT_PTR + 0x28)
// yet for whatever reason this is counted at 60 fps?
IN_GAME_TIME = tbyte(0x00284480)
// for now splitting into two named addresses
// maybe later we optimize but I like having both on hand
FULL_AUCTION_PTR = dword(0x001be73c)
AUCTION_PTR = tbyte(0x001be73c)
AUCTION_UNLOCK_ELIGIBILITY = 0x00284ad0
AUCTIONS_UNLOCKED = 0x00284acb
FULL_ATTACKER_TEAM_PTR = dword(0x001c9fd0)
ATTACKER_TEAM_PTR = tbyte(0x001c9fd0)
FULL_DEFENDER_TEAM_PTR = dword(0x001c9fd4)
DEFENDER_PTR = tbyte(0x001c9fd4)

// Structure I haven't figured out that I want to keep a note for:
// [32-bit Pointer] Pointer to overworld event select
// +0x53 City select [8-bit]
// 0x00 = All
// 0x01 = Tokyo
// 0x02 = Osaka
// 0x03 = Nagoya
// +0x54 y-index of event being hovered [8-bit]
// +0x60 Area ID being hovered [8-bit]
// Above is in a linked list and it'd be only useful for RP

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

function in_combat_mission(mission_name) => word(0x00284abe) == combat_mission_by_name[mission_name]

// Whenever you're in an event (combat or otherwise) the 8-bit value at 0x00284ab8 is set to 0x1e. 
// I'm not sure why that is significant, however it is a helpful fingerprint to know if the player is doing something.
function actively_in_event() => byte(0x00284ab8) == 0x1e

// This does not confirm what combat mission you're on, just that you're in one.
// @param mission_name the String name of the mission that the player would see.
function on_mission(mission_name) => actively_in_event() && MOST_RECENT_MISSION == event_id_by_name[mission_name]

// Check if the team taking their turn is engaged in combat.
function active_unit_in_combat() => bit0(COMBAT_PTR + 0x1c) == 0

// Check what team is actively moving and whether it's a friendly unit.
function expected_team_moving(expected_team_lead_index) {
    return ptr_valid(FULL_COMBAT_PTR) && byte(COMBAT_PTR + 0x250) == expected_team_lead_index && unit_moving()
}

// See if the current unit is moving around while in combat.
function unit_moving() => ptr_valid(FULL_COMBAT_PTR) && bit0(COMBAT_PTR + 0x1c) == 1

// This is checking if the player *ever* entered a free battle, not if they're currently in one.
// This is done by seeing if the player ever saw the tutorials for how Free Combat works.
// TODO match how the game checks it, I tried unflagging these before beating Polaris and it didn't take
function entered_free_battle() => bit0(0x00284ad7) == 0x01 || bit1(0x00284ad7) == 0x01

// Check if the enemy we're looking for is the defending team in this active combat.
// We only care about the enemy leader for the most part; side enemies are hopefully not notable enough for most achievements.
function defender_leader_is(enemy_name) => ptr_valid(FULL_DEFENDER_TEAM_PTR) && word(DEFENDER_PTR + 0x0a) == enemy_id_by_name[enemy_name]

// Check if the enemy we're looking for is the attacking team in this active combat.
// We only care about the enemy leader for the most part; side enemies are hopefully not notable enough for most achievements.
function attacker_leader_is(enemy_name) => ptr_valid(FULL_ATTACKER_TEAM_PTR) && word(ATTACKER_TEAM_PTR + 0x0a) == enemy_id_by_name[enemy_name]

// See if the attacking leader was defeated in this particular combat.
function attacker_leader_defeated() => ptr_valid(FULL_ATTACKER_TEAM_PTR)  && unit_defeated(ATTACKER_TEAM_PTR + 0x18)

function attacker_leader_reduced_to_1hp() => ptr_valid(FULL_ATTACKER_TEAM_PTR)  && unit_soft_defeated(ATTACKER_TEAM_PTR + 0x18)

// See if the unit on the left side of the attacker's team was defeated in this particular combat.
function attacker_left_unit_defeated() => ptr_valid(FULL_ATTACKER_TEAM_PTR) && unit_defeated(ATTACKER_TEAM_PTR + 0xbc)

// See if the unit on the right side of the attacker's team was defeated in this particular combat.
function attacker_right_unit_defeated() => ptr_valid(FULL_ATTACKER_TEAM_PTR) && unit_defeated(ATTACKER_TEAM_PTR + 0x160)

// See if the defending leader was defeated in this particular combat.
function defender_leader_defeated() => ptr_valid(FULL_DEFENDER_TEAM_PTR) && unit_defeated(DEFENDER_PTR + 0x18)

function defender_leader_reduced_to_1hp() => ptr_valid(FULL_DEFENDER_TEAM_PTR) && unit_soft_defeated(DEFENDER_PTR + 0x18)

// See if the unit on the left side of the defender's team was defeated in this combat.
function defender_left_unit_defeated() => ptr_valid(FULL_DEFENDER_TEAM_PTR) && unit_defeated(DEFENDER_PTR + 0xbc)

// See if the unit on the right side of the defender's team was defeated in combat.
function defender_right_unit_defeated() => ptr_valid(FULL_DEFENDER_TEAM_PTR) && unit_defeated(DEFENDER_PTR + 0x160)

// Should be valid when the count of 0xff in the turn order array goes down by one.
function unit_respawns() {
    cond = ptr_valid(FULL_COMBAT_PTR)

    running_total = prev((byte(COMBAT_PTR + 0x250))) / 0xff
    for i in range(1, 11) {
        running_total = running_total + (prev((byte(COMBAT_PTR + 0x250 + i))) / 0xff)
    }

    for i in range(0, 11) {
        running_total = running_total - (byte(COMBAT_PTR + 0x250 + i) / 0xff)
    }

    return cond && running_total == 0x01
}

// Check whether there are only allied teams standing in combat.
// This specifically checks if all expected deployed allies are alive.
function all_allied_teams_last_standing(num_starting_teams) {
    // Player team indexed from 0 and game reserves first 4 indexes for player teams
    // enemy ids have to start at 0x04 as a result
    max_player_id = 0x03
    // At least one player-controllable character should be alive
    only_friendlies_present = ptr_valid(FULL_COMBAT_PTR)
    
    // From the end of the team order array to where friendly teams could begin, we should see 0xff
    for i in range(num_starting_teams + 1, 11) {
        only_friendlies_present = only_friendlies_present && (byte(COMBAT_PTR + 0x250 + i)) == 0xff
    }

    for i in range(0, num_starting_teams - 1) {
        only_friendlies_present = only_friendlies_present && (byte(COMBAT_PTR + 0x250 + i)) <= max_player_id
    }


    // finally, check that the slot past the last alive friendly team just died
    only_friendlies_present = only_friendlies_present && (
        prev((byte(COMBAT_PTR + 0x250 + num_starting_teams))) > max_player_id &&
        byte(COMBAT_PTR + 0x250 + num_starting_teams) == 0xff
    )

    return only_friendlies_present
}

// Haven't really found a good indicator otherwise for game overs, except for this pointer popping up
// So if you're in combat and this is valid, player goofed
function game_over() => ptr_valid(dword(0x001beac8))

// Determine if the specific unit was just defeated.
// A "unit" is either a team leader or a demon. 
// Input: address of unit's current health. It is expected that the max health is directly 0x02 after and is the same size. 
// Note: this looks specifically for the enemy's HP hitting 0. Some do not on defeat.
// See: Man of Fury, Ronaldo for a specific example of this
function unit_defeated(addr_unit_current_health) {
    return prev(word(addr_unit_current_health)) <= word(addr_unit_current_health + 0x02) && word(addr_unit_current_health) == 0x00
}

function unit_soft_defeated(addr_unit_current_health) {
    return prev(word(addr_unit_current_health)) <= word(addr_unit_current_health + 0x02) && word(addr_unit_current_health) == 0x01
}
// Check if a character is still alive according to plot flags.
// Some characters can permanently die if you meet (or fail to meet) certain conditions.
function character_alive(char_name) {
    // for whatever reason no characters exist from 0x00 -> 0x02
    char_index = chararacter_ids_by_name[char_name] - 0x03

    return bit1(0x00284dc2 + (0x10 * char_index)) == 0
}

function character_recruited(char_name) {
    // for whatever reason no characters exist from 0x00 -> 0x02
    char_index = chararacter_ids_by_name[char_name] - 0x03
    return prev(bit2(0x00284dc2 + (0x10 * char_index))) == 0x01 && bit2(0x00284dc2 + (0x10 * char_index)) == 0x00
}

// Check if the given team moved to the given tile on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param x the expected x-coordinate
// @param y the expected y-coordinate
function team_moves_to_coord(team_offset, x, y) {
    cond = ptr_valid(FULL_COMBAT_PTR)
    cond = cond && team_moves_to_x(team_offset, x)
    cond = cond && team_moves_to_y(team_offset, y)
    return cond
}

// Check if the given team moved to the given row on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param x the expected x-coordinate
function team_moves_to_x(team_offset, x) {
    cond = ptr_valid(FULL_TEAM_ARRAY_PTR)
    cond = cond && prev(byte(TEAM_ARRAY_PTR + (0x27c * team_offset) + 0x1f2)) != x && byte(TEAM_ARRAY_PTR + (0x27c * team_offset) + 0x1f2) == x
    return cond
}

// Check if the given team moved to the given column on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param y the expected y-coordinate
function team_moves_to_y(team_offset, y) {
    cond = ptr_valid(FULL_TEAM_ARRAY_PTR)
    cond = cond && prev(byte(TEAM_ARRAY_PTR + (0x27c * team_offset) + 0x1f3)) != y && byte(TEAM_ARRAY_PTR + (0x27c * team_offset) + 0x1f3) == y
    return cond
}

// Given the index of a team, ensure that the leader's HP is full.
function team_leader_hp_full(team_offset) {
    return ptr_valid(FULL_TEAM_ARRAY_PTR) && word(TEAM_ARRAY_PTR + (0x27c * team_offset) + 0x18) == word(TEAM_ARRAY_PTR + (0x27c * team_offset) + 0x1a)
}

// Given the team's offset, determine if they're still on the map.
// This is done by checking the turn order array for combat and whether the offset is still available in the active turn order.
function team_leader_on_map(team_offset) {
    cond = ptr_valid(FULL_COMBAT_PTR)

    return cond && any_of(range(COMBAT_PTR + 0x250, COMBAT_PTR + 0x25c), i => byte(i) == team_offset)
}

// See how many teams are still active on the current combat map.
function num_teams_on_map(num_teams) {
    cond = ptr_valid(FULL_COMBAT_PTR)

    for i in range(0, num_teams - 1) {
        cond = cond && byte(COMBAT_PTR + 0x250 + i) != 0xff
    }

    for i in range(num_teams, 0x0b) {
        cond = cond && byte(COMBAT_PTR + 0x250 + i) == 0xff
    }

    return cond
}

// Check if the given team is deployed in the current combat.
// This specifically looks to see if the team leader is paired with a specific demon.
function pairing_present(team_leader_name, demon_name) {
    // Protagonist is special as they're always the first deployed team
    if (team_leader_name == "Hero") {
        return (left_demon(0x00) == enemy_id_by_name[demon_name] || right_demon(0x00) == enemy_id_by_name[demon_name])
    } else {
        return (
            (team_leader(0x01) == enemy_id_by_name[team_leader_name] && (left_demon(0x01) == enemy_id_by_name[demon_name] || right_demon(0x01) == enemy_id_by_name[demon_name])) ||
            (team_leader(0x02) == enemy_id_by_name[team_leader_name] && (left_demon(0x02) == enemy_id_by_name[demon_name] || right_demon(0x02) == enemy_id_by_name[demon_name])) ||
            (team_leader(0x03) == enemy_id_by_name[team_leader_name] && (left_demon(0x03) == enemy_id_by_name[demon_name] || right_demon(0x03) == enemy_id_by_name[demon_name]))
        )
    }
}

// Get the ID of the leader of the given combat team.
function team_leader(team_offset) {
    return word(COMBAT_PTR + 0x26c + 0x0a + (team_offset * 0x27c))
}

// Get the ID of the demon deployed on the left-hand side of the input team.
function left_demon(team_offset) {
    return word(COMBAT_PTR + 0x26c + 0xae + (team_offset * 0x27c))
}

// Get the ID of the demon deployed on the right-hand side of the input team.
function right_demon(team_offset) {
    return word(COMBAT_PTR + 0x26c + 0x152 + (team_offset * 0x27c))
}

// Calculates offered Macca + Extra that the demon demands
function true_auction_cost() => dword(FULL_AUCTION_PTR + 0x1cc) + dword(FULL_AUCTION_PTR + 0x1e4)

// Stub for now until I have logic for this.
function is_new_game_plus() => always_false()

// Confirm we're on the ending path we intend to be on.
// @param one of ["Anguished One", "Daichi (Real)", "Daichi", "Ronaldo", "Yamato"]
function ending_selected(ending) {
    if (ending == "Anguished One") {
        return bit4(0x00284b10) == 0x01
    } else if (ending == "Yamato") {
        return bit2(0x00284b10) == 0x01
    }
}

// The game offers a Suspend feature. This is very similar to using a Save State.
// This doesn't work for some of the achievements being coded, so we get to detect if someone actually hopped on a mission
// using the menu or if they're loading from suspend.
// DO NOT USE THIS FOR PROGRESSION. ONLY CHALLENGES.
function loaded_from_suspend() => FULL_TEAM_ARRAY_PTR > 0x02ffffff || FULL_TEAM_ARRAY_PTR < 0x02000000

// Checks if the turn that's being started is an allied unit's turn.
function allied_turn_starts() {
    cond = ptr_valid(FULL_COMBAT_PTR)

    return cond && byte(COMBAT_PTR + 0x250) <= 0x03 
        && prev(byte(COMBAT_PTR + 0x24)) == 0x00 && byte(COMBAT_PTR + 0x24) == 0x02 
}

// I would do by id/offset BUT THEY PUT GAPS IN BETWEEN SOME.
// They also intermingle demons you can get and demons/enemies you can't get in the Compendium
// in the compendium list itself, because internally it's probably all just entities of the same size anyway
// Instead, what I'll be doing is: 
// - for every demon that the handy Gamefaqs guides have listed as possible, note on RA
// - each one of those will be re-referenced here using the start of their block
// - for achievements, helper functions to check by name
// - which will then reference this map and apply same "did it get checked off" logic
monster_addr_by_name = {
    "Tonatiuh":       0x00285074,
    "Chernobog":      0x00285094,
    "Wu Kong":        0x002850b4,
    "Susano-o":       0x002850d4,
    "Kartikeya":      0x002850f4,
    "Shiva":          0x00285114,
    "Hathor":         0x00285134,
    "Sarasvati":      0x00285154,
    "Kikuri-Hime":    0x00285174,
    "Brigid":         0x00285194,
    "Scathach":       0x002851b4,
    "Laksmi":         0x002851d4,
    "Norn":           0x002851f4,
    "Isis":           0x00285214,
    "Amaterasu":      0x00285234,
    "Mahakala":       0x00285254,
    "Thor":           0x00285274,
    "Arahabaki":      0x00285294,
    "Odin":           0x002852b4,
    "Yama":           0x002852d4,
    "Lugh":           0x002852f4,
    "Baal":           0x00285314,
    "Asura":          0x00285334,
    "Orcus":          0x00285354,
    "Pazuzu":         0x00285374,
    "Abaddon":        0x00285394,
    "Tao Tie":        0x002853b4,
    "Arioch":         0x002853d4,
    "Tezcatlipoca":   0x002853f4,
    "Nyarlathotep":   0x00285414,
    "Makara":         0x00285434,
    "Nozuchi":        0x00285454,
    "Pendragon":      0x00285474,
    "Gui Xian":       0x00285494,
    "Quetzalcoatl":   0x002854b4,
    "Seiryuu":        0x002854d4,
    "Orochi":         0x002854f4,
    "Ananta":         0x00285514,
    "Hoyau Kamui":    0x00285534,
    "Toubyou":        0x00285554,
    "Bai Suzhen":     0x00285574,
    "Basilisk":       0x00285594,
    "Ym":             0x002855b4,
    "Python":         0x002855d4,
    "Culebre":        0x002855f4,
    "Vritra":         0x00285614,
    "Vasuki":         0x00285634,
    "Angel":          0x00285674,
    "Power":          0x00285694,
    "Lailah":         0x002856b4,
    "Aniel":          0x002856d4, 
    "Kazfiel":        0x002856f4,
    "Remiel":         0x00285714,
    "Metatron":       0x00285734,
    "Itsumade":       0x00285754,
    "Moh Shuvuu":     0x00285774,
    "Hamsa":          0x00285794,
    "Suparna":        0x002857b4,
    "Vidofnir":       0x002857d4,
    "Badb Catha":     0x002857f4,
    "Anzu":           0x00285814,
    "Feng Huang":     0x00285834,
    "Garuda":         0x00285854,
    "Gagyson":        0x00285874,
    "Abraxas":        0x00285894,
    "Flauros":        0x002858b4,
    "Nisroc":         0x002858d4,
    "Orobas":         0x002858f4,
    "Decarabia":      0x00285914,
    "Nebiros":        0x00285934,
    "Agares":         0x00285954,
    "Murmur":         0x00285974,
    "Heqet":          0x00285994,
    "Kamapua'a":      0x002859b4,
    "Shiisaa":        0x002859d4,
    "Bai Ze":         0x002859f4,
    "Baihu":          0x00285a14,
    "Airavata":       0x00285a34,
    "Ukano Mitama":   0x00285a54,
    "Barong":         0x00285a74,
    "Anubis":         0x00285a94,
    "Kabuso":         0x00285ab4,
    "Hairy Jack":     0x00285ad4,
    "Nekomata":       0x00285af4,
    "Cait Sith":      0x00285b14,
    "Nue":            0x00285b34,
    "Orthrus":        0x00285b54,
    "Myrmecolion":    0x00285b74,
    "Cerberus":       0x00285b94,
    "Fenrir":         0x00285bb4,
    "Hare of Inaba":  0x00285bd4,
    "Waira":          0x00285bf4,
    "Garm":           0x00285c14,
    "Afanc":          0x00285c34,
    "Mothman":        0x00285c54,
    "Taown":          0x00285c74,
    "Behemoth":       0x00285c94,
    "Ammut":          0x00285cb4,
    "Tam Lin":        0x00285cd4,
    "Jambavan":       0x00285cf4,
    "Tlaloc":         0x00285d14,
    "Ictinike":       0x00285d34,
    "Hanuman":        0x00285d54,
    "Cu Chulainn":    0x00285d74,
    "Kresnik":        0x00285d94,
    "Ganesha":        0x00285db4,
    "Heimdall":       0x00285dd4,
    "Pixie":          0x00285df4,
    "Knocker":        0x00285e14,
    "Kijimunaa":      0x00285e34,
    "Jack Frost":     0x00285e54,
    "Pyro Jack":      0x00285e74,
    "Silky":          0x00285e94,
    "Lorelei":        0x00285eb4,
    "Vivian":         0x00285ed4,
    "Titania":        0x00285ef4,
    "Oberon":         0x00285f14,
    "King Frost":     0x00285f34,
    "Moloch":         0x00285f54,
    "Hecate":         0x00285f74,
    "Tzitzmitl":      0x00285f94,
    "Astaroth":       0x00285fb4,
    "Mot":            0x00285fd4,
    "Loki":           0x00285ff4,
    "Lucifer":        0x00286014,
    "Ubelluris":      0x00286034,
    "Nalagiri":       0x00286054,
    "Hitokotonusi":   0x00286074,
    "Take-Mikazuchi": 0x00286094,
    "Zouchouten":     0x002860b4,
    "Jikokuten":      0x002860d4,
    "Koumokuten":     0x002860f4,
    "Bishamonten":    0x00286114,
    "Zaou Gongen":    0x00286134,
    "Kobold":         0x00286154,
    "Bilwis":         0x00286174,
    "Gozuki":         0x00286194,
    "Mezuki":         0x002861b4,
    "Ikusa":          0x002861d4,
    "Lham Dearg":     0x002861f4,
    "Berserker":      0x00286214,
    "Yaksa":          0x00286234,
    "Nata Taishi":    0x00286254,
    "Oumitsunu":      0x00286274,
    "Obariyon":       0x00286294,
    "Ogre":           0x002862b4,
    "Mokoi":          0x002862d4,
    "Ogun":           0x002862f4,
    "Wendigo":        0x00286314,
    "Legion":         0x00286334,
    "Rakshasa":       0x00286354,
    "Girimehkala":    0x00286374,
    "Grendel":        0x00286394,
    "Black Frost":    0x002863b4,
    "Kikimora":       0x002863d4,
    "Lilim":          0x002863f4,
    "Yuki Jyorou":    0x00286414,
    "Leanan Sidhe":   0x00286434,
    "Peri":           0x00286454,
    "Hariti":         0x00286474,
    "Rangda":         0x00286494,
    "Kali":           0x002864b4,
    "Lilith":         0x002864d4,
    "Poltergeist":    0x002864f4,
    "Agathion":       0x00286514,
    "Tenong Cut":     0x00286534,
    "Kumbhanda":      0x00286554,
    "Loa":            0x00286574,
    "Pisaca":         0x00286594,
    "Kudlak":         0x002865b4,
    "Purple Mirror":  0x002865d4,
    "Billiken":       0x002865f4,
    "Ghost Q":        0x00286614,
    "Sage of Time":   0x00286634,
    "Alice":          0x00286654,
    "Trumpeter":      0x00286674,
    "Neko Shogun":    0x00286694,
    "Hagen":          0x002866b4,
    "Jeanne d'Arc":   0x002866d4,
    "Yoshitsune":     0x002866f4,
    "Guan Yu":        0x00286714,
    "Flaemis":        0x00286734,
    "Aquans":         0x00286754,
    "Aeros":          0x00286774,
    "Erthys":         0x00286794,
    "Ara Mitama":     0x002867b4,
    "Nigi Mitama":    0x002867d4,
    "Kusi Mitama":    0x002867f4,
    "Saki Mitama":    0x00286814,
    "Satan":          0x00286954,
    "Beelzebub":      0x00286974,
    "Belial":         0x00286994,
    "Asp":            0x00286a74,
    "Apis":           0x00286a94,
    "Pabilsag":       0x00286ab4,
    "Sleipnir":       0x00286ad4,
    "Xiezhai":        0x00286af4,
    "Kangiten":       0x00286b14,
    "Baphomet":       0x00286b34,
    "Anat":           0x00286b54,
    "Pallas Athena":  0x00286b74,
    "Mithra":         0x00286b94,
    "Osiris":         0x00286bb4,
    "Gucumatz":       0x00286bd4,
    "Da Peng":        0x00286bf4,
    "Ometeotl":       0x00286c14,
    "Jarilo":         0x00286c34,
    "Botis":          0x00286c54,
    "Bifrons":        0x00286db4,
    "Barbatos":       0x00286dd4,
    "Dzelarhons":     0x00286df4,
    "Kama":           0x00286e14,
    "Parvati":        0x00286e34,
    "Ixtab":          0x00286e54,
    "Balor":          0x00286e74,
    "Nergal":         0x00286e94,
    "Inti":           0x00286eb4,
    "Alilat":         0x00286ed4,
    "Beiji-Weng":     0x00286ef4,
    "Lord Nan Dou":   0x00286f14,
    "Masakado":       0x00286f34
}

// I hate everything.
// This map is needed because enemy IDs loosely follow what the compendium lists, but there's other entities intermingled in there.
// Other entities being different variants of an enemy, human characters, other enemies that don't line up or appear otherwise in compendium
// The compendium itself also skips over some of the entries, i.e. there aren't empty slots between the following two entries
//    "Botis":         0xf0,
//    "Bifrons":       0x116,
// so we just gotta rattle 'em off.
enemy_id_by_name = {
    "Hero":           0x00,
    "Ronaldo":        0x01,
    // I have to PRESUME that other human controllable characters you can fight go here.
    // i.e. this now goes from Io -> Anguished One, placing Anguished One at 0x0d
    "Io":             0x02,
    "Yamato":         0x03,
    "Fumi":           0x04,
    "Daichi":         0x05,
    "Otome":          0x06,
    "Jungo":          0x07,
    "Makoto":         0x08,
    "Keita":          0x09,
    "Airi":           0x0a,
    "Joe":            0x0b,
    "Hinako":         0x0c,
    "Anguished One":  0x0d,
    // End of presumed character IDs 
    "Tonatiuh":       0x0e,
    "Chernobog":      0x0f,
    "Wu Kong":        0x10,
    "Susano-o":       0x11,
    "Kartikeya":      0x12,
    "Shiva":          0x13,
    "Hathor":         0x14,
    "Sarasvati":      0x15,
    "Kikuri-Hime":    0x16,
    "Brigid":         0x17,
    "Scathach":       0x18,
    "Laksmi":         0x19,
    "Norn":           0x1a,
    "Isis":           0x1b,
    "Amaterasu":      0x1c,
    "Mahakala":       0x1d,
    "Thor":           0x1e,
    "Arahabaki":      0x1f,
    "Odin":           0x20,
    "Yama":           0x21,
    "Lugh":           0x22,
    "Baal":           0x23,
    "Asura":          0x24,
    "Orcus":          0x25,
    "Pazuzu":         0x26,
    "Abaddon":        0x27,
    "Tao Tie":        0x28,
    "Arioch":         0x29,
    "Tezcatlipoca":   0x2a,
    "Nyarlathotep":   0x2b,
    "Makara":         0x2c,
    "Nozuchi":        0x2d,
    "Pendragon":      0x2e,
    "Gui Xian":       0x2f,
    "Quetzalcoatl":   0x30,
    "Seiryuu":        0x31,
    "Orochi":         0x32,
    "Ananta":         0x33,
    "Hoyau Kamui":    0x34,
    "Toubyou":        0x35,
    "Bai Suzhen":     0x36,
    "Basilisk":       0x37,
    "Ym":             0x38,
    "Python":         0x39,
    "Culebre":        0x3a,
    "Vritra":         0x3b,
    "Vasuki":         0x3c,
    // My notes indicate something called "Holy Ghost" is 0x3d, but I don't know if that's a real thing you can encounter
    "Angel":          0x3e,
    "Power":          0x3f,
    "Lailah":         0x40,
    "Aniel":          0x41, 
    "Kazfiel":        0x42,
    "Remiel":         0x43,
    "Metatron":       0x44,
    "Itsumade":       0x45,
    "Moh Shuvuu":     0x46,
    "Hamsa":          0x47,
    "Suparna":        0x48,
    "Vidofnir":       0x49,
    "Badb Catha":     0x4a,
    "Anzu":           0x4b,
    "Feng Huang":     0x4c,
    "Garuda":         0x4d,
    "Gagyson":        0x4e,
    "Abraxas":        0x4f,
    "Flauros":        0x50,
    "Nisroc":         0x51,
    "Orobas":         0x52,
    "Decarabia":      0x53,
    "Nebiros":        0x54,
    "Agares":         0x55,
    "Murmur":         0x56,
    "Heqet":          0x57,
    "Kamapua'a":      0x58,
    "Shiisaa":        0x59,
    "Bai Ze":         0x5a,
    "Baihu":          0x5b,
    "Airavata":       0x5c,
    "Ukano Mitama":   0x5d,
    "Barong":         0x5e,
    "Anubis":         0x5f,
    "Kabuso":         0x60,
    "Hairy Jack":     0x61,
    "Nekomata":       0x62,
    "Cait Sith":      0x63,
    "Nue":            0x64,
    "Orthrus":        0x65,
    "Myrmecolion":    0x66,
    "Cerberus":       0x67,
    "Fenrir":         0x68,
    "Hare of Inaba":  0x69,
    "Waira":          0x6a,
    "Garm":           0x6b,
    "Afanc":          0x6c,
    "Mothman":        0x6d,
    "Taown":          0x6e,
    "Behemoth":       0x6f,
    "Ammut":          0x70,
    "Tam Lin":        0x71,
    "Jambavan":       0x72,
    "Tlaloc":         0x73,
    "Ictinike":       0x74,
    "Hanuman":        0x75,
    "Cu Chulainn":    0x76,
    "Kresnik":        0x77,
    "Ganesha":        0x78,
    "Heimdall":       0x79,
    "Pixie":          0x7a,
    "Knocker":        0x7b,
    "Kijimunaa":      0x7c,
    "Jack Frost":     0x7d,
    "Pyro Jack":      0x7e,
    "Silky":          0x7f,
    "Lorelei":        0x80,
    "Vivian":         0x81,
    "Titania":        0x82,
    "Oberon":         0x83,
    "King Frost":     0x84,
    "Moloch":         0x85,
    "Hecate":         0x86,
    "Tzitzmitl":      0x87,
    "Astaroth":       0x88,
    "Mot":            0x89,
    "Loki":           0x8a,
    "Lucifer":        0x8b,
    "Ubelluris":      0x8c,
    "Nalagiri":       0x8d,
    "Hitokotonusi":   0x8e,
    "Take-Mikazuchi": 0x8f,
    "Zouchouten":     0x90,
    "Jikokuten":      0x91,
    "Koumokuten":     0x92,
    "Bishamonten":    0x93,
    "Zaou Gongen":    0x94,
    "Kobold":         0x95,
    "Bilwis":         0x96,
    "Gozuki":         0x97,
    "Mezuki":         0x98,
    "Ikusa":          0x99,
    "Lham Dearg":     0x9a,
    "Berserker":      0x9b,
    "Yaksa":          0x9c,
    "Nata Taishi":    0x9d,
    "Oumitsunu":      0x9e,
    "Obariyon":       0x9f,
    "Ogre":           0xa0,
    "Mokoi":          0xa1,
    "Ogun":           0xa2,
    "Wendigo":        0xa3,
    "Legion":         0xa4,
    "Rakshasa":       0xa5,
    "Girimehkala":    0xa6,
    "Grendel":        0xa7,
    "Black Frost":    0xa8,
    "Kikimora":       0xa9,
    "Lilim":          0xaa,
    "Yuki Jyorou":    0xab,
    "Leanan Sidhe":   0xac,
    "Peri":           0xad,
    "Hariti":         0xae,
    "Rangda":         0xaf,
    "Kali":           0xb0,
    "Lilith":         0xb1,
    "Poltergeist":    0xb2,
    "Agathion":       0xb3,
    "Tenong Cut":     0xb4,
    "Kumbhanda":      0xb5,
    "Loa":            0xb6,
    "Pisaca":         0xb7,
    "Kudlak":         0xb8,
    "Purple Mirror":  0xb9,
    "Billiken":       0xba,
    "Ghost Q":        0xbb,
    "Sage of Time":   0xbc,
    "Alice":          0xbd,
    "Trumpeter":      0xbe,
    "Neko Shogun":    0xbf,
    "Hagen":          0xc0,
    "Jeanne d'Arc":   0xc1,
    "Yoshitsune":     0xc2,
    "Guan Yu":        0xc3,
    "Flaemis":        0xc4,
    "Aquans":         0xc5,
    "Aeros":          0xc6,
    "Erthys":         0xc7,
    "Ara Mitama":     0xc8,
    "Nigi Mitama":    0xc9,
    "Kusi Mitama":    0xca,
    "Saki Mitama":    0xcb,
    "Merak":          0xcd,
    "Phecda (Whole)": 0xce,
    "Megrez":         0xcf,
    "Alioth Core":    0xd0,
    "Polaris":        0xd4,
    "Satan":          0xd5,
    "Beelzebub":      0xd6,
    "Belial":         0xd7,
    "Asp":            0xe0,
    "Apis":           0xe1,
    "Pabilsag":       0xe2,
    "Sleipnir":       0xe3,
    "Xiezhai":        0xe4,
    "Kangiten":       0xe5,
    "Baphomet":       0xe6,
    "Anat":           0xe7,
    "Pallas Athena":  0xe8,
    "Mithra":         0xe9,
    "Osiris":         0xea,
    "Gucumatz":       0xeb,
    "Da Peng":        0xec,
    "Ometeotl":       0xed,
    "Jarilo":         0xee,
    "Botis":          0xf0,
    "Salaryman":      0xf2,  // Specifically from App Abuser Amrita/Phys Up/Hustle
    "Punk":           0xf9,  // Specifically from App Abuser Snipe/Mana Bonus/Hustle
    "Phecda (Magic)": 0xff,
    "Phecda (Phys)":  0x100,
    "Young Man":      0x10c, // Specifically from App Abuser Extra Cancel/Extra Bonus/Hustle
    "Dubhe (Whole)":  0x114, // Dubhe that can reflect phys and null others
    "Dubhe (Half)":   0x115, 
    "Bifrons":        0x116,
    "Barbatos":       0x117,
    "Dzelarhons":     0x118,
    "Kama":           0x119,
    "Parvati":        0x11a,
    "Ixtab":          0x11b,
    "Balor":          0x11c,
    "Nergal":         0x11d,
    "Inti":           0x11e,
    "Alilat":         0x11f,
    "Beiji-Weng":     0x120,
    "Lord Nan Dou":   0x121,
    "Masakado":       0x122,
    "Mizar Tentacle (1L)": 0x125,
    "Mizar Tentacle (1R)": 0x126,
    "Mizar Tentacle (3R)": 0x127,
    "Mizar Tentacle (2R)": 0x128,
    "Mizar Tentacle (2L)": 0x129,
    "Mizar Tentacle (3L)": 0x12a,
    "Polaris A":        0x131,
    "Tall Woman":     0x134, // Makoto in Daichi's Crisis
    "Salaryman Carrying Food": 0x146, // in Girl in Pursuit. No, do not fix the indentation.
    "Polaris B":        0x15f,
    "Polaris (Complete)": 0x163, // the actual fr fr final boss
    "Vacant Woman":   0x164, // Fumi in Demon-Hacked
}

// This map exists for RP purposes, that's it
enemy_name_by_id = {
    0x00: "Hero", // That's what the game calls him!
    0x01: "Ronaldo",
    0x02: "Io",
    0x03: "Yamato",
    0x04: "Fumi",
    0x05: "Daichi",
    0x06: "Otome",
    0x07: "Jungo",
    0x08: "Makoto",
    0x09: "Keita",
    0x0a: "Airi",
    0x0b: "Joe",
    0x0c: "Hinako",
    0x0d: "Anguished One",
    0x0e: "Tonatiuh",
    0x0f: "Chernobog",
    0x10: "Wu Kong",
    0x11: "Susano-o",
    0x12: "Kartikeya",
    0x13: "Shiva",
    0x14: "Hathor",
    0x15: "Sarasvati",
    0x16: "Kikuri-Hime",
    0x17: "Brigid",
    0x18: "Scathach",
    0x19: "Laksmi",
    0x1a: "Norn",
    0x1b: "Isis",
    0x1c: "Amaterasu",
    0x1d: "Mahakala",
    0x1e: "Thor",
    0x1f: "Arahabaki",
    0x20: "Odin",
    0x21: "Yama",
    0x22: "Lugh",
    0x23: "Baal",
    0x24: "Asura",
    0x25: "Orcus",
    0x26: "Pazuzu",
    0x27: "Abaddon",
    0x28: "Tao Tie",
    0x29: "Arioch",
    0x2a: "Tezcatlipoca",
    0x2b: "Nyarlathotep",
    0x2c: "Makara",
    0x2d: "Nozuchi",
    0x2e: "Pendragon",
    0x2f: "Gui Xian",
    0x30: "Quetzalcoatl",
    0x31: "Seiryuu",
    0x32: "Orochi",
    0x33: "Ananta",
    0x34: "Hoyau Kamui",
    0x35: "Toubyou",
    0x36: "Bai Suzhen",
    0x37: "Basilisk",
    0x38: "Ym",
    0x39: "Python",
    0x3a: "Culebre",
    0x3b: "Vritra",
    0x3c: "Vasuki",
    // My notes indicate something called "Holy Ghost" is 0x3d, but I don't know if that's a real thing you can encounter
    0x3e: "Angel",
    0x3f: "Power",
    0x40: "Lailah",
    0x41: "Aniel", 
    0x42: "Kazfiel",
    0x43: "Remiel",
    0x44: "Metatron",
    0x45: "Itsumade",
    0x46: "Moh Shuvuu",
    0x47: "Hamsa",
    0x48: "Suparna",
    0x49: "Vidofnir",
    0x4a: "Badb Catha",
    0x4b: "Anzu",
    0x4c: "Feng Huang",
    0x4d: "Garuda",
    0x4e: "Gagyson",
    0x4f: "Abraxas",
    0x50: "Flauros",
    0x51: "Nisroc",
    0x52: "Orobas",
    0x53: "Decarabia",
    0x54: "Nebiros",
    0x55: "Agares",
    0x56: "Murmur",
    0x57: "Heqet",
    0x58: "Kamapua'a",
    0x59: "Shiisaa",
    0x5a: "Bai Ze",
    0x5b: "Baihu",
    0x5c: "Airavata",
    0x5d: "Ukano Mitama",
    0x5e: "Barong",
    0x5f: "Anubis",
    0x60: "Kabuso",
    0x61: "Hairy Jack",
    0x62: "Nekomata",
    0x63: "Cait Sith",
    0x64: "Nue",
    0x65: "Orthrus",
    0x66: "Myrmecolion",
    0x67: "Cerberus",
    0x68: "Fenrir",
    0x69: "Hare of Inaba",
    0x6a: "Waira",
    0x6b: "Garm",
    0x6c: "Afanc",
    0x6d: "Mothman",
    0x6e: "Taown",
    0x6f: "Behemoth",
    0x70: "Ammut",
    0x71: "Tam Lin",
    0x72: "Jambavan",
    0x73: "Tlaloc",
    0x74: "Ictinike",
    0x75: "Hanuman",
    0x76: "Cu Chulainn",
    0x77: "Kresnik",
    0x78: "Ganesha",
    0x79: "Heimdall",
    0x7a: "Pixie",
    0x7b: "Knocker",
    0x7c: "Kijimunaa",
    0x7d: "Jack Frost",
    0x7e: "Pyro Jack",
    0x7f: "Silky",
    0x80: "Lorelei",
    0x81: "Vivian",
    0x82: "Titania",
    0x83: "Oberon",
    0x84: "King Frost",
    0x85: "Moloch",
    0x86: "Hecate",
    0x87: "Tzitzmitl",
    0x88: "Astaroth",
    0x89: "Mot",
    0x8a: "Loki",
    0x8b: "Lucifer",
    0x8c: "Ubelluris",
    0x8d: "Nalagiri",
    0x8e: "Hitokotonusi",
    0x8f: "Take-Mikazuchi",
    0x90: "Zouchouten",
    0x91: "Jikokuten",
    0x92: "Koumokuten",
    0x93: "Bishamonten",
    0x94: "Zaou Gongen",
    0x95: "Kobold",
    0x96: "Bilwis",
    0x97: "Gozuki",
    0x98: "Mezuki",
    0x99: "Ikusa",
    0x9a: "Lham Dearg",
    0x9b: "Berserker",
    0x9c: "Yaksa",
    0x9d: "Nata Taishi",
    0x9e: "Oumitsunu",
    0x9f: "Obariyon",
    0xa0: "Ogre",
    0xa1: "Mokoi",
    0xa2: "Ogun",
    0xa3: "Wendigo",
    0xa4: "Legion",
    0xa5: "Rakshasa",
    0xa6: "Girimehkala",
    0xa7: "Grendel",
    0xa8: "Black Frost",
    0xa9: "Kikimora",
    0xaa: "Lilim",
    0xab: "Yuki Jyorou",
    0xac: "Leanan Sidhe",
    0xad: "Peri",
    0xae: "Hariti",
    0xaf: "Rangda",
    0xb0: "Kali",
    0xb1: "Lilith",
    0xb2: "Poltergeist",
    0xb3: "Agathion",
    0xb4: "Tenong Cut",
    0xb5: "Kumbhanda",
    0xb6: "Loa",
    0xb7: "Pisaca",
    0xb8: "Kudlak",
    0xb9: "Purple Mirror",
    0xba: "Billiken",
    0xbb: "Ghost Q",
    0xbc: "Sage of Time",
    0xbd: "Alice",
    0xbe: "Trumpeter",
    0xbf: "Neko Shogun",
    0xc0: "Hagen",
    0xc1: "Jeanne d'Arc",
    0xc2: "Yoshitsune",
    0xc3: "Guan Yu",
    0xc4: "Flaemis",
    0xc5: "Aquans",
    0xc6: "Aeros",
    0xc7: "Erthys",
    0xc8: "Ara Mitama",
    0xc9: "Nigi Mitama",
    0xca: "Kusi Mitama",
    0xcb: "Saki Mitama",
    0xcd: "Merak",
    0xce: "Phecda",
    0xcf: "Megrez",
    0xd0: "Alioth Core",
    0xd4: "Polaris",
    0xd5: "Satan",
    0xd6: "Beelzebub",
    0xd7: "Belial",
    0xe0: "Asp",
    0xe1: "Apis",
    0xe2: "Pabilsag",
    0xe3: "Sleipnir",
    0xe4: "Xiezhai",
    0xe5: "Kangiten",
    0xe6: "Baphomet",
    0xe7: "Anat",
    0xe8: "Pallas Athena",
    0xe9: "Mithra",
    0xea: "Osiris",
    0xeb: "Gucumatz",
    0xec: "Da Peng",
    0xed: "Ometeotl",
    0xee: "Jarilo",
    0xf0: "Botis",
    0xf2: "Salaryman",
    0xf3: "Salaryman",
    0xf6: "Office Lady",
    0xf7: "Office Lady",
    0xf8: "Office Lady",
    0xf9: "Punk",
    0xfa: "Punk",
    0xfc: "Yakuza",
    0xff: "Phecda",
    0x100: "Phecda",
    0x103: "Dragon",
    0x10a: "Worker",
    0x10b: "Student",
    0x10c: "Young Man",
    0x114: "Dubhe",
    0x115: "Dubhe",
    0x116: "Bifrons",
    0x117: "Barbatos",
    0x118: "Dzelarhons",
    0x119: "Kama",
    0x11a: "Parvati",
    0x11b: "Ixtab",
    0x11c: "Balor",
    0x11d: "Nergal",
    0x11e: "Inti",
    0x11f: "Alilat",
    0x120: "Beiji-Weng",
    0x121: "Lord Nan Dou",
    0x122: "Masakado",
    0x123: "Mizar",
    0x124: "Mizar",
    // Mizar tentacles
    0x125: "Tentacle",
    0x126: "Tentacle",
    0x127: "Tentacle",
    0x128: "Tentacle",
    0x129: "Tentacle",
    0x12a: "Tentacle",
    0x12c: "Benetsnach",
    0x12d: "Benetsnach",
    0x12e: "Benetsnach",
    0x12f: "Benetsnach",
    0x131: "Polaris A",
    0x134: "Tall Woman",  // Makoto in Daichi's Crisis
    0x137: "Daichi (Tied Up)", // Daichi in Saving Daichi / Goodbye Jungo
    0x13f: "Guardian",
    0x140: "Guardian",
    0x141: "Guardian",
    0x143: "Guardian",
    0x146: "Salaryman Carrying Food", // in Girl in Pursuit
    0x149: "Student",
    0x15f: "Polaris B",
    0x161: "Fumi",        // in Hacker Revealed
    0x163: "Polaris",
    0x164: "Vacant Woman" // Fumi in Demon-Hacked
}

// Check if the player has access to the demon compendium
function compendium_added() => bit7(0x00284cb3) == 0x01 && byte(0x00284cb3) != 0xff
// the compendium itself is in a static spot in memory
start_of_compendium = 0x00285074
// each entry is 32 bytes long
end_of_compendium = 0x00287054
// There are multiple indicators for a valid compendium entry. Each demon has a 32-byte space they're statically stored in.
// We're using the following indicator that is common to every demon: entry + 0x04 == 0xff.
// @param demon_name the human readable name of the demon you want to check registry for
function demon_registered(demon_name) {
    return byte(monster_addr_by_name[demon_name] + 0x04) / 0xff
}

// Check how many demons are currently registered in the player's compendium.
// The game has internal listings of monster IDs/offsets from 0x0e ranging to 0x12b.
// However, not every ID is used between those IDs and some IDs are for enemies that can't be acquired.
// In this version of the game, there are 221 demons you can get total. 
// https://aqiu384.github.io/megaten-fusion-tool/ds2/demons has details for all demons that you can get
function num_registered_compendium() {
    return sum_of(monster_addr_by_name, demon_registered)
}

// There are 4 "Element" demons in the game that cost 1000 macca to fuse
function elements_registered() {
    return demon_registered("Flaemis") + demon_registered("Aquans") + demon_registered("Aeros") + demon_registered("Erthys")
}

// There are 4 demons with the Mitama race, but 5 have it in their name.
function mitamas_registered() {
    return demon_registered("Nigi Mitama") + demon_registered("Saki Mitama") + demon_registered("Ara Mitama") + demon_registered("Kusi Mitama")
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

function char_fate_staged_progressed_to(char_name, desired_stage) {
    // This should be a static size between array spots but for whatever reason this was falling apart when I tried to use math
    // The solution? Never do math.
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
    for i in range(0, 13) {
        char_addr = 0x002844e4 + (i * 0x24)
        cond = cond || (word(char_addr) == chararacter_ids_by_name[char_name] 
            && prev(byte(char_addr + 0x21)) == 0x04 
            && byte(char_addr + 0x21) == 0x05)
    }

    return cond

}

// Check if a given character has their FATE stage maxed.
// Characters are stored in an array that is sorted based on who's in party.
// Protag always leads array and is fixed at 0x002844c2.
// Other characters that aren't protag start array at 0x002844e4 and end array at 0x002846b8.
// Fate stage is 0x21 into block.
function char_fate_stage_maxed(char_name) {
    cond = always_false()
    for i in range(0, 13) {
        char_addr = 0x002844e4 + (i * 0x24)
        cond = cond || (word(char_addr) == chararacter_ids_by_name[char_name]
            // protection against the game sorting characters
            && prev(word(char_addr)) == word(char_addr)
            && prev(byte(char_addr + 0x21)) == 0x04 
            && byte(char_addr + 0x21) == 0x05)
    }

    return cond
}

// Locations by id.
// This is the location you enter the event at; it's not the actual location your character might be at plot wise 
// because sometimes characters move around to different spots mid event.
location = {
    0x00: "Aoyama Cemetary",
    0x01: "??? 0x01",
    0x02: "Akasaka Tunnel",
    0x03: "Akihabara Street",
    0x04: "Sensouji",
    0x05: "Toyo Anzu",
    0x06: "Sunset Blvd",
    0x07: "Eikokuji",
    0x08: "Fukutoshin Line Platform",
    0x09: "Omotesando",
    0x0a: "Shinbashi Special Platform",
    0x0b: "Bugeikan",
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
    0x20: "Roppongi Crosswalk",
    0x21: "99 Plaza",
    0x22: "??? 0x22",
    0x23: "Tokyo Station, Central Exit",
    0x24: "Shinjuku Govt Plaza",
    0x25: "Multipurpose Hall",
    0x26: "??? 0x26",
    0x27: "Miyashita Park",
    0x28: "Room ",
    0x29: "??? 0x29",
    0x2a: "Roppongi Hills",
    0x2b: "Akasaka Palace",
    0x2c: "Nagata-cho, Tokyo Branch",
    0x2d: "Asakusa Sensouji",
    0x2e: "Sankyu Line",
    0x2f: "Bickman",
    0x30: "Sankyu 3rd District",
    0x31: "Shin-Osaka Special Platform",
    0x32: "Triangle Plaza",
    0x33: "the Festgate", // The real name is "Festival Gate" but one of the characters calls it Festgate
    0x34: "Tsuutenkaku",
    0x35: "Shinsekai",
    0x36: "??? 0x36",
    0x37: "Akasaka Mall",
    0x38: "Ebisu Bridge",
    0x39: "OCUT Plaza",
    0x3a: "Ten 7 Mall",
    0x3b: "Tennouji Station Turnstile",
    0x3c: "??? 0x3c",
    0x3d: "Osaka Castle Park Square",
    0x3e: "Shinsekai Terminal Mk. 2",
    0x3f: "??? 0x3f", 
    0x41: "Shinsekai Terminal",
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

// This is for combat missions
// Note that some missions share an ID; there's likely multiple factors being used to set up the real combat mission
// As an example: Osaka Soul vs. Too Late share an ID
// The mission is largely the same, except in Too Late the Keita unit is replaced with a Waira unit
// Easier to think of it as a "combat mission id" though.
combat_mission_by_name = {
    "Man of Fury (Ronaldo)": 0x0020,
    "Man of Fury (Phecda)": 0x0021,
}

// This is for events selected on the map
event_id_by_name = {
    "Death Clip":           0x3e9,
    "Daichi's Crisis":      0x3f1,
    "A Man Named Joe":      0x3f3,
    "Daichi's Resolve":     0x3f4,
    "App Abuser":           0x7d4,
    "Never Say Die":        0x7d8,
    "Demon-Hacked":         0x7da,
    "Osaka Soul":           0x7dc,
    "Merak Arrives":        0x7e2,
    "Vs. Q":                0xbbb,
    "Girl in Pursuit":      0xbbd,
    "Boy in Combat":        0xbbe,        
    "Hacker Revealed":      0xbbf,
    "Saving Daichi":        0xbc2,
    "Man of Fury":          0xbc4,
    "Bud of Malice":        0xfa1,
    "A Hard Choice":        0xfa7,
    "Megrez Meeting":       0xfa8,
    "Delta Battle":         0xfb5,
    "Poisonous Day":        0x1389,
    "Nataraja":             0x1398,
    "Ananga":               0x1399,
    "Unexpected Hostility": 0x139d,
    "Victim of Foul Play":  0x139e,
    "Alioth Core":          0x13a4,
    "Normality Gone":       0x13a6,
    "God of Luck":          0x177a,
    "Barrier Failure":      0x177d,
    "The Dragon":           0x1783,
    "Food Chain":           0x1784,
    "Ronaldo Rises":        0x1785,
    "Vs. Tokyo":            0x1c85,
    "Strong Breaker":       0x2072,
    "New Tomorrow":         0x2073,
    "The Promise":          0x2432
}

missions_by_id = {
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
    0xbbf: "Hacker Revealed",
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
    0x13a4: "Alioth Core",
    0x13a6: "Normality Gone",
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
    0x08: "Last Day"
}

// Game keeps a separate byte stored to indicate which unit is taking their turn.
// This byte is null until the mission starts, so we can use it to determine when the player has selected "Mission Start"
function active_mission_started() => ptr_valid(FULL_COMBAT_PTR) && prev(byte(COMBAT_PTR + 0x24c)) == 0xff && byte(COMBAT_PTR + 0x24c) != 0xff
// Sister method to #active_mission_started, except it only checks that this ever happened and not that it happened right now.
function active_mission_in_progress() => ptr_valid(FULL_COMBAT_PTR) && byte(COMBAT_PTR + 0x24c) != 0xff

// Rolling with this approach until something more consistent pops up.
// The game seems to like to use the following addresses for flags for the *current* mission:
// [0x00284b54, 0x00284b55, 0x00284b56, 0x00284b57, 0x00284b58].
// As we only need a generic check for some missions, for a given mission we'll check if the associated flag flipped.
function active_mission_completed(mission_name) {
    if (mission_name == "Daichi's Crisis") {
        return prev(bit2(0x00284b55)) == 0x00 && bit2(0x00284b55) == 0x01
    }

    if (mission_name == "A Man Named Joe") {
        return prev(bit1(0x00284b56)) == 0x00 && bit1(0x00284b56) == 0x01
    }

    if (mission_name == "Demon-Hacked") {
        return prev(bit1(0x00284b57) == 0x00) && bit1(0x00284b57) == 0x01
    }

    if (mission_name == "Never Say Die") {
        return prev(bit2(0x00284b57)) == 0x00 && bit2(0x00284b57) == 0x01
    }

    if (mission_name == "Osaka Soul") { 
        return prev(bit4(0x00284b54)) == 0x00 && bit4(0x00284b54) == 0x01
    }

    if (mission_name == "Hacker Revealed") {
        return prev(bit2(0x00284b56)) == 0x00 && bit2(0x00284b56) == 0x01
    }

    if (mission_name == "Barrier Failure") {
        return prev(bit7(0x00284b59) == 0x00) && bit7(0x00284b59) == 0x01
    }
}

// Helper while we're still mapping out mails.
// For every mailbox address we don't know about, tell us when it flips from 0xff to anything else.
function mailbox_hunt_helper() {
    starting_addr = 0x00284cb1
    ending_addr = 0x00284d83

    mapped_addrs = [
        0x00284cb3,
        0x00284cb4,
        0x00284cb5,
        0x00284cb6,
        0x00284cb7,
        0x00284cb8,
        0x00284cb9,
        0x00284cbb,
        0x00284ccb,
        0x00284ccc,
        0x00284cce,
        0x00284ccf,
        0x00284ce6,
        0x00284ce7,
        0x00284cd5,
        0x00284cd6,
        0x00284cd7,
        0x00284cd9
    ]

    mails_to_check = DAY <= 0x08

    for i in range(0x00284cb0, 0x00284d83) {
        if (!array_contains(mapped_addrs, i)) {
            mails_to_check = mails_to_check || (prev(byte(i)) == 0xff && byte(i) != 0xff)
        } 
    }
    return mails_to_check
}

// Helper function to check if a specific in-game mail just started being read.
// This is usually sent out at the end of special optional missions, making it really handy to use as a final trigger.  
function mail_triggered(mail_name) {
    if (mail_name == "Re: Jikoku") {
        addr = 0x00284cbc
    } else if (mail_name == "Re: Bilikin") {
        addr = 0x00284cba
    } else if (mail_name == "Re: Hitokotonusi") {
        addr = 0x00284cb8
    } else if (mail_name == "Re: Trumpeter") {
        addr = 0x00284cc0
    }

    return byte(addr) != 0xff && prev(bit7(addr)) == 0x01 && bit7(addr) == 0x00
}

achievement(
    title = "[FOR DEV]Mailbox Hunt",
    description = "You got mail!",
    points = 0,
    trigger = IN_GAME_CLOCK != 0x0000 && DAY <= 0x08 && mailbox_hunt_helper()
)

achievement(
    title = "[FOR DEV]Zone Change",
    description = "New zone where dis",
    points = 0,
    trigger = IN_GAME_CLOCK != 0000 && (
        CURRENT_LOCATION == 0x01 ||
        CURRENT_LOCATION == 0x13 ||
        CURRENT_LOCATION == 0x14 ||
        CURRENT_LOCATION == 0x15 ||
        CURRENT_LOCATION == 0x1a ||
        CURRENT_LOCATION == 0x1f ||
        CURRENT_LOCATION == 0x22 ||
        CURRENT_LOCATION == 0x26 ||
        CURRENT_LOCATION == 0x29 ||
        CURRENT_LOCATION == 0x36 ||
        CURRENT_LOCATION == 0x3c ||
        CURRENT_LOCATION == 0x3f ||
        CURRENT_LOCATION == 0x52
    )
)

achievement(
    title = "[FOR DEV]Event Flag Hunt",
    description = "Events have flags associated to say 'you did this.' This might be one of them!",
    points = 0,
    trigger = DAY <= 0x08 && (
        // 0x00284ad8
        (prev(bit1(0x00284ad8)) == 0x00 && bit1(0x00284ad8) == 0x01) ||
        (prev(bit5(0x00284ad8)) == 0x00 && bit5(0x00284ad8) == 0x01) ||
        // 0x00284ad9
        (prev(bit1(0x00284ad9)) == 0x00 && bit1(0x00284ad9) == 0x01) ||
        (prev(bit3(0x00284ad9)) == 0x00 && bit3(0x00284ad9) == 0x01) ||
        (prev(bit4(0x00284ad9)) == 0x00 && bit4(0x00284ad9) == 0x01) ||
        // 0x00284ada
        (prev(bit1(0x00284ada)) == 0x00 && bit1(0x00284ada) == 0x01) ||
        // 0x00284adb
        (prev(bit2(0x00284adb)) == 0x00 && bit2(0x00284adb) == 0x01) ||
        (prev(bit6(0x00284adb)) == 0x00 && bit6(0x00284adb) == 0x01) ||
        // 0x00284adc
        (prev(bit1(0x00284adc)) == 0x00 && bit1(0x00284adc) == 0x01) ||
        (prev(bit2(0x00284adc)) == 0x00 && bit2(0x00284adc) == 0x01) ||
        (prev(bit3(0x00284adc)) == 0x00 && bit3(0x00284adc) == 0x01) ||
        (prev(bit4(0x00284adc)) == 0x00 && bit4(0x00284adc) == 0x01) ||
        // 0x00284add
        (prev(bit1(0x00284add)) == 0x00 && bit1(0x00284add) == 0x01) ||
        (prev(bit2(0x00284add)) == 0x00 && bit2(0x00284add) == 0x01) ||
        (prev(bit7(0x00284add)) == 0x00 && bit7(0x00284add) == 0x01) ||
        // 0x00284ade
        (prev(bit5(0x00284ade)) == 0x00 && bit5(0x00284ade) == 0x01) ||
        (prev(bit6(0x00284ade)) == 0x00 && bit6(0x00284ade) == 0x01) ||
        // 0x00284adf
        (prev(bit0(0x00284adf)) == 0x00 && bit0(0x00284adf) == 0x01) ||
        (prev(bit4(0x00284adf)) == 0x00 && bit4(0x00284adf) == 0x01) ||
        (prev(bit7(0x00284adf)) == 0x00 && bit7(0x00284adf) == 0x01) ||
        // 0x00284ae0
        (prev(bit0(0x00284ae0)) == 0x00 && bit0(0x00284ae0) == 0x01) ||
        (prev(bit5(0x00284ae0)) == 0x00 && bit5(0x00284ae0) == 0x01) ||
        // 0x00284ae1
        (prev(bit1(0x00284ae1)) == 0x00 && bit1(0x00284ae1) == 0x01) ||
        (prev(bit3(0x00284ae1)) == 0x00 && bit3(0x00284ae1) == 0x01) ||
        (prev(bit4(0x00284ae1)) == 0x00 && bit4(0x00284ae1) == 0x01) ||
        (prev(bit6(0x00284ae1)) == 0x00 && bit6(0x00284ae1) == 0x01) ||
        // 0x00284ae2 
        (prev(bit0(0x00284ae2)) == 0x00 && bit0(0x00284ae2) == 0x01) ||
        (prev(bit1(0x00284ae2)) == 0x00 && bit1(0x00284ae2) == 0x01) ||
        (prev(bit2(0x00284ae2)) == 0x00 && bit2(0x00284ae2) == 0x01) ||
        (prev(bit3(0x00284ae2)) == 0x00 && bit3(0x00284ae2) == 0x01) ||
        (prev(bit4(0x00284ae2)) == 0x00 && bit4(0x00284ae2) == 0x01) ||
        (prev(bit5(0x00284ae2)) == 0x00 && bit5(0x00284ae2) == 0x01) ||
        (prev(bit6(0x00284ae2)) == 0x00 && bit6(0x00284ae2) == 0x01) ||
        // 0x00284ae3
        (prev(bit7(0x00284ae3)) == 0x00 && bit7(0x00284ae3) == 0x01) ||
        // 0x00284ae4
        (prev(bit0(0x00284ae4)) == 0x00 && bit0(0x00284ae4) == 0x01) ||
        (prev(bit2(0x00284ae4)) == 0x00 && bit2(0x00284ae4) == 0x01) ||
        (prev(bit3(0x00284ae4)) == 0x00 && bit3(0x00284ae4) == 0x01) ||
        // 0x00284ae5
        // bit4 is likely Jungo's Find
        (prev(bit4(0x00284ae5)) == 0x00 && bit4(0x00284ae5) == 0x01) ||
        (prev(bit5(0x00284ae5)) == 0x00 && bit5(0x00284ae5) == 0x01) ||
        (prev(bit6(0x00284ae5)) == 0x00 && bit6(0x00284ae5) == 0x01) ||
        (prev(bit7(0x00284ae5)) == 0x00 && bit7(0x00284ae5) == 0x01) ||
        // 0x00284ae6
        (prev(bit2(0x00284ae6)) == 0x00 && bit2(0x00284ae6) == 0x01) ||
        (prev(bit3(0x00284ae6)) == 0x00 && bit3(0x00284ae6) == 0x01) ||
        // 0x00284ae7
        (prev(bit1(0x00284ae7)) == 0x00 && bit1(0x00284ae7) == 0x01) ||
        (prev(bit2(0x00284ae7)) == 0x00 && bit2(0x00284ae7) == 0x01) ||
        (prev(bit3(0x00284ae7)) == 0x00 && bit3(0x00284ae7) == 0x01) ||
        (prev(bit4(0x00284ae7)) == 0x00 && bit4(0x00284ae7) == 0x01) ||
        (prev(bit5(0x00284ae7)) == 0x00 && bit5(0x00284ae7) == 0x01) ||
        (prev(bit6(0x00284ae7)) == 0x00 && bit6(0x00284ae7) == 0x01) ||
        // 0x00284ae8
        (prev(bit0(0x00284ae8)) == 0x00 && bit0(0x00284ae8) == 0x01) ||
        (prev(bit1(0x00284ae8)) == 0x00 && bit1(0x00284ae8) == 0x01) ||
        (prev(bit2(0x00284ae8)) == 0x00 && bit2(0x00284ae8) == 0x01) ||
        (prev(bit3(0x00284ae8)) == 0x00 && bit3(0x00284ae8) == 0x01) ||
        (prev(bit4(0x00284ae8)) == 0x00 && bit4(0x00284ae8) == 0x01) ||
        // 0x00284ae9 is fully covered
        // 0x00284aea is fully covered
        // 0x00284aeb is fully covered
        // 0x00284aec is fully covered
        // 0x00284aed is fully covered
        // 0x00284aee is fully covered
        // 0x00284aef is fully covered
        // 0x00284af0 is fully covered
        // 0x00284af1 is fully covered
        // 0x00284af2
        (prev(bit0(0x00284af2)) == 0x00 && bit0(0x00284af2) == 0x01) ||
        (prev(bit2(0x00284af2)) == 0x00 && bit2(0x00284af2) == 0x01) ||
        // 0x00284af3
        (prev(bit1(0x00284af3)) == 0x00 && bit1(0x00284af3) == 0x01) ||
        // 0x00284af4
        (prev(bit0(0x00284af4)) == 0x00 && bit0(0x00284af4) == 0x01) ||
        (prev(bit4(0x00284af4)) == 0x00 && bit4(0x00284af4) == 0x01) ||
        (prev(bit5(0x00284af4)) == 0x00 && bit5(0x00284af4) == 0x01) ||
        (prev(bit6(0x00284af4)) == 0x00 && bit6(0x00284af4) == 0x01) ||
        // 0x00284af5
        (prev(bit1(0x00284af5)) == 0x00 && bit1(0x00284af5) == 0x01) ||
        (prev(bit2(0x00284af5)) == 0x00 && bit2(0x00284af5) == 0x01) ||
        (prev(bit4(0x00284af5)) == 0x00 && bit4(0x00284af5) == 0x01) ||
        (prev(bit5(0x00284af5)) == 0x00 && bit5(0x00284af5) == 0x01) ||
        (prev(bit6(0x00284af5)) == 0x00 && bit6(0x00284af5) == 0x01) ||
        // 0x00284af6
        (prev(bit1(0x00284af6)) == 0x00 && bit1(0x00284af6) == 0x01) ||
        (prev(bit2(0x00284af6)) == 0x00 && bit2(0x00284af6) == 0x01) ||
        (prev(bit3(0x00284af6)) == 0x00 && bit3(0x00284af6) == 0x01) ||
        (prev(bit4(0x00284af6)) == 0x00 && bit4(0x00284af6) == 0x01) ||
        (prev(bit5(0x00284af6)) == 0x00 && bit5(0x00284af6) == 0x01) ||
        (prev(bit6(0x00284af6)) == 0x00 && bit6(0x00284af6) == 0x01) ||
        // 0x00284af7
        (prev(bit0(0x00284af7)) == 0x00 && bit0(0x00284af7) == 0x01) ||
        (prev(bit1(0x00284af7)) == 0x00 && bit1(0x00284af7) == 0x01) ||
        (prev(bit2(0x00284af7)) == 0x00 && bit2(0x00284af7) == 0x01) ||
        (prev(bit3(0x00284af7)) == 0x00 && bit3(0x00284af7) == 0x01) ||
        (prev(bit6(0x00284af7)) == 0x00 && bit6(0x00284af7) == 0x01) ||
        // 0x00284af8
        (prev(bit3(0x00284af8)) == 0x00 && bit3(0x00284af8) == 0x01) ||
        // 0x00284af9 fully covered
        // 0x00284afa
        (prev(bit3(0x00284afa)) == 0x00 && bit3(0x00284afa) == 0x01) || 
        (prev(bit5(0x00284afa)) == 0x00 && bit5(0x00284afa) == 0x01) || 
        (prev(bit6(0x00284afa)) == 0x00 && bit6(0x00284afa) == 0x01) || 
        (prev(bit7(0x00284afa)) == 0x00 && bit7(0x00284afa) == 0x01) || 
        // 0x00284afb
        (prev(bit4(0x00284afb)) == 0x00 && bit4(0x00284afb) == 0x01) ||
        (prev(bit5(0x00284afb)) == 0x00 && bit5(0x00284afb) == 0x01) ||
        (prev(bit6(0x00284afb)) == 0x00 && bit6(0x00284afb) == 0x01) ||
        (prev(bit7(0x00284afb)) == 0x00 && bit7(0x00284afb) == 0x01) ||
        // 0x00284afc
        (prev(bit0(0x00284afc)) == 0x00 && bit0(0x00284afc) == 0x01) ||
        (prev(bit1(0x00284afc)) == 0x00 && bit1(0x00284afc) == 0x01) ||
        (prev(bit2(0x00284afc)) == 0x00 && bit2(0x00284afc) == 0x01) ||
        // 0x00284afd fully covered
        // 0x00284afe
        (prev(bit6(0x00284afe)) == 0x00 && bit6(0x00284afe) == 0x01) ||
        // 0x00284aff
        (prev(bit5(0x00284aff)) == 0x00 && bit5(0x00284aff) == 0x01) || 
        (prev(bit7(0x00284aff)) == 0x00 && bit7(0x00284aff) == 0x01) || 
        // 0x00284b00
        (prev(bit0(0x00284b00)) == 0x00 && bit0(0x00284b00) == 0x01) ||
        (prev(bit1(0x00284b00)) == 0x00 && bit1(0x00284b00) == 0x01) || 
        (prev(bit2(0x00284b00)) == 0x00 && bit2(0x00284b00) == 0x01) || 
        (prev(bit3(0x00284b00)) == 0x00 && bit3(0x00284b00) == 0x01) || 
        (prev(bit4(0x00284b00)) == 0x00 && bit4(0x00284b00) == 0x01) || 
        // 0x00284b01
        (prev(bit0(0x00284b01)) == 0x00 && bit0(0x00284b01) == 0x01) ||
        (prev(bit1(0x00284b01)) == 0x00 && bit1(0x00284b01) == 0x01) ||
        (prev(bit2(0x00284b01)) == 0x00 && bit2(0x00284b01) == 0x01) ||
        (prev(bit3(0x00284b01)) == 0x00 && bit3(0x00284b01) == 0x01) ||
        (prev(bit4(0x00284b01)) == 0x00 && bit4(0x00284b01) == 0x01) ||
        (prev(bit5(0x00284b01)) == 0x00 && bit5(0x00284b01) == 0x01) ||
        (prev(bit6(0x00284b01)) == 0x00 && bit6(0x00284b01) == 0x01) ||
        (prev(bit7(0x00284b01)) == 0x00 && bit7(0x00284b01) == 0x01) ||
        // 0x00284b02
        (prev(bit0(0x00284b02)) == 0x00 && bit0(0x00284b02) == 0x01) ||
        (prev(bit1(0x00284b02)) == 0x00 && bit1(0x00284b02) == 0x01) ||
        (prev(bit2(0x00284b02)) == 0x00 && bit2(0x00284b02) == 0x01) ||
        (prev(bit3(0x00284b02)) == 0x00 && bit3(0x00284b02) == 0x01) ||
        (prev(bit4(0x00284b02)) == 0x00 && bit4(0x00284b02) == 0x01) ||
        (prev(bit5(0x00284b02)) == 0x00 && bit5(0x00284b02) == 0x01) ||
        (prev(bit6(0x00284b02)) == 0x00 && bit6(0x00284b02) == 0x01) ||
        (prev(bit7(0x00284b02)) == 0x00 && bit7(0x00284b02) == 0x01) ||
        // 0x00284b03
        (prev(bit0(0x00284b03)) == 0x00 && bit0(0x00284b03) == 0x01) ||
        (prev(bit1(0x00284b03)) == 0x00 && bit1(0x00284b03) == 0x01) ||
        (prev(bit2(0x00284b03)) == 0x00 && bit2(0x00284b03) == 0x01) ||
        (prev(bit3(0x00284b03)) == 0x00 && bit3(0x00284b03) == 0x01) ||
        (prev(bit5(0x00284b03)) == 0x00 && bit5(0x00284b03) == 0x01) ||
        (prev(bit6(0x00284b03)) == 0x00 && bit6(0x00284b03) == 0x01) ||
        (prev(bit7(0x00284b03)) == 0x00 && bit7(0x00284b03) == 0x01) ||
        // 0x00284b04
        (prev(bit0(0x00284b04)) == 0x00 && bit0(0x00284b04) == 0x01) ||
        (prev(bit1(0x00284b04)) == 0x00 && bit1(0x00284b04) == 0x01) ||
        (prev(bit2(0x00284b04)) == 0x00 && bit2(0x00284b04) == 0x01) ||
        (prev(bit3(0x00284b04)) == 0x00 && bit3(0x00284b04) == 0x01) ||
        (prev(bit4(0x00284b04)) == 0x00 && bit4(0x00284b04) == 0x01) ||
        (prev(bit5(0x00284b04)) == 0x00 && bit5(0x00284b04) == 0x01) ||
        (prev(bit6(0x00284b04)) == 0x00 && bit6(0x00284b04) == 0x01) ||
        (prev(bit7(0x00284b04)) == 0x00 && bit7(0x00284b04) == 0x01) ||
        // 0x00284b05
        (prev(bit0(0x00284b05)) == 0x00 && bit0(0x00284b05) == 0x01) ||
        (prev(bit1(0x00284b05)) == 0x00 && bit1(0x00284b05) == 0x01) ||
        (prev(bit2(0x00284b05)) == 0x00 && bit2(0x00284b05) == 0x01) ||
        (prev(bit3(0x00284b05)) == 0x00 && bit3(0x00284b05) == 0x01) ||
        (prev(bit4(0x00284b05)) == 0x00 && bit4(0x00284b05) == 0x01) ||
        (prev(bit5(0x00284b05)) == 0x00 && bit5(0x00284b05) == 0x01) ||
        (prev(bit6(0x00284b05)) == 0x00 && bit6(0x00284b05) == 0x01) ||
        (prev(bit7(0x00284b05)) == 0x00 && bit7(0x00284b05) == 0x01) ||
        // 0x00284b06
        (prev(bit0(0x00284b06)) == 0x00 && bit0(0x00284b06) == 0x01) ||
        (prev(bit1(0x00284b06)) == 0x00 && bit1(0x00284b06) == 0x01) ||
        (prev(bit2(0x00284b06)) == 0x00 && bit2(0x00284b06) == 0x01) ||
        (prev(bit3(0x00284b06)) == 0x00 && bit3(0x00284b06) == 0x01) ||
        (prev(bit4(0x00284b06)) == 0x00 && bit4(0x00284b06) == 0x01) ||
        (prev(bit5(0x00284b06)) == 0x00 && bit5(0x00284b06) == 0x01) ||
        (prev(bit6(0x00284b06)) == 0x00 && bit6(0x00284b06) == 0x01) ||
        (prev(bit7(0x00284b06)) == 0x00 && bit7(0x00284b06) == 0x01) ||
        // 0x00284b07
        (prev(bit0(0x00284b07)) == 0x00 && bit0(0x00284b07) == 0x01) ||
        (prev(bit1(0x00284b07)) == 0x00 && bit1(0x00284b07) == 0x01) ||
        (prev(bit2(0x00284b07)) == 0x00 && bit2(0x00284b07) == 0x01) ||
        (prev(bit3(0x00284b07)) == 0x00 && bit3(0x00284b07) == 0x01) ||
        (prev(bit4(0x00284b07)) == 0x00 && bit4(0x00284b07) == 0x01) ||
        (prev(bit5(0x00284b07)) == 0x00 && bit5(0x00284b07) == 0x01) ||
        (prev(bit6(0x00284b07)) == 0x00 && bit6(0x00284b07) == 0x01) ||
        (prev(bit7(0x00284b07)) == 0x00 && bit7(0x00284b07) == 0x01) ||
        // 0x00284b08
        (prev(bit0(0x00284b08)) == 0x00 && bit0(0x00284b08) == 0x01) ||
        (prev(bit1(0x00284b08)) == 0x00 && bit1(0x00284b08) == 0x01) ||
        (prev(bit2(0x00284b08)) == 0x00 && bit2(0x00284b08) == 0x01) ||
        (prev(bit3(0x00284b08)) == 0x00 && bit3(0x00284b08) == 0x01) ||
        // 0x00284b09 fully covered
        // 0x00284b0a
        (prev(bit7(0x00284b0a)) == 0x00 && bit7(0x00284b0a) == 0x01) ||
        // 0x00284b0b
        (prev(bit0(0x00284b0b)) == 0x00 && bit0(0x00284b0b) == 0x01) ||
        (prev(bit1(0x00284b0b)) == 0x00 && bit1(0x00284b0b) == 0x01) ||
        (prev(bit2(0x00284b0b)) == 0x00 && bit2(0x00284b0b) == 0x01) ||
        (prev(bit3(0x00284b0b)) == 0x00 && bit3(0x00284b0b) == 0x01) ||
        (prev(bit4(0x00284b0b)) == 0x00 && bit4(0x00284b0b) == 0x01) ||
        (prev(bit5(0x00284b0b)) == 0x00 && bit5(0x00284b0b) == 0x01) ||
        (prev(bit6(0x00284b0b)) == 0x00 && bit6(0x00284b0b) == 0x01) ||
        (prev(bit7(0x00284b0b)) == 0x00 && bit7(0x00284b0b) == 0x01) ||
        // 0x00284b0c
        (prev(bit0(0x00284b0c)) == 0x00 && bit0(0x00284b0c) == 0x01) ||
        (prev(bit1(0x00284b0c)) == 0x00 && bit1(0x00284b0c) == 0x01) ||
        (prev(bit2(0x00284b0c)) == 0x00 && bit2(0x00284b0c) == 0x01) ||
        (prev(bit3(0x00284b0c)) == 0x00 && bit3(0x00284b0c) == 0x01) ||
        (prev(bit4(0x00284b0c)) == 0x00 && bit4(0x00284b0c) == 0x01) ||
        (prev(bit5(0x00284b0c)) == 0x00 && bit5(0x00284b0c) == 0x01) ||
        (prev(bit6(0x00284b0c)) == 0x00 && bit6(0x00284b0c) == 0x01) ||
        (prev(bit7(0x00284b0c)) == 0x00 && bit7(0x00284b0c) == 0x01) ||
        // 0x00284b0d
        (prev(bit0(0x00284b0d)) == 0x00 && bit0(0x00284b0d) == 0x01) ||
        (prev(bit1(0x00284b0d)) == 0x00 && bit1(0x00284b0d) == 0x01) ||
        (prev(bit2(0x00284b0d)) == 0x00 && bit2(0x00284b0d) == 0x01) ||
        (prev(bit3(0x00284b0d)) == 0x00 && bit3(0x00284b0d) == 0x01) ||
        (prev(bit4(0x00284b0d)) == 0x00 && bit4(0x00284b0d) == 0x01) ||
        (prev(bit7(0x00284b0d)) == 0x00 && bit7(0x00284b0d) == 0x01) ||
        // 0x00284b0e
        (prev(bit4(0x00284b0e)) == 0x00 && bit4(0x00284b0e) == 0x01) ||
        (prev(bit5(0x00284b0e)) == 0x00 && bit5(0x00284b0e) == 0x01) ||
        (prev(bit6(0x00284b0e)) == 0x00 && bit6(0x00284b0e) == 0x01) ||
        (prev(bit7(0x00284b0e)) == 0x00 && bit7(0x00284b0e) == 0x01) ||
        // 0x00284b0f
        (prev(bit0(0x00284b0f)) == 0x00 && bit0(0x00284b0f) == 0x01) ||
        (prev(bit1(0x00284b0f)) == 0x00 && bit1(0x00284b0f) == 0x01) ||
        (prev(bit2(0x00284b0f)) == 0x00 && bit2(0x00284b0f) == 0x01) ||
        (prev(bit3(0x00284b0f)) == 0x00 && bit3(0x00284b0f) == 0x01) ||
        (prev(bit4(0x00284b0f)) == 0x00 && bit4(0x00284b0f) == 0x01) ||
        // 0x00284b10
        (prev(bit1(0x00284b10)) == 0x00 && bit1(0x00284b10) == 0x01) ||
        (prev(bit3(0x00284b10)) == 0x00 && bit3(0x00284b10) == 0x01) ||
        (prev(bit5(0x00284b10)) == 0x00 && bit5(0x00284b10) == 0x01) ||
        (prev(bit6(0x00284b10)) == 0x00 && bit6(0x00284b10) == 0x01) ||
        (prev(bit7(0x00284b10)) == 0x00 && bit7(0x00284b10) == 0x01) ||
        // 0x00284b11
        (prev(bit0(0x00284b11)) == 0x00 && bit0(0x00284b11) == 0x01) ||
        (prev(bit1(0x00284b11)) == 0x00 && bit1(0x00284b11) == 0x01) ||
        (prev(bit3(0x00284b11)) == 0x00 && bit3(0x00284b11) == 0x01) ||
        (prev(bit4(0x00284b11)) == 0x00 && bit4(0x00284b11) == 0x01) ||
        (prev(bit5(0x00284b11)) == 0x00 && bit5(0x00284b11) == 0x01) ||
        (prev(bit6(0x00284b11)) == 0x00 && bit6(0x00284b11) == 0x01) ||
        (prev(bit7(0x00284b11)) == 0x00 && bit7(0x00284b11) == 0x01) ||
        // it goes down to here :(
        (prev(bit0(0x00284b12)) == 0x00 && bit0(0x00284b12) == 0x01) ||
        (prev(bit2(0x00284b12)) == 0x00 && bit2(0x00284b12) == 0x01) ||
        (prev(bit3(0x00284b12)) == 0x00 && bit3(0x00284b12) == 0x01) ||
        (prev(bit5(0x00284b12)) == 0x00 && bit5(0x00284b12) == 0x01) ||
        // 0x00284b13 fully covered
        // 0x00284b14
        (prev(bit0(0x00284b14)) == 0x00 && bit0(0x00284b14) == 0x01) ||
        (prev(bit1(0x00284b14)) == 0x00 && bit1(0x00284b14) == 0x01) ||
        (prev(bit2(0x00284b14)) == 0x00 && bit2(0x00284b14) == 0x01) ||
        (prev(bit3(0x00284b14)) == 0x00 && bit3(0x00284b14) == 0x01) ||
        (prev(bit4(0x00284b14)) == 0x00 && bit4(0x00284b14) == 0x01) ||
        (prev(bit5(0x00284b14)) == 0x00 && bit5(0x00284b14) == 0x01) ||
        // 0x00284b15
        (prev(bit1(0x00284b15)) == 0x00 && bit1(0x00284b15) == 0x01) ||
        (prev(bit2(0x00284b15)) == 0x00 && bit2(0x00284b15) == 0x01) ||
        (prev(bit3(0x00284b15)) == 0x00 && bit3(0x00284b15) == 0x01) ||
        (prev(bit5(0x00284b15)) == 0x00 && bit5(0x00284b15) == 0x01) ||
        // 0x00284b16
        (prev(bit5(0x00284b16)) == 0x00 && bit5(0x00284b16) == 0x01) ||
        (prev(bit6(0x00284b16)) == 0x00 && bit6(0x00284b16) == 0x01) ||
        (prev(bit7(0x00284b16)) == 0x00 && bit7(0x00284b16) == 0x01) ||
        // 0x00284b17
        (prev(bit0(0x00284b17)) == 0x00 && bit0(0x00284b17) == 0x01) ||
        (prev(bit1(0x00284b17)) == 0x00 && bit1(0x00284b17) == 0x01) ||
        (prev(bit2(0x00284b17)) == 0x00 && bit2(0x00284b17) == 0x01) ||
        (prev(bit3(0x00284b17)) == 0x00 && bit3(0x00284b17) == 0x01) ||
        (prev(bit4(0x00284b17)) == 0x00 && bit4(0x00284b17) == 0x01) ||
        (prev(bit5(0x00284b17)) == 0x00 && bit5(0x00284b17) == 0x01) ||
        (prev(bit6(0x00284b17)) == 0x00 && bit6(0x00284b17) == 0x01) ||
        (prev(bit7(0x00284b17)) == 0x00 && bit7(0x00284b17) == 0x01) ||
        // 0x00284b18
        (prev(bit0(0x00284b18)) == 0x00 && bit0(0x00284b18) == 0x01) ||
        (prev(bit1(0x00284b18)) == 0x00 && bit1(0x00284b18) == 0x01) ||
        (prev(bit2(0x00284b18)) == 0x00 && bit2(0x00284b18) == 0x01) ||
        (prev(bit3(0x00284b18)) == 0x00 && bit3(0x00284b18) == 0x01) ||
        (prev(bit4(0x00284b18)) == 0x00 && bit4(0x00284b18) == 0x01) ||
        (prev(bit5(0x00284b18)) == 0x00 && bit5(0x00284b18) == 0x01) ||
        (prev(bit6(0x00284b18)) == 0x00 && bit6(0x00284b18) == 0x01) ||
        (prev(bit7(0x00284b18)) == 0x00 && bit7(0x00284b18) == 0x01) ||
        // 0x00284b19
        (prev(bit0(0x00284b19)) == 0x00 && bit0(0x00284b19) == 0x01) ||
        (prev(bit2(0x00284b19)) == 0x00 && bit2(0x00284b19) == 0x01) ||
        (prev(bit4(0x00284b19)) == 0x00 && bit4(0x00284b19) == 0x01) ||
        (prev(bit5(0x00284b19)) == 0x00 && bit5(0x00284b19) == 0x01) ||
        (prev(bit6(0x00284b19)) == 0x00 && bit6(0x00284b19) == 0x01) ||
        // 0x00284b1a
        (prev(bit2(0x00284b1a)) == 0x00 && bit2(0x00284b1a) == 0x01) ||
        (prev(bit3(0x00284b1a)) == 0x00 && bit3(0x00284b1a) == 0x01) ||
        (prev(bit4(0x00284b1a)) == 0x00 && bit4(0x00284b1a) == 0x01) ||
        (prev(bit5(0x00284b1a)) == 0x00 && bit5(0x00284b1a) == 0x01) ||
        (prev(bit6(0x00284b1a)) == 0x00 && bit6(0x00284b1a) == 0x01) ||
        (prev(bit7(0x00284b1a)) == 0x00 && bit7(0x00284b1a) == 0x01) ||
        // 0x00284b1b
        (prev(bit0(0x00284b1b)) == 0x00 && bit0(0x00284b1b) == 0x01) ||
        (prev(bit1(0x00284b1b)) == 0x00 && bit1(0x00284b1b) == 0x01) ||
        (prev(bit2(0x00284b1b)) == 0x00 && bit2(0x00284b1b) == 0x01) ||
        (prev(bit3(0x00284b1b)) == 0x00 && bit3(0x00284b1b) == 0x01) ||
        (prev(bit4(0x00284b1b)) == 0x00 && bit4(0x00284b1b) == 0x01) ||
        (prev(bit5(0x00284b1b)) == 0x00 && bit5(0x00284b1b) == 0x01) ||
        (prev(bit6(0x00284b1b)) == 0x00 && bit6(0x00284b1b) == 0x01) ||
        (prev(bit7(0x00284b1b)) == 0x00 && bit7(0x00284b1b) == 0x01) ||
        // 0x00284b1c
        (prev(bit0(0x00284b1c)) == 0x00 && bit0(0x00284b1c) == 0x01) ||
        (prev(bit1(0x00284b1c)) == 0x00 && bit1(0x00284b1c) == 0x01) ||
        (prev(bit2(0x00284b1c)) == 0x00 && bit2(0x00284b1c) == 0x01) ||
        (prev(bit3(0x00284b1c)) == 0x00 && bit3(0x00284b1c) == 0x01) ||
        (prev(bit4(0x00284b1c)) == 0x00 && bit4(0x00284b1c) == 0x01) ||
        (prev(bit5(0x00284b1c)) == 0x00 && bit5(0x00284b1c) == 0x01) ||
        (prev(bit6(0x00284b1c)) == 0x00 && bit6(0x00284b1c) == 0x01) ||
        (prev(bit7(0x00284b1c)) == 0x00 && bit7(0x00284b1c) == 0x01) ||
        // 0x00284b1d
        (prev(bit0(0x00284b1d)) == 0x00 && bit0(0x00284b1d) == 0x01) ||
        (prev(bit1(0x00284b1d)) == 0x00 && bit1(0x00284b1d) == 0x01) ||
        (prev(bit2(0x00284b1d)) == 0x00 && bit2(0x00284b1d) == 0x01) ||
        (prev(bit3(0x00284b1d)) == 0x00 && bit3(0x00284b1d) == 0x01) ||
        (prev(bit4(0x00284b1d)) == 0x00 && bit4(0x00284b1d) == 0x01) ||
        (prev(bit5(0x00284b1d)) == 0x00 && bit5(0x00284b1d) == 0x01) ||
        (prev(bit6(0x00284b1d)) == 0x00 && bit6(0x00284b1d) == 0x01) ||
        (prev(bit7(0x00284b1d)) == 0x00 && bit7(0x00284b1d) == 0x01) ||
        // 0x00284b1e
        (prev(bit0(0x00284b1e)) == 0x00 && bit0(0x00284b1e) == 0x01) ||
        (prev(bit1(0x00284b1e)) == 0x00 && bit1(0x00284b1e) == 0x01) ||
        (prev(bit2(0x00284b1e)) == 0x00 && bit2(0x00284b1e) == 0x01) ||
        (prev(bit3(0x00284b1e)) == 0x00 && bit3(0x00284b1e) == 0x01) ||
        (prev(bit4(0x00284b1e)) == 0x00 && bit4(0x00284b1e) == 0x01) ||
        (prev(bit5(0x00284b1e)) == 0x00 && bit5(0x00284b1e) == 0x01) ||
        // 0x00284b1f
        (prev(bit0(0x00284b1f)) == 0x00 && bit0(0x00284b1f) == 0x01) ||
        (prev(bit1(0x00284b1f)) == 0x00 && bit1(0x00284b1f) == 0x01) ||
        (prev(bit2(0x00284b1f)) == 0x00 && bit2(0x00284b1f) == 0x01) ||
        (prev(bit3(0x00284b1f)) == 0x00 && bit3(0x00284b1f) == 0x01) ||
        (prev(bit5(0x00284b1f)) == 0x00 && bit5(0x00284b1f) == 0x01) ||
        (prev(bit6(0x00284b1f)) == 0x00 && bit6(0x00284b1f) == 0x01) ||
        (prev(bit7(0x00284b1f)) == 0x00 && bit7(0x00284b1f) == 0x01) ||
        // 0x00284b20
        (prev(bit0(0x00284b20)) == 0x00 && bit0(0x00284b20) == 0x01) ||
        (prev(bit1(0x00284b20)) == 0x00 && bit1(0x00284b20) == 0x01) ||
        (prev(bit2(0x00284b20)) == 0x00 && bit2(0x00284b20) == 0x01) ||
        (prev(bit5(0x00284b20)) == 0x00 && bit5(0x00284b20) == 0x01) ||
        (prev(bit7(0x00284b20)) == 0x00 && bit7(0x00284b20) == 0x01) ||
        // noooooooooooooooooooo it goes even further down here too!!
        // 0x00284b21
        (prev(bit0(0x00284b21)) == 0x00 && bit0(0x00284b21) == 0x01) ||
        (prev(bit1(0x00284b21)) == 0x00 && bit1(0x00284b21) == 0x01) ||
        (prev(bit2(0x00284b21)) == 0x00 && bit2(0x00284b21) == 0x01) ||
        (prev(bit3(0x00284b21)) == 0x00 && bit3(0x00284b21) == 0x01) ||
        (prev(bit4(0x00284b21)) == 0x00 && bit3(0x00284b21) == 0x01) ||
        (prev(bit5(0x00284b21)) == 0x00 && bit5(0x00284b21) == 0x01) ||
        (prev(bit6(0x00284b21)) == 0x00 && bit6(0x00284b21) == 0x01) ||
        (prev(bit7(0x00284b21)) == 0x00 && bit7(0x00284b21) == 0x01) ||
        // 0x00284b22
        (prev(bit0(0x00284b22)) == 0x00 && bit0(0x00284b22) == 0x01) ||
        (prev(bit1(0x00284b22)) == 0x00 && bit1(0x00284b22) == 0x01) ||
        (prev(bit2(0x00284b22)) == 0x00 && bit2(0x00284b22) == 0x01) ||
        (prev(bit3(0x00284b22)) == 0x00 && bit3(0x00284b22) == 0x01) ||
        (prev(bit4(0x00284b22)) == 0x00 && bit3(0x00284b22) == 0x01) ||
        (prev(bit5(0x00284b22)) == 0x00 && bit5(0x00284b22) == 0x01) ||
        (prev(bit6(0x00284b22)) == 0x00 && bit6(0x00284b22) == 0x01) ||
        (prev(bit7(0x00284b22)) == 0x00 && bit7(0x00284b22) == 0x01) ||
        // 0x00284b23
        (prev(bit0(0x00284b23)) == 0x00 && bit0(0x00284b23) == 0x01) ||
        (prev(bit1(0x00284b23)) == 0x00 && bit1(0x00284b23) == 0x01) ||
        (prev(bit2(0x00284b23)) == 0x00 && bit2(0x00284b23) == 0x01) ||
        (prev(bit3(0x00284b23)) == 0x00 && bit3(0x00284b23) == 0x01) ||
        (prev(bit4(0x00284b23)) == 0x00 && bit3(0x00284b23) == 0x01) ||
        (prev(bit5(0x00284b23)) == 0x00 && bit5(0x00284b23) == 0x01) ||
        (prev(bit6(0x00284b23)) == 0x00 && bit6(0x00284b23) == 0x01) ||
        (prev(bit7(0x00284b23)) == 0x00 && bit7(0x00284b23) == 0x01) ||
        // 0x00284b24
        (prev(bit0(0x00284b24)) == 0x00 && bit0(0x00284b24) == 0x01) ||
        (prev(bit1(0x00284b24)) == 0x00 && bit1(0x00284b24) == 0x01) ||
        (prev(bit2(0x00284b24)) == 0x00 && bit2(0x00284b24) == 0x01) ||
        (prev(bit3(0x00284b24)) == 0x00 && bit3(0x00284b24) == 0x01) ||
        (prev(bit4(0x00284b24)) == 0x00 && bit3(0x00284b24) == 0x01) ||
        (prev(bit5(0x00284b24)) == 0x00 && bit5(0x00284b24) == 0x01) ||
        (prev(bit6(0x00284b24)) == 0x00 && bit6(0x00284b24) == 0x01) ||
        (prev(bit7(0x00284b24)) == 0x00 && bit7(0x00284b24) == 0x01) ||
        // 0x00284b25
        (prev(bit0(0x00284b25)) == 0x00 && bit0(0x00284b25) == 0x01) ||
        (prev(bit1(0x00284b25)) == 0x00 && bit1(0x00284b25) == 0x01) ||
        (prev(bit2(0x00284b25)) == 0x00 && bit2(0x00284b25) == 0x01) ||
        (prev(bit3(0x00284b25)) == 0x00 && bit3(0x00284b25) == 0x01) ||
        (prev(bit4(0x00284b25)) == 0x00 && bit3(0x00284b25) == 0x01) ||
        (prev(bit5(0x00284b25)) == 0x00 && bit5(0x00284b25) == 0x01) ||
        (prev(bit6(0x00284b25)) == 0x00 && bit6(0x00284b25) == 0x01) ||
        (prev(bit7(0x00284b25)) == 0x00 && bit7(0x00284b25) == 0x01) ||
        // 0x00284b26
        (prev(bit0(0x00284b26)) == 0x00 && bit0(0x00284b26) == 0x01) ||
        (prev(bit1(0x00284b26)) == 0x00 && bit1(0x00284b26) == 0x01) ||
        (prev(bit2(0x00284b26)) == 0x00 && bit2(0x00284b26) == 0x01) ||
        (prev(bit3(0x00284b26)) == 0x00 && bit3(0x00284b26) == 0x01) ||
        (prev(bit4(0x00284b26)) == 0x00 && bit3(0x00284b26) == 0x01) ||
        (prev(bit5(0x00284b26)) == 0x00 && bit5(0x00284b26) == 0x01) ||
        (prev(bit6(0x00284b26)) == 0x00 && bit6(0x00284b26) == 0x01) ||
        (prev(bit7(0x00284b26)) == 0x00 && bit7(0x00284b26) == 0x01) ||
        // 0x00284b27
        (prev(bit1(0x00284b27)) == 0x00 && bit1(0x00284b27) == 0x01) ||
        (prev(bit2(0x00284b27)) == 0x00 && bit2(0x00284b27) == 0x01) ||
        (prev(bit3(0x00284b27)) == 0x00 && bit3(0x00284b27) == 0x01) ||
        (prev(bit4(0x00284b27)) == 0x00 && bit3(0x00284b27) == 0x01) ||
        (prev(bit5(0x00284b27)) == 0x00 && bit5(0x00284b27) == 0x01) ||
        (prev(bit6(0x00284b27)) == 0x00 && bit6(0x00284b27) == 0x01) ||
        (prev(bit7(0x00284b27)) == 0x00 && bit7(0x00284b27) == 0x01)
    )
)

// *** Achievements ***

// Progression

achievement(
    title = "False Alarm",
    description = "Avert the crisis shown in your death clip.",
    points = 1,
    trigger =  DAY == 0x01 && on_mission("Death Clip") && all_allied_teams_last_standing(3),
    type = "progression",
    id=530957
)
achievement(
    title = "Just Needed Moral Support",
    description = "Have Daichi's team land the killing blow on Bai Suzhen in Daichi's Crisis.",
    points = 5,
    trigger = on_mission("Daichi's Crisis")
        && (
            (attacker_leader_is("Daichi") && defender_leader_is("Bai Suzhen") && defender_leader_defeated()) || 
            (defender_leader_is("Daichi") && attacker_leader_is("Bai Suzhen") && attacker_leader_defeated())
        ),
    type = "missable",
    id=530986
)
achievement(
    title = "She's Sealed Away for a Reason",
    description = "Avert the crisis shown in the second death clip on Sunday.",
    points = 1,
    trigger = on_mission("Daichi's Crisis") && active_mission_completed("Daichi's Crisis"),
    type = "progression",
    id=530958
)
achievement(
    title = "Taking on Troublesome Contracts",
    description = "Help Joe resolve his outstanding contract.",
    points = 2,
    trigger = on_mission("A Man Named Joe") && active_mission_completed("A Man Named Joe"),
    type = "progression",
    id=530959
)
achievement(
    title = "Alpha Ursae Majoris",
    description = "Get all allies to the escape area in Daichi's Worth without Dubhe killing any demons and without using the Suspend feature.",
    points = 5,
    trigger = never(MOST_RECENT_MISSION != 0x3f4)
        && ptr_valid(FULL_TEAM_ARRAY_PTR)
        && bit3(0x00284aec) == 0x01
        && trigger_when(prev(word(TEAM_ARRAY_PTR + (0x27c * 0x04) + 0x0a)) == 0x114 && word(TEAM_ARRAY_PTR + (0x27c * 0x04) + 0x0a) == 0x115)
        && (
            disable_when(attacker_leader_is("Dubhe (Whole)") && defender_left_unit_defeated())
        && disable_when(attacker_leader_is("Dubhe (Whole)") && defender_right_unit_defeated())
        && disable_when(defender_leader_is("Dubhe (Whole)") && attacker_left_unit_defeated())
        && disable_when(defender_leader_is("Dubhe (Whole)") && attacker_right_unit_defeated())
        )
        // This may not be technically necessary, but it makes me feel better!
        // I'm observing that the game does not use a separate pointer to access teams when the game loads from suspend in this mission
        // which means that the validity check for the FULL_TEAM_ARRAY_PTR is actually doing work
        && disable_when(loaded_from_suspend(), until=MOST_RECENT_MISSION != 0x3f4),
    type = "missable",
    id=530960
)
achievement(
    title = "Dubious Dubhe",
    description = "Defeat Dubhe.",
    points = 5,
    trigger = on_mission("Daichi's Resolve")
        && ((attacker_leader_is("Dubhe (Half)") && attacker_leader_defeated()) || defender_leader_is("Dubhe (Half)") && defender_leader_defeated()),
    type = "progression",
    id=530961
)
achievement(
    title = "I Take My Volunteer Work Seriously",
    description = "Without using the Suspend feature, defeat all human enemies in App Abuser before any have a chance to escape.",
    points = 3,
    trigger = never(MOST_RECENT_MISSION != 0x7d4)
        && on_mission("App Abuser")
        && on_grid_map()
        && never(loaded_from_suspend())
        && trigger_when(once(defender_leader_is("Punk") && defender_leader_defeated())) 
        && trigger_when(once(defender_leader_is("Salaryman") && defender_leader_defeated()))
        && trigger_when(once(defender_leader_is("Young Man") && defender_leader_defeated()))
        && disable_when(team_moves_to_x(0x04, 0x0e), until=MOST_RECENT_MISSION != 0x7d4)
        && disable_when(team_moves_to_x(0x05, 0x0e), until=MOST_RECENT_MISSION != 0x7d4)
        && disable_when(team_moves_to_x(0x06, 0x0e), until=MOST_RECENT_MISSION != 0x7d4),
    type = "missable",
    id = 546726
)
achievement(
    title = "Busting the 'valgate Party",
    description = "Complete 'Demon-Hacked'.",
    points = 5,
    trigger = on_mission("Demon-Hacked") 
        && in_combat() 
        && active_mission_completed("Demon-Hacked"),
    type = "progression",
    id = 546725
)
achievement(
    title = "I Hate Escorting People",
    description = "In 'Never Say Die', defeat all enemy demons with the civilians at full HP.",
    points = 3,
    trigger = on_mission("Never Say Die") 
        && team_leader_hp_full(0x0a) 
        && team_leader_hp_full(0x0b)
        && trigger_when(active_mission_completed("Never Say Die")),
    type = "missable",
    id = 546542
)
achievement(
    title = "Take Me to the Men in Yellow",
    description = "Recruit Hinako to the party.",
    points = 3,
    trigger = on_mission("Never Say Die") && character_recruited("Hinako"),
    type = "progression",
    id=530962
)
// likely cutting this, but still mulling it over
// if we keep it, allow mission that isn't Osaka Soul
achievement(
    title = "Miasma Maestro",
    description = "Clear all of the miasma in 'Osaka Soul' before any additional enemy teams are summoned and complete the mission without using the Suspend feature.",
    points = 5,
    trigger = on_mission("Osaka Soul") 
        && never(loaded_from_suspend())
        && disable_when(unit_respawns(), until=MOST_RECENT_MISSION != event_id_by_name["Osaka Soul"])
        && trigger_when(bit0(0x00284b5a) == 0x01)
        && trigger_when(bit1(0x00284b5a) == 0x01)
        && trigger_when(bit2(0x00284b5a) == 0x01)
        && trigger_when(bit3(0x00284b59) == 0x01)
        && trigger_when(active_mission_completed("Osaka Soul")),
    type = "missable"
)
achievement(
    title = "Savior of the Angry",
    description = "Prevent the death foretold by Monday's death clip.",
    points = 3,
    trigger = bit1(0x00284aee) == 0x01 && on_mission("Osaka Soul") && character_alive("Keita") && character_recruited("Keita"),
    type = "missable",
    id=530963
)
achievement(
    title = "Beta Ursae Majoris",
    description = "Defeat Merak without it ever using Circumpolarity and without using the Suspend feature.",
    points = 5,
    trigger = on_grid_map() && on_mission("Merak Arrives") 
            && ptr_valid(FULL_TEAM_ARRAY_PTR)
            && never(loaded_from_suspend())
            && trigger_when((attacker_leader_is("Merak") && attacker_leader_defeated()) 
            || defender_leader_is("Merak") && defender_leader_defeated())
            && disable_when(prev(byte(TEAM_ARRAY_PTR + 0xc3b)) == 0x00 && byte(TEAM_ARRAY_PTR + 0xc3b) == 0x0a, until=MOST_RECENT_MISSION != 0x7e2),
    type = "missable",
    id=530964
)
achievement(
    title = "Meticulous Merak",
    description = "Defeat Merak.",
    points = 5,
    trigger = on_mission("Merak Arrives")  
        && ((attacker_leader_is("Merak") && attacker_leader_defeated()) || defender_leader_is("Merak") && defender_leader_defeated()),
    type = "progression",
    id=530965
)
achievement(
    title = "A Fun-Filled Q...!",
    description = "Defeat Ghost Q.",
    points = 10,
    trigger = DAY == 0x03 && on_mission("Vs. Q")
        && ((defender_leader_is("Ghost Q") && defender_leader_defeated()) || (attacker_leader_is("Ghost Q") && attacker_leader_defeated())),
    type = "missable",
    id=530966
)
achievement(
    title = "Hot-Headed Redhead",
    description = "Recruit Airi to the party.",
    points = 2,
    trigger = bit4(0x00284af2) == 0x01 && bit5(0x00284af2) == 0x01
        && (MOST_RECENT_MISSION == event_id_by_name["Girl in Pursuit"] || MOST_RECENT_MISSION == event_id_by_name["Boy in Combat"])
        && prev(actively_in_event()) && !actively_in_event(),
    type = "progression",
    id=530967
)
achievement(
    title = "Second Time's the Charm",
    description = "Defeat Botis in 'Hacker Revealed.'",
    points = 5,
    trigger = on_mission("Hacker Revealed") &&
        ((defender_leader_is("Botis") && defender_leader_defeated()) || (attacker_leader_is("Botis") && attacker_leader_defeated())),
    type = "missable",
    id=530968
)
achievement(
    title = "Hmm... Mm?",
    description = "Complete 'Hacker Revealed.'",
    points = 3,
    trigger = on_mission("Hacker Revealed") && active_mission_completed("Hacker Revealed"),
    type = "progression",
    id=530969
)
achievement(
    title = "Solid Snake Would Be Proud",
    description = "Escort Daichi to the rescue point in Saving Daichi.",
    points = 5,
    trigger = on_mission("Saving Daichi") && bit4(0x00284b1f) == 0x01 
        && trigger_when(prev(bit5(0x00284b56)) == 0x00) 
        && trigger_when(bit5(0x00284b56) == 0x01),
    type = "missable",
    id=530970
)
achievement(
    title = "Savior of the Strong",
    description = "Prevent the death foretold by Tuesday's death clip.",
    points = 5,
    trigger = bit2(0x00284af1) == 0x01 && on_mission("Saving Daichi") && character_alive("Jungo") && character_recruited("Jungo"),
    type = "missable",
    id=530971
)
achievement(
    title = "Brutal Efficiency",
    description = "In 'Man of Fury,' defeat Ronaldo while all other teams are still on the map.",
    points = 5,
    // Loose high level idea here:
    // Normally I would detect when HP hits 0, but HP actually hits 1 here
    // Instead of going through and adding that edge case, we'll rely on combat flags flipping while all other teams are up
    trigger = on_mission("Man of Fury") && num_teams_on_map(0x0a) &&
        in_combat_mission("Man of Fury (Ronaldo)") &&
        // The underlying pointers here continue pointing to the associated defender/attacker until next combat is entered, so this is fine
        trigger_when((defender_leader_is("Ronaldo") || attacker_leader_is("Ronaldo"))) &&
        trigger_when(prev(bit6(0x00284b59) == 0x00)) && trigger_when(bit6(0x00284b59) == 0x01) &&
        trigger_when(prev(bit7(0x00284b59) == 0x00)) && trigger_when(bit7(0x00284b59) == 0x01),
    type = "missable"
)
achievement(
    title = "Gamma Ursae Majoris",
    description = "Defeat Phecda without using the Suspend feature.",
    points = 10,
    trigger = never(loaded_from_suspend()) && on_mission("Man of Fury") &&
        // Phys already defeated, Magic being defeated
        ((
            bit0(0x00284b56) == 0x01 
            && (attacker_leader_is("Phecda (Magic)") || defender_leader_is ("Phecda (Magic)")) 
            && prev(bit6(0x00284b55) == 0x00) 
            && bit6(0x00284b55) == 0x01
        ) ||
        // Magic already defeated, Phys being defeated
        (
            bit6(0x00284b55) == 0x01 
            && (attacker_leader_is("Phecda (Phys)") || defender_leader_is("Phecda (Phys)")) 
            && prev(bit0(0x00284b56)) == 0x00 
            && bit0(0x00284b56) == 0x01
        )),
    type = "missable",
    id = 547112
)
achievement(
    title = "Partitioned Phecda",
    description = "Defeat Phecda.",
    points = 5,
    trigger = on_mission("Man of Fury") &&
        // Phys already defeated, Magic being defeated
        ((
            bit0(0x00284b56) == 0x01 
            && (attacker_leader_is("Phecda (Magic)") || defender_leader_is ("Phecda (Magic)")) 
            && prev(bit6(0x00284b55) == 0x00) 
            && bit6(0x00284b55) == 0x01
        ) ||
        // Magic already defeated, Phys being defeated
        (
            bit6(0x00284b55) == 0x01 
            && (attacker_leader_is("Phecda (Phys)") || defender_leader_is("Phecda (Phys)")) 
            && prev(bit0(0x00284b56)) == 0x00 
            && bit0(0x00284b56) == 0x01
        )),
    // This will actually need a pair of clauses
    // There's multiple Phecda forms and you can defeat one or the other
    // This will also need to make sure that regardless of session, both Phecdas are defeated
    type = "progression",
    id=530972
)
// Megrez missions: Have only the team leader on any team get hit when Megrez's Bud uses its Diastrophism skill.
achievement(
    title = "If Only People Could Float",
    description = "When Megrez Bud uses Diastrophism, have only the team leader be damaged on any team.",
    points = 5,
    trigger = DAY == 0x04
        && actively_in_event()
        && (MOST_RECENT_MISSION == event_id_by_name["Bud of Malice"])
        && ptr_valid(FULL_COMBAT_PTR) 
        && byte(COMBAT_PTR + 0xc61) == 0x40
        && (
                // team 0
                (
                    word(COMBAT_PTR + 0x284) > 0 
                    && prev(word(COMBAT_PTR + 0x284)) > word(COMBAT_PTR + 0x284) 
                    && prev(word(COMBAT_PTR + 0x328)) == word(COMBAT_PTR + 0x328) 
                    && prev(word(COMBAT_PTR + 0x3c8)) == word(COMBAT_PTR + 0x3c8)
                ) ||
                // team 1
                (
                    word(COMBAT_PTR + 0x500) > 0 
                    && prev(word(COMBAT_PTR + 0x500)) > word(COMBAT_PTR + 0x500) 
                    && prev(word(COMBAT_PTR + 0x5a4)) == word(COMBAT_PTR + 0x5a4) 
                    && prev(word(COMBAT_PTR + 0x646)) == word(COMBAT_PTR + 0x646)
                ) ||
                // team 2
                (
                    word(COMBAT_PTR + 0x77c) > 0 
                    && prev(word(COMBAT_PTR + 0x77c)) > word(COMBAT_PTR + 0x77c) 
                    && prev(word(COMBAT_PTR + 0x820)) == word(COMBAT_PTR + 0x820) 
                    && prev(word(COMBAT_PTR + 0x8c4)) == word(COMBAT_PTR + 0x8c4)
                ) ||
                // team 3
                (
                    word(COMBAT_PTR + 0x9f8) > 0 
                    && prev(word(COMBAT_PTR + 0x9f8)) > word(COMBAT_PTR + 0x9f8) 
                    && prev(word(COMBAT_PTR + 0xa9c)) == word(COMBAT_PTR + 0xa9c) 
                    && prev(word(COMBAT_PTR + 0xb4a)) == word(COMBAT_PTR + 0xb4a)
                )
            ),
    type = "missable"
)
achievement(
    title = "Truly a Hard Choice",
    description = "Defeat Neko Shogun in A Hard Choice",
    points = 5,
    trigger = on_mission("A Hard Choice") && ((attacker_leader_is("Neko Shogun") && attacker_leader_defeated()) || (defender_leader_is("Neko Shogun") && defender_leader_defeated())),
    type = "missable",
    id=546531
)
achievement(
    title="Can I Go to Timor With This?",
    description="Unlock the ability to use the Terminal.",
    points = 1,
    trigger = MOST_RECENT_MISSION == event_id_by_name["Megrez Meeting"] && prev(actively_in_event()) && !(actively_in_event()),
    type = "progression",
    id=546532
)
// if the set still feels "light" there are more forced missions you can acknowledge between these two points
achievement(
    title = "Savior of the Aloof",
    description = "Prevent the death foretold by Wednesday's death clip.",
    points = 5,
    trigger = MOST_RECENT_MISSION == 0xfb0 && character_alive("Joe") && character_recruited("Joe"),
    type = "missable",
    id=546535
)
achievement(
    title = "Delta Ursae Majoris",
    description = "Win the Delta Battle mission without clearing any of the miasma.",
    points = 5,
    trigger = on_mission("Delta Battle")
        && ptr_valid(FULL_COMBAT_PTR)
        && bit1(0x00284b58) == 0x00
        && bit2(0x00284b58) == 0x00
        && bit3(0x00284b58) == 0x00
        && bit4(0x00284b58) == 0x00
        && trigger_when((attacker_leader_is("Megrez") && attacker_leader_defeated()) || (defender_leader_is("Megrez") && defender_leader_defeated())),
    type = "missable"
)
achievement(
    title = "Marooned Megrez",
    description = "Defeat Megrez.",
    points = 10,
    trigger = on_mission("Delta Battle") && ((attacker_leader_is("Megrez") && attacker_leader_defeated()) || (defender_leader_is("Megrez") && defender_leader_defeated())),
    type = "progression",
    id = 546547
)
// ** Thursday Missions **
achievement(
    title = "It's Showtime",
    description = "Complete the 'Poisonous Day' mission and unlock Hitokotonusi.",
    points = 5,
    trigger = on_mission("Poisonous Day") && mail_triggered("Re: Hitokotonusi"),
    type = "progression",
    id = 546543
)
// To reproduce: Hinako, then Airi. Airi's FATE stage goes up by 1 as well when you successfully do this
achievement(
    title = "Recreating the Legend of Pasaputa",
    description = "Successfully recruit two of your teammates to help recreate the legend of Pasaputa before JPs reconvenes.",
    points = 1,
    trigger = DAY == 0x05 && bit0(0x00284af9) == 0x01 && bit1(0x00284af9) == 0x01 && bit4(0x00284b12) == 0x01 && prev(IN_GAME_CLOCK) == 0x276 && IN_GAME_CLOCK == 0x294, 
    type= "missable",
    id = 546546
)
// Ananga Mission: win with Airi as an active and alive team
// kama reduces to 1hp in this mission as the win
achievement(
    title ="I'm Bringing Sexy Ban",
    description = "Complete the 'Ananga' mission with Airi as an active and alive team leader.",
    points = 3,
    trigger = DAY == 0x09,
    type = "missable"
)
achievement(
    title = "Shiva Demands Perfect Health",
    description = "Complete the '' mission with Hinako having never been damaged during her dance.",
    points = 5,
    trigger = DAY == 0x09,
    type = "missable"
)
achievement(
    title = "(Bifrons Actually Required)",
    description = "Defeat Bifrons in either of 'Unexpected Hostility' or 'Victim of Foul Play'.",
    points = 10,
    trigger = (on_mission("Unexpected Hostility") || on_mission("Victim of Foul Play")) &&
        (attacker_leader_is("Bifrons") || defender_leader_is("Bifrons")) && 
        prev(bit4(0x00284b15)) == 0x00 && bit4(0x00284b15) == 0x01,
    type = "missable",
    id = 546544
)
achievement(
    title = "The Savior's Savior",
    description = "Prevent the death shown by Thursday's death clip.",
    points = 5,
    trigger = bit1(0x00284afa) == 0x01 && on_mission("Unexpected Hostility") && character_alive("Otome") && character_recruited("Otome"),
    type = "missable",
    id = 546545
)
// A White Lie for A Nation: Witness the conclusion of Kama and Shiva's legend. just a one pointer to throw the player an extra point, but it's kind of bloat

achievement(
    title = "Epsilon Ursae Majoris",
    description = "Defeat Alioth without usage of the neutralizing agent.",
    // in consideration: 25 pointer, if set is underscored by end of dev
    points = 10,
    trigger = on_mission("Alioth Core") 
        && bit2(0x00284b58) != 0x01 
        && trigger_when((attacker_leader_is("Alioth Core") && attacker_leader_defeated()) || defender_leader_is("Alioth Core") && defender_leader_defeated()),
    type = "missable",
    id = 547508
)
achievement(
    title = "Antagonizing Alioth",
    description = "Defeat Alioth Core.",
    points = 10,
    trigger = on_mission("Alioth Core") && ((attacker_leader_is("Alioth Core") && attacker_leader_defeated()) || defender_leader_is("Alioth Core") && defender_leader_defeated()),
    type = "progression",
    id = 546585
)
// under consideration still
// achievement(
//     title = "Will of the Species",
//     description = "Discover what Polaris is and what needs to be done to meet him.",
//     points = 1,
//     trigger = DAY == 0x09,
//     type = "progression"
// )

achievement(
    title = "Let's See Those Wallets",
    description = "Complete the 'God of Luck' mission and receive mail about Bilikin afterward.",
    points = 10,
    trigger = MOST_RECENT_MISSION == event_id_by_name["God of Luck"] && mail_triggered("Re: Bilikin"), //byte(0x00284cba) != 0xff && prev(bit7(0x00284cba)) == 0x01 && bit7(0x00284cba) == 0x00,
    type = "missable",
    id = 546680
)
achievement(
    title = "Chilly Crater Combat",
    description = "Complete the 'Barrier Failure' mission and witness the ensuing events.",
    points = 5,
    trigger = on_mission("Barrier Failure") && prev(bit5(0x00284b00)) == 0x00 && bit5(0x00284b00) == 0x01,
    type = "progression",
    id = 547006
)

// Lamhfhada: Win; potential points if set is underscored

achievement(
    title = "Trial of The Dragon",
    description = "Call forth the Dragon Stream using Lugh's power.",
    points = 5,
    trigger = on_mission("The Dragon") && character_alive("Io") && character_recruited("Io"),
    type = "progression",
    id = 547042
)
achievement(
    title = "Zeta Ursae Majoris",
    description = "Defeat Mizar without using the 'Suspend' feature.",
    points = 10,
    trigger = on_mission("Food Chain") 
        && once(((defender_leader_is("Mizar Tentacle (3R)") && defender_leader_defeated()) || (attacker_leader_is("Mizar Tentacle (3R)") && attacker_leader_defeated())))
        && once(((defender_leader_is("Mizar Tentacle (3L)") && defender_leader_defeated()) || (attacker_leader_is("Mizar Tentacle (3L)") && attacker_leader_defeated())))
        && never(!on_mission("Food Chain")),
    type = "missable"
)
achievement(
    title = "Mizar (No Longer) Multiply",
    description = "Defeat Mizar.",
    points = 10,
    trigger = on_mission("Food Chain") &&
        bit1(0x00284b55) == 0x01 &&
        bit2(0x00284b55) == 0x01 &&
        bit3(0x00284b55) == 0x01 &&
        bit4(0x00284b55) == 0x01 &&
        (bit4(0x00284b54) == 0x01 && ((defender_leader_is("Mizar Tentacle (3R)") && defender_leader_defeated()) || (attacker_leader_is("Mizar Tentacle (3R)") && attacker_leader_defeated())) ||
         bit3(0x00284b54) == 0x01 && ((defender_leader_is("Mizar Tentacle (3L)") && defender_leader_defeated()) || (attacker_leader_is("Mizar Tentacle (3L)") && attacker_leader_defeated()))
        ),
    type = "progression",
    id = 547043
)
achievement(
    title = "Savior of the Loyal",
    description = "Avert the crisis shown in Friday's death clip.",
    points = 5,
    trigger = on_mission("Ronaldo Rises") && character_alive("Makoto") && character_recruited("Makoto"),
    type = "missable",
    id = 547045
)
achievement(
    title = "Dera-Deka's Tale",
    description = "Witness all of the events surrounding the Mystery Man.",
    points = 25,
    trigger = measured(
        // Events measured, in order, are:
        // Mystery Man
        // The Victim
        // A Family
        // Identity
        // Dera-Deka
        // The Promise (17:00 - 18:00 Friday)
        bit2(0x00284b13) + bit3(0x00284b13) + bit4(0x00284b13) + bit5(0x00284b13) + bit6(0x00284b13) + bit7(0x00284b13) == 0x06, 
        when=always_true(), 
        format="raw"
    ) && MOST_RECENT_MISSION == event_id_by_name["The Promise"] && mail_triggered("Re: Jikoku"),
    type = "missable"
)
// ** Shared Saturday Missions **
achievement(
    title = "The Destroyer",
    description = "Defeat Shiva in Vs. Tokyo.",
    points = 10,
    trigger = on_mission("Vs. Tokyo") && ((attacker_leader_is("Shiva") && attacker_leader_defeated()) || (defender_leader_is("Shiva") && defender_leader_defeated())),
    type = "missable",
    id = 547044
)
// Benetsnach 1: Complete 'Unknown Threat.'
achievement(
    title = ""
)
// Persuade Trumpeter
achievement(
    title = "Percussive Persuasion",
    description = "Have Trumpeter agree to aid you in the battle against Benetsnach."
)
achievement(
    title = "The Last of the Seven",
    description = "Defeat Benetsnach.",
    points = 25,
    trigger = on_mission("Seven Down") && mail_triggered("Re: Trumpeter"),
    type = "progression"
)
achievement(
    title = "Eta Ursae Majoris",
    description = "Defeat Benetsnach without using the Suspend feature and without Trumpeter being hurt.",
    points = 25,
    trigger = on_mission("Seven Down")
        // pseudologic: 
        // - enemy slot where Trumpeter is, is actually Trumpeter && never curr_hp < max_hp
        // - main Benetsnach defeated
        // - each child Benetsnach defeated
        && once(
        
        ),
    type = "missable"
)
achievement(
    title = "Dragon Tamer",
    description = "Defeat the Dragon.",
    points = 5,
    trigger = on_mission("Reared Head") && ((attacker_leader_is("Dragon") && attacker_leader_defeated()) || (defender_leader_is("Dragon") && defender_leader_defeated())),
    type = "progression"
)
achievement(
    title = "Alpha Ursae Minoris",
    description = "Defeat Polaris without using the Suspend feature.",
    points = 25,
    trigger = on_mission("New Tomorrow")
        && !loaded_from_suspend()
        && (
            (defender_leader_is("Polaris A") && defender_leader_defeated()) 
            || (attacker_leader_is("Polaris A") && attacker_leader_defeated())
        )    
)
achievement(
    title = "At Trial's End",
    description = "Defeat Polaris.",
    points = 25,
    trigger = on_mission("New Tomorrow") 
        && (
            (defender_leader_is("Polaris A") && defender_leader_defeated()) 
            || (attacker_leader_is("Polaris A") && attacker_leader_defeated())
        ),
    type = "win_condition"
)

// ** Daichi's Way **
// ** A New World **
achievement(
    title = "The World vs. Team Tokyo",
    description = "Defeat Team Tokyo as Al Saiduq's team."
)
achievement(
    title = "The World vs. Team Osaka",
    description = "Defeat Team Osaka as Al Saiduq's team.",
    points = 5,
    trigger = ending_selected("Anguished One") && DAY == 0x09
)
achievement(
    title = "The World vs. Team Nagoya",
    description = "Defeat Team Nagoya as Al Saiduq's team.",
    points = 5,
    trigger = ending_selected("Anguished One") && DAY == 0x09
)
achievement(
    title = "Dream's End",
    description = "Defeat Ronaldo as Al Saiduq's team",
    trigger = on_mission("Dream's End")
    // the trigger here will be ronaldo dying of his own volition
        && ending_selected("Anguished One")
        && prev(bit1(0x00284dc2)) == 0x00
        && bit1(0x00284dc2) == 0x01,
    points = 5
)
achievement(
    title = "Loose Ends",
    description = "Defeat Yamato as Al Saiduq's team.",
    points = 5,
    trigger = on_mission("Strong Breaker")
        && ending_selected("Anguished One")
        && prev(bit1(0x00284de2)) == 0x00
        && bit1(0x00284de2) == 0x01
)
achievement(
    title = "Starting Fresh",
    description = "Defeat Polaris and establish your new world order.",
    points = 25,
    trigger = on_mission("New Tomorrow")
        && ending_selected("Anguished One")
        && ((defender_leader_is("Polaris (Complete)") && defender_leader_defeated()) || (attacker_leader_is("Polaris (Complete)") && attacker_leader_defeated())),
)
// ** Yamato's Way **
// ** Ronaldo's Way **
// Settling Things: use Lugh mail as indicator
achievement(
    title = ""
)

achievement(
    title = ""
)

// no Free Battle progression
achievement(
    title = "Sunday's Melancholy",
    description = "Reach the end of Day 1 without ever entering any Free Battle on a New Game file.",
    points = 5,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && IN_GAME_CLOCK == 0x4ec && DAY == 0x01 && prev(bit0(0x00284aec)) == 0x00 && bit0(0x00284aec) == 0x01,
    type = "missable",
    id=530973
)
achievement(
    title = "Monday's Turmoil",
    description = "Reach the end of Day 2 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && IN_GAME_CLOCK == 0x4ec && DAY == 0x02 && prev(bit2(0x00284aef)) == 0x00 && bit2(0x00284aef) == 0x01,
    type = "missable",
    id=530974
)
achievement(
    title = "Tuesday's Disquiet",
    description = "Reach the end of Day 3 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && IN_GAME_CLOCK == 0x4ec && DAY == 0x03 && prev(bit1(0x00284af2)) == 0x00 && bit1(0x00284af2) == 0x01,
    type = "missable",
    id=530975
)
achievement(
    title = "Wednesday's Changes",
    description = "Reach the end of Day 4 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(IN_GAME_CLOCK == 0x4ec) && IN_GAME_CLOCK == 0x00 && prev(DAY == 0x04) && DAY == 0x05,
    type = "missable",
    id=530976
)
achievement(
    title = "Thursday's Shock",
    description = "Reach the end of Day 5 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(IN_GAME_CLOCK == 0x582) && IN_GAME_CLOCK == 0x00 && prev(DAY == 0x05) && DAY == 0x06,
    type = "missable",
    id = 547047
)
achievement(
    title = "Friday's Partings",
    description = "Reach the end of Day 6 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(IN_GAME_CLOCK == 0x582) && IN_GAME_CLOCK == 0x00 && prev(DAY == 0x06) && DAY == 0x07,
    type = "missable"
)
achievement(
    title = "A Saturday Towards Polaris",
    description = "Reach the end of Day 7 without ever entering any Free Battle on a New Game file.",
    points = 25,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(IN_GAME_CLOCK == 0x582) && IN_GAME_CLOCK == 0x00 && prev(DAY == 0x07) && DAY == 0x08,
    type = "missable"
)
achievement(
    title = "Wait, You Can Just... Grind?",
    description = "Complete any ending without ever entering any Free Battle on a New Game file.",
    points = 25,
    trigger = never(is_new_game_plus()) && !entered_free_battle() 
        && (
            (defender_leader_is("Polaris A") && defender_leader_defeated()) 
            || (attacker_leader_is("Polaris A") && attacker_leader_defeated())
        ),
    type = "missable"
)
// FATE stages

achievement(
    title = "Wanna Borrow This?",
    description = "Unlock the ability to use SDTP with another team.",
    points = 3,
    // needs way more than this for save protection
    // probably check that exactly one fate stage has recently progressed to 4 and all others are under
    trigger = prev(bit1(0x00284b19)) == 0x00 && bit1(0x00284b19) == 0x01 
)

achievement(
    title = "Ronaldo's Best Friend",
    description = "Reach FATE stage 5 with Ronaldo.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Ronaldo"),
    id = 547062
)
achievement(
    title = "Io's Best Friend",
    description = "Reach FATE stage 5 with Io.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Io"),
    id = 547052
)
achievement(
    title = "Yamato's Best Friend",
    description = "Reach FATE stage 5 with Yamato.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Yamato"),
    id = 547053
)
achievement(
    title = "Fumi's Best Friend",
    description = "Reach FATE stage 5 with Fumi.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Fumi"),
    id = 547054
)
achievement(
    title = "Daichi's Best Friend",
    description = "Reach FATE stage 5 with Daichi.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Daichi"),
    id = 547050
)
// 
achievement(
    title = "Otome's Best Friend",
    description = "Reach FATE stage 5 with Otome.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Otome"),
    id = 547055
)
achievement(
    title = "Jungo's Best Friend",
    description = "Reach FATE stage 5 with Jungo.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Jungo"),
    id = 547051
)
achievement(
    title = "Makoto's Best Friend",
    description = "Reach FATE stage 5 with Makoto.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Makoto"),
    id = 547056
)
achievement(
    title = "Keita's Best Friend",
    description = "Reach FATE stage 5 with Keita.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Keita"),
    id = 547058
)
achievement(
    title = "Airi's Best Friend",
    description = "Reach FATE stage 5 with Airi.",
    points = 10,
    trigger = character_alive("Airi") && char_fate_stage_maxed("Airi"),
    id = 547057
)
achievement(
    title = "Joe's Best Friend",
    description = "Reach FATE stage 5 with Joe.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Joe"),
    id = 547059
)
achievement(
    title = "Hinako's Best Friend",
    description = "Reach FATE stage 5 with Hinako.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Hinako"),
    id = 547060
)
achievement(
    title = "Anguished One's Best Friend",
    description = "Reach FATE stage 5 with the Anguished One.",
    points = 10,
    trigger = actively_in_event() && char_fate_stage_maxed("Anguished One"),
    id = 547061
)
// *** Auctions ***
achievement(
    "Blind Bidder",
    description = "In an auction with 3 other bidders, place a successful bid and pay for the demon before seeing any of the reactions from other bidders.",
    points = 2,
    trigger = ptr_valid(FULL_AUCTION_PTR) 
        && (ptr_valid(dword(AUCTION_PTR + 0x168)) && byte(AUCTION_PTR + 0x185) == 0xff)
        && (ptr_valid(dword(AUCTION_PTR + 0x188)) && byte(AUCTION_PTR + 0x1a5) == 0xff)
        && (ptr_valid(dword(AUCTION_PTR + 0x1a8)) && byte(AUCTION_PTR + 0x1c5) == 0xff)
        && byte(AUCTION_PTR) == 0x1c
        && prev(MACCA) > MACCA,
    id=530977
)
achievement(
    title = "Math Is Not its Strong Suit",
    description = "Have a demon give you back more Macca than the Extra it demanded.",
    points = 2,
    trigger = ptr_valid(FULL_AUCTION_PTR)
        && byte(AUCTION_PTR) == 0x1c
        && dword(AUCTION_PTR + 0x1e4) < dword(AUCTION_PTR + 0x1e8) 
        && prev(byte(AUCTION_PTR + 0x214)) == 0x01 
        && byte(AUCTION_PTR + 0x214) == 0x02,
    id=530978
)
achievement(
    title = "Clearance Sale",
    description = "Win 3 bids during a single Special Auction.",
    points = 3,
    trigger = never(!ptr_valid(FULL_AUCTION_PTR))
        && never(byte(AUCTION_PTR) == 0x0c)
        && repeated(3, (prev(byte(AUCTION_PTR)) == 0x12 || prev(byte(AUCTION_PTR)) == 0x14) && byte(AUCTION_PTR) == 0x17),
    id=530979
)
achievement(
    title="All That Glitters Is Macca, Actually",
    description = "Unlock the Gold tier of demon auctions.",
    points = 5,
    trigger = bit5(AUCTION_UNLOCK_ELIGIBILITY) == 0x01
        && ptr_valid(FULL_AUCTION_PTR)
        && prev(bit2(AUCTIONS_UNLOCKED) == 0x00) 
        && bit2(AUCTIONS_UNLOCKED) == 0x01,
    id=530980
)
achievement(
    title = "The Holy Grail of Demon Auctions",
    description = "Unlock the Platinum tier of demon auctions.",
    points = 5,
    trigger = ptr_valid(FULL_AUCTION_PTR)
        && prev(bit3(AUCTIONS_UNLOCKED) == 0x00) 
        && bit3(AUCTIONS_UNLOCKED) == 0x01,
    id=530981
)
achievement(
    title = "Embracing the Occult",
    description = "Unlock the Occult tier of demon auctions.",
    points = 5,
    trigger = ptr_valid(FULL_AUCTION_PTR)
        && prev(bit4(AUCTIONS_UNLOCKED) == 0x00) 
        && bit4(AUCTIONS_UNLOCKED) == 0x01,
    id=530982
)

achievement(
    title = "Power Overwhelming",
    description = "Get both of No Damage and Overwhelm bonuses from a single combat.",
    points = 5,
    trigger = ptr_valid(FULL_COMBAT_PTR) 
        && active_mission_in_progress()
        && bit0(0x001c9ff8) == 0x01
        && bit1(0x001c9ff8) == 0x01
        && prev(active_unit_in_combat()) 
        && !active_unit_in_combat(),
    id=546537
)
achievement(
    title = "Ooh, Fancy",
    description = "Have any demon upgrade their Racial Skill while on a mission.",
    points = 3,
    trigger = in_combat()         
        && active_mission_in_progress()
        && any_of(range(0, 23), i => (
            dword(0x00284700 + (0x20 * i)) != 0xffffffff 
                && prev(byte(0x00284700 + (0x20 * i) + 0x18)) != byte(0x00284700 + (0x20 * i) + 0x18)
                && prev(byte(0x00284700 + (0x20 * i))) == byte(0x00284700 + (0x20 * i))
        ))
)

// Anime Teams
achievement(
    title = "A Few Episodes Too Late",
    description = "Use a team composed of the protagonist and his anime signature demon Baihu to defeat any enemy team leader.",
    points = 3,
    trigger = pairing_present("Hero", "Baihu") && ((attacker_leader_is("Hero") && defender_leader_defeated()) || defender_leader_is("Hero") && attacker_leader_defeated())
)
achievement(
    title = "\"If It Will Help Us...\"",
    description = "Use a team composed of Makoto and her anime signature demon Power to defeat any enemy team leader.",
    points = 3,
    trigger = pairing_present("Makoto", "Power") && ((attacker_leader_is("Makoto") && defender_leader_defeated()) || defender_leader_is("Makoto") && attacker_leader_defeated())
)
achievement(
    title = "\"Don't Be Thankin' Me\"",
    description = "Use a team composed of Keita and his anime signature demon Berserker to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Keita", "Berserker") && ((attacker_leader_is("Keita") && defender_leader_defeated()) || defender_leader_is("Keita") && attacker_leader_defeated())
)
achievement(
    title = "\"You See... I Can't Just Sit Still\"",
    description = "Use a team composed of Hinako and her anime signature demon Lilim to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Hinako", "Lilim") && ((attacker_leader_is("Hinako") && defender_leader_defeated()) || defender_leader_is("Hinako") && attacker_leader_defeated())
)
achievement(
    title = "\"Like You, I Want To Try Hard\"",
    description = "Use a team composed of Io and her anime signature demon Kikuri-Hime to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Io", "Kikuri-Hime") && ((attacker_leader_is("Io") && defender_leader_defeated()) || defender_leader_is("Io") && attacker_leader_defeated())
)
// "Kuze Hibiki... He's Our Hope"
achievement(
    title = "\"Think About It. What Is Proper?\"",
    description = "Use a team composed of Ronaldo and his anime signature demon Hagen to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Ronaldo", "Hagen") && ((attacker_leader_is("Ronaldo") && defender_leader_defeated()) || defender_leader_is("Ronaldo") && attacker_leader_defeated())
)
achievement(
    title = "\"Well, This Has Gotten Crazy, Huh?\"",
    description = "Use a team composed of Joe and his anime signature demon Orcus to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Joe", "Orcus") && ((attacker_leader_is("Joe") && defender_leader_defeated()) || defender_leader_is("Joe") && attacker_leader_defeated())
)
achievement(
    title = "\"I'm a Mysterious Woman, Aren't I?\"",
    description = "Use a team compoed of Otome and her anime signature demon Sarasvati to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Otome", "Sarasvati") && ((attacker_leader_is("Otome") && defender_leader_defeated()) || defender_leader_is("Otome") && attacker_leader_defeated())
)
achievement(
    title = "\"Violence Is Not Good\"",
    description = "Use a team composed of Jungo and his anime signature demon Neko Shogun to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Jungo", "Neko Shogun") && ((attacker_leader_is("Jungo") && defender_leader_defeated()) || defender_leader_is("Jungo") && attacker_leader_defeated())
)
achievement(
    title = "\"Don't Make Me Do That Again\"",
    description = "Use a team composed of Yamato and his anime signature demon Cerberus to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Yamato", "Cerberus") && ((attacker_leader_is("Yamato") && defender_leader_defeated()) || defender_leader_is("Yamato") && attacker_leader_defeated())
)
achievement(
    title = "No Forgiveness",
    description = "Use a team composed of Airi and her anime signature demon Lorelei to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Airi", "Lorelei") && ((attacker_leader_is("Airi") && defender_leader_defeated()) || defender_leader_is("Airi") && attacker_leader_defeated())
)
achievement(
    title = "Fighting Frequency with Frequency",
    description = "Use a team composed of Fumi and her anime signature demon Trumpeter to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Fumi", "Trumpeter") && ((attacker_leader_is("Fumi") && defender_leader_defeated()) || defender_leader_is("Fumi") && attacker_leader_defeated())
)
achievement(
    title = "\"Hee. HO.\"",
    description = "Use a team composed of Daichi and his anime signature demon Black Frost to defeat any team leader.",
    points = 3,
    trigger = pairing_present("Daichi", "Black Frost") && ((attacker_leader_is("Daichi") && defender_leader_defeated()) || defender_leader_is("Daichi") && attacker_leader_defeated())
)

// Compendium and Demon Recruitment
// *** Unique Teams and Fusion Things ***
achievement(
    title = "[NEEDS_DEV]Unique Demons",
    description = "Win any battle with 8 active demons that all have the Unique attribute.",
    points = 5,
    trigger = DAY == 0x09 // TODO.
)

// TODO get any advanced race skill

achievement(
    title = "Quarter-Filled Compendium",
    description = "Complete 25% of the Demon compendium.",
    points = 5,
    trigger = prev(num_registered_compendium() == 0x37) && measured(num_registered_compendium() == 0x38, when=always_true(), format="raw"),
    id = 546538
)
achievement(
    title = "Halfway There",
    description = "Complete 50% of the Demon compendium.",
    points = 10,
    trigger = prev(num_registered_compendium() == 0x6e) && measured(num_registered_compendium() == 0x6f, when=always_true(), format="raw"),
    id = 546539
)
achievement(
    title = "That's a Lot of Demons",
    description = "Complete 75% of the Demon compendium.",
    points = 25,
    trigger = prev(num_registered_compendium() == 0xa6) && measured(num_registered_compendium() == 0xa7, when=always_true(), format="raw"),
    id = 546540
)
achievement(
    title = "Finally, Fully Filled",
    description = "Complete 100% of the Demon compendium.",
    points = 50,
    trigger = prev(num_registered_compendium() == 0xdc) && measured(num_registered_compendium() == 0xdd, when=always_true(), format="raw"),
    id = 546541
)
achievement(
    title = "The Purest of Form",
    description = "Register all four demons of the Element race in your compendium.",
    points = 5,
    trigger = prev(elements_registered() == 0x03) && measured(elements_registered() == 0x04, when=always_true(), format="raw"),
    id = 546534

)
// TODO needs badge before upload
achievement(
    title="Spirits of the Second Run",
    description="Register all four demons of the Mitama race in your compendium.",
    points = 5,
    trigger = prev(mitamas_registered() == 0x03) && measured(mitamas_registered() == 0x04, when=always_true(), format="raw")
)

// Skill-Adjacent Achievements
achievement(
    title = "Fast-tracked Learning",
    description = "Learn 4 skills, all from different enemies, in the same mission.",
    points = 5,
    trigger = repeated(4, (num_learned_skills() - prev(num_learned_skills()) == 0x01 && never(!on_grid_map())))
)

achievement(
    title = "The Power to Do Anything",
    description = "Learn all Command skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_command_skills()) == 0x42 && measured(num_learned_command_skills() == 0x43, when=always_true(), format="raw"),
    id=530983
)

achievement(
    title = "Sedentary Strength",
    description = "Learn all Passive Skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_passive_skills()) == 0x4b && measured(num_learned_passive_skills() == 0x4c, when=always_true(), format="raw"),
    id=530984
)

achievement(
    title = "Automating the Helpful Things",
    description = "Learn all Auto Skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_auto_skills()) == 0x1f && measured(num_learned_auto_skills() == 0x20, when=always_true(), format="raw"),
    id=530985
)

// New Game + Stuff
achievement(
    title = "[NEEDS_TEST]Super Fast Dubhe",
    description = "Defeat Dubhe before it enters its second phase.",
    points = 0,
    trigger = MOST_RECENT_MISSION == 0x3f4
        && ((attacker_leader_is("Dubhe (Whole)") && attacker_leader_defeated()) || defender_leader_is("Dubhe (Whole)") && defender_leader_defeated()) 
)

// *** Leaderboards ***
leaderboard(
    title = "Biggest Chump", // please don't actually call it this.
    description = "Highest Extra you've ever agreed to pay during a Demon auction.",
    start = ptr_valid(FULL_AUCTION_PTR) 
        && byte(AUCTION_PTR) == 0x1c 
        && prev(byte(AUCTION_PTR + 0x214)) == 0x00 && byte(AUCTION_PTR + 0x214) == 0x01,
    cancel = byte(AUCTION_PTR) == 0x04 && prev(MACCA) == MACCA,
    submit = prev(byte(AUCTION_PTR + 0x214) == 0x01) && (byte(AUCTION_PTR + 0x214) >= 0x02 && byte(AUCTION_PTR + 0x214) <= 0x03),
    value = dword(AUCTION_PTR + 0x1e4),
    format="VALUE",
    lower_is_better=false
)
leaderboard(
    title = "Turns Used on Dubhe (New Game)",
    description = "Fewest number of allied unit turns used to defeat Dubhe on New Game.",
    start = !loaded_from_suspend() &&
        !is_new_game_plus() && 
        on_mission("Daichi's Resolve") && 
        active_mission_started(),
    cancel = MOST_RECENT_MISSION != event_id_by_name["Daichi's Resolve"],
    submit = ((attacker_leader_is("Dubhe (Half)") && attacker_leader_defeated()) || defender_leader_is("Dubhe (Half)") && defender_leader_defeated()),
    value = tally(0, allied_turn_starts()),
    format="VALUE",
    lower_is_better=true
)
leaderboard(
    title = "Turns Used on Merak (New Game)",
    description = "Fewest number of allied unit turns used to defeat Merak on New Game.",
    start = !loaded_from_suspend() &&
        !is_new_game_plus() &&
        on_mission("Merak Arrives") && 
        active_mission_started(),
    cancel = MOST_RECENT_MISSION != event_id_by_name["Merak Arrives"],
    submit = ((attacker_leader_is("Merak") && attacker_leader_defeated()) || defender_leader_is("Merak") && defender_leader_defeated()),
    value = tally(0, allied_turn_starts()),
    format="VALUE",
    lower_is_better=true
)
leaderboard(
    title = "Turns Used on Phecda (New Game)",
    description = "Fewest number of allied turns used to defeat both forms of Phecda on New Game.",
    start = !loaded_from_suspend() && 
        !is_new_game_plus() &&
        on_mission("Man of Fury") && 
        in_combat_mission("Man of Fury (Phecda)") && 
        prev(bit3(0x00284b5a)) == 0x00 && 
        bit3(0x00284b5a) == 0x01,
    cancel = MOST_RECENT_MISSION != event_id_by_name["Man of Fury"],
    submit = 
        // Phys already defeated, Magic being defeated
        ((
            bit0(0x00284b56) == 0x01 
            && (attacker_leader_is("Phecda (Magic)") || defender_leader_is ("Phecda (Magic)")) 
            && prev(bit6(0x00284b55) == 0x00) 
            && bit6(0x00284b55) == 0x01
        ) ||
        // Magic already defeated, Phys being defeated
        (
            bit6(0x00284b55) == 0x01 
            && (attacker_leader_is("Phecda (Phys)") || defender_leader_is("Phecda (Phys)")) 
            && prev(bit0(0x00284b56)) == 0x00 
            && bit0(0x00284b56) == 0x01
        )),
    value = tally(0, allied_turn_starts()),
    format="VALUE",
    lower_is_better=true
)
leaderboard(
    title = "Turns Used on Megrez (New Game)",
    description = "Fewest number of allied unit turns used to defeat Merak on New Game.",
    start = !loaded_from_suspend() &&
        !is_new_game_plus() &&
        on_mission("Delta Battle") && 
        active_mission_started(),
    cancel = MOST_RECENT_MISSION != event_id_by_name["Delta Battle"],
    submit = ((attacker_leader_is("Megrez") && attacker_leader_defeated()) || defender_leader_is("Megrez") && defender_leader_defeated()),
    value = tally(0, allied_turn_starts())
)
leaderboard(
    title = "Turns Used on Alioth",
    description="Fewest allied unit turns used to defeat Alioth on New Game.",
    start = !loaded_from_suspend() &&
        !is_new_game_plus() &&
        on_mission("Alioth Core") &&
        active_mission_started(),
        cancel = MOST_RECENT_MISSION != event_id_by_name["Alioth Core"],
        submit = ((attacker_leader_is("Alioth Core") && attacker_leader_defeated()) || defender_leader_is("Alioth Core") && defender_leader_defeated()),
        value = tally(0, allied_turn_starts())
)
leaderboard(
    title = "Turns used on Mizar",
    description = "Fewest allied turn units used to defeat Mizar.",
    start = !loaded_from_suspend() &&
        !is_new_game_plus() &&
        on_mission("Food Chain") &&
        active_mission_started(),
        cancel = MOST_RECENT_MISSION != event_id_by_name["Food Chain"],
        submit = (
            once(((defender_leader_is("Mizar Tentacle (3R)") && defender_leader_defeated()) || (attacker_leader_is("Mizar Tentacle (3R)") && attacker_leader_defeated())))
            && once(((defender_leader_is("Mizar Tentacle (3L)") && defender_leader_defeated()) || (attacker_leader_is("Mizar Tentacle (3L)") && attacker_leader_defeated())))
        ),
        value = tally(0, allied_turn_starts())
)


// *** Rich Presence ***

rich_presence_conditional_display(DAY == 0x01 && IN_GAME_CLOCK == 0x00 && MACCA == 0x00, "On the title screen")
rich_presence_conditional_display(ptr_valid(FULL_AUCTION_PTR), "{0} {1} | Getting more Demons from the Auction",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS")
)

rich_presence_conditional_display(in_combat() && ptr_valid(FULL_COMBAT_PTR) && active_unit_in_combat(), "{0} {1} | At {2} | {3} ⚔️ {4} | Time on Mission={5}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_lookup("Unit", word(ATTACKER_TEAM_PTR + 0x0a), enemy_name_by_id),
    rich_presence_lookup("Unit", word(DEFENDER_PTR + 0x0a), enemy_name_by_id),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

// If we could do lookups based on dynamic values, this could be one condition. Alas, it's four.
rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x00), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x276), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x01), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x4f2), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x02), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x76e), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x03), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x9ea), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

// Similar with these, if we could do lookups based on dynamic values, this could be one condition. Alas, it's eight.
rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x04), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0xc66), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x05), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0xee2), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x06), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x115e), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x07), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x13da), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x08), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x1656), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x09), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x18d2), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x0a), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x1b4e), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x0b), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_lookup("Unit", word(COMBAT_PTR + 0x1dca), enemy_name_by_id),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
)

// Non-combat things
rich_presence_conditional_display(actively_in_event(), "{0} {1} 💰 {2} | At {3} | IGT={4}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_value("Macca", MACCA),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("In-Game Time", IN_GAME_TIME / 60, "SECS")
)

rich_presence_display("{0} {1} 💰 {2} | Thinking about where to go next | IGT={3}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_value("Macca", MACCA),
    rich_presence_value("In-Game Time", IN_GAME_TIME / 60, "SECS")
)
