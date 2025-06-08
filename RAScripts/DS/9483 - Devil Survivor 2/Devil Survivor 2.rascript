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
function on_mission(mission_name) {
    return actively_in_event() && most_recent_mission == event_id_by_name[mission_name]
}

// Check if the team taking their turn is engaged in combat.
function active_unit_in_combat() {
    return bit0(combat_ptr + 0x1c) == 0
}

// Check what team is actively moving and whether it's a friendly unit.
function expected_team_moving(expected_team_lead_index) {
    return ptr_valid(full_combat_ptr) && byte(combat_ptr + 0x250) == expected_team_lead_index && unit_moving()
}

// See if the current unit is moving around while in combat.
function unit_moving() => ptr_valid(full_combat_ptr) && bit0(combat_ptr + 0x1c) == 1

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

// Should be valid when the count of 0xff in the turn order array goes down by one.
function unit_respawns() {
    cond = ptr_valid(full_combat_ptr)

    running_total = prev((byte(combat_ptr + 0x250))) / 0xff
    for i in range(1, 11) {
        running_total = running_total + (prev((byte(combat_ptr + 0x250 + i))) / 0xff)
    }

    for i in range(0, 11) {
        running_total = running_total - (byte(combat_ptr + 0x250 + i) / 0xff)
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
    only_friendlies_present = ptr_valid(full_combat_ptr)
    
    // From the end of the team order array to where friendly teams could begin, we should see 0xff
    for i in range(num_starting_teams + 1, 11) {
        only_friendlies_present = only_friendlies_present && (byte(combat_ptr + 0x250 + i)) == 0xff
    }

    for i in range(0, num_starting_teams - 1) {
        only_friendlies_present = only_friendlies_present && (byte(combat_ptr + 0x250 + i)) <= max_player_id
    }


    // finally, check that the slot past the last alive friendly team just died
    only_friendlies_present = only_friendlies_present && (
        prev((byte(combat_ptr + 0x250 + num_starting_teams))) > max_player_id &&
        byte(combat_ptr + 0x250 + num_starting_teams) == 0xff
    )

    return only_friendlies_present
}

// Haven't really found a good indicator otherwise for game overs, except for this pointer popping up
// So if you're in combat and this is valid, player goofed
function game_over() => ptr_valid(dword(0x001beac8))

// Determine if the specific unit was just defeated.
// A "unit" is either a team leader or a demon. 
// Input: address of unit's current health. It is expected that the max health is directly 0x02 after and is the same size. 
function unit_defeated(addr_unit_current_health) {
    return prev(word(addr_unit_current_health)) <= word(addr_unit_current_health + 0x02) && word(addr_unit_current_health) == 0x00
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
    cond = ptr_valid(full_combat_ptr)
    cond = cond && team_moves_to_x(team_offset, x)
    cond = cond && team_moves_to_y(team_offset, y)
    return cond
}

// Check if the given team moved to the given row on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param x the expected x-coordinate
function team_moves_to_x(team_offset, x) {
    cond = ptr_valid(full_team_array_ptr)
    cond = cond && prev(byte(team_array_ptr + (0x27c * team_offset) + 0x1f2)) != x && byte(team_array_ptr + (0x27c * team_offset) + 0x1f2) == x
    return cond
}

// Check if the given team moved to the given column on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param y the expected y-coordinate
function team_moves_to_y(team_offset, y) {
    cond = ptr_valid(full_team_array_ptr)
    cond = cond && prev(byte(team_array_ptr + (0x27c * team_offset) + 0x1f3)) != y && byte(team_array_ptr + (0x27c * team_offset) + 0x1f3) == y
    return cond
}

// Given the index of a team, ensure that the leader's HP is full.
function team_leader_hp_full(team_offset) {
    return ptr_valid(full_team_array_ptr) && word(team_array_ptr + (0x27c * team_offset) + 0x18) == word(team_array_ptr + (0x27c * team_offset) + 0x1a)
}

// Check if the given team is deployed in the current combat.
// This specifically looks to see if the team leader is paired with a specific demon.
// I think we have two options for this, can investigate both:
// 1. Check combat pointer and teams;
// 2. Check static array of demons and correlate with which leader is deployed.
// If 2 is possible we should do that.
// Protag always leads array and is fixed at 0x002844c2.
//        0x002844e4,
//        0x00284508,
//        0x0028452c,

function pairing_present(team_leader_name, demon_name) {
    // Protagonist is special as they're always the first deployed team
    if (team_leader_name == "Hero") {
        return (left_demon(0x00) == enemy_id_by_name[demon_name] || right_demon(0x00) == enemy_id_by_name[demon_name])
    } else {
        return (
            (team_leader(0x01) == chararacter_ids_by_name["Ronaldo"] && (left_demon(0x01) == enemy_id_by_name[demon_name] || right_demon(0x01) == enemy_id_by_name[demon_name])) ||
            (team_leader(0x02) == chararacter_ids_by_name["Ronaldo"] && (left_demon(0x02) == enemy_id_by_name[demon_name] || right_demon(0x02) == enemy_id_by_name[demon_name])) ||
            (team_leader(0x03) == chararacter_ids_by_name["Ronaldo"] && (left_demon(0x03) == enemy_id_by_name[demon_name] || right_demon(0x03) == enemy_id_by_name[demon_name]))
        )
    }
}

// Get the ID of the leader of the given combat team.
function team_leader(team_offset) {
    return word(0x002844e4 + (team_offset * 0x24))
}

// Get the ID of the demon deployed on the left-hand side of the input team.
function left_demon(team_offset) {
    return word(0x00284700 + 0x02 + (team_offset * 0x20))
}

// Get the ID of the demon deployed on the right-hand side of the input team.
function right_demon(team_offset) {
    return word(0x00284700 + 0x02 + (team_offset * 0x20) + 0x20)
}

// Check if the given team is deployed in the current combat.
// This specifically looks to see if the team leader is using two specific demons.
function team_present(team_leader_name, demon_one, demon_two) {
    // Protagonist is special as they're always the first deployed team
    if (team_leader_name == "Hero") {
        return (
            (left_demon(0x00) == enemy_id_by_name[demon_one] && right_demon(0x00) == enemy_id_by_name[demon_two]) || 
            (left_demon(0x00) == enemy_id_by_name[demon_two] && right_demon(0x00) == enemy_id_by_name[demon_one])
        )
    } else {
        return (
            team_leader(0x01) == chararacter_ids_by_name["Ronaldo"] && (
                (left_demon(0x01) == enemy_id_by_name[demon_one] && right_demon(0x01) == enemy_id_by_name[demon_two]) ||
                (left_demon(0x01) == enemy_id_by_name[demon_two] && right_demon(0x01) == enemy_id_by_name[demon_one])
            ) ||
            (team_leader(0x02) == chararacter_ids_by_name["Ronaldo"] && (left_demon(0x02) == enemy_id_by_name[demon_name] || right_demon(0x02) == enemy_id_by_name[demon_name])) ||
            (team_leader(0x03) == chararacter_ids_by_name["Ronaldo"] && (left_demon(0x03) == enemy_id_by_name[demon_name] || right_demon(0x03) == enemy_id_by_name[demon_name]))
        )
    }
}

// Calculates offered Macca + Extra that the demon demands
function true_auction_cost() => dword(full_auction_ptr + 0x1cc) + dword(full_auction_ptr + 0x1e4)

// Stub for now until I have logic for this.
function is_new_game_plus() => always_false()

// The game offers a Suspend function. This is very similar to using a Save State.
// This doesn't work for some of the achievements being coded, so we get to detect if someone actually hopped on a mission
// using the menu or if they're loading from suspend.
// DO NOT USE THIS FOR PROGRESSION. ONLY CHALLENGES.
function loaded_from_suspend() => ptr_valid(full_combat_ptr) && byte(combat_ptr + 0x268) == 0x01

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
    "Megrez":         0xcf,
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
    "Tall Woman":     0x134, // Makoto in Daichi's Crisis
    "Salaryman Carrying Food": 0x146, // in Girl in Pursuit. No, do not fix the indentation.
    "Vacant Woman":   0x164, // Fumi in Demon-Hacked
}

