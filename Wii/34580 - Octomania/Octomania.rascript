// Octomania
// #ID = 34580
// In case future you needs it for RP: This world is called Lonronpia

GAME_CODE = 0x52544b45  // "RKTE"
MAKER_CODE = 0x355a     // "5Z"

// Checks that the pointer is valid and assigned.
function ptr_valid(addr) => dword_be(addr) >= 0x80000000 && dword_be(addr) <= 0x9fffffff 

// Helper function to convert addresses from RA memory scheme to real Wii memory scheme.
// RA starts memory at 0x00000000, real system starts at 0x80000000.
// Pass in the memory address with no modifiers. 
// This will return your address as AddAddress(ptr) & 0x1FFFFFFF.
function mask_ptr(ptr) => dword_be(ptr) & 0x1FFFFFFF

DIFFICULTY = {
    0x00: "Rookie",
    0x01: "Fighter",
    0x02: "Master",
    0x03: "2x Fighter",
    0x04: "2x Master"
}

ARCADE_BOARD_ONE = 0x0021a8c0
ARCADE_BOARD_TWO = 0x0021ac10

PLAYER_BOARD = 0x0021bbe8
ENEMY_BOARD = 0x0021bcec

PLAYER_ONE   = 0x0021bbec
PLAYER_TWO   = 0x0021bbf0
PLAYER_THREE = 0x0021bcf0
PLAYER_FOUR  = 0x0021bcf4

// 0x00 = Rookie;
// 0x01 = Fighter;
// 0x02 = Master;
// 0x03 = 2x Fighter;
// 0x04 = 2x Master;
// This exists on both boards, so check both
function octopuzzle_difficulty(difficulty) {
    first_board = OctoBoard(PLAYER_BOARD)
    second_board = OctoBoard(ENEMY_BOARD)

    return first_board.is_difficulty(difficulty) && first_board.current_difficulty() == second_board.current_difficulty()
} 

// there should be an enemy on the other board! TODO check existence for that
function is_playing_octopuzzle() => OctoCharacter(PLAYER_ONE).is_player_controlled() && OctoCharacter(PLAYER_THREE).is_computer_controlled()

// You have a valid Octopuzzle board, but the "enemy" board isn't valid for play 
function is_playing_endless() => ptr_valid(PLAYER_ONE) && OctoBoard(ENEMY_BOARD).board_inactive()

function is_playing_arcade() {
    return dword_be(0x0021b808) == 0x00 
        && dword_be(0x0021a8c0) == 0x2c
        && byte(0x0021a8c4) == 0x01
        && byte(0x0021a8c5) == 0x01
} 

// General catch-all for RP
function is_in_tutorial() => dword_be(0x0021b808) >= 0x87 && dword_be(0x0021b808) <= 0x8f

CHARACTER_IDS = {
    0x00: "Kari",
    0x01: "Dramo",
    0x02: "Gobu",
    0x03: "Angelique",
    0x04: "Exaltus",
    0x05: "Funkee",
    0x06: "Kanizaemon",
    0x07: "Kapprio",
    0x08: "Shadow Kari",
    0x09: "Feifei",
    0x0a: "Octobot",
    0x0b: "Takobo"
}

CHARACTER_UNLOCKED_FLAGS = {
    "Shadow Kari": bit0(0x0021c8da),
    "Feifei": bit1(0x0021c8da),
    "Octobot": bit2(0x0021c8da),
    "Takobo": bit3(0x0021c8da),
    "Kari": bit0(0x0021c8db),
    "Dramo": bit1(0x0021c8db),
    "Gobu": bit2(0x0021c8db),
    "Angelique": bit3(0x0021c8db),
    "Exaltus": bit4(0x0021c8db),
    "Funkee": bit5(0x0021c8db),
    "Kanizaemon": bit6(0x0021c8db),
    "Kapprio": bit7(0x0021c8db)
}

function character_unlocked(name) => prev(CHARACTER_UNLOCKED_FLAGS[name]) == 0 && CHARACTER_UNLOCKED_FLAGS[name] == 1

// An OctoCharacter is 48 bytes long.
// {
//    0x00: Validity check (if 0x00ffffff, not loaded) [32-bit BE]
//    0x04: Player controlled boolean [8-bit]
//    0x05: Character ID [8-bit]
//    0x06: X-coordinate of cursor [8-bit]
//    0x07: Y-coordinate of cursor [8-bit]
// }
class OctoCharacter {
    // Feed the pointer you want into here
    root_address = 0x80000000

    // Check if this player is controlled by the computer. 
    function is_computer_controlled() => ptr_valid(this.root_address) && byte(mask_ptr(this.root_address) + 0x04) == 0x00
    // Check if this player is controlled by a human.
    function is_player_controlled() => ptr_valid(this.root_address) && byte(mask_ptr(this.root_address) + 0x04) == 0x01

    function current_character() => byte(mask_ptr(this.root_address) + 0x05)
    // Check which character this is.
    function is_character(character_name) {
        for character_id in CHARACTER_IDS {
            if (CHARACTER_IDS[character_id] == character_name) {
                    return byte(mask_ptr(this.root_address) + 0x05) == character_id
            }
        }
    }
}

// An OctoBoard is 0x104 bytes long.
// {
//     0x00: Position of board [32-bit BE]
//     0x04: Character 1 pointer [32-bit BE]
//     0x08: Character 2 pointer [32-bit BE]
//     0x0c: Board active boolean [8-bit]
//     0x0d: Number of board wins [8-bit]
//     0x10: Score of board [32-bit BE]
//     0x16: Difficulty of board [8-bit]
//     0x18: Type of octopi that can be spawned on board [8-bit]
//     0x27: Number of diamonds on the board [8-bit]
//     0x31: Number of octopi on board [16-bit BE]
//     0x33: Number of octopi in current chain, total [8-bit]
//     0x5d: Time since last octopi drop [32-bit BE]
//     0x60: Frames that newly placed piece has been falling for until it hits board [8-bit]
//     0x63: Number of octopi dropped on board [8-bit]
//     0x64: X-coord that octopi is being placed on [8-bit]
//     0x65: Y-coord that octopi is being placed on [8-bit]
//     0x66: ID of piece being placed [8-bit]
//     0xa8: Diamond gauge [16-bit BE]
//     0xaa: Current hit combo [16-bit BE]
//     0xac: Current hit combo copy [16-bit BE]
//     0xae: Last hit combo recorded [16-bit BE]
//     0xbc: Number of red octopi on board [8-bit]
//     0xbd: Number of blue octopi on board [8-bit]
//     0xbe: Number of yellow octopi on board [8-bit]
//     0xbf: Number of green octopi on board [8-bit]
//     0xc0: Number of squid on board [8-bit]
//     0xc1: ?? [8-bit]
//     0xd0: Number of red octopi in chain [8-bit]
//     0xd1: Number of blue octopi in chain [8-bit]
//     0xd2: Number of yellow octopi in chain [8-bit]
//     0xd3: Number of green octopi in chain [8-bit]
//     0xd4: Number of squid in chain [8-bit]
//     0xd5: ?? (corresponds with 0xc1) [8-bit]
// }
class OctoBoard {
    // Feed the pointer you want into here
    root_address = PLAYER_BOARD

