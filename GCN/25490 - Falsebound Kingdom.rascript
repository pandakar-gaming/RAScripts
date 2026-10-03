// Yu-Gi-Oh! The Falsebound Kingdom
// #ID = 25490

// General note: this set is going to have different root pointers for things. No getting around it for now.
// I thought I had found something, but the game does some strange stuff once you step into a mission.
// The title screen loads differently for one, but also other things seem to be slightly out of whack too.

function is_ntsc() => dword_be(0) == 0x47594645
function is_pal() => dword_be(0) == 0x47594650
function is_jp() => dword_be(0) == 0xffffffff

// Get the current money available for the mission.
// This is relevant because the game actively writes to this as the mission updates.
function current_money_mission(region) {
    if (region == "NTSC") {
        return dword_be(0x0018e290)
    } else if (region == "PAL") {
        
    } else if (region == "JP") {

    }
}

// Typical Konami code: Up Up Down Down Left Right Left Right B A
//                       1  2    3    4    5     6    7     8 9 Reset
// The game keeps track of the full sequence. On hitting the final correct input, it resets and adds 579 money to your totals.
// For RA purposes this is banned. Also tracked as a funny leaderboard in case people really want to show off how much they input the code.
// For the early game set ups, at least on your first run through the game, this results in a complete imbalancing of difficulty and 
// lets a player breeze through things via equipment and items that they may otherwise struggle with. 
function entered_konami_code(region) {
    konami_code_counter = 0x00
    if (region == "NTSC") {
        konami_code_counter = 0x0018e2c4
    } else if (region == "PAL") {
        
    } else if (region == "JP") {
        
    }

    return prev(byte(konami_code_counter)) == 0x09 && byte(konami_code_counter) == 0x00
        && prev(current_money_mission("NTSC")) + 0x23d == current_money_mission("NTSC")
}


// General TODO
// 1. Link JP and note game code above
// 2. Try to find another stable pointer for "character data"
// 3. Use dicts below for RP
// 3a. Inventory count in RP, 0/512 where count goes up if slot < 0xff
// 4. Start looking into how game holds battle data live (cities, timer)
// 5. See if we can't find where the character data is being read from to determine what character's what

// 0x801bccdd is character ID [ntsc]
CAMPAIGN_LEADERS = {
    0x00: "Yugi",
    0x01: "Kaiba",
    0x02: "Joey"
}

// 0x801bccde is mission ID [ntsc] 
YUGI_MISSIONS = {
    0x00: "War Campaign",
    0x01: "Fury of the Empire",
    0x02: "Strategy",
    0x03: "Battle for Tsughut",
    0x04: "Turbulent Waters",
    0x05: "Badlands",
    0x06: "Crucial Battle",
    0x07: "Refugees",
    0x08: "Break Free",
    0x09: "Counterattack",
    0x0a: "Spellcaster",
    0x0b: "Phantom Blast",
    0x0c: "For That Someone Special",
    0x0d: "Scorched",
    0x0e: "Betrayed",
    0x0f: "A Lost Cause",
    0x10: "Secret Power",
    0x11: "Face Off",
    0x12: "Banishment",
    0x13: "Hallowed Land of Ishtar",
    0x14: "Dream World",
    0x15: "Dark Spirit",
    0x16: "Credits"
}

KAIBA_MISSIONS = {
    0x00: "Hand of Fire",
    0x01: "Bandits",
    0x02: "Surrounded",
    0x03: "Framed",
    0x04: "Lord of the Forest",
    0x05: "Lord of the Plains",
    0x06: "Sever the Supply Line!",
    0x07: "Full-Scale Offensive",
    0x08: "Crucial Battle",
    0x09: "Aid from Afar",
    0x0a: "Going the Distance",
    0x0b: "Raid",
    0x0c: "Bandits, Again",
    0x0d: "Dragon Lair",
    0x0e: "Guidance",
    0x0f: "Surprise Attack",
    0x10: "Face-Off",
    0x11: "Banishment",
    0x12: "Hallowed Land of Ishtar",
    0x13: "Dream World",
    0x14: "Dark Spirit",
    0x15: "Credits"
}

JOEY_MISSIONS = {
    0x00: "Raid",
    0x01: "Outnumbered?",
    0x02: "Quick Attack",
    0x03: "Pursuit",
    0x04: "Minion of Darkness",
    0x05: "Thrashing",
    0x06: "Reversal",
    0x07: "Master Plan",
    0x08: "Impostor",
    0x09: "Invincible Imperial Guard",
    0x0a: "Credits"
}

// TODO monster definitions here
// It really does seem like it's static, based on the US version. Game is doing simple STB and LBZ instructions on writing to the field:
// https://fenixfox-studios.com/manual/powerpc/instructions/stb.html
// https://fenixfox-studios.com/manual/powerpc/instructions/lbz.html


// +0x00 Status? for using Crawling Dragon [8-bit]
// +0x01 Star count [8-bit]
// +0x06 Max HP [16-bit BE]
// +0x08 Additional Attack [16-bit BE]
// +0x0a Additional Defense [16-bit BE]
// +0x0c EXP [16-bit BE]
// +0x0e Item #1 equipped, 0xff00 if nothing [16-bit BE]
// +0x10 Item #2 equipped, 0xff00 if nothing [16-bit BE]
// +0x12 Item #3 equipped, 0xff00 if nothing [16-bit BE]
class MonsterData {

    // index of the monster in MONSTERS array
    monster_index =  0x00
    // One of NTSC, PAL, JP
    region = "NTSC"

    function root_address() {
        offset = this.monster_index * 20
        if (this.region == "NTSC") {
            return 0x1bcce0 + offset
        } else if (this.region == "PAL") {

        } else if (this.region == "JP") {

        }
    }

    function status() {
        return byte(this.root_address())
    }

    function just_unlocked() {
        return prev(bit6(this.root_address())) == 0x00 && bit6(this.root_address()) == 0x01 
            && prev(bit7(this.root_address())) == 0x00 && bit7(this.root_address()) == 0x01
    }

