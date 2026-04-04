// Devil Survivor 2
// #ID=9483
// md5: 4b1ee25404620aed63ee09f24a9a6db5
// #MinimumVersion=1.3.1

// General note for myself: DS pointers usually take the form of 0x02xxxxxx
// However, the DS only has 4MB of RAM so with RA addressing you can just take the 24 bytes denoted by xxxxxx and deref that
// Because of that, this script has two named variables per ptr until I figure out a more elegant way to reference this

// (Hours * 60) + minutes
IN_GAME_CLOCK = word(0x00284ab4)

// Checks if we're at a current time of day, written in a way that lets us write human-readable times.
function is_time_of_day(hours, minutes) => hours * 60 + minutes == IN_GAME_CLOCK

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

function is_day(expected_day) {
    if (expected_day == "Sunday") {
        return DAY == 0x01
    } else if (expected_day == "Monday") {
        return DAY == 0x02
    } else if (expected_day == "Tuesday") {
        return DAY == 0x03
    } else if (expected_day == "Wednesday") {
        return DAY == 0x04
    } else if (expected_day == "Thursday") {
        return DAY == 0x05
    } else if (expected_day == "Friday") {
        return DAY == 0x06
    } else if (expected_day == "Saturday") {
        return DAY == 0x07
    } else if (expected_day == "Final Day") {
        return DAY == 0x08
    }
}

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
function on_mission(mission_name) => MOST_RECENT_MISSION == event_id_by_name[mission_name]

// This exists because it turns out, mission names are NOT UNIQUE.
// Isn't that fun to find out several months into developing a set?
// Anyway, I don't want to rework this entire goddamn thing so instead just tell me what the branching mission is you're on
// and we'll do it through fugly nested if statements.
function on_branching_mission(mission_name, ending) {
    identified_mission = 0xffff

    if (ending == "Ronaldo") {
        if (mission_name == "Vs. Tokyo") {
            identified_mission = 0x1b59
        } else if (mission_name == "Settling Up") {
            identified_mission = 0x1b5c
        }else if (mission_name == "Vs. Osaka") {
            identified_mission = 0x1b60
        } else if (mission_name == "Test of Might") {
            identified_mission = 0x1b64
        } else if (mission_name == "Seven Down") {
            identified_mission = 0x1b68
        } else if (mission_name == "Shown Path") {
            identified_mission = 0x1f42
        } else if (mission_name == "Unexpected Battle") {
            identified_mission = 0x1f44
        } else if (mission_name == "Last Assassin") {
            identified_mission = 0x1f45
        } else if (mission_name == "Unseen Tomorrow") {
            identified_mission = 0x1f46
        }
    } else if (ending == "Yamato") {
        if (mission_name == "Vs. Tokyo") {
            identified_mission = 0x1bbd
        } else if (mission_name == "Settling Up") {
            identified_mission = 0x1bc0
        } else if (mission_name == "Vs. Nagoya") {
            identified_mission = 0x1bc4
        } else if (mission_name == "Last Stand") {
            identified_mission = 0x1bc7
        } else if (mission_name == "Seven Down") {
            identified_mission = 0x1bcc
        } else if (mission_name == "Shown Path") {
            identified_mission = 0x1fa6
        } else if (mission_name == "Unexpected Battle") {
            identified_mission = 0x1fa8
        } else if (mission_name == "Last Assassin") {
            identified_mission = 0x1fa9
        } else if (mission_name == "Correct Tomorrow") {
            identified_mission = 0x1faa
        }
    } else if (ending == "Al Saiduq" || ending == "Anguished One") {
        if (mission_name == "Vs. Tokyo") {
            identified_mission = 0x1c85
        // I would put these in order but RATools is freaking out on me for some nondescript reason if this is where I want it to be
        } else if (mission_name == "Strong Breaker") {
            identified_mission = 0x2072
        } else if (mission_name == "Settling Up") {
            identified_mission = 0x1c88
        } else if (mission_name == "Vs. Osaka") {
            identified_mission = 0x1c8c
        } else if (mission_name == "Vs. Nagoya") {
            identified_mission = 0x1c90
        } else if (mission_name == "Seven Down") {
            identified_mission = 0x1c96
        } else if (mission_name == "Dream's End") {
            identified_mission = 0x206e
        } else if (mission_name == "Reared Head") {
            identified_mission = 0x2071
        } else if (mission_name == "New Tomorrow") {
            identified_mission = 0x2073
        }
    } else if (ending == "Daichi") {
        if (mission_name == "Vs. Osaka") {
            identified_mission = 0x1c21
        } else if (mission_name == "Vs. Nagoya") {
            identified_mission = 0x1c25
        } else if (mission_name == "Unknown Threat") {
            identified_mission = 0x1c28
        } else if (mission_name == "Dream's End") {
            identified_mission = 0x1c29
        } else if (mission_name == "Strong Breaker") {
            identified_mission = 0x1c2c
        } else if (mission_name == "Seven Down") {
            identified_mission = 0x1c31
        } else if (mission_name == "Shown Path") {
            identified_mission = 0x20d3
        }
    // This is a problem for future me.
    // It seems like there's a lot of those in this script!
    // Anyway, daichi has two further splits and they are DIFFERENT MISSION IDS. 
    } else if (ending == "Daichi (Restorer)") {
        if (mission_name == "Unexpected Battle") {
            identified_mission = 0x20d5
        } else if (mission_name == "Last Assassin") {
            identified_mission = 0x20d6
        } else if (mission_name == "Dreamed Future") {
            identified_mission = 0x20d7
        }
    } else if (ending == "Daichi (Liberator)") {
        if (mission_name == "Unexpected Battle") {
            identified_mission = 0x200c
        } else if (mission_name == "Last Assassin") {
            identified_mission = 0x200d
        } else if (mission_name == "To Freedom") {
            identified_mission = 0x200e
        }
    }

    return MOST_RECENT_MISSION == identified_mission
}

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
function attacker_leader_defeated() => ptr_valid(FULL_ATTACKER_TEAM_PTR) && unit_defeated(ATTACKER_TEAM_PTR + 0x18)

// See if the attacking leader is a friendly unit. A friendly unit is one that the player placed.
function attacker_leader_friendly() {
    return ptr_valid(FULL_ATTACKER_TEAM_PTR) 
        && ptr_valid(FULL_COMBAT_PTR)
        && word(ATTACKER_TEAM_PTR + 0x0a) <= 0x0d
} 

function defender_leader_friendly() {
    return ptr_valid(FULL_DEFENDER_TEAM_PTR) && ptr_valid(FULL_COMBAT_PTR) && word(DEFENDER_PTR + 0x0a) <= 0x0d
}

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
    cond = ptr_valid(FULL_COMBAT_PTR) && byte(0x001beaa8) > 1

    running_total = prev((byte(COMBAT_PTR + 0x250))) / 0xff
    for i in range(1, 11) {
        running_total = running_total + (prev((byte(COMBAT_PTR + 0x250 + i))) / 0xff)
    }

    for i in range(0, 11) {
        running_total = running_total - (byte(COMBAT_PTR + 0x250 + i) / 0xff)
    }

    return cond && running_total == 0x01
}

// Check if a specific team is being led by a specific unit.
function team_leader_is(index, team_leader_name) {
    return word(COMBAT_PTR + 0x26c + (0x27c)*index + 0x0a) == enemy_id_by_name[team_leader_name]
}

// [8-bit] State of combat
// 0x01 = Setting up for Dispatch;
// 0x03 = Dialogue mid combat;
// 0x04 = Moving view to next unit;
// 0x05 = Active character can make a move;
// 0x06 = Fighting;
// 0x0a = Combat done;
// 0x0f = Not doing a combat;
// 0x10 = Seen during Lamhfhada after picking up an energy
function combat_actively_occurring() => byte(0x001beaa8) == 0x06

// Helper function for the thing I keep copy-pasting everywhere.
// Check that any unit defeated the named unit.
function specific_leader_defeated(unit_name) {
    return (
        (attacker_leader_is(unit_name) && defender_leader_friendly() && attacker_leader_defeated()) 
          || defender_leader_is(unit_name) && attacker_leader_friendly() && defender_leader_defeated()
    )
}

// Helper function for the other damn thing that keeps coming up.
// Can these units JUST DIE?
// This is the soft defeat analagous helper function to #specific_leader_defeated.
function specific_leader_soft_defeated(unit_name) {
    return ((attacker_leader_is(unit_name)) && attacker_leader_reduced_to_1hp()
        || defender_leader_is(unit_name) && defender_leader_reduced_to_1hp())
}

// Similar to specific_leader_soft_defeated, except we check if a specific unit reduced the other one to 1hp.
function specific_leader_soft_defeated_by(defeated_unit, winning_unit) {
    return (attacker_leader_is(winning_unit) && defender_leader_is(defeated_unit) && defender_leader_reduced_to_1hp()) || 
           (defender_leader_is(winning_unit) && attacker_leader_is(defeated_unit) && attacker_leader_reduced_to_1hp())
}

// Similar to unit_defeated, except we're checking that a specific unit defeated another specific unit.
function specific_leader_defeated_by(defeated_unit, winning_unit) {
    return (attacker_leader_is(winning_unit) && defender_leader_is(defeated_unit) && defender_leader_defeated()) || 
           (defender_leader_is(winning_unit) && attacker_leader_is(defeated_unit) && attacker_leader_defeated())
}

// Check whether there are only allied teams standing in combat.
// This specifically checks if all expected deployed allies are alive and only those teams are alive.
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

// Check how many player teams are alive.
// This is different from #all_allied_teams_last_standing because this strictly checks player teams, not enemy teams.
function player_teams_alive(num_teams) {
    cond = always_true()
    for i in range(0, num_teams - 1) {
        offset = 0x27c * i
        cond = cond && bit0(COMBAT_PTR + 0x26c + offset) == 0x01
                    && bit1(COMBAT_PTR + 0x26c + offset) == 0x01
                    && bit2(COMBAT_PTR + 0x26c + offset) == 0x01 
                    && byte(COMBAT_PTR + 0x284 + offset) > 0
    }

    return cond
}

function only_friendly_teams_left() {
    return byte(COMBAT_PTR + 0x218) > 0 && (
            // Case 1: one party member alive
            (
                byte(COMBAT_PTR + 0x250) <= 0x03
                && prev(byte(COMBAT_PTR + 0x251) <= 0x0b)
                && byte(COMBAT_PTR + 0x251) == 0xff
            )
            ||
            // Case 2: two party members alive
            (
                byte(COMBAT_PTR + 0x250) <= 0x03
                && byte(COMBAT_PTR + 0x251) <= 0x03
                && prev(byte(COMBAT_PTR + 0x252) <= 0x0b)
                && byte(COMBAT_PTR + 0x252) == 0xff
            )
            ||
            // Case 3: three party members alive
            (
                byte(COMBAT_PTR + 0x250) <= 0x03
                && byte(COMBAT_PTR + 0x251) <= 0x03
                && byte(COMBAT_PTR + 0x252) <= 0x03
                && prev(byte(COMBAT_PTR + 0x253) <= 0x0b)
                && byte(COMBAT_PTR + 0x253) == 0xff
            )
            ||
            // Case 4: four party members alive
            (
                byte(COMBAT_PTR + 0x250) <= 0x03
                && byte(COMBAT_PTR + 0x251) <= 0x03
                && byte(COMBAT_PTR + 0x252) <= 0x03
                && byte(COMBAT_PTR + 0x253) <= 0x03
                && prev(byte(COMBAT_PTR + 0x254)) <= 0x0b
                && byte(COMBAT_PTR + 0x254) == 0xff
            )
    )
}

function friendly_used_special_action() {
    return bit5(COMBAT_PTR + 0x218) == 0x01 || bit6(COMBAT_PTR + 0x218) == 0x01
}

// Check that only friendlies and some designated team are alive.
// Usually this designated team is some exceptional NPC on a mission, i.e. Fumi on her second mission.
function only_friendly_teams_left_with_exception_team(exception_team_index) {
    return (
            // Case 1: one party member alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && prev(byte(COMBAT_PTR + 0x252) <= 0x0b)
                && byte(COMBAT_PTR + 0x252) == 0xff
            )
            ||
            // Case 2: two party members alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == exception_team_index)
                && prev(byte(COMBAT_PTR + 0x253) <= 0x0b)
                && byte(COMBAT_PTR + 0x253) == 0xff
            )
            ||
            // Case 3: three party members alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x253) <= 0x03 || byte(COMBAT_PTR + 0x253) == exception_team_index)
                && prev(byte(COMBAT_PTR + 0x254) <= 0x0b)
                && byte(COMBAT_PTR + 0x254) == 0xff
            )
            ||
            // Case 4: four party members alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x253) <= 0x03 || byte(COMBAT_PTR + 0x253) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x254) <= 0x03 || byte(COMBAT_PTR + 0x254) == exception_team_index)
                && prev(byte(COMBAT_PTR + 0x255)) <= 0x0b
                && byte(COMBAT_PTR + 0x255) == 0xff
            )
        )
}

// non trigger-y version of above
function only_friendly_teams_and_exception_team(exception_team_index) {
        return (
            // Case 1: one party member alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && byte(COMBAT_PTR + 0x252) == 0xff
            )
            ||
            // Case 2: two party members alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == exception_team_index)
                && byte(COMBAT_PTR + 0x253) == 0xff
            )
            ||
            // Case 3: three party members alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x253) <= 0x03 || byte(COMBAT_PTR + 0x253) == exception_team_index)
                && byte(COMBAT_PTR + 0x254) == 0xff
            )
            ||
            // Case 4: four party members alive
            (
                __ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x253) <= 0x03 || byte(COMBAT_PTR + 0x253) == exception_team_index)
                && __ornext(byte(COMBAT_PTR + 0x254) <= 0x03 || byte(COMBAT_PTR + 0x254) == exception_team_index)
                && byte(COMBAT_PTR + 0x255) == 0xff
            )
        )
}

// Checks if a specific team is alive in the current combat mission.
// Usually, if you care about this, you know that the unit is "special" so you should have a good idea
// of what order they got spawned in. I.e. you SHOULD know the index of the unit.
function check_specific_team_alive(expected_index, unit_name) {
    return ptr_valid(FULL_COMBAT_PTR)
        && byte(COMBAT_PTR + 0x284 + (0x27c) * expected_index) > 0
        && word(COMBAT_PTR + 0x276 + (0x27c) * expected_index) == enemy_id_by_name[unit_name]
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
    return prev(word(addr_unit_current_health + 0x02)) == word(addr_unit_current_health + 0x02)
        && prev(word(addr_unit_current_health)) <= word(addr_unit_current_health + 0x02)
        && prev(word(addr_unit_current_health)) > 0
        && word(addr_unit_current_health) == 0x00
}

// Determine if the specific unit was soft defeated.
// Some enemy leaders trigger mission events upon hitting 1HP.
function unit_soft_defeated(addr_unit_current_health) {
    return prev(word(addr_unit_current_health)) <= word(addr_unit_current_health + 0x02) && word(addr_unit_current_health) == 0x01
}

// Check that all characters are alive for plot purposes.
function all_characters_alive() {
    cond = always_true()
    for character in chararacter_ids_by_name {
        cond = cond && character_alive(character)
    }

    return cond
}

function character_died(char_name) {
    char_index = chararacter_ids_by_name[char_name] - 0x03

    return prev(bit1(0x00284dc2 + (0x10 * char_index)) == 0) && bit1(0x00284dc2 + (0x10 * char_index)) == 1
}

// Check if a character is still alive according to plot flags.
// Some characters can permanently die if you meet (or fail to meet) certain conditions.
function character_alive(char_name) {
    // for whatever reason no characters exist from 0x00 -> 0x02
    char_index = chararacter_ids_by_name[char_name] - 0x03

    return bit1(0x00284dc2 + (0x10 * char_index)) == 0
}

