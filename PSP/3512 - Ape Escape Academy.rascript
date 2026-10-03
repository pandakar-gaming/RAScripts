// Ape Escape Academy
// #ID = 3512

function ptr_valid(addr) => addr >= 0x08000000 && addr <= 0x09ffffff 
function mask_ptr(addr) => dword(addr) & 0x1FFFFFF

// $879B62: [8-bit] Survival mode
//          0x00 = Mind
//          0x01 = Tech
//          0x02 = Body
//          0x03 = Cross-genre
function survival_mode() => byte(0x879B62)

// $87A450: [32-bit Pointer] Pointer to Salvage's Manager section
//          
//          +0x4a0 Constant of "src/031_saruvage/manager.c". Header for Salvage section that we care about. [ASCII Text]
//          +0x4a4 Constant of "031_", game ID substring from above header. [ASCII Text]
//          +0x55c Flag that indicates if you lost this round of Salvage. Presumed to be 32-bit given the other variables in the space. [32-bit]
//          0x00 = Player has not lost Salvage
//          0x01 = Player has lost Salvage
//          +0x568 Current number of chests grabbed in Salvage. In Endless mode, you can only get up to 6. [32-bit]
//          +0x56c Likely the number of chests you could grab in Salvage. In Endless mode, this only goes up to 5. [32-bit]
//          +0x578 Flag that indicates if you grabbed the chest. Presumed to be 32-bit given the other variables in this space. [32-bit]
//          0x00 = Player has not grabbed the chest
//          0x01 = Player has grabbed the chest
function pointer_to_salvages_manager_section() => dword(0x87A450)
function constant_of_031_game_id_substring_from_above_header() => dword((pointer_to_salvages_manager_section() & 0x1FFFFFF) + 0x0004A4)
function flag_that_indicates_if_you_lost_this_round_of_salvage_presumed_to_be_32_bit_given_the_other_variables_in_the_space() => dword((pointer_to_salvages_manager_section() & 0x1FFFFFF) + 0x00055C)
function current_number_of_chests_grabbed_in_salvage_in_endless_mode_you_can_only_get_up_to_6() => dword((pointer_to_salvages_manager_section() & 0x1FFFFFF) + 0x000568)
function current_number_of_chests_grabbed_in_salvage_in_endless_mode_you_can_only_get_up_to_6_byte() => byte((pointer_to_salvages_manager_section() & 0x1FFFFFF) + 0x000568)
function flag_that_indicates_if_you_grabbed_the_chest_presumed_to_be_32_bit_given_the_other_variables_in_this_space() => dword((pointer_to_salvages_manager_section() & 0x1FFFFFF) + 0x000578)

// $882323: [8 bytes] Filename being loaded by the game from the disc
//          
//          This is where the variability of filenames loaded into memory begins.
//          
//          This note denotes both 4-byte and 8-byte values. Specifically, only the parts being keyed in on - the part of this filename string that's sufficient to uniquely identify it. These are denoted as needed to be matched against, since this game uses little-endian addressing.
//          
//          ** 4-byte values **
//          0x5f313030 = 001_ - 001_zentai.bin - Ape the Ape
//          0x5f323030 = 002_ - 002_ukkiranning.bin - Morning Jog
//          0x5f333030 = 003_ - 003_monmer.bin - Hammer Throw
//          0x5f343030 = 004_ - 004_jugmong.bin - Street Juggler
//          0x5f373030 = 007_ - 007_tarzaru.bin - Enter the Monkey I
//          0x5f303130 = 010_ - 010_mongiri.bin - Spot the Difference
//          0x5f313130 = 011_ - 011_quiz1.bin - Ask Darwin
//          0x5f323130 = 012_ - 012_run1m.bin - 1.00m Dash
//          0x5f353130 = 015_ - 015_guardian.bin - Banana Guardian
//          0x5f363130 = 016_ - 016_maimumaimu.bin - Red Hot Jig
//          0x5f373130 = 017_ - 017_saruryouri.bin - Chef Chimpy
//          0x5f393130 = 019_ - 019_bridge.bin - Monkey Balancing
//          0x5f323230 = 022_ - 022_ohineri.bin - A Rose, Monsieur?
//          0x5f333230 = 023_ - 023_vision.bin - Monkavision
//          0x5f343230 = 024_ - 024_golf.bin - Every Monkey's Golf
//          0x5f353230 = 025_ - 025_tasogare.bin - Mon Quixote
//          0x5f393230 = 029_ - 029_sasuke.bin - Enter the Monkey II
//          0x5f313330 = 031_ - 031_saruvage.bin - Salvage
//          0x5f323330 = 032_ - 032_fighter.bin - Karate Chimpster
//          0x5f383330 = 038_ - 038_saruhirari.bin - Monkey Ole
//          0x5f393330 = 039_ - 039_sarusasu.bin - Shishkebab Special
//          0x5f303430 = 040_ - 040_sarulaser.bin - Monkey Dodgeball
//          0x5f333430 = 043_ - 043_wrestle.bin - Simian Suplex
//          0x5f363430 = 046_ - 046_saruinsky.bin - Geronimo
//          0x5f373430 = 047_ - 047_monkysoccer.bin - Monkey Soccer
//          0x5f383430 = 048_ - 048_granturismon.bin - Gran Turismonkey
//          0x5f343530 = 054_ - 054_xal.bin - Monkey Dice
//          0x5f353530 = 055_ - 055_osarux.bin - Spectre Z. Note that this may not actually show up here, but it's being noted for completeness.
//          0x5f373530 = 057_ - 057_shateki.bin - Pot Shots
//          0x5f383530 = 058_ - 058_bunsinnojyutu.bin - Enter the Monkey III
//          0x5f393530 = 059_ - 059_shiryokukensa.bin - Monkey Drills
//          0x5f303630 = 060_ - 060_bakudan.bin - Bombermonkey
//          0x5f323630 = 062_ - 062_monkyball.bin - Monkey Bowling
//          0x5f353630 = 065_ - 065_air.bin - Monkey Hockey
//          0x5f363630 = 066_ - 066_pipowars.bin - Monkeytech
//          0x5f373630 = 067_ - 067_koutsu.bin - Monkey Watching
//          0x5f323038 = 802_ - 802_graduation.bin - Player Won
//          0x5f333038 = 803_ - 803_staff.bin - Credits
//          0x5f313039 = 901_ - 901_mainmenu.bin - Main Menu
//          0x5f313139 = 911_ - 911_academia.bin - Academy Mode
//          0x5f313239 = 921_ - 921_rehearsal.bin - Mini-Game Selection
//          0x5f313339 = 931_ - 931_versus.bin
//          0x5f303439 = 940_ - 940_salonmenu.bin - Trophy Showcase
//          
//          ** 8-byte values **
//          Note that all of these presume a prefix of 0x2f637275 = "src/".
//          
//          0x5f313439 = 941_ -- 941_salon/junior1.res -- Trophy Screen, Junior 1 Section
CURRENT_BINARY_LOADED = dword(0x882323)
function current_binary_is(binary_name) {
    binary_prefix = 0xffffffff
    if (binary_name == "Ape the Ape") {
        binary_prefix = 0x5f313030
    } else if (binary_name == "Morning Jog") {
        binary_prefix = 0x5f323030
    } else if (binary_name == "Hammer Throw") {
        binary_prefix = 0x5f333030
    } else if (binary_name == "Street Juggler") {
        binary_prefix = 0x5f343030
    } else if (binary_name == "Enter the Monkey I") {
        binary_prefix = 0x5f373030
    } else if (binary_name == "Spot the Difference") {
        binary_prefix = 0x5f303130
    } else if (binary_name == "Ask Darwin") {
        binary_prefix = 0x5f313130
    } else if (binary_name == "1.00m Dash") {
        binary_prefix = 0x5f323130
    } else if (binary_name == "Banana Guardian") {
        binary_prefix = 0x5f353130
    } else if (binary_name == "Red Hot Jig") {
        binary_prefix = 0x5f363130
    } else if (binary_name == "Chef Chimpy") {
        binary_prefix = 0x5f373130
    } else if (binary_name == "Monkey Balancing") {
        binary_prefix = 0x5f393130
    } else if (binary_name == "A Rose, Monsieur?") {
        binary_prefix = 0x5f323230
    } else if (binary_name == "Monkavision") { 
        binary_prefix = 0x5f333230
    } else if (binary_name == "Every Monkey's Golf") {
        binary_prefix = 0x5f343230
    } else if (binary_name == "Mon Quixote") {
        binary_prefix = 0x5f353230
    } else if (binary_name == "Enter the Monkey II") {
        binary_prefix = 0x5f393230
    } else if (binary_name == "Salvage") {
        binary_prefix = 0x5f313330
    } else if (binary_name == "Karate Chimpster") {
        binary_prefix = 0x5f323330
    } else if (binary_name == "Monkey Ole") {
        binary_prefix = 0x5f383330
    } else if (binary_name == "Shishkebab Special") {
        binary_prefix = 0x5f393330
    } else if (binary_name == "Monkey Dodgeball") {
        binary_prefix = 0x5f303430
    } else if (binary_name == "Simian Suplex") {
        binary_prefix = 0x5f333430
    } else if (binary_name == "Geronimo") {
        binary_prefix = 0x5f363430
    } else if (binary_name == "Monkey Soccer") {
        binary_prefix = 0x5f373430
    } else if (binary_name == "Gran Turismonkey") {
        binary_prefix = 0x5f383430
    } else if (binary_name == "Monkey Dice") { 
        binary_prefix = 0x5f343530
    } else if (binary_name == "Specter Z") {
        binary_prefix = 0x5f353530
    } else if (binary_name == "Pot Shots") { 
        binary_prefix = 0x5f373530
    } else if (binary_name == "Enter the Monkey III") { 
        binary_prefix = 0x5f383530
    } else if (binary_name == "Monkey Drills") {
        binary_prefix = 0x5f393530
    } else if (binary_name == "Bombermonkey") {
        binary_prefix = 0x5f303630
    } else if (binary_name == "Monkey Bowling") {
        binary_prefix = 0x5f323630
    } else if (binary_name == "Monkey Hockey") {
        binary_prefix = 0x5f353630
    } else if (binary_name == "Monkeytech") {
        binary_prefix = 0x5f363630
    } else if (binary_name == "Monkey Watching") {
        binary_prefix = 0x5f373630
    } else if (binary_name == "Graduation") {
        binary_prefix = 0x5f323038
    } else if (binary_name == "Credits") {
        binary_prefix = 0x5f333038
    } else if (binary_name == "Main Menu") {
        binary_prefix = 0x5f313039
    } else if (binary_name == "Academy Mode") {
        binary_prefix = 0x5f313139
    } else if (binary_name == "Mini-Game Selection") {
        binary_prefix = 0x5f313239
    } else if (binary_name == "Versus") {
        binary_prefix = 0x5f313339
    } else if (binary_name == "Trophy Showcase") {
        binary_prefix = 0x5f303439
    }

    return CURRENT_BINARY_LOADED == binary_prefix
}

// $882327: [20 bytes] Portion of filename being loaded from disc by game
//          For some reason, when fighting against Specter, this is offset. Many of the files will load in a way that looks like the following sequence of events:
//          
//          disc0:PSP_GAME/USRDIR/src/921_rehearsal/921_rehearsal.res
//          then after loading it goes to
//          disc0:PSP_GAME/USRDIR/921_rehearsal/921_rehearsal.bin
//          
//          Basically, loading two files. Specter.Z doesn't seem to need to do that, so the actual ID of the game being loaded appears here as a full string looking like
//          
//          disc0:PSP_GAME/USRDIR/src/055_osarux/floor{n}.res.
//          
//          0x5f353530 = 055_ - 055_osarux
//          floor1
//          floor2
//          floor3
//          floor4
//          floor5
//          floor6
SPECTER_BINARY_FLOOR_NAME = dword(0x882327)

// $882331: [5 bytes] Substring of the disc's file being loaded that indicates what year of Academy mode you're in.
//          
//          Strings seen (relevant portion starting here):
//          
//          year1.res
//          year2.res
//          year3.res
//          year4.res
//          year5.res
ACADEMY_YEAR_RES_NAME = dword(0x882331)

// $882335: [8-bit] ASCII portion of the "year" that you're in when in Academy mode.
//          0x31 = 1
//          0x32 = 2
//          0x33 = 3
//          0x34 = 4
//          0x35 = 5
//          0x36 = 6
//          
//          These values presume that they are suffixed onto a string that looks like "/year".
ACADEMY_YEAR_ASCII = byte(0x882335)