// This map is strictly getting enemies that can lead teams. That's it.
// too many goddamn dicts in this script already
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
    0x47: "Hamsa",
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
    0x59: "Shiisaa",
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
    0x74: "Ictinike",
    // "Hanuman":       0x75,
    // "Cu Chulainn":   0x76,
    // "Kresnik":       0x77,
    // "Ganesha":       0x78,
    // "Heimdall":      0x79,
    0x7a: "Pixie",
    0x7b: "Knocker",
    // "Kijimunaa":     0x7c,
    0x7d: "Jack Frost",
    0x7e: "Pyro Jack",
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
    0xa3: "Wendigo",
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
    0xbb: "Ghost Q",
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
    0xcd: "Merak",
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
    0xf0: "Botis",
    0xf2: "Salaryman",
    0xf3: "Salaryman",
    0xf6: "Office Lady",
    0xf7: "Office Lady",
    0xf8: "Office Lady",
    0xf9: "Punk",
    0xfc: "Yakuza",
    0x10a: "Worker",
    0x10b: "Student",
    0x10c: "Young Man",
    0x114: "Dubhe",
    0x115: "Dubhe",
     // "Bifrons":       0x116,
     // "Barbatos":      0x117,
     // "Dzelarhons":    0x118,
     // "Kama":          0x119,
     // "Parvati":       0x11a,
     // "Ixtab":         0x11b,
     // "Balor":         0x11c,
     // "Nergal":        0x11d,
     // "Inti":          0x11e,
     // "Alilat":        0x11f,
     // "Beiji-Weng":    0x120,
     // "Lord Nan Dou":  0x121,
     // "Masakado":      0x122,
    0x134: "Tall Woman",  // Makoto in Daichi's Crisis
    0x146: "Salaryman Carrying Food", // in Girl in Pursuit
    0x161: "Fumi",        // in Hacker Revealed
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

// Check if a given character has their FATE stage maxed.
// Characters are stored in an array that is sorted based on who's in party.
// Protag always leads array and is fixed at 0x002844c2.
// Other characters that aren't protag start array at 0x002844e4 and end array at 0x002846b8.
// Fate stage is 0x21 into block.
function char_fate_stage_maxed(char_name) {
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
    // for char_addr in array_positions {
    //     cond = cond || (word(char_addr) == chararacter_ids_by_name[char_name] 
    //             && prev(byte(char_addr + 0x21)) == 0x04 
    //             && byte(char_addr + 0x21) == 0x05)
    // }
    return cond
}

// Locations by id.
// This is the location you enter the event at; it's not the actual location your character might be at plot wise 
// because sometimes characters move around to different spots mid event.
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

event_id_by_name = {
    "Death Clip":       0x3e9,
    "Daichi's Crisis":  0x3f1,
    "A Man Named Joe":  0x3f3,
    "Daichi's Resolve": 0x3f4,
    "App Abuser":       0x7d4,
    "Never Say Die":    0x7d8,
    "Demon-Hacked":     0x7da,
    "Osaka Soul":       0x7dc,
    "Merak Arrives":    0x7e2,
    "Vs. Q":            0xbbb,
    "Girl in Pursuit":  0xbbd,
    "Boy in Combat":    0xbbe,        
    "Hacker Revealed":  0xbbf,
    "Saving Daichi":    0xbc2,
    "Megrez Meeting":   0xfa8
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

    if (mission_name == "Never Say Die") {
        return prev(bit2(0x00284b57)) == 0x00 && bit2(0x00284b57) == 0x01
    }

    if (mission_name == "Osaka Soul") { 
        return prev(bit4(0x00284b54)) == 0x00 && bit4(0x00284b54) == 0x01
    }

    if (mission_name == "Hacker Revealed") {
        return prev(bit2(0x00284b56)) == 0x00 && bit2(0x00284b56) == 0x01
    }
}

// Helper while we're still mapping out mails.
// For every mailbox address we don't know about, tell us when it flips from 0xff to anything else.
function mailbox_hunt_helper() {
    starting_addr = 0x00284cb0
    ending_addr = 0x00284d83

    mapped_addrs = [
        0x00284cb3,
        0x00284cb4,
        0x00284cb5,
        0x00284cb6,
        0x00284cb7,
        0x00284ccb,
        0x00284ccc,
        0x00284cce,
        0x00284ccf,
        0x00284ce6,
        0x00284ce7
    ]

    mails_to_check = day <= 0x08

    for i in range(0x00284cb0, 0x00284d83) {
        if (!array_contains(mapped_addrs, i)) {
            mails_to_check = mails_to_check || (prev(byte(i)) == 0xff && byte(i) != 0xff)
        } 
    }
    return mails_to_check
}

achievement(
    title = "[FOR DEV]Mailbox Hunt",
    description = "You got mail!",
    points = 0,
    trigger = day <= 0x08 && mailbox_hunt_helper()
)