    function is_unlocked() {
        return bit7(this.root_address()) == 0x01 && bit7(this.root_address()) == 0x01
    }

    function star_count() {
        return byte(this.root_address() + 0x01) 
    }

    function battle_speed() {
        return byte(this.root_address() + 0x02) 
    }

    function orb_red() {
        return byte(this.root_address() + 0x03) 
    }

    function orb_green() {
        return byte(this.root_address() + 0x04)
    }

    function orb_red() {
        return byte(this.root_address() + 0x05)
    }

    function max_hp() {
        return word_be(this.root_address() + 0x06) 

    }

    function additional_attack() {
        return word_be(this.root_address() + 0x08)
    }

    function additional_defense() {
        return word_be(this.root_address() + 0x0a)
    }

    function exp() {
        return word_be(this.root_address() + 0x0c)
    }

    function item_1_equipped() {
        return word_be(this.root_address() + 0x0e)
    }

    function item_2_equipped() {
        return word_be(this.root_address() + 0x10)
    }

    function item_3_equipped() {
        return word_be(this.root_address() + 0x12)
    }
}

// This is the order they appear in memory.
MONSTERS = [
    "Blue-Eyes White Dragon (Azrael)",
    "Seiyaryu",
    "Blue-Eyes Ultimate Dragon",
    "Kaiser Dragon",
    "Blackland Fire Dragon",
    "Curse of Dragon",
    "Red-Eyes B. Dragon",
    "B. Skull Dragon",
    "Serpent Night Dragon",
    "Meteor B. Dragon",
    "Crawling Dragon",
    "Meteor Dragon",
    "Baby Dragon",
    "Winged Dragon, Guardian of the Fortress #1",
    "Gaia the Dragon Champion",
    "Thousand Dragon",
    "Parrot Dragon",
    "Harpie's Pet Dragon",
    "Mystical Elf",
    "Time Wizard",
    "Rogue Doll",
    "Fairy's Gift",
    "Magician of Faith",
    "Saggi the Dark Clown",
    "Dark Magician",
    "Illusionist Faceless Mage",
    "Phantom Dewan",
    "Skull Knight",
    "Cosmo Queen",
    "Magician of Black Chaos",
    "Dark Elf",
    "Lord of D.",
    "Invitation to a Dark Sleep",
    "The Illusory Gentleman",
    "Dark Magician Girl",
    "Tao the Chanter",
    "Kazejin",
    "Aqua Madoor",
    "Shadow Specter",
    "Zombie Warrior",
    "The Snake Hair",
    "Armored Zombie",
    "Dragon Zombie",
    "Pumpking the King of Ghosts",
    "Shadow Ghoul",
    "Ghoul with an Appetite",
    "Giltia the D. Knight",
    "Black Luster Soldier",
    "Gate Guardian",
    "Swordstalker",
    "Flame Swordsman",
    "Swamp Battleguard",
    "Judge Man",
    "Gaia the Fierce Knight",
    "Celtic Guardian",
    "Axe Raider",
    "Zanki",
    "Ansatsu",
    "Kanan the Swordmistress",
    "Stuffed Animal",
    "Monster Tamer",
    "Swordsman from a Foreign Land",
    "Lava Battleguard",
    "Garoozis",
    "Hitotsu-Me-Giant",
    "Battle Ox",
    "Beaver Warrior",
    "Mountain Warrior",
    "Tiger Axe",
    "Rabid Horseman",
    "Sengenjin",
    "Panther Warrior",
    "Dark Rabbit",
    "Silver Wolf",
    "Mystic Horseman",
    "Hane-Hane",
    "Gazelle the King of Mythical Beasts",
    "Chimera the Flying Mythical Beast",
    "Crimson Sunbird",
    "Mavelus",
    "Wing Eagle",
    "Feral Imp",
    "Summoned Skull",
    "Horn Imp",
    "Kuriboh",
    "Castle of Dark Illusions",
    "Reaper of the Cards",
    "King of Yamimakai",
    "Dark Chimera",
    "Dark King of the Abyss",
    "Midnight Fiend",
    "Ryu-Kishin Powered",
    "Bickuribox",
    "Zoa",
    "Dragon Seeker",
    "Neck Hunter",
    "Three-headed Geedo",
    "Kryuel",
    "Gyakutenno Megami",
    "Orion the Battle King",
    "Dark Witch",
    "Dancing Elf",
    "Big Insect",
    "Basic Insect",
    "Hercules Beetle",
    "Larvae Moth",
    "Perfectly Ultimate Great Moth",
    "Dungeon Worm",
    "Man-Eater Bug",
    "Hunter Spider",
    "Two-Headed King Rex",
    "Megazowler",
    "Uraby",
    "Armored Lizard",
    "Enchanting Mermaid",
    "Fortress Whale",
    "Kairyu-Shin",
    "Aqua Dragon",
    "Sea King Dragon",
    "Spike Seadra",
    "Labyrinth Tank",
    "Metalzoa",
    "Cyber Soldier",
    "Cyber Commander",
    "Dharma Cannon",
    "Red-Eyes Black Metal Dragon",
    "Barrel Dragon",
    "Slot Machine",
    "Launcher Spider",
    "Robotic Knight",
    "Machine King",
    "Giant Mech-Soldier",
    "Cyber Saurus",
    "Sanga of the Thunder",
    "Thunder Dragon",
    "Twin-Headed Thunder Dragon",
    "Fiend Kraken",
    "Jellyfish",
    "Octoberser",
    "Beastking of the Swamps",
    "Suijin",
    "Water Girl",
    "Giant Red Seasnake",
    "Kanikabuto",
    "Zarigun",
    "Penguin Soldier",
    "Dragon Piper",
    "Flame Cerberus",
    "Giant Soldier of Stone",
    "Millenium Golem",
    "Dark Plant",
    "Queen of Autumn Leaves",
    "Moisture Creature",
    "Jinzo",
    "Alpha the Magnet Warrior",
    "Beta the Magnet Warrior",
    "Gamma the Magnet Warrior",
    "Insect Queen",
    "Dunames Dark Witch",
    "Buster Blader",
    "Valkyrion the Magna Warrior",
    "Obelisk the Tormentor",
    "Slifer the Sky Dragon",
    "The Winged Dragon of Ra",
    "Beast of Gilfer",
    "Embodiment of Apophis",
    "Mystical Beast Serket",
    "Harpie Lady (Airo)",
    "Harpie Lady (Ocupete)",
    "Harpie Lady (Keraino)",
    "Gemini Elf (Kachua)",
    "Gemini Elf (Lora)",
    "Blue-Eyes White Dragon (Ibris)",
    "Blue-Eyes White Dragon (Djibril)",
    "Rocket Warrior",
    "Dark Magician #2",
    "Berformet"
]