// $882710: [32-bit Pointer] Pointer to Every Monkey's Golf
//          +0x40 Pointer to the middle of a struct for game metadata [32-bit]
//          ++ffffffc0 Beginning of struct and pointer to next node [32-bit]
//          Yes, this is negative. However, it's close enough to where we land in the struct and I'm confident that this is part of the same struct.
//          ++ffffffc4 Pointer to previous node [32-bit]
//          +++0x04 Pointer to previous node [32-bit]
//          ++++0x48 Pointer to score for Every Monkey's Golf [32-bit]
//          +++++0xe0 Constant of "src/024_golf/score.c", a section header for the mini-game containing score info. [ASCII TEXT]
//          +++++0xe4 Constant of "024_", substring containing game ID from above. [ASCII TEXT]
//          +++++0x100 Your score [32-bit]
//          +++++0x180 Score cutoff the game enforces [32-bit]
EVERY_MONKEYS_GOLF_PTR = dword(0x882710)
function pointer_to_every_monkeys_golf() => dword(0x882710)
function pointer_to_the_middle_of_a_struct_for_game_metadata() => dword((pointer_to_every_monkeys_golf() & 0x1FFFFFF) + 0x000040)

// $8827C0: [32-bit Pointer] Pointer to player information during Bombermonkey.
//          
//          +0x8360 Constant of "src/060_bakudan/player.c", section header for the game's player status. [ASCII Text]
//          +0x8364 Constant of "060_", substring of the above containing game ID. [ASCII Text]
//          +0x83c4 Flag for whether the player has been blown up
//          0x00 = Player is still running around and playing
//          0x01 = Player has been hit by a bomb
//          
//          Observation: this seems to point to many mini-games. It's reliable enough for Bombermonkey, but in theory someone could use it for other mini-games too.
function pointer_to_player_information_during_bombermonkey() => dword(0x8827C0)
function flag_for_whether_the_player_has_been_blown_up() => byte((pointer_to_player_information_during_bombermonkey() & 0x1FFFFFF) + 0x0083C4)

// $8827C4: [32-bit Pointer] Pointer to Monkey Hockey scoring information
//          
//          This mini-game will have slightly different offsets depending on whether you're playing from Academy Mode or if you are playing from the Mini-game Collection. This is likely due to the mini-game collection tacking on a timer.
//          
//          *** MINI-GAME COLLECTION OFFETS ***
//          
//          +0x7be0 Constant of "src/065_air/score.c". One of the section headers that we care about for this game. [ASCII Text]
//          +0x7be4 Constant of "065_", game ID substring from above header. [ASCII Text]
//          +0x7bec Constant of "scor", filename substring from above header. [ASCII Text]
//          +0x7c18 Player score in the game. [32-bit]
//          +0x7c1c Enemy score in the game. [32-bit]
//          
//          *** ACADEMY MODE OFFSETS ***
//          
//          +0x7a60 Constant of "src/065_air/score.c". One of the section headers that we care about for this game. [ASCII Text]
//          +0x7a64 Constant of "065_", game ID substring from above header. [ASCII Text]
//          +0x7a6c Constant of "scor", filename substring from above header. [ASCII Text]
//          +0x7a98 Player score in the game. [32-bit]
//          +0x7a9c Enemy score in the game. [32-bit]
function pointer_to_monkey_hockey_scoring_information() => dword(0x8827C4)
function constant_of_065_game_id_substring_from_above_header_ascii_text() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007A64)
function constant_of_scor_filename_substring_from_above_header_ascii_text() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007A6C)
function player_score_in_the_game() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007A98)
function enemy_score_in_the_game() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007A9C)
function constant_of_065_game_id_substring_from_above_header_ascii_text_2() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007BE4)
function constant_of_scor_filename_substring_from_above_header_ascii_text_2() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007BEC)
function player_score_in_the_game_2() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007C18)
function enemy_score_in_the_game_2() => dword((pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF) + 0x007C1C)

// $886834: [32-bit Pointer] Pointer to Monkey Watching scoring information
//          
//          +0x6fa0 Constant of "src/067_koutsu/game.c". Header for Monkey Watching section we care about. [ASCII Text]
//          +0x6fa4 Constant of "067_", substring of above containing game ID. [ASCII Text]
//          +0x6fc0 Number of monkeys that will run by on the first wave. [32-bit]
//          +0x6fc4 Number of monkeys that will run by on the second wave. [32-bit]
//          +0x6fc8 Number of monkeys that will run by on the third wave. [32-bit]
//          +0x6fcc Index of the wave of monkeys running by. This pairs with the previous three addresses. When this is done, this flips back to 0 and the game replays the monkeys to verify the count. [32-bit]
//          +0x6fd0 Number of monkeys that the player has counted. [32-bit]
//          +0x6fd4 Number of consecutive games that you've won in Monkey Counting. [32-bit]
function pointer_to_monkey_watching_scoring_information() => dword(0x886834)
function constant_of_067_substring_of_above_containing_game_id() => dword((pointer_to_monkey_watching_scoring_information() & 0x1FFFFFF) + 0x006FA4)
function number_of_consecutive_games_that_youve_won_in_monkey_counting() => dword((pointer_to_monkey_watching_scoring_information() & 0x1FFFFFF) + 0x006FD4)

// $898CA4: [32-bit Pointer] Pointer to Senior yr 3 game data
//          +0x00 Pointer to struct containing player and boss HP [32-bit Pointer]
//          ++0x44 Floor we're on [32-bit]
//          ++0x54 Player HP [Float]
//          ++0x58 Copy of Player HP [Float]
//          ++0x5c Copy of Boss HP, but it sometimes does weird stuff so use the other value [Float]
//          ++0x60 Boss HP [Float]
function pointer_to_senior_yr_3_game_data() => dword(0x898CA4)
function pointer_to_struct_containing_player_and_boss_hp() => dword(pointer_to_senior_yr_3_game_data() & 0x1FFFFFF)
function floor_were_on() => dword((pointer_to_senior_yr_3_game_data() & 0x1FFFFFF) + (pointer_to_struct_containing_player_and_boss_hp() & 0x1FFFFFF) + 0x000044)
function boss_hp() => float((pointer_to_senior_yr_3_game_data() & 0x1FFFFFF) + (pointer_to_struct_containing_player_and_boss_hp() & 0x1FFFFFF) + 0x000060)

// $898CA8: [32-bit Pointer] Pointer to Bombermonkey Stats.
//          
//          +0x34 = Pointer to number of times you've served a monkey bombs. [32-bit]
//          ++0x00 Number of times the player has passed bombs off to a monkey on the side. [32-bit]
//          +0x48 = This correlates to the number of bombs that have been served. [32-bit]
//          If playing from Academy Mode: This starts at the number of bombs you must serve and counts down.
//          If playing from the Mini-Game collection: This starts at 0 and counts up as you serve bombs.
function pointer_to_bombermonkey_stats() => dword(0x898CA8)
function this_correlates_to_the_number_of_bombs_that_have_been_served() => dword((pointer_to_bombermonkey_stats() & 0x1FFFFFF) + 0x000048)

// $898CB8: [32-bit Pointer] Pointer to Ask Darwin
//          +0x34 Pointer to score section for Ask Darwin [32-bit Pointer]
//          ++0x10 Number of questions answered correctly by the player. [32-bit]
//          ++0x2c Number of questions asked by the game. [32-bit]
ASK_DARWIN_PTR = dword(0x898CB8)
function pointer_to_ask_darwin() => dword(0x898CB8)
function pointer_to_score_section_for_ask_darwin() => dword((pointer_to_ask_darwin() & 0x1FFFFFF) + 0x000034)
function number_of_questions_answered_correctly_by_the_player() => dword((pointer_to_ask_darwin() & 0x1FFFFFF) + (pointer_to_score_section_for_ask_darwin() & 0x1FFFFFF) + 0x000010)
function number_of_questions_asked_by_the_game() => dword((pointer_to_ask_darwin() & 0x1FFFFFF) + (pointer_to_score_section_for_ask_darwin() & 0x1FFFFFF) + 0x00002C)

// $898CD0: [32-bit Pointer] Pointer to Academy Mode bingo board stats
//          +0x34 Pointer to bingo.c section [32-bit]
//          ++0x34 Counter for how many line combinations iterated over at end of Bingo [32-bit]
//          ++0x38 Number of lines made at end of Bingo [32-bit]
function pointer_to_academy_mode_bingo_board_stats() => dword(0x898CD0)
function pointer_to_bingo_c_section() => dword((pointer_to_academy_mode_bingo_board_stats() & 0x1FFFFFF) + 0x000034)
function counter_for_how_many_line_combinations_iterated_over_at_end_of_bingo() => dword((pointer_to_academy_mode_bingo_board_stats() & 0x1FFFFFF) + (pointer_to_bingo_c_section() & 0x1FFFFFF) + 0x000034)
function number_of_lines_made_at_end_of_bingo() => dword((pointer_to_academy_mode_bingo_board_stats() & 0x1FFFFFF) + (pointer_to_bingo_c_section() & 0x1FFFFFF) + 0x000038)

// $898CDC: [32-bit Pointer] Pointer to Mon Quixote Scoring Stats
//          +0x34 Pointer to Mon Quixote Score [32-bit Pointer]
//          ++0x00 Number of arrows blocked in Mon Quixote [32-bit]
function pointer_to_mon_quixote_scoring_stats() => dword(0x898CDC)
function pointer_to_mon_quixote_score() => dword((pointer_to_mon_quixote_scoring_stats() & 0x1FFFFFF) + 0x000034)
function number_of_arrows_blocked_in_mon_quixote() => dword(pointer_to_mon_quixote_scoring_stats() & 0x1FFFFFF) + (pointer_to_mon_quixote_score() & 0x1FFFFFF)

// $898CF8: [32-bit] Pointer to Enter the Monkey II Scoring Stats.
//          Likely only relevant during Endless Play (minigame collection.
//          +0x34 Pointer to scoring stats [32-bit]
//          ++0x00 Current number of floors you've climbed [32-bit]
function pointer_to_enter_the_monkey_ii_scoring_stats() => dword(0x898CF8)
function pointer_to_scoring_stats() => dword((pointer_to_enter_the_monkey_ii_scoring_stats() & 0x1FFFFFF) + 0x000034)
function current_number_of_floors_youve_climbed() => dword(pointer_to_enter_the_monkey_ii_scoring_stats() & 0x1FFFFFF) + (pointer_to_scoring_stats() & 0x1FFFFFF)

// $E40CC0: [32-bit] Score when playing Enter the Monkey I via the Mini-game collection.
//          
//          This note is duplicated because the mini-game is dynamically allocated but no root pointer could be found to reliably lead to this section.
function score_when_playing_enter_the_monkey_i_via_the_minigame_collection() => dword(0xE40CC0)

// $EB4B80: [8-bit] Page of mini-game selection you're on
//          0x00 = Favourites
//          0x01 = Mind
//          0x02 = Tech
//          0x03 = Body
//          0x04 = Special
function page_of_minigame_selection_youre_on() => byte(0xEB4B80)

// $EB4B82: [8-bit] Some constant of 0x05. This appears when I'm selecting mini-games.
//          Likely indicating max number of rows.
function some_constant_of_0x05_this_appears_when_im_selecting_minigames() => byte(0xEB4B82)

// $145E310: [32-bit Pointer] Pointer to Mon Quixote game information
//           
//           +0x2ae0 Constant of "src/025_tasogare/saru.c", a header in Mon Quixote indicating information about the monkey. [23 bytes]
//           +0x2ae4 Constant of "025_", game ID substring from the above. [4 bytes]
//           +0x2af1 Constant of "saru", substring from above. [4 bytes]
//           +0x2bc8 How many times the monkey has been hit in Mon Quixote. In Academy Play, monkey can be hit multiple times; in endless, only once. [32-bit]
function pointer_to_mon_quixote_game_information() => dword(0x145E310)
function constant_of_025_game_id_substring_from_the_above() => dword((pointer_to_mon_quixote_game_information() & 0x1FFFFFF) + 0x002AE4)
function constant_of_saru_substring_from_above() => dword((pointer_to_mon_quixote_game_information() & 0x1FFFFFF) + 0x002AF1)
function how_many_times_the_monkey_has_been_hit_in_mon_quixote_in_academy_play_monkey_can_be_hit_multiple_times_in_endless_only_once() => dword((pointer_to_mon_quixote_game_information() & 0x1FFFFFF) + 0x002BC8)