    //     0x0c: Board active boolean [8-bit]
    function board_active() => byte(this.root_address + 0x0c) == 0x01
    
    // So we don't have to say !board.is_active()
    function board_inactive() => byte(this.root_address + 0x0c) == 0x00

    // The game always has two boards up in gameplay, but in modes like Endless only one will be used as a game board.
    // In this scenario, the other board is for showing scores and it won't have a character associated with it.
    function is_player_board() => ptr_valid(this.root_address + 0x04)

    // Check if this board is being controlled by a human being.
    function is_human_controlled_board() {
        return ptr_valid(this.root_address + 0x04) 
            && OctoCharacter(this.root_address + 0x04).is_player_controlled()
    }

    function is_computer_controlled() => ptr_valid(this.root_address + 0x04) && OctoCharacter(this.root_address + 0x04).is_computer_controlled()
    
    // Simple condition to check that only a single player is associated with this board so we don't end up with 4 alts
    function is_one_player_board() => ptr_valid(this.root_address + 0x04) && dword_be(this.root_address + 0x08) == 0x00000000
    // Checks if there are two characters associated with this board.
    //     0x04: Character 1 pointer [32-bit BE]; 0x08: Character 2 pointer [32-bit BE]
    function is_two_player_board() => ptr_valid(this.root_address + 0x04) && ptr_valid(this.root_address + 0x08)

    //     0x0d: Number of board wins [8-bit]
    // For a single player game, this will go to 1 at most.
    function board_win_state() => byte(this.root_address + 0x0d)

    // Check if this board just won.
    //     0x0d: Number of board wins [8-bit]
    // For a single player game, this will go to 1 at most.
    function board_has_won() => prev(byte(this.root_address + 0x0d) == 0x00) && byte(this.root_address + 0x0d) == 0x01

    // Get current score of board.
    //     0x10: Score of board [32-bit BE]
    function current_score() => dword_be(this.root_address + 0x10)

    function current_difficulty() => byte(this.root_address + 0x16)
    // Check if the board is on the given difficulty.
    //     0x16: Difficulty of board [8-bit]
    function is_difficulty(expected_difficulty) {

        for diff in DIFFICULTY {
            if (DIFFICULTY[diff] == expected_difficulty) {
                return byte(this.root_address + 0x16) == diff
            }
        }
    }

    // 0x18: Type of octopi that can be spawned on this board [8-bit] 
    function number_octopi_types() => byte(this.root_address + 0x18)

    // 0x27: Number of diamonds on the board [8-bit]
    function num_diamonds() => byte(this.root_address + 0x27)

    //     0x31: Number of octopi on board [16-bit BE]
    function num_total_octopi_on_board() => word_be(this.root_address + 0x31)

    // Check if the given board has started a new combo.
    //     0xaa: Current hit combo [16-bit BE]
    function combo_started() => prev(word_be(this.root_address + 0xaa)) == 0 && word_be(this.root_address + 0xaa) > 0

    // Check if the given board's combo has just finished.
    //     0xaa: Current hit combo [16-bit BE]
    function combo_finished() => prev(word_be(this.root_address + 0xaa)) > 0 && word_be(this.root_address + 0xaa) == 0

    // Check that the combo hits a specific threshold.
    //     0xaa: Current hit combo [16-bit BE]
    //     0xae: Last hit combo recorded [16-bit BE]
    function combo_goes_to(combo) {
        return prev(word_be(this.root_address + 0xaa)) < combo
            && word_be(this.root_address + 0xaa) == combo
            && word_be(this.root_address + 0xae) == combo
    }

    //     0xae: Last hit combo recorded [16-bit BE]
    function current_combo() => word_be(this.root_address + 0xae)

    //     0xbc: Number of red octopi on board [8-bit]
    function red_octopi_on_board() => byte(this.root_address + 0xbc)
    //     0xbd: Number of blue octopi on board [8-bit]
    function blue_octopi_on_board() => byte(this.root_address + 0xbd)
    //     0xbe: Number of yellow octopi on board [8-bit]
    function yellow_octopi_on_board() => byte(this.root_address + 0xbe)
    //     0xbf: Number of green octopi on board [8-bit]
    function green_octopi_on_board() => byte(this.root_address + 0xbf)
    //     0xc0: Number of squid on board [8-bit]
    function squids_on_board() => byte(this.root_address + 0xc0)
    //     0xc1: Number of light blue octopi on board [8-bit]
    function light_blue_octopi_on_board() => byte(this.root_address + 0xc1)
    //     0xc2: Number of purple octopi on board [8-bit]
    function purple_octopi_on_board() => byte(this.root_address + 0xc2)
    //     0xc3: Number of black squids on board [8-bit]
    function black_squid_on_board() => byte(this.root_address + 0xc3)
    //     0xc4: Number of light green octopi on board [8-bit]
    function light_green_octopi_on_board() => byte(this.root_address + 0xc4)
    //     0xd0: Number of red octopi in chain [8-bit]
    function number_red_octopi_in_chain() => byte(this.root_address + 0xd0)
    //     0xd1: Number of blue octopi in chain [8-bit]
    function number_blue_octopi_in_chain() => byte(this.root_address + 0xd1)
    //     0xd2: Number of yellow octopi in chain [8-bit]
    function number_yellow_octopi_in_chain() => byte(this.root_address + 0xd2)
    //     0xd3: Number of green octopi in chain [8-bit]
    function number_green_octopi_in_chain() => byte(this.root_address + 0xd3)
    //     0xd4: Number of squid in chain [8-bit]
    function number_squid_in_chain() => byte(this.root_address + 0xd4)
    //     0xd5: Number of light blue octopi in chain [8-bit]
    function number_light_blue_octopi_in_chain() => byte(this.root_address + 0xd5)
    //     0xd6: Number of purple octopi in chain [8-bit]
    function number_purple_octopi_in_chain() => byte(this.root_address + 0xd6)
    //     0xd7: Number of black squid in chain [8-bit]
    function number_black_squid_in_chain() => byte(this.root_address + 0xd7)
    //     0xd8: Number of light green octopi in chain [8-bit]
    function number_light_green_octopi_in_chain() => byte(this.root_address + 0xd8)