class CharacterData { 

    index =  0
    region = "NTSC"

    function root_address() {
        if (this.region == "NTSC") {
            return 0x1bdab4 + this.index * 8
        }
    }

}

CHARACTERS = [
    "Yugi",
    "CHARACTER 2",
    "CHARACTER 3",
    "CHARACTER 4",
    "CHARACTER 5",
    "CHARACTER 6",
    "CHARACTER 7",
    "CHARACTER 8",
    "Fizdiz",
    "Shimon",
    "Kaiba",
    "CHARACTER 12",
    "CHARACTER 13",
    "CHARACTER 14",
    "CHARACTER 15",
    "CHARACTER 16",
    "CHARACTER 17",
    "Mokuba",
    "Marthis",
    "CHARACTER 20",
    "CHARACTER 21",
    "CHARACTER 22",
    "CHARACTER 23",
    "CHARACTER 24",
    "CHARACTER 25",
    "CHARACTER 26",
]

// Note that this is partial because I don't know what every part of the city object is. 
// I'm only noting the relative parts that I'm confident in.  
class City {

    index = 0
    region = "NTSC"

    function root_address() {
        if (this.region == "NTSC") {
            return 0x001958b6 + (this.index * 0x34)
        }
    }

    function num_stars() {
        return byte(this.root_address() + 1)
    }

    function is_player_controlled() {
        return byte(this.root_address() + 2) == 0x00
    }

    function is_enemy_controlled() {
        return byte(this.root_address() + 2) == 0x01
    }

    function num_hearts() {
        return 5 - byte(this.root_address() + 3)
    }

    function num_units_in_city() {
        return byte(this.root_address() + 5)
    }

    function stationed_unit(i) {
        return byte(this.root_address() + 6 + i)
    }

    function upgrade_one() {
        return byte(this.root_address() + 0x0e)
    }

    function upgrade_two() {
        return byte(this.root_address() + 0x0f)
    }

    function has_any_upgrade() {
        return byte(this.root_address() + 0x0e) != 0x00 && byte(this.root_address() + 0x0f) != 0x00
    }
}


class FieldedMonster {

    root_address = 0xffffffff

    function ptr_monster_data() => dword_be(this.root_address)
    function monster_level() => byte(this.root_address + 0x04)
    function action_points() => byte(this.root_address + 0x05)
    function element() => byte(this.root_address + 0x06)
    function max_hp() => word_be(this.root_address + 0x0c)
    function attack() => word_be(this.root_address + 0x0e)
    function defense() => word_be(this.root_address + 0x10)
    function exp() => word_be(this.root_address + 0x12)
    function current_hp() => word_be(this.root_address + 0x14)
    function gold_value() => word_be(this.root_address + 0x16)
    function item_1() => word_be(this.root_address + 0x18)
    function item_2() => word_be(this.root_address + 0x1a)
    function item_3() => word_be(this.root_address + 0x1c)
    function enemy_id() => word_be(this.root_address + 0x1e)

}

// 128 bytes
// 20 are for player
// 36 * 3 for fielded monsters
class PlayerFieldedTeam {

    index = 0
    region = "NTSC"

    function root_address() {
        if (this.region == "NTSC") {
            return (0x001bdbcc) + (this.index * 128)
        }
    }

    function player_reference_ptr() => dword_be(this.root_address() + 0x04)
    function player_level() => byte(this.root_address() + 0x08)
    function player_red_affinity() => byte(this.root_address() + 0x09)
    function player_green_affinity() => byte(this.root_address() + 0x0a)
    function player_blue_affinity() => byte(this.root_address() + 0x0b)
    function player_experience() => word_be(this.root_address() + 0x0c)
    // Middle monster
    function middle_monster() => FieldedMonster(this.root_address() + 0x14)
    // Left monster
    function left_monster() => FieldedMonster(this.root_address() + 0x38)
    // Right monster
    function right_monster() => FieldedMonster(this.root_address() + 0x5c)
}

class EnemyFieldedTeam {

    index = 0
    region = "NTSC"

    function root_address() {
        if (this.region == "NTSC") {
            return (0x001bee1c) + (this.index * 128)
        }
    }

    function player_reference_ptr() => dword_be(this.root_address() + 0x04)
    function player_level() => byte(this.root_address() + 0x08)
    function player_red_affinity() => byte(this.root_address() + 0x09)
    function player_green_affinity() => byte(this.root_address() + 0x0a)
    function player_blue_affinity() => byte(this.root_address() + 0x0b)
    function player_experience() => word_be(this.root_address() + 0x0c)
    function middle_monster() => FieldedMonster(this.root_address() + 0x14)
    function left_monster() => FieldedMonster(this.root_address() + 0x38)
    function right_monster() => FieldedMonster(this.root_address() + 0x5c)

}

// The enemy's polymerized monster gets copied to a separate, temporary block. 
// It still has the same structure, but acts separately. 
class EnemyPolymerizedMonster {
    region = "NTSC"
    root_address = 0x001bf9d0