// Check that a specific character has been recruited.
function character_recruited(char_name) {
    // for whatever reason no characters exist from 0x00 -> 0x02
    char_index = chararacter_ids_by_name[char_name] - 0x03
    return prev(bit2(0x00284dc2 + (0x10 * char_index))) == 0x01 && bit2(0x00284dc2 + (0x10 * char_index)) == 0x00
}

// Many of the characters leave on Saturday. You have to successfully negotiate with them to come back.
function num_saturday_recruited_characters() {
    return bit0(0x00284b16)
        + bit1(0x00284b16)
        + bit2(0x00284b16)
        + bit3(0x00284b16)
        + bit4(0x00284b16)
        + bit5(0x00284b16)
        + bit6(0x00284b16)
        + bit1(0x00284b13)
        + bit6(0x00284b15)
}

// Check if the given team moved to the given tile on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param x the expected x-coordinate
// @param y the expected y-coordinate
function team_moves_to_coord(team_offset, x, y) => team_moves_to_x(team_offset, x) && team_moves_to_y(team_offset, y)

// Check if the given team moved to the given row on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param x the expected x-coordinate
function team_moves_to_x(team_offset, x) {
    return ptr_valid(FULL_COMBAT_PTR)
        // The team does need to be alive for this check to make sense
        && word(COMBAT_PTR + (0x27c * team_offset) + 0x284)  > 0 
        && prev(byte(COMBAT_PTR + (0x27c * team_offset) + 0x45f)) != x 
        && byte(COMBAT_PTR + (0x27c * team_offset) + 0x45f) == x
}

// Check if the given team moved to the given column on the active combat map.
// @param team_offset a value from 0x00 to 0x0b indicating which team is moving around
// @param y the expected y-coordinate
function team_moves_to_y(team_offset, y) {
    return ptr_valid(FULL_COMBAT_PTR)
        // The team does need to be alive for this check to make sense
        && word(COMBAT_PTR + (0x27c * team_offset) + 0x284) > 0 
        && prev(byte(COMBAT_PTR + (0x27c * team_offset) + 0x460)) != y 
        && byte(COMBAT_PTR + (0x27c * team_offset) + 0x460) == y
    return cond
}