    // Get the number of unique chains happening on the board.
    // Several different colors can be exploding all at once, so we're really just checking if there's any value in each of these addresses.
    function number_unique_chains() {
        return (this.number_red_octopi_in_chain() / this.number_red_octopi_in_chain())
            + (this.number_blue_octopi_in_chain() / this.number_blue_octopi_in_chain())
            + (this.number_yellow_octopi_in_chain() / this.number_yellow_octopi_in_chain())
            + (this.number_green_octopi_in_chain() / this.number_green_octopi_in_chain())
            + (this.number_squid_in_chain() / this.number_squid_in_chain())
            + (this.number_light_blue_octopi_in_chain() / this.number_light_blue_octopi_in_chain())
            + (this.number_purple_octopi_in_chain() / this.number_purple_octopi_in_chain())
            + (this.number_black_squid_in_chain() / this.number_black_squid_in_chain())
            + (this.number_light_green_octopi_in_chain() / this.number_light_green_octopi_in_chain())
    }
}

// Arcade mode is treated completely differently by the game. Different board structure, different starting point, everything.
class ArcadeBoard {
    root_address = 0x00000000

    // +0x04 Boolean for board can get octopi drops (0x01 = true) [8-bit]
    function is_active() => byte(this.root_address + 0x04) == 0x01
    // +0x05 Boolean for board is player controlled (0x01 = true) [8-bit]
    function is_player_controlled() => byte(this.root_address + 0x05) == 0x01
    // +0x07 board has won boolean [8-bit]
    function board_has_won() => prev(byte(this.root_address + 0x07)) == 0x00 && byte(this.root_address + 0x07) == 0x01

    // +0x08 Score [32-bit BE]
    function current_score() => dword_be(this.root_address + 0x08)
    // +0x0e Difficulty [8-bit]
    // 0x00 = Rookie
    // 0x01 = Fighter
    // 0x02 = Master
    function current_difficulty() => byte(this.root_address + 0x0e)

    // +0x0f Current opponent [8-bit]
    // 0x00 = Gobu;
    // 0x01 = Kanizaemon;
    // 0x02 = Funkee;
    // 0x03 = Kapprio;
    // 0x04 = ?
    // 0x05 = Exaltus;
    // 0x06 = Angelique;
    function current_opponent() => byte(this.root_address + 0x0f)


} 

// Helper function to determine what character the given slot is.
function is_octopuzzle_character(player_num, char_name) {
    // Basics of this:
    // - if it's player 1, it does nothing and stays at 0x0021bbec
    // - if it's player 2 or 4, it needs to add 0x04
    // - if it's player 3 or 4, it needs to add 0x104
    offset = PLAYER_ONE + (0x04 * ((player_num + 1) % 2)) + ((player_num / 3) * 0x104)

    character = OctoCharacter(root_address = offset)

    return menu_option_selected() && character.is_character(char_name)
}

// Helper function to determine the primary enemy. 
// Two nice parts about this:
// 1. The enemy we care about is always the 3rd player
// 2. They must not be a player character
function is_octopuzzle_enemy(char_name) {
    character = OctoCharacter(root_address = PLAYER_THREE)

    for character_id in CHARACTER_IDS {
        if (CHARACTER_IDS[character_id] == char_name) {
            return character.is_computer_controlled() && character.is_character(char_name)
        }
    } 
}

//LIST OF TITLES (Endless Mode)
TITLES = {
    "Grass": bit0(0x0021c8dc), // Leave only Green Octopi on the screen after a combo
    "Squid Farmer": bit1(0x0021c8dc), // Leave only Squids (white) on the screen after a combo
    "Snow": bit2(0x0021c8dc), // Leave only Light Blue Octopi on the screen after a combo
    "Lavender": bit3(0x0021c8dc), // Leave only Purple Octopi on the screen after a combo
    "Congrats": bit4(0x0021c8dc), // 10-hit combo using Red Octopi and Squids
    "Fireworks": bit5(0x0021c8dc), // 10-hit combo using Red, Blue, and Yellow Octopi
    "Hydrangea": bit6(0x0021c8dc), // 10-hit combo using Purple and Green Octopi
    "Pink": bit7(0x0021c8dc), // 10-hit combo using Purple and Light Blue Octopi and Squids
    "Survivor": bit0(0x0021c8dd), // Play for 20 minutes
    "Marathon": bit1(0x0021c8dd), // Play for 30 minutes
    "Eternal": bit2(0x0021c8dd), // Play for 40 minutes
    "Infinity": bit3(0x0021c8dd), // Play for 60 minutes
    "Endless": bit4(0x0021c8dd), // Play for 90 minutes
    "Rose": bit5(0x0021c8dd), // Leave only Red Octopi on the screen after a combo
    "Iris": bit6(0x0021c8dd), // Leave only Blue Octopi on the screen after a combo
    "Tulip": bit7(0x0021c8dd), // Leave only Yellow Octopi on the screen after a combo
    "Grill Master": bit0(0x0021c8de), // Clear an “8” grill
    "Five Alive": bit1(0x0021c8de), // Combo using 5 different colors at once
    "Quick Six": bit2(0x0021c8de), // Combo using 6 different colors at once
    "Lucky Seven": bit3(0x0021c8de), // Combo using 7 different colors at once
    "Rich Man": bit4(0x0021c8de), // Have 2 diamonds on the screen at once
    "Filthy Rich": bit5(0x0021c8de), // Have 3 diamonds on the screen at once
    "Iced Out": bit6(0x0021c8de), // Have 4 diamonds on the screen at once
    "Othello": bit7(0x0021c8de), // Form bubbles in all four corners
    "Red Ginger": bit0(0x0021c8df), // 30-hit combo with Red Octopi
    "High Tide": bit1(0x0021c8df), // 30-hit combo with Blue Octopi
    "Teriyaki Egg": bit2(0x0021c8df), // 30-hit combo with Yellow Octopi
    "Green Onion": bit3(0x0021c8df), // 30-hit combo with Green Octopi
    "Cool Guy": bit4(0x0021c8df), // 30-hit combo with Squids (white)
    "Aqua": bit5(0x0021c8df), // 30-hit combo with Light Blue Octopi
    "Octopi King": bit6(0x0021c8df), // 30-hit combo with Purple Octopi
    "All Clear": bit7(0x0021c8df) // Clear everything from the screen
}

function title_count() {
    running_total = 0
    
    for title in TITLES {
        running_total = running_total + TITLES[title]
    }

    return running_total
}