    function root_address() {
        if (this.region == "NTSC") {
            return 0x001bf9d0
        }
    }

    function ptr_monster_data() => dword_be(this.root_address)
    function monster_level() => byte(this.root_address + 0x04)
    function action_points() => byte(this.root_address + 0x05)
    function element() => byte(this.root_address + 0x06)
    function max_hp() => word_be(this.root_address + 0x0c)
    function attack() => word_be(this.root_address + 0x0e)
    function defense() => word_be(this.root_address + 0x10)
    function exp() => word_be(this.root_address + 0x12)
    function current_hp() => word_be(this.root_address + 0x14)
    function gold_value() => word_be(this.root_address + 0x16)
    function item_1() => word_be(this.root_address + 0x18)
    function item_2() => word_be(this.root_address + 0x1a)
    function item_3() => word_be(this.root_address + 0x1c)
    function enemy_id() => word_be(this.root_address + 0x1e)

    function enemy_is(enemy) {
        if (enemy == "Blue-Eyes Ultimate Dragon") {
            return this.enemy_id() == 0x200
        } else if (enemy == "Gate Guardian") {
            return this.enemy_id() == 0x3000
        }
    }

}

function campaign_character_addr(region) {
    if (region == "NTSC") {
        return byte(0x001bccdd)
    } else if (region == "PAL") {

    } else if (region == "JP") {

    }
}

function campaign_mission_addr(region) {
    if (region == "NTSC") {
        return byte(0x001bccde)
    } else if (region == "PAL") {

    } else if (region == "JP") {

    }
}


function current_campaign_character_is(region, char_name) {
    campaign_character = campaign_character_addr(region)

    if (char_name == "Yugi") {
        return campaign_character == 0x00
    } else if (char_name == "Kaiba") {
        return campaign_character == 0x01
    } else if (char_name == "Joey") {
        return campaign_character == 0x02
    }
}

function current_campaign_mission(region) {
    campaign_character = campaign_character_addr(region)
    campaign_mission_addr = campaign_mission_addr(region)

    if (byte(campaign_character) == 0x00) {
        return YUGI_MISSIONS[(campaign_mission_addr)]
    } else if (byte(campaign_character) == 0x01) {
        return KAIBA_MISSIONS[(campaign_mission_addr)]
    } else if (byte(campaign_character) == 0x02) {
        return JOEY_MISSIONS[(campaign_mission_addr)]
    }
}

function current_campaign_mission_is(region, char_name, mission_name) {
    campaign_mission = campaign_mission_addr(region)

    mission_catalog = {}
    if (char_name == "Yugi") {
        mission_catalog = YUGI_MISSIONS
    } else if (char_name == "Kaiba") {
        mission_catalog = KAIBA_MISSIONS
    } else if (char_name == "Joey") {
        mission_catalog = JOEY_MISSIONS
    }

    is_correct_mission = always_false()

    for mission in mission_catalog {
        if (mission_catalog[mission] == mission_name) {
            is_correct_mission = campaign_mission == mission
        }
    }
    
    return current_campaign_character_is(region, char_name) && is_correct_mission
}

function character_joined_team(region, char_name) {
    char_address_start = 0x00000000
    if (region == "NTSC") {
        char_address_start = 0x001bdab4
    } else if (region == "PAL") {
        
    } else if (region == "JP") {

    }

    offset = 0

    if (char_name == "Tristan") {
        offset = 2
    } else if (char_name == "Mako") {
        offset = 5
    } else if (char_name == "Bakura") {
        offset = 7
    }

    return prev(bit6(char_address_start + (8 * offset))) == 0x00
        && bit6(char_address_start + (8 * offset)) == 0x01
        && prev(bit7(char_address_start + (8 * offset))) == 0x00 
        && bit7(char_address_start + (8 * offset)) == 0x01 
}

function city_liberated(region, char_name, mission_name, city_name) {
    addr = 0x00

    if (region == "NTSC") {
        addr = 0x0018e28f
    }

    if (char_name == "Yugi" && mission_name == "Strategy" && city_name == "Telenoes") {
        return prev(bit0(addr)) == 0x00 && bit0(addr) == 0x01
    }

}

function monster_data_of(region, monster_name) {
    i = 0
    for monster in MONSTERS {
        if (monster == monster_name) {
            return MonsterData(i, region)
        }
        i = i + 1
    }
}

CURRENT_GAME_MODE_FINGERPRINT = {
    0x02: "Watching the intro cinematic",
    0x03: "On the title screen",
    0x04: "On the title screen",
    0x05: "Deciding between Story and Challenge",
    0x0d: "In Challenge mode",
    0x0e: "Selecting a character for Story",
    0x0f: "Selecting a character for Story",
    0x10: "",
    0x15: "Watching an example battle",
}

function main_menu_fingerprint_addr(region) {
    if (region == "NTSC") {
        return byte(0x001d10b1)
    } else if (region == "PAL") {

    } else if (region == "JP") {

    }
}

function map_timer(region) {
    addr = 0x00
    if (region == "NTSC") {
        return dword_be(0x0018e304)
    }


}

// Helper to tell if the main menu is pulled up.
// region: one of "NTSC", "PAL", or "JP"
// Pseudologic:
// You either have nonzero campaign progress, OR are on Yugi 0/0 mission
// If we're on the base case, likely on the main menu. 
function on_main_menu(region) {
    if (region == "NTSC") {
        return byte(0x001d10b1) != 0x12 && byte(0x001bccdd) == 0x00 && byte(0x001bccde) == 0x00
    } else if (region == "PAL") {

    } else if (region == "JP") {

    }
}

function campaign_mission_addr(region) {
    if (region == "NTSC") {
        return byte(0x001bccde)
    } else if (region == "PAL") {

    } else if (region == "JP") {

    }
}

function in_campaign(region) {
    if (region == "NTSC") {
        return byte(0x001d10b1) == 0x12 || byte(0x001bccdd) > 0x00 || byte(0x001bccde) > 0x00
    } else if (region == "PAL") {

    } else if (region == "JP") {

    }
}