// Given the index of a team, ensure that the leader's HP is full.
function team_leader_hp_full(team_offset) {
    return ptr_valid(FULL_COMBAT_PTR) 
        && word(COMBAT_PTR + (0x27c * team_offset) + 0x284) == word(COMBAT_PTR + (0x27c * team_offset) + 0x286)
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

// This is slightly distinct from num_teams_on_map as it's affirming "validity" of combat.
// This confirms if combat's in a good state to read from.
// We do this by reading the guaranteed turn order array and the projected one. They should be a match.
// If they're not, they should be off by exactly one, i.e. it's off because a team leader just died. 
function valid_teams_on_map() {
    cond = ptr_valid(FULL_COMBAT_PTR)
    for i in range(0, 11) {
        cond = cond && __ornext(
            byte(COMBAT_PTR + 0x250 + i) == byte(COMBAT_PTR + 0x250 + i + 0xc) || byte(COMBAT_PTR + 0x250 + i) == 0xff
        )
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

// Many perks are available from New Game Plus. Sometimes, we even care which ones are enabled!
function new_game_plus_perk_enabled(perk) {
    flag = always_true()

    if (perk == "Carry over 1 demon") {
        flag = bit0(0x00287074)
    } else if (perk == "Carry over 4 demons") {
        flag =  bit1(0x00287074)
    } else if (perk == "Carry over 8 demons") {
        flag = bit2(0x00287074)
    } else if (perk == "Carry over all demons") {
        flag = bit3(0x00287074)
    } else if (perk == "Carry over skills") {
        flag = bit4(0x00287074)
    } else if (perk == "Carry over Macca") {
        flag = bit5(0x00287074)
    } else if (perk == "Carry over auction") {
        flag = bit6(0x00287074)
    } else if (perk == "Remove EXP limit") {
        flag = bit7(0x00287074)
    } else if (perk == "10% off Compendium") {
        flag = bit0(0x00287075)
    } else if (perk == "30% off Compendium") {
        flag = bit1(0x00287075)
    } else if (perk == "50% off Compendium") {
        flag = bit2(0x00287075)
    } else if (perk == "Remove fusion LV limit") {
        flag = bit3(0x00287075)
    } else if (perk == "New Tuesday enemy") {
        flag = bit6(0x00287075)
    } else if (perk == "Unlock Mitama fusion") {
        flag = bit7(0x00287075)
    }

    return flag == 1
}

// Stub for now until I have logic for this.
function is_new_game_plus() {
    return __ornext(byte(0x00287074) > 0x00 || byte(0x00287075) > 0x00 || bit6(0x00284b1f) == 0x01 || bit7(0x00284b1f) == 0x01 || bit0(0x00284b20) == 0x01)
}
// Confirm we're on the ending path we intend to be on.
// @param one of ["Anguished One", "Daichi (Real)", "Daichi", "Ronaldo", "Yamato"]
function ending_selected(ending) {
    if (ending == "Anguished One") {
        return bit4(0x00284b10) == 0x01 && bit1(0x00284b10) == 0x00 && bit2(0x00284b10) == 0x00 && bit3(0x00284b10) == 0x00
    } else if (ending == "Yamato") {
        return bit2(0x00284b10) == 0x01 && bit1(0x00284b10) == 0x00 && bit3(0x00284b10) == 0x00 && bit4(0x00284b10) == 0x00
    } else if (ending == "Ronaldo") {
        return bit1(0x00284b10) == 0x01 && bit2(0x00284b10) == 0x00 && bit3(0x00284b10) == 0x00 && bit4(0x00284b10) == 0x00
    } else if (ending == "Daichi") {
        return bit3(0x00284b10) == 0x01 && bit1(0x00284b10) == 0x00 && bit2(0x00284b10) == 0x00 && bit4(0x00284b10) == 0x00
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
        && prev(byte(COMBAT_PTR + 0x24)) == 0x00 
        && byte(COMBAT_PTR + 0x24) == 0x02 
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

demons_by_race = {
    "Omega": ["Shiva", "Beiji-Weng", "Susano-o", "Kartikeya", "Wu Kong", "Chernobog", "Tonatiuh"],
    "Megami": ["Amaterasu", "Pallas Athena", "Norn", "Parvati", "Isis", "Laksmi", "Scathach", "Brigid", "Hathor", "Kikuri-Hime", "Sarasvati"],
    "Deity": ["Asura", "Lord Nan Dou", "Baal", "Alilat", "Lugh", "Osiris", "Mithra", "Inti", "Yama", "Odin", "Arahabaki", "Thor", "Mahakala"],
    "Vile": ["Nyarlathotep", "Tezcatlipoca", "Tao Tie", "Abaddon", "Pazuzu", "Baphomet", "Orcus"],
    "Snake": ["Hoyau Kamui", "Ananta", "Orochi", "Gucumatz", "Seiryuu", "Quetzalcoatl", "Gui Xian", "Pendragon", "Nozuchi", "Makara"],
    "Dragon": ["Vasuki", "Vritra", "Culebre", "Python", "Ym", "Asp", "Basilisk", "Bai Suzhen", "Toubyou"],
    "Divine": ["Metatron", "Remiel", "Kazfiel", "Aniel", "Lailah", "Power", "Angel"],
    "Avian": ["Da Peng", "Garuda", "Feng Huang", "Anzu", "Badb Catha", "Vidofnir", "Suparna", "Hamsa", "Moh Shuvuu", "Itsumade"],
    "Fallen": ["Satan", "Nebiros", "Agares", "Murmur", "Decarabia", "Orobas", "Bifrons", "Nisroc", "Botis", "Barbatos", "Flauros", "Abraxas", "Gagyson"],
    "Avatar": ["Anubis", "Barong", "Ukano Mitama", "Airavata", "Baihu", "Pabilsag", "Bai Ze", "Kamapua'a", "Shiisaa", "Apis", "Heqet"],
    "Beast": ["Fenrir", "Cerberus", "Myrmecolion", "Nue", "Cait Sith", "Orthrus", "Nekomata", "Hairy Jack", "Kabuso"],
    "Wilder": ["Ammut", "Behemoth", "Sleipnir", "Taown", "Mothman", "Xiezhai", "Afanc", "Garm", "Waira", "Hare of Inaba"],
    "Genma": ["Heimdall", "Jarilo", "Ganesha", "Kangiten", "Kresnik", "Kama", "Cu Chulainn", "Hanuman", "Tlaloc", "Ictinike", "Jambavan", "Tam Lin"],
    "Fairy": ["Oberon", "Titania", "Vivian", "Silky", "Lorelei", "Pyro Jack", "Jack Frost", "Kijimunaa", "Knocker", "Pixie"],
    "Tyrant": ["Lucifer", "Beelzebub", "Belial", "Nergal", "Astaroth", "Mot", "Loki", "Tzitzmitl", "Hecate", "Balor", "Moloch", "King Frost"],
    "Kishin": ["Zaou Gongen", "Ometeotl", "Bishamonten", "Koumokuten", "Jikokuten", "Zouchouten", "Take-Mikazuchi", "Hitokotonusi", "Nalagiri", "Ubelluris"],
    "Touki": ["Oumitsunu", "Nata Taishi", "Yaksa", "Lham Dearg", "Berserker", "Ikusa", "Mezuki", "Gozuki", "Bilwis", "Kobold"],
    "Jaki": ["Black Frost", "Grendel", "Rakshasa", "Girimehkala", "Legion", "Wendigo", "Ogun", "Mokoi", "Ogre", "Obariyon"],
    "Femme": ["Lilith", "Kali", "Anat", "Rangda", "Dzelarhons", "Hariti", "Ixtab", "Peri", "Yuki Jyorou", "Leanan Sidhe", "Lilim", "Kikimora"],
    "Ghost": ["Purple Mirror", "Kudlak", "Pisaca", "Loa", "Kumbhanda", "Tenong Cut", "Agathion", "Poltergeist"],
    "Fiend": ["Alice", "Trumpeter", "Billiken", "Sage of Time", "Ghost Q"],
    "Hero": ["Masakado", "Guan Yu", "Yoshitsune", "Jeanne d'Arc", "Hagen", "Neko Shogun"],
    "Element": ["Flaemis", "Aquans", "Aeros", "Erthys"],
    "Mitama": ["Nigi Mitama", "Ara Mitama", "Kusi Mitama", "Saki Mitama"],
}

function num_demons_of_race_registered(race) {
    demons = demons_by_race[race]

    cond = 0
    for demon in demons {
        cond = cond + demon_registered(demon)
    }

    return cond
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
    // End of character IDs 
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
    "Alcor":          0xd3,
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
    "Megrez Bud":     0x101,
    "Dragon":         0x103,
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
    "Benetnasch Bud": 0x12b,
    "Alcor (Alternate)": 0x130, // Alcor on Yamato's Way
    "Polaris A":        0x131,
    "Tall Woman":     0x134, // Makoto in Daichi's Crisis
    "Salaryman Carrying Food": 0x146, // in Girl in Pursuit. No, do not fix the indentation.
    "Polaris B":        0x15f,
    "Lilith (Hostile)": 0x162, // Version of Lilith that shows up in Original Wife
    "Polaris (Complete)": 0x163, // the actual fr fr final boss
    "Vacant Woman":   0x164, // Fumi in Demon-Hacked
    "Fumi (Hacking)": 0x167, // Fumi in Vs. Osaka, Ronaldo
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
    0xd3: "Alcor",
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
    0x101: "Megrez",
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
    0x12c: "Benetnasch",
    0x12d: "Benetnasch",
    0x12e: "Benetnasch",
    0x12f: "Benetnasch",
    0x130: "Alcor",
    0x131: "Polaris A",
    0x134: "Tall Woman",  // Makoto in Daichi's Crisis
    0x137: "Daichi (Tied Up)", // Daichi in Saving Daichi / Goodbye Jungo
    0x13f: "Guardian",
    0x140: "Guardian",
    0x141: "Guardian",
    0x143: "Guardian",
    0x146: "Salaryman Carrying Food", // in Girl in Pursuit
    0x149: "Student",
    0x152: "Ronaldo", // The clone in Daichi's Way - Restoration
    0x153: "Io", // The clone in Daichi's Way - Restoration
    0x154: "Yamato", // The clone in Daichi's Way - Restoration
    0x156: "Daichi", // The clone in Daichi's Way - Restoration
    0x15a: "Keita", // The clone in Daichi's Way - Restoration
    0x15f: "Polaris B",
    0x161: "Fumi",        // in Hacker Revealed
    0x162: "Lilith",      // in Original Wife
    0x163: "Polaris",
    0x164: "Vacant Woman", // Fumi in Demon-Hacked
    0x167: "Fumi" // Fumi in Vs. Osaka, Ronaldo edition
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

// 6 NG+ bosses, just following past me's patterns.
function new_game_plus_bosses_registered() {
    return demon_registered("Sage of Time")
        + demon_registered("Nebiros")
        + demon_registered("Lilith")
        + demon_registered("Belial")
        + demon_registered("Beelzebub")
        + demon_registered("Alice")
}

// Ordered in the order that the game stores them, not in the order listed by the game's Command Skill folder
COMMAND_SKILLS = {
    "Agi": bit2(0x00284a56),
    "Agidyne": bit3(0x00284a56),
    "Maragi": bit4(0x00284a56),
    "Maragidyne": bit5(0x00284a56),
    "Bufu": bit6(0x00284a56),
    "Bufudyne": bit7(0x00284a56),

    "Mabufu": bit0(0x00284a57),
    "Mabufudyne": bit1(0x00284a57),
    "Zio": bit2(0x00284a57),
    "Ziodyne": bit3(0x00284a57),
    "Mazio": bit4(0x00284a57),
    "Maziodyne": bit5(0x00284a57),
    "Zan": bit6(0x00284a57),
    "Zandyne": bit7(0x00284a57),

    "Mazan": bit0(0x00284a58),
    "Mazandyne": bit1(0x00284a58),
    "Megido": bit2(0x00284a58),
    "Megidolaon": bit3(0x00284a58),
    "Fire Dance": bit4(0x00284a58),
    "Ice Dance": bit5(0x00284a58),
    "Elec Dance": bit6(0x00284a58),
    "Force Dance": bit7(0x00284a58),

    "Holy Dance": bit0(0x00284a59),
    "Drain": bit1(0x00284a59),
    "Judgement": bit2(0x00284a59),
    "Petra Eyes": bit3(0x00284a59),
    "Paral Eyes": bit5(0x00284a59),
    "Death Call": bit6(0x00284a59),
    "Power Hit": bit7(0x00284a59),

    "Berserk": bit0(0x00284a5a),
    "Mighty Hit": bit1(0x00284a5a),
    "Anger Hit": bit2(0x00284a5a),
    "Brutal Hit": bit3(0x00284a5a),
    "Hassohappa": bit4(0x00284a5a),
    "Deathbound": bit5(0x00284a5a),
    "Weak Kill": bit6(0x00284a5a),

    "Gigajama": bit1(0x00284a5b),
    "Makarakarn": bit3(0x00284a5b),
    "Tetrakarn": bit4(0x00284a5b),
    "Might Call": bit5(0x00284a5b),
    "Shield All": bit6(0x00284a5b),
    "Taunt": bit7(0x00284a5b),

    "Dia": bit0(0x00284a5c),
    "Diarahan": bit1(0x00284a5c),
    "Media": bit2(0x00284a5c),
    "Mediarahan": bit3(0x00284a5c),
    "Amrita": bit4(0x00284a5c),
    "Prayer": bit5(0x00284a5c),
    "Recarm": bit6(0x00284a5c),
    "Samarecarm": bit7(0x00284a5c),

    "Piercing Hit ": bit2(0x00284a5e),
    "Multi-Hit": bit3(0x00284a5e),
    "Holy Strike": bit4(0x00284a5e),
    "Power Charge": bit5(0x00284a5e),
    "Sexy Gaze": bit6(0x00284a5e),
    "Marin Karin": bit7(0x00284a5e),

    "Extra Cancel": bit0(0x00284a5f),
    "Assassinate": bit1(0x00284a5f),
    "Fatal Strike": bit2(0x00284a5f),
    "Diarama": bit3(0x00284a5f),
    "Nigayomogi": bit4(0x00284a5f),
    "Recarmloss": bit5(0x00284a5f),
    "Mow Down": bit6(0x00284a5f),
    "Snipe": bit7(0x00284a5f),

    "Life Drain": bit0(0x00284a60),
    "Multi-Strike": bit1(0x00284a60),
    "Inferno": bit2(0x00284a60),
}

function check_num_command_skills() {
    total_learned = 0
    for skill in COMMAND_SKILLS {
        total_learned = total_learned + COMMAND_SKILLS[skill]
    }

    return total_learned
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
        bit6(0x00284a5b) + // Shield All
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
        bit4(0x00284a5f) + // Nigayomogi
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
function num_learned_skills() => num_learned_auto_skills() + check_num_command_skills() + num_learned_passive_skills()

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
    0x01: "a mysterious place", // No, I don't know where this is, it never popped up.
    0x02: "Akasaka Tunnel",
    0x03: "Akihabara Street",
    0x04: "Sensouji",
    0x05: "Toyo Anzu",
    0x06: "Sunset Blvd",
    0x07: "Eikokuji",
    0x08: "Fukutoshin Line Platform",
    0x09: "Omotesando",
    0x0a: "Kanda",
    0x0b: "Bugeikan",
    0x0c: "Sengakuji",
    0x0d: "Tokyo Tower",
    0x0e: "Shiba Park",
    0x0f: "Shibuya Q-TRONT",
    0x10: "Hanzoumon Line Platform",
    0x11: "Shibuya 901",
    0x12: "Shibuya Station",
    0x13: "a strange place", // I also don't know where this is.
    0x14: "a bizarre place", // Or this!
    0x15: "an unknown location", // Or even this!
    0x16: "Miyashita Park",
    0x17: "Cine City Plaza",
    0x18: "Kannagi-cho",
    0x19: "SL Plaza",
    0x1a: "Shinbashi Platform",
    0x1b: "Stadium",
    0x1c: "Diet Building",
    0x1d: "Nagata-cho, Tokyo Branch",
    0x1e: "Hibiya Park",
    0x1f: "some unforetold destination", // So rather than RP look weird, I'm going to 
    0x20: "Roppongi Crosswalk",
    0x21: "99 Plaza",
    0x22: "some unforeseen place", // leave a cryptic message
    0x23: "Tokyo Station, Central Exit",
    0x24: "Shinjuku Govt Plaza",
    0x25: "Multipurpose Hall",
    0x26: "a dangerous locale", // on every line
    0x27: "Miyashita Park",
    0x28: "Room ",
    0x29: "an unimpressive destination", // that I have no idea about!
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
    0x36: "a forgotten corner of Japan", // Maybe one day we'll figure out what all of this means.
    0x37: "Akasaka Mall",
    0x38: "Ebisu Bridge",
    0x39: "OCUT Plaza",
    0x3a: "Ten 7 Mall",
    0x3b: "Tennouji Station Turnstile",
    0x3c: "Nankou",
    0x3d: "Osaka Castle Park Square",
    0x3e: "Akasha Stratum",
    0x3f: "Osaka Branch", 
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
    0x52: "Nagoya Branch",
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
    "Father Time": 0x00b7, // This is the "Sage of Time" encounter
    "Necromancer": 0x00b8, // Nebiros
    "Original Wife": 0x00b9, // Lilith
    "The Inferno": 0x00ba, // Belial
    "Lord of Flies": 0x00bb, // Beelzebub
    "Innocent Soul": 0x00bc
}

// This is for events selected on the map
event_id_by_name = {
    "Death Clip":           0x3e9,
    "Daichi's Crisis":      0x3f1,
    "A Man Named Joe":      0x3f3,
    "Daichi's Worth":     0x3f4,
    "App Abuser":           0x7d4,
    "Never Say Die":        0x7d8,
    "Demon-Hacked":         0x7da,
    "Osaka Soul":           0x7dc,
    "Too Late":             0x7dd,
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
    "Under Attack":         0x177b,
    "Barrier Failure":      0x177d,
    "Lamhfhada":            0x1780,
    "The Dragon":           0x1783,
    "Food Chain":           0x1784,
    "Ronaldo Rises":        0x1785,
    "Vs. Tokyo":            0x1c85,
    "Seven Down":           0x1c96,
    "Dream's End":          0x206e,
    "Reared Head":          0x2071,
    "Strong Breaker":       0x2072,
    "New Tomorrow":         0x2073,
    "Shown Path":           0x20d3,
    "The Promise":          0x2432
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

    if (mission_name == "Osaka Soul" || mission_name == "Too Late") { 
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
        0x00284cb1,
        0x00284cb2,
        0x00284cb3,
        0x00284cb4,
        0x00284cb5,
        0x00284cb6,
        0x00284cb7,
        0x00284cb8,
        0x00284cb9,
        0x00284cbb,
        0x00284cc6,
        0x00284cc8,
        0x00284ccb,
        0x00284ccc,
        0x00284cce,
        0x00284ccf,
        0x00284cd0,
        0x00284cd5,
        0x00284cd6,
        0x00284cd7,
        0x00284cd8,
        0x00284cd9,
        0x00284ce6,
        0x00284ce7,
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
    } else if (mail_name == "Re: Billiken") {
        addr = 0x00284cba
    } else if (mail_name == "Re: Hitokotonusi") {
        addr = 0x00284cb8
    } else if (mail_name == "Re: Trumpeter") {
        addr = 0x00284cc0
    } else if (mail_name == "Re: Lilith") {
        addr = 0x00284cc6
    } else if (mail_name == "Re: Black Frost") {
        addr = 0x00284cc1
    }

    return byte(addr) != 0xff && prev(bit7(addr)) == 0x01 && bit7(addr) == 0x00
}

// For Saturday/Last Day, when everyone has literally the same mission name
function on_shared_mission(event_name) {
    if (event_name == "Seven Down") {
        return (
            MOST_RECENT_MISSION == 0x1c31 || // Daichi's Way
            MOST_RECENT_MISSION == 0x1c96 || // Al Saiduq
            MOST_RECENT_MISSION == 0x1bcc || // Yamato
            MOST_RECENT_MISSION == 0x1b68 // Ronaldo 
        )
    }
}

achievement(
    title = "[FOR DEV]Mailbox Hunt",
    description = "You got mail!",
    points = 0,
    trigger = !is_time_of_day(0, 0) && DAY <= 0x08 && mailbox_hunt_helper()
)

achievement(
    title = "[FOR DEV]Zone Change",
    description = "New zone where dis",
    points = 0,
    trigger = !is_time_of_day(0, 0) && (
        CURRENT_LOCATION == 0x01 ||
        CURRENT_LOCATION == 0x0a ||
        CURRENT_LOCATION == 0x13 ||
        CURRENT_LOCATION == 0x14 ||
        CURRENT_LOCATION == 0x15 ||
        CURRENT_LOCATION == 0x1a ||
        CURRENT_LOCATION == 0x1f ||
        CURRENT_LOCATION == 0x22 ||
        CURRENT_LOCATION == 0x26 ||
        CURRENT_LOCATION == 0x29 ||
        CURRENT_LOCATION == 0x36
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
        (prev(bit3(0x00284ad9)) == 0x00 && bit3(0x00284ad9) == 0x01) ||
        (prev(bit4(0x00284ad9)) == 0x00 && bit4(0x00284ad9) == 0x01) ||
        // 0x00284ada fully covered
        // 0x00284adb
        (prev(bit2(0x00284adb)) == 0x00 && bit2(0x00284adb) == 0x01) ||
        // 0x00284adc fully covered
        // 0x00284add
        (prev(bit1(0x00284add)) == 0x00 && bit1(0x00284add) == 0x01) ||
        (prev(bit2(0x00284add)) == 0x00 && bit2(0x00284add) == 0x01) ||
        (prev(bit7(0x00284add)) == 0x00 && bit7(0x00284add) == 0x01) ||
        // 0x00284ade
        (prev(bit5(0x00284ade)) == 0x00 && bit5(0x00284ade) == 0x01) ||
        (prev(bit6(0x00284ade)) == 0x00 && bit6(0x00284ade) == 0x01) ||
        // 0x00284adf fully covered
        // 0x00284ae0
        (prev(bit5(0x00284ae0)) == 0x00 && bit5(0x00284ae0) == 0x01) ||
        // 0x00284ae1
        (prev(bit1(0x00284ae1)) == 0x00 && bit1(0x00284ae1) == 0x01) ||
        // 0x00284ae2 
        (prev(bit0(0x00284ae2)) == 0x00 && bit0(0x00284ae2) == 0x01) ||
        (prev(bit3(0x00284ae2)) == 0x00 && bit3(0x00284ae2) == 0x01) ||
        (prev(bit4(0x00284ae2)) == 0x00 && bit4(0x00284ae2) == 0x01) ||
        (prev(bit5(0x00284ae2)) == 0x00 && bit5(0x00284ae2) == 0x01) ||
        (prev(bit6(0x00284ae2)) == 0x00 && bit6(0x00284ae2) == 0x01) ||
        // 0x00284ae3 fully covered
        // 0x00284ae4
        (prev(bit0(0x00284ae4)) == 0x00 && bit0(0x00284ae4) == 0x01) ||
        (prev(bit2(0x00284ae4)) == 0x00 && bit2(0x00284ae4) == 0x01) ||
        (prev(bit3(0x00284ae4)) == 0x00 && bit3(0x00284ae4) == 0x01) ||
        // 0x00284ae5
        (prev(bit5(0x00284ae5)) == 0x00 && bit5(0x00284ae5) == 0x01) ||
        // 0x00284ae6
        (prev(bit2(0x00284ae6)) == 0x00 && bit2(0x00284ae6) == 0x01) ||
        (prev(bit3(0x00284ae6)) == 0x00 && bit3(0x00284ae6) == 0x01) ||
        // 0x00284ae7
        (prev(bit1(0x00284ae7)) == 0x00 && bit1(0x00284ae7) == 0x01) ||
        (prev(bit2(0x00284ae7)) == 0x00 && bit2(0x00284ae7) == 0x01) ||
        (prev(bit7(0x00284ae7)) == 0x00 && bit7(0x00284ae7) == 0x01) ||
        // 0x00284ae8
        (prev(bit1(0x00284ae8)) == 0x00 && bit1(0x00284ae8) == 0x01) ||
        (prev(bit2(0x00284ae8)) == 0x00 && bit2(0x00284ae8) == 0x01) ||
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
        (prev(bit2(0x00284af2)) == 0x00 && bit2(0x00284af2) == 0x01) ||
        // 0x00284af3
        (prev(bit1(0x00284af3)) == 0x00 && bit1(0x00284af3) == 0x01) ||
        // 0x00284af4
        (prev(bit0(0x00284af4)) == 0x00 && bit0(0x00284af4) == 0x01) ||
        // 0x00284af5 fully covered
        // 0x00284af6
        (prev(bit1(0x00284af6)) == 0x00 && bit1(0x00284af6) == 0x01) ||
        (prev(bit2(0x00284af6)) == 0x00 && bit2(0x00284af6) == 0x01) ||
        (prev(bit3(0x00284af6)) == 0x00 && bit3(0x00284af6) == 0x01) ||
        (prev(bit4(0x00284af6)) == 0x00 && bit4(0x00284af6) == 0x01) ||
        (prev(bit5(0x00284af6)) == 0x00 && bit5(0x00284af6) == 0x01) ||
        // 0x00284af7
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
        // 0x00284b01 fully covered
        // 0x00284b02 fully covered
        // 0x00284b03
        (prev(bit3(0x00284b03)) == 0x00 && bit3(0x00284b03) == 0x01) ||
        // 0x00284b04 fully covered
        // 0x00284b05
        (prev(bit6(0x00284b05)) == 0x00 && bit6(0x00284b05) == 0x01) ||
        // 0x00284b06 fully covered
        // 0x00284b07 fully covered
        // 0x00284b08
        (prev(bit1(0x00284b08)) == 0x00 && bit1(0x00284b08) == 0x01) ||
        (prev(bit2(0x00284b08)) == 0x00 && bit2(0x00284b08) == 0x01) ||
        (prev(bit3(0x00284b08)) == 0x00 && bit3(0x00284b08) == 0x01) ||
        // 0x00284b09 fully covered
        // 0x00284b0a
        (prev(bit7(0x00284b0a)) == 0x00 && bit7(0x00284b0a) == 0x01) ||
        // 0x00284b0b fully covered
        // 0x00284b0c
        (prev(bit6(0x00284b0c)) == 0x00 && bit6(0x00284b0c) == 0x01) ||
        // 0x00284b0d
        (prev(bit0(0x00284b0d)) == 0x00 && bit0(0x00284b0d) == 0x01) ||
        (prev(bit7(0x00284b0d)) == 0x00 && bit7(0x00284b0d) == 0x01) ||
        // 0x00284b0e fully covered
        // 0x00284b0f
        (prev(bit4(0x00284b0f)) == 0x00 && bit4(0x00284b0f) == 0x01) ||
        // 0x00284b10
        (prev(bit5(0x00284b10)) == 0x00 && bit5(0x00284b10) == 0x01) ||
        (prev(bit7(0x00284b10)) == 0x00 && bit7(0x00284b10) == 0x01) ||
        // 0x00284b11
        (prev(bit0(0x00284b11)) == 0x00 && bit0(0x00284b11) == 0x01) ||
        (prev(bit1(0x00284b11)) == 0x00 && bit1(0x00284b11) == 0x01) ||
        (prev(bit4(0x00284b11)) == 0x00 && bit4(0x00284b11) == 0x01) ||
        (prev(bit5(0x00284b11)) == 0x00 && bit5(0x00284b11) == 0x01) ||
        (prev(bit6(0x00284b11)) == 0x00 && bit6(0x00284b11) == 0x01) ||
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
        // 0x00284b15
        (prev(bit1(0x00284b15)) == 0x00 && bit1(0x00284b15) == 0x01) ||
        (prev(bit2(0x00284b15)) == 0x00 && bit2(0x00284b15) == 0x01) ||
        (prev(bit5(0x00284b15)) == 0x00 && bit5(0x00284b15) == 0x01) ||
        // 0x00284b16
        (prev(bit7(0x00284b16)) == 0x00 && bit7(0x00284b16) == 0x01) ||
        // 0x00284b17
        (prev(bit0(0x00284b17)) == 0x00 && bit0(0x00284b17) == 0x01) ||
        (prev(bit1(0x00284b17)) == 0x00 && bit1(0x00284b17) == 0x01) ||
        (prev(bit2(0x00284b17)) == 0x00 && bit2(0x00284b17) == 0x01) ||
        (prev(bit3(0x00284b17)) == 0x00 && bit3(0x00284b17) == 0x01) ||
        (prev(bit4(0x00284b17)) == 0x00 && bit4(0x00284b17) == 0x01) ||
        (prev(bit5(0x00284b17)) == 0x00 && bit5(0x00284b17) == 0x01) ||
        // 0x00284b18
        (prev(bit0(0x00284b18)) == 0x00 && bit0(0x00284b18) == 0x01) ||
        (prev(bit2(0x00284b18)) == 0x00 && bit2(0x00284b18) == 0x01) ||
        (prev(bit7(0x00284b18)) == 0x00 && bit7(0x00284b18) == 0x01) ||
        // 0x00284b19
        (prev(bit0(0x00284b19)) == 0x00 && bit0(0x00284b19) == 0x01) ||
        (prev(bit2(0x00284b19)) == 0x00 && bit2(0x00284b19) == 0x01) ||
        (prev(bit4(0x00284b19)) == 0x00 && bit4(0x00284b19) == 0x01) ||
        (prev(bit5(0x00284b19)) == 0x00 && bit5(0x00284b19) == 0x01) ||
        (prev(bit6(0x00284b19)) == 0x00 && bit6(0x00284b19) == 0x01) ||
        // 0x00284b1a
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
        // 0x00284b1c
        (prev(bit3(0x00284b1c)) == 0x00 && bit3(0x00284b1c) == 0x01) ||
        (prev(bit5(0x00284b1c)) == 0x00 && bit5(0x00284b1c) == 0x01) ||
        (prev(bit6(0x00284b1c)) == 0x00 && bit6(0x00284b1c) == 0x01) ||
        (prev(bit7(0x00284b1c)) == 0x00 && bit7(0x00284b1c) == 0x01) ||
        // 0x00284b1d
        (prev(bit3(0x00284b1d)) == 0x00 && bit3(0x00284b1d) == 0x01) ||
        (prev(bit4(0x00284b1d)) == 0x00 && bit4(0x00284b1d) == 0x01) ||
        (prev(bit5(0x00284b1d)) == 0x00 && bit5(0x00284b1d) == 0x01) ||
        (prev(bit6(0x00284b1d)) == 0x00 && bit6(0x00284b1d) == 0x01) ||
        // 0x00284b1e
        (prev(bit1(0x00284b1e)) == 0x00 && bit1(0x00284b1e) == 0x01) ||
        (prev(bit2(0x00284b1e)) == 0x00 && bit2(0x00284b1e) == 0x01) ||
        (prev(bit3(0x00284b1e)) == 0x00 && bit3(0x00284b1e) == 0x01) ||
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
        (prev(bit5(0x00284b20)) == 0x00 && bit5(0x00284b20) == 0x01) ||
        // noooooooooooooooooooo it goes even further down here too!!
        // 0x00284b21
        (prev(bit0(0x00284b21)) == 0x00 && bit0(0x00284b21) == 0x01) ||
        (prev(bit1(0x00284b21)) == 0x00 && bit1(0x00284b21) == 0x01) ||
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
        (prev(bit4(0x00284b22)) == 0x00 && bit4(0x00284b22) == 0x01) ||
        (prev(bit5(0x00284b22)) == 0x00 && bit5(0x00284b22) == 0x01) ||
        (prev(bit6(0x00284b22)) == 0x00 && bit6(0x00284b22) == 0x01) ||
        (prev(bit7(0x00284b22)) == 0x00 && bit7(0x00284b22) == 0x01) ||
        // 0x00284b23
        (prev(bit0(0x00284b23)) == 0x00 && bit0(0x00284b23) == 0x01) ||
        (prev(bit1(0x00284b23)) == 0x00 && bit1(0x00284b23) == 0x01) ||
        (prev(bit2(0x00284b23)) == 0x00 && bit2(0x00284b23) == 0x01) ||
        (prev(bit3(0x00284b23)) == 0x00 && bit3(0x00284b23) == 0x01) ||
        (prev(bit4(0x00284b23)) == 0x00 && bit4(0x00284b23) == 0x01) ||
        (prev(bit5(0x00284b23)) == 0x00 && bit5(0x00284b23) == 0x01) ||
        (prev(bit6(0x00284b23)) == 0x00 && bit6(0x00284b23) == 0x01) ||
        (prev(bit7(0x00284b23)) == 0x00 && bit7(0x00284b23) == 0x01) ||
        // 0x00284b24
        (prev(bit0(0x00284b24)) == 0x00 && bit0(0x00284b24) == 0x01) ||
        (prev(bit1(0x00284b24)) == 0x00 && bit1(0x00284b24) == 0x01) ||
        (prev(bit2(0x00284b24)) == 0x00 && bit2(0x00284b24) == 0x01) ||
        (prev(bit3(0x00284b24)) == 0x00 && bit3(0x00284b24) == 0x01) ||
        (prev(bit4(0x00284b24)) == 0x00 && bit4(0x00284b24) == 0x01) ||
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
        (prev(bit3(0x00284b27)) == 0x00 && bit3(0x00284b27) == 0x01) ||
        (prev(bit4(0x00284b27)) == 0x00 && bit4(0x00284b27) == 0x01) ||
        (prev(bit5(0x00284b27)) == 0x00 && bit5(0x00284b27) == 0x01) ||
        (prev(bit6(0x00284b27)) == 0x00 && bit6(0x00284b27) == 0x01) ||
        (prev(bit7(0x00284b27)) == 0x00 && bit7(0x00284b27) == 0x01)
    )
)

// *** Achievements ***

// Progression

achievement(
    title = "False Alarm",
    description = "Prevent the death foretold in your own death clip.",
    points = 1,
    trigger =  is_day("Sunday") && actively_in_event() && on_mission("Death Clip") && all_allied_teams_last_standing(3),
    type = "progression",
    id=530957
)
achievement(
    title = "Just Needed Moral Support",
    description = "Have Daichi's team land the killing blow on Bai Suzhen in Daichi's Crisis.",
    points = 3,
    trigger = actively_in_event() 
        && on_mission("Daichi's Crisis")
        && (
            (attacker_leader_is("Daichi") && defender_leader_is("Bai Suzhen") && defender_leader_defeated()) || 
            (defender_leader_is("Daichi") && attacker_leader_is("Bai Suzhen") && attacker_leader_defeated())
        ),
    type = "missable",
    id=530986
)
achievement(
    title = "She's Sealed Away for a Reason",
    description = "Prevent the death foretold by the second death clip on Sunday.",
    points = 3,
    trigger = on_mission("Daichi's Crisis") && actively_in_event() &&active_mission_completed("Daichi's Crisis"),
    type = "progression",
    id=530958
)
achievement(
    title = "Taking on Troublesome Contracts",
    description = "Help Joe resolve his outstanding contract.",
    points = 2,
    trigger = on_mission("A Man Named Joe") && actively_in_event() && active_mission_completed("A Man Named Joe"),
    type = "progression",
    id=530959
)
achievement(
    title = "Alpha Ursae Majoris",
    description = "Get all allies to the escape area in Daichi's Worth without Dubhe killing any demons and without using Suspend.",
    points = 5,
    trigger = on_mission("Daichi's Worth")
        && never(loaded_from_suspend())
        // && disable_when(loaded_from_suspend(), until=MOST_RECENT_MISSION != 0x3f4)
        && bit3(0x00284aec) == 0x01
        && trigger_when(prev(word(TEAM_ARRAY_PTR + (0x27c * 0x04) + 0x0a)) == 0x114 && word(TEAM_ARRAY_PTR + (0x27c * 0x04) + 0x0a) == 0x115)
        && (
            disable_when(attacker_leader_is("Dubhe (Whole)") && defender_left_unit_defeated())
            && disable_when(attacker_leader_is("Dubhe (Whole)") && defender_right_unit_defeated())
            && disable_when(defender_leader_is("Dubhe (Whole)") && attacker_left_unit_defeated())
            && disable_when(defender_leader_is("Dubhe (Whole)") && attacker_right_unit_defeated())
        ),
    type = "missable",
    id=530960
)
achievement(
    title = "Dubious Dubhe",
    description = "Defeat Dubhe.",
    points = 5,
    trigger = actively_in_event() 
        && on_mission("Daichi's Worth") 
        && combat_actively_occurring()
        && specific_leader_defeated("Dubhe (Half)"),
    type = "progression",
    id=530961
)
achievement(
    title = "I Take My Volunteer Work Seriously",
    description = "Defeat all human enemies in App Abuser before any escape and without using Suspend.",
    points = 3,
    trigger = never(MOST_RECENT_MISSION != 0x7d4)
        && actively_in_event() 
        && on_mission("App Abuser")
        && on_grid_map()
        && never(loaded_from_suspend())
        && trigger_when(once(defender_leader_is("Punk") && defender_leader_defeated())) 
        && trigger_when(once(defender_leader_is("Salaryman") && defender_leader_defeated()))
        && trigger_when(once(defender_leader_is("Young Man") && defender_leader_defeated()))
        && disable_when(team_moves_to_y(0x04, 0x0e), until=MOST_RECENT_MISSION != 0x7d4)
        && disable_when(team_moves_to_y(0x05, 0x0e), until=MOST_RECENT_MISSION != 0x7d4)
        && disable_when(team_moves_to_y(0x06, 0x0e), until=MOST_RECENT_MISSION != 0x7d4),
    type = "missable",
    id = 546726
)
achievement(
    title = "Busting the 'valgate Party",
    description = "Complete 'Demon-Hacked'.",
    points = 5,
    trigger = actively_in_event() 
        && on_mission("Demon-Hacked") 
        && in_combat()
        && only_friendly_teams_left(),
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
        && actively_in_event()
        && trigger_when(active_mission_completed("Never Say Die")),
    type = "missable",
    id = 546542
)
achievement(
    title = "Take Me to the Men in Yellow",
    description = "Recruit Hinako to the party.",
    points = 2,
    trigger = actively_in_event() && on_mission("Never Say Die") && character_recruited("Hinako"),
    type = "progression",
    id=530962
)
achievement(
    id=597372,
    title = "Miasma Maestro",
    description = "On either of 'Osaka Soul' or 'Too Late', clear all of the miasma before any additional enemy teams are summoned and complete the mission without using Suspend.",
    points = 5,
    trigger = __ornext(MOST_RECENT_MISSION == event_id_by_name["Osaka Soul"] || MOST_RECENT_MISSION == event_id_by_name["Too Late"])
        && actively_in_event()
        && never(loaded_from_suspend())
        && disable_when(unit_respawns(), until= MOST_RECENT_MISSION != event_id_by_name["Osaka Soul"] && MOST_RECENT_MISSION != event_id_by_name["Too Late"])
        && trigger_when(bit0(0x00284b5a) == 0x01)
        && trigger_when(bit1(0x00284b5a) == 0x01)
        && trigger_when(bit2(0x00284b5a) == 0x01)
        && trigger_when(bit3(0x00284b59) == 0x01)
        && trigger_when(active_mission_completed("Osaka Soul")),
    type = "missable"
)
achievement(
    title = "Savior of the Angry",
    description = "Prevent the crisis foretold by Monday's death clip.",
    points = 3,
    trigger = bit1(0x00284aee) == 0x01 && actively_in_event() && on_mission("Osaka Soul") && character_alive("Keita") && character_recruited("Keita"),
    type = "missable",
    id=530963
)
achievement(
    title = "Beta Ursae Majoris",
    description = "Defeat Merak without it ever using Circumpolarity and without using Suspend.",
    points = 5,
    trigger = on_grid_map()
            && actively_in_event()  
            && on_mission("Merak Arrives") 
            && never(loaded_from_suspend())
            && trigger_when(combat_actively_occurring())
            && trigger_when(specific_leader_defeated("Merak"))
            && disable_when(prev(byte(TEAM_ARRAY_PTR + 0xc3b)) == 0x00 && byte(TEAM_ARRAY_PTR + 0xc3b) == 0x0a, until=MOST_RECENT_MISSION != 0x7e2),
    type = "missable",
    id=530964
)
achievement(
    title = "Meticulous Merak",
    description = "Defeat Merak.",
    points = 5,
    trigger = actively_in_event()  
        && on_mission("Merak Arrives")
        && combat_actively_occurring() 
        && specific_leader_defeated("Merak"),
    type = "progression",
    id=530965
)
achievement(
    title = "A Fun-Filled Q...!",
    description = "Defeat Ghost Q.",
    points = 10,
    trigger = is_day("Tuesday")
        && actively_in_event()  
        && on_mission("Vs. Q") 
        && combat_actively_occurring()
        && specific_leader_defeated("Ghost Q"),
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
    trigger = actively_in_event() 
        && on_mission("Hacker Revealed")
        && combat_actively_occurring() 
        && specific_leader_defeated("Botis"),
    type = "missable",
    id=530968
)
achievement(
    title = "Hmm... Mm?",
    description = "Complete 'Hacker Revealed.'",
    points = 3,
    trigger = actively_in_event() 
        && on_mission("Hacker Revealed") 
        && ptr_valid(FULL_COMBAT_PTR)
        && word(COMBAT_PTR + 0xee2) == 0x161
        && (
            // Fumi was already reduced to 1hp and we are cleaning up enemies
            (word(COMBAT_PTR + 0xef0) == 0x01 && only_friendly_teams_left_with_exception_team(0x05)) ||
            // All the other enemies have been cleaned up and we reduced Fumi to 1HP
            (
                (byte(COMBAT_PTR + 0x254) <= 0x03 || byte(COMBAT_PTR + 0x254) == 0x05) && 
                byte(COMBAT_PTR + 0x255) == 0xff &&
                prev(word(COMBAT_PTR + 0xef0)) > 0x01 &&
                word(COMBAT_PTR + 0xef0) == 0x01
            )
        ),
    type = "progression",
    id=530969
)
achievement(
    title = "Solid Snake Would Be Proud",
    description = "Escort Daichi to the rescue point in Saving Daichi.",
    points = 3,
    trigger = on_mission("Saving Daichi")
        && in_combat()
        && actively_in_event() 
        && bit4(0x00284b1f) == 0x01 
        && trigger_when(prev(bit5(0x00284b56)) == 0x00) 
        && trigger_when(bit5(0x00284b56) == 0x01),
    type = "missable",
    id=530970
)
achievement(
    title = "Savior of the Strong",
    description = "Prevent the crisis foretold by Tuesday's death clip.",
    points = 5,
    trigger = bit2(0x00284af1) == 0x01 
        && actively_in_event() 
        && on_mission("Saving Daichi") 
        && character_alive("Jungo") 
        && character_recruited("Jungo"),
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
    trigger = actively_in_event() 
        && on_mission("Man of Fury") 
        && num_teams_on_map(0x0a)
        && in_combat_mission("Man of Fury (Ronaldo)")
        // The underlying pointers here continue pointing to the associated defender/attacker until next combat is entered, so this is fine
        && trigger_when((defender_leader_is("Ronaldo") || attacker_leader_is("Ronaldo")))
        && trigger_when(prev(bit6(0x00284b59) == 0x00)) && trigger_when(bit6(0x00284b59) == 0x01)
        && trigger_when(prev(bit7(0x00284b59) == 0x00)) && trigger_when(bit7(0x00284b59) == 0x01),
    type = "missable"
)
achievement(
    title = "Gamma Ursae Majoris",
    description = "Defeat Phecda without using Suspend.",
    points = 10,
    trigger = never(loaded_from_suspend())
        && actively_in_event() 
        && on_mission("Man of Fury")
        // Phys already defeated, Magic being defeated
        && ((
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
    trigger = actively_in_event()  
        && on_mission("Man of Fury")
        // Phys already defeated, Magic being defeated
        && ((
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
    type = "progression",
    id=530972
)

// Check if the given unit is using Diastrophism.
// This is an ability specific to buds of septentriones. Megrez or Benetnasch.
// This ability can be dodged in one of a few ways:
// - nullify phys
// - be Avian
// - be Divine
function unit_using_diastrophism(team_id, enemy_name) {
    offset_to_team = 0x26c + (0x27c * team_id)
    offset_to_team_lead_id = 0xa
    offset_to_diastrophism_indicator = 0x5

    return byte(COMBAT_PTR + 0x250) == team_id
        && word(COMBAT_PTR + offset_to_team + offset_to_team_lead_id) == enemy_id_by_name[enemy_name]
        && byte(COMBAT_PTR + offset_to_team + offset_to_diastrophism_indicator) == 0x40
}

// Test cases:
// Bud of Malice, dodge/hit/dodge:
// Bud of Malice, dodge/invuln/dodge:
// Delta Battle, dodge/hit/dodge:
// Delta Battle, dodge/invuln/dodge:
achievement(
    title = "If Only People Could Float",
    // On any team with all members alive, have (at most) the team leader be damaged during Diastrophism.
    description = "On any team with all members alive, have only the team leader be damaged during Diastrophism.",
    points = 5,
    trigger = actively_in_event()
        && (
            is_day("Wednesday")
            && on_mission("Bud of Malice")
            && unit_using_diastrophism(4, "Megrez Bud") 
            && (
                    (
                        word(COMBAT_PTR + 0x284) > 0 
                        && prev(word(COMBAT_PTR + 0x284)) > word(COMBAT_PTR + 0x284) 
                        && prev(word(COMBAT_PTR + 0x328)) == word(COMBAT_PTR + 0x328)
                        && word(COMBAT_PTR + 0x328) > 0
                        && prev(word(COMBAT_PTR + 0x3c8)) == word(COMBAT_PTR + 0x3c8)
                        && word(COMBAT_PTR + 0x3c8) > 0
                    ) ||
                    // team 1
                    (
                        word(COMBAT_PTR + 0x500) > 0 
                        && prev(word(COMBAT_PTR + 0x500)) > word(COMBAT_PTR + 0x500) 
                        && prev(word(COMBAT_PTR + 0x5a4)) == word(COMBAT_PTR + 0x5a4) 
                        && word(COMBAT_PTR + 0x5a4) > 0
                        && prev(word(COMBAT_PTR + 0x646)) == word(COMBAT_PTR + 0x646)
                        && word(COMBAT_PTR + 0x646) > 0
                    ) ||
                    // team 2
                    (
                        word(COMBAT_PTR + 0x77c) > 0 
                        && prev(word(COMBAT_PTR + 0x77c)) > word(COMBAT_PTR + 0x77c) 
                        && prev(word(COMBAT_PTR + 0x820)) == word(COMBAT_PTR + 0x820)
                        && word(COMBAT_PTR + 0x820) > 0 
                        && prev(word(COMBAT_PTR + 0x8c4)) == word(COMBAT_PTR + 0x8c4)
                        && word(COMBAT_PTR + 0x8c4) > 0
                    ) ||
                    // team 3
                    (
                        word(COMBAT_PTR + 0x9f8) > 0 
                        && prev(word(COMBAT_PTR + 0x9f8)) > word(COMBAT_PTR + 0x9f8) 
                        && prev(word(COMBAT_PTR + 0xa9c)) == word(COMBAT_PTR + 0xa9c) 
                        && word(COMBAT_PTR + 0xa9c) > 0
                        && prev(word(COMBAT_PTR + 0xb40)) == word(COMBAT_PTR + 0xb40)
                        && word(COMBAT_PTR + 0xb40) > 0
                    )
            )
        )
        ||
        (
            is_day("Wednesday")
            && on_mission("Delta Battle")
            && (unit_using_diastrophism(5, "Megrez Bud") 
                || unit_using_diastrophism(6, "Megrez Bud") 
                || unit_using_diastrophism(7, "Megrez Bud")
                || unit_using_diastrophism(8, "Megrez Bud")
                || unit_using_diastrophism(9, "Megrez Bud")
                || unit_using_diastrophism(10, "Megrez Bud")
                || unit_using_diastrophism(11, "Megrez Bud")
            )
            && (
                    (
                        word(COMBAT_PTR + 0x284) > 0 
                        && prev(word(COMBAT_PTR + 0x284)) > word(COMBAT_PTR + 0x284) 
                        && prev(word(COMBAT_PTR + 0x328)) == word(COMBAT_PTR + 0x328)
                        && word(COMBAT_PTR + 0x328) > 0
                        && prev(word(COMBAT_PTR + 0x3c8)) == word(COMBAT_PTR + 0x3c8)
                        && word(COMBAT_PTR + 0x3c8) > 0
                    ) ||
                    // team 1
                    (
                        word(COMBAT_PTR + 0x500) > 0 
                        && prev(word(COMBAT_PTR + 0x500)) > word(COMBAT_PTR + 0x500) 
                        && prev(word(COMBAT_PTR + 0x5a4)) == word(COMBAT_PTR + 0x5a4) 
                        && word(COMBAT_PTR + 0x5a4) > 0
                        && prev(word(COMBAT_PTR + 0x646)) == word(COMBAT_PTR + 0x646)
                        && word(COMBAT_PTR + 0x646) > 0
                    ) ||
                    // team 2
                    (
                        word(COMBAT_PTR + 0x77c) > 0 
                        && prev(word(COMBAT_PTR + 0x77c)) > word(COMBAT_PTR + 0x77c) 
                        && prev(word(COMBAT_PTR + 0x820)) == word(COMBAT_PTR + 0x820)
                        && word(COMBAT_PTR + 0x820) > 0 
                        && prev(word(COMBAT_PTR + 0x8c4)) == word(COMBAT_PTR + 0x8c4)
                        && word(COMBAT_PTR + 0x8c4) > 0
                    ) ||
                    // team 3
                    (
                        word(COMBAT_PTR + 0x9f8) > 0 
                        && prev(word(COMBAT_PTR + 0x9f8)) > word(COMBAT_PTR + 0x9f8) 
                        && prev(word(COMBAT_PTR + 0xa9c)) == word(COMBAT_PTR + 0xa9c) 
                        && word(COMBAT_PTR + 0xa9c) > 0
                        && prev(word(COMBAT_PTR + 0xb40)) == word(COMBAT_PTR + 0xb40)
                        && word(COMBAT_PTR + 0xb40) > 0
                    )
            )
        )
        ||
        // case: Seven Down
        (
            is_day("Saturday")
            && on_shared_mission("Seven Down")
            && (unit_using_diastrophism(9, "Benetnasch Bud")|| unit_using_diastrophism(10, "Benetnasch Bud"))
            && (
                    (
                        word(COMBAT_PTR + 0x284) > 0 
                        && prev(word(COMBAT_PTR + 0x284)) > word(COMBAT_PTR + 0x284) 
                        && prev(word(COMBAT_PTR + 0x328)) == word(COMBAT_PTR + 0x328)
                        && word(COMBAT_PTR + 0x328) > 0
                        && prev(word(COMBAT_PTR + 0x3c8)) == word(COMBAT_PTR + 0x3c8)
                        && word(COMBAT_PTR + 0x3c8) > 0
                    ) ||
                    // team 1
                    (
                        word(COMBAT_PTR + 0x500) > 0 
                        && prev(word(COMBAT_PTR + 0x500)) > word(COMBAT_PTR + 0x500) 
                        && prev(word(COMBAT_PTR + 0x5a4)) == word(COMBAT_PTR + 0x5a4) 
                        && word(COMBAT_PTR + 0x5a4) > 0
                        && prev(word(COMBAT_PTR + 0x646)) == word(COMBAT_PTR + 0x646)
                        && word(COMBAT_PTR + 0x646) > 0
                    ) ||
                    // team 2
                    (
                        word(COMBAT_PTR + 0x77c) > 0 
                        && prev(word(COMBAT_PTR + 0x77c)) > word(COMBAT_PTR + 0x77c) 
                        && prev(word(COMBAT_PTR + 0x820)) == word(COMBAT_PTR + 0x820)
                        && word(COMBAT_PTR + 0x820) > 0 
                        && prev(word(COMBAT_PTR + 0x8c4)) == word(COMBAT_PTR + 0x8c4)
                        && word(COMBAT_PTR + 0x8c4) > 0
                    ) ||
                    // team 3
                    (
                        word(COMBAT_PTR + 0x9f8) > 0 
                        && prev(word(COMBAT_PTR + 0x9f8)) > word(COMBAT_PTR + 0x9f8) 
                        && prev(word(COMBAT_PTR + 0xa9c)) == word(COMBAT_PTR + 0xa9c) 
                        && word(COMBAT_PTR + 0xa9c) > 0
                        && prev(word(COMBAT_PTR + 0xb40)) == word(COMBAT_PTR + 0xb40)
                        && word(COMBAT_PTR + 0xb40) > 0
                    )
            )        
        )
        ,
    type = "missable"
)
achievement(
    title = "Warm and Fuzzy Foe",
    description = "Defeat Neko Shogun in A Hard Choice.",
    points = 5,
    trigger = actively_in_event() 
        && on_mission("A Hard Choice")
        && combat_actively_occurring() 
        && specific_leader_defeated("Neko Shogun"),
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
    description = "Prevent the crisis foretold by Wednesday's death clip.",
    points = 5,
    trigger = MOST_RECENT_MISSION == 0xfb0 && character_alive("Joe") && character_recruited("Joe"),
    type = "missable",
    id=546535
)
achievement(
    title = "Delta Ursae Majoris",
    description = "Win the Delta Battle mission without clearing any of the miasma.",
    points = 5,
    trigger = actively_in_event() 
        && on_mission("Delta Battle")
        && bit1(0x00284b58) == 0x00
        && bit2(0x00284b58) == 0x00
        && bit3(0x00284b58) == 0x00
        && bit4(0x00284b58) == 0x00
        && trigger_when(combat_actively_occurring())
        && trigger_when(specific_leader_defeated("Megrez")),
    type = "missable"
)
achievement(
    title = "Marooned Megrez",
    description = "Defeat Megrez.",
    points = 10,
    trigger = actively_in_event() 
        && on_mission("Delta Battle")
        && combat_actively_occurring() 
        && specific_leader_defeated("Megrez"),
    type = "progression",
    id = 546547
)
// ** Thursday Missions **
achievement(
    title = "It's Showtime",
    description = "Complete the 'Poisonous Day' mission and unlock Hitokotonusi.",
    points = 5,
    trigger = is_day("Thursday") && on_mission("Poisonous Day") && mail_triggered("Re: Hitokotonusi"),
    type = "progression",
    id = 546543
)
// To reproduce: Hinako, then Airi. Airi's FATE stage goes up by 1 as well when you successfully do this
achievement(
    title = "Recreating the Legend of Pasaputa",
    description = "Successfully recruit two of your teammates to help recreate the legend of Pasaputa before JPs reconvenes.",
    points = 1,
    trigger = is_day("Thursday") 
        && bit0(0x00284af9) == 0x01 // Please, Hinako
        && bit1(0x00284af9) == 0x01 // Please, Airi
        && bit4(0x00284b12) == 0x01 // Airi agrees to be sexy, but only after you've asked Hinako to dance
        && bit3(0x00284af9) == 0x00 // For the Interception has NOT started
        && prev(bit2(0x00284af9)) == 0x00 && bit2(0x00284af9) == 0x01, // and Yamato has just called you asking about proggers, 
    type= "missable",
    id = 546546
)
achievement(
    id = 590387,
    title ="I'm Bringing Sexy Ban",
    description = "Have Airi defeat Kama during the 'Ananga' mission.",
    points = 3,
    trigger = is_day("Thursday") && actively_in_event() && on_mission("Ananga") && trigger_when(specific_leader_soft_defeated_by("Kama", "Airi")),
    type = "missable"
)
achievement(
    id = 593551,
    title = "A Summoning via Lasya",
    description = "Complete the 'Nataraja' mission with Hinako having never been damaged during her dance and without using Suspend.",
    points = 5,
    trigger = is_day("Thursday")
        && actively_in_event()
        && on_mission("Nataraja")
        && !loaded_from_suspend()
        && disable_when(
            (word(COMBAT_PTR + 0x1b4e) == 0x0c  && once(prev(word(COMBAT_PTR + 0x1b5e)) > word(COMBAT_PTR + 0x1b5c))),
            until=!on_mission("Nataraja")
        )
        && trigger_when(only_friendly_teams_left_with_exception_team(0x0a)),
    type = "missable"
)
achievement(
    title = "(Bifrons Actually Required)",
    description = "Defeat Bifrons in either of 'Unexpected Hostility' or 'Victim of Foul Play'.",
    points = 10,
    trigger = actively_in_event() 
        && (on_mission("Unexpected Hostility") || on_mission("Victim of Foul Play"))
        && (attacker_leader_is("Bifrons") || defender_leader_is("Bifrons"))
        && prev(bit4(0x00284b15)) == 0x00 
        && bit4(0x00284b15) == 0x01,
    type = "missable",
    id = 546544
)
achievement(
    title = "The Savior's Savior",
    description = "Prevent the crisis shown by Thursday's death clip.",
    points = 5,
    trigger = bit1(0x00284afa) == 0x01
        && actively_in_event() 
        && on_mission("Unexpected Hostility") 
        && character_alive("Otome") 
        && character_recruited("Otome"),
    type = "missable",
    id = 546545
)
achievement(
    title = "Epsilon Ursae Majoris",
    description = "Defeat Alioth without usage of the neutralizing agent.",
    points = 10,
    // 
    trigger = actively_in_event()
        && on_mission("Alioth Core") 
        && bit2(0x00284b58) != 0x01
        && disable_when(
            // When the mission's done, only MC + Alioth are left in turn order. Regardless of who you deployed.
            // To prevent misfires, we're checking that is the case AND Alioth's HP has been 0 for more than a few frames.
            byte(COMBAT_PTR + 0x250) == 0x00 && 
            byte(COMBAT_PTR + 0x251) == 0x04 && 
            byte(COMBAT_PTR + 0x252) == 0xff && 
            word(COMBAT_PTR + 0xc74) == prev(word(COMBAT_PTR + 0xc74)) &&
            word(COMBAT_PTR + 0xc74) == 0x00
        , until=!on_mission("Alioth Core"))
        && trigger_when(combat_actively_occurring())
        && trigger_when(specific_leader_defeated("Alioth Core")),
    type = "missable",
    id = 547508
)
achievement(
    title = "Antagonizing Alioth",
    description = "Defeat Alioth.",
    points = 10,
    trigger = actively_in_event()
        && on_mission("Alioth Core")
        && combat_actively_occurring()
        && specific_leader_defeated("Alioth Core"),
    type = "progression",
    id = 546585
)

achievement(
    title = "Let's See Those Wallets",
    description = "Complete the 'God of Luck' mission and receive mail about Billiken afterward.",
    points = 10,
    trigger = MOST_RECENT_MISSION == event_id_by_name["God of Luck"] && mail_triggered("Re: Billiken"),
    type = "missable",
    id = 546680
)
achievement(
    id = 594834,
    title = "Unparalleled Regeneration",
    description = "Complete the 'Under Attack' mission.",
    points = 3,
    type = "progression",
    trigger = actively_in_event() && on_mission("Under Attack") && only_friendly_teams_left()
)
achievement(
    title = "Chilly Crater Combat",
    description = "Complete the 'Barrier Failure' mission and witness the ensuing events.",
    points = 5,
    trigger = actively_in_event() && on_mission("Barrier Failure") && prev(bit5(0x00284b00)) == 0x00 && bit5(0x00284b00) == 0x01,
    type = "progression",
    id = 547006
)

achievement(
    id = 594849,
    title = "Power Attracts",
    description = "Collect all of Lugh's fragments of energy.",
    points = 3,
    type = "progression",
    trigger = actively_in_event() && on_mission("Lamhfhada") && only_friendly_teams_left()
)
achievement(
    id = 594850,
    title = "Demon Delivery Service",
    description = "On 'Lamhfhada', complete the mission without actively picking up energy yourself and without using the Suspend feature.",
    points = 3,
    trigger = actively_in_event() 
        // && on_mission("Lamhfhada")
        && never(loaded_from_suspend())
        && never(!on_mission("Lamhfhada"))
        && once(prev(byte(COMBAT_PTR + 0x24c) == 0x00) && byte(COMBAT_PTR + 0x24c) == 0x05)
        && disable_when(once(ptr_valid(FULL_COMBAT_PTR) && friendly_used_special_action()), until=!on_mission("Lamhfhada"))
        // && byte(COMBAT_PTR + 0x218) > 0 && 
        // The following is a carbon copy of only_friendly_teams_left(), except that it has trigger_whens
        // We cannot apply trigger_when to the current form of only_friendly_teams_left(). "Too complex"
        && (
            // Case 1: one party member alive
            (
                trigger_when(byte(COMBAT_PTR + 0x250) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x251) == byte(COMBAT_PTR + 0x251 + 12))
                && trigger_when(prev(byte(COMBAT_PTR + 0x251) <= 0x0b))
                && trigger_when(byte(COMBAT_PTR + 0x251) == 0xff)
            )
            ||
            // Case 2: two party members alive
            (
                trigger_when(byte(COMBAT_PTR + 0x250) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x251) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x252) == byte(COMBAT_PTR + 0x252 + 12))
                && trigger_when(prev(byte(COMBAT_PTR + 0x252) <= 0x0b))
                && trigger_when(byte(COMBAT_PTR + 0x252) == 0xff)
            )
            ||
            // Case 3: three party members alive
            (
                trigger_when(byte(COMBAT_PTR + 0x250) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x251) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x252) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x253) == byte(COMBAT_PTR + 0x253 + 12))
                && trigger_when(prev(byte(COMBAT_PTR + 0x253) <= 0x0b))
                && trigger_when(byte(COMBAT_PTR + 0x253) == 0xff)
            )
            ||
            // Case 4: four party members alive
            (
                trigger_when(byte(COMBAT_PTR + 0x250) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x251) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x252) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x253) <= 0x03)
                && trigger_when(byte(COMBAT_PTR + 0x254) == byte(COMBAT_PTR + 0x254 + 12))
                && trigger_when(prev(byte(COMBAT_PTR + 0x254)) <= 0x0b)
                && trigger_when(byte(COMBAT_PTR + 0x254) == 0xff)
            )
    ),
    type = "missable"
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
achievement(
    title = "Trial of the Dragon",
    description = "Call forth the Dragon Stream using Lugh's power.",
    points = 10,
    trigger = actively_in_event()
        && on_mission("The Dragon") 
        && ((character_alive("Io") && character_recruited("Io")) || (prev(bit7(0x00284b11)) == 0x00 && bit7(0x00284b11) == 0x01)),
    type = "progression",
    id = 547042
)
achievement(
    id = 594973,
    title = "Savior of the Timid",
    description = "Prevent the crisis shown in the death clip on Friday.",
    points = 5,
    trigger = actively_in_event() && on_mission("The Dragon") && character_alive("Io") && character_recruited("Io"),
    type = "missable"
)

achievement(
    id = 594999,
    title = "Zeta Ursae Majoris",
    description = "Deploy 4 teams to the Food Chain mission and defeat Mizar with all team leaders alive.",
    points = 10,
    trigger = actively_in_event()
        && on_mission("Food Chain") 
        && player_teams_alive(4)
        && trigger_when(bit1(0x00284b55) == 0x01) 
        && trigger_when(bit2(0x00284b55) == 0x01)
        && trigger_when(bit3(0x00284b55) == 0x01)
        && trigger_when(bit4(0x00284b55) == 0x01)
        && trigger_when(combat_actively_occurring())
        && ( 
            (trigger_when(bit4(0x00284b54) == 0x01) && trigger_when(specific_leader_defeated("Mizar Tentacle (3R)"))) ||
            (trigger_when(bit3(0x00284b54) == 0x01) && trigger_when(specific_leader_defeated("Mizar Tentacle (3L)")))
        ),
    type = "missable"
)
achievement(
    title = "Mizar (No Longer) Multiply",
    description = "Defeat Mizar.",
    points = 10,
    trigger = actively_in_event()
        && on_mission("Food Chain") 
        && bit1(0x00284b55) == 0x01 
        && bit2(0x00284b55) == 0x01 
        && bit3(0x00284b55) == 0x01 
        && bit4(0x00284b55) == 0x01
        && trigger_when(combat_actively_occurring())
        && (
            (bit4(0x00284b54) == 0x01 && specific_leader_defeated("Mizar Tentacle (3R)")) ||
            (bit3(0x00284b54) == 0x01 && specific_leader_defeated("Mizar Tentacle (3L)"))
        ),
    type = "progression",
    id = 547043
)
achievement(
    title = "Savior of the Loyal",
    description = "Prevent the crisis shown in Friday's second death clip.",
    points = 5,
    trigger = actively_in_event() && on_mission("Ronaldo Rises") && character_alive("Makoto") && character_recruited("Makoto"),
    type = "missable",
    id = 547045
)

// ** Shared Saturday Missions **
achievement(
    title = "The Destroyer",
    description = "Defeat Shiva in Vs. Tokyo.",
    points = 10,
    trigger = combat_actively_occurring()
    && (
        on_branching_mission("Vs. Tokyo", "Ronaldo")
        || on_branching_mission("Vs. Tokyo", "Al Saiduq")
        || on_branching_mission("Vs. Tokyo", "Yamato")    
    ) && specific_leader_defeated("Shiva"),
    type = "missable",
    id = 547044
)
// This is effectively "unlock Lugh" but unlocks at the end of the fight vs. on mail trigger
achievement(
    id = 596422,
    title = "Now, Everyone! Rise Up!",
    description = "Complete the 'Settling Up' mission with the enemy team at full power.",
    points = 5,
    trigger = __ornext(on_branching_mission("Settling Up", "Ronaldo") ||
                on_branching_mission("Settling Up", "Al Saiduq") ||
                on_branching_mission("Settling Up", "Yamato")
            ) && character_alive("Io") && only_friendly_teams_left(),
    type = "missable"
)

achievement(
    id = 597869,
    title = "How Many Demons Could a Phone Hold, Anyway?",
    description = "On Vs. Osaka, defeat Fumi last.",
    points = 5,
    type = "missable",
    // do this one at a time
    trigger = (
        __ornext(on_branching_mission("Vs. Osaka", "Anguished One") || on_branching_mission("Vs. Osaka", "Daichi"))
        && bit2(COMBAT_PTR + 0xc5c) == 0x00 
        && bit2(COMBAT_PTR + 0xed8) == 0x00
        && bit2(COMBAT_PTR + 0x1154) == 0x00
        && bit2(COMBAT_PTR + 0x13d0) == 0x00
        && bit2(COMBAT_PTR + 0x164c) == 0x01
        && word(COMBAT_PTR + 0x1656) == enemy_id_by_name["Fumi"] 
        && bit2(COMBAT_PTR + 0x18c8) == 0x00
        && bit2(COMBAT_PTR + 0x1b44) == 0x00
        && bit2(COMBAT_PTR + 0x1dc0) == 0x00
        && combat_actively_occurring()
        && specific_leader_defeated("Fumi")
    ) || (
        on_branching_mission("Vs. Osaka", "Ronaldo")
        && bit2(COMBAT_PTR + 0xc5c) == 0x01 
        && word(COMBAT_PTR + 0xc66) == enemy_id_by_name["Fumi (Hacking)"]
        && bit2(COMBAT_PTR + 0xed8) == 0x00
        && bit2(COMBAT_PTR + 0x1154) == 0x00
        && bit2(COMBAT_PTR + 0x13d0) == 0x00
        && bit2(COMBAT_PTR + 0x164c) == 0x00
        && bit2(COMBAT_PTR + 0x18c8) == 0x00
        && bit2(COMBAT_PTR + 0x1b44) == 0x00
        && bit2(COMBAT_PTR + 0x1dc0) == 0x00
        && combat_actively_occurring()
        && specific_leader_defeated("Fumi (Hacking)")
    )
)

achievement(
    title = "Eta Ursae Majoris",
    description = "Defeat Benetnasch with Trumpeter having been hit no more than two times.",
    points = 5,
    trigger = actively_in_event()
        && __ornext(on_shared_mission("Seven Down"))
        // pseudologic: 
        // - enemy slot where Trumpeter is, is actually Trumpeter && never curr_hp < max_hp
        // - main Benetnasch defeated
        // - each child Benetnasch defeated
        && word(COMBAT_PTR + 0xef2) == 561
        && word(COMBAT_PTR + 0xee2) == 0xbe
        && disable_when(tally(3, prev(word(COMBAT_PTR + 0xef0)) > word(COMBAT_PTR + 0xef0)), until=!__ornext(on_shared_mission("Seven Down")))
        // sanity checking that at least one of the Benetnasch splits is on the field. presuming they can spawn in any order
        && trigger_when(__ornext(
            (word(COMBAT_PTR + 0xc66) == 0x12c) ||
            (word(COMBAT_PTR + 0xc66) == 0x12d) ||
            (word(COMBAT_PTR + 0xc66) == 0x12e) ||
            (word(COMBAT_PTR + 0xc66) == 0x12f)
        ))
        && (
            // one party member, trumpeter, one enemy
            (
                trigger_when(__ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == 0x05))
                && trigger_when(prev(byte(COMBAT_PTR + 0x252)) <= 0x08)
                && trigger_when(byte(COMBAT_PTR + 0x252) == 0xff)
            ) 
            // two party members, trumpeter, one enemy
            ||
            (
                trigger_when(__ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == 0x05))
                && trigger_when(prev(byte(COMBAT_PTR + 0x253)) <= 0x08)
                && trigger_when(byte(COMBAT_PTR + 0x253) == 0xff)

            )
            // three party members, trumpeter, one enemy
            ||
            (
                trigger_when(__ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x253) <= 0x03 || byte(COMBAT_PTR + 0x253) == 0x05))
                && trigger_when(prev(byte(COMBAT_PTR + 0x254)) <= 0x08)
                && trigger_when(byte(COMBAT_PTR + 0x254) == 0xff)
            )
            ||
            // four party members, trumpeter, one enemy
            (
                trigger_when(__ornext(byte(COMBAT_PTR + 0x250) <= 0x03 || byte(COMBAT_PTR + 0x250) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x251) <= 0x03 || byte(COMBAT_PTR + 0x251) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x252) <= 0x03 || byte(COMBAT_PTR + 0x252) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x253) <= 0x03 || byte(COMBAT_PTR + 0x253) == 0x05))
                && trigger_when(__ornext(byte(COMBAT_PTR + 0x254) <= 0x03 || byte(COMBAT_PTR + 0x254) == 0x05))
                && trigger_when(prev(byte(COMBAT_PTR + 0x255)) <= 0x08)
                && trigger_when(byte(COMBAT_PTR + 0x255) == 0xff)
            )
        ),
    type = "missable"
)
achievement(
    title = "Only the Administrator Remains",
    description = "Defeat Benetnasch.",
    points = 25,
    trigger = __ornext(on_shared_mission("Seven Down"))
        && mail_triggered("Re: Trumpeter"),
    type = "progression"
)
achievement(
    id = 596710,
    title = "Messenger of Love and Justice",
    description = "Defeat Black Frost on the final day.",
    points = 10,
    // Missable because of two reasons: You need to be on Not Anguished One's path, AND you must have defeated Botis
    type = "missable",
    trigger = is_day("Final Day") 
    && __ornext(
        on_branching_mission("Shown Path", "Daichi") ||
        on_branching_mission("Shown Path", "Yamato") ||
        on_branching_mission("Shown Path", "Ronaldo")
    ) 
    && combat_actively_occurring()
    && specific_leader_defeated("Black Frost")
)
achievement(
    id = 596774,
    title = "Saving the Best for Last",
    description = "Defeat the Dragon last on either of 'Unexpected Battle' or 'Reared Head.'",
    points = 5,
    type = "missable",
    trigger = actively_in_event()
        && __ornext(
            on_mission("Reared Head") ||
            on_branching_mission("Unexpected Battle", "Daichi (Restorer)") ||
            on_branching_mission("Unexpected Battle", "Daichi (Liberator)") ||
            on_branching_mission("Unexpected Battle", "Yamato") ||
            on_branching_mission("Unexpected Battle", "Ronaldo")
        ) && (
            trigger_when(byte(COMBAT_PTR + 0x250) <= 0x04) &&
            trigger_when(byte(COMBAT_PTR + 0x251) <= 0x04) &&
            trigger_when(__ornext(byte(COMBAT_PTR + 0x252) <= 0x04 || byte(COMBAT_PTR + 0x252) == 0xff)) &&
            trigger_when(__ornext(byte(COMBAT_PTR + 0x253) <= 0x04 || byte(COMBAT_PTR + 0x253) == 0xff)) &&
            trigger_when(__ornext(byte(COMBAT_PTR + 0x254) <= 0x04 || byte(COMBAT_PTR + 0x254) == 0xff))
        )
        && team_leader_is(4, "Dragon")
        && trigger_when(combat_actively_occurring())
        && trigger_when(specific_leader_defeated("Dragon"))
)
achievement(
    id = 575409,
    title = "Dragon Tamer",
    description = "Defeat the Dragon.",
    type = "progression",
    points = 10,
    trigger = actively_in_event() 
        && __ornext(
            on_mission("Reared Head") ||
            on_branching_mission("Unexpected Battle", "Daichi (Restorer)") ||
            on_branching_mission("Unexpected Battle", "Daichi (Liberator)") ||
            on_branching_mission("Unexpected Battle", "Yamato") ||
            on_branching_mission("Unexpected Battle", "Ronaldo")
        )
        && combat_actively_occurring()
        && specific_leader_defeated("Dragon")
)
achievement(
    id = 596776,
    title = "The Administrator's Sword Stirs Chaos",
    description = "On 'Last Assassin', defeat Alcor while it is in its alternate form.",
    points = 10,
    type = "missable",
    trigger = __ornext(
        on_branching_mission("Last Assassin", "Daichi (Restorer)") ||
        on_branching_mission("Last Assassin", "Daichi (Liberator)") ||
        on_branching_mission("Last Assassin", "Yamato") ||
        on_branching_mission("Last Assassin", "Ronaldo")
    )
    && __ornext(
        team_leader_is(4, "Alcor (Alternate)") 
        || team_leader_is(5, "Alcor (Alternate)") 
        || team_leader_is(6, "Alcor (Alternate)") 
        || team_leader_is(7, "Alcor (Alternate)") 
        || team_leader_is(8, "Alcor (Alternate)") 
        || team_leader_is(9, "Alcor (Alternate)") 
        || team_leader_is(10, "Alcor (Alternate)") 
        || team_leader_is(11, "Alcor (Alternate)") 
    )
    && trigger_when(combat_actively_occurring())
    && trigger_when(specific_leader_defeated("Alcor (Alternate)"))
)
achievement(
    id = 597442,
    title = "Earth's Cepheid",
    description = "Defeat the first form of Polaris without releasing any of its weaknesses.",
    points = 25,
    trigger = __ornext(
        on_branching_mission("Dreamed Future", "Daichi (Restorer)") ||
        on_branching_mission("To Freedom", "Daichi (Liberator)") ||
        on_branching_mission("New Tomorrow", "Al Saiduq") ||
        on_branching_mission("Correct Tomorrow", "Yamato") ||
        on_branching_mission("Unseen Tomorrow", "Ronaldo")
    )
    && combat_actively_occurring()
    // Polaris is unit 4, so check starting from unit 5 that they all have HP left
    && word(COMBAT_PTR + 0xc74) > 0
    && word(COMBAT_PTR + 0xef0) > 0
    && word(COMBAT_PTR + 0x116c) > 0
    && word(COMBAT_PTR + 0x13e8) > 0
    && word(COMBAT_PTR + 0x1664) > 0
    && word(COMBAT_PTR + 0x18e0) > 0
    && word(COMBAT_PTR + 0x1b5c) > 0
    && word(COMBAT_PTR + 0x1dd8) > 0
    && specific_leader_soft_defeated("Polaris")
)
achievement(
    id = 590282,
    title = "Alpha Ursae Minoris",
    description = "Deploy 4 leaders to fight Polaris and win with all team leaders alive.",
    points = 25,
    trigger = __ornext(
        on_branching_mission("Dreamed Future", "Daichi (Restorer)") ||
        on_branching_mission("To Freedom", "Daichi (Liberator)") ||
        on_branching_mission("New Tomorrow", "Al Saiduq") ||
        on_branching_mission("Correct Tomorrow", "Yamato") ||
        on_branching_mission("Unseen Tomorrow", "Ronaldo")
    ) 
    && ptr_valid(FULL_COMBAT_PTR)
    && combat_actively_occurring()
    && player_teams_alive(4) 
    && specific_leader_defeated("Polaris A")
)
achievement(
    id = 590281,
    title = "Besting the Northern Star",
    description = "Defeat Polaris.",
    points = 25,
    trigger = __ornext(
        on_branching_mission("Dreamed Future", "Daichi (Restorer)") ||
        on_branching_mission("To Freedom", "Daichi (Liberator)") ||
        on_branching_mission("New Tomorrow", "Al Saiduq") ||
        on_branching_mission("Correct Tomorrow", "Yamato") ||
        on_branching_mission("Unseen Tomorrow", "Ronaldo")
    ) 
    && combat_actively_occurring()
    && specific_leader_defeated("Polaris A"),
    type = "win_condition"
)
// ** Daichi's Way **
achievement(
    id=596129,
    title = "Coexisting With Team Osaka",
    description = "Defeat the helping members of Team Osaka as Daichi's team.",
    points = 5,
    trigger = ending_selected("Daichi") && on_branching_mission("Vs. Osaka", "Daichi") && only_friendly_teams_left()
)
achievement(
    id=596130,
    title = "Coexisting With Team Nagoya",
    description = "Defeat the helping members of Team Nagoya as Daichi's team.",
    points = 5,
    trigger = ending_selected("Daichi") && on_branching_mission("Vs. Nagoya", "Daichi") && only_friendly_teams_left()
)
achievement(
    id=596131,
    title = "Coexisting at Dream's End",
    description = "Defeat the leading faction of Team Nagoya as Daichi's team.",
    points = 5,
    trigger = ending_selected("Daichi") && on_branching_mission("Dream's End", "Daichi") && only_friendly_teams_left()
)
achievement(
    id = 596134,
    title = "Coexisting With the Strong Breaker",
    description = "Defeat the leading faction of Team Osaka as Daichi's team.",
    points = 5,
    trigger = ending_selected("Daichi") 
        && on_branching_mission("Strong Breaker", "Daichi") 
        && combat_actively_occurring()
        && specific_leader_defeated("Yamato")
)
achievement(
    id = 596135,
    title = "The Band's Back Together",
    description = "With all death clips prevented and all characters alive, persuade all former party members to aid your cause.",
    points = 25,
    type = "missable",
    trigger = is_day("Saturday") 
        && all_characters_alive()
        && ending_selected("Daichi")
        && prev(num_saturday_recruited_characters()) == 7
        && num_saturday_recruited_characters() == 8
)
achievement(
    id = 596384,
    title = "Return to Silence",
    description = "After conferring with the Anguished One on Sunday to confirm your path, defeat all enemies.",
    points = 5,
    trigger = ending_selected("Daichi") && on_branching_mission("Shown Path", "Daichi") && only_friendly_teams_left()
)
achievement(
    id = 596775,
    title = "The Power of Possibility",
    description = "With intent to commit to your newfound path, defeat the administrator's final guardian.",
    points = 5,
    trigger = ending_selected("Daichi") && 
        __ornext(
            on_branching_mission("Last Assassin", "Daichi (Restorer)") ||
            on_branching_mission("Last Assassin", "Daichi (Liberator)")
        ) && character_died("Anguished One")
)
achievement(
    id = 597443,
    title = "Dreamed Future",
    description = "Overcome the administrator's test and win an opportunity to try this all again.",
    points = 25,
    trigger = ending_selected("Daichi") 
        && on_branching_mission("Dreamed Future", "Daichi (Restorer)") 
        && combat_actively_occurring()
        && specific_leader_defeated("Polaris A")
)
achievement(
    id = 597441,
    title = "Unshackled",
    description = "Topple the administrator and win a future fit solely for mankind to shape.",
    points = 25,
    trigger = ending_selected("Daichi") 
        && on_branching_mission("To Freedom", "Daichi (Liberator)") 
        && combat_actively_occurring()
        && specific_leader_defeated("Polaris A")
)
achievement(
    id = 597444,
    title = "Will of the Species",
    description = "Defeat Polaris with all possible demon users alive and recruited.",
    points = 25,
    type = "missable",
    trigger = ending_selected("Daichi") 
        && __ornext(
            on_branching_mission("Dreamed Future", "Daichi (Restorer)") ||
            on_branching_mission("To Freedom", "Daichi (Liberator)")
        )
        && num_saturday_recruited_characters() == 8
        && combat_actively_occurring()
        && specific_leader_defeated("Polaris A")
)
// ** A New World **
achievement(
    id = 596490,
    title = "The World vs. Team Tokyo",
    description = "Defeat the helping members of Team Tokyo as Al Saiduq's team.",
    points = 10,
    trigger = ending_selected("Anguished One") && on_branching_mission("Vs. Tokyo", "Al Saiduq") && only_friendly_teams_left()
)
achievement(
    id = 596491,
    title = "The World's Here to Settle Things",
    description = "Defeat the leading faction of Team Tokyo as Al Saiduq's team.",
    points = 5,
    trigger = ending_selected("Anguished One") && on_branching_mission("Settling Up", "Al Saiduq") && only_friendly_teams_left()
)
achievement(
    id = 596489,
    title = "The World vs. Team Osaka",
    description = "Defeat the helping members of Team Osaka as Al Saiduq's team.",
    points = 5,
    trigger = ending_selected("Anguished One") && on_branching_mission("Vs. Osaka", "Al Saiduq") && only_friendly_teams_left()
)
achievement(
    id = 596488,
    title = "The World vs. Team Nagoya",
    description = "Defeat the helping members of Team Nagoya as Al Saiduq's team.",
    points = 5,
    trigger = ending_selected("Anguished One") && on_branching_mission("Vs. Nagoya", "Al Saiduq") && only_friendly_teams_left()
)
achievement(
    id = 596626,
    title = "Dreams Crushed by the World",
    description = "Defeat the leading faction of Team Nagoya as Al Saiduq's team.",
    trigger = ending_selected("Anguished One") && on_branching_mission("Dream's End", "Al Saiduq") && character_died("Ronaldo"),        
    points = 5
)
achievement(
    id = 596630,
    title = "Tying up This World's Last Loose End",
    description = "Defeat Yamato as Al Saiduq's team.",
    points = 5,
    trigger = ending_selected("Anguished One") && on_branching_mission("Strong Breaker", "Al Saiduq") && character_died("Yamato")
)
achievement(
    id = 596684,
    title = "Starting Fresh",
    description = "Defeat Polaris and establish your new free world.",
    points = 25,
    trigger = ending_selected("Anguished One") 
        && actively_in_event()
        && on_mission("New Tomorrow") 
        && combat_actively_occurring()
        && specific_leader_defeated("Polaris A")    
)
// ** Yamato's Way **
achievement(
    id = 595432,
    title = "Merit vs. Team Tokyo",
    description = "Defeat the helping members of Team Tokyo as Yamato's team.",
    points = 5,
    trigger = ending_selected("Yamato") && on_branching_mission("Vs. Tokyo", "Yamato") && only_friendly_teams_left()
)
achievement(
    id = 596421,
    title = "Trampling Former Friends",
    description = "Defeat the leading faction of Team Tokyo as Yamato's team.",
    points = 5,
    trigger = ending_selected("Yamato") && on_branching_mission("Settling Up", "Yamato") && only_friendly_teams_left()
)
achievement(
    id = 596686,
    title = "Having It Out",
    description = "Defeat the helping members of Team Nagoya as Yamato's team.",
    points = 5,
    trigger = ending_selected("Yamato") && on_branching_mission("Vs. Nagoya", "Yamato") && only_friendly_teams_left()
)
achievement(
    id = 596687,
    title = "The Only Path Forward Is Through Merit",
    description = "Defeat the leading faction of Team Nagoya as Yamato's team.",
    points = 5,
    trigger = ending_selected("Yamato") && on_branching_mission("Last Stand", "Yamato") && character_died("Ronaldo")
)
achievement(
    id = 596709,
    title = "Chasing the Self-Important",
    description = "With resolve to establish your world of merit, confer with the Anguished One and overcome his ordeal.",
    points = 5,
    trigger = ending_selected("Yamato") && on_branching_mission("Shown Path", "Yamato") && only_friendly_teams_left()
)
achievement(
    id = 596777,
    title = "Quelling a Stellar Heretic",
    description = "With resolve to establish your world of merit, defeat the administrator's final guardian.",
    points = 5,
    trigger = ending_selected("Yamato") && on_branching_mission("Last Assassin", "Yamato") && character_died("Anguished One")
)
achievement(
    id = 597428,
    title = "Might Shall Make Right",
    description = "Overcome the administrator's test and establish your meritocracy.",
    points = 25,
    trigger = ending_selected("Yamato") 
        && on_branching_mission("Correct Tomorrow", "Yamato") 
        && combat_actively_occurring()
        && specific_leader_defeated("Polaris A")
)
// ** Ronaldo's Way **
achievement(
    id = 596060,
    title = "Equality vs. Tokyo",
    description = "Defeat the helping members of Team Tokyo as Ronaldo's team.",
    points = 5,
    trigger = ending_selected("Ronaldo") && on_branching_mission("Vs. Tokyo", "Ronaldo") && only_friendly_teams_left()
)
achievement(
    id = 596493,
    title = "Not All Friendships Are Equal",
    description = "Defeat the leading faction of Team Tokyo as Ronaldo's team.",
    points = 5,
    trigger = ending_selected("Ronaldo") && on_branching_mission("Settling Up", "Ronaldo") && only_friendly_teams_left()
)
achievement(
    id = 596688,
    title = "Equality vs. Osaka",
    description = "Defeat the helping members of Team Osaka as Ronaldo's team.",
    points = 5,
    trigger = ending_selected("Ronaldo") && on_branching_mission("Vs. Osaka", "Ronaldo") && only_friendly_teams_left()
)
achievement(
    id = 596494,
    title = "A Test of Might",
    description = "Defeat the leading faction of Team Osaka as Ronaldo's team.",
    points = 5,
    trigger = ending_selected("Ronaldo") 
        && on_branching_mission("Test of Might", "Ronaldo") 
        && combat_actively_occurring()
        && specific_leader_defeated("Yamato")
)
achievement(
    id = 596779,
    title = "Don't Be Hasty",
    description = "With resolve to make the world equal for all, confer with the Anguished One and overcome his ordeal.",
    points = 5,
    trigger = ending_selected("Ronaldo") && on_branching_mission("Shown Path", "Ronaldo") && only_friendly_teams_left()
)
achievement(
    id = 596778,
    title = "Our Only Means of Repayment",
    description = "With resolve to make the world equal for all, defeat the administrator's final guardian.",
    points = 5,
    trigger = ending_selected("Ronaldo") && on_branching_mission("Last Assassin", "Ronaldo") && character_died("Anguished One")
)
achievement(
    id = 597427,
    title = "All for One and One for All",
    description = "Overcome the administrator's test and establish your society built on equality.",
    points = 25,
    trigger = ending_selected("Ronaldo") 
        && on_branching_mission("Unseen Tomorrow", "Ronaldo") 
        && combat_actively_occurring()
        && specific_leader_defeated("Polaris A")
)