// General notes
// Simply setting the score to max (1,999,999,999) got me Octo Expert
LICENSES = {
    "Octo Angel": bit3(0x0021c8e2),
    "Octo Devil": bit2(0x0021c8e2),
    "Octo Professor": bit1(0x0021c8e2),
    "Octo Master": bit0(0x0021c8e2),
    "Disguised Squid": bit7(0x0021c8e3),
    "Octo Expert": bit6(0x0021c8e3),
    "Octo Prodigy": bit5(0x0021c8e3),
    "Octo Tamer": bit4(0x0021c8e3),
    "Octo Monk": bit3(0x0021c8e3),
    "Octo Child": bit2(0x0021c8e3),
    "Octo Toddler": bit1(0x0021c8e3),
    "Octo Baby": bit0(0x0021c8e3)
}

function license_count() {
    running_total = 0
    
    for license in LICENSES {
        running_total = running_total + LICENSES[license]
    }

    return running_total
}


// They're using one singular array for menu options. Which I think is just grand.
// They display parts of the menu depending on ~context~
MENU_OPTIONS = {
    // Main Menu
    0x00: "Arcade",
    0x01: "Original",
    0x02: "Nintendo Wi-Fi Connection Battle",
    0x03: "Options",
    0x04: "Tutorial",
    // Mode select after selecting "Original"
    0x05: "Octopuzzle",
    0x06: "Octobattle",
    0x07: "Endless",
    // Num players select after selecting "Octopuzzle"
    0x09: "1 Player",
    0x0a: "2 Player",
    // Difficulty select, after choosing number of players in Octopuzzle
    0x13: "Octo Rookie (Novice)",
    0x14: "Octo Fighter (Intermediate)",
    0x15: "Octo Master (Advanced)",
    0x16: "2x Octo Fighter (Battle against 2 Octo Fighters!)",
    0x17: "2x Octo Master (Battle against 2 Octo Masters!)",
    // Character select, after choosing difficulty in Octopuzzle
    0x18: "Kari",
    0x19: "Pig",
    0x1a: "Crab",
    0x1b: "Tree",
    0x1c: "Fanboy",
    0x1d: "Kappa",
    0x1e: "Shadow Kari",
    0x1f: "?",
    0x20: "?",
    0x21: "?",
    0x22: "?",
    0x23: "?",
    // Entering name for records
    0x3b: "A",
    0x3c: "B",
    // ... (no I'm not recording the rest of the alphabet why do you even care it's A-Z)
    0x54: "Z",
    0x55: "?",
    0x56: "!",
    0x57: "&",
    0x58: ".",
    0x59: "_",
    0x5a: "a space",
    0x5b: "Back",
    0x5c: "Confirm",
    // -- Pause --
    0x5d: "Return to Game",
    0x5e: "Return to Title",
    // -- Tutorial --
    0x87: "How to Play",
    0x88: "Arcade Mode",
    0x89: "Original Mode",
    0x8a: "Pointer Style",
    0x8b: "Sideways Style",
    0x8c: "Chain Explosion",
    0x8d: "Diamond",
    0x8e: "Specialty Color",
    0x8f: "Character Intro",
    // Any menu has this option
    0xc3: "Return",
}

// This is a cheat ish way of asking "has the player stepped into Octopuzzle?"
// Doing this because some achievements prime on the title screen and I cannot tell what they are until I publish.
// But internally they're using a board that otherwise looks valid...
function menu_option_selected() => dword_be(0x0021b808) != 0

function menu_option_selected_is(option) {
    for key in MENU_OPTIONS {
        if (MENU_OPTIONS[key] == option) {
            return dword_be(0x0021b808) == key
        }
    }
}

// Cheaty way of asking "can we enter a score to a leaderboard" without actually checking which entry got overridden.
function leaderboard_available_to_enter() {
    return OctoBoard(PLAYER_BOARD).is_human_controlled_board()
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && OctoBoard(PLAYER_BOARD).current_score() >= 1000000
        && prev(byte(0x0021b818)) == 0x00
        && byte(0x0021b818) == 0x1f
}

function endless_leaderboard_available_to_enter() {
    return OctoBoard(PLAYER_BOARD).is_human_controlled_board()
        && OctoBoard(ENEMY_BOARD).board_inactive()
        && OctoBoard(PLAYER_BOARD).current_score() >= 1000000
        && prev(byte(0x0021b818)) == 0x00
        && byte(0x0021b818) == 0x1f
}

// Each leaderboard entry is 20 bytes long.
class LeaderboardEntry {
    root_address = 0x0021d028

    // This is just here to denote that the first 5 characters are the name. Don't bother checking this for anything real.
    // 0x00 -> 0x04: each a byte, some value between 0x00 and 0x1f
    function name(pos_char) => always_false()

    // +0x05 ID of character [8-bit]
    function character() => byte(this.root_address + 5)

    // +0x08 Score [32-bit BE]
    function score() => dword_be(this.root_address + 8)

    // +0x0c Time taken [32-bit BE]
    function time_taken() => dword_be(this.root_address + 0x0c)

    // +0x13 Highest hit combo [8-bit]
    function highest_hit_combo() => dword_be(this.root_address + 0x13)
}


ALL_MODES = [
    "Arcade - Play Alone - Rookie",
    "Arcade - Play Alone - Fighter",
    "Arcade - Play Alone - Master",
    "Arcade - Endless",
    "Original - Story - 1 Player - Rookie",
    "Original - Story - 1 Player - Fighter",
    "Original - Story - 1 Player - Master",
    "Original - Story - 1 Player - 2x Fighter",
    "Original - Story - 1 Player - 2x Master",
    "Original - Story - 2 Player - Rookie",
    "Original - Story - 2 Player - Fighter",
    "Original - Story - 2 Player - Master",
    "Original - Story - 2 Player - 2x Fighter",
    "Original - Story - 2 Player - 2x Master",
    "Original - Endless - 1 Player",
    "Original - Endless - 2 Player"
]

// All possible permuatations:
// Arcade - Play Alone - Rookie;
// Arcade - Play Alone - Fighter;
// Arcade - Play Alone - Master;
// Arcade - Endless;
// Original - Story - 1 Player - Rookie;
// Original - Story - 1 Player - Fighter;
// Original - Story - 1 Player - Master;
// Original - Story - 1 Player - 2x Fighter;
// Original - Story - 1 Player - 2x Master;
// Original - Story - 2 Player - Rookie;
// Original - Story - 2 Player - Fighter;
// Original - Story - 2 Player - Master;
// Original - Story - 2 Player - 2x Fighter;
// Original - Story - 2 Player - 2x Master;
// Original - Endless - 1 Player;
// Original - Endless - 2 Player;
// Each of the above is 10 entries. Each entry is 20 bytes. 
// This function returns the address for a leaderboard entry given the mode and the place. 
function get_leaderboard_entry(selected_mode, place) {
    root_address = 0x0021d028

    for i in range(0, length(ALL_MODES)) {
        if (ALL_MODES[i] == selected_mode) {
            offset = (20 * i * 10) + (20 * (place - 1))
            return root_address + offset
        }
    }
}