achievement(
    title = "Yugi, No!",
    description = "The Konami code disables all achievements. Achievements are now locked until you restart the game.",
    points = 0,
    trigger = (
        is_ntsc() && entered_konami_code("NTSC")
    )
)

achievement(
    title = "The Wolf of Makhad",
    description = "[Yugi] Recruit the Silver Wolf to your army.",
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "War Campaign") 
        && monster_data_of("NTSC", "Silver Wolf").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "War Campaign",
    description = "[Yugi] Liberate Jakhud during War Campaign to kick off the revolution.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "War Campaign")
        && monster_data_of("NTSC", "Blackland Fire Dragon").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// One of the units just forgets to leave if you take the other town first. 
// TODO tighten this so that it's as follows:
// never (enemy hp goes from 0 to half, i.e. they respawned)
// while controlling the tutorial town they suggest
achievement(
    title = "Tutorial Unclear",
    description = "[Yugi] Defeat the Officer stationed in Jakhud while controlling all other cities.",
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "War Campaign")
        && City(2).is_player_controlled()
        && City(3).is_player_controlled()
        && prev(City(0).num_units_in_city()) == 0x02
        && City(0).num_units_in_city() == 0x01
        // // one of:
        //     // left monster dies, right and mid already dead
        // && ((EnemyFieldedTeam(1).right_monster().current_hp() == 0
        //     && EnemyFieldedTeam(1).middle_monster().current_hp() == 0
        //     && prev(EnemyFieldedTeam(1).left_monster().current_hp()) > 0
        //     && EnemyFieldedTeam(1).left_monster().current_hp() == 0) 
        //     || 
        //     // mid monster dies, left and right already dead
        //     (EnemyFieldedTeam(1).right_monster().current_hp() == 0
        //     && EnemyFieldedTeam(1).left_monster().current_hp() == 0
        //     && prev(EnemyFieldedTeam(1).middle_monster().current_hp()) > 0
        //     && EnemyFieldedTeam(1).middle_monster().current_hp() == 0) 
        //     // right monster dies, left and mid already dead

        //     || (EnemyFieldedTeam(1).middle_monster().current_hp() == 0
        //     && EnemyFieldedTeam(1).left_monster().current_hp() == 0
        //     && prev(EnemyFieldedTeam(1).right_monster().current_hp()) > 0
        //     && EnemyFieldedTeam(1).right_monster().current_hp() == 0
        //     )
        // )
        // I do not remember if there is aoe in this game. If there is it's not today's combinatorics problem.
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Croethian Roamers",
    description = "[Yugi] Recruit the Mystic Horseman, Man-Eater Bug and Hane-Hane to your army.",
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Fury of the Empire")
        && monster_data_of("NTSC", "Mystic Horseman").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Fury of the Empire",
    description = "[Yugi] Liberate Ashton during Fury of the Empire and welcome a friendly face to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Fury of the Empire")
        && character_joined_team("NTSC", "Tristan")
        && unless(once(entered_konami_code("NTSC")))
    )
)

// Mission 3 idea: capture Dyethruo before 9:00pm. 
// Alternative: 

achievement(
    title = "Sometimes You Just Need to Ask Nicely",
    description = "[Yugi] Recruit Winged Dragon, Guardian of the Fortress #1 to your army.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Strategy")
        && monster_data_of("NTSC", "Winged Dragon, Guardian of the Fortress #1").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Strategy",
    description = "[Yugi] Liberate Telenoes during Strategy.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Strategy")
        && city_liberated("NTSC", "Yugi", "Strategy", "Telenoes")
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Battle for Tsughut",
    description = "[Yugi] Liberate Tsughut during Battle for Tsughut.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Battle for Tsughut")
        && character_joined_team("NTSC", "Bakura")
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Those Cannons Don't Scare Me!",
    // todo update badge so that clock face has hands
    description = "[Yugi] Liberate Tsughut before Bakura disables the castle's defenses.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Battle for Tsughut")
        && City(index = 0, region = "NTSC").has_any_upgrade()
        && trigger_when(character_joined_team("NTSC", "Bakura"))
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Persuading Jokhan's Finest",
    description = "[Yugi] Defeat Octoberser and recruit them to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Turbulent Waters")
        && monster_data_of("NTSC", "Octoberser").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "The Siren of Van-Lova",
    description = "[Yugi] Defeat Enchanting Mermaid and recruit her to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Turbulent Waters")
        && monster_data_of("NTSC", "Enchanting Mermaid").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Turbulent Waters",
    description = "[Yugi] Liberate Gigan-Syip during Turbulent Waters and take your first step onto the mainland.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Turbulent Waters")
        && character_joined_team("NTSC", "Mako")
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Correcting Impolite Behaviors",
    description = "[Yugi] Defeat The Illusory Gentleman and his minions and recruit them to your army.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Badlands")
        && monster_data_of("NTSC", "The Illusory Gentleman").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Living on the Edge",
    description = "[Yugi] Defeat the Summoned Skull and recruit it to your army.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Badlands")
        && monster_data_of("NTSC", "Summoned Skull").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Beasty Badlands",
    description = "[Yugi] Liberate Air-Shrine during Badlands.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Badlands")
        && monster_data_of("NTSC", "Dark Magician").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Crucial Battle", 
    description = "[Yugi] Defeat Haysheen at Enno.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Crucial Battle")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// Everyone can relax now, I have arrived!
// Huh? Am I too late? You didn't need me?
// - You're too late, Mai.
// Well, I got here as fast as I could, but you can't rush a lady, you know.
achievement(
    title = "Can't Rush a Lady",
    description = "[Yugi] Defeat Haysheen at Enno before Mai arrives.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Crucial Battle")
        // and mai is not on the field
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )

)