// $15C8120: [32-bit Pointer] Pointer to Morning Jog.
//           
//           +0x4be0 Constant of "src/002_ukkiranning/game.c". Section header for Morning Jog performance. [ASCII Text]
//           +0x4be4 Constant of "002_", game ID substring from above. [ASCII Text]
//           +0xb50c Number of "great" hits where player matched note as well as they could. [32-bit]
//           +0xb510 Number of "good" hits. Almost off, but the game gave it to the player. [32-bit]
PTR_MORNING_JOG = dword(0x00879c14)
ADDR_PTR_MORNING_JOG = 0x00879c14


// $15E4F20: [32-bit Pointer] Pointer to Shishkebab Special
//           
//           +0x27a0 Constant of "src/039_sarusasu/score.c". One of the section headers that we care about for this mini-game. [ASCII Text]
//           +0x27a4 Constant of "039_", a substring from the above section header indicating game ID. [ASCII Text]
//           +0x27b1 Constant of "scor", substring from prior header. [4 bytes]
//           +0x27b5 Constant of "e.c", substring from prior header. [3 bytes]
//           +0x27c0 Your score during Shishkebab Special. [32-bit]
SHISHKEBAB_PTR_ADDR = 0x898CB8
SHISHKEBAB_PTR = dword(0x898CB8)
SHISHKEBAB_TIMER_ADDR = 0x00898cc4
SHISHKEBAB_TIMER_PTR = dword(0x00898cc4)

// $1A71050: [32-bit] Player's health in Monkey Dice. Player starts with 3 health. Goes down in increments of 1 if the player gets hit.
function players_health_in_monkey_dice_player_starts_with_3_health_goes_down_in_increments_of_1_if_the_player_gets_hit() => dword(0x1A71050)

// $1A71054: [32-bit]  Enemy's health in Monkey Dice. Enemy starts with 3 health. Goes down in increments of 1 if the enemy gets hit.
function enemys_health_in_monkey_dice_enemy_starts_with_3_health_goes_down_in_increments_of_1_if_the_enemy_gets_hit() => dword(0x1A71054)

// $1A72D84: [32-bit Pointer] Pointer to Enter the Monkey II, specifically the part tracking the monkey
//           
//           +0x220 Constant of "src/029_sasuke/Saru.c". This section contains information around the player during the mini-game. [ASCII Text]
//           +0x224 Constant of "029_", substring of the above. [ASCII Text]
//           +0x22f Constant of "Saru", substring of the above. [ASCII Text]
//           +0x514 Flag indicating whether the game is complete or not. [8-bit]
//           0x00=Monkey can jump between walls (playing the game)
//           0x01=Walls have closed and game is done
//           
//           ** UNRELIABLE, FIXING **
//           +0x84e0 Constant of "src/029_sasuke/score.c". When playing from the Mini-game collection, this section is used to hold score-centric information. [ASCII Text]
//           +0x84e4 Constant of "029_", substring of the above. [ASCII Text]
//           +0x84ef Constant of "scor", substring of the above header. [ASCII Text]
//           +0x84f3 Constant of "e.c", substring of above. [ASCII Text]
//           +0x8500 Number of walls player has scaled [32-bit]
function pointer_to_enter_the_monkey_ii_specifically_the_part_tracking_the_monkey() => dword(0x1A72D84)
function constant_of_029_substring_of_the_above() => dword((pointer_to_enter_the_monkey_ii_specifically_the_part_tracking_the_monkey() & 0x1FFFFFF) + 0x000224)
function constant_of_saru_substring_of_the_above() => dword((pointer_to_enter_the_monkey_ii_specifically_the_part_tracking_the_monkey() & 0x1FFFFFF) + 0x00022F)
function flag_indicating_whether_the_game_is_complete_or_not() => byte((pointer_to_enter_the_monkey_ii_specifically_the_part_tracking_the_monkey() & 0x1FFFFFF) + 0x000514)

// $1BE7914: [8-bit] y-coordinate when selecting your year in Academy Mode
//           0x00 = Junior Yr. 1
//           0x01 = Junior Yr. 2
//           0x02 = Junior Yr. 3
//           0x03 = Senior Yr. 1
//           0x04 = Senior Yr. 2
//           0x05 = Senior Yr. 3
function ycoordinate_when_selecting_your_year_in_academy_mode() => byte(0x1BE7914)

ClassYearLookup = {
    0: "Junior Yr.1",
    1: "Junior Yr.2",
    2: "Junior Yr.3",
    3: "Senior Yr.1",
    4: "Senior Yr.2",
    5: "Senior Yr.3",
}

// $1BE7918: [8-bit] When this section is Year Select, indicates whether the mode has been selected.
//           0x01 = Ready to Select
//           0x02 = Selected, time to load everything
function when_this_section_is_year_select_indicates_whether_the_mode_has_been_selected() => byte(0x1BE7918)

// $1C15180: [32-bit] Score when playing Enter the Monkey I via the Mini-game collection.
//           
//           This note is duplicated because the mini-game is dynamically allocated but no root pointer could be found to reliably lead to this section.
function score_when_playing_enter_the_monkey_i_via_the_minigame_collection_2() => dword(0x1C15180)

// $1CE14F4: [32-bit Pointer] Pointer to Red Hot Jig.
//           This is reused for every variant, with different note track and BGM.
//           
//           +0x2a0 Constant of "src/016_maimumaimu/game.c", section header for game. [ASCII Text]
//           +0x2a4 Constant of "016_", game ID substring from above header. [ASCII Text]
//           +0x2cc Number of Great Hits [32-bit]
//           +0x2d0 Number of OK Hits [32-bit]
//           +0x2d4 Number of Misses [32-bit]
//           +0x2e0 = Background track loaded [ASCII Text]
//           BGM0_CNF3=Oklahoma Mixer
//           BGM1_CNF3=Korobushka
//           BGM2_CNF3=One Week
function pointer_to_red_hot_jig() => dword(0x1CE14F4)
function number_of_great_hits() => dword((pointer_to_red_hot_jig() & 0x1FFFFFF) + 0x0002CC)
function number_of_ok_hits() => dword((pointer_to_red_hot_jig() & 0x1FFFFFF) + 0x0002D0)
function number_of_misses() => dword((pointer_to_red_hot_jig() & 0x1FFFFFF) + 0x0002D4)
function background_track_loaded() => dword((pointer_to_red_hot_jig() & 0x1FFFFFF) + 0x0002E0)

// $1CE3274: [32-bit Pointer] Pointer to Monkey Drill
//           
//           +0xe0 Constant of "src/059_shiryokukensa/game.c", section header for game. [ASCII Text]
//           +0xe4 Constant of "059_", game ID substring from above header. [ASCII Text]
//           +0xf6 Constant of "game", filename substring from above header. [ASCII Text]
//           +0x108 Difficulty [32-bit]
//           0x03=Drills 1
//           0x0b=Drills 2
//           0x13=Drills 3
//           0x1b=Drills 4
//           +0x114 Current Score [32-bit]
//           +0x194 Whether Square is the correct answer [32-bit]
//           0x17=Incorrect
//           0x18=Correct
//           +0x198 Whether Triangle is the correct answer [32-bit]
//           0x17=Incorrect
//           0x18=Correct
//           +0x19c Whether Cross is the correct answer [32-bit]
//           0x17=Incorrect
//           0x18=Correct
//           +0x1a0 Whether Circle is the correct answer [32-bit]
//           0x17=Incorrect
//           0x18=Correct
function pointer_to_monkey_drill() => dword(0x1CE3274)
function constant_of_059_game_id_substring_from_above_header() => dword((pointer_to_monkey_drill() & 0x1FFFFFF) + 0x0000E4)
function constant_of_game_filename_substring_from_above_header() => dword((pointer_to_monkey_drill() & 0x1FFFFFF) + 0x0000F6)
function difficulty() => byte((pointer_to_monkey_drill() & 0x1FFFFFF) + 0x000108)
function current_score() => dword((pointer_to_monkey_drill() & 0x1FFFFFF) + 0x000114)

// $1CE38F4: [32-bit Pointer] Pointer to Gran Turismonkey
//           
//           +0x720 Constant of "src/048_granturismon/game.c", section header containing progress information for game. [ASCII Text]
//           +0x724 Constant of "048_", substring of above indicating game ID [ASCII Text]
//           +0x828 Number of moves player has successfully made to wash car [32-bit]
//           +0x82c Number of moves player needs to complete washing car [32-bit]
//           +0x830 Number of frames that have passed over course of game, running from the 0.00 to 30.00 mark. [32-bit]
//           +0x834 Max frame count for game, 0x0708. Constant. [32-bit]
//           +0x848 Countdown for game.
//           0x02=3 on Screen
//           0x01=2 on Screen
//           0x00=1 on Screen. Instead of going to -1, next attempted decrement starts game.
//           +0x850 Number of X inputs remaining to wash right side of the car. Starts at 0x0f. [32-bit]
//           +0x854 Number of X inputs remaining to wash front of the car. Starts at 0x14. [32-bit]
//           +0x858 Number of X inputs remaining to wash left side of the car. Starts at 0x19. [32-bit]
//           +0x85c Number of X inputs remaining to wash back side of the car. Starts at 0x0a. [32-bit]
//           +0x860 Number of X inputs remaining to wash the top of the car. Starts at 0x1e. [32-bit]
function pointer_to_gran_turismonkey() => dword(0x1CE38F4)
function constant_of_048_substring_of_above_indicating_game_id() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x000724)
function number_of_moves_player_has_successfully_made_to_wash_car() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x000828)
function number_of_moves_player_needs_to_complete_washing_car() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x00082C)
function number_of_x_inputs_remaining_to_wash_right_side_of_the_car_starts_at_0x0f() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x000850)
function number_of_x_inputs_remaining_to_wash_front_of_the_car_starts_at_0x14() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x000854)
function number_of_x_inputs_remaining_to_wash_left_side_of_the_car_starts_at_0x19() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x000858)
function number_of_x_inputs_remaining_to_wash_back_side_of_the_car_starts_at_0x0a() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x00085C)
function number_of_x_inputs_remaining_to_wash_the_top_of_the_car_starts_at_0x1e() => dword((pointer_to_gran_turismonkey() & 0x1FFFFFF) + 0x000860)

// $1CE3C74: [32-bit Pointer] Pointer to Monkey Ole
//           
//           +0x1a0 Constant of "src/038_saruhirari/game.c". Section header that we care about. [ASCII Text]
//           +0x1a4 Constant of "022_", game ID substring from above header. [ASCII Text]
//           +0x1d0 Pointer that disappears when the "Start!" text fades away from the screen. This is likely pointing to that text, or something identifying that text. [32-bit]
//           +0x1d4 Number of bulls you've successfully dodged. [32-bit]
//           +0x1dc Active "Ole!" combo. [32-bit]
//           +0x1ec Number of frames until your "Ole!" combo drops [32-bit]
function pointer_to_monkey_ole() => dword(0x1CE3C74)
function constant_of_022_game_id_substring_from_above_header_ascii_text_2() => dword((pointer_to_monkey_ole() & 0x1FFFFFF) + 0x0001A4)
function active_ole_combo() => dword((pointer_to_monkey_ole() & 0x1FFFFFF) + 0x0001DC)
function number_of_frames_until_your_ole_combo_drops() => dword((pointer_to_monkey_ole() & 0x1FFFFFF) + 0x0001EC)

// $1CE5204: [32-bit Pointer] Pointer to Monkey Dodgeball
//           
//           +0x8e0 Constant of "src/040_sarulaser/game.c". This is the section header that we care about. [ASCII Text]
//           +0x8e4 Constant of "040_", game ID substring from above header. [ASCII Text]
//           +0x90c: Pointer to something. I don't know what, but it's significant because it only pops up when the player gets hit. [32-bit]
//           +0x914: Number of shots fired by the 6 apes floating around. [32-bit]
//           +0x918: Number of shots dodged by your ape. [32-bit]
function pointer_to_monkey_dodgeball() => dword(0x1CE5204)
function constant_of_040_game_id_substring_from_above_header() => dword((pointer_to_monkey_dodgeball() & 0x1FFFFFF) + 0x0008E4)
function pointer_to_something_i_dont_know_what_but_its_significant_because_it_only_pops_up_when_the_player_gets_hit() => dword((pointer_to_monkey_dodgeball() & 0x1FFFFFF) + 0x00090C)
function number_of_shots_fired_by_the_6_apes_floating_around() => dword((pointer_to_monkey_dodgeball() & 0x1FFFFFF) + 0x000914)
function number_of_shots_dodged_by_your_ape() => dword((pointer_to_monkey_dodgeball() & 0x1FFFFFF) + 0x000918)
function number_of_shots_dodged_by_your_ape_byte() => byte((pointer_to_monkey_dodgeball() & 0x1FFFFFF) + 0x000918)