achievement(
    title = "[FOR DEV]Event Flag Hunt",
    description = "Events have flags associated to say 'you did this.' This might be one of them!",
    points = 0,
    trigger = day <= 0x08 && (
        // 0x00284ad8
        (prev(bit1(0x00284ad8)) == 0x00 && bit1(0x00284ad8) == 0x01) ||
        (prev(bit4(0x00284ad8)) == 0x00 && bit4(0x00284ad8) == 0x01) ||
        (prev(bit5(0x00284ad8)) == 0x00 && bit5(0x00284ad8) == 0x01) ||
        (prev(bit6(0x00284ad8)) == 0x00 && bit6(0x00284ad8) == 0x01) ||
        (prev(bit7(0x00284ad8)) == 0x00 && bit7(0x00284ad8) == 0x01) ||
        // 0x00284ad9
        (prev(bit0(0x00284ad9)) == 0x00 && bit0(0x00284ad9) == 0x01) ||
        (prev(bit1(0x00284ad9)) == 0x00 && bit1(0x00284ad9) == 0x01) ||
        (prev(bit3(0x00284ad9)) == 0x00 && bit3(0x00284ad9) == 0x01) ||
        (prev(bit4(0x00284ad9)) == 0x00 && bit4(0x00284ad9) == 0x01) ||
        // 0x00284ada
        (prev(bit1(0x00284ada)) == 0x00 && bit1(0x00284ada) == 0x01) ||
        (prev(bit2(0x00284ada)) == 0x00 && bit2(0x00284ada) == 0x01) ||
        (prev(bit3(0x00284ada)) == 0x00 && bit3(0x00284ada) == 0x01) ||
        (prev(bit4(0x00284ada)) == 0x00 && bit4(0x00284ada) == 0x01) ||
        (prev(bit5(0x00284ada)) == 0x00 && bit5(0x00284ada) == 0x01) ||
        (prev(bit6(0x00284ada)) == 0x00 && bit6(0x00284ada) == 0x01) ||
        // 0x00284adb
        (prev(bit2(0x00284adb)) == 0x00 && bit2(0x00284adb) == 0x01) ||
        (prev(bit6(0x00284adb)) == 0x00 && bit6(0x00284adb) == 0x01) ||
        (prev(bit7(0x00284adb)) == 0x00 && bit7(0x00284adb) == 0x01) ||
        // 0x00284adc
        (prev(bit0(0x00284adc)) == 0x00 && bit0(0x00284adc) == 0x01) ||
        (prev(bit1(0x00284adc)) == 0x00 && bit1(0x00284adc) == 0x01) ||
        (prev(bit2(0x00284adc)) == 0x00 && bit2(0x00284adc) == 0x01) ||
        (prev(bit3(0x00284adc)) == 0x00 && bit3(0x00284adc) == 0x01) ||
        (prev(bit4(0x00284adc)) == 0x00 && bit4(0x00284adc) == 0x01) ||
        // 0x00284add
        (prev(bit1(0x00284add)) == 0x00 && bit1(0x00284add) == 0x01) ||
        (prev(bit2(0x00284add)) == 0x00 && bit2(0x00284add) == 0x01) ||
        (prev(bit7(0x00284add)) == 0x00 && bit7(0x00284add) == 0x01) ||
        // 0x00284ade
        (prev(bit0(0x00284ade)) == 0x00 && bit0(0x00284ade) == 0x01) ||
        (prev(bit1(0x00284ade)) == 0x00 && bit1(0x00284ade) == 0x01) ||
        (prev(bit2(0x00284ade)) == 0x00 && bit2(0x00284ade) == 0x01) ||
        (prev(bit3(0x00284ade)) == 0x00 && bit3(0x00284ade) == 0x01) ||
        (prev(bit5(0x00284ade)) == 0x00 && bit5(0x00284ade) == 0x01) ||
        (prev(bit6(0x00284ade)) == 0x00 && bit6(0x00284ade) == 0x01) ||
        // 0x00284adf
        (prev(bit0(0x00284adf)) == 0x00 && bit0(0x00284adf) == 0x01) ||
        (prev(bit1(0x00284adf)) == 0x00 && bit1(0x00284adf) == 0x01) ||
        (prev(bit2(0x00284adf)) == 0x00 && bit2(0x00284adf) == 0x01) ||
        (prev(bit3(0x00284adf)) == 0x00 && bit3(0x00284adf) == 0x01) ||
        (prev(bit4(0x00284adf)) == 0x00 && bit4(0x00284adf) == 0x01) ||
        (prev(bit7(0x00284adf)) == 0x00 && bit7(0x00284adf) == 0x01) ||
        // 0x00284ae0
        (prev(bit0(0x00284ae0)) == 0x00 && bit0(0x00284ae0) == 0x01) ||
        (prev(bit1(0x00284ae0)) == 0x00 && bit1(0x00284ae0) == 0x01) ||
        (prev(bit5(0x00284ae0)) == 0x00 && bit5(0x00284ae0) == 0x01) ||
        (prev(bit6(0x00284ae0)) == 0x00 && bit6(0x00284ae0) == 0x01) ||
        (prev(bit7(0x00284ae0)) == 0x00 && bit7(0x00284ae0) == 0x01) ||
        // 0x00284ae1
        (prev(bit0(0x00284ae1)) == 0x00 && bit0(0x00284ae1) == 0x01) ||
        (prev(bit1(0x00284ae1)) == 0x00 && bit1(0x00284ae1) == 0x01) ||
        (prev(bit3(0x00284ae1)) == 0x00 && bit3(0x00284ae1) == 0x01) ||
        (prev(bit4(0x00284ae1)) == 0x00 && bit4(0x00284ae1) == 0x01) ||
        (prev(bit6(0x00284ae1)) == 0x00 && bit6(0x00284ae1) == 0x01) ||
        (prev(bit7(0x00284ae1)) == 0x00 && bit7(0x00284ae1) == 0x01) ||
        // 0x00284ae2 needs a sign of anything being there before we commit
        (prev(bit0(0x00284ae2)) == 0x00 && bit0(0x00284ae2) == 0x01) ||
        (prev(bit1(0x00284ae2)) == 0x00 && bit1(0x00284ae2) == 0x01) ||
        (prev(bit2(0x00284ae2)) == 0x00 && bit2(0x00284ae2) == 0x01) ||
        (prev(bit3(0x00284ae2)) == 0x00 && bit3(0x00284ae2) == 0x01) ||
        (prev(bit4(0x00284ae2)) == 0x00 && bit4(0x00284ae2) == 0x01) ||
        (prev(bit5(0x00284ae2)) == 0x00 && bit5(0x00284ae2) == 0x01) ||
        (prev(bit6(0x00284ae2)) == 0x00 && bit6(0x00284ae2) == 0x01) ||
        (prev(bit7(0x00284ae2)) == 0x00 && bit7(0x00284ae2) == 0x01) ||
        // 0x00284ae3
        (prev(bit0(0x00284ae3)) == 0x00 && bit0(0x00284ae3) == 0x01) ||
        (prev(bit4(0x00284ae3)) == 0x00 && bit4(0x00284ae3) == 0x01) ||
        (prev(bit5(0x00284ae3)) == 0x00 && bit5(0x00284ae3) == 0x01) ||
        (prev(bit6(0x00284ae3)) == 0x00 && bit6(0x00284ae3) == 0x01) ||
        (prev(bit7(0x00284ae3)) == 0x00 && bit7(0x00284ae3) == 0x01) ||
        // 0x00284ae4
        (prev(bit0(0x00284ae4)) == 0x00 && bit0(0x00284ae4) == 0x01) ||
        (prev(bit2(0x00284ae4)) == 0x00 && bit2(0x00284ae4) == 0x01) ||
        (prev(bit3(0x00284ae4)) == 0x00 && bit3(0x00284ae4) == 0x01) ||
        (prev(bit6(0x00284ae4)) == 0x00 && bit6(0x00284ae4) == 0x01) ||
        (prev(bit7(0x00284ae4)) == 0x00 && bit7(0x00284ae4) == 0x01) ||
        // 0x00284ae5
        (prev(bit0(0x00284ae5)) == 0x00 && bit0(0x00284ae5) == 0x01) ||
        (prev(bit1(0x00284ae5)) == 0x00 && bit1(0x00284ae5) == 0x01) ||
        (prev(bit2(0x00284ae5)) == 0x00 && bit2(0x00284ae5) == 0x01) ||
        (prev(bit3(0x00284ae5)) == 0x00 && bit3(0x00284ae5) == 0x01) ||
        // bit4 is likely Jungo's Find
        (prev(bit4(0x00284ae5)) == 0x00 && bit4(0x00284ae5) == 0x01) ||
        (prev(bit5(0x00284ae5)) == 0x00 && bit5(0x00284ae5) == 0x01) ||
        (prev(bit6(0x00284ae5)) == 0x00 && bit6(0x00284ae5) == 0x01) ||
        (prev(bit7(0x00284ae5)) == 0x00 && bit7(0x00284ae5) == 0x01) ||
        // 0x00284ae6
        (prev(bit1(0x00284ae6)) == 0x00 && bit1(0x00284ae6) == 0x01) ||
        (prev(bit2(0x00284ae6)) == 0x00 && bit2(0x00284ae6) == 0x01) ||
        (prev(bit3(0x00284ae6)) == 0x00 && bit3(0x00284ae6) == 0x01) ||
        (prev(bit4(0x00284ae6)) == 0x00 && bit4(0x00284ae6) == 0x01) ||
        (prev(bit5(0x00284ae6)) == 0x00 && bit5(0x00284ae6) == 0x01) ||
        (prev(bit6(0x00284ae6)) == 0x00 && bit6(0x00284ae6) == 0x01) ||
        (prev(bit7(0x00284ae6)) == 0x00 && bit7(0x00284ae6) == 0x01) ||
        // 0x00284ae7
        (prev(bit1(0x00284ae7)) == 0x00 && bit1(0x00284ae7) == 0x01) ||
        (prev(bit2(0x00284ae7)) == 0x00 && bit2(0x00284ae7) == 0x01) ||
        (prev(bit3(0x00284ae7)) == 0x00 && bit3(0x00284ae7) == 0x01) ||
        (prev(bit4(0x00284ae7)) == 0x00 && bit4(0x00284ae7) == 0x01) ||
        (prev(bit5(0x00284ae7)) == 0x00 && bit5(0x00284ae7) == 0x01) ||
        (prev(bit6(0x00284ae7)) == 0x00 && bit6(0x00284ae7) == 0x01) ||
        (prev(bit7(0x00284ae7)) == 0x00 && bit7(0x00284ae7) == 0x01) ||
        // 0x00284ae8
        (prev(bit0(0x00284ae8)) == 0x00 && bit0(0x00284ae8) == 0x01) ||
        (prev(bit1(0x00284ae8)) == 0x00 && bit1(0x00284ae8) == 0x01) ||
        (prev(bit2(0x00284ae8)) == 0x00 && bit2(0x00284ae8) == 0x01) ||
        (prev(bit3(0x00284ae8)) == 0x00 && bit3(0x00284ae8) == 0x01) ||
        (prev(bit4(0x00284ae8)) == 0x00 && bit4(0x00284ae8) == 0x01) ||
        (prev(bit6(0x00284ae8)) == 0x00 && bit6(0x00284ae8) == 0x01) ||
        (prev(bit7(0x00284ae8)) == 0x00 && bit7(0x00284ae8) == 0x01) ||
        // 0x00284ae9
        (prev(bit0(0x00284ae9)) == 0x00 && bit0(0x00284ae9) == 0x01) ||
        (prev(bit1(0x00284ae9)) == 0x00 && bit1(0x00284ae9) == 0x01) ||
        (prev(bit2(0x00284ae9)) == 0x00 && bit2(0x00284ae9) == 0x01) ||
        (prev(bit3(0x00284ae9)) == 0x00 && bit3(0x00284ae9) == 0x01) ||
        (prev(bit4(0x00284ae9)) == 0x00 && bit4(0x00284ae9) == 0x01) ||
        (prev(bit5(0x00284ae9)) == 0x00 && bit5(0x00284ae9) == 0x01) ||
        (prev(bit6(0x00284ae9)) == 0x00 && bit6(0x00284ae9) == 0x01) ||
        (prev(bit7(0x00284ae9)) == 0x00 && bit7(0x00284ae9) == 0x01) ||
        // 0x00284aea
        (prev(bit0(0x00284aea)) == 0x00 && bit0(0x00284aea) == 0x01) ||
        (prev(bit1(0x00284aea)) == 0x00 && bit1(0x00284aea) == 0x01) ||
        (prev(bit2(0x00284aea)) == 0x00 && bit2(0x00284aea) == 0x01) ||
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
        (prev(bit7(0x00284af5)) == 0x00 && bit7(0x00284af5) == 0x01) ||
        // 0x00284af6
        (prev(bit0(0x00284af6)) == 0x00 && bit0(0x00284af6) == 0x01) ||
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
        (prev(bit4(0x00284af7)) == 0x00 && bit4(0x00284af7) == 0x01) ||
        (prev(bit5(0x00284af7)) == 0x00 && bit5(0x00284af7) == 0x01) ||
        (prev(bit6(0x00284af7)) == 0x00 && bit6(0x00284af7) == 0x01) ||
        (prev(bit7(0x00284af7)) == 0x00 && bit7(0x00284af7) == 0x01) ||
        // 0x00284af8
        (prev(bit0(0x00284af8)) == 0x00 && bit0(0x00284af8) == 0x01) ||
        (prev(bit1(0x00284af8)) == 0x00 && bit1(0x00284af8) == 0x01) ||
        (prev(bit2(0x00284af8)) == 0x00 && bit2(0x00284af8) == 0x01) ||
        (prev(bit3(0x00284af8)) == 0x00 && bit3(0x00284af8) == 0x01) ||
        (prev(bit4(0x00284af8)) == 0x00 && bit4(0x00284af8) == 0x01) ||
        (prev(bit5(0x00284af8)) == 0x00 && bit5(0x00284af8) == 0x01) ||
        (prev(bit6(0x00284af8)) == 0x00 && bit6(0x00284af8) == 0x01) ||
        (prev(bit7(0x00284af8)) == 0x00 && bit7(0x00284af8) == 0x01) ||
        // 0x00284af9
        (prev(bit0(0x00284af9)) == 0x00 && bit0(0x00284af9) == 0x01) ||
        (prev(bit1(0x00284af9)) == 0x00 && bit1(0x00284af9) == 0x01) ||
        (prev(bit2(0x00284af9)) == 0x00 && bit2(0x00284af9) == 0x01) ||
        (prev(bit3(0x00284af9)) == 0x00 && bit3(0x00284af9) == 0x01) ||
        (prev(bit4(0x00284af9)) == 0x00 && bit4(0x00284af9) == 0x01) ||
        (prev(bit5(0x00284af9)) == 0x00 && bit5(0x00284af9) == 0x01) ||
        (prev(bit6(0x00284af9)) == 0x00 && bit6(0x00284af9) == 0x01) ||
        (prev(bit7(0x00284af9)) == 0x00 && bit7(0x00284af9) == 0x01) ||
        // 0x00284afa
        (prev(bit0(0x00284afa)) == 0x00 && bit0(0x00284afa) == 0x01) ||
        (prev(bit1(0x00284afa)) == 0x00 && bit1(0x00284afa) == 0x01) || 
        (prev(bit2(0x00284afa)) == 0x00 && bit2(0x00284afa) == 0x01) || 
        (prev(bit3(0x00284afa)) == 0x00 && bit3(0x00284afa) == 0x01) || 
        (prev(bit4(0x00284afa)) == 0x00 && bit4(0x00284afa) == 0x01) || 
        (prev(bit5(0x00284afa)) == 0x00 && bit5(0x00284afa) == 0x01) || 
        (prev(bit6(0x00284afa)) == 0x00 && bit6(0x00284afa) == 0x01) || 
        (prev(bit7(0x00284afa)) == 0x00 && bit7(0x00284afa) == 0x01) || 
        // 0x00284afb
        (prev(bit0(0x00284afb)) == 0x00 && bit0(0x00284afb) == 0x01) ||
        (prev(bit1(0x00284afb)) == 0x00 && bit1(0x00284afb) == 0x01) ||
        (prev(bit2(0x00284afb)) == 0x00 && bit2(0x00284afb) == 0x01) ||
        (prev(bit3(0x00284afb)) == 0x00 && bit3(0x00284afb) == 0x01) ||
        (prev(bit4(0x00284afb)) == 0x00 && bit4(0x00284afb) == 0x01) ||
        (prev(bit5(0x00284afb)) == 0x00 && bit5(0x00284afb) == 0x01) ||
        (prev(bit6(0x00284afb)) == 0x00 && bit6(0x00284afb) == 0x01) ||
        (prev(bit7(0x00284afb)) == 0x00 && bit7(0x00284afb) == 0x01) ||
        // 0x00284afc
        (prev(bit0(0x00284afc)) == 0x00 && bit0(0x00284afc) == 0x01) ||
        (prev(bit1(0x00284afc)) == 0x00 && bit1(0x00284afc) == 0x01) ||
        (prev(bit2(0x00284afc)) == 0x00 && bit2(0x00284afc) == 0x01) ||
        (prev(bit3(0x00284afc)) == 0x00 && bit3(0x00284afc) == 0x01) ||
        (prev(bit4(0x00284afc)) == 0x00 && bit4(0x00284afc) == 0x01) ||
        (prev(bit5(0x00284afc)) == 0x00 && bit5(0x00284afc) == 0x01) ||
        (prev(bit6(0x00284afc)) == 0x00 && bit6(0x00284afc) == 0x01) ||
        (prev(bit7(0x00284afc)) == 0x00 && bit7(0x00284afc) == 0x01) ||
        // 0x00284afd
        (prev(bit0(0x00284afd)) == 0x00 && bit0(0x00284afd) == 0x01) ||
        (prev(bit1(0x00284afd)) == 0x00 && bit1(0x00284afd) == 0x01) ||
        (prev(bit2(0x00284afd)) == 0x00 && bit2(0x00284afd) == 0x01) ||
        (prev(bit3(0x00284afd)) == 0x00 && bit3(0x00284afd) == 0x01) ||
        (prev(bit4(0x00284afd)) == 0x00 && bit4(0x00284afd) == 0x01) ||
        (prev(bit5(0x00284afd)) == 0x00 && bit5(0x00284afd) == 0x01) ||
        (prev(bit6(0x00284afd)) == 0x00 && bit6(0x00284afd) == 0x01) ||
        (prev(bit7(0x00284afd)) == 0x00 && bit7(0x00284afd) == 0x01) ||
        // 0x00284afe
        (prev(bit0(0x00284afe)) == 0x00 && bit0(0x00284afe) == 0x01) ||
        (prev(bit1(0x00284afe)) == 0x00 && bit1(0x00284afe) == 0x01) ||
        (prev(bit2(0x00284afe)) == 0x00 && bit2(0x00284afe) == 0x01) ||
        (prev(bit3(0x00284afe)) == 0x00 && bit3(0x00284afe) == 0x01) ||
        (prev(bit4(0x00284afe)) == 0x00 && bit4(0x00284afe) == 0x01) ||
        (prev(bit5(0x00284afe)) == 0x00 && bit5(0x00284afe) == 0x01) ||
        (prev(bit6(0x00284afe)) == 0x00 && bit6(0x00284afe) == 0x01) ||
        (prev(bit7(0x00284afe)) == 0x00 && bit7(0x00284afe) == 0x01) ||
        // 0x00284aff
        (prev(bit0(0x00284aff)) == 0x00 && bit0(0x00284aff) == 0x01) || 
        (prev(bit1(0x00284aff)) == 0x00 && bit1(0x00284aff) == 0x01) || 
        (prev(bit2(0x00284aff)) == 0x00 && bit2(0x00284aff) == 0x01) || 
        (prev(bit3(0x00284aff)) == 0x00 && bit3(0x00284aff) == 0x01) || 
        (prev(bit4(0x00284aff)) == 0x00 && bit4(0x00284aff) == 0x01) || 
        (prev(bit5(0x00284aff)) == 0x00 && bit5(0x00284aff) == 0x01) || 
        (prev(bit6(0x00284aff)) == 0x00 && bit6(0x00284aff) == 0x01) || 
        (prev(bit7(0x00284aff)) == 0x00 && bit7(0x00284aff) == 0x01) || 
        // 0x00284b00
        (prev(bit0(0x00284b00)) == 0x00 && bit0(0x00284b00) == 0x01) ||
        (prev(bit1(0x00284b00)) == 0x00 && bit1(0x00284b00) == 0x01) || 
        (prev(bit2(0x00284b00)) == 0x00 && bit2(0x00284b00) == 0x01) || 
        (prev(bit3(0x00284b00)) == 0x00 && bit3(0x00284b00) == 0x01) || 
        (prev(bit4(0x00284b00)) == 0x00 && bit4(0x00284b00) == 0x01) || 
        (prev(bit5(0x00284b00)) == 0x00 && bit5(0x00284b00) == 0x01) || 
        (prev(bit6(0x00284b00)) == 0x00 && bit6(0x00284b00) == 0x01) || 
        (prev(bit7(0x00284b00)) == 0x00 && bit7(0x00284b00) == 0x01) || 
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
        (prev(bit4(0x00284b03)) == 0x00 && bit4(0x00284b03) == 0x01) ||
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
        (prev(bit4(0x00284b08)) == 0x00 && bit4(0x00284b08) == 0x01) ||
        (prev(bit5(0x00284b08)) == 0x00 && bit5(0x00284b08) == 0x01) ||
        (prev(bit6(0x00284b08)) == 0x00 && bit6(0x00284b08) == 0x01) ||
        (prev(bit7(0x00284b08)) == 0x00 && bit7(0x00284b08) == 0x01) ||
        // 0x00284b09
        (prev(bit0(0x00284b09)) == 0x00 && bit0(0x00284b09) == 0x01) ||
        (prev(bit1(0x00284b09)) == 0x00 && bit1(0x00284b09) == 0x01) ||
        (prev(bit2(0x00284b09)) == 0x00 && bit2(0x00284b09) == 0x01) ||
        (prev(bit3(0x00284b09)) == 0x00 && bit3(0x00284b09) == 0x01) ||
        (prev(bit4(0x00284b09)) == 0x00 && bit4(0x00284b09) == 0x01) ||
        (prev(bit5(0x00284b09)) == 0x00 && bit5(0x00284b09) == 0x01) ||
        (prev(bit6(0x00284b09)) == 0x00 && bit6(0x00284b09) == 0x01) ||
        (prev(bit7(0x00284b09)) == 0x00 && bit7(0x00284b09) == 0x01) ||
        // 0x00284b0a
        (prev(bit0(0x00284b0a)) == 0x00 && bit0(0x00284b0a) == 0x01) ||
        (prev(bit1(0x00284b0a)) == 0x00 && bit1(0x00284b0a) == 0x01) ||
        (prev(bit2(0x00284b0a)) == 0x00 && bit2(0x00284b0a) == 0x01) ||
        (prev(bit3(0x00284b0a)) == 0x00 && bit3(0x00284b0a) == 0x01) ||
        (prev(bit4(0x00284b0a)) == 0x00 && bit4(0x00284b0a) == 0x01) ||
        (prev(bit5(0x00284b0a)) == 0x00 && bit5(0x00284b0a) == 0x01) ||
        (prev(bit6(0x00284b0a)) == 0x00 && bit6(0x00284b0a) == 0x01) ||
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
        (prev(bit5(0x00284b0d)) == 0x00 && bit5(0x00284b0d) == 0x01) ||
        (prev(bit6(0x00284b0d)) == 0x00 && bit6(0x00284b0d) == 0x01) ||
        (prev(bit7(0x00284b0d)) == 0x00 && bit7(0x00284b0d) == 0x01) ||
        // 0x00284b0e
        (prev(bit0(0x00284b0e)) == 0x00 && bit0(0x00284b0e) == 0x01) ||
        (prev(bit1(0x00284b0e)) == 0x00 && bit1(0x00284b0e) == 0x01) ||
        (prev(bit2(0x00284b0e)) == 0x00 && bit2(0x00284b0e) == 0x01) ||
        (prev(bit3(0x00284b0e)) == 0x00 && bit3(0x00284b0e) == 0x01) ||
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
        (prev(bit5(0x00284b0f)) == 0x00 && bit5(0x00284b0f) == 0x01) ||
        (prev(bit6(0x00284b0f)) == 0x00 && bit6(0x00284b0f) == 0x01) ||
        (prev(bit7(0x00284b0f)) == 0x00 && bit7(0x00284b0f) == 0x01) ||
        // 0x00284b10
        (prev(bit0(0x00284b10)) == 0x00 && bit0(0x00284b10) == 0x01) ||
        (prev(bit1(0x00284b10)) == 0x00 && bit1(0x00284b10) == 0x01) ||
        (prev(bit2(0x00284b10)) == 0x00 && bit2(0x00284b10) == 0x01) ||
        (prev(bit3(0x00284b10)) == 0x00 && bit3(0x00284b10) == 0x01) ||
        (prev(bit4(0x00284b10)) == 0x00 && bit4(0x00284b10) == 0x01) ||
        (prev(bit5(0x00284b10)) == 0x00 && bit5(0x00284b10) == 0x01) ||
        (prev(bit6(0x00284b10)) == 0x00 && bit6(0x00284b10) == 0x01) ||
        (prev(bit7(0x00284b10)) == 0x00 && bit7(0x00284b10) == 0x01) ||
        // 0x00284b11
        (prev(bit0(0x00284b11)) == 0x00 && bit0(0x00284b11) == 0x01) ||
        (prev(bit1(0x00284b11)) == 0x00 && bit1(0x00284b11) == 0x01) ||
        (prev(bit2(0x00284b11)) == 0x00 && bit2(0x00284b11) == 0x01) ||
        (prev(bit3(0x00284b11)) == 0x00 && bit3(0x00284b11) == 0x01) ||
        (prev(bit4(0x00284b11)) == 0x00 && bit4(0x00284b11) == 0x01) ||
        (prev(bit5(0x00284b11)) == 0x00 && bit5(0x00284b11) == 0x01) ||
        (prev(bit6(0x00284b11)) == 0x00 && bit6(0x00284b11) == 0x01) ||
        (prev(bit7(0x00284b11)) == 0x00 && bit7(0x00284b11) == 0x01) ||
        // it goes down to here :(
        (prev(bit0(0x00284b12)) == 0x00 && bit0(0x00284b12) == 0x01) ||
        (prev(bit1(0x00284b12)) == 0x00 && bit1(0x00284b12) == 0x01) ||
        (prev(bit2(0x00284b12)) == 0x00 && bit2(0x00284b12) == 0x01) ||
        (prev(bit3(0x00284b12)) == 0x00 && bit3(0x00284b12) == 0x01) ||
        (prev(bit4(0x00284b12)) == 0x00 && bit4(0x00284b12) == 0x01) ||
        (prev(bit5(0x00284b12)) == 0x00 && bit5(0x00284b12) == 0x01) ||
        (prev(bit6(0x00284b12)) == 0x00 && bit6(0x00284b12) == 0x01) ||
        (prev(bit7(0x00284b12)) == 0x00 && bit7(0x00284b12) == 0x01) ||
        // 0x00284b13
        (prev(bit0(0x00284b13)) == 0x00 && bit0(0x00284b13) == 0x01) ||
        (prev(bit1(0x00284b13)) == 0x00 && bit1(0x00284b13) == 0x01) ||
        (prev(bit4(0x00284b13)) == 0x00 && bit4(0x00284b13) == 0x01) ||
        (prev(bit5(0x00284b13)) == 0x00 && bit5(0x00284b13) == 0x01) ||
        (prev(bit6(0x00284b13)) == 0x00 && bit6(0x00284b13) == 0x01) ||
        (prev(bit7(0x00284b13)) == 0x00 && bit7(0x00284b13) == 0x01) ||
        // 0x00284b14
        (prev(bit0(0x00284b14)) == 0x00 && bit0(0x00284b14) == 0x01) ||
        (prev(bit1(0x00284b14)) == 0x00 && bit1(0x00284b14) == 0x01) ||
        (prev(bit2(0x00284b14)) == 0x00 && bit2(0x00284b14) == 0x01) ||
        (prev(bit3(0x00284b14)) == 0x00 && bit3(0x00284b14) == 0x01) ||
        (prev(bit4(0x00284b14)) == 0x00 && bit4(0x00284b14) == 0x01) ||
        (prev(bit5(0x00284b14)) == 0x00 && bit5(0x00284b14) == 0x01) ||
        (prev(bit6(0x00284b14)) == 0x00 && bit6(0x00284b14) == 0x01) ||
        (prev(bit7(0x00284b14)) == 0x00 && bit7(0x00284b14) == 0x01) ||
        // 0x00284b15
        (prev(bit0(0x00284b15)) == 0x00 && bit0(0x00284b15) == 0x01) ||
        (prev(bit1(0x00284b15)) == 0x00 && bit1(0x00284b15) == 0x01) ||
        (prev(bit2(0x00284b15)) == 0x00 && bit2(0x00284b15) == 0x01) ||
        (prev(bit3(0x00284b15)) == 0x00 && bit3(0x00284b15) == 0x01) ||
        (prev(bit4(0x00284b15)) == 0x00 && bit4(0x00284b15) == 0x01) ||
        (prev(bit5(0x00284b15)) == 0x00 && bit5(0x00284b15) == 0x01) ||
        (prev(bit6(0x00284b15)) == 0x00 && bit6(0x00284b15) == 0x01) ||
        (prev(bit7(0x00284b15)) == 0x00 && bit7(0x00284b15) == 0x01) ||
        // 0x00284b16
        (prev(bit0(0x00284b16)) == 0x00 && bit0(0x00284b16) == 0x01) ||
        (prev(bit1(0x00284b16)) == 0x00 && bit1(0x00284b16) == 0x01) ||
        (prev(bit2(0x00284b16)) == 0x00 && bit2(0x00284b16) == 0x01) ||
        (prev(bit3(0x00284b16)) == 0x00 && bit3(0x00284b16) == 0x01) ||
        (prev(bit4(0x00284b16)) == 0x00 && bit4(0x00284b16) == 0x01) ||
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
        (prev(bit1(0x00284b19)) == 0x00 && bit1(0x00284b19) == 0x01) ||
        (prev(bit2(0x00284b19)) == 0x00 && bit2(0x00284b19) == 0x01) ||
        (prev(bit3(0x00284b19)) == 0x00 && bit3(0x00284b19) == 0x01) ||
        (prev(bit4(0x00284b19)) == 0x00 && bit4(0x00284b19) == 0x01) ||
        (prev(bit5(0x00284b19)) == 0x00 && bit5(0x00284b19) == 0x01) ||
        (prev(bit6(0x00284b19)) == 0x00 && bit6(0x00284b19) == 0x01) ||
        (prev(bit7(0x00284b19)) == 0x00 && bit7(0x00284b19) == 0x01) ||
        // 0x00284b1a
        (prev(bit0(0x00284b1a)) == 0x00 && bit0(0x00284b1a) == 0x01) ||
        (prev(bit1(0x00284b1a)) == 0x00 && bit1(0x00284b1a) == 0x01) ||
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
        (prev(bit6(0x00284b1e)) == 0x00 && bit6(0x00284b1e) == 0x01) ||
        (prev(bit7(0x00284b1e)) == 0x00 && bit7(0x00284b1e) == 0x01) ||
        // 0x00284b1f
        (prev(bit0(0x00284b1f)) == 0x00 && bit0(0x00284b1f) == 0x01) ||
        (prev(bit1(0x00284b1f)) == 0x00 && bit1(0x00284b1f) == 0x01) ||
        (prev(bit2(0x00284b1f)) == 0x00 && bit2(0x00284b1f) == 0x01) ||
        (prev(bit3(0x00284b1f)) == 0x00 && bit3(0x00284b1f) == 0x01) ||
        (prev(bit4(0x00284b1f)) == 0x00 && bit4(0x00284b1f) == 0x01) ||
        (prev(bit5(0x00284b1f)) == 0x00 && bit5(0x00284b1f) == 0x01) ||
        (prev(bit6(0x00284b1f)) == 0x00 && bit6(0x00284b1f) == 0x01) ||
        (prev(bit7(0x00284b1f)) == 0x00 && bit7(0x00284b1f) == 0x01) ||
        // 0x00284b20
        (prev(bit0(0x00284b20)) == 0x00 && bit0(0x00284b20) == 0x01) ||
        (prev(bit1(0x00284b20)) == 0x00 && bit1(0x00284b20) == 0x01) ||
        (prev(bit2(0x00284b20)) == 0x00 && bit2(0x00284b20) == 0x01) ||
        (prev(bit5(0x00284b20)) == 0x00 && bit5(0x00284b20) == 0x01) ||
        (prev(bit7(0x00284b20)) == 0x00 && bit7(0x00284b20) == 0x01)
    )
)