achievement(
    title = "Exhilirating Escape",
    description = "[Yugi] Complete Refugees without any of your monsters taking damage.",
    points = 5,
    // 
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        // tea enters Craw-Valley (Craw-Valley's user count goes from 4 to 5)
        && prev(City(2).num_units_in_city()) == 0x04
        && City(2).num_units_in_city() == 0x05
        // player 0 monsters never change hp
        && disable_when(
            PlayerFieldedTeam(0).middle_monster().max_hp() > PlayerFieldedTeam(0).middle_monster().current_hp(),
            until=!current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(0).left_monster().max_hp() > PlayerFieldedTeam(0).left_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(0).right_monster().max_hp() > PlayerFieldedTeam(0).right_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        // player 1 monsters never change hp
        && disable_when(
            PlayerFieldedTeam(1).middle_monster().max_hp() > PlayerFieldedTeam(1).middle_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(1).left_monster().max_hp() > PlayerFieldedTeam(1).left_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(1).right_monster().max_hp() > PlayerFieldedTeam(1).right_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        // player 2 monsters never change hp
        && disable_when(
            PlayerFieldedTeam(2).middle_monster().max_hp() > PlayerFieldedTeam(2).middle_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(2).left_monster().max_hp() > PlayerFieldedTeam(2).left_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(2).right_monster().max_hp() > PlayerFieldedTeam(2).right_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        // player 3 monsters never change hp
        && disable_when(
            PlayerFieldedTeam(3).middle_monster().max_hp() > PlayerFieldedTeam(3).middle_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(3).left_monster().max_hp() > PlayerFieldedTeam(3).left_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(3).right_monster().max_hp() > PlayerFieldedTeam(3).right_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        // player 4 monsters never change hp
        && disable_when(
            PlayerFieldedTeam(4).middle_monster().max_hp() > PlayerFieldedTeam(4).middle_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(4).left_monster().max_hp() > PlayerFieldedTeam(4).left_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && disable_when(
            PlayerFieldedTeam(4).right_monster().max_hp() > PlayerFieldedTeam(4).right_monster().current_hp(),
            until=current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        )
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Refugees",
    description = "[Yugi] Complete Refugees by capturing Vrauson.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Another Refugee in Tow",
    description = "[Yugi] Recruit Baby Dragon during Refugees.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Refugees")
        && monster_data_of("NTSC", "Baby Dragon").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// Defeat Atensa before reinforcements arrive in Break Free.
// Interesting note: every unit in Break Free respawns and refuses to leave Chelyumn. 

achievement(
    title = "Harpie Lady Ocupete",
    description = "[Yugi] Recruit Harpie Lady (Ocupete) to your army.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Break Free")
        && monster_data_of("NTSC", "Harpie Lady (Ocupete)").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))        
    )
)

achievement(
    title = "Sanga of the Thunder",
    description = "Defeat Sanga of the Thunder during Break Free and recruit it to your army.",
    points = 3,
    trigger = (
        is_ntsc() 
        && current_campaign_mission_is("NTSC", "Yugi", "Break Free")
        && monster_data_of("NTSC", "Sanga of the Thunder").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))        
    )
)



// I'm sorry I'm late! But I'm here now!
// Number One Student
// That's nice! 'Near the bottom,' indeed! That's no way to build up a girl's confidence, you know.
achievement(
    title = "Number One Student",
    description = "Recruit the Dark Magician Girl to your army.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Counterattack")
        && monster_data_of("NTSC", "Dark Magician Girl").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "A Day in Hand",
    description = "Recruit the Time Wizard to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Spellcaster")
        && monster_data_of("NTSC", "Time Wizard").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Fatally Flawed Spellwork",
    description = "Liberate Air-Shrine during Spellcaster.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Spellcaster")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Draconic Aid",
    description = "Liberate Enno during Phantom Blast.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Phantom Blast")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// For That Someone Special
achievement(
    title = "For That Someone Special",
    description = "Defeat Joey with Mai during For That Someone Special.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "For That Someone Special")
        && monster_data_of("NTSC", "Panther Warrior").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Coastal Menaces",
    description = "Defeat and recruit the roaming monsters on the coasts of Tsughut during Scorched.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Scorched")
        && monster_data_of("NTSC", "Suijin").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// did not pop, it's not city 0
achievement(
    title = "Scorched",
    description = "Reclaim Telenoes in Scorched.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Scorched")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Betrayed",
    description = "Save Jakhud from Bakura's backstabbing forces.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Betrayed")
        && character_joined_team("NTSC", "Espa Roba")
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "The True Magician Master",
    description = "It's not so lost now, is it?!",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "A Lost Cause")
        && monster_data_of("NTSC", "Dark Magician #2").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "The King of Machines",
    description = "Liberate Jenonnva during Secret Power and discover Machine King.", 
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Secret Power")
        && monster_data_of("NTSC", "Machine King").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Our Ancestors Knew of Magnets",
    description = "Liberate Phyo-Rente during Secret Power and discover Beta the Magnet Warrior.",
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Secret Power")
        && monster_data_of("NTSC", "Beta the Magnet Warrior").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Abandoned Artillery",
    description = "Discover the Labyrinth Tank while exploring the forests in Secret Power.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Secret Power")
        && monster_data_of("NTSC", "Labyrinth Tank").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Pertubed Piper",
    description = "Discover the Dragon Piper while exploring the forests in Secret Power.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Secret Power")
        && monster_data_of("NTSC", "Dragon Piper").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Powers Once Lost",
    description = "Discover the Millenium Golem alongside secrets of lost rituals in Secret Power.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Secret Power")
        && monster_data_of("NTSC", "Millenium Golem").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// Face Off