function specific_leaderboard_entry_changed(selected_mode, place) {
    entry = LeaderboardEntry(get_leaderboard_entry(selected_mode, place))
    return (prev(entry.score()) < entry.score())
}

function any_leaderboard_entry_changed(selected_mode) {
    cond = always_false()

    root_address = 0x0021d028

    for i in range(0, length(ALL_MODES)) {
        if (ALL_MODES[i] == selected_mode) {
            for lb in range(0, 9) {
                offset = (20 * i * 10) + (20 * (lb))
                
                cond = cond || (prev(LeaderboardEntry(root_address + offset).score()) < LeaderboardEntry(root_address + offset).score())
            }
            return cond
        }
    }
}

achievement(
    id = 599679,
    title = "How Humiliating-Gobu!",
    points = 2,
    description = "Defeat Gobu in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Gobu") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599707,
    title = "He Has Shamed His Ancestors",
    points = 2,
    description = "Defeat Kanizaemon in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Kanizaemon") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599708,
    title = "Fired and Inspired",
    points = 2,
    description = "Defeat Funkee in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Funkee") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599706,
    title = "No, My Rose! My Rose!",
    points = 2,
    description = "Defeat Kapprio in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Kapprio") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599694,
    title = "Must Resort to Plan B",
    points = 2,
    type = "progression",
    description = "Defeat Octobot in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Octobot") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599705,
    title = "I Didn't Want to Play This Anyway",
    points = 2,
    type = "progression",
    description = "Defeat Dramo in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Dramo") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599928,
    title = "Prince Exaltus Out of Reach",
    points = 2,
    description = "Defeat Feifei in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Feifei") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599680,
    title = "Takobo Just Wants to Go Home",
    points = 2,
    type = "progression",
    description = "Defeat Takobo in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Takobo") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599704,
    title = "I'm Telling Mommy",
    points = 2,
    type = "progression",
    description = "Defeat Exaltus in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Exaltus") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599697,
    title = "You Creep",
    points = 2,
    type = "progression",
    description = "Defeat Angelique in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Angelique") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599693,
    title = "No, I Lost!",
    points = 2,
    description = "Defeat Kari in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Kari") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599698,
    title = "I Can't Believe I Lost",
    points = 2,
    type = "progression",
    description = "Defeat Shadow Kari in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Shadow Kari")
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

// Real important note: credits do not roll if you do not have a score over 1m.
// Literally does not happen. Even if you reach a point where you can unlock a character. 
// Whether the youngins like it or not, this is THE way to hit credits so it is the win condition. 
achievement(
    id = 599696,
    title = "Nobody Grills Better Than Me",
    points = 10,
    type = "progression",
    description = "Complete any Octopuzzle story and record your final score.",
    trigger = is_playing_octopuzzle() 
        && OctoBoard(ENEMY_BOARD).board_win_state() != 0x01
        && leaderboard_available_to_enter()
)

achievement(
    id = 600373,
    title = "Octomaniac",
    points = 5,
    description = "Record a score of 100,000,000 or higher in Octopuzzle.",
    trigger = is_playing_octopuzzle() 
        && leaderboard_available_to_enter()
        && OctoBoard(PLAYER_BOARD).current_score() >= 100000000 
)

achievement(
    id = 600625,
    title = "It's Raining Octopi",
    points = 5,
    description = "Complete Arcade on any difficulty.",
    type = "progression",
    trigger = ArcadeBoard(ARCADE_BOARD_ONE).is_active()
        && ArcadeBoard(ARCADE_BOARD_ONE).is_player_controlled()
        && ArcadeBoard(ARCADE_BOARD_TWO).is_active()
        && !ArcadeBoard(ARCADE_BOARD_TWO).is_player_controlled()
        && (
            (ArcadeBoard(ARCADE_BOARD_ONE).current_difficulty() == 0x00 
            && ArcadeBoard(ARCADE_BOARD_TWO).current_opponent() == 0x03
            && ArcadeBoard(ARCADE_BOARD_ONE).board_has_won())
            || (__ornext(ArcadeBoard(ARCADE_BOARD_ONE).current_difficulty() == 0x01 || ArcadeBoard(ARCADE_BOARD_ONE).current_difficulty() == 0x02)
            && ArcadeBoard(ARCADE_BOARD_TWO).current_opponent() == 0x06
            && ArcadeBoard(ARCADE_BOARD_ONE).board_has_won()
            )
        )
)

achievement(
    id = 600626,
    title = "No Room for Fake Karis up Here",
    points = 25,
    description = "Defeat Shadow Kari in Arcade mode on Fighter or Master difficulty.",
    trigger = ArcadeBoard(ARCADE_BOARD_ONE).is_active()
        && ArcadeBoard(ARCADE_BOARD_ONE).is_player_controlled()
        && ArcadeBoard(ARCADE_BOARD_TWO).is_active()
        && !ArcadeBoard(ARCADE_BOARD_TWO).is_player_controlled()
        && ((__ornext(ArcadeBoard(ARCADE_BOARD_ONE).current_difficulty() == 0x01 || ArcadeBoard(ARCADE_BOARD_ONE).current_difficulty() == 0x02)
            && ArcadeBoard(ARCADE_BOARD_TWO).current_opponent() == 0x07
            && ArcadeBoard(ARCADE_BOARD_ONE).board_has_won()
            )
        )
)

achievement(
    id = 600563,
    title = "Grilling in Takoron Style",
    points = 5,
    description = "Record a score of 100,000,000 or more in Arcade single player on Octo Master.",
    trigger = ArcadeBoard(ARCADE_BOARD_ONE).is_active()
        && ArcadeBoard(ARCADE_BOARD_ONE).is_player_controlled()
        && ArcadeBoard(ARCADE_BOARD_TWO).is_active()
        && !ArcadeBoard(ARCADE_BOARD_TWO).is_player_controlled()
        && ArcadeBoard(ARCADE_BOARD_ONE).current_score() >= 100000000
        && ((ArcadeBoard(ARCADE_BOARD_ONE).current_difficulty() == 2 && specific_leaderboard_entry_changed("Arcade - Play Alone - Master", 1)))
)