// $1CE5BC4: [32-bit Pointer] Pointer to Banana Guardian
//           
//           +0x13e0 Constant of "src/015_guardian/game.c". Section header for game stats that we care about. [ASCII Text]
//           +0x13e4 Substring of "015_", game ID substring from above. [ASCII Text]
//           +0x1410 Number monkeys shot during Banana Guardian [32-bit]
function pointer_to_banana_guardian() => dword(0x1CE5BC4)
function substring_of_015_game_id_substring_from_above() => dword((pointer_to_banana_guardian() & 0x1FFFFFF) + 0x0013E4)
function number_monkeys_shot_during_banana_guardian() => dword((pointer_to_banana_guardian() & 0x1FFFFFF) + 0x001410)

// $1CE6014: [32-bit Pointer] Pointer to 1.00m Dash.
//           
//           +0x120 "src/012_run1m/game.c". This is the section header. [ASCII Text]
//           +0x124 "012_run1m/game.c", game ID substring from above [ASCII Text]
//           +0x148 Flag for whether game is done. [8-bit]
//           0x00=Game in-progress
//           0x01=Game is finished
//           +0x190 Flag for whether game has an additional dramatic delay. 0x01 = Dramatic delay [8-bit]
//           +0x1bc Your time, in milliseconds. For some reason, this doesn't get used in Academy play. [16-bit]
//           +0x1f0 Time for first place [Float]
//           +0x1f4 Index of monkey in first place. Player monkey is 0x03 [32-bit]
function pointer_to_1_00m_dash() => dword(0x1CE6014)
function _012_run1m_game_c_game_id_substring_from_above() => dword((pointer_to_1_00m_dash() & 0x1FFFFFF) + 0x000124)
function flag_for_whether_game_is_done() => byte((pointer_to_1_00m_dash() & 0x1FFFFFF) + 0x000148)
function time_for_first_place() => float((pointer_to_1_00m_dash() & 0x1FFFFFF) + 0x0001F0)
function index_of_monkey_in_first_place_player_monkey_is_0x03() => dword((pointer_to_1_00m_dash() & 0x1FFFFFF) + 0x0001F4)

// $1CE66E4: [32-bit Pointer] Pointer to Karate Chimpster
//           
//           +0x1a0 Constant of "src/032_fighter/game.c", the header containing game information. [22 bytes]
//           +0x1a4 Constant of "032_", a substring of the above containing game ID. [4 bytes]
//           +0x1b0 Constant of "game", a substring of the above indicating source file. [4 bytes]
//           +0x1c4 Difficulty of Monkey you are fighting. In infinite mode, this counts up with every won round. In Academy mode, this jumps to the difficulty based off year you selected. [32-bit]
//           +0x1c8 This is your score (number monkeys knocked off), recorded immediately after knocking enemy monkey off.
//           +0x220 Constant of "src/share/eztime.c", section header from infinite play containing top timer. [18 bytes]
//           +0x22a Constant of "ezti", substring of the above. [4 bytes]
//           +0x22e Constant of "me.c", substring of the above. [4 bytes]
//           +0x2e0 Timer at top for game [Float]
function pointer_to_karate_chimpster() => dword(0x1CE66E4)
function constant_of_032_a_substring_of_the_above_containing_game_id() => dword((pointer_to_karate_chimpster() & 0x1FFFFFF) + 0x0001A4)
function constant_of_game_a_substring_of_the_above_indicating_source_file() => dword((pointer_to_karate_chimpster() & 0x1FFFFFF) + 0x0001B0)
function difficulty_of_monkey_you_are_fighting_in_infinite_mode_this_counts_up_with_every_won_round_in_academy_mode_this_jumps_to_the_difficulty_based_off_year_you_selected() => dword((pointer_to_karate_chimpster() & 0x1FFFFFF) + 0x0001C4)
function this_is_your_score_number_monkeys_knocked_off_recorded_immediately_after_knocking_enemy_monkey_off() => dword((pointer_to_karate_chimpster() & 0x1FFFFFF) + 0x0001C8)
function constant_of_ezti_substring_of_the_above() => dword((pointer_to_karate_chimpster() & 0x1FFFFFF) + 0x00022A)
function constant_of_me_c_substring_of_the_above() => dword((pointer_to_karate_chimpster() & 0x1FFFFFF) + 0x00022E)
function timer_at_top_for_game() => float((pointer_to_karate_chimpster() & 0x1FFFFFF) + 0x0002E0)

// $1CE7654: [32-bit Pointer] Pointer to Spot the Difference
//           
//           +0xe0 Constant of "src/010_mongiri/game.c". Section header for Spot the Difference. [22 bytes]
//           +0xe4 Constant of "010_", game ID substring from above. [4 bytes]
//           +0xf0 Constant of "game", substring of filename from above. [4 bytes]
//           +0x104 This is some magic number when playing Spot the Difference. I do not know the meaning, however I do know that it's starting at 0x02d0 when playing from the Mini-game Collection. It goes down consistently after every round of play. [32-bit]
//           +0x110 Flag to indicate Spot the Difference is done. [8-bit]
//           0x00 = Game on
//           0x01 = Called out wrong person, game is done
//           +0x160 Number of monkeys swatted in Spot the Difference
function pointer_to_spot_the_difference() => dword(0x1CE7654)
function constant_of_010_game_id_substring_from_above() => dword((pointer_to_spot_the_difference() & 0x1FFFFFF) + 0x0000E4)
function this_is_some_magic_number_when_playing_spot_the_difference_i_do_not_know_the_meaning_however_i_do_know_that_its_starting_at_0x02d0_when_playing_from_the_minigame_collection_it_goes_down_consistently_after_every_round_of_play() => dword((pointer_to_spot_the_difference() & 0x1FFFFFF) + 0x000104)
function flag_to_indicate_spot_the_difference_is_done() => dword((pointer_to_spot_the_difference() & 0x1FFFFFF) + 0x000110)
function number_of_monkeys_swatted_in_spot_the_difference() => dword((pointer_to_spot_the_difference() & 0x1FFFFFF) + 0x000160)

// $1CE7668: [32-bit] Flag to indicate the player has won that round of Spot the Difference.
//           0x00 = Player is playing the round.
//           0x01 = Player has won the round, re-load mini-game
//           
//           The above logic applies only to Mini-game Collection. The Academy Mode variant does the reverse. In Academy Mode:
//           0x01 = Player is playing
//           0x00 = Game is done
function flag_to_indicate_the_player_has_won_that_round_of_spot_the_difference() => dword(0x1CE7668)

// $1CE7674: [32-bit] Sum of previous monkeys swatted in continuous Spot the Difference.
//           When the player successfully closes out a round (the curtains close) this gets updated with the current player score.
function sum_of_previous_monkeys_swatted_in_continuous_spot_the_difference() => dword(0x1CE7674)

// $1CE8104: [32-bit Pointer] Pointer to A Rose, Monsieur?
//           
//           +0xe0 Constant of "src/022_ohineri/game.c" [ASCII Text]
//           +0xe4 Constant of "022_", game ID substring from above header. [ASCII Text]
//           +0xf0 Constant of "game", substring containing source code file loaded from above [ASCII Text]
//           +0x104 Number of roses that the player must hand out to complete game. [32-bit]
//           0x05 = Junior Yr. 1 + Junior Yr.2 requirement
//           0x0a = Junior Yr. 3 requirement
//           0x0f = Senior  Yr. 1 requirement
//           0x14 = Senior Yr. 2 requirement
//           0x19 = Seen from Mini-game Collection. Unsure if it's a hard limit.
//           +0x15c Number of roses handed out during A Rose, Monsieur [32-bit]
//           +0xc660 Constant of "src/022_ohineri/player.c". Header for A Rose, Monsieur? section that we care about. [ASCII Text]
//           +0xc664 Constant of "022_", game ID substring from above header. [ASCII Text]
//           +0xc671 Constant of "play", substring of above header. [ASCII Text]
//           +0xc68c Number of frames that the game has been active for. Counts up from 0x0000 and keeps counting up until the game is full on done. [32-bit]
//           +0xc6a0 Direction player is holding. [8-bit]
//           0x00 = No direction being held
//           0x10 = Up
//           0x20 = Right
//           0x40 = Down
//           0x80 = Left
//           +0xc6a1 Indicates whether the player is offering a rose. [8-bit]
//           0x00 = Player is not offering a rose
//           0x20 = Player is offering a rose
//           +0xc6e0 Some decimal value that changes whenever the player is being yelled at by a passing monkey. [Float]
//           0x3f800000 (1.0) Player is able to control the game as expected
//           0x400ccccd (2.2) Player is being yelled at by a passing monkey.
function pointer_to_a_rose_monsieur() => dword(0x1CE8104)
function constant_of_022_game_id_substring_from_above_header_ascii_text() => dword((pointer_to_a_rose_monsieur() & 0x1FFFFFF) + 0x0000E4)
function number_of_roses_handed_out_during_a_rose_monsieur() => dword((pointer_to_a_rose_monsieur() & 0x1FFFFFF) + 0x00015C)
function constant_of_022_game_id_substring_from_above_header_ascii_text_3() => dword((pointer_to_a_rose_monsieur() & 0x1FFFFFF) + 0x00C664)
function number_of_frames_that_the_game_has_been_active_for_counts_up_from_0x0000_and_keeps_counting_up_until_the_game_is_full_on_done() => dword((pointer_to_a_rose_monsieur() & 0x1FFFFFF) + 0x00C68C)
function some_decimal_value_that_changes_whenever_the_player_is_being_yelled_at_by_a_passing_monkey() => dword((pointer_to_a_rose_monsieur() & 0x1FFFFFF) + 0x00C6E0)

// $1CE9DFC: [32-bit Pointer] Pointer to Geronimo
//           
//           +0x34a0 Constant of "src/046_saruinsky/game.c", section header for game. [ASCII Text]
//           +0x34a4 Constant of "046_", game ID substring from above header. [ASCII Text]
//           +0x34c8 Number of monkeys saved during Geronimo [32-bit]
function pointer_to_geronimo() => dword(0x1CE9DFC)
function constant_of_046_game_id_substring_from_above_header() => dword((pointer_to_geronimo() & 0x1FFFFFF) + 0x0034A4)
function number_of_monkeys_saved_during_geronimo() => dword((pointer_to_geronimo() & 0x1FFFFFF) + 0x0034C8)

// $1CEA394: [32-bit Pointer] Pointer to Simian Suplex
//           
//           +0x1a0 Constant of "src/043_wrestle/game.c". Header for section of Simian Suplex containing game-centric data. [ASCII Text]
//           +0x1a4 Constant of "043_", game ID substring of the above. [ASCII Text]
//           +0x1c4 flag for whether you won the round in simian Suplex [8-bit]
//           0x00 = not won
//           0x01 = you won
function pointer_to_simian_suplex() => dword(0x1CEA394)
function constant_of_043_game_id_substring_of_the_above() => dword((pointer_to_simian_suplex() & 0x1FFFFFF) + 0x0001A4)
function flag_for_whether_you_won_the_round_in_simian_suplex() => byte((pointer_to_simian_suplex() & 0x1FFFFFF) + 0x0001C4)

// $1CEC354: [32-bit Pointer] Pointer to Hammer Throw / UFO Throw.
//           The games share an implementation, they just throw a different object that can go a different distance.
//           
//           +0x2e0 Constant of "src/003_monmer/game.c". Section header for game. [ASCII Text]
//           +0x2e4 Constant of "003_", game ID Substring from above. [ASCII Text]
//           +0x308 Field that indicates whether scoring monkey has finalized the distance for your throw. [32-bit]
//           0xffffffff=null, aka monkey has not finished scoring
//           0x01=monkey has finished scoring your throw
//           +0x314 ID of object being thrown. [32-bit]
//           0x00, 0x01 = Hammer
//           0x02 = UFO
//           +0x348 Distance that you threw the object. This ticks up rapidly as the scoring monkey runs out to where you landed. [32-bit]
function pointer_to_hammer_throw_ufo_throw() => dword(0x1CEC354)
function constant_of_003_game_id_substring_from_above() => dword((pointer_to_hammer_throw_ufo_throw() & 0x1FFFFFF) + 0x0002E4)
function field_that_indicates_whether_scoring_monkey_has_finalized_the_distance_for_your_throw() => dword((pointer_to_hammer_throw_ufo_throw() & 0x1FFFFFF) + 0x000308)
function id_of_object_being_thrown() => dword((pointer_to_hammer_throw_ufo_throw() & 0x1FFFFFF) + 0x000314)
function distance_that_you_threw_the_object_this_ticks_up_rapidly_as_the_scoring_monkey_runs_out_to_where_you_landed() => dword((pointer_to_hammer_throw_ufo_throw() & 0x1FFFFFF) + 0x000348)