// *** Achievements ***

// Progression

achievement(
    title = "False Alarm",
    description = "Avert the crisis shown in your death clip.",
    points = 1,
    trigger =  day == 0x01 && on_mission("Death Clip") && all_allied_teams_last_standing(3),
    type = "progression"
)
achievement(
    title = "She's Sealed Away for a Reason",
    description = "Avert the crisis shown in the second death clip on Sunday.",
    points = 1,
    trigger = on_mission("Daichi's Crisis") && active_mission_completed("Daichi's Crisis"),
    type = "progression"
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
    type = "missable"
)
achievement(
    title = "Taking on Troublesome Contracts",
    description = "Help Joe resolve his outstanding contract.",
    points = 2,
    trigger = on_mission("A Man Named Joe") && active_mission_completed("A Man Named Joe"),
    type = "progression"
)
achievement(
    title = "No Demon Left Behind",
    description = "Get all allies to the escape area in Daichi's Worth without Dubhe killing any demons and without using the Suspend feature.",
    points = 5,
    trigger = never(most_recent_mission != 0x3f4)
        && ptr_valid(full_team_array_ptr)
        && bit3(0x00284aec) == 0x01
        && trigger_when(prev(word(team_array_ptr + (0x27c * 0x04) + 0x0a)) == 0x114 && word(team_array_ptr + (0x27c * 0x04) + 0x0a) == 0x115)
        && never((attacker_leader_is("Dubhe (Whole)") && defender_left_unit_defeated())
        || (attacker_leader_is("Dubhe (Whole)") && defender_right_unit_defeated())
        || (defender_leader_is("Dubhe (Whole)") && attacker_left_unit_defeated())
        || (defender_leader_is("Dubhe (Whole)") && attacker_right_unit_defeated()))
        // This may not be technically necessary, but it makes me feel better!
        // I'm observing that the game does not use a separate pointer to access teams when the game loads from suspend in this mission
        // which means that the validity check for the full_team_array_ptr is actually doing work
        && disable_when(loaded_from_suspend(), until=most_recent_mission != 0x3f4),
    type = "missable"
)
achievement(
    title = "Dubious Dubhe",
    description = "Defeat Dubhe.",
    points = 5,
    trigger = on_mission("Daichi's Resolve")
        && ((attacker_leader_is("Dubhe (Half)") && attacker_leader_defeated()) || defender_leader_is("Dubhe (Half)") && defender_leader_defeated()),
    type = "progression"
)
achievement(
    title = "I Take My Volunteer Work Seriously",
    // We don't actively need to check for the Suspend function here, the hits take care of that
    description = "Without using the Suspend function, defeat all human enemies in App Abuser before any have a chance to escape.",
    points = 3,
    trigger = never(most_recent_mission != 0x7d4)
        && on_mission("App Abuser")
        && on_grid_map()
        && trigger_when(once(defender_leader_is("Punk") && defender_leader_defeated())) 
        && trigger_when(once(defender_leader_is("Salaryman") && defender_leader_defeated()))
        && trigger_when(once(defender_leader_is("Young Man") && defender_leader_defeated()))
        && disable_when(team_moves_to_x(0x04, 0x0e), until=most_recent_mission != 0x7d4)
        && disable_when(team_moves_to_x(0x05, 0x0e), until=most_recent_mission != 0x7d4)
        && disable_when(team_moves_to_x(0x06, 0x0e), until=most_recent_mission != 0x7d4),
    type = "missable"
)
// Suspend allowed
achievement(
    title = "Busting the 'valgate Party",
    description = "Defeat the Vacant Woman in Demon-Hacked before a second wave of demons joins the fight.",
    points = 5,
    trigger = on_mission("Demon-Hacked")
        && in_combat()
        && trigger_when(defender_leader_is("Vacant Woman")) && trigger_when(defender_leader_defeated())
        // I'm making the hot presumption that Fumi's team position is static
        // There's 0 way this bites me in the ass. No way!
        // In all seriousness the other summon is a special one that doesn't happen on "her" turn
        // so we only have to check this occurs once.
        && ptr_valid(full_team_array_ptr)
        && disable_when(
            once(prev(word(team_array_ptr + 0x162b)) == 0x0c && word(team_array_ptr + 0x162b) == 0x11),
            until=most_recent_mission != 0x7da
        ),
    type = "missable"
)
achievement(
    title = "I Hate Escorting People",
    description = "In 'Never Say Die', defeat all enemy demons with the civilians at full HP.",
    points = 5,
    trigger = on_mission("Never Say Die") && team_leader_hp_full(0x0a) && team_leader_hp_full(0x0b)
        && trigger_when(active_mission_completed("Never Say Die")),
    type = "missable"
)
achievement(
    title = "Take Me to the Men in Yellow",
    description = "Recruit Hinako to the party.",
    points = 3,
    trigger = on_mission("Never Say Die") && character_recruited("Hinako"),
    type = "progression"
)
achievement(
    title = "Miasma Maestro",
    description = "Clear all of the miasma in 'Osaka Soul' before any additional enemy teams are summoned and complete the mission without using the Suspend feature.",
    points = 5,
    trigger = on_mission("Osaka Soul") 
        && never(loaded_from_suspend())
        && disable_when(unit_respawns(), until=most_recent_mission != event_id_by_name["Osaka Soul"])
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
    type = "missable"
)
achievement(
    title = "Treading Carefully",
    description = "Defeat Merak without it ever using Circumpolarity and without using the Suspend feature.",
    points = 5,
    trigger = on_grid_map() && on_mission("Merak Arrives") 
            && ptr_valid(full_team_array_ptr)
            && never(loaded_from_suspend())
            && trigger_when((attacker_leader_is("Merak") && attacker_leader_defeated()) 
            || defender_leader_is("Merak") && defender_leader_defeated())
            && disable_when(prev(byte(team_array_ptr + 0xc3b)) == 0x00 && byte(team_array_ptr + 0xc3b) == 0x0a, until=most_recent_mission != 0x7e2),
    type = "missable"
)
achievement(
    title = "Meticulous Merak",
    description = "Defeat Merak.",
    points = 5,
    trigger = on_mission("Merak Arrives")  
        && ((attacker_leader_is("Merak") && attacker_leader_defeated()) || defender_leader_is("Merak") && defender_leader_defeated()),
    type = "progression"
)
achievement(
    title = "A Fun-Filled Q...!",
    description = "Defeat Ghost Q.",
    points = 10,
    trigger = day == 0x03 && on_mission("Vs. Q")
        && ((defender_leader_is("Ghost Q") && defender_leader_defeated()) || (attacker_leader_is("Ghost Q") && attacker_leader_defeated())),
    type = "missable"
)
achievement(
    title = "Hands Off The Food, Bud",
    description = "Prevent the salaryman carrying food from escaping in Girl in Pursuit.",
    points = 3,
    trigger = on_mission("Girl in Pursuit") && ((defender_leader_is("Salaryman Carrying Food") && defender_leader_defeated()) || (attacker_leader_is("Salaryman Carrying Food") && attacker_leader_defeated())),
    type = "missable"
)
achievement(
    title = "Hot-Headed Redhead",
    description = "Recruit Airi to the party.",
    points = 2,
    trigger = bit4(0x00284af2) == 0x01 && bit5(0x00284af2) == 0x01
        && (most_recent_mission == event_id_by_name["Girl in Pursuit"] || most_recent_mission == event_id_by_name["Boy in Combat"])
        && prev(actively_in_event()) && !actively_in_event(),
    type = "progression"
)
achievement(
    title = "Second Time's the Charm",
    description = "Defeat Botis in 'Hacker Revealed.'",
    points = 5,
    trigger = on_mission("Hacker Revealed") &&
        ((defender_leader_is("Botis") && defender_leader_defeated()) || (attacker_leader_is("Botis") && attacker_leader_defeated())),
    type = "missable"
)
achievement(
    title = "Hmm... Mm?",
    description = "Complete 'Hacker Revealed'",
    points = 3,
    trigger = on_mission("Hacker Revealed") && active_mission_completed("Hacker Revealed"),
    type = "progression"
)
achievement(
    title = "[NEEDS_DEV]Untie Me Already!",
    description = "Escort Daichi to the rescue point in the mission where he gets tied up",
    points = 5,
    trigger = day == 0x09,
    type = "missable"
)
// Badge should be picture of rioters in Planetarium that gang up on Jungo
achievement(
    title = "Savior of the Strong",
    description = "Prevent the death foretold by Tuesday's death clip.",
    points = 5,
    // probably needs a bit more in case of game over
    trigger = bit2(0x00284af1) == 0x01 && on_mission("Saving Daichi") && character_alive("Jungo") && character_recruited("Jungo"),
    type = "missable"
)
// Man of Fury: Defeat Ronaldo before any supporter has a chance to escape. "Go for the Head"
achievement(
    title = "[NEEDS_DEV]Brutal Efficiency",
    description = "In 'Man of Fury,' defeat Ronaldo while all other enemy teams still on the map.",
    points = 10,
    // Loose high level idea here:
    // you detect when Ronaldo's HP hits 0, this is the trigger
    // you verify that the first N slots in the turn order are != 0xff. that's it
    trigger = day == 0x09,
    type = "missable"
)
achievement(
    title = "[NEEDS_DEV]Efficient Multitasker",
    // Make sure it's very clear that you can Suspend before it splits, but any Suspend after it splits 
    // will result in not being to accomplish this challenge 
    description = "In a single session, defeat Phecda within 5 turns of it splitting into two units.",
    points = 5,
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
    // This will also need to make sure that regardless of session, both Phecdas are defeated
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
    title="Can I Go to Timor With This?",
    description="Unlock the ability to use the Terminal.",
    points = 1,
    trigger = most_recent_mission == event_id_by_name["Megrez Meeting"] && prev(actively_in_event()) && !(actively_in_event())
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

// *** Avoidable Deaths to Cover ***
// Otome
// Makoto
// Saving Daichi OR Goodbye Jungo: Actually save Daichi by bringing him to a rescue point. Do what the mission says!!!
// Man of Fury pt. 2: Defeat Phecda
// Megrez missions: Have only the team leader on any team get hit when Megrez's Bud uses its Diastrophism skill.
// ^ above can be either Megrez bud or refight
// Confrontation: Fight both the JP members and civilians and clear everyone out.
// App and Muggers:
// A Hard Choice: Defeat all the demons / Neko Shogun
// Power Outage: Ronaldo survives fight as well
// Mystery Man
// Need to decide if Dera-deka is being split up into two cheevos or one
achievement(
    title = "A Mysterious Man Indeed",
    description = "Witness all of the events surrounding the Mystery Man.",
    points = 5,
    trigger = day == 0x09, // TODO need more digging
    type = "missable"
)
// Delta Battle: Win the fight without clearing any Miasma.

// no Free Battle progression
achievement(
    title = "Sunday's Melancholy",
    description = "Reach the end of Day 1 without ever entering any Free Battle on a New Game file.",
    points = 5,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && in_game_clock == 0x4ec && day == 0x01 && prev(bit0(0x00284aec)) == 0x00 && bit0(0x00284aec) == 0x01,
    type = "missable"
)
achievement(
    title = "Monday's Turmoil",
    description = "Reach the end of Day 2 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && in_game_clock == 0x4ec && day == 0x02 && prev(bit2(0x00284aef)) == 0x00 && bit2(0x00284aef) == 0x01,
    type = "missable"
)
achievement(
    title = "Tuesday's Disquiet",
    description = "Reach the end of Day 3 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && in_game_clock == 0x4ec && day == 0x03 && prev(bit1(0x00284af2)) == 0x00 && bit1(0x00284af2) == 0x01,
    type = "missable"
)
achievement(
    title = "Wednesday's Changes",
    description = "Reach the end of Day 4 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x04) && day == 0x05,
    type = "missable"
)
achievement(
    title = "[NEEDS DEV]Thursday",
    description = "Reach the end of Day 5 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x05) && day == 0x06,
    type = "missable"
)
achievement(
    title = "[NEEDS DEV]Friday",
    description = "Reach the end of Day 6 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x06) && day == 0x07,
    type = "missable"
)
achievement(
    title = "[NEEDS DEV]Saturday",
    description = "Reach the end of Day 7 without ever entering any Free Battle on a New Game file.",
    points = 10,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x07) && day == 0x08,
    type = "missable"
)
achievement(
    title = "[NEEDS DEV]Wait, You Can Just... Grind?",
    description = "Complete any ending without ever entering any Free Battle on a New Game file.",
    points = 25,
    trigger = never(is_new_game_plus()) && !entered_free_battle() && prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x07) && day == 0x08,
    type = "missable"
)
// FATE stages