achievement(
    id = 599702,
    title = "Addressing the Octopus Complex",
    points = 10,
    description = "As Kari, reach and defeat Angelique in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Kari")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Kari"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 599700,
    title = "Eat Some Takoyaki for Both of Us",
    points = 3,
    description = "Unlock Shadow Kari as a playable character.",
    trigger = OctoCharacter(PLAYER_ONE).is_character("Kari") 
        && is_octopuzzle_enemy("Shadow Kari")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Shadow Kari")
)

achievement(
    id = 599929,
    title = "Disinfecting the World, One Puzzle at a Time",
    points = 10,
    description = "As Gobu, reach and defeat Shadow Kari in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Gobu")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Gobu"))
        && trigger_when(is_octopuzzle_enemy("Shadow Kari"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 599930,
    title = "Together, We Can Clean the World",
    description = "Unlock Octobot as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Gobu") 
        && is_octopuzzle_enemy("Octobot")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Octobot")
)

achievement(
    id = 599695,
    title = "A Samurai Must Endure Many Trials",
    points = 10,
    description = "As Kanizaemon, reach and defeat Exaltus in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Kanizaemon")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Kanizaemon"))
        && trigger_when(is_octopuzzle_enemy("Exaltus"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 599703,
    title = "Deceit and Crime Never Pay",
    description = "Unlock Dramo as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Kanizaemon")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && is_octopuzzle_enemy("Dramo")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Dramo")
)

achievement(
    id = 600148,
    title = "Lonronpia World Tour",
    points = 10,
    description = "As Funkee, reach and defeat Prince Exaltus in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Funkee")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Funkee"))
        && trigger_when(is_octopuzzle_enemy("Exaltus"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600149,
    title = "Get Outside More",
    description = "Unlock Angelique as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Funkee") 
        && is_octopuzzle_enemy("Angelique")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Angelique")
)

achievement(
    id = 600153,
    title = "A Journey of Retribution",
    points = 10,
    description = "As Feifei, reach and defeat Shadow Kari in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Feifei")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Feifei"))
        && trigger_when(is_octopuzzle_enemy("Shadow Kari"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600154,
    title = "You Had Me at Free Takoyaki",
    description = "Unlock Takobo as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Feifei") 
        && is_octopuzzle_enemy("Takobo")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Takobo")
)

achievement(
    id = 600195,
    title = "Undefeated Octopuzzle Champion",
    points = 10,
    description = "As Kapprio, reach and defeat Dramo in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Kapprio")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Kapprio"))
        && trigger_when(is_octopuzzle_enemy("Dramo"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600196,
    title = "Defenseless Dramo's Protector",
    description = "Unlock Exaltus as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Kapprio") 
        && is_octopuzzle_enemy("Exaltus")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Exaltus")
)

achievement(
    id = 600362,
    title = "Self-Indulgent Chaos Gremlin Beats Up the World",
    points = 10,
    description = "As Shadow Kari, reach and defeat Feifei in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Shadow Kari")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Shadow Kari"))
        && trigger_when(is_octopuzzle_enemy("Feifei"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600374,
    title = "Still Searching for the Creator",
    points = 10,
    description = "As Octobot, reach and defeat Angelique in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Octobot")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Octobot"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600478,
    title = "The Demon King's Throne is Mine",
    points = 10,
    description = "As Dramo, reach and defeat Exaltus in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Dramo")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Dramo"))
        && trigger_when(is_octopuzzle_enemy("Exaltus"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600364,
    title = "Totally Killing the Vacation Vibe",
    points = 10,
    description = "As Angelique, reach and defeat Exaltus in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Angelique")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Angelique"))
        && trigger_when(is_octopuzzle_enemy("Exaltus"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600375,
    title = "Best Takoyaki Chef in the Universe",
    points = 10,
    description = "As Takobo, reach and defeat Angelique in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Takobo")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Takobo"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    id = 600477,
    title = "Never Mess With the Prince of Demons",
    points = 10,
    description = "As Exaltus, reach and defeat Dramo in Octopuzzle without using a Continue.",
    trigger = is_octopuzzle_character(1, "Exaltus")
        && OctoCharacter(PLAYER_ONE).is_player_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Exaltus"))
        && trigger_when(is_octopuzzle_enemy("Dramo"))            
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

// *** Master ***

achievement(
    id = 600539,
    title = "Grilling the Germophobe",
    points = 5,
    description = "In Octopuzzle, defeat Gobu on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Gobu") 
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))
        && OctoBoard(PLAYER_BOARD).board_has_won() 
)

achievement(
    id = 600540,
    title = "Grilled Samurai Legs",
    points = 5,
    description = "In Octopuzzle, defeat Kanizaemon on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Kanizaemon") 
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600541,
    title = "Grilling the DJ",
    points = 5,
    description = "In Octopuzzle, defeat Funkee on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Funkee")
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master")) 
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600542,
    title = "Grilling the Rose",
    points = 5,
    description = "In Octopuzzle, defeat Kapprio on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Kapprio") 
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master")) 
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600543,
    title = "Grilling the Loyal Guardian",
    points = 5,
    description = "In Octopuzzle, defeat Octobot on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Octobot")
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))  
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600544,
    title = "Grilling the Dragon",
    points = 5,
    description = "In Octopuzzle, defeat Dramo on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Dramo")
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600548,
    title = "Grilling the Fangirl",
    points = 5,
    description = "In Octopuzzle, defeat Feifei on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Feifei")
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600545,
    title = "Grilling the Grill Master",
    points = 5,
    description = "In Octopuzzle, defeat Takobo on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Takobo")
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600546,
    title = "Grilling Prince Exaltopus",
    points = 5,
    description = "In Octopuzzle, defeat Exaltus on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Exaltus") 
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600549,
    title = "Grilling the Sorceress",
    points = 5,
    description = "In Octopuzzle, defeat Kari on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Kari") 
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600547,
    title = "Grilling the Vacationista",
    points = 5,
    description = "In Octopuzzle, defeat Angelique on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Angelique")
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600550,
    title = "Grilling the Alter Ego",
    points = 5,
    description = "In Octopuzzle, defeat Shadow Kari on Octo Master or 2x Octo Master.",
    trigger = is_octopuzzle_enemy("Shadow Kari")
        && __ornext(octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 600150,
    title = "Octo Wrangler",
    points = 5,
    description = "Get a 30-hit combo in Octopuzzle on a board that has at least 4 different kinds of octopi.",
    trigger = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).number_octopi_types() >= 4
        && OctoBoard(PLAYER_BOARD).combo_goes_to(30)
)