achievement(
    title = "Earning Eternal Loyalty",
    description = "Recruit Gaia the Fierce Knight to your army during Face Off.",
    points = 10,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Face Off")
        && monster_data_of("NTSC", "Gaia the Fierce Knight").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Red Sparks Flying",
    description = "Defeat Kaiba at Nonnber during Face Off.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Face Off")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Besting the Dragon King",
    description = "Defeat Kaiba's Blue-Eyes Ultimate Dragon during Face Off.",
    points = 10,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Face Off")
        && EnemyPolymerizedMonster().enemy_is("Blue-Eyes Ultimate Dragon")
        && trigger_when(prev(EnemyPolymerizedMonster().current_hp() > 0x00))
        && trigger_when(EnemyPolymerizedMonster().current_hp() == 0x00)
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Harpie Lady Keraino",
    description = "Recruit Harpie Lady (Keraino) to your army during Banishment.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Banishment")
        && monster_data_of("NTSC", "Harpie Lady (Keraino)").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// Not city 0, need to dig more
achievement(
    title = "You're a Third Rate Fighter With a Fourth Rate Army",
    description = "Defeat Scott at Sygh-Varths during Banishment.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Banishment")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// hollowed land of ishtar
// capture all cities, defeat all enemy soldiers, they cannot claim any city
achievement(
    title = "Aggressive Posturing",
    description = "Claim all cities during The Hollowed Land of Ishtar and complete the mission with the enemy having never claimed a city.",
    points = 4,
    trigger = (
        always_false()
    )
)

achievement(
    title = "Saving Private Mokuba",
    description = "[Yugi] Complete the Hollowed Land of Ishtar.",
    points = 4,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Hollowed Land of Ishtar")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Soldiers in a Strange Space",
    description = "[Yugi] Recruit Alpha the Magnet Warrior to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Dream World")
        && monster_data_of("NTSC", "Alpha the Magnet Warrior").just_unlocked()
        && unless(once(entered_konami_code("NTSC"))) 
    )
)

achievement(
    title = "Ruler of Cyberspace",
    description = "Claim all cities during Dream World and complete the mission with at least one team stationed in each city.",
    points = 5,
    trigger = (
        is_ntsc()
        && (current_campaign_mission_is("NTSC", "Yugi", "Dream World") || current_campaign_mission_is("NTSC", "Kaiba", "Dream World"))
        && City(1).is_player_controlled()
        && City(1).num_units_in_city() >= 0x01
        && City(2).is_player_controlled()
        && City(2).num_units_in_city() >= 0x01
        && City(3).is_player_controlled()
        && City(3).num_units_in_city() >= 0x01
        && City(4).is_player_controlled()
        && City(4).num_units_in_city() >= 0x01
        && City(5).is_player_controlled()
        && City(5).num_units_in_city() >= 0x01
        && City(6).is_player_controlled()
        && City(6).num_units_in_city() >= 0x01
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )    
)

achievement(
    title = "Tearing Firewalls Down",
    description = "Defeat the polymerized Gate Guardian during Dream World.",
    points = 5,
    trigger = (
        is_ntsc()
        && (current_campaign_mission_is("NTSC", "Yugi", "Dream World") || current_campaign_mission_is("NTSC", "Kaiba", "Dream World"))
        && EnemyPolymerizedMonster("NTSC").enemy_is("Gate Guardian")
        && trigger_when(prev(EnemyPolymerizedMonster("NTSC").current_hp() > 0x00))
        && trigger_when(EnemyPolymerizedMonster("NTSC").current_hp() == 0x00)
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Yugi's Dream World",
    description = "[Yugi] Complete Dream World.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Dream World")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "The Tormentor",
    description = "[Yugi] Defeat Obelisk the Tormentor and escape this virtual world.",
    points = 25,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Yugi", "Dark Spirit")
        && EnemyFieldedTeam(0).middle_monster().enemy_id() == 0xff // TODO get obelisk's ID
        && prev(EnemyFieldedTeam(0).middle_monster().current_hp()) > 0x00
        && EnemyFieldedTeam(0).middle_monster().current_hp() == 0x00
    )
)

achievement(
    title = "A Dangerous Forest",
    description = "[Kaiba] Defeat Berformet and recruit it to your army.",
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Hand of Fire")
        && monster_data_of("NTSC", "Berformet").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// Ryu-Kishin Powered joins
achievement(
    title = "Hand of Fire",
    description = "[Kaiba] Complete Hand of Fire.",
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Hand of Fire")
        && monster_data_of("NTSC", "Ryu-Kishin Powered").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// mission 2: bonz joins as trigger
achievement(
    // "Boss! Don't Leave me behind!"
    // "I don't want to die! Spare me! Have mercy!"
    title = "My Life is Yours",
    description = "[Kaiba] Disperse the bandits and strong-arm Bonz into joining your cause.",
    points = 2,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Bandits")
        && character_joined_team("NTSC", "Bonz")
        && unless(once(entered_konami_code("NTSC")))
    )
)

// mission 3: actual full clear mission because it'd probably be a challenge
achievement(
    title = "Turning the Tides",
    description = "[Kaiba] Capture every city during Surrounded.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Bandits")
        // trigger here needs work, this just says we captured all cities once
        && prev(bitcount(0x0018e28f)) == 0x07
        && bitcount(0x0018e28f) == 0x08
        && unless(once(entered_konami_code("NTSC")))
    )
)

// With the current planned badge, try to have this pop after the night-time dialogue.
achievement(
    title = "Say You're Sorry Isn't So Effective",
    description = "[Kaiba] Defeat Pegasus's resistance at Enno.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Bandits")
        // trigger here needs work, this just says we captured all cities once
        && prev(City(5).is_enemy_controlled())
        && City(5).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))

    )
)

