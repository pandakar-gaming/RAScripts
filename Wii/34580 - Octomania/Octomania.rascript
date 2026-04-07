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
function is_playing_endless() => ptr_valid(PLAYER_ONE) && !ptr_valid(PLAYER_THREE)

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
    function board_active() => ptr_valid(this.root_address) && byte(mask_ptr(this.root_address) + 0x0c) == 0x01
    
    // The game always has two boards up in gameplay, but in modes like Endless only one will be used as a game board.
    // In this scenario, the other board is for showing scores and it won't have a character associated with it.
    function is_player_board() => ptr_valid(this.root_address + 0x04)

    // Check if this board is being controlled by a human being.
    function is_human_controlled_board() {
        return ptr_valid(this.root_address + 0x04) 
            && OctoCharacter(this.root_address + 0x04).is_player_controlled()
    }

    function is_computer_controlled() => ptr_valid(this.root_address + 0x04) && OctoCharacter(this.root_address + 0x04).is_computer_controlled()
    
    // Checks if there are two characters associated with this board.
    //     0x04: Character 1 pointer [32-bit BE]; 0x08: Character 2 pointer [32-bit BE]
    function is_two_player_board() => ptr_valid(this.root_address + 0x04) && ptr_valid(this.root_address + 0x08)

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
                return byte(mask_ptr(this.root_address) + 0x16) == diff
            }
        }
    }
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

    //     0xd0: Number of red octopi in chain [8-bit]
    function number_red_octopi_in_chain() => byte(this.root_address + 0xd0)
    //     0xd1: Number of blue octopi in chain [8-bit]
    function number_blue_octopi_in_chain() => byte(this.root_address + 0xd1)
    //     0xd2: Number of yellow octopi in chain [8-bit]
    function number_yellow_octopi_in_chain() => byte(this.root_address + 0xd2)
    //     0xd3: Number of green octopi in chain [8-bit]
    function number_green_octopi_in_chain() => byte(this.root_address + 0xd3)
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

    root_address = 0x0021d028

    for i in range(0, length(ALL_MODES)) {
        if (ALL_MODES[i] == selected_mode) {
            offset = (20 * i * 10) + (20 * (place - 1))
            return root_address + offset
        }
    }
}

// Tired idea:
// - basic achievements are based on story lines
// - master difficulty achievement are Grilling the <whatever they are>
achievement(
    id = 599679,
    title = "How Humiliating-Gobu!",
    points = 2,
    description = "Defeat Gobu in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Gobu") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the Germophobe",
    points = 5,
    description = "Beat Gobu up, but on Master mode.",
    trigger = is_octopuzzle_enemy("Gobu") 
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))
        && OctoBoard(PLAYER_BOARD).board_has_won() 
)

achievement(
    id = 599707,
    title = "He Has Shamed His Ancestors",
    points = 2,
    description = "Defeat Kanizaemon in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Kanizaemon") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilled Samurai Legs",
    points = 2,
    description = "Defeat Kanizaemonin Octopuzzle on Master mode or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Kanizaemon") 
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599708,
    // todo listen to this quote again and see if you can find something better
    title = "Fired and Inspired",
    points = 2,
    description = "Defeat Funkee in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Funkee") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the DJ",
    points = 2,
    description = "Defeat Funkee in Octopuzzle on Master mode or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Funkee")
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master")) 
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599706,
    title = "No, My Rose! My Rose!",
    points = 2,
    description = "Defeat Kapprio in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Kapprio") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the Rose",
    points = 2,
    description = "Defeat Kapprio in Octopuzzle on Master mode or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Kapprio") 
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master")) 
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599694,
    title = "Must Resort to Plan B",
    points = 2,
    description = "Defeat Octobot in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Octobot") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the Loyal Guardian",
    points = 2,
    description = "Defeat Octobot in Octopuzzle on Master or 2x Master.",
    trigger = is_octopuzzle_enemy("Octobot")
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))  
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599705,
    title = "I Didn't Want To Play This Anyway",
    points = 2,
    description = "Defeat Dramo in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Dramo") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the Dragon",
    points = 2,
    description = "Defeat Dramo in Octopuzzle on Master mode or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Dramo")
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Prince Exaltus Out of Reach",
    points = 2,
    description = "Shitty sorceress loses, more news at 11",
    trigger = is_octopuzzle_enemy("Feifei") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the Fangirl",
    points = 2,
    description = "Shitty sorceress loses, more news at 11",
    trigger = is_octopuzzle_enemy("Feifei")
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599680,
    title = "Takobo Just Wants To Go Home",
    points = 2,
    description = "Defeat Takobo in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Takobo") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the Grill Master",
    points = 2,
    description = "Defeat Takobo in Octopuzzle on Master or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Takobo")
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599704,
    title = "I'm Telling Mommy",
    points = 2,
    description = "Defeat Exaltus in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Exaltus") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling Prince Exaltopus",
    points = 2,
    description = "Defeat Exaltus in Octopuzzle on Master or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Exaltus") 
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599697,
    title = "You Creep",
    points = 2,
    description = "Defeat Angelique in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Angelique") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "She Really Needs a Beach Day",
    points = 2,
    description = "Defeat Angelique in Octopuzzle on Master or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Angelique")
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599693,
    title = "No, I Lost!",
    points = 2,
    description = "Defeat Kari in Octopuzzle.",
    trigger = is_octopuzzle_enemy("Kari") && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Grilling the Sorceress",
    points = 2,
    description = "Defeat Kari in Octopuzzle on Master or 2x Master mode.",
    trigger = is_octopuzzle_enemy("Kari") 
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    id = 599698,
    title = "I Can't Believe I Lost",
    points = 2,
    description = "Defeat Shadow Kari.",
    trigger = is_octopuzzle_enemy("Shadow Kari")
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