achievement(
    id = 599701,
    title = "This Is My Kind of Octopi",
    points = 5,
    description = "Chain 15 or more octopi of your character's specialty color together in Octopuzzle.",
    trigger = OctoBoard(PLAYER_BOARD).is_human_controlled_board()
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && OctoBoard(ENEMY_BOARD).board_active()
        && ((
            __ornext(
                OctoCharacter(PLAYER_ONE).is_character("Angelique") 
                || OctoCharacter(PLAYER_ONE).is_character("Kanizaemon")
                || OctoCharacter(PLAYER_ONE).is_character("Octobot")  
            )
            && prev(OctoBoard(PLAYER_BOARD).number_red_octopi_in_chain()) < 15
            && OctoBoard(PLAYER_BOARD).number_red_octopi_in_chain() >= 15
        ) 
        ||
        
            // Shadow Kari = Blue
            // Exaltus = Blue
            // Kapprio = Blue
        (
            __ornext(
                OctoCharacter(PLAYER_ONE).is_character("Shadow Kari") 
                || OctoCharacter(PLAYER_ONE).is_character("Exaltus")
                || OctoCharacter(PLAYER_ONE).is_character("Kapprio")  
            )
            && prev(OctoBoard(PLAYER_BOARD).number_blue_octopi_in_chain()) < 15
            && OctoBoard(PLAYER_BOARD).number_blue_octopi_in_chain() >= 15
        ) 
        ||
        (
            // Kari = Yellow
            // Feifei = Yellow
            // Takobo = Yellow
            __ornext(
                OctoCharacter(PLAYER_ONE).is_character("Kari") 
                || OctoCharacter(PLAYER_ONE).is_character("Feifei")
                || OctoCharacter(PLAYER_ONE).is_character("Takobo")  
            )
            && prev(OctoBoard(PLAYER_BOARD).number_yellow_octopi_in_chain()) < 15
            && OctoBoard(PLAYER_BOARD).number_yellow_octopi_in_chain() >= 15

        )
        ||
            // Dramo = Green
            // Gobu = Green
            // Funkee = Green
        (
            __ornext(
                OctoCharacter(PLAYER_ONE).is_character("Dramo") 
                || OctoCharacter(PLAYER_ONE).is_character("Gobu")
                || OctoCharacter(PLAYER_ONE).is_character("Funkee")  
            )
            && prev(OctoBoard(PLAYER_BOARD).number_green_octopi_in_chain()) < 15
            && OctoBoard(PLAYER_BOARD).number_green_octopi_in_chain() >= 15
        ))
)

achievement(
    id = 600567,
    title = "I Just Like Looking At Them",
    points = 10,
    description = "In Endless, get 4 diamonds on screen at once.",
    trigger = is_playing_endless()
        && prev(OctoBoard(PLAYER_BOARD).num_diamonds() == 3)
        && trigger_when(OctoBoard(PLAYER_BOARD).num_diamonds() == 4)
)

achievement(
    title = "Monochrome Grilling",
    points = 5,
    description = "In Endless, leave only one color of octopi on the screen after a combo.",
    trigger = is_playing_endless()
        && OctoBoard(PLAYER_BOARD).combo_finished()
        && (
            ( // reds left
                OctoBoard(PLAYER_BOARD).red_octopi_on_board() > 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )
            || ( // blues left
                OctoBoard(PLAYER_BOARD).blue_octopi_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )
            || ( // yellows left
                OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )            
            || ( // greens left
                OctoBoard(PLAYER_BOARD).green_octopi_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )
            || ( // squids left
                OctoBoard(PLAYER_BOARD).squids_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )
            || ( // light blue left
                OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )            
            || ( // purple left
                OctoBoard(PLAYER_BOARD).purple_octopi_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )
            || ( // black left
                OctoBoard(PLAYER_BOARD).black_squid_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() == 0
            )
            || ( // light green left
                OctoBoard(PLAYER_BOARD).light_green_octopi_on_board() > 0
                && OctoBoard(PLAYER_BOARD).red_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).yellow_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).green_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).squids_on_board() == 0
                && OctoBoard(PLAYER_BOARD).light_blue_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).purple_octopi_on_board() == 0
                && OctoBoard(PLAYER_BOARD).black_squid_on_board() == 0
            )
        )
)

achievement(
    id = 600627,
    title = "Rainbow-Colored Sea of Smoke",
    description = "In Endless, get a combo that uses 5 or more different colors at once.",
    points = 10,
    trigger = is_playing_endless()
        && (prev(OctoBoard(PLAYER_BOARD).number_unique_chains()) <= 4)
        && ((OctoBoard(PLAYER_BOARD).number_unique_chains()) >= 5)
        && ((OctoBoard(PLAYER_BOARD).number_unique_chains()) < 10)
)

achievement(
    id = 600479,
    title = "Octopus Vulgaris",
    points = 5,
    description = "Earn 3 licenses through Original Endless.",
    trigger = is_playing_endless()
        && prev(license_count()) == 2
        && measured(license_count() == 3, when=always_true(), format="raw") 
)

achievement(
    id = 600480,
    title = "Octopus Chierchiae",
    points = 10,
    description = "Earn 6 licenses through Original Endless.",
    trigger = is_playing_endless()
        && prev(license_count()) == 5
        && measured(license_count() == 6, when=always_true(), format="raw") 
)

achievement(
    id = 600481,
    title = "Octopus Cyanea",
    points = 10,
    description = "Earn 9 licenses through Original Endless.",
    trigger = is_playing_endless()
        && prev(license_count()) == 8
        && measured(license_count() == 9, when=always_true(), format="raw") 
)

achievement(
    id = 600566,
    title = "Former Radioyaki Enjoyer",
    points = 5,
    description = "Earn 5 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && title_count() <= 28
        && prev(title_count()) < 5
        && measured(title_count() >= 5, when=always_true(), format="raw")
)

achievement(
    id = 600565,
    title = "Authentic Aizuya Griller",
    points = 10,
    description = "Earn 10 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && title_count() <= 28
        && prev(title_count()) < 10
        && measured(title_count() >= 10, when=always_true(), format="raw")
)

achievement(
    id = 600568,
    title = "Osaka Snack Enthusiast",
    points = 10,
    description = "Earn 15 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && title_count() <= 28
        && prev(title_count()) < 15
        && measured(title_count() >= 15, when=always_true(), format="raw")
)

achievement(
    id = 600564,
    title = "Takoyaki, Takaron!",
    points = 25,
    description = "Earn 20 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && title_count() <= 28
        && prev(title_count()) < 20
        && measured(title_count() >= 20, when=always_true(), format="raw")
)