// $1CED504: [32-bit Pointer] Pointer to Chef Chimpy
//           
//           +0x820 Constant of "src/017_saruyouri/game.c", section header containing scoring information for the game. [ASCII Text]
//           +0x824 Constant of "017_", substring from the above containing game ID. [ASCII Text]
//           +0x840 Flag field for status of game. [32-bit]
//           0x01=Game is about to start
//           0x03=Game is in progress
//           0x04=Game has been won
//           0x05=Game has been lost
//           +0x844 Number of frames the game has been active for. [32-bit]
//           +0x870 Total number of monkeys served. Max of 31. [32-bit]
//           +0x874 Number of monkeys that got mad and ran off before their food could be served. If this gets to 3, player loses. [32-bit]
function pointer_to_chef_chimpy() => dword(0x1CED504)
function constant_of_017_substring_from_the_above_containing_game_id() => dword((pointer_to_chef_chimpy() & 0x1FFFFFF) + 0x000824)
function flag_field_for_status_of_game() => dword((pointer_to_chef_chimpy() & 0x1FFFFFF) + 0x000840)
function total_number_of_monkeys_served_max_of_31() => dword((pointer_to_chef_chimpy() & 0x1FFFFFF) + 0x000870)
function number_of_monkeys_that_got_mad_and_ran_off_before_their_food_could_be_served_if_this_gets_to_3_player_loses() => dword((pointer_to_chef_chimpy() & 0x1FFFFFF) + 0x000874)

// $1CF0784: [32-bit Pointer] Pointer to Monkavision
//           
//           +0x16a0  Constant of "src/023_vision/master.c", section header containing information relating to game progress. [ASCII Text]
//           +0x16a4 Constant of "023_", substring from above for game ID [ASCII Text]
//           +0x16af Constant of "mast", substring from above [ASCII Text]
//           +0x16b3 Constant of "er.c", substring from above [ASCII Text]
//           +0x16cc Int flag indicating game status. [32-bit]
//           0x01=Game is active
//           0x02=Game was lost
//           0x03=Game won
//           +0x10ba0 Constant of "src/023_vision/point.c", section header containing displayed score during Monkavision. [ASCII Text]
//           +0x10ba4 Constant of "023_", substring of above containing game ID. [ASCII Text]
//           +0x10baf Constant of "poin", substring of above [ASCII Text]
//           +0x10bb3 Constant of "t.c", substring of above [ASCII Text]
//           +0x10bc0 Displayed score during Monkavision [32-bit]
function pointer_to_monkavision() => dword(0x1CF0784)
function constant_of_023_substring_from_above_for_game_id() => dword((pointer_to_monkavision() & 0x1FFFFFF) + 0x0016A4)
function int_flag_indicating_game_status() => dword((pointer_to_monkavision() & 0x1FFFFFF) + 0x0016CC)

achievement(
    title = "Freshman Year in the Books", points = 5, type="progression",
    description = "Complete Junior Yr. 1 in Academy Mode.",
    id = 467980, badge = "530902", published = "10/5/2024 5:47:40 PM", modified = "4/5/2025 10:10:54 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x31 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x00 && number_of_lines_made_at_end_of_bingo() == 0x01
)

achievement(
    title = "Hammers Solve Many Problems", points = 5, type="progression",
    description = "After getting 3 Specter coins in Junior Yr. 1, win the Monkey Dice minigame.",
    id = 469462, badge = "532340", published = "10/10/2024 12:33:04 AM", modified = "11/17/2024 12:07:28 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F343530 && dword(0x1A71024) == 0x5F343530 &&
              players_health_in_monkey_dice_player_starts_with_3_health_goes_down_in_increments_of_1_if_the_player_gets_hit() > 0x00 &&
              players_health_in_monkey_dice_player_starts_with_3_health_goes_down_in_increments_of_1_if_the_player_gets_hit() <= 0x03 &&
              prev(enemys_health_in_monkey_dice_enemy_starts_with_3_health_goes_down_in_increments_of_1_if_the_enemy_gets_hit())
              == 0x01 &&
              enemys_health_in_monkey_dice_enemy_starts_with_3_health_goes_down_in_increments_of_1_if_the_enemy_gets_hit() == 0x00
)

achievement(
    title = "Sophomore Year in the Books", points = 5, type="progression",
    description = "Complete Junior Yr. 2 in Academy Mode.",
    id = 468139, badge = "531061", published = "10/5/2024 11:16:00 PM", modified = "4/5/2025 11:15:22 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x32 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x00 && number_of_lines_made_at_end_of_bingo() == 0x01
)

achievement(
    title = "Give the Ape a Powerwasher", points = 5, type="progression",
    description = "After getting 3 Specter coins in Junior Yr. 2, win the Gran Turismonkey minigame.",
    id = 469463, badge = "532342", published = "10/10/2024 1:03:09 AM", modified = "11/17/2024 12:23:24 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F383430 &&
              constant_of_048_substring_of_above_indicating_game_id() == 0x5F383430 &&
              number_of_x_inputs_remaining_to_wash_right_side_of_the_car_starts_at_0x0f() == 0x00 &&
              number_of_x_inputs_remaining_to_wash_front_of_the_car_starts_at_0x14() == 0x00 &&
              number_of_x_inputs_remaining_to_wash_left_side_of_the_car_starts_at_0x19() == 0x00 &&
              number_of_x_inputs_remaining_to_wash_back_side_of_the_car_starts_at_0x0a() == 0x00 &&
              number_of_x_inputs_remaining_to_wash_the_top_of_the_car_starts_at_0x1e() == 0x00 &&
              number_of_moves_player_needs_to_complete_washing_car() == 0x64 &&
              prev(number_of_moves_player_has_successfully_made_to_wash_car()) == 0x63 &&
              number_of_moves_player_has_successfully_made_to_wash_car() == 0x64
)

achievement(
    title = "Junior Years Behind Me", points = 10, type="progression",
    description = "Complete Junior Yr. 3 in Academy Mode.",
    id = 468184, badge = "531068", published = "10/5/2024 11:36:39 PM", modified = "4/5/2025 11:15:23 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x33 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x00 && number_of_lines_made_at_end_of_bingo() == 0x01
)

achievement(
    title = "You Got Anything Else on the Menu?", points = 10, type="progression",
    description = "After getting 3 Specter coins in Junior Yr. 3, win the Chef Chimpy minigame.",
    id = 469464, badge = "532343", published = "10/10/2024 1:56:08 AM", modified = "11/17/2024 12:32:02 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F373130 &&
              constant_of_017_substring_from_the_above_containing_game_id() == 0x5F373130 &&
              total_number_of_monkeys_served_max_of_31() >= 0x1C && total_number_of_monkeys_served_max_of_31() <= 0x1F &&
              number_of_monkeys_that_got_mad_and_ran_off_before_their_food_could_be_served_if_this_gets_to_3_player_loses() != 0x03 &&
              prev(flag_field_for_status_of_game()) == 0x03 && flag_field_for_status_of_game() == 0x04
)

achievement(
    title = "You've Got Talent", points = 10, type="progression",
    description = "Complete Senior Yr. 1 in Academy mode.",
    id = 468710, badge = "531599", published = "10/7/2024 2:48:48 AM", modified = "4/5/2025 11:15:23 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x34 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x01 && number_of_lines_made_at_end_of_bingo() == 0x02
)

achievement(
    title = "Nice Par", points = 10, type="progression",
    description = "After getting 3 Specter coins in Senior Yr. 1, win the Every Monkey's Golf minigame.",
    id = 469465, badge = "532344", published = "10/10/2024 3:37:50 AM", modified = "3/30/2025 2:40:50 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F343230 &&
              dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF + 0xFFFFFFC4) &
              0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0xE4) == 0x5F343230 &&
              dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF + 0xFFFFFFC4) &
              0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0x180) == 0x08 &&
              prev(dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF +
              0xFFFFFFC4) & 0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0x100)) < 0x08 &&
              dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF + 0xFFFFFFC4) &
              0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0x100) >= 0x08
)

achievement(
    title = "End of the Academy in Sight", points = 25, type="progression",
    description = "Complete Senior Yr. 2 in Academy mode.",
    id = 470303, badge = "533203", published = "10/11/2024 3:40:47 AM", modified = "4/5/2025 11:15:23 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x35 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x02 && number_of_lines_made_at_end_of_bingo() == 0x03
)

achievement(
    title = "A Stunning Display", points = 25, type="progression",
    description = "After getting 3 Specter coins in Senior Yr. 2, win the Monkavision minigame.",
    id = 470304, badge = "533204", published = "10/11/2024 4:46:54 AM", modified = "11/17/2024 12:42:51 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F333230 &&
              constant_of_023_substring_from_above_for_game_id() == 0x5F333230 &&
              prev(int_flag_indicating_game_status()) == 0x01 && int_flag_indicating_game_status() == 0x03
)

achievement(
    title = "The Student Has Surpassed the Masters", points = 25, type="win_condition",
    description = "Complete Senior Yr. 3 and graduate.",
    id = 470615, badge = "533734", published = "10/12/2024 6:44:09 PM", modified = "5/28/2025 12:11:11 AM",
    trigger = SPECTER_BINARY_FLOOR_NAME == 0x5F353530 && byte(0x882337) == 0x36 &&
              floor_were_on() == 0x06 && prev(boss_hp()) > 0.0 && boss_hp() <= 0.0
)

achievement(
    title = "Red Monkey Showed You the Ropes", points = 10,
    description = "Win all mini-games and get a perfect bingo board in Junior Yr. 1.",
    id = 467981, badge = "530903", published = "10/5/2024 5:51:45 PM", modified = "4/5/2025 11:15:23 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x31 &&
              counter_for_how_many_line_combinations_iterated_over_at_end_of_bingo() == 0x09 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x07 && number_of_lines_made_at_end_of_bingo() == 0x08
)

achievement(
    title = "Scooting Past Blue Monkey", points = 10,
    description = "Win all mini-games and get a perfect bingo board in Junior Yr. 2.",
    id = 471111, badge = "534247", published = "10/14/2024 1:59:08 AM", modified = "4/5/2025 11:15:24 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x32 &&
              counter_for_how_many_line_combinations_iterated_over_at_end_of_bingo() == 0x09 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x07 && number_of_lines_made_at_end_of_bingo() == 0x08
)

achievement(
    title = "Loved by Yellow Monkey", points = 25,
    description = "Win all mini-games and get a perfect bingo board in Junior Yr. 3.",
    id = 471139, badge = "534415", published = "10/14/2024 6:14:03 PM", modified = "4/5/2025 11:15:24 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x33 &&
              counter_for_how_many_line_combinations_iterated_over_at_end_of_bingo() == 0x09 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x07 && number_of_lines_made_at_end_of_bingo() == 0x08
)

achievement(
    title = "Outwitting White Monkey", points = 25,
    description = "Win all mini-games and get a perfect bingo board in Senior Yr. 1.",
    id = 471141, badge = "534428", published = "10/14/2024 7:18:37 PM", modified = "4/5/2025 11:15:24 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x34 &&
              counter_for_how_many_line_combinations_iterated_over_at_end_of_bingo() == 0x09 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x07 && number_of_lines_made_at_end_of_bingo() == 0x08
)

achievement(
    title = "Exclusive Signed Merch From Pink Monkey", points = 25,
    description = "Win all mini-games and get a perfect bingo board in Senior Yr. 2.",
    id = 472257, badge = "535243", published = "10/19/2024 5:53:22 AM", modified = "4/5/2025 11:15:25 PM",
    trigger = CURRENT_BINARY_LOADED == 0x2F637273 &&
              ACADEMY_YEAR_RES_NAME == 0x72616579 &&
              ACADEMY_YEAR_ASCII == 0x35 &&
              counter_for_how_many_line_combinations_iterated_over_at_end_of_bingo() == 0x09 &&
              prev(number_of_lines_made_at_end_of_bingo()) == 0x07 && number_of_lines_made_at_end_of_bingo() == 0x08
)