achievement(
    title = "Dark Side of the Grill",
    points = 5,
    description = "Defeat Shadow Kari on Master.",
    trigger = is_octopuzzle_enemy("Shadow Kari")
        && (octopuzzle_difficulty("Master") || octopuzzle_difficulty("2x Master"))   
        && OctoBoard(PLAYER_BOARD).board_has_won()
)

// Real important note: credits do not roll if you do not have a score over 1m.
// Literally does not happen. Even if you get to a point where you can unlock a character. 
// Whether the youngins like it or not, this is THE way to hit credits so it is the win condition. 
achievement(
    id = 599696,
    title = "Nobody Grills Better Than Me",
    points = 10,
    type = "win_condition",
    description = "Complete Octopuzzle as any character and record your final score.",
    trigger = is_playing_octopuzzle() && leaderboard_available_to_enter()
)

achievement(
    id = 599702,
    title = "Addressing the Octopus Complex",
    points = 10,
    description = "As Kari, get to and defeat Angelique on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Kari")
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
    title = "Disinfecting the World, One Puzzle at a Time",
    points = 10,
    description = "As Gobu, get to and defeat Shadow Kari on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Gobu")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Gobu"))
        && trigger_when(is_octopuzzle_enemy("Shadow Kari"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
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
    description = "As Kanizaemon, get to and defeat Exaltus on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Kanizaemon")
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
        && is_octopuzzle_enemy("Dramo")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Dramo")
)

// This triggers on the title screen still
// Specifically, it's triggering because it's lingering from having seen the credits and having had the last menu index input be 0x5c, or "confirm"
achievement(
    title = "[NEEDS TITLE]Funkee Doin Good",
    points = 10,
    description = "As Funkee, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Funkee")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Funkee"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "[NEEDS TITLE]Angelique Unlock",
    description = "Unlock Angelique as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Funkee") 
        && is_octopuzzle_enemy("Angelique")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Angelique")
)

achievement(
    title = "[NEEDS TITLE]Feifei Doin Good",
    points = 10,
    description = "As Feifei, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Feifei")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Feifei"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "[NEEDS TITLE]Takobo Unlock",
    description = "Unlock Takobo as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Feifei") 
        && is_octopuzzle_enemy("Takobo")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Takobo")
)

achievement(
    title = "[NEEDS TITLE]Kapprio Doin Good",
    points = 10,
    description = "As Kapprio, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Kapprio")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Kapprio"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "[NEEDS TITLE]Exaltus Unlock",
    description = "Unlock Exaltus as a playable character.",
    points = 3,
    trigger = OctoCharacter(PLAYER_ONE).is_character("Kapprio") 
        && is_octopuzzle_enemy("Exaltus")
        && OctoBoard(ENEMY_BOARD).is_computer_controlled()
        && character_unlocked("Exaltus")
)

achievement(
    title = "[NEEDS TITLE]Shadow Kari Doin Good",
    points = 10,
    description = "As Shadow Kari, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Shadow Kari")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Shadow Kari"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "[NEEDS TITLE]Dramo Doin Good",
    points = 10,
    description = "As Dramo, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Dramo")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Dramo"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "[NEEDS TITLE]Octobot Doin Good",
    points = 10,
    description = "As Octobot, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Octobot")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Octobot"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "[NEEDS TITLE]Takobo Doin Good",
    points = 10,
    description = "As Takobo, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Octobot")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Takobo"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "[NEEDS TITLE]Angelique Doin Good",
    points = 10,
    description = "As Angelique, get to and defeat <TODO LITERALLY WHO?> on any difficulty without using a Continue.",
    trigger = is_octopuzzle_character(1, "Octobot")
        && disable_when(OctoBoard(ENEMY_BOARD).board_has_won(), until=!is_octopuzzle_character(1, "Angelique"))
        && trigger_when(is_octopuzzle_enemy("Angelique"))
        && trigger_when(OctoBoard(PLAYER_BOARD).board_has_won())
)