leaderboard(
    title = "Octopuzzle Highest Hit Combo",
    description = "Highest Hit combo during Octopuzzle Endless",
    start = OctoBoard(PLAYER_BOARD).combo_started() && !(OctoBoard(ENEMY_BOARD).is_player_board()),
    cancel = !(OctoCharacter(PLAYER_ONE).is_player_controlled()),
    submit = OctoBoard(PLAYER_BOARD).combo_finished(),
    value = prev(OctoBoard(PLAYER_BOARD).current_combo()),
    format = "VALUE"
)

leaderboard(
    title = "Arcade Rookie High Score",
    description = "Highest score submitted at the end of Arcade on Rookie.",
    start = is_playing_arcade() && __ornext(any_leaderboard_entry_changed("Arcade - Play Alone - Rookie")),
    cancel = always_false(),
    submit = always_true(),
    value = ArcadeBoard(ARCADE_BOARD_ONE).current_score()
)

leaderboard(
    title = "Arcade Fighter High Score",
    description = "Highest score submitted at the end of Arcade on Fighter.",
    start = is_playing_arcade() && __ornext(any_leaderboard_entry_changed("Arcade - Play Alone - Fighter")),
    cancel = always_false(),
    submit = always_true(),
    value = ArcadeBoard(ARCADE_BOARD_ONE).current_score()
)

leaderboard(
    title = "Arcade Master High Score",
    description = "Highest score submitted at the end of Arcade on Master.",
    start = is_playing_arcade() && __ornext(any_leaderboard_entry_changed("Arcade - Play Alone - Master")),
    cancel = always_false(),
    submit = always_true(),
    value = ArcadeBoard(ARCADE_BOARD_ONE).current_score()
)

leaderboard(
    title = "Arcade Endless High Score",
    description = "Highest score submitted at the end of Arcade on Endless.",
    start = is_playing_arcade() && __ornext(any_leaderboard_entry_changed("Arcade - Endless")),
    cancel = always_false(),
    submit = always_true(),
    value = ArcadeBoard(ARCADE_BOARD_ONE).current_score()
)

leaderboard(
    title = "Octopuzzle 1 Player Rookie High Score",
    description = "Highest score on overwriting an Octopuzzle 1 Player Rookie record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("Rookie")
        && OctoBoard(PLAYER_BOARD).is_one_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 1 Player Fighter High Score",
    description = "Highest score on overwriting an Octopuzzle 1 Player Fighter record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("Fighter")
        && OctoBoard(PLAYER_BOARD).is_one_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 1 Player Master High Score",
    description = "Highest score on overwriting an Octopuzzle 1 Player Master record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("Master")
        && OctoBoard(PLAYER_BOARD).is_one_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 1 Player 2x Fighter High Score",
    description = "Highest score on overwriting an Octopuzzle 1 Player 2x Fighter record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("2x Fighter")
        && OctoBoard(PLAYER_BOARD).is_one_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 1 Player 2x Master High Score",
    description = "Highest score on overwriting an Octopuzzle 1 Player 2x Master record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("2x Master")
        && OctoBoard(PLAYER_BOARD).is_one_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 2 Player Rookie High Score",
    description = "Highest score on overwriting an Octopuzzle 2 Player Rookie record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("Rookie")
        && OctoBoard(PLAYER_BOARD).is_two_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 2 Player Fighter High Score",
    description = "Highest score on overwriting an Octopuzzle 2 Player Fighter record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("Fighter")
        && OctoBoard(PLAYER_BOARD).is_two_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 2 Player Master High Score",
    description = "Highest score on overwriting an Octopuzzle 2 Player Master record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("Master")
        && OctoBoard(PLAYER_BOARD).is_two_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 2 Player 2x Fighter High Score",
    description = "Highest score on overwriting an Octopuzzle 2 Player 2x Fighter record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("2x Fighter")
        && OctoBoard(PLAYER_BOARD).is_two_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 2 Player 2x Master High Score",
    description = "Highest score on overwriting an Octopuzzle 2 Player 2x Master record",
    start = is_playing_octopuzzle() 
        && OctoBoard(PLAYER_BOARD).is_difficulty("2x Master")
        && OctoBoard(PLAYER_BOARD).is_two_player_board()
        && leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 1 Player Endless High Score",
    description = "Highest score on overwriting an Octopuzzle 1 Player Endless record",
    start = is_playing_endless() 
        && OctoBoard(PLAYER_BOARD).is_one_player_board()
        && endless_leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

leaderboard(
    title = "Octopuzzle 2 Player Endless High Score",
    description = "Highest score on overwriting an Octopuzzle 2 Player Endless record",
        start = is_playing_endless() 
        && OctoBoard(PLAYER_BOARD).is_two_player_board()
        && endless_leaderboard_available_to_enter(),
    cancel = always_false(),
    submit = always_true(),
    value = OctoBoard(PLAYER_BOARD).current_score(),
    format = "VALUE"
)

rich_presence_conditional_display(
    menu_option_selected_is("Arcade Mode"),
    "Learning about how Arcade works through Tutorials"
)

rich_presence_conditional_display(
    menu_option_selected_is("Chain Explosion"),
    "Learning about induced chain-gobu explosions"
)

rich_presence_conditional_display(
    menu_option_selected_is("Specialty Color"),
    "Learning about everyone's favorite colors and what they do"
)

rich_presence_conditional_display(
    is_in_tutorial(),
    "Learning more about the wonders of octopi and Lonronpia"
)

rich_presence_conditional_display(
    is_playing_octopuzzle(), 
    "{0} is challenging {1} to Octopuzzle on {2} difficulty",
    rich_presence_lookup("characters", OctoCharacter(PLAYER_ONE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("characters", OctoCharacter(PLAYER_THREE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("difficulty", OctoBoard(PLAYER_BOARD).current_difficulty(), DIFFICULTY)
)

rich_presence_conditional_display(
    is_playing_arcade(),
    "Kari is powering through Arcade mode",
    rich_presence_lookup("characters", OctoCharacter(PLAYER_THREE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("difficulty", OctoBoard(PLAYER_BOARD).current_difficulty(), DIFFICULTY)
)

rich_presence_conditional_display(
    is_playing_endless(), 
    "{0} is surviving in Endless",
    rich_presence_lookup("characters", OctoCharacter(PLAYER_ONE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("characters", OctoCharacter(PLAYER_THREE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("difficulty", OctoBoard(PLAYER_BOARD).current_difficulty(), DIFFICULTY)
)
rich_presence_conditional_display(
    is_playing_endless(),
    "{0} is grilling octopi endlessly",
    rich_presence_lookup("characters", OctoCharacter(PLAYER_ONE).current_character(), CHARACTER_IDS)
)

rich_presence_display("Thinking about delicious takoyaki")