achievement(
    title = "If You Can Dodge a Net...", points = 5,
    description = "Dodge 20 or more balls while playing Monkey Dodgeball.",
    id = 466243, badge = "528155", published = "9/26/2024 3:37:19 AM", modified = "11/17/2024 12:50:25 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F303430 &&
              constant_of_040_game_id_substring_from_above_header() == 0x5F303430 &&
              prev(number_of_shots_dodged_by_your_ape_byte()) == 0x13 &&
              number_of_shots_dodged_by_your_ape_byte() == 0x14
)

achievement(
    title = "Are You Smarter than a Chimp?", points = 3,
    description = "Get 5 questions correct on any difficulty of Ask Darwin.",
    id = 467852, badge = "530799", published = "10/4/2024 5:31:04 PM", modified = "4/5/2025 10:34:13 PM",
    trigger = CURRENT_BINARY_LOADED == 0x5F313130 &&
              number_of_questions_asked_by_the_game() == 0x05 &&
              prev(number_of_questions_answered_correctly_by_the_player()) == 0x04 &&
              number_of_questions_answered_correctly_by_the_player() == 0x05
)

achievement(
    title = "Left 4 Chimp", points = 5,
    description = "Knock out 50 monkeys while playing Banana Guardian.",
    id = 468125, badge = "531059", published = "10/5/2024 10:07:14 PM", modified = "11/17/2024 1:01:04 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F353130 &&
              substring_of_015_game_id_substring_from_above() == 0x5F353130 &&
              prev(number_monkeys_shot_during_banana_guardian()) >= 0x2E &&
              prev(number_monkeys_shot_during_banana_guardian()) <= 0x31 &&
              number_monkeys_shot_during_banana_guardian() >= 0x32
)

achievement(
    title = "Tetris Grooves", points = 5,
    description = "Complete the Red Hot Jig: Korobushka without dropping a note.",
    id = 468984, badge = "531824", published = "10/8/2024 6:29:03 AM", modified = "11/17/2024 1:12:45 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F363130 && background_track_loaded() == 0x314D4742 &&
              (prev(number_of_great_hits()) + prev(number_of_ok_hits())) == 0x3E &&
              (number_of_great_hits() + number_of_ok_hits()) == 0x3F && number_of_misses() == 0x00
)

achievement(
    title = "Only Real Oklahomans Know This One", points = 3,
    description = "Complete the Red Hot Jig: Oklahoma Mixer without dropping a note.",
    id = 468985, badge = "531825", published = "10/8/2024 6:29:16 AM", modified = "11/17/2024 1:11:15 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F363130 && background_track_loaded() == 0x304D4742 &&
              (prev(number_of_great_hits()) + prev(number_of_ok_hits())) == 0x17 &&
              (number_of_great_hits() + number_of_ok_hits()) == 0x18 && number_of_misses() == 0x00
)

achievement(
    title = "It's Been One Week Since You Danced With Me", points = 3,
    description = "Complete the Red Hot Jig: One Week without dropping a note.",
    id = 471140, badge = "534417", published = "10/14/2024 6:41:37 PM", modified = "11/17/2024 1:13:54 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F363130 && background_track_loaded() == 0x324D4742 &&
              (prev(number_of_great_hits()) + prev(number_of_ok_hits())) == 0x26 &&
              (number_of_great_hits() + number_of_ok_hits()) == 0x27 && number_of_misses() == 0x00
)

achievement(
    title = "A New Perspective Is Needed", points = 2,
    description = "Win in a round of Salvage.",
    id = 470419, badge = "533358", published = "10/11/2024 4:19:01 PM", modified = "11/17/2024 1:19:51 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F313330 &&
              constant_of_031_game_id_substring_from_above_header() == 0x5F313330 &&
              prev(flag_that_indicates_if_you_grabbed_the_chest_presumed_to_be_32_bit_given_the_other_variables_in_this_space())
              == 0x00 &&
              flag_that_indicates_if_you_grabbed_the_chest_presumed_to_be_32_bit_given_the_other_variables_in_this_space() == 0x01
)

achievement(
    title = "Why Are There So Many Monkeys?!", points = 5,
    description = "Successfully count monkeys for 5 rounds in a row when playing Monkey Watching from the Minigame Collection.",
    id = 468003, badge = "530914", published = "10/5/2024 7:23:17 PM", modified = "11/17/2024 1:34:24 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F373630 &&
              constant_of_067_substring_of_above_containing_game_id() == 0x5F373630 &&
              prev(number_of_consecutive_games_that_youve_won_in_monkey_counting()) == 0x04 &&
              number_of_consecutive_games_that_youve_won_in_monkey_counting() == 0x05
)

achievement(
    title = "Quick Monkey Math", points = 3,
    description = "Answer 10 questions correctly on any difficulty of Monkey Drill while playing from the Minigame Collection.",
    id = 468986, badge = "531826", published = "10/8/2024 7:04:00 AM", modified = "11/17/2024 1:41:24 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F393530 &&
              constant_of_059_game_id_substring_from_above_header() == 0x5F393530 &&
              constant_of_game_filename_substring_from_above_header() == 0x656D6167 &&
              (difficulty() == 0x03) || difficulty() == 0x0B || difficulty() == 0x13 || difficulty() == 0x1B &&
              prev(current_score()) == 0x09 && current_score() == 0x0A
)

achievement(
    title = "A Rose, Just for Me?", points = 3,
    description = "Hand out 5 roses in a row without getting yelled at when playing A Rose, Monsieur?",
    id = 469403, badge = "532269", published = "10/9/2024 4:53:08 PM", modified = "11/17/2024 1:49:19 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F323230 &&
              constant_of_022_game_id_substring_from_above_header_ascii_text() == 0x5F323230 &&
              repeated(5,
                  dword(dword(pointer_to_a_rose_monsieur() & 0x1FFFFFF + 0x1CE8104) & 0x1FFFFFF + 0x15C) >
                  prev(dword(dword(pointer_to_a_rose_monsieur() & 0x1FFFFFF + 0x1CE8104) & 0x1FFFFFF + 0x15C)) &&
                  never(constant_of_022_game_id_substring_from_above_header_ascii_text_3() != 0x5F323230)
              ) &&
              number_of_frames_that_the_game_has_been_active_for_counts_up_from_0x0000_and_keeps_counting_up_until_the_game_is_full_on_done()
              != 0x00 &&
              never(some_decimal_value_that_changes_whenever_the_player_is_being_yelled_at_by_a_passing_monkey() == 0x400CCCCD)
)

achievement(
    title = "Putting That Muleta to Use", points = 5,
    description = "Get a 5-combo in a round of Monkey Ole.",
    id = 469259, badge = "532131", published = "10/9/2024 2:02:22 AM", modified = "11/17/2024 1:53:20 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F383330 &&
              constant_of_022_game_id_substring_from_above_header_ascii_text_2() == 0x5F383330 &&
              number_of_frames_until_your_ole_combo_drops() > 0x00 && prev(active_ole_combo()) == 0x04 &&
              active_ole_combo() == 0x05
)

achievement(
    title = "Stretching the Definition of a Shishkebab", points = 3,
    description = "Get a score of 600 or more when playing Shishkebab Special from the Minigame Collection.",
    id = 470437, 
    badge = "533376", 
    trigger = current_binary_is("Shishkebab Special") &&
            ptr_valid(SHISHKEBAB_PTR) &&
            ptr_valid(dword(mask_ptr(SHISHKEBAB_PTR_ADDR) + 0x34)) &&
            prev(dword(mask_ptr(mask_ptr(SHISHKEBAB_PTR_ADDR) + 0x34))) > 0x00 &&
            prev(dword(mask_ptr(mask_ptr(SHISHKEBAB_PTR_ADDR) + 0x34))) < 0x258 &&
            dword(mask_ptr(mask_ptr(SHISHKEBAB_PTR_ADDR) + 0x34)) >= 0x258
)

achievement(
    title = "Explosive Delivery", points = 5,
    description = "Serve a stack of 4 bombs during a game of Bombermonkey.",
    id = 468689, badge = "531528", published = "10/7/2024 12:53:15 AM", modified = "11/17/2024 2:09:13 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F303630 &&
              ((trigger_when((prev(this_correlates_to_the_number_of_bombs_that_have_been_served()) -
                    this_correlates_to_the_number_of_bombs_that_have_been_served()) == 0x04
                )) ||
               (trigger_when((this_correlates_to_the_number_of_bombs_that_have_been_served() -
                    prev(this_correlates_to_the_number_of_bombs_that_have_been_served())) == 0x04
                )))
)

achievement(
    title = "Reverse Sweep", points = 5,
    description = "Start from a 0-2 score and score 3 times in a row to win in Monkey Hockey.",
    id = 468987, badge = "531897", published = "10/8/2024 8:21:54 AM", modified = "11/17/2024 12:07:31 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F353630 &&
              ((constant_of_065_game_id_substring_from_above_header_ascii_text_2() == 0x5F353630 &&
                constant_of_scor_filename_substring_from_above_header_ascii_text_2() == 0x726F6373 &&
                once((dword(dword(pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF + 0x8827C4) & 0x1FFFFFF +
                    0x7C1C) == 0x02) && player_score_in_the_game_2() == 0x00 && never(enemy_score_in_the_game_2() == 0x03)
                ) && trigger_when(prev(player_score_in_the_game_2()) == 0x02) &&
                trigger_when(player_score_in_the_game_2() == 0x03)) ||
               (constant_of_065_game_id_substring_from_above_header_ascii_text() == 0x5F353630 &&
                constant_of_scor_filename_substring_from_above_header_ascii_text() == 0x726F6373 &&
                once((dword(dword(pointer_to_monkey_hockey_scoring_information() & 0x1FFFFFF + 0x8827C4) & 0x1FFFFFF +
                    0x7A9C) == 0x02) && player_score_in_the_game() == 0x00 && never(enemy_score_in_the_game() == 0x03)
                ) && trigger_when(prev(player_score_in_the_game()) == 0x02) &&
                trigger_when(player_score_in_the_game() == 0x03)))
)

achievement(
    title = "A Lovely Morning Jog", points = 3,
    description = "Hit every note when playing the Morning Jog minigame.",
    id = 465986, badge = "527508",
    trigger = current_binary_is("Morning Jog") &&
            ptr_valid(PTR_MORNING_JOG) &&
            ptr_valid(dword(mask_ptr(ADDR_PTR_MORNING_JOG) + 0x40)) && (
            // previous score
                prev(dword(mask_ptr(mask_ptr(ADDR_PTR_MORNING_JOG) + 0x40) + 0x0c)) + 
                prev(dword(mask_ptr(mask_ptr(ADDR_PTR_MORNING_JOG) + 0x40) + 0x10)) == 0x27
            ) && (
            // current score
                dword(mask_ptr(mask_ptr(ADDR_PTR_MORNING_JOG) + 0x40) + 0x0c) + 
                dword(mask_ptr(mask_ptr(ADDR_PTR_MORNING_JOG) + 0x40) + 0x10) == 0x28
            )
)

achievement(
    title = "You Spin Me Right Round", points = 3,
    description = "Throw yourself and the ball 75m or further in a round of Hammer Throw.",
    id = 468124, badge = "534182", published = "10/5/2024 10:05:40 PM", modified = "11/17/2024 2:21:28 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F333030 &&
              constant_of_003_game_id_substring_from_above() == 0x5F333030 &&
              (id_of_object_being_thrown() == 0x00) || id_of_object_being_thrown() == 0x01 &&
              prev(distance_that_you_threw_the_object_this_ticks_up_rapidly_as_the_scoring_monkey_runs_out_to_where_you_landed())
              <= 0x4B &&
              distance_that_you_threw_the_object_this_ticks_up_rapidly_as_the_scoring_monkey_runs_out_to_where_you_landed() >= 0x4B
)

achievement(
    title = "A Cool Monkey Would Stick the Landing", points = 5,
    description = "Throw your UFO and pilot it 110m or further in a round of UFO Throw.",
    id = 471026, badge = "534181", published = "10/13/2024 6:40:15 PM", modified = "11/17/2024 2:21:29 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F333030 &&
              constant_of_003_game_id_substring_from_above() == 0x5F333030 && id_of_object_being_thrown() == 0x02 &&
              prev(distance_that_you_threw_the_object_this_ticks_up_rapidly_as_the_scoring_monkey_runs_out_to_where_you_landed())
              <= 0x6E &&
              distance_that_you_threw_the_object_this_ticks_up_rapidly_as_the_scoring_monkey_runs_out_to_where_you_landed() >= 0x6E
)