achievement(
    title = "Sunday's Melancholy",
    description = "Without ever entering any Free Battle, reach the end of Day 1 without carrying over Demons or Macca and no compendium discount.",
    points = 5,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle() 
        && prev(is_time_of_day(21, 0))
        && is_time_of_day(0, 0)
        && prev(is_day("Sunday"))
        && is_day("Monday"), 
    type = "missable",
    id=530973
)
achievement(
    title = "Monday's Turmoil",
    description = "Without ever entering any Free Battle, reach the end of Day 2 without carrying over Demons or Macca and no compendium discount.",
    points = 10,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle() 
        && prev(is_time_of_day(21, 0))
        && is_time_of_day(0, 0)
        && prev(is_day("Monday"))
        && is_day("Tuesday"), 
    type = "missable",
    id=530974
)
achievement(
    title = "Tuesday's Disquiet",
    description = "Without ever entering any Free Battle, reach the end of Day 3 without carrying over Demons or Macca and no compendium discount.",
    points = 10,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle()
        && prev(is_time_of_day(21, 0))
        && is_time_of_day(0, 0)
        && prev(is_day("Tuesday"))
        && is_day("Wednesday"), 
    type = "missable",
    id=530975
)
achievement(
    title = "Wednesday's Changes",
    description = "Without ever entering any Free Battle, reach the end of Day 4 without carrying over Demons or Macca and no compendium discount.",
    points = 10,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle() 
        && prev(is_time_of_day(23, 30)) 
        && is_time_of_day(0, 0) 
        && prev(is_day("Wednesday")) 
        && is_day("Thursday"),
    type = "missable",
    id=530976
)
achievement(
    title = "Thursday's Shock",
    description = "Without ever entering any Free Battle, reach the end of Day 5 without carrying over Demons or Macca and no compendium discount.",
    points = 10,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle() 
        && prev(is_time_of_day(23, 30)) 
        && is_time_of_day(0, 0) 
        && prev(is_day("Thursday")) 
        && is_day("Friday"),
    type = "missable",
    id = 547047
)
achievement(
    title = "Friday's Partings",
    description = "Without ever entering any Free Battle, reach the end of Day 6 without carrying over Demons or Macca and no compendium discount.",
    points = 10,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle() 
        && prev(is_time_of_day(23, 30)) 
        && is_time_of_day(0, 0) 
        && prev(is_day("Friday")) 
        && is_day("Saturday"),
    type = "missable"
)
achievement(
    title = "A Saturday Towards a New World",
    description = "Without ever entering any Free Battle, reach the end of Day 7 without carrying over Demons or Macca and no compendium discount.",
    points = 25,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle() 
        && prev(is_time_of_day(23, 30)) 
        && is_time_of_day(0, 0) 
        && prev(is_day("Saturday")) 
        && is_day("Final Day"),
    type = "missable"
)
achievement(
    title = "I Have a Severe Allergy to Grinding",
    description = "Without ever entering any Free Battle, complete any ending without carrying over Demons or Macca and no compendium discount.",
    points = 25,
    trigger = !new_game_plus_perk_enabled("Carry over 1 demon")
        && !new_game_plus_perk_enabled("Carry over 4 demons")
        && !new_game_plus_perk_enabled("Carry over 8 demons")
        && !new_game_plus_perk_enabled("Carry over all demons")
        && !new_game_plus_perk_enabled("Carry over Macca")
        && !new_game_plus_perk_enabled("10% off Compendium")
        && !new_game_plus_perk_enabled("30% off Compendium")
        && !new_game_plus_perk_enabled("50% off Compendium")
        && !entered_free_battle()
        && combat_actively_occurring()
        && specific_leader_defeated("Polaris A"),
    type = "missable"
)