achievement(
    title = "This Isn't the Alpha Warrior You're Looking For",
    description = "Recruit Gamma the Magnet Warrior to your army during Framed.",
    points = 1,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Framed")
        && monster_data_of("NTSC", "Gamma the Magnet Warrior").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// mission 4: clear the missions before Pegasus arrives
achievement(
    title = ""
)

achievement(
    title = "Pegasus J. Kroitzel is Today's Friend",
    description = "",
    points = 0,
    trigger = (

    )
)

achievement(
    title = "Making Up For That Rude Entrance",
    description = "Defeat Tiger Axe and recruit him to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Lord of the Plains")
        && monster_data_of("NTSC", "Tiger Axe").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

// Garoozis
// Hold it right there! You can't go through here. Leave your toll and be on your way!
achievement(
    title = "Won't Be Paying That Toll, Thanks",
    description = "[Kaiba] Defeat Garoozis and recruit it to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Sever the Supply Line!")
        && monster_data_of("NTSC", "Garoozis").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Moisture Creature",
    description = "[Kaiba] Recruit the Moisture Creature to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Sever the Supply Line!")
        && monster_data_of("NTSC", "Moisture Creature").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Sever the Supply Line!",
    description = "[Kaiba]",
    points = 3,
    trigger = (
        is_ntsc()
        // mission 7: Runinn-Zhamhud 
        && current_campaign_mission_is("NTSC", "Kaiba", "Sever the Supply Line!")
        && monster_data_of("NTSC", "Moisture Creature").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "The Scourge of Thor-Mount's Waters",
    description = "[Kaiba] Defeat the Sea King Dragon and recruit it to your army.",
    points = 3,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Full-Scale Offensive")
        && monster_data_of("NTSC", "Sea King Dragon").just_unlocked()
        && unless(once(entered_konami_code("NTSC")))
    )
)

achievement(
    title = "Full-Scale Offensive",
    description = "[Kaiba] Defeat Necubetos at Gigan-Syip.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Full-Scale Offensive")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    ) 
)

achievement(
    title = "Judge, Jury and Executioner",
    description = "[Kaiba] Defeat Haysheen at Nonnber.",
    points = 5,
    trigger = (
        is_ntsc()
        && current_campaign_mission_is("NTSC", "Kaiba", "Crucial Battle")
        && prev(City(0).is_enemy_controlled())
        && City(0).is_player_controlled()
        && unless(once(entered_konami_code("NTSC")))
    )  
)


// Aid from Afar
achievement(
    title = "Holding On",
    description = "[Kaiba] Complete 'Aid from Afar' without any of your marshals being defeated.",
    points = 5,
    trigger = (
        
    )
)
// Challenge idea: complete the mission without losing any marshals.

// So You're Saying There's A Chance (Your chances of winning are less than 0.00009%)
achievement(
    title = "Survival is Paramount",
    description = "[Kaiba] Survive Scott's onslaught until the mission timer runs out on Going the Distance.",
    points = 5,
    trigger = (
    )
) 

achievement(
    title = "So You're Saying There's a Chance",
    description = "[Kaiba] Defeat Scott at Gigan-Syip during Going the Distance.",
    points = 5,
    trigger = (
        // capture city 1
    )
)

// mission 12 - Defeat 
achievement(
    title = "Replenishing Supplies",
    description = "[Kaiba] Defeat Semmut at Beyzon during Raid.",
    points = 3,
    trigger = ()
)

achievement(
    title = "Money's As Important As Information",
    description = "During Bandits, Again, capture all cities.",
    points = 3,
    trigger = (

    )
)

achievement(
    title = "",
    description = "",
    points = 3,
    trigger = (

    )
)
// mission 13 - 


// Bandits, Again
achievement(

)

leaderboard(
    title = "Konami Code Single Mission Usage",
    description = "Number of times you used the Konami code in any singular mission.",
    start = always_false(),
    cancel = always_true(),
    submit = always_false(),
    value = 0
)

leaderboard(
    title = "Challenge Super Easy Score",
    description = "Score at the end of Challenge Mode on Super Easy",
    start = always_false(),
    cancel = always_true(),
    submit = always_false(),
    value = 0
)

leaderboard(
    title = "Challenge Easy Score",
    description = "Score at the end of Challenge Mode on Easy",
    start = always_false(),
    cancel = always_true(),
    submit = always_false(),
    value = 0
)

leaderboard(
    title = "Challenge Normal Score",
    description = "Score at the end of Challenge Mode on Normal",
    start = always_false(),
    cancel = always_true(),
    submit = always_false(),
    value = 0
)

leaderboard(
    title = "Challenge Hard Score",
    description = "Score at the end of Challenge Mode on Hard",
    start = always_false(),
    cancel = always_true(),
    submit = always_false(),
    value = 0
)

leaderboard(
    title = "Challenge Super Hard Score",
    description = "Score at the end of Challenge Mode on Super Hard",
    start = always_false(),
    cancel = always_true(),
    submit = always_false(),
    value = 0
)

rich_presence_conditional_display(
    on_main_menu("NTSC"), "[NTSC] {0}",
    rich_presence_lookup("MainMenuOption", main_menu_fingerprint_addr("NTSC"), CURRENT_GAME_MODE_FINGERPRINT)
)

rich_presence_conditional_display(
    in_campaign("NTSC") && once(entered_konami_code("NTSC")), "[NTSC] {0} entered the Konami code! Achievements are locked.",
    rich_presence_lookup("CurrentCharacter", campaign_character_addr("NTSC"), CAMPAIGN_LEADERS)
)

rich_presence_conditional_display(
    in_campaign("NTSC") && current_campaign_character_is("NTSC", "Yugi"), "[NTSC] Yugi is on {0}",
    rich_presence_lookup("CampaignMissionsYugi", campaign_mission_addr("NTSC"), YUGI_MISSIONS)
)

rich_presence_conditional_display(
    in_campaign("NTSC") && current_campaign_character_is("NTSC", "Kaiba"), "[NTSC] Kaiba is on {0}",
    rich_presence_lookup("CampaignMissionsKaiba", campaign_mission_addr("NTSC"), KAIBA_MISSIONS)
)

rich_presence_conditional_display(
    in_campaign("NTSC") && current_campaign_character_is("NTSC", "Joey"), "[NTSC] Joey is on {0}",
    rich_presence_lookup("CampaignMissionJoey", campaign_mission_addr("NTSC"), JOEY_MISSIONS)
)

rich_presence_display("Stub")