achievement(
    title = "Starting on the Right Foot", points = 3,
    description = "Win with a time of 00:00.35 or lower when playing 1.00m Dash from the Minigame Collection.",
    id = 465985, badge = "527507", published = "9/24/2024 5:56:52 PM", modified = "11/17/2024 3:47:39 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F323130 &&
              _012_run1m_game_c_game_id_substring_from_above() == 0x5F323130 && time_for_first_place() < 36.0 &&
              index_of_monkey_in_first_place_player_monkey_is_0x03() == 0x03 &&
              prev(flag_for_whether_game_is_done()) == 0x00 && flag_for_whether_game_is_done() == 0x01
)

achievement(
    title = "From Wall to Wall", points = 5,
    description = "Climb 25 floors or more when playing Enter the Monkey II from the Minigame Collection.",
    id = 468112, badge = "531041", published = "10/5/2024 9:35:08 PM", modified = "2/14/2025 6:33:43 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F393230 &&
              constant_of_029_substring_of_the_above() == 0x5F393230 &&
              constant_of_saru_substring_of_the_above() == 0x75726153 &&
              prev(current_number_of_floors_youve_climbed()) == 0x18 && current_number_of_floors_youve_climbed() == 0x19
)

achievement(
    title = "One Good Left Hook", points = 2,
    description = "Knock out another ape in Simian Suplex.",
    id = 467600, badge = "530569", published = "10/3/2024 6:52:10 PM", modified = "11/17/2024 2:40:02 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F333430 &&
              constant_of_043_game_id_substring_of_the_above() == 0x5F333430 &&
              prev(flag_for_whether_you_won_the_round_in_simian_suplex()) == 0x00 &&
              flag_for_whether_you_won_the_round_in_simian_suplex() == 0x01
)

achievement(
    title = "No Monkey Left Behind", points = 3,
    description = "Save all 9 monkeys in a round of Geronimo.",
    id = 468116, badge = "531044", published = "10/5/2024 9:45:24 PM", modified = "11/17/2024 2:44:21 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F363430 &&
              constant_of_046_game_id_substring_from_above_header() == 0x5F363430 &&
              prev(number_of_monkeys_saved_during_geronimo()) < 0x09 &&
              number_of_monkeys_saved_during_geronimo() == 0x09
)

achievement(
    title = "Wonderful Putting Technique", points = 5,
    description = "Score 10 or more points in a single shot when playing Every Monkey's Golf.",
    id = 471091, badge = "534218", published = "10/14/2024 12:09:07 AM", modified = "3/30/2025 2:40:46 AM",
    trigger = CURRENT_BINARY_LOADED == 0x5F343230 &&
              dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF + 0xFFFFFFC4) &
              0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0xE4) == 0x5F343230 &&
              dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF + 0xFFFFFFC4) &
              0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0x100) != 0x00 &&
              (dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF + 0xFFFFFFC4) &
              0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0x100) -
              prev(dword(dword(dword(dword(pointer_to_the_middle_of_a_struct_for_game_metadata() & 0x1FFFFFF +
              0xFFFFFFC4) & 0x1FFFFFF + 0x04) & 0x1FFFFFF + 0x48) & 0x1FFFFFF + 0x100))) >= 0x0A
)

achievement(
    title = "Survival of the Fittest", points = 5,
    description = "Complete 9 or more mini-games in Survival mode in a row in the Body category.",
    id = 524331, badge = "594232", published = "6/5/2025 5:13:54 AM", modified = "6/5/2025 5:13:54 AM",
    trigger = survival_mode() == 0x02 && byte(0x879B63) == 0x09 && prev(byte(0x879B64)) == 0x08 &&
              byte(0x879B64) == 0x00 && prev(byte(0x879B66)) == 0x08 && byte(0x879B66) == 0x09
)

achievement(
    title = "Survival of the Dextrous", points = 5,
    description = "Complete 9 or more mini-games in Survival mode in a row in the Tech category.",
    id = 524332, badge = "594233", published = "6/5/2025 5:13:54 AM", modified = "6/5/2025 5:13:54 AM",
    trigger = survival_mode() == 0x01 && byte(0x879B63) == 0x09 && prev(byte(0x879B64)) == 0x08 &&
              byte(0x879B64) == 0x00 && prev(byte(0x879B66)) == 0x08 && byte(0x879B66) == 0x09
)

achievement(
    title = "Survival of the Smartest", points = 5,
    description = "Complete 9 or more mini-games in Survival mode in a row in the Mind category.",
    id = 524333, badge = "594234", published = "6/5/2025 5:13:54 AM", modified = "6/5/2025 5:13:54 AM",
    trigger = survival_mode() == 0x00 && byte(0x879B63) == 0x09 && prev(byte(0x879B64)) == 0x08 &&
              byte(0x879B64) == 0x00 && prev(byte(0x879B66)) == 0x08 && byte(0x879B66) == 0x09
)

achievement(
    title = "Survival of the Mini-Game Onslaught", points = 10,
    description = "Complete 18 or more mini-games in Survival mode in a row in the Cross-genre category.",
    id = 524334, badge = "594235", published = "6/5/2025 5:13:55 AM", modified = "7/1/2025 12:54:04 AM",
    trigger = survival_mode() == 0x03 && byte(0x879B63) == 0x1B && prev(byte(0x879B64)) == 0x11 &&
              byte(0x879B64) == 0x12 && prev(byte(0x879B66)) == 0x11 && byte(0x879B66) == 0x12
)

achievement(
    title = "[VOID] Just Like Tarzan", points = 0,
    description = "When playing Enter the Monkey I from the Mini-game collection, successfully grab 30 vines in a single round of gameplay.",
    id = 470438, badge = "533378", published = "10/11/2024 5:19:54 PM", modified = "10/20/2024 5:35:39 PM",
    trigger = CURRENT_BINARY_LOADED == 0x5F373030 &&
              ((dword(0xE40CA4) == 0x5F373030 &&
                prev(score_when_playing_enter_the_monkey_i_via_the_minigame_collection()) == 0x1D &&
                score_when_playing_enter_the_monkey_i_via_the_minigame_collection() == 0x1E) ||
               (dword(0x1C15164) == 0x5F373030 &&
                prev(score_when_playing_enter_the_monkey_i_via_the_minigame_collection_2()) == 0x1D &&
                score_when_playing_enter_the_monkey_i_via_the_minigame_collection_2() == 0x1E))
)

leaderboard(
    id = 120019, title = "Salvage Chests Grabbed",
    description = "When playing Salvage, collect as many chests as you can.",
    start  = CURRENT_BINARY_LOADED == 0x5F313330 &&
             constant_of_031_game_id_substring_from_above_header() == 0x5F313330 &&
             flag_that_indicates_if_you_lost_this_round_of_salvage_presumed_to_be_32_bit_given_the_other_variables_in_the_space()
             == 0x00,
    cancel = CURRENT_BINARY_LOADED != 0x5F313330,
    submit = constant_of_031_game_id_substring_from_above_header() == 0x5F313330 &&
             ((prev(flag_that_indicates_if_you_lost_this_round_of_salvage_presumed_to_be_32_bit_given_the_other_variables_in_the_space())
               == 0x00 &&
               flag_that_indicates_if_you_lost_this_round_of_salvage_presumed_to_be_32_bit_given_the_other_variables_in_the_space()
               == 0x01 &&
               current_number_of_chests_grabbed_in_salvage_in_endless_mode_you_can_only_get_up_to_6_byte() > 0x00) ||
              (prev(current_number_of_chests_grabbed_in_salvage_in_endless_mode_you_can_only_get_up_to_6_byte()) == 0x05 &&
               current_number_of_chests_grabbed_in_salvage_in_endless_mode_you_can_only_get_up_to_6_byte() == 0x06)),
    value  = measured(current_number_of_chests_grabbed_in_salvage_in_endless_mode_you_can_only_get_up_to_6()),
    format = "VALUE"
)

leaderboard(
    id = 120020, title = "Hammer Throw High Score",
    description = "High score when playing Hammer Throw.",
    start  = CURRENT_BINARY_LOADED == 0x5F333030 &&
             constant_of_003_game_id_substring_from_above() == 0x5F333030 &&
             field_that_indicates_whether_scoring_monkey_has_finalized_the_distance_for_your_throw() == 0xFFFFFFFF &&
             (id_of_object_being_thrown() == 0x00) || id_of_object_being_thrown() == 0x01,
    cancel = CURRENT_BINARY_LOADED != 0x5F333030,
    submit = (id_of_object_being_thrown() == 0x00) || id_of_object_being_thrown() == 0x01 &&
             prev(field_that_indicates_whether_scoring_monkey_has_finalized_the_distance_for_your_throw()) == 0xFFFFFFFF &&
             field_that_indicates_whether_scoring_monkey_has_finalized_the_distance_for_your_throw() == 0x01,
    value  = measured(distance_that_you_threw_the_object_this_ticks_up_rapidly_as_the_scoring_monkey_runs_out_to_where_you_landed()),
    format = "VALUE"
)

leaderboard(
    id = 120021, title = "UFO Throw High Score",
    description = "High score when playing UFO Throw.",
    start  = CURRENT_BINARY_LOADED == 0x5F333030 &&
             constant_of_003_game_id_substring_from_above() == 0x5F333030 &&
             field_that_indicates_whether_scoring_monkey_has_finalized_the_distance_for_your_throw() == 0xFFFFFFFF &&
             id_of_object_being_thrown() == 0x02,
    cancel = CURRENT_BINARY_LOADED != 0x5F333030,
    submit = id_of_object_being_thrown() == 0x02 &&
             prev(field_that_indicates_whether_scoring_monkey_has_finalized_the_distance_for_your_throw()) == 0xFFFFFFFF &&
             field_that_indicates_whether_scoring_monkey_has_finalized_the_distance_for_your_throw() == 0x01,
    value  = measured(distance_that_you_threw_the_object_this_ticks_up_rapidly_as_the_scoring_monkey_runs_out_to_where_you_landed()),
    format = "VALUE"
)

// Current conundrums:
// If I submit based purely on timer, I get scenarios in which I score after the timer finishes, involuntarily.
// If I submit based purely on score zero'ing out, I get scenarios in which I submit garbage scores.
leaderboard(
    id = 120088, 
    title = "Shishkebab Special Score",
    description = "High score when playing Shishkebab Special from the Minigame Collection.",
    start  = current_binary_is("Shishkebab Special") &&
            ptr_valid(SHISHKEBAB_PTR) &&
            ptr_valid(SHISHKEBAB_TIMER_PTR) &&
            ptr_valid(dword(mask_ptr(SHISHKEBAB_PTR_ADDR) + 0x34)) &&
            ptr_valid(dword(mask_ptr(SHISHKEBAB_TIMER_ADDR) + 0x34)) && 
            prev(dword(mask_ptr(mask_ptr(SHISHKEBAB_TIMER_ADDR) + 0x34) + 0x08)) != 0xe08 &&
            dword(mask_ptr(mask_ptr(SHISHKEBAB_TIMER_ADDR) + 0x34) + 0x08) == 0xe08,
    cancel = !current_binary_is("Shishkebab Special"),
    submit = current_binary_is("Shishkebab Special") &&
            prev(dword(mask_ptr(mask_ptr(SHISHKEBAB_TIMER_ADDR) + 0x34)) + 0x08) > 0x00 &&
            dword(mask_ptr(mask_ptr(SHISHKEBAB_TIMER_ADDR) + 0x34) + 0x08) == 0x00,
    value  = measured((dword(mask_ptr(mask_ptr(SHISHKEBAB_PTR_ADDR) + 0x34)))),
    format = "VALUE"
)

leaderboard(
    id = 120089, title = "1.00m Dash Best Time",
    description = "Take off as fast as you can in the 1.00m Dash.",
    start  = CURRENT_BINARY_LOADED == 0x5F323130 &&
             _012_run1m_game_c_game_id_substring_from_above() == 0x5F323130 && flag_for_whether_game_is_done() == 0x00,
    cancel = CURRENT_BINARY_LOADED != 0x5F323130,
    submit = index_of_monkey_in_first_place_player_monkey_is_0x03() == 0x03 &&
             prev(flag_for_whether_game_is_done()) == 0x00 && flag_for_whether_game_is_done() == 0x01,
    value  = measured(time_for_first_place()),
    format = "MILLISECS", lower_is_better = true
)