achievement(
    title = "[NEEDS_TEST]Ronaldo's Best Friend",
    description = "Reach FATE stage 5 with Ronaldo.",
    points = 10,
    trigger = char_fate_stage_maxed("Ronaldo")
)
achievement(
    title = "[NEEDS_TEST]IO's Best Friend",
    description = "Reach FATE stage 5 with Io.",
    points = 10,
    trigger = char_fate_stage_maxed("Io")
)
achievement(
    title = "[NEEDS_TEST]Yamato's Best Friend",
    description = "Reach FATE stage 5 with Yamato.",
    points = 10,
    trigger = char_fate_stage_maxed("Yamato")
)
achievement(
    title = "[NEEDS_TEST]Fumi's Best Friend",
    description = "Reach FATE stage 5 with Fumi.",
    points = 10,
    trigger = char_fate_stage_maxed("Fumi")
)
achievement(
    title = "[NEEDS_TEST]Daichi's Best Friend",
    description = "Reach FATE stage 5 with Daichi.",
    points = 10,
    trigger = char_fate_stage_maxed("Daichi") 
)
achievement(
    title = "[NEEDS_TEST]Otome's Best Friend",
    description = "Reach FATE stage 5 with Otome.",
    points = 10,
    trigger = char_fate_stage_maxed("Otome") 
)
achievement(
    title = "[NEEDS_TEST]Jungo's Best Friend",
    description = "Reach FATE stage 5 with Jungo.",
    points = 10,
    trigger = char_fate_stage_maxed("Jungo") 
)
achievement(
    title = "[NEEDS_TEST]Makoto's Best Friend",
    description = "Reach FATE stage 5 with Makoto.",
    points = 10,
    trigger = char_fate_stage_maxed("Makoto") 
)
achievement(
    title = "[NEEDS_TEST]Keita's Best Friend",
    description = "Reach FATE stage 5 with Keita.",
    points = 10,
    trigger = char_fate_stage_maxed("Keita") 
)
achievement(
    title = "[NEEDS_TEST]Airi's Best Friend",
    description = "Reach FATE stage 5 with Airi.",
    points = 10,
    trigger = character_alive("Airi") && char_fate_stage_maxed("Airi") 
)
achievement(
    title = "[NEEDS_TEST]Joe's Best Friend",
    description = "Reach FATE stage 5 with Joe.",
    points = 10,
    trigger = char_fate_stage_maxed("Joe") 
)
achievement(
    title = "[NEEDS_TEST]Hinako's Best Friend",
    description = "Reach FATE stage 5 with Hinako.",
    points = 10,
    trigger = char_fate_stage_maxed("Hinako") 
)
achievement(
    title = "[NEEDS_TEST]Anguished One's Best Friend",
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
        // this has been consistently wrong, it's not a flag of "yeah it asked for extra" but is something else
        && byte(auction_ptr + 0x214) == 0x01
        && (dword(auction_ptr + 0x1cc) + dword(auction_ptr + 0x1e4) + macca) > prev(macca)
)
achievement(
    title = "Clearance Sale",
    description = "Win 3 bids during a single Special Auction.",
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

achievement(
    title = "[NEEDS_DEV] 6x Technical",
    description = "Get a 6x Technical Bonus or higher in any combat.",
    points = 3,
    trigger = word(0x001c9ff2) >= 0x06 && byte(0x001c9ff3) != 0xff
        && ptr_valid(full_combat_ptr) 
        && prev(active_unit_in_combat()) 
        && !active_unit_in_combat()
)
achievement(
    title = "Power Overwhelming",
    description = "Get both of No Damage and Overwhelm bonuses from a single combat.",
    points = 5,
    trigger = ptr_valid(full_combat_ptr) 
        && bit0(0x001c9ff8) == 0x01
        && bit1(0x001c9ff8) == 0x01
        && prev(active_unit_in_combat()) 
        && !active_unit_in_combat()
)

// Anime Teams
// General concept: Win any battle while including a team composed of <team leader>, <requiredDemon> and <any other demon || otherRequiredDemon> 

// Protag + Byakko + Suzaku
// However, in the actual game they have different names :)
// If This Can Solve Things, I'll Do It
achievement(
    title = "A Few Episodes Too Late",
    description = "Win any battle while including a team composed of the protagonist and Baihu.",
    points = 3,
    trigger = pairing_present("Hero", "Baihu") && prev(in_combat()) && !in_combat() 
)
// Makoto + Power => "Makoto": 0x0a, or Makoto + Pallas Athena
// I'm Doing It, If It Will Help Us
achievement(
    title = "\"If It Will Help Us...\"",
    description = "Win any battle while including a team composed of Makoto and Power.",
    points = 3,
    trigger = pairing_present("Makoto", "Power") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "\"Don't Be Thankin' Me\"",
    description = "Win any battle while including a team composed of Keita and Berserker.",
    points = 3,
    trigger = pairing_present("Keita", "Berserker") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "\"You See... I Can't Just Sit Still\"",
    description = "Win any battle while including a team composed of Hinako and Lilim.",
    points = 3,
    trigger = pairing_present("Hinako", "Lilim") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "\"Like You, I Want To Try Hard\"",
    description = "Win any battle while including a team composed of Io and Kikuri-Hime.",
    points = 3,
    trigger = pairing_present("Io", "Kikuri-Hime") && prev(in_combat()) && !in_combat() 
)
// Ronaldo + Hagen => "Ronaldo": 0x03,
// "Kuze Hibiki... He's Our Hope"
achievement(
    title = "\"Think About It. What Is Proper?\"",
    description = "Win any battle while including a team composed of Ronaldo and Hagen.",
    points = 3,
    trigger = pairing_present("Ronaldo", "Hagen") && prev(in_combat()) && !in_combat() 
)
// Joe + Orcus => "Joe": 0x0d,
achievement(
    title = "\"Well, This Has Gotten Crazy, Huh?\"",
    description = "Win any battle while including a team composed of Joe and Orcus.",
    points = 3,
    trigger = pairing_present("Joe", "Orcus") && prev(in_combat()) && !in_combat() 
)
// Otome + Sarasvati with Drain => "Otome": 0x08,
// "I'm a mysterious woman, aren't I?"
achievement(
    title = "[NEEDS_DEV / ANIME TIE IN]Otome",
    description = "Win any battle while including a team composed of Otome and Sarasvati.",
    points = 3,
    trigger = pairing_present("Otome", "Sarasvati") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "\"Violence Is Not Good\"",
    description = "Win any battle while including a team composed of Jungo and Neko Shogun.",
    points = 3,
    trigger = pairing_present("Jungo", "Neko Shogun") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "\"Don't Make Me Do That Again\"",
    description = "Win any battle while including a team composed of Yamato and Cerberus.",
    points = 3,
    trigger = pairing_present("Yamato", "Cerberus") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "No Forgiveness",
    description = "Win any battle while including a team composed of Airi and Lorelei.",
    points = 3,
    trigger = pairing_present("Airi", "Lorelei") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "Fighting Frequency with Frequency",
    description = "Win any battle while including a team composed of Fumi and Trumpeter.",
    points = 3,
    trigger = pairing_present("Fumi", "Trumpeter") && prev(in_combat()) && !in_combat() 
)
achievement(
    title = "\"Hee. HO.\"",
    description = "Win any battle while including a team composed of Daichi and Black Frost.",
    points = 3,
    trigger = pairing_present("Daichi", "Black Frost") && prev(in_combat()) && !in_combat() 
)

// Compendium and Demon Recruitment
// *** Unique Teams and Fusion Things ***
achievement(
    title = "[NEEDS_DEV]Unique Demons",
    description = "Win any battle with 8 active demons that all have the Unique attribute.",
    points = 5,
    trigger = day == 0x09 // TODO.
)

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
    title = "The Purest of Form",
    description = "Register all four demons of the Element race in your compendium.",
    points = 5,
    trigger = prev(elements_registered() == 0x03) && measured(elements_registered() == 0x04, when=always_true(), format="raw") 
)
achievement(
    title="Spirits of the Second Run",
    description="Register all four demons of the Mitama race in your compendium.",
    points = 5,
    trigger = prev(mitamas_registered() == 0x03) && measured(mitamas_registered == 0x04, when=always_true(), format="raw")
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

rich_presence_conditional_display(in_combat() && ptr_valid(full_combat_ptr) && active_unit_in_combat(), "{0} {1} | At {2} | {3} ⚔️ {4} | Time on Mission={5}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_lookup("Unit", word(attacker_team_ptr + 0x0a), enemy_name_by_id),
    rich_presence_lookup("Unit", word(defender_ptr + 0x0a), enemy_name_by_id),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

// If we could do lookups based on dynamic values, this could be one condition. Alas, it's four.
rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x00), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x276), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x01), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x4f2), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x02), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x76e), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x03), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x9ea), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

// Similar with these, if we could do lookups based on dynamic values, this could be one condition. Alas, it's eight.
rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x04), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0xc66), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x05), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0xee2), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x06), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x115e), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x07), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x13da), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x08), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x1656), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x09), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x18d2), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x0a), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x1b4e), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_conditional_display(on_grid_map() && expected_team_moving(0x0b), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Unit", word(combat_ptr + 0x1dca), enemy_name_by_id),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

// Non-combat things
rich_presence_conditional_display(actively_in_event(), "{0} {1} 💰 {2} | At {3} | IGT={4}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_value("Macca", macca),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_value("In-Game Time", in_game_time / 60, "SECS")
)

rich_presence_display("{0} {1} 💰 {2} | Thinking about where to go next | IGT={3}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_value("Macca", macca),
    rich_presence_value("In-Game Time", in_game_time / 60, "SECS")
)