achievement(
    title = "Ronaldo's Best Friend",
    description = "Reach FATE stage 5 with Ronaldo.",
    points = 10,
    trigger = char_fate_stage_maxed("Ronaldo"),
    id = 547062
)
achievement(
    title = "Io's Best Friend",
    description = "Reach FATE stage 5 with Io.",
    points = 5,
    trigger = char_fate_stage_maxed("Io"),
    id = 547052
)
achievement(
    title = "Yamato's Best Friend",
    description = "Reach FATE stage 5 with Yamato.",
    points = 10,
    trigger = char_fate_stage_maxed("Yamato"),
    id = 547053
)
achievement(
    title = "Fumi's Best Friend",
    description = "Reach FATE stage 5 with Fumi.",
    points = 5,
    trigger = char_fate_stage_maxed("Fumi"),
    id = 547054
)
achievement(
    title = "Daichi's Best Friend",
    description = "Reach FATE stage 5 with Daichi.",
    points = 5,
    trigger = char_fate_stage_maxed("Daichi"),
    id = 547050
)
achievement(
    title = "Otome's Best Friend",
    description = "Reach FATE stage 5 with Otome.",
    points = 5,
    trigger = char_fate_stage_maxed("Otome"),
    id = 547055
)
achievement(
    title = "Jungo's Best Friend",
    description = "Reach FATE stage 5 with Jungo.",
    points = 5,
    trigger = char_fate_stage_maxed("Jungo"),
    id = 547051
)
achievement(
    title = "Makoto's Best Friend",
    description = "Reach FATE stage 5 with Makoto.",
    points = 5,
    trigger = char_fate_stage_maxed("Makoto"),
    id = 547056
)
achievement(
    title = "Keita's Best Friend",
    description = "Reach FATE stage 5 with Keita.",
    points = 5,
    trigger = char_fate_stage_maxed("Keita"),
    id = 547058
)
achievement(
    title = "Airi's Best Friend",
    description = "Reach FATE stage 5 with Airi.",
    points = 5,
    trigger = char_fate_stage_maxed("Airi"),
    id = 547057
)
achievement(
    title = "Joe's Best Friend",
    description = "Reach FATE stage 5 with Joe.",
    points = 5,
    trigger = char_fate_stage_maxed("Joe"),
    id = 547059
)
achievement(
    title = "Hinako's Best Friend",
    description = "Reach FATE stage 5 with Hinako.",
    points = 5,
    trigger = char_fate_stage_maxed("Hinako"),
    id = 547060
)
achievement(
    title = "Anguished One's Best Friend",
    description = "Reach FATE stage 5 with the Anguished One.",
    points = 10,
    trigger = char_fate_stage_maxed("Anguished One"),
    id = 547061
)
// *** Auctions ***
achievement(
    title = "Blind Bidder",
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
    title = "Math Is Not Its Strong Suit",
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
        && valid_teams_on_map()
        && bit0(ATTACKER_TEAM_PTR + 0x00) == 0x01
        && bit0(DEFENDER_PTR + 0x00) == 0x01
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

// Skill-Adjacent Achievements
achievement(
    title = "Fast-tracked Learning",
    description = "Learn 4 skills, all from different enemies, in the same mission.",
    points = 5,
    trigger = repeated(4, (num_learned_skills() - prev(num_learned_skills()) == 0x01 && never(!on_grid_map())))
)

achievement(
    title = "The Power to Do Anything",
    description = "Learn all Command skills.",
    points = 25,
    trigger = prev(check_num_command_skills()) == length(COMMAND_SKILLS) - 1 
        && measured(check_num_command_skills() == length(COMMAND_SKILLS), when=always_true(), format="raw"),
    id=530983
)

achievement(
    title = "Sedentary Strength",
    description = "Learn all Passive Skills.",
    points = 25,
    trigger = prev(num_learned_passive_skills()) == 0x4b && measured(num_learned_passive_skills() == 0x4c, when=always_true(), format="raw"),
    id=530984
)

achievement(
    title = "Automating the Helpful Things",
    description = "Learn all Auto Skills.",
    points = 25,
    trigger = prev(num_learned_auto_skills()) == 0x1f && measured(num_learned_auto_skills() == 0x20, when=always_true(), format="raw"),
    id=530985
)

// Compendium and Demon Recruitment
// New Game + Stuff
achievement(
    id = 573794,
    title = "New World, Same Old Geezer",
    description = "Defeat the Sage of Time on Monday on a New Game Plus file.",
    points = 5,
    trigger = is_new_game_plus() && is_day("Monday") && in_combat_mission("Father Time")  && specific_leader_defeated("Sage of Time")
)
achievement(
    id = 575036,
    title = "All for Her",
    description = "Defeat Nebiros on Tuesday on a New Game Plus file.",
    // This is 25 because Nebiros is a fucker and does the following actions:
    // - if there is any allied unit dead (his allied unit) he will perform Necromancy and bring them back to life
    // - if you defeat the Nebiros unit while another enemy is alive, he will take over their team leader and come back to full HP
    // - he has 2133 hp
    // It is as obnoxious as it sounds, and the player does deserve to be rewarded for it.
    points = 25,
    trigger = is_new_game_plus() && is_day("Tuesday") && in_combat_mission("Necromancer") && prev(bit1(0x00284b20)) == 0x00 && bit1(0x00284b20) == 0x01
)
achievement(
    id = 590276,
    title = "Million-Dollar Smile",
    // she has 2620 hp
    description = "Defeat Lilith on Wednesday on a New Game Plus file.",
    points = 10,
    trigger = is_new_game_plus() && is_day("Wednesday") && in_combat_mission("Original Wife") && specific_leader_defeated("Lilith (Hostile)")
)
// 3575 hp
achievement(
    title = "Braving Gomorrah's Fire",
    description = "Defeat Belial on Thursday on a New Game Plus file.",
    points = 25,
    trigger = is_new_game_plus() && is_day("Thursday") && in_combat_mission("The Inferno") && specific_leader_defeated("Belial")
)
// 6666 hp, you cheeky little devs...
achievement(
    id = 595000,
    title = "Lord of the Flies",
    description = "Defeat Beelzebub on Friday on a New Game Plus file.",
    points = 25,
    trigger = is_new_game_plus() && is_day("Friday") && in_combat_mission("Lord of Flies") && specific_leader_defeated("Beelzebub")
)
// oh... she has 21,074 hp...
achievement(
    id = 596132,
    title = "Die For Me",
    description = "Defeat Alice on Saturday on a New Game Plus File.",
    points = 50,
    trigger = is_new_game_plus() && is_day("Saturday") && in_combat_mission("Innocent Soul") && specific_leader_defeated("Alice")
)
achievement(
    id = 596780,
    title = "We've Become the Best of Friends",
    description = "Record all New Game Plus bosses in your Compendium.",
    points = 5,
    trigger = prev(new_game_plus_bosses_registered() == 0x05) && measured(new_game_plus_bosses_registered() == 0x06, when=always_true(), format="raw") 
)

achievement(
    id = 546538,
    title = "Power Seekers",
    description = "Record all 7 demons of the Omega race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Omega") == length(demons_by_race["Omega"]) - 1)
        && measured(num_demons_of_race_registered("Omega") == length(demons_by_race["Omega"]), when=always_true(), format="raw")
)
achievement(
    id = 546539,
    title = "Grace of the Affectionate",
    description = "Record all 11 demons of the Megami race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Megami") == length(demons_by_race["Megami"]) - 1)
        && measured(num_demons_of_race_registered("Megami") == length(demons_by_race["Megami"]), when=always_true(), format="raw")
)
achievement(
    id = 546540,
    title = "Awakening the Enlightened",
    description = "Record all 13 demons of the Deity race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Deity") == length(demons_by_race["Deity"]) - 1)
        && measured(num_demons_of_race_registered("Deity") == length(demons_by_race["Deity"]), when=always_true(), format="raw")
)