leaderboard(
    id = 120183, title = "Karate Chimpster Fast Knockout",
    description = "Knock the enemy off as quickly as you can when playing Karate Chimpster from the Minigame Collection.",
    start  = CURRENT_BINARY_LOADED == 0x5F323330 &&
             constant_of_032_a_substring_of_the_above_containing_game_id() == 0x5F323330 &&
             constant_of_game_a_substring_of_the_above_indicating_source_file() == 0x656D6167 &&
             difficulty_of_monkey_you_are_fighting_in_infinite_mode_this_counts_up_with_every_won_round_in_academy_mode_this_jumps_to_the_difficulty_based_off_year_you_selected()
                 >= this_is_your_score_number_monkeys_knocked_off_recorded_immediately_after_knocking_enemy_monkey_off() &&
             constant_of_ezti_substring_of_the_above() == 0x69747A65 &&
             constant_of_me_c_substring_of_the_above() == 0x632E656D,
    cancel = CURRENT_BINARY_LOADED != 0x5F323330,
    submit = (this_is_your_score_number_monkeys_knocked_off_recorded_immediately_after_knocking_enemy_monkey_off() -
             prev(this_is_your_score_number_monkeys_knocked_off_recorded_immediately_after_knocking_enemy_monkey_off()))
             == 0x01,
    value  = measured((99.0 - timer_at_top_for_game())),
    format = "SECS", lower_is_better = true
)

leaderboard(
    id = 120195, title = "Mon Quixote Arrows Blocked",
    description = "Block as many arrows as you can without getting hit when playing Mon Quixote from the Minigame Collection.",
    start  = CURRENT_BINARY_LOADED == 0x5F353230 &&
             constant_of_025_game_id_substring_from_the_above() == 0x5F353230 &&
             constant_of_saru_substring_from_above() == 0x75726173 &&
             how_many_times_the_monkey_has_been_hit_in_mon_quixote_in_academy_play_monkey_can_be_hit_multiple_times_in_endless_only_once()
             == 0x00 && number_of_arrows_blocked_in_mon_quixote() == 0x00,
    cancel = CURRENT_BINARY_LOADED != 0x5F353230,
    submit = prev(how_many_times_the_monkey_has_been_hit_in_mon_quixote_in_academy_play_monkey_can_be_hit_multiple_times_in_endless_only_once())
             == 0x00 &&
             how_many_times_the_monkey_has_been_hit_in_mon_quixote_in_academy_play_monkey_can_be_hit_multiple_times_in_endless_only_once()
             == 0x01,
    value  = measured(number_of_arrows_blocked_in_mon_quixote()),
    format = "VALUE"
)

leaderboard(
    id = 120199, title = "Bombermonkey High Score",
    description = "High score when playing Bombermonkey from the Minigame Collection.",
    start  = CURRENT_BINARY_LOADED == 0x5F303630 &&
             flag_for_whether_the_player_has_been_blown_up() == 0x00 &&
             dword(pointer_to_player_information_during_bombermonkey() & 0x1FFFFFF + 0x48) == 0x00,
    cancel = CURRENT_BINARY_LOADED != 0x5F303630,
    submit = prev(flag_for_whether_the_player_has_been_blown_up()) == 0x00 &&
             flag_for_whether_the_player_has_been_blown_up() == 0x01,
    value  = measured(this_correlates_to_the_number_of_bombs_that_have_been_served()),
    format = "VALUE"
)

leaderboard(
    id = 120200, title = "Monkey Dodgeball Balls Dodged",
    description = "Dodge as many balls as you can when playing Monkey Dodgeball.",
    start  = CURRENT_BINARY_LOADED == 0x5F303430 &&
             constant_of_040_game_id_substring_from_above_header() == 0x5F303430 &&
             number_of_shots_fired_by_the_6_apes_floating_around() == 0x00 &&
             number_of_shots_dodged_by_your_ape() == 0x00,
    cancel = CURRENT_BINARY_LOADED != 0x5F303430,
    submit = constant_of_040_game_id_substring_from_above_header() == 0x5F303430 &&
             prev(pointer_to_something_i_dont_know_what_but_its_significant_because_it_only_pops_up_when_the_player_gets_hit())
             == 0x00 &&
             pointer_to_something_i_dont_know_what_but_its_significant_because_it_only_pops_up_when_the_player_gets_hit() != 0x00,
    value  = measured(number_of_shots_dodged_by_your_ape()),
    format = "VALUE"
)

leaderboard(
    id = 120201, title = "Spot the Difference Monkeys Corrected",
    description = "When playing Spot the Difference from the Mini-game Collection, get as high of a score as you can.",
    start  = CURRENT_BINARY_LOADED == 0x5F303130 &&
             constant_of_010_game_id_substring_from_above() == 0x5F303130 &&
             this_is_some_magic_number_when_playing_spot_the_difference_i_do_not_know_the_meaning_however_i_do_know_that_its_starting_at_0x02d0_when_playing_from_the_minigame_collection_it_goes_down_consistently_after_every_round_of_play()
             == 0x2D0 && flag_to_indicate_the_player_has_won_that_round_of_spot_the_difference() == 0x00,
    cancel = CURRENT_BINARY_LOADED != 0x5F303130,
    submit = CURRENT_BINARY_LOADED == 0x5F303130 &&
             ((prev(flag_to_indicate_spot_the_difference_is_done()) == 0x00 &&
               flag_to_indicate_spot_the_difference_is_done() == 0x01) ||
              ((prev(number_of_monkeys_swatted_in_spot_the_difference()) +
               prev(sum_of_previous_monkeys_swatted_in_continuous_spot_the_difference())) == 0x72 &&
               (number_of_monkeys_swatted_in_spot_the_difference() +
               sum_of_previous_monkeys_swatted_in_continuous_spot_the_difference()) == 0x73)),
    value  = measured((number_of_monkeys_swatted_in_spot_the_difference() +
                 sum_of_previous_monkeys_swatted_in_continuous_spot_the_difference())
             ),
    format = "VALUE"
)

leaderboard(
    id = 120202, title = "Enter the Monkey II Walls Climbed",
    description = "High score when playing Enter the Monkey II from the Minigame Collection.",
    start  = CURRENT_BINARY_LOADED == 0x5F393230 &&
             constant_of_029_substring_of_the_above() == 0x5F393230 &&
             constant_of_saru_substring_of_the_above() == 0x75726153 && current_number_of_floors_youve_climbed() == 0x00,
    cancel = CURRENT_BINARY_LOADED != 0x5F393230,
    submit = prev(flag_indicating_whether_the_game_is_complete_or_not()) == 0x00 &&
             flag_indicating_whether_the_game_is_complete_or_not() == 0x01,
    value  = measured(current_number_of_floors_youve_climbed()),
    format = "VALUE"
)

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F303439, "Checking out their Trophy Showcase")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x2F637273 &&
    SPECTER_BINARY_FLOOR_NAME == 0x5F313439, "Checking their trophies acquired")

rich_presence_conditional_display(some_constant_of_0x05_this_appears_when_im_selecting_minigames() == 0x05 &&
    page_of_minigame_selection_youre_on() == 0x00, "Thinking about replaying a favorited mini-game")

rich_presence_conditional_display(some_constant_of_0x05_this_appears_when_im_selecting_minigames() == 0x05 &&
    page_of_minigame_selection_youre_on() == 0x01, "Thinking about replaying a Mind mini-game")

rich_presence_conditional_display(some_constant_of_0x05_this_appears_when_im_selecting_minigames() == 0x05 &&
    page_of_minigame_selection_youre_on() == 0x02, "Thinking about replaying a Tech mini-game")

rich_presence_conditional_display(some_constant_of_0x05_this_appears_when_im_selecting_minigames() == 0x05 &&
    page_of_minigame_selection_youre_on() == 0x03, "Thinking about replaying a Body mini-game")

rich_presence_conditional_display(some_constant_of_0x05_this_appears_when_im_selecting_minigames() == 0x05 &&
    page_of_minigame_selection_youre_on() == 0x04, "Thinking about replaying a Special mini-game")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F313030, "Enduring rigorous basic ape training")

rich_presence_conditional_display((tbyte(0x1B8D064) == 0x323030 || tbyte(0x1B8CBA4) == 0x323030), "On their Morning Jog")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F333030 &&
    CURRENT_BINARY_LOADED == 0x5F333030 &&
    (dword(0x1B89954) == 0x01 || dword(0x1B89F94) == 0x01), "Playing Hammer Throw")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F333030 &&
    CURRENT_BINARY_LOADED == 0x5F333030 &&
    (dword(0x1B89954) == 0x02 || dword(0x1B89F94) == 0x02), "Playing UFO Throw")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F343030, "Playing Street Juggler")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F373030, "Playing Enter the Monkey I")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F303130, "Playing Spot the Difference")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F313130, "Playing Ask Darwin")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F323130, "Running the longest metre of their life in the 1.00m Dash")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F353130, "Playing Banana Guardian")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F363130 &&
    dword(pointer_to_red_hot_jig() + 0xF80002E0) == 0x304D4742, "Playing Red Hot Jig: Oklahoma Mixer")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F363130 &&
    dword(pointer_to_red_hot_jig() + 0xF80002E0) == 0x314D4742, "Playing Red Hot Jig: Korobushka")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F373130, "Cooking up a storm in Chef Chimpy")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F393130, "Attempting to balance 7 monkeys in Monkey Balancing")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F323230, "Handing out roses in A Rose, Monsieur?")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F333230, "Attempting to shoot down that UFO in Monkavision")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F343230, "Playing Every Monkey's Golf")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F353230, "Playing Mon Quixote")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F393230, "Jumping from wall to wall in Enter the Monkey II")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F323330, "Playing Karate Chimpster")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F313330, "Playing Salvage")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F383330, "Playing Monkey Ole")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F393330, "Playing Shishkebab Special")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F303430, "Playing Monkey Dodgeball")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F333430, "Playing Simian Suplex")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F363430, "Playing Geronimo")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F373430, "Playing Monkey Soccer")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F383430, "Polishing a car in Gran Turismonkey")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F343530, "Playing Monkey Dice")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F373530, "Playing Pot Shots")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F383530, "Playing Enter the Monkey III")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F393530, "Playing Monkey Drills")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F303630, "Playing Bombermonkey")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F323630, "Playing Monkey Bowling")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F353630, "Playing Monkey Hockey")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F363630, "Playing Monkeytech")

rich_presence_conditional_display(CURRENT_BINARY_LOADED == 0x5F373630, "Playing Monkey Watching")

rich_presence_conditional_display(ACADEMY_YEAR_ASCII == 0x31 && dword(0x1BFEEE4) == 0x5F353139, "Learning from Red Monkey in Junior Yr. 1")

rich_presence_conditional_display(ACADEMY_YEAR_ASCII == 0x32 && dword(0x1BFE864) == 0x5F353139, "Learning from Blue Monkey in Junior Yr. 2")

rich_presence_conditional_display(ACADEMY_YEAR_ASCII == 0x33 && dword(0x1BFE624) == 0x5F353139, "Learning from Yellow Monkey in Junior Yr. 3")

rich_presence_conditional_display(ACADEMY_YEAR_ASCII == 0x34 && dword(0x1C012E4) == 0x5F353139, "Learning from White Monkey in Senior Yr. 1")

rich_presence_conditional_display(ACADEMY_YEAR_ASCII == 0x35 && dword(0x1BFD4E4) == 0x5F353139, "Learning from Pink Monkey in Senior Yr. 2")

rich_presence_conditional_display(SPECTER_BINARY_FLOOR_NAME == 0x5F353530 && byte(0x882337) == 0x31, "Challenging Specter (Floor 1)")

rich_presence_conditional_display(SPECTER_BINARY_FLOOR_NAME == 0x5F353530 && byte(0x882337) == 0x32, "Challenging Specter (Floor 2)")

rich_presence_conditional_display(SPECTER_BINARY_FLOOR_NAME == 0x5F353530 && byte(0x882337) == 0x33, "Challenging Specter (Floor 3)")

rich_presence_conditional_display(SPECTER_BINARY_FLOOR_NAME == 0x5F353530 && byte(0x882337) == 0x34, "Challenging Specter (Floor 4)")

rich_presence_conditional_display(SPECTER_BINARY_FLOOR_NAME == 0x5F353530 && byte(0x882337) == 0x35, "Challenging Specter (Floor 5)")

rich_presence_conditional_display(SPECTER_BINARY_FLOOR_NAME == 0x5F353530 && byte(0x882337) == 0x36, "Challenging Specter (Floor 6)")

rich_presence_conditional_display(when_this_section_is_year_select_indicates_whether_the_mode_has_been_selected() == 0x01, "About to start {0}",
    rich_presence_lookup("ClassYear", ycoordinate_when_selecting_your_year_in_academy_mode(), ClassYearLookup)
)

rich_presence_display("Diligently studying to be an irresponsible ape")