achievement(
    title = "Octo Wrangler",
    points = 5,
    description = "Get a 30-hit combo in Octopuzzle.",
    trigger = OctoBoard(PLAYER_BOARD).combo_goes_to(30)
)

achievement(
    id = 599701,
    title = "This Is My Kind of Octopi",
    points = 5,
    description = "Chain 15 or more octopi of your character's specialty color together in Octopuzzle.",
    trigger = OctoBoard(PLAYER_BOARD).is_human_controlled_board()
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

// If we do any arcade acknowledgement, it goes here

achievement(
    title = "[NEEDS TITLE]Arcade High Score",
    points = 5,
    description = "Record a score of 5,000,000 or more in Arcade single player on Fighter or Master.",
    trigger = always_false() 
                  // Need to double check RAM for this, but it might just be as simple as 
                  // is_player_board_active
                  // is_enemy_board_active
                  // did_score_overwrite
                  // Note these are all relative to the ARCADE mode, so it may be easier to simply check at all times if any of those 10 score slots was overridden
                  // The board is different!
)

// High Score acknowledgement

achievement(
    title = "[NEEDS TITLE]Octopuzzle High Score",
    points = 5,
    description = "Record a score of 100,000,000 or higher in Octopuzzle on Fighter or above.",
    trigger = is_playing_octopuzzle() 
        && leaderboard_available_to_enter() 
        && OctoBoard(PLAYER_BOARD).current_score() >= 100000000 
)

achievement(
    title = "[NEEDS TITLE]Octopus Fact 1-1",
    points = 5,
    description = "Get 3 or more licenses through Original Endless.",
    trigger = is_playing_endless()
        && prev(license_count()) == 2
        && measured(license_count() == 3, when=always_true(), format="raw") 
)

achievement(
    title = "[NEEDS TITLE]Octopus Fact 1-2",
    points = 5,
    description = "Get 6 or more licenses through Original Endless.",
    trigger = is_playing_endless()
        && prev(license_count()) == 5
        && measured(license_count() == 6, when=always_true(), format="raw") 
)

achievement(
    title = "[NEEDS TITLE]Octopus Fact 1-3",
    points = 5,
    description = "Get 9 or more licenses through Original Endless.",
    trigger = is_playing_endless()
        && prev(license_count()) == 8
        && measured(license_count() == 9, when=always_true(), format="raw") 
)

achievement(
    title = "[NEEDS TITLE] Octopus Fact 1",
    points = 5,
    description = "Get 5 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && prev(title_count()) == 4
        && measured(title_count() == 5, when=always_true(), format="raw")
)

achievement(
    title = "[NEEDS TITLE]Octopus Fact 2",
    points = 10,
    description = "Get 10 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && prev(title_count()) == 9
        && measured(title_count() == 10, when=always_true(), format="raw")
)

achievement(
    title = "[NEEDS TITLE]Octopus Fact 3",
    points = 10,
    description = "Get 15 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && prev(title_count()) == 14
        && measured(title_count() == 15, when=always_true(), format="raw")
)

achievement(
    title = "[NEEDS TITLE]Octopus Fact 4",
    points = 25,
    description = "Get 20 or more titles through Original Endless.",
    trigger = is_playing_endless()
        && prev(title_count()) == 14
        && measured(title_count() == 20, when=always_true(), format="raw")
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

// TODO start here and get RP right
// General cases:
// learning about Arcade in Tutorial
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

// - viewing character profiles in Tutorial
rich_presence_conditional_display(
    is_in_tutorial(),
    "Learning more about the wonders of octopi and Lonronpia"
)

// - playing Octopuzzle (include who they're fighting against)
rich_presence_conditional_display(
    is_playing_octopuzzle(), 
    "{0} is challenging {1} to Octopuzzle on {2} difficulty",
    rich_presence_lookup("characters", OctoCharacter(PLAYER_ONE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("characters", OctoCharacter(PLAYER_THREE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("difficulty", OctoBoard(PLAYER_BOARD).current_difficulty(), DIFFICULTY)
)
// - playing Arcade (include who they're fighting against)
rich_presence_conditional_display(
    is_playing_arcade(),
    "Kari is powering through Arcade mode",
    rich_presence_lookup("characters", OctoCharacter(PLAYER_THREE).current_character(), CHARACTER_IDS),
    rich_presence_lookup("difficulty", OctoBoard(PLAYER_BOARD).current_difficulty(), DIFFICULTY)
)

// - playing Endless
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