achievement(
    id = 530987,
    title = "Chaotic Beings",
    description = "Record all 8 demons of the Vile race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Vile") == length(demons_by_race["Vile"]) - 1)
        && measured(num_demons_of_race_registered("Vile") == length(demons_by_race["Vile"]), when=always_true(), format="raw")
)
achievement(
    id = 530988,
    title = "Those That Constrict",
    description = "Record all 10 demons of the Snake race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Snake") == length(demons_by_race["Snake"]) - 1)
        && measured(num_demons_of_race_registered("Snake") == length(demons_by_race["Snake"]), when=always_true(), format="raw")
)

achievement(
    id = 530989,
    title = "Evil Serpents",
    description = "Record all 9 demons of the Dragon race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Dragon") == length(demons_by_race["Dragon"]) - 1)
        && measured(num_demons_of_race_registered("Dragon") == length(demons_by_race["Dragon"]), when=always_true(), format="raw")
)

achievement(
    id = 530991,
    title = "Stigma of the Divine",
    description = "Record all 7 demons of the Divine race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Divine") == length(demons_by_race["Divine"]) - 1)
        && measured(num_demons_of_race_registered("Divine") == length(demons_by_race["Divine"]), when=always_true(), format="raw")
)
achievement(
    id = 530992,
    title = "Taking Flight",
    description = "Record all 10 demons of the Avian race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Avian") == length(demons_by_race["Avian"]) - 1)
        && measured(num_demons_of_race_registered("Avian") == length(demons_by_race["Avian"]), when=always_true(), format="raw")
)
achievement(
    id = 530996,
    title = "Feasting With the Fallen",
    description = "Record all 13 demons of the Fallen race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Fallen") == length(demons_by_race["Fallen"]) - 1)
        && measured(num_demons_of_race_registered("Fallen") == length(demons_by_race["Fallen"]), when=always_true(), format="raw")
)
achievement(
    id = 530997,
    title = "Switching Forms for Their Believers",
    description = "Record all 11 demons of the Avatar race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Avatar") == length(demons_by_race["Avatar"]) - 1)
        && measured(num_demons_of_race_registered("Avatar") == length(demons_by_race["Avatar"]), when=always_true(), format="raw")
)
achievement(
    id = 530998,
    title = "Brutish Beasts",
    description = "Record all 9 demons of the Beast race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Beast") == length(demons_by_race["Beast"]) - 1)
        && measured(num_demons_of_race_registered("Beast") == length(demons_by_race["Beast"]), when=always_true(), format="raw")
)
achievement(
    id = 530999,
    title = "Devils Closing In",
    description = "Record all 10 demons of the Wilder race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Wilder") == length(demons_by_race["Wilder"]) - 1)
        && measured(num_demons_of_race_registered("Wilder") == length(demons_by_race["Wilder"]), when=always_true(), format="raw")
)
achievement(
    id = 531000,
    title = "No Obstacles Shall Bar Them",
    description = "Record all 12 demons of the Genma race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Genma") == length(demons_by_race["Genma"]) - 1)
        && measured(num_demons_of_race_registered("Genma") == length(demons_by_race["Genma"]), when=always_true(), format="raw")
)
achievement(
    id = 531001,
    title = "Glamorous Beings",
    description = "Record all 10 demons of the Fairy race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Fairy") == length(demons_by_race["Fairy"]) - 1)
        && measured(num_demons_of_race_registered("Fairy") == length(demons_by_race["Fairy"]), when=always_true(), format="raw")
)
achievement(
    id = 531002,
    title = "Relentless Rulers",
    description = "Record all 12 demons of the Tyrant race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Tyrant") == length(demons_by_race["Tyrant"]) - 1)
        && measured(num_demons_of_race_registered("Tyrant") == length(demons_by_race["Tyrant"]), when=always_true(), format="raw")
)
achievement(
    id = 530990,
    title = "Peerless Fighters",
    description = "Record all 10 demons of the Kishin race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Kishin") == length(demons_by_race["Kishin"]) - 1)
        && measured(num_demons_of_race_registered("Kishin") == length(demons_by_race["Kishin"]), when=always_true(), format="raw")
)
achievement(
    id = 597448,
    title = "Easily Agitated",
    description = "Record all 10 demons of the Touki race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0) 
        && prev(num_demons_of_race_registered("Touki") == length(demons_by_race["Touki"]) - 1)
        && measured(num_demons_of_race_registered("Touki") == length(demons_by_race["Touki"]), when=always_true(), format="raw")
)
achievement(
    id = 597447,
    title = "Bound by Evil",
    description = "Record all 10 demons of the Jaki race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Jaki") == length(demons_by_race["Jaki"]) - 1)
        && measured(num_demons_of_race_registered("Jaki") == length(demons_by_race["Jaki"]), when=always_true(), format="raw")
)
achievement(
    id = 597446,
    title = "Maternal Devotion",
    description = "Record all 12 demons of the Femme race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Femme") == length(demons_by_race["Femme"]) - 1)
        && measured(num_demons_of_race_registered("Femme") == length(demons_by_race["Femme"]), when=always_true(), format="raw")
)
achievement(
    id = 597449,
    title = "Possessing the Possessors",
    description = "Record all 8 demons of the Ghost race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Ghost") == length(demons_by_race["Ghost"]) - 1)
        && measured(num_demons_of_race_registered("Ghost") == length(demons_by_race["Ghost"]), when=always_true(), format="raw")
)
achievement(
    id = 597445,
    title = "Uncanny Characters",
    description = "Record all 5 demons of the Fiend race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Fiend") == length(demons_by_race["Fiend"]) - 1)
        && measured(num_demons_of_race_registered("Fiend") == length(demons_by_race["Fiend"]), when=always_true(), format="raw")
)
achievement(
    id = 597450,
    title = "Proof of Heroism",
    description = "Record all 6 demons of the Hero race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(num_demons_of_race_registered("Hero") == length(demons_by_race["Hero"]) - 1)
        && measured(num_demons_of_race_registered("Hero") == length(demons_by_race["Hero"]), when=always_true(), format="raw")
)
achievement(
    title = "The Purest of Form",
    description = "Register all four demons of the Element race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0)
        && prev(elements_registered() == 0x03) 
        && measured(elements_registered() == 0x04, when=always_true(), format="raw"),
    id = 546534
)
achievement(
    title="Honorable Spirits",
    description="Register all four demons of the Mitama race in your compendium.",
    points = 5,
    trigger = !is_time_of_day(0, 0) 
        && prev(mitamas_registered() == 0x03) 
        && measured(mitamas_registered() == 0x04, when=always_true(), format="raw"),
    id = 575035
)
achievement(
    title = "Finally, Fully Filled",
    description = "Complete 100% of the Demon compendium.",
    points = 50,
    trigger = !is_time_of_day(0, 0)
        && prev(num_registered_compendium() == 220) 
        && measured(num_registered_compendium() == 221, when=always_true(), format="raw"),
    id = 546541
)

// *** Rich Presence ***

rich_presence_conditional_display(is_day("Sunday") && is_time_of_day(0, 0) && MACCA == 0x00, "On the title screen")
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

for i in range(0, 3) {
    rich_presence_conditional_display(on_grid_map() && expected_team_moving(i), "{0} {1} | {2} is moving around {3} | Time on Mission={4}",
        rich_presence_lookup("Day", DAY, day_of_week),
        rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
        rich_presence_lookup("Unit", word(COMBAT_PTR + 0x276), enemy_name_by_id),
        rich_presence_lookup("Location", CURRENT_LOCATION, location),
        rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
    )
}

for i in range(0x04, 0x0b) {
    rich_presence_conditional_display(on_grid_map() && expected_team_moving(i), "{0} {1} | Watching {2} move around {3} | Time on Mission={4}",
        rich_presence_lookup("Day", DAY, day_of_week),
        rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
        rich_presence_lookup("Unit", word(COMBAT_PTR + 0xc66), enemy_name_by_id),
        rich_presence_lookup("Location", CURRENT_LOCATION, location),
        rich_presence_value("Combat Timer", TOTAL_TIME_IN_MISSION / 30, "SECS")
    )
}

// Non-combat things
rich_presence_conditional_display(actively_in_event(), "{0} {1} 💰 {2} | At {3}",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_value("Macca", MACCA),
    rich_presence_lookup("Location", CURRENT_LOCATION, location),
    rich_presence_value("In-Game Time", IN_GAME_TIME / 60, "SECS")
)

rich_presence_display("{0} {1} 💰 {2} | Thinking about where to go next",
    rich_presence_lookup("Day", DAY, day_of_week),
    rich_presence_value("Time", IN_GAME_CLOCK, "SECS"),
    rich_presence_value("Macca", MACCA),
    rich_presence_value("In-Game Time", IN_GAME_TIME / 60, "SECS")
)
