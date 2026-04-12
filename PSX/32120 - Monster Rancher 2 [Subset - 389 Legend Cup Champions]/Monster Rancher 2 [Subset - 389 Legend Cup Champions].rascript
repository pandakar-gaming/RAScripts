// Monster Rancher 2 [Subset - 389 Legend Cup Champions]
// #ID = 11287
// #subset_id=32120
// md5: 05818755ed7ba092aef2a3bb681d0118


// IMPORTANT this only covers named breeds
// Any special monsters with a sub-breed of ??? need to be manually checked and noted
breeds = {
    "Pixie": 0x00,
    "Dragon": 0x01,
    "Centaur": 0x02,
    "ColorPandora": 0x03,
    "Beaclon": 0x04,
    "Henger": 0x05,
    "Wracky": 0x06,
    "Golem": 0x07,
    "Zuum": 0x08,
    "Durahan": 0x09,
    "Arrow Head": 0x0a,
    "Tiger": 0x0b,
    "Hopper": 0x0c,
    "Hare": 0x0d,
    "Baku": 0x0e,
    "Gali": 0x0f,
    "Kato": 0x10,
    "Zilla": 0x11,
    "Bajarl": 0x12,
    "Mew": 0x13,
    "Phoenix": 0x14,
    "Ghost": 0x15,
    "Metalner": 0x16,
    "Suezo": 0x17,
    "Jill": 0x18,
    "Mocchi": 0x19,
    "Joker": 0x1a,
    "Gaboo": 0x1b,
    "Jell": 0x1c,
    "Undine": 0x1d,
    "Niton": 0x1e,
    "Mock": 0x1f,
    "Ducken": 0x20,
    "Plant": 0x21,
    "Monol": 0x22,
    "Ape": 0x23,
    "Worm": 0x24,
    "Naga": 0x25
}

items = {
    "Strong Glue": 0x66
}

// Check that the inventory contains Strong Glue
// item_name: str, should map to items dict
function inventory_contains_glue() {
    return __ornext(byte(0x09923c) == 0x66 ||
        byte(0x099240) == 0x66 ||
        byte(0x099244) == 0x66 ||
        byte(0x099248) == 0x66 ||
        byte(0x09924c) == 0x66 ||
        byte(0x099250) == 0x66 ||
        byte(0x099254) == 0x66 ||
        byte(0x099258) == 0x66 ||
        byte(0x09925c) == 0x66 ||
        byte(0x099260) == 0x66 ||
        byte(0x099264) == 0x66 ||
        byte(0x099268) == 0x66 ||
        byte(0x09926c) == 0x66 ||
        byte(0x099270) == 0x66 ||
        byte(0x099274) == 0x66 ||
        byte(0x099278) == 0x66 ||
        byte(0x09927c) == 0x66 ||
        byte(0x099280) == 0x66 ||
        byte(0x099284) == 0x66 ||
        byte(0x099288) == 0x66)
}

function primary_breed() => byte(0x97a18)
function secondary_breed() => byte(0x97a1c)

function is_primary_breed(breed_name) => primary_breed() == breeds[breed_name]
function is_secondary_breed(breed_name) => secondary_breed() == breeds[breed_name]

// Given the name of the unique monster, determine whether our current monster is that monster.
// Rare breeds have some sub-breed identifier from 0x26 to 0x2b
// It is dependent on which specific monster you're talking about though, and it is not formulaic
// Special enemy monsters also make use of this system so we have to map it out
function rare_breed_matches(breed_name) {

    if (breed_name == "Poison") {
        return is_primary_breed("Pixie") && secondary_breed() == 0x26
    }
    
    if (breed_name == "Kasumi") {
        return is_primary_breed("Pixie") && secondary_breed() == 0x27
    }
    
    if (breed_name == "Mia") {
        return is_primary_breed("Pixie") && secondary_breed() == 0x28
    }

    if (breed_name == "Moo") {
        return is_primary_breed("Dragon") && secondary_breed() == 0x26
    }
    
    if (breed_name == "Trotter") {
        return is_primary_breed("Centaur") && secondary_breed() == 0x26
    }    
    
    if (breed_name == "Blue Thunder") {
        return is_primary_breed("Centaur") && secondary_breed() == 0x27
    }    
    
    if (breed_name == "Dice") {
        return is_primary_breed("ColorPandora") && secondary_breed() == 0x26
    }
    
    if (breed_name == "Tram") {
        return is_primary_breed("ColorPandora") && secondary_breed() == 0x27
    }
    
    if (breed_name == "Eggplantern") {
        return is_primary_breed("Beaclon") && secondary_breed() == 0x26
    }
    
    if (breed_name == "Skeleton") {
        return is_primary_breed("Henger") && secondary_breed() == 0x26
    }

    if (breed_name == "Satan Clause") {
        return is_primary_breed("Wracky") && secondary_breed() == 0x26
    }
    
    if (breed_name == "ForwardGolem") {
        return is_primary_breed("Golem") && secondary_breed() == 0x26
    }

    if (breed_name == "ZebraSaurian") {
        return is_primary_breed("Zuum") && secondary_breed() == 0x26
    }
    
    if (breed_name == "Shogun") {
        return is_primary_breed("Durahan") && secondary_breed() == 0x26
    }

    if (breed_name == "Ruby Knight") {
        return is_primary_breed("Durahan") && secondary_breed() == 0x27
    }

    if (breed_name == "Kokushi Muso") {
        return is_primary_breed("Durahan") && secondary_breed() == 0x28
    }

    if (breed_name == "Sumopion") {
        return is_primary_breed("Arrow Head") && secondary_breed() == 0x26
    }

    if (breed_name == "White Hound") {
        return is_primary_breed("Tiger") && secondary_breed() == 0x26
    }

    if (breed_name == "Frog Hopper") {
        return is_primary_breed("Hopper") && secondary_breed() == 0x26
    }

    if (breed_name == "KungFuHare") {
        return is_primary_breed("Hare") && secondary_breed() == 0x26
    }

    if (breed_name == "ShiShi") {
        return is_primary_breed("Baku") && secondary_breed() == 0x26
    }

    if (breed_name == "Happy Mask") {
        return is_primary_breed("Gali") && secondary_breed() == 0x26
    }

    if (breed_name == "Ninja Kato") {
        return is_primary_breed("Kato") && secondary_breed() == 0x26
    }

    if (breed_name == "Deluxe Liner") {
        return is_primary_breed("Zilla") && secondary_breed() == 0x26
    }

    if (breed_name == "Boxer Bajarl") {
        return is_primary_breed("Bajarl") && secondary_breed() == 0x26
    }

    if (breed_name == "Magic Bajarl") {
        return is_primary_breed("Bajarl") && secondary_breed() == 0x27
    }

    if (breed_name == "Ultrarl") {
        return is_primary_breed("Bajarl") && secondary_breed() == 0x28
    }
    
    if (breed_name == "Swimmer") {
        return is_primary_breed("Mew") && secondary_breed() == 0x26
    }

    if (breed_name == "Cinder Bird") {
        return is_primary_breed("Phoenix") && secondary_breed() == 0x26
    }
    
    if (breed_name == "Chef") {
        return is_primary_breed("Ghost") && secondary_breed() == 0x26
    }

    if (breed_name == "Chinois") {
        return is_primary_breed("Metalner") && secondary_breed() == 0x26
    }

    if (breed_name == "Gold Suezo") {
        return is_primary_breed("Suezo") && secondary_breed() == 0x26
    }

    if (breed_name == "Silver Suezo") {
        return is_primary_breed("Suezo") && secondary_breed() == 0x27
    }

    if (breed_name == "Bronze Suezo") {
        return is_primary_breed("Suezo") && secondary_breed() == 0x28
    }

    if (breed_name == "Birdie") {
        return is_primary_breed("Suezo") && secondary_breed() == 0x29
    }

    if (breed_name == "Pithecan") {
        return is_primary_breed("Jill") && secondary_breed() == 0x26
    }

    if (breed_name == "Caloriena") {
        return is_primary_breed("Mocchi") && secondary_breed() == 0x27
    }

    if (breed_name == "Mocchini") {
        return is_primary_breed("Mocchi") && secondary_breed() == 0x29
    }

    if (breed_name == "Bloodshed") {
        return is_primary_breed("Joker") && secondary_breed() == 0x26
    }

    if (breed_name == "GabooSoldier") {
        return is_primary_breed("Gaboo") && secondary_breed() == 0x26
    }

    if (breed_name == "Metal Jell") {
        return is_primary_breed("Jell") && secondary_breed() == 0x26
    }

    if (breed_name == "Mermaid") {
        return is_primary_breed("Undine") && secondary_breed() == 0x26
    }

    if (breed_name == "Dribbler") {
        return is_primary_breed("Niton") && secondary_breed() == 0x26
    }

    if (breed_name == "Radial Niton") {
        return is_primary_breed("Niton") && secondary_breed() == 0x27
    }

    if (breed_name == "Disc Niton") {
        return is_primary_breed("Niton") && secondary_breed() == 0x28
    }

    if (breed_name == "White Birch") {
        return is_primary_breed("Mock") && secondary_breed() == 0x26
    }

    if (breed_name == "Pole Mock") {
        return is_primary_breed("Mock") && secondary_breed() == 0x27
    }

    if (breed_name == "Watermelony") {
        return is_primary_breed("Ducken") && secondary_breed() == 0x26
    }

    if (breed_name == "Cawken") {
        return is_primary_breed("Ducken") && secondary_breed() == 0x27
    }

    if (breed_name == "Raggae Plant") {
        return is_primary_breed("Plant") && secondary_breed() == 0x26
    }

    if (breed_name == "Galaxy") {
        return is_primary_breed("Monol") && secondary_breed() == 0x26
    }

    if (breed_name == "Dominos") {
        return is_primary_breed("Monol") && secondary_breed() == 0x27
    }

    if (breed_name == "Scribble") {
        return is_primary_breed("Monol") && secondary_breed() == 0x28
    }

    if (breed_name == "Gold Dust") {
        return is_primary_breed("Ape") && secondary_breed() == 0x26
    }
    
    if (breed_name == "Express Worm") {
        return is_primary_breed("Worm") && secondary_breed() == 0x26
    }

    if (breed_name == "Time Noise") {
        return is_primary_breed("Naga") && secondary_breed() == 0x26
    }
}

// All of the unlock checks are to verify that the player can legitimately raise the monster
// i.e. that they did not use any save editor to pull in a monster they shouldn't have access to
// or that they didn't modify a monster in the lab to be of the breed they want
function monster_summonable(monster_breed) {
    return byte(0x99386 + breeds[monster_breed]) == 0x01
}

// for dragon: check that the tournament is on the calendar
function dragon_unlocked() => byte(0x099078) == 0x1c && monster_summonable("Dragon")
// for centaur: check that the flags around getting a spear have been hit
function centaur_unlocked() => byte(0x099359) == 0x00 && byte(0x09935a) == 0x00 && monster_summonable("Centaur")
// for beaclon, nothing really good except checking stat screen to make sure one's been raised
function beaclon_unlocked() => word(0x98fe6) > 0 && monster_summonable("Beaclon")
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function henger_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && monster_summonable("Henger")
// check that they got the doll and it moved on ranch
function wracky_unlocked() => byte(0x99350) == 0x00 && byte(0x99351) == 0x00 && monster_summonable("Wracky")
// check that stable is at least level 1
function golem_unlocked() => __ornext(byte(0x98fc2) == 0x01 || byte(0x98fc2) == 0x02) && monster_summonable("Golem")
// check that the durahan invitational is on calendar
function durahan_unlocked() => byte(0x99079) == 0x16 && byte(0x99338) == 0x00 && monster_summonable("Durahan")
// check that stable is at least level 1
function baku_unlocked() => __ornext(byte(0x98fc2) == 0x01 || byte(0x98fc2) == 0x02) && monster_summonable("Baku")
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function gali_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && monster_summonable("Gali")
// check that they've been told about what zilla beard do
function zilla_unlocked() => byte(0x099340) == 0x00 && byte(0x099341) == 0x00 && byte(0x099342) == 0x00 && monster_summonable("Zilla")
// check that binto forked the pot over
function bajarl_unlocked() => byte(0x99316) == 0x00 && monster_summonable("Bajarl")
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function mew_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && monster_summonable("Mew")
// there SHOULD be a flag for phoenix feather having been found, but I haven't needed it till now
// in lieu, check that they went to phoenix volcano (have gone on an expedition ever)
function phoenix_unlocked() => byte(0x9932c) == 0x00 && monster_summonable("Phoenix")
// check that pabs has yelled about the altar being a mess
function ghost_unlocked() => byte(0x9933d) == 0x00 && monster_summonable("Ghost")
// check that metalner has visited from afar
function metalner_unlocked() => byte(0x09935e) == 0x00 && byte(0x09935f) == 0x00 && byte(0x099360) == 0x00 && monster_summonable("Metalner")
// check that pabs put on the mask
function joker_unlocked() => byte(0x9934a) == 0x00 && monster_summonable("Joker")
// both undine and niton, check that the player's got a hot springs
function undine_unlocked() => byte(0x99356) == 0x00 && monster_summonable("Undine")
function niton_unlocked() => byte(0x99356) == 0x00 && monster_summonable("Niton")
// check that tree on ranch died
function mock_unlocked() => monster_summonable("Mock")
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function worm_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && monster_summonable("Worm")
// check that player's gotten at least one fun can and that they've got strong glue in inventory
// NOTE: strong glue cannot be sold, meaning that if it's gone and they have a ducken they cheated it out
function ducken_unlocked() => byte(0x99322) == 0x00 && monster_summonable("Ducken") && inventory_contains_glue()
// check that player has seen Bighand
function jill_unlocked() => byte(0x099344) == 0x00 && byte(0x09921d) == 0x01 && monster_summonable("Jill")

function m1_grand_prix_won() => dword(0x97a80) >= 0x01
function greatest_4_won() => dword(0x97a84) >= 0x01
function world_monsters_cup_won() => dword(0x97a88) >= 0x01
function winners_cup_won() => dword(0x97a8c) >= 0x01
function legend_cup() => byte(0x97a90)
function current_week() => byte(0x99235)
function current_month() => byte(0x99236)
function current_tournament() => byte(0x9961c)

// mostly helper info for now
monster_breeds = {
    0x00: "Pixie",
    0x01: "Dragon",
    0x02: "Centaur",
    0x03: "ColorPandora",
    0x04: "Beaclon",
    0x05: "Henger",
    0x06: "Wracky",
    0x07: "Golem",
    0x08: "Zuum",
    0x09: "Durahan",
    0x0a: "Arrow Head",
    0x0b: "Tiger",
    0x0c: "Hopper",
    0x0d: "Hare",
    0x0e: "Baku",
    0x0f: "Gali",
    0x10: "Kato",
    0x11: "Zilla",
    0x12: "Bajarl",
    0x13: "Mew",
    0x14: "Phoenix",
    0x15: "Ghost",
    0x16: "Metalner",
    0x17: "Suezo",
    0x18: "Jill",
    0x19: "Mocchi",
    0x1a: "Joker",
    0x1b: "Gaboo",
    0x1c: "Jell",
    0x1d: "Undine",
    0x1e: "Niton",
    0x1f: "Mock",
    0x20: "Ducken",
    0x21: "Plant",
    0x22: "Monol",
    0x23: "Ape",
    0x24: "Worm",
    0x25: "Naga",
    0x26: "???",
    0x27: "???",
    0x28: "???",
    0x29: "???",
    0x2a: "???",
    0x2b: "???"
}

// 0x98fc4 is the start of trainer data, "Number of X monster raised". 
function has_trained_breed(breed_name) => word(0x98fde + breeds[breed_name]*2) >= 1

function prereq_tournaments_won() => m1_grand_prix_won() && winners_cup_won() && greatest_4_won() && world_monsters_cup_won()
function correct_date() => current_month() == 0x04 && current_week() == 0x04
function prereqs_met() => prereq_tournaments_won() && correct_date() && __ornext(current_tournament() == 0x4e || current_tournament() == 0x4f) 

CURRENT_YEAR = word(0x99230)


// I'm going to denote these by breed then sub-breed. Keep my own life sane for structuring.
// Invoke this as CARD_ADDRESSES[primary_breed][secondary_breed] and you get the byte back that represents your card.
// If your secondary breed is ???, input the name of the breed and (Rare).
// i.e. the Mia variant of Pixie should be CARD_ADDRESSES["Pixie"]["Mia (Rare)"].
CARD_ADDRESSES = {
    "Pixie": {
        "Pixie": byte(0x9908c),
        "Dragon": byte(0x9908d),
        "Centaur": byte(0x9908e),
        "Wracky": byte(0x9908f),
        "Golem": byte(0x99090),
        "Zuum": byte(0x99091),
        "Durahan": byte(0x99092),
        "Tiger": byte(0x99093),
        "Hare": byte(0x99094),
        "Gali": byte(0x99095),
        "Kato": byte(0x99096),
        "Bajarl": byte(0x99097),
        "Metalner": byte(0x99098),
        "Vanity": byte(0x99099),
        "Jill": byte(0x9909a),
        "Joker": byte(0x9909b),
        "Jell": byte(0x9909c),
        "Mock": byte(0x9909d),
        "Plant": byte(0x9909e),
        "Monol": byte(0x9909f),
        "Worm": byte(0x990a0),
        "Naga": byte(0x990a1),
        "Poison (Rare)": byte(0x990a2),
        "Kasumi (Rare)": byte(0x990a3),
        "Mia (Rare)": byte(0x990a4)
    },
    "Dragon": {
        "Pixie": byte(0x990a5),
        "Dragon": byte(0x990a6),
        "Beaclon": byte(0x990a7),
        "Henger": byte(0x990a8),
        "Golem": byte(0x990a9),
        "Durahan": byte(0x990aa),
        "Arrow Head": byte(0x990ab),
        "Tiger": byte(0x990ac),
        "Gali": byte(0x990ad),
        "Kato": byte(0x990ae),
        "Bajarl": byte(0x990af),
        "Metalner": byte(0x990b0),
        "Joker": byte(0x990b1),
        "Monol": byte(0x990b2),
        "Moo (Rare)": byte(0x990b3)
    },
    "Centaur": {
        "Pixie": byte(0x990b4),
        "Dragon": byte(0x990b5),
        "Centaur": byte(0x990b6),
        "Golem": byte(0x990b7),
        "Durahan": byte(0x990b8),
        "Arrow Head": byte(0x990b9),
        "Tiger": byte(0x990ba),
        "Bajarl": byte(0x990bb),
        "Joker": byte(0x990bc),
        "Trotter (Rare)": byte(0x990bd),
        "Blue Thunder (Rare)": byte(0x990be)
    },
    "ColorPandora": {
        "Pixie": byte(0x990bf),
        "ColorPandora": byte(0x990c0),
        "Jell": byte(0x990c1),
        "Dice (Rare)": byte(0x990c2),
        "Tram (Rare)": byte(0x990c3),
    },
    "Beaclon": {
        "Dragon": byte(0x990c4),
        "Beaclon": byte(0x990c5),
        "Henger": byte(0x990c6),
        "Golem": byte(0x990c7),
        "Durahan": byte(0x990c8),
        "Tiger": byte(0x990c9),
        "Bajarl": byte(0x990ca),
        "Joker": byte(0x990cb),
        "Ducken": byte(0x990cc),
        "Eggplantern (Rare)": byte(0x990cd),
    },
    "Henger": {
        "Dragon": byte(0x990ce),
        "Henger": byte(0x990cf),
        "Golem": byte(0x990d0),
        "Zuum": byte(0x990d1),
        "Metalner": byte(0x990d2),
        "Joker": byte(0x990d3),
        "Mock": byte(0x990d4),
        "Monol": byte(0x990d5),
        "Skeleton (Rare)": byte(0x990d6)
    },
    "Wracky": {
        "Pixie": byte(0x990d7),
        "Dragon": byte(0x990d8),
        "Henger": byte(0x990d9),
        "Wracky": byte(0x990da),
        "Golem": byte(0x990db),
        "Durahan": byte(0x990dc),
        "Bajarl": byte(0x990dd),
        "Metalner": byte(0x990de),
        "Joker": byte(0x990df),
        "Mock": byte(0x990e0),
        "Satan Clause (Rare)": byte(0x990e1)
    },
    "Golem": {
        "Pixie": byte(0x990e2),
        "Dragon": byte(0x990e3),
        "Beaclon": byte(0x990e4),
        "Henger": byte(0x990e5),
        "Wracky": byte(0x990e6),
        "Golem": byte(0x990e7),
        "Zuum": byte(0x990e8),
        "Durahan": byte(0x990e9),
        "Arrow Head": byte(0x990ea),
        "Tiger": byte(0x990eb),
        "Hare": byte(0x990ec),
        "Baku": byte(0x990ed),
        "Gali": byte(0x990ee),
        "Zilla": byte(0x990ef),
        "Bajarl": byte(0x990f0),
        "Metalner": byte(0x990f1),
        "Suezo": byte(0x990f2),
        "Joker": byte(0x990f3),
        "Jell": byte(0x990f4),
        "Mock": byte(0x990f5),
        "Plant": byte(0x990f6),
        "Monol": byte(0x990f7),
        "Worm": byte(0x990f8),
        "Naga": byte(0x990f9),
        "ForwardGolem (Rare)": byte(0x990fa)
    },
    "Zuum": {
        "Pixie": byte(0x990fb),
        "Dragon": byte(0x990fc),
        "Golem": byte(0x990fd),
        "Zuum": byte(0x990fe),
        "Arrow Head": byte(0x990ff),
        "Tiger": byte(0x99100),
        "Hare": byte(0x99101),
        "Baku": byte(0x99102),
        "Gali": byte(0x99103),
        "Kato": byte(0x99104),
        "Bajarl": byte(0x99105),
        "Suezo": byte(0x99106),
        "Joker": byte(0x99107),
        "Jell": byte(0x99108),
        "Mock": byte(0x99109),
        "Plant": byte(0x9910a),
        "Monol": byte(0x9910b),
        "Worm": byte(0x9910c),
        "Naga": byte(0x9910d),
        "ZebraSaurian (Rare)": byte(0x9910e), 
    },
    "Durahan": {
        "Pixie": byte(0x9910f),
        "Dragon": byte(0x99110),
        "Beaclon": byte(0x99111),
        "Golem": byte(0x99112),
        "Durahan": byte(0x99113),
        "Arrow Head": byte(0x99114),
        "Tiger": byte(0x99115),
        "Phoenix": byte(0x99116),
        "Metalner": byte(0x99117),
        "Joker": byte(0x99118),
        "Mock": byte(0x99119),
        "Shogun (Rare)": byte(0x9911a),
        "Ruby Knight (Rare)": byte(0x9911b),
        "Kokushi Muso (Rare)": byte(0x9911c)
    },
    "Arrow Head": {
        "Henger": byte(0x9911d),
        "Golem": byte(0x9911e),
        "Durahan": byte(0x9911f),
        "Arrow Head": byte(0x99120),
        "Suezo": byte(0x99121),
        "Joker": byte(0x99122),
        "Mock": byte(0x99123),
        "Sumopion (Rare)": byte(0x99124)
    },
    "Tiger": {
        "Pixie": byte(0x99125),
        "Golem": byte(0x99126),
        "Zuum": byte(0x99127),
        "Tiger": byte(0x99128),
        "Hare": byte(0x99129),
        "Gali": byte(0x9912a),
        "Suezo": byte(0x9912b),
        "Jell": byte(0x9912c),
        "Plant": byte(0x9912d),
        "Monol": byte(0x9912e),
        "Worm": byte(0x9912f),
        "Naga": byte(0x99130),
        "White Hound (Rare)": byte(0x99131)
    },
    "Hopper": {
        "Pixie": byte(0x99132),
        "Dragon": byte(0x99133),
        "Tiger": byte(0x99134),
        "Hopper": byte(0x99135),
        "Kato": byte(0x99136),
        "Bajarl": byte(0x99137),
        "Metalner": byte(0x99138),
        "Suezo": byte(0x99139),
        "Jill": byte(0x9913a),
        "Mocchi": byte(0x9913b),
        "Joker": byte(0x9913c),
        "Mock": byte(0x9913d),
        "Frog Hopper (Rare)": byte(0x9913e)
    },
    "Hare": {
        "Pixie": byte(0x9913f),
        "Golem": byte(0x99140),
        "Zuum": byte(0x99141),
        "Tiger": byte(0x99142),
        "Hare": byte(0x99143),
        "Gali": byte(0x99144),
        "Suezo": byte(0x99145),
        "Jell": byte(0x99146),
        "Plant": byte(0x99147),
        "Monol": byte(0x99148),
        "Worm": byte(0x99149),
        "Naga": byte(0x9914a),
        "Kung Fu Hare (Rare)": byte(0x9914b),
    },
    "Baku": {
        "Dragon": byte(0x9914c),
        "Golem": byte(0x9914d),
        "Durahan": byte(0x9914e),
        "Tiger": byte(0x9914f),
        "Hare": byte(0x99150),
        "Baku": byte(0x99151),
        "Kato": byte(0x99152),
        "Joker": byte(0x99153),
        "Jell": byte(0x99154),
        "Shishi (Rare)": byte(0x99155)
    },
    "Gali": {
        "Pixie": byte(0x99156),
        "Golem": byte(0x99157),
        "Zuum": byte(0x99158),
        "Tiger": byte(0x99159),
        "Hare": byte(0x9915a),
        "Gali": byte(0x9915b),
        "Suezo": byte(0x9915c),
        "Jell": byte(0x9915d),
        "Plant": byte(0x9915e),
        "Monol": byte(0x9915f),
        "Worm": byte(0x99160),
        "Naga": byte(0x99161),
        "Happy Mask": byte(0x99162),
    },
    "Kato": {
        "Dragon": byte(0x99163),
        "Tiger": byte(0x99164),
        "Gali": byte(0x99165),
        "Kato": byte(0x99166),
        "Suezo": byte(0x99167),
        "Mocchi": byte(0x99168),
        "Joker": byte(0x99169),
        "Ninja Kato (Rare)": byte(0x9916a)
    },
    "Zilla": {
        "Pixie": byte(0x9916b),
        "Tiger": byte(0x9916c),
        "Zilla": byte(0x9916d),
        "Jell": byte(0x9916e),
        "Deluxe Liner (Rare)": byte(0x9916f)
    },
    "Bajarl": {
        "Bajarl": byte(0x99170),
        "Joker": byte(0x99171),
        "Boxer Bajarl (Rare)": byte(0x99172),
        "Magic Bajarl (Rare)": byte(0x99173),
        "Ultrarl (Rare)": byte(0x99174)
    },
    "Mew": {
        "Pixie": byte(0x99175),
        "Tiger": byte(0x99176),
        "Hare": byte(0x99177),
        "Mew": byte(0x99178),
        "Jell": byte(0x99179),
        "Swimmer (Rare)": byte(0x9917a)
    },
    "Phoenix": {
        "Phoenix": byte(0x9917b),
        "Cinder Bird (Rare)": byte(0x9917c)
    },
    "Ghost": {
        "Ghost": byte(0x9917d),
        "Chef (Rare)": byte(0x9917e)
    },
    "Metalner": {
        "Pixie": byte(0x9917f),
        "Metalner": byte(0x99180),
        "Suezo": byte(0x99181),
        "Chinois (Rare)": byte(0x99182),
    },
    "Suezo": {
        "Pixie": byte(0x99183),
        "Golem": byte(0x99184),
        "Zuum": byte(0x99185),
        "Tiger": byte(0x99186),
        "Hare": byte(0x99187),
        "Gali": byte(0x99188),
        "Suezo": byte(0x99189),
        "Jell": byte(0x9918a),
        "Plant": byte(0x9918b),
        "Monol": byte(0x9918c),
        "Worm": byte(0x9918d),
        "Naga": byte(0x9918e),
        "Gold Suezo (Rare)": byte(0x9918f),
        "Silver Suezo (Rare)": byte(0x99190),
        "Bronze Suezo (Rare)": byte(0x99191),
        "Birdie (Rare)": byte(0x99192),
        "Sueki Suezo (Rare)": byte(0x99193),
    },
    "Jill": {
        "Pixie": byte(0x99194),
        "Tiger": byte(0x99195),
        "Hare": byte(0x99196),
        "Kato": byte(0x99197),
        "Suezo": byte(0x99198),
        "Jill": byte(0x99199),
        "Joker": byte(0x9919a),
        "Pithecan (Rare)": byte(0x9919b),
    },
    "Mocchi": {
        "Pixie": byte(0x9919c),
        "Dragon": byte(0x9919d),
        "Durahan": byte(0x9919e),
        "Tiger": byte(0x9919f),
        "Kato": byte(0x991a0),
        "Mocchi": byte(0x991a1),
        "Joker": byte(0x991a2),
        "Jell": byte(0x991a3),
        "GentleMocchi (Rare)": byte(0x991a4),
        "Caloriena (Rare)": byte(0x991a5),
        "Mocchini (Rare)": byte(0x991a6)
    },
    "Joker": {
        "Pixie": byte(0x991a7),
        "Dragon": byte(0x991a8),
        "Golem": byte(0x991a9),
        "Tiger": byte(0x991aa),
        "Bajarl": byte(0x991ab),
        "Joker": byte(0x991ac),
        "Bloodshed (Rare)": byte(0x991ad)
    },
    "Gaboo": {
        "Tiger": byte(0x991ae),
        "Joker": byte(0x991af),
        "Gaboo": byte(0x991b0),
        "Jell": byte(0x991b1),
        "GabooSoldier (Rare)": byte(0x991b2),
    },
    "Jell": {
        "Pixie": byte(0x991b3),
        "Golem": byte(0x991b4),
        "Zuum": byte(0x991b5),
        "Tiger": byte(0x991b6),
        "Hare": byte(0x991b7),
        "Gali": byte(0x991b8),
        "Suezo": byte(0x991b9),
        "Jell": byte(0x991ba),
        "Plant": byte(0x991bb),
        "Monol": byte(0x991bc),
        "Worm": byte(0x991bd),
        "Naga": byte(0x991be),
        "Metal Jell (Rare)": byte(0x991bf)
    },
    "Undine": {
        "Joker": byte(0x991c0),
        "Undine": byte(0x991c1),
        "Mermaid (Rare)": byte(0x991c2)
    },
    "Niton": {
        "Golem": byte(0x991c3),
        "Durahan": byte(0x991c4),
        "Kato": byte(0x991c5),
        "Bajarl": byte(0x991c6),
        "Metalner": byte(0x991c7),
        "Jell": byte(0x991c8),
        "Niton": byte(0x991c9),
        "Mock": byte(0x991ca),
        "Dribbler (Rare)": byte(0x991cb),
        "Radial Niton (Rare)": byte(0x991cc),
        "Disc Niton (Rare)": byte(0x991cd),
    },
    "Mock": {
        "Joker": byte(0x991ce),
        "Mock": byte(0x991cf),
        "White Birch (Rare)": byte(0x991d0),
        "Pole Mock (Rare)": byte(0x991d1),
    },
    "Ducken": {
        "Golem": byte(0x991d2),
        "Suezo": byte(0x991d3),
        "Ducken": byte(0x991d4),
        "Watermelony (Rare)": byte(0x991d5),
        "Cawken (Rare)": byte(0x991d6),
    },
    "Plant": {
        "Pixie": byte(0x991d7),
        "Golem": byte(0x991d8),
        "Zuum": byte(0x991d9),
        "Tiger": byte(0x991da),
        "Hare": byte(0x991db),
        "Gali": byte(0x991dc),
        "Suezo": byte(0x991dd),
        "Jell": byte(0x991de),
        "Plant": byte(0x991df),
        "Monol": byte(0x991e0),
        "Worm": byte(0x991e1),
        "Naga": byte(0x991e2),
        "Raggae Plant (Rare)": byte(0x991e3)
    },
    "Monol": {
        "Pixie": byte(0x991e4),
        "Golem": byte(0x991e5),
        "Zuum": byte(0x991e6),
        "Tiger": byte(0x991e7),
        "Hare": byte(0x991e8),
        "Gali": byte(0x991e9),
        "Suezo": byte(0x991ea),
        "Jell": byte(0x991eb),
        "Plant": byte(0x991ec),
        "Monol": byte(0x991ed),
        "Worm": byte(0x991ee),
        "Naga": byte(0x991ef),
        "Galaxy (Rare)": byte(0x991f0),
        "Dominos (Rare)": byte(0x991f1),
        "Scribble (Rare)": byte(0x991f2),
    },
    "Ape": {
        "Golem": byte(0x991f3),
        "Hare": byte(0x991f4),
        "Gali": byte(0x991f5),
        "Plant": byte(0x991f6),
        "Ape": byte(0x991f7),
        "Gold Dust (Rare)": byte(0x991f8)
    },
    "Worm": {
        "Pixie": byte(0x991f9),
        "Golem": byte(0x991fa),
        "Zuum": byte(0x991fb),
        "Tiger": byte(0x991fc),
        "Hare": byte(0x991fd),
        "Gali": byte(0x991fe),
        "Suezo": byte(0x991ff),
        "Jell": byte(0x99200),
        "Plant": byte(0x99201),
        "Monol": byte(0x99202),
        "Worm": byte(0x99203),
        "Naga": byte(0x99204),
        "Express Worm (Rare)": byte(0x99205),
    },
    "Naga": {
        "Pixie": byte(0x99206),
        "Golem": byte(0x99207),
        "Zuum": byte(0x99208),
        "Tiger": byte(0x99209),
        "Hare": byte(0x9920a),
        "Gali": byte(0x9920b),
        "Suezo": byte(0x9920c),
        "Jell": byte(0x9920d),
        "Plant": byte(0x9920e),
        "Monol": byte(0x9920f),
        "Worm": byte(0x99210),
        "Naga": byte(0x99211),
        "Time Noise (Rare)": byte(0x99212)
    },
}

// Check if we've unlocked a specific card. This happens when you summon a monster legitimately.
function card_unlocked(primary, secondary) => CARD_ADDRESSES[primary][secondary] == 0x01

// I hate everything about this, but it's needed. Thanks, users who think they can be cute and just modify a monster in the lab repeatedly!
// Some checks will be able to check more than one card/one trainer stat due to unlock chains. Not all can though :(
function monster_trained(monster_name) {
    if (monster_name == "Pixie") { // pixies start here
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Pixie")
    } else if (monster_name == "Daina") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Dragon") && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")
    } else if (monster_name == "Unico") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Centaur") && has_trained_breed("Centaur") && card_unlocked("Centaur", "Centaur")
    } else if (monster_name == "Jilt") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Wracky") && has_trained_breed("Wracky") && card_unlocked("Wracky", "Wracky") 
    } else if (monster_name == "Granity") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Golem")
    } else if (monster_name == "Dixie") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Zuum")
    } else if (monster_name == "Janne") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Durahan") && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan") 
    } else if (monster_name == "Mint") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Tiger")
    } else if (monster_name == "Lepus") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Hare")
    } else if (monster_name == "Angel") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Gali")
    } else if (monster_name == "Kitten") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Kato")
    } else if (monster_name == "Jinnee") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Bajarl") && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")
    } else if (monster_name == "Futurity") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Metalner")
    } else if (monster_name == "Vanity") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Suezo")
    } else if (monster_name == "Snowy") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Jill") && has_trained_breed("Jill") && card_unlocked("Jill", "Jill") 
    } else if (monster_name == "Lilim") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Joker") && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")
    } else if (monster_name == "Nagisa") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Jell")
    } else if (monster_name == "Dryad") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Mock") && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")
    } else if (monster_name == "Serenity") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Plant")
    } else if (monster_name == "Silhouette") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Monol")
    } else if (monster_name == "Night Flyer") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Worm")
    } else if (monster_name == "Allure") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Naga")
    } else if (monster_name == "Poison") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Poison (Rare)")
    } else if (monster_name == "Kasumi") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Kasumi (Rare)")
    } else if (monster_name == "Mia") {
        return has_trained_breed("Pixie") && card_unlocked("Pixie", "Mia (Rare)")
    } else if (monster_name == "Tiamat") { // dragons start here
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Pixie")
    } else if (monster_name == "Dragon") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")
    } else if (monster_name == "Corkasus") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Beaclon") && has_trained_breed("Beaclon") && card_unlocked("Beaclon", "Beaclon")
    } else if (monster_name == "Tecno Dragon") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Henger")       
    } else if (monster_name == "Stone Dragon") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Golem")        
    } else if (monster_name == "Armor Dragon") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Durahan") && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")         
    } else if (monster_name == "Crab Dragon") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Arrow Head")        
    } else if (monster_name == "Hound Dragon") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Tiger")        
    } else if (monster_name == "Gariel") {
        return has_trained_breed("Dragon") && card_unlocked("Dragon", "Gali")        
    } else if (monster_name == "Oscerot") {
        return has_trained_breed("Dragon") && byte(0x990ae) == 0x01        
    } else if (monster_name == "Dodongo") {
        return has_trained_breed("Dragon") && byte(0x990af) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")
    } else if (monster_name == "Gidras") {
        return has_trained_breed("Dragon") && byte(0x990b0) == 0x01        
    } else if (monster_name == "Death Dragon") {
        return has_trained_breed("Dragon") && byte(0x990b1) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Ragnaroks") {
        return has_trained_breed("Dragon") && byte(0x990b2) == 0x01        
    } else if (monster_name == "Moo") {
        return has_trained_breed("Dragon") && byte(0x990b3) == 0x01        
    } else if (monster_name == "Ferious") { // centaurs start here
        return has_trained_breed("Centaur") && byte(0x990b4) == 0x01        
    } else if (monster_name == "Dragoon") {
        return has_trained_breed("Centaur") && byte(0x990b5) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")       
    } else if (monster_name == "Centaur") {
        return has_trained_breed("Centaur") && byte(0x990b6) == 0x01        
    } else if (monster_name == "Trojan") {
        return has_trained_breed("Centaur") && byte(0x990b7) == 0x01        
    } else if (monster_name == "Chariot") {
        return has_trained_breed("Centaur") && byte(0x990b8) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")         
    } else if (monster_name == "Antares") {
        return has_trained_breed("Centaur") && byte(0x990b9) == 0x01        
    } else if (monster_name == "Celious") {
        return has_trained_breed("Centaur") && byte(0x990ba) == 0x01        
    } else if (monster_name == "Bazoo") {
        return has_trained_breed("Centaur") && byte(0x990bb) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")
    } else if (monster_name == "Reaper") {
        return has_trained_breed("Centaur") && byte(0x990bc) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")            
    } else if (monster_name == "Trotter") {
        return has_trained_breed("Centaur") && byte(0x990bd) == 0x01        
    } else if (monster_name == "Blue Thunder") {
        return has_trained_breed("Centaur") && byte(0x990be) == 0x01        
    } else if (monster_name == "PeachTreeBug") { // ColorPandora starts here
        return has_trained_breed("ColorPandora") && byte(0x990bf) == 0x01        
    } else if (monster_name == "ColorPandora") {
        return has_trained_breed("ColorPandora") && byte(0x990c0) == 0x01        
    } else if (monster_name == "Liquid Cube") {
        return has_trained_breed("ColorPandora") && byte(0x990c1) == 0x01        
    } else if (monster_name == "Dice") {
        return has_trained_breed("ColorPandora") && byte(0x990c2) == 0x01        
    } else if (monster_name == "Tram") {
        return has_trained_breed("ColorPandora") && byte(0x990c3) == 0x01        
    } else if (monster_name == "Bethelgeus") { // Beaclon starts here
        return has_trained_breed("Beaclon") && byte(0x990c4) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")           
    } else if (monster_name == "Beaclon") {
        return has_trained_breed("Beaclon") && card_unlocked("Beaclon", "Beaclon")        
    } else if (monster_name == "Melcarba") {
        return has_trained_breed("Beaclon") && byte(0x990c6) == 0x01        
    } else if (monster_name == "Rocklon") {
        return has_trained_breed("Beaclon") && byte(0x990c7) == 0x01        
    } else if (monster_name == "Centurion") {
        return has_trained_breed("Beaclon") && byte(0x990c8) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")         
    } else if (monster_name == "Sloth Beetle") {
        return has_trained_breed("Beaclon") && byte(0x990c9) == 0x01        
    } else if (monster_name == "KautRoarKaut") {
        return has_trained_breed("Beaclon") && byte(0x990ca) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Jaggernaut") {
        return has_trained_breed("Beaclon") && byte(0x990cb) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Ducklon") {
        return has_trained_breed("Beaclon") && byte(0x990cc) == 0x01 && has_trained_breed("Ducken") && card_unlocked("Ducken", "Ducken")        
    } else if (monster_name == "Eggplantern") {
        return has_trained_breed("Beaclon") && byte(0x990cd) == 0x01        
    } else if (monster_name == "Garlant") { // Henger starts here
        return has_trained_breed("Henger") && byte(0x990ce) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")    
    } else if (monster_name == "Henger") {
        return has_trained_breed("Henger") && byte(0x990cf) == 0x01        
    } else if (monster_name == "Gaia") {
        return has_trained_breed("Henger") && byte(0x990d0) == 0x01        
    } else if (monster_name == "Omega") {
        return has_trained_breed("Henger") && byte(0x990d1) == 0x01        
    } else if (monster_name == "Heuy") {
        return has_trained_breed("Henger") && byte(0x990d2) == 0x01
    } else if (monster_name == "End Bringer") {
        return has_trained_breed("Henger") && byte(0x990d3) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")
    } else if (monster_name == "Automaton") {
        return has_trained_breed("Henger") && byte(0x990d4) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "Black Henger") {
        return has_trained_breed("Henger") && byte(0x990d5) == 0x01        
    } else if (monster_name == "Skeleton") {
        return has_trained_breed("Henger") && byte(0x990d6) == 0x01        
    } else if (monster_name == "Baby Doll") { // Wracky starts here
        return has_trained_breed("Wracky") && byte(0x990d7) == 0x01        
    } else if (monster_name == "Draco Doll") {
        return has_trained_breed("Wracky") && byte(0x990d8) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")         
    } else if (monster_name == "Henger Doll") {
        return has_trained_breed("Wracky") && byte(0x990d9) == 0x01
    } else if (monster_name == "Wracky") {
        return has_trained_breed("Wracky") && card_unlocked("Wracky", "Wracky")        
    } else if (monster_name == "Pebbly") {
        return has_trained_breed("Wracky") && byte(0x990db) == 0x01        
    } else if (monster_name == "Petit Knight") {
        return has_trained_breed("Wracky") && byte(0x990dc) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan") 
    } else if (monster_name == "Bakky") {
        return has_trained_breed("Wracky") && byte(0x990dd) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Metal Glay") {
        return has_trained_breed("Wracky") && byte(0x990de) == 0x01        
    } else if (monster_name == "Tricker") {
        return has_trained_breed("Wracky") && byte(0x990df) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")       
    } else if (monster_name == "Mocky") {
        return has_trained_breed("Wracky") && byte(0x990e0) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "Satan Clause") {
        return has_trained_breed("Wracky") && byte(0x990e1) == 0x01        
    } else if (monster_name == "Tyrant") { // Golem starts here
        return has_trained_breed("Golem") && byte(0x990e2) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")       
    } else if (monster_name == "Pink Golem") {
        return has_trained_breed("Golem") && byte(0x990e3) == 0x01        
    } else if (monster_name == "Strong Horn") {
        return has_trained_breed("Golem") && byte(0x990e4) == 0x01 && has_trained_breed("Beaclon") && card_unlocked("Beaclon", "Beaclon")
    } else if (monster_name == "Gobi") {
        return has_trained_breed("Golem") && byte(0x990e5) == 0x01        
    } else if (monster_name == "Mariomax") {
        return has_trained_breed("Golem") && byte(0x990e6) == 0x01 && has_trained_breed("Wracky") && card_unlocked("Wracky", "Wracky") 
    } else if (monster_name == "Golem") {
        return has_trained_breed("Golem") && byte(0x990e7) == 0x01        
    } else if (monster_name == "Scaled Golem") {
        return has_trained_breed("Golem") && byte(0x990e8) == 0x01        
    } else if (monster_name == "Battle Rocks") {
        return has_trained_breed("Golem") && byte(0x990e9) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")        
    } else if (monster_name == "Dagon") {
        return has_trained_breed("Golem") && byte(0x990ea) == 0x01        
    } else if (monster_name == "Big Blue") {
        return has_trained_breed("Golem") && byte(0x990eb) == 0x01        
    } else if (monster_name == "Moaigon") {
        return has_trained_breed("Golem") && byte(0x990ec) == 0x01        
    } else if (monster_name == "Sleepyhead") {
        return has_trained_breed("Golem") && byte(0x990ed) == 0x01        
    } else if (monster_name == "Amenhotep") {
        return has_trained_breed("Golem") && byte(0x990ee) == 0x01        
    } else if (monster_name == "Pressure") {
        return has_trained_breed("Golem") && byte(0x990ef) == 0x01 && has_trained_breed("Zilla") && card_unlocked("Zilla", "Zilla")        
    } else if (monster_name == "Dao") {
        return has_trained_breed("Golem") && byte(0x990f0) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Astro") {
        return has_trained_breed("Golem") && byte(0x990f1) == 0x01       
    } else if (monster_name == "Titan") {
        return has_trained_breed("Golem") && byte(0x990f2) == 0x01        
    } else if (monster_name == "Angolmor") {
        return has_trained_breed("Golem") && byte(0x990f3) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Poseidon") {
        return has_trained_breed("Golem") && byte(0x990f4) == 0x01        
    } else if (monster_name == "Wood Golem") {
        return has_trained_breed("Golem") && byte(0x990f5) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "Ecologuardia") {
        return has_trained_breed("Golem") && byte(0x990f6) == 0x01        
    } else if (monster_name == "Black Golem") {
        return has_trained_breed("Golem") && byte(0x990f7) == 0x01        
    } else if (monster_name == "Magna") {
        return has_trained_breed("Golem") && byte(0x990f8) == 0x01        
    } else if (monster_name == "Marble Guy") {
        return has_trained_breed("Golem") && byte(0x990f9) == 0x01        
    } else if (monster_name == "ForwardGolem") {
        return has_trained_breed("Golem") && byte(0x990fa) == 0x01        
    } else if (monster_name == "FairySaurian") { // Zuum starts here
        return has_trained_breed("Zuum") && byte(0x990fb) == 0x01        
    } else if (monster_name == "Salamander") {
        return has_trained_breed("Zuum") && byte(0x990fc) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")       
    } else if (monster_name == "Rock Saurian") {
        return has_trained_breed("Zuum") && byte(0x990fd) == 0x01        
    } else if (monster_name == "Zuum") {
        return has_trained_breed("Zuum") && byte(0x990fe) == 0x01        
    } else if (monster_name == "Crab Saurian") {
        return has_trained_breed("Zuum") && byte(0x990ff) == 0x01        
    } else if (monster_name == "HoundSaurian") {
        return has_trained_breed("Zuum") && byte(0x99100) == 0x01        
    } else if (monster_name == "Spot Saurian") {
        return has_trained_breed("Zuum") && byte(0x99101) == 0x01        
    } else if (monster_name == "Hachiro") {
        return has_trained_breed("Zuum") && byte(0x99102) == 0x01        
    } else if (monster_name == "NobleSaurian") {
        return has_trained_breed("Zuum") && byte(0x99103) == 0x01        
    } else if (monster_name == "Tasman") {
        return has_trained_breed("Zuum") && byte(0x99104) == 0x01        
    } else if (monster_name == "Sand Saurian") {
        return has_trained_breed("Zuum") && byte(0x99105) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Mustardy") {
        return has_trained_breed("Zuum") && byte(0x99106) == 0x01        
    } else if (monster_name == "Basilisk") {
        return has_trained_breed("Zuum") && byte(0x99107) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "JellySaurian") {
        return has_trained_breed("Zuum") && byte(0x99108) == 0x01        
    } else if (monster_name == "Wood Saurian") {
        return has_trained_breed("Zuum") && byte(0x99109) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "AlohaSaurian") {
        return has_trained_breed("Zuum") && byte(0x9910a) == 0x01        
    } else if (monster_name == "BlackSaurian") {
        return has_trained_breed("Zuum") && byte(0x9910b) == 0x01        
    } else if (monster_name == "ShellSaurian") {
        return has_trained_breed("Zuum") && byte(0x9910c) == 0x01        
    } else if (monster_name == "Naga Saurian") {
        return has_trained_breed("Zuum") && byte(0x9910d) == 0x01        
    } else if (monster_name == "ZebraSaurian") {
        return has_trained_breed("Zuum") && byte(0x9910e) == 0x01        
    } else if (monster_name == "Leziena") { // Durahan starts here
        return has_trained_breed("Durahan") && byte(0x9910f) == 0x01        
    } else if (monster_name == "Vesuvius") {
        return has_trained_breed("Durahan") && byte(0x99110) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")       
    } else if (monster_name == "Hercules") {
        return has_trained_breed("Durahan") && byte(0x99111) == 0x01 && has_trained_breed("Beaclon") && card_unlocked("Beaclon", "Beaclon")       
    } else if (monster_name == "Kelmadics") {
        return has_trained_breed("Durahan") && byte(0x99112) == 0x01        
    } else if (monster_name == "Durahan") {
        return has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")        
    } else if (monster_name == "Lorica") {
        return has_trained_breed("Durahan") && byte(0x99114) == 0x01        
    } else if (monster_name == "Hound Knight") {
        return has_trained_breed("Durahan") && byte(0x99115) == 0x01        
    } else if (monster_name == "Garuda") {
        return has_trained_breed("Durahan") && byte(0x99116) == 0x01 && has_trained_breed("Phoenix") && card_unlocked("Phoenix", "Phoenix")        
    } else if (monster_name == "Metal Glory") {
        return has_trained_breed("Durahan") && byte(0x99117) == 0x01        
    } else if (monster_name == "Genocider") {
        return has_trained_breed("Durahan") && byte(0x99118) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Wood Knight") {
        return has_trained_breed("Durahan") && byte(0x99119) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "Shogun") {
        return has_trained_breed("Durahan") && byte(0x9911a) == 0x01        
    } else if (monster_name == "Ruby Knight") {
        return has_trained_breed("Durahan") && byte(0x9911b) == 0x01        
    } else if (monster_name == "Kokushi Muso") {
        return has_trained_breed("Durahan") && byte(0x9911c) == 0x01        
    } else if (monster_name == "Renocraft") { // Arrow Head starts here
        return has_trained_breed("Arrow Head") && byte(0x9911d) == 0x01        
    } else if (monster_name == "Priarocks") {
        return has_trained_breed("Arrow Head") && byte(0x9911e) == 0x01        
    } else if (monster_name == "Plated Arrow") {
        return has_trained_breed("Arrow Head") && byte(0x9911f) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")        
    } else if (monster_name == "Arrow Head") {
        return has_trained_breed("Arrow Head") && byte(0x99120) == 0x01        
    } else if (monster_name == "MustardArrow") {
        return has_trained_breed("Arrow Head") && byte(0x99121) == 0x01        
    } else if (monster_name == "Selketo") {
        return has_trained_breed("Arrow Head") && byte(0x99122) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Log Sawer") {
        return has_trained_breed("Arrow Head") && byte(0x99123) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "Sumopion") {
        return has_trained_breed("Arrow Head") && byte(0x99124) == 0x01        
    } else if (monster_name == "Daton") { // Tiger starts here
        return has_trained_breed("Tiger") && byte(0x99125) == 0x01        
    } else if (monster_name == "Rock Hound") {
        return has_trained_breed("Tiger") && byte(0x99126) == 0x01        
    } else if (monster_name == "Datonare") {
        return has_trained_breed("Tiger") && byte(0x99127) == 0x01        
    } else if (monster_name == "Tiger") {
        return has_trained_breed("Tiger") && byte(0x99128) == 0x01        
    } else if (monster_name == "Hare Hound") {
        return has_trained_breed("Tiger") && byte(0x99129) == 0x01        
    } else if (monster_name == "Balon") {
        return has_trained_breed("Tiger") && byte(0x9912a) == 0x01        
    } else if (monster_name == "Mono Eyed") {
        return has_trained_breed("Tiger") && byte(0x9912b) == 0x01        
    } else if (monster_name == "Jelly Hound") {
        return has_trained_breed("Tiger") && byte(0x9912c) == 0x01        
    } else if (monster_name == "Tropical Dog") {
        return has_trained_breed("Tiger") && byte(0x9912d) == 0x01        
    } else if (monster_name == "Terror Dog") {
        return has_trained_breed("Tiger") && byte(0x9912e) == 0x01        
    } else if (monster_name == "Jagd Hound") {
        return has_trained_breed("Tiger") && byte(0x9912f) == 0x01        
    } else if (monster_name == "Cabalos") {
        return has_trained_breed("Tiger") && byte(0x99130) == 0x01        
    } else if (monster_name == "White Hound") {
        return has_trained_breed("Tiger") && byte(0x99131) == 0x01        
    } else if (monster_name == "Fairy Hopper") { // Hopper starts here
        return has_trained_breed("Hopper") && byte(0x99132) == 0x01        
    } else if (monster_name == "Draco Hopper") {
        return has_trained_breed("Hopper") && byte(0x99133) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")      
    } else if (monster_name == "Skipper") {
        return has_trained_breed("Hopper") && byte(0x99134) == 0x01        
    } else if (monster_name == "Hopper") {
        return has_trained_breed("Hopper") && byte(0x99135) == 0x01        
    } else if (monster_name == "Mustachios") {
        return has_trained_breed("Hopper") && byte(0x99136) == 0x01        
    } else if (monster_name == "Emerald Eye") {
        return has_trained_breed("Hopper") && byte(0x99137) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Springer") {
        return has_trained_breed("Hopper") && byte(0x99138) == 0x01        
    } else if (monster_name == "Rear Eyed") {
        return has_trained_breed("Hopper") && byte(0x99139) == 0x01        
    } else if (monster_name == "Snow Hopper") {
        return has_trained_breed("Hopper") && byte(0x9913a) == 0x01 && has_trained_breed("Jill") && card_unlocked("Jill", "Jill")         
    } else if (monster_name == "Pink Hopper") {
        return has_trained_breed("Hopper") && byte(0x9913b) == 0x01     
    } else if (monster_name == "Sneak Hopper") {
        return has_trained_breed("Hopper") && byte(0x9913c) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Woody Hopper") {
        return has_trained_breed("Hopper") && byte(0x9913d) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "Frog Hopper") {
        return has_trained_breed("Hopper") && byte(0x9913e) == 0x01        
    } else if (monster_name == "Fairy Hare") { // Hare starts here
        return has_trained_breed("Hare") && byte(0x9913f) == 0x01        
    } else if (monster_name == "Rocky Fur") {
        return has_trained_breed("Hare") && byte(0x99140) == 0x01        
    } else if (monster_name == "Scaled Hare") {
        return has_trained_breed("Hare") && byte(0x99141) == 0x01        
    } else if (monster_name == "Blue Hare") {
        return has_trained_breed("Hare") && byte(0x99142) == 0x01        
    } else if (monster_name == "Hare") {
        return has_trained_breed("Hare") && byte(0x99143) == 0x01        
    } else if (monster_name == "Prince Hare") {
        return has_trained_breed("Hare") && byte(0x99144) == 0x01        
    } else if (monster_name == "Four Eyed") {
        return has_trained_breed("Hare") && byte(0x99145) == 0x01        
    } else if (monster_name == "Jelly Hare") {
        return has_trained_breed("Hare") && byte(0x99146) == 0x01        
    } else if (monster_name == "Leaf Hare") {
        return has_trained_breed("Hare") && byte(0x99147) == 0x01        
    } else if (monster_name == "Evil Hare") {
        return has_trained_breed("Hare") && byte(0x99148) == 0x01        
    } else if (monster_name == "Wild Hare") {
        return has_trained_breed("Hare") && byte(0x99149) == 0x01        
    } else if (monster_name == "Purple Hare") {
        return has_trained_breed("Hare") && byte(0x9914a) == 0x01        
    } else if (monster_name == "KungFuHare") {
        return has_trained_breed("Hare") && byte(0x9914b) == 0x01        
    } else if (monster_name == "Magmax") { // Baku starts here
        return has_trained_breed("Baku") && byte(0x9914c) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")       
    } else if (monster_name == "Higante") {
        return has_trained_breed("Baku") && byte(0x9914d) == 0x01       
    } else if (monster_name == "War Baku") {
        return has_trained_breed("Baku") && byte(0x9914e) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")        
    } else if (monster_name == "Icebergy") {
        return has_trained_breed("Baku") && byte(0x9914f) == 0x01        
    } else if (monster_name == "Gontar") {
        return has_trained_breed("Baku") && byte(0x99150) == 0x01        
    } else if (monster_name == "Baku") {
        return has_trained_breed("Baku") && byte(0x99151) == 0x01        
    } else if (monster_name == "Nussie") {
        return has_trained_breed("Baku") && byte(0x99152) == 0x01        
    } else if (monster_name == "Baku Clown") {
        return has_trained_breed("Baku") && byte(0x99153) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Giga Pint") {
        return has_trained_breed("Baku") && byte(0x99154) == 0x01        
    } else if (monster_name == "ShiShi") {
        return has_trained_breed("Baku") && byte(0x99155) == 0x01        
    } else if (monster_name == "Pink Mask") { // Gali starts here
        return has_trained_breed("Gali") && byte(0x99156) == 0x01        
    } else if (monster_name == "Stone Mask") {
        return has_trained_breed("Gali") && byte(0x99157) == 0x01        
    } else if (monster_name == "Scaled Mask") {
        return has_trained_breed("Gali") && byte(0x99158) == 0x01        
    } else if (monster_name == "Fanged Mask") {
        return has_trained_breed("Gali") && byte(0x99159) == 0x01        
    } else if (monster_name == "Furred Mask") {
        return has_trained_breed("Gali") && byte(0x9915a) == 0x01        
    } else if (monster_name == "Gali") {
        return has_trained_breed("Gali") && byte(0x9915b) == 0x01        
    } else if (monster_name == "Suezo Mask") {
        return has_trained_breed("Gali") && byte(0x9915c) == 0x01        
    } else if (monster_name == "Aqua Mask") {
        return has_trained_breed("Gali") && byte(0x9915d) == 0x01        
    } else if (monster_name == "Colorful") {
        return has_trained_breed("Gali") && byte(0x9915e) == 0x01        
    } else if (monster_name == "Galirous") {
        return has_trained_breed("Gali") && byte(0x9915f) == 0x01        
    } else if (monster_name == "Brown Mask") {
        return has_trained_breed("Gali") && byte(0x99160) == 0x01        
    } else if (monster_name == "Purple Mask") {
        return has_trained_breed("Gali") && byte(0x99161) == 0x01        
    } else if (monster_name == "Happy Mask") {
        return has_trained_breed("Gali") && byte(0x99162) == 0x01        
    } else if (monster_name == "Draco Kato") { // Kato starts here
        return has_trained_breed("Kato") && byte(0x99163) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")        
    } else if (monster_name == "Blue Kato") {
        return has_trained_breed("Kato") && byte(0x99164) == 0x01        
    } else if (monster_name == "Gordish") {
        return has_trained_breed("Kato") && byte(0x99165) == 0x01        
    } else if (monster_name == "Kato") {
        return has_trained_breed("Kato") && byte(0x99166) == 0x01        
    } else if (monster_name == "Citronie") {
        return has_trained_breed("Kato") && byte(0x99167) == 0x01        
    } else if (monster_name == "Pink Kato") {
        return has_trained_breed("Kato") && byte(0x99168) == 0x01        
    } else if (monster_name == "Tainted Cat") {
        return has_trained_breed("Kato") && byte(0x99169) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Ninja Kato") {
        return has_trained_breed("Kato") && byte(0x9916a) == 0x01        
    } else if (monster_name == "Pink Zilla") { // Zilla starts here
        return has_trained_breed("Zilla") && byte(0x9916b) == 0x01        
    } else if (monster_name == "Gooji") {
        return has_trained_breed("Zilla") && byte(0x9916c) == 0x01        
    } else if (monster_name == "Zilla") {
        return has_trained_breed("Zilla") && card_unlocked("Zilla", "Zilla")        
    } else if (monster_name == "Gigalon") {
        return has_trained_breed("Zilla") && byte(0x9916e) == 0x01        
    } else if (monster_name == "Deluxe Liner") {
        return has_trained_breed("Zilla") && byte(0x9916f) == 0x01        
    } else if (monster_name == "Bajarl") { // Bajarl starts here
        return has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Jaba") {
        return has_trained_breed("Bajarl") && byte(0x99171) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Boxer Bajarl") {
        return has_trained_breed("Bajarl") && byte(0x99172) == 0x01        
    } else if (monster_name == "Magic Bajarl") {
        return has_trained_breed("Bajarl") && byte(0x99173) == 0x01        
    } else if (monster_name == "Ultrarl") {
        return has_trained_breed("Bajarl") && byte(0x99174) == 0x01        
    } else if (monster_name == "Mum Mew") { // Mew starts here
        return has_trained_breed("Mew") && byte(0x99175) == 0x01        
    } else if (monster_name == "Bowwow") {
        return has_trained_breed("Mew") && byte(0x99176) == 0x01        
    } else if (monster_name == "Eared Mew") {
        return has_trained_breed("Mew") && byte(0x99177) == 0x01        
    } else if (monster_name == "Mew") {
        return has_trained_breed("Mew") && byte(0x99178) == 0x01        
    } else if (monster_name == "Aqua Mew") {
        return has_trained_breed("Mew") && byte(0x99179) == 0x01        
    } else if (monster_name == "Swimmer") {
        return has_trained_breed("Mew") && byte(0x9917a) == 0x01        
    } else if (monster_name == "Phoenix") { // Phoenix starts here
        return has_trained_breed("Phoenix") && card_unlocked("Phoenix", "Phoenix")        
    } else if (monster_name == "Cinder Bird") {
        return has_trained_breed("Phoenix") && byte(0x9917c) == 0x01        
    } else if (monster_name == "Ghost") { // Ghost starts here
        return has_trained_breed("Ghost") && byte(0x9917d) == 0x01        
    } else if (monster_name == "Chef") {
        return has_trained_breed("Ghost") && byte(0x9917e) == 0x01        
    } else if (monster_name == "Love Seeker") { // Metalner
        return has_trained_breed("Metalner") && byte(0x9917f) == 0x01        
    } else if (monster_name == "Metalner") {
        return has_trained_breed("Metalner") && byte(0x99180) == 0x01        
    } else if (monster_name == "Metazorl") {
        return has_trained_breed("Metalner") && byte(0x99181) == 0x01        
    } else if (monster_name == "Chinois") {
        return has_trained_breed("Metalner") && byte(0x99182) == 0x01        
    } else if (monster_name == "Pink Eye") { // Suezo starts here
        return has_trained_breed("Suezo") && byte(0x99183) == 0x01        
    } else if (monster_name == "Rocky Suezo") {
        return has_trained_breed("Suezo") && byte(0x99184) == 0x01        
    } else if (monster_name == "Melon Suezo") {
        return has_trained_breed("Suezo") && byte(0x99185) == 0x01        
    } else if (monster_name == "Horn") {
        return has_trained_breed("Suezo") && byte(0x99186) == 0x01        
    } else if (monster_name == "Furred Suezo") {
        return has_trained_breed("Suezo") && byte(0x99187) == 0x01        
    } else if (monster_name == "Orion") {
        return has_trained_breed("Suezo") && byte(0x99188) == 0x01        
    } else if (monster_name == "Suezo") {
        return has_trained_breed("Suezo") && byte(0x99189) == 0x01        
    } else if (monster_name == "Clear Suezo") {
        return has_trained_breed("Suezo") && byte(0x9918a) == 0x01        
    } else if (monster_name == "Green Suezo") {
        return has_trained_breed("Suezo") && byte(0x9918b) == 0x01        
    } else if (monster_name == "Red Eye") {
        return has_trained_breed("Suezo") && byte(0x9918c) == 0x01        
    } else if (monster_name == "Fly Eye") {
        return has_trained_breed("Suezo") && byte(0x9918d) == 0x01        
    } else if (monster_name == "Purple Suezo") {
        return has_trained_breed("Suezo") && byte(0x9918e) == 0x01        
    } else if (monster_name == "Gold Suezo") {
        // This case is unique because it's Silver Suezo + Bronze Suezo
        return has_trained_breed("Suezo") && card_unlocked("Suezo", "Gold Suezo (Rare)") && card_unlocked("Suezo", "Silver Suezo (Rare)") && card_unlocked("Suezo", "Bronze Suezo (Rare)")       
    } else if (monster_name == "Silver Suezo") {
        return has_trained_breed("Suezo") && card_unlocked("Suezo", "Silver Suezo (Rare)")        
    } else if (monster_name == "Bronze Suezo") {
        return has_trained_breed("Suezo") && card_unlocked("Suezo", "Bronze Suezo (Rare)")        
    } else if (monster_name == "Birdie") {
        return has_trained_breed("Suezo") && card_unlocked("Suezo", "Birdie (Rare)")        
    } else if (monster_name == "Sueki Suezo") {
        // This is to fill in the gap for cards, but this case should NEVER be hit
        return has_trained_breed("Suezo") && card_unlocked("Suezo", "Sueki Suezo (Rare)")        
    } else if (monster_name == "Pong Pong") { // Jill starts here
        return has_trained_breed("Jill") && byte(0x99194) == 0x01        
    } else if (monster_name == "Pierry") {
        return has_trained_breed("Jill") && byte(0x99195) == 0x01        
    } else if (monster_name == "Wondar") {
        return has_trained_breed("Jill") && byte(0x99196) == 0x01        
    } else if (monster_name == "Bengal") {
        return has_trained_breed("Jill") && byte(0x99197) == 0x01        
    } else if (monster_name == "Zorjil") {
        return has_trained_breed("Jill") && byte(0x99198) == 0x01        
    } else if (monster_name == "Jill") {
        return has_trained_breed("Jill") && card_unlocked("Jill", "Jill")        
    } else if (monster_name == "Skull Capped") {
        return has_trained_breed("Jill") && byte(0x9919a) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")
    } else if (monster_name == "Pithecan") {
        return has_trained_breed("Jill") && byte(0x9919b) == 0x01        
    } else if (monster_name == "Manna") { // Mocchi starts here
        return has_trained_breed("Mocchi") && byte(0x9919c) == 0x01        
    } else if (monster_name == "Draco Mocchi") {
        return has_trained_breed("Mocchi") && byte(0x9919d) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")        
    } else if (monster_name == "KnightMocchi") {
        return has_trained_breed("Mocchi") && byte(0x9919e) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")        
    } else if (monster_name == "Fake Penguin") {
        return has_trained_breed("Mocchi") && byte(0x9919f) == 0x01        
    } else if (monster_name == "Nyankoro") {
        return has_trained_breed("Mocchi") && byte(0x991a0) == 0x01        
    } else if (monster_name == "Mocchi") {
        return has_trained_breed("Mocchi") && byte(0x991a1) == 0x01        
    } else if (monster_name == "Hell Pierrot") {
        return has_trained_breed("Mocchi") && byte(0x991a2) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Gelatine") {
        return has_trained_breed("Mocchi") && byte(0x991a3) == 0x01        
    } else if (monster_name == "GentleMocchi") {
        return has_trained_breed("Mocchi") && byte(0x991a4) == 0x01        
    } else if (monster_name == "Caloriena") {
        return has_trained_breed("Mocchi") && byte(0x991a5) == 0x01        
    } else if (monster_name == "Mocchini") {
        return has_trained_breed("Mocchi") && byte(0x991a6) == 0x01        
    } else if (monster_name == "Hell Heart") { // Joker starts here
        return has_trained_breed("Joker") && byte(0x991a7) == 0x01        
    } else if (monster_name == "Flare Death") {
        return has_trained_breed("Joker") && byte(0x991a8) == 0x01 && has_trained_breed("Dragon") && card_unlocked("Dragon", "Dragon")        
    } else if (monster_name == "Tombstone") {
        return has_trained_breed("Joker") && byte(0x991a9) == 0x01        
    } else if (monster_name == "Blue Terror") {
        return has_trained_breed("Joker") && byte(0x991aa) == 0x01        
    } else if (monster_name == "Odium") {
        return has_trained_breed("Joker") && byte(0x991ab) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Joker") {
        return has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Bloodshed") {
        return has_trained_breed("Joker") && byte(0x991ad) == 0x01        
    } else if (monster_name == "Frozen Gaboo") { // Gaboo starts here
        return has_trained_breed("Gaboo") && byte(0x991ae) == 0x01        
    } else if (monster_name == "Dokoo") {
        return has_trained_breed("Gaboo") && byte(0x991af) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Gaboo") {
        return has_trained_breed("Gaboo") && byte(0x991b0) == 0x01        
    } else if (monster_name == "Jelly Gaboo") {
        return has_trained_breed("Gaboo") && byte(0x991b1) == 0x01        
    } else if (monster_name == "GabooSoldier") {
        return has_trained_breed("Gaboo") && byte(0x991b2) == 0x01        
    } else if (monster_name == "Pink Jam") { // Jell starts here
        return has_trained_breed("Jell") && byte(0x991b3) == 0x01        
    } else if (monster_name == "Wall Mimic") {
        return has_trained_breed("Jell") && byte(0x991b4) == 0x01        
    } else if (monster_name == "Scaled Jell") {
        return has_trained_breed("Jell") && byte(0x991b5) == 0x01        
    } else if (monster_name == "Icy Jell") {
        return has_trained_breed("Jell") && byte(0x991b6) == 0x01        
    } else if (monster_name == "Muddy Jell") {
        return has_trained_breed("Jell") && byte(0x991b7) == 0x01        
    } else if (monster_name == "Noble Jell") {
        return has_trained_breed("Jell") && byte(0x991b8) == 0x01        
    } else if (monster_name == "Eye Jell") {
        return has_trained_breed("Jell") && byte(0x991b9) == 0x01        
    } else if (monster_name == "Jell") {
        return has_trained_breed("Jell") && byte(0x991ba) == 0x01        
    } else if (monster_name == "Chloro Jell") {
        return has_trained_breed("Jell") && byte(0x991bb) == 0x01        
    } else if (monster_name == "Clay") {
        return has_trained_breed("Jell") && byte(0x991bc) == 0x01        
    } else if (monster_name == "Worm Jell") {
        return has_trained_breed("Jell") && byte(0x991bd) == 0x01        
    } else if (monster_name == "Purple Jell") {
        return has_trained_breed("Jell") && byte(0x991be) == 0x01        
    } else if (monster_name == "Metal Jell") {
        return has_trained_breed("Jell") && byte(0x991bf) == 0x01        
    } else if (monster_name == "Siren") { // Undine starts here
        return has_trained_breed("Undine") && byte(0x991c0) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Undine") {
        return has_trained_breed("Undine") && byte(0x991c1) == 0x01        
    } else if (monster_name == "Mermaid") {
        return has_trained_breed("Undine") && byte(0x991c2) == 0x01        
    } else if (monster_name == "Ammon") { // Niton starts here
        return has_trained_breed("Niton") && byte(0x991c3) == 0x01        
    } else if (monster_name == "Knight Niton") {
        return has_trained_breed("Niton") && byte(0x991c4) == 0x01 && has_trained_breed("Durahan") && card_unlocked("Durahan", "Durahan")        
    } else if (monster_name == "Stripe Shell") {
        return has_trained_breed("Niton") && byte(0x991c5) == 0x01        
    } else if (monster_name == "Alabia Niton") {
        return has_trained_breed("Niton") && byte(0x991c6) == 0x01 && has_trained_breed("Bajarl") && card_unlocked("Bajarl", "Bajarl")        
    } else if (monster_name == "Metal Shell") {
        return has_trained_breed("Niton") && byte(0x991c7) == 0x01       
    } else if (monster_name == "Clear Shell") {
        return has_trained_breed("Niton") && byte(0x991c8) == 0x01        
    } else if (monster_name == "Niton") {
        return has_trained_breed("Niton") && byte(0x991c9) == 0x01        
    } else if (monster_name == "Baum Kuchen") {
        return has_trained_breed("Niton") && byte(0x991ca) == 0x01 && has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "Dribbler") {
        return has_trained_breed("Niton") && byte(0x991cb) == 0x01        
    } else if (monster_name == "Radial Niton") {
        return has_trained_breed("Niton") && byte(0x991cc) == 0x01        
    } else if (monster_name == "Disc Niton") {
        return has_trained_breed("Niton") && byte(0x991cd) == 0x01        
    } else if (monster_name == "Ebony") { // Mock starts here
        return has_trained_breed("Mock") && byte(0x991ce) == 0x01 && has_trained_breed("Joker") && card_unlocked("Joker", "Joker")        
    } else if (monster_name == "Mock") {
        return has_trained_breed("Mock") && card_unlocked("Mock", "Mock")        
    } else if (monster_name == "White Birch") {
        return has_trained_breed("Mock") && byte(0x991d0) == 0x01        
    } else if (monster_name == "Pole Mock") {
        return has_trained_breed("Mock") && byte(0x991d1) == 0x01        
    } else if (monster_name == "Blocken") {
        return has_trained_breed("Ducken") && byte(0x991d2) == 0x01        
    } else if (monster_name == "Ticken") {
        return has_trained_breed("Ducken") && byte(0x991d3) == 0x01        
    } else if (monster_name == "Ducken") {
        return has_trained_breed("Ducken") && card_unlocked("Ducken", "Ducken")        
    } else if (monster_name == "Watermelony") {
        return has_trained_breed("Ducken") && byte(0x991d5) == 0x01        
    } else if (monster_name == "Cawken") {
        return has_trained_breed("Ducken") && byte(0x991d6) == 0x01        
    } else if (monster_name == "Queen Plant") { // Plant starts here
        return has_trained_breed("Plant") && byte(0x991d7) == 0x01        
    } else if (monster_name == "Rock Plant") {
        return has_trained_breed("Plant") && byte(0x991d8) == 0x01        
    } else if (monster_name == "Scaled Plant") {
        return has_trained_breed("Plant") && byte(0x991d9) == 0x01        
    } else if (monster_name == "Blue Plant") {
        return has_trained_breed("Plant") && byte(0x991da) == 0x01        
    } else if (monster_name == "Hare Plant") {
        return has_trained_breed("Plant") && byte(0x991db) == 0x01        
    } else if (monster_name == "Gold Plant") {
        return has_trained_breed("Plant") && byte(0x991dc) == 0x01        
    } else if (monster_name == "Usaba") {
        return has_trained_breed("Plant") && byte(0x991dd) == 0x01        
    } else if (monster_name == "Mirage Plant") {
        return has_trained_breed("Plant") && byte(0x991de) == 0x01        
    } else if (monster_name == "Plant") {
        return has_trained_breed("Plant") && byte(0x991df) == 0x01        
    } else if (monster_name == "Black Plant") {
        return has_trained_breed("Plant") && byte(0x991e0) == 0x01        
    } else if (monster_name == "Fly Plant") {
        return has_trained_breed("Plant") && byte(0x991e1) == 0x01        
    } else if (monster_name == "Weeds") {
        return has_trained_breed("Plant") && byte(0x991e2) == 0x01        
    } else if (monster_name == "Raggae Plant") {
        return has_trained_breed("Plant") && byte(0x991e3) == 0x01        
    } else if (monster_name == "Romper Wall") { // Monol starts here
        return has_trained_breed("Monol") && byte(0x991e4) == 0x01        
    } else if (monster_name == "Obelisk") {
        return has_trained_breed("Monol") && byte(0x991e5) == 0x01        
    } else if (monster_name == "Jura Wall") {
        return has_trained_breed("Monol") && byte(0x991e6) == 0x01        
    } else if (monster_name == "Blue Sponge") {
        return has_trained_breed("Monol") && byte(0x991e7) == 0x01        
    } else if (monster_name == "Furred Wall") {
        return has_trained_breed("Monol") && byte(0x991e8) == 0x01        
    } else if (monster_name == "Ivory Wall") {
        return has_trained_breed("Monol") && byte(0x991e9) == 0x01        
    } else if (monster_name == "Sandy") {
        return has_trained_breed("Monol") && byte(0x991ea) == 0x01        
    } else if (monster_name == "Ice Candy") {
        return has_trained_breed("Monol") && byte(0x991eb) == 0x01        
    } else if (monster_name == "New Leaf") {
        return has_trained_breed("Monol") && byte(0x991ec) == 0x01        
    } else if (monster_name == "Monol") {
        return has_trained_breed("Monol") && byte(0x991ed) == 0x01        
    } else if (monster_name == "Soboros") {
        return has_trained_breed("Monol") && byte(0x991ee) == 0x01        
    } else if (monster_name == "Asphaltum") {
        return has_trained_breed("Monol") && byte(0x991ef) == 0x01        
    } else if (monster_name == "Galaxy") {
        return has_trained_breed("Monol") && byte(0x991f0) == 0x01        
    } else if (monster_name == "Dominos") {
        return has_trained_breed("Monol") && byte(0x991f1) == 0x01        
    } else if (monster_name == "Scribble") {
        return has_trained_breed("Monol") && byte(0x991f2) == 0x01        
    } else if (monster_name == "Rock Ape") { // Ape starts here
        return has_trained_breed("Ape") && byte(0x991f3) == 0x01        
    } else if (monster_name == "Gibberer") {
        return has_trained_breed("Ape") && byte(0x991f4) == 0x01        
    } else if (monster_name == "Bossy") {
        return has_trained_breed("Ape") && byte(0x991f5) == 0x01        
    } else if (monster_name == "Tropical Ape") {
        return has_trained_breed("Ape") && byte(0x991f6) == 0x01        
    } else if (monster_name == "Ape") {
        return has_trained_breed("Ape") && byte(0x991f7) == 0x01        
    } else if (monster_name == "Gold Dust") {
        return has_trained_breed("Ape") && byte(0x991f8) == 0x01        
    } else if (monster_name == "Red Worm") { // Worm starts here
        return has_trained_breed("Worm") && byte(0x991f9) == 0x01        
    } else if (monster_name == "Rock Worm") {
        return has_trained_breed("Worm") && byte(0x991fa) == 0x01        
    } else if (monster_name == "Scaled Worm") {
        return has_trained_breed("Worm") && byte(0x991fb) == 0x01        
    } else if (monster_name == "Drill Tusk") {
        return has_trained_breed("Worm") && byte(0x991fc) == 0x01        
    } else if (monster_name == "Corone") {
        return has_trained_breed("Worm") && byte(0x991fd) == 0x01        
    } else if (monster_name == "Mask Worm") {
        return has_trained_breed("Worm") && byte(0x991fe) == 0x01        
    } else if (monster_name == "Eye Worm") {
        return has_trained_breed("Worm") && byte(0x991ff) == 0x01        
    } else if (monster_name == "Jelly Worm") {
        return has_trained_breed("Worm") && byte(0x99200) == 0x01        
    } else if (monster_name == "Flower Worm") {
        return has_trained_breed("Worm") && byte(0x99201) == 0x01        
    } else if (monster_name == "Black Worm") {
        return has_trained_breed("Worm") && byte(0x99202) == 0x01        
    } else if (monster_name == "Worm") {
        return has_trained_breed("Worm") && byte(0x99203) == 0x01        
    } else if (monster_name == "Purple Worm") {
        return has_trained_breed("Worm") && byte(0x99204) == 0x01        
    } else if (monster_name == "Express Worm") {
        return has_trained_breed("Worm") && byte(0x99205) == 0x01        
    } else if (monster_name == "Ripper") { // Naga starts here
        return has_trained_breed("Naga") && byte(0x99206) == 0x01        
    } else if (monster_name == "Trident") {
        return has_trained_breed("Naga") && byte(0x99207) == 0x01        
    } else if (monster_name == "Stinger") {
        return has_trained_breed("Naga") && byte(0x99208) == 0x01        
    } else if (monster_name == "Striker") {
        return has_trained_breed("Naga") && byte(0x99209) == 0x01        
    } else if (monster_name == "Edgehog") {
        return has_trained_breed("Naga") && byte(0x9920a) == 0x01        
    } else if (monster_name == "Bazula") {
        return has_trained_breed("Naga") && byte(0x9920b) == 0x01        
    } else if (monster_name == "Cyclops") {
        return has_trained_breed("Naga") && byte(0x9920c) == 0x01        
    } else if (monster_name == "Aqua Cutter") {
        return has_trained_breed("Naga") && byte(0x9920d) == 0x01        
    } else if (monster_name == "Jungler") {
        return has_trained_breed("Naga") && byte(0x9920e) == 0x01        
    } else if (monster_name == "Crimson Eyed") {
        return has_trained_breed("Naga") && byte(0x9920f) == 0x01        
    } else if (monster_name == "Earth Keeper") {
        return has_trained_breed("Naga") && byte(0x99210) == 0x01        
    } else if (monster_name == "Naga") {
        return has_trained_breed("Naga") && byte(0x99211) == 0x01        
    } else if (monster_name == "Time Noise") {
        return has_trained_breed("Naga") && byte(0x99212) == 0x01        
    }
}

legend_cup_set = achievement_set("389 Legend Cup Champions", type="BONUS", id=32120)

// ==== Pixie ====

achievement(
    set = legend_cup_set,
    title = "Spoiled but Not Powerless",
    description = "Win the Legend Cup with a Pixie (Pixie/Pixie).",
    points = 10,
    trigger = monster_trained("Pixie") && is_primary_breed("Pixie") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "High Pride",
    description = "Win the Legend Cup with a Daina (Pixie/Dragon).",
    points = 10,
    trigger = monster_trained("Daina") && is_primary_breed("Pixie") && is_secondary_breed("Dragon") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Unico vs. The World",
    description = "Win the Legend Cup with a Unico (Pixie/Centaur).",
    points = 10,
    trigger = monster_trained("Unico") && is_primary_breed("Pixie") && is_secondary_breed("Centaur") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Little Tease",
    description = "Win the Legend Cup with a Jilt (Pixie/Wracky).",
    points = 10,
    trigger = monster_trained("Jilt") && is_primary_breed("Pixie") && is_secondary_breed("Wracky") && prereqs_met() && wracky_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Strong-Willed",
    description = "Win the Legend Cup with a Granity (Pixie/Golem).",
    points = 10,
    trigger = monster_trained("Granity") && is_primary_breed("Pixie") && is_secondary_breed("Golem") && prereqs_met() && golem_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Welcome to the Jungle",
    description = "Win the Legend Cup with a Dixie (Pixie/Zuum).",
    points = 10,
    trigger = monster_trained("Dixie") && is_primary_breed("Pixie") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Brave Yet Delicate",
    description = "Win the Legend Cup with a Janne (Pixie/Durahan).",
    points = 10,
    trigger = monster_trained("Janne") && is_primary_breed("Pixie") && is_secondary_breed("Durahan") && prereqs_met() && durahan_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Poster Girl",
    description = "Win the Legend Cup with a Mint (Pixie/Tiger).",
    points = 10,
    trigger = monster_trained("Mint") && is_primary_breed("Pixie") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Constellation of Legends",
    description = "Win the Legend Cup with a Lepus (Pixie/Hare).",
    points = 10,
    trigger = monster_trained("Lepus") && is_primary_breed("Pixie") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Today There Is No Mercy",
    description = "Win the Legend Cup with an Angel (Pixie/Gali).",
    points = 10,
    trigger = monster_trained("Angel") && is_primary_breed("Pixie") && is_secondary_breed("Gali") && prereqs_met() && gali_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Second Musical Now in the Works",
    description = "Win the Legend Cup with a Kitten (Pixie/Kato).",
    points = 10,
    trigger = monster_trained("Kitten") && is_primary_breed("Pixie") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Sloppy, but Efficient",
    description = "Win the Legend Cup with a Jinnee (Pixie/Bajarl).",
    points = 10,
    trigger = monster_trained("Jinnee") && is_primary_breed("Pixie") && is_secondary_breed("Bajarl") && prereqs_met() && bajarl_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "This Is Our Future",
    description = "Win the Legend Cup with a Futurity (Pixie/Metalner).",
    points = 10,
    trigger = monster_trained("Futurity") && is_primary_breed("Pixie") && is_secondary_breed("Metalner") && prereqs_met() && metalner_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Dr. Maccots Greatest Discovery",
    description = "Win the Legend Cup with a Vanity (Pixie/Suezo).",
    points = 10,
    trigger = monster_trained("Vanity") && is_primary_breed("Pixie") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Northern Legend",
    description = "Win the Legend Cup with a Snowy (Pixie/Jill).",
    points = 10,
    trigger = monster_trained("Snowy") && is_primary_breed("Pixie") && is_secondary_breed("Jill") && prereqs_met() && jill_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Little Witch",
    description = "Win the Legend Cup with a Lilim (Pixie/Joker).",
    points = 10,
    trigger = monster_trained("Lilim") && is_primary_breed("Pixie") && is_secondary_breed("Joker") && prereqs_met() && joker_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Nagisa Skin",
    description = "Win the Legend Cup with a Nagisa (Pixie/Jell).",
    points = 10,
    trigger = monster_trained("Nagisa") && is_primary_breed("Pixie") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Forest Dweller",
    description = "Win the Legend Cup with a Dryad (Pixie/Mock).",
    points = 10,
    trigger = monster_trained("Dryad") && is_primary_breed("Pixie") && is_secondary_breed("Mock") && prereqs_met() && mock_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Time to Soak Some Rays",
    description = "Win the Legend Cup with a Serenity (Pixie/Plant).",
    points = 10,
    trigger = monster_trained("Serenity") && is_primary_breed("Pixie") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Shield No Longer Needed",
    description = "Win the Legend Cup with a Silhouette (Pixie/Monol).",
    points = 10,
    trigger = monster_trained("Silhouette") && is_primary_breed("Pixie") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Beauty Is in the Eye of the Beholder",
    description = "Win the Legend Cup with a Night Flyer (Pixie/Worm).",
    points = 10,
    trigger = monster_trained("Night Flyer") && is_primary_breed("Pixie") && is_secondary_breed("Worm") && prereqs_met() && worm_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Vampiric Tendencies",
    description = "Win the Legend Cup with an Allure (Pixie/Naga).",
    points = 10,
    trigger = monster_trained("Allure") && is_primary_breed("Pixie") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ??? pixies
achievement(
    set = legend_cup_set,
    title = "Power of the Red Pill",
    description = "Win the Legend Cup with a Poison (Pixie/???).",
    points = 10,
    trigger = monster_trained("Poison") && is_primary_breed("Pixie") && rare_breed_matches("Poison") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Pixie of Destiny",
    description = "Win the Legend Cup with a Kasumi (Pixie/???).",
    points = 10,
    trigger = monster_trained("Kasumi") && is_primary_breed("Pixie") && rare_breed_matches("Kasumi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Woman in Mia",
    description = "Win the Legend Cup with a Mia (Pixie/???).",
    points = 10,
    trigger = monster_trained("Mia") && is_primary_breed("Pixie") && rare_breed_matches("Mia") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Dragon ====

achievement(
    set = legend_cup_set,
    title = "Uncontested Strength",
    description = "Win the Legend Cup with a Tiamat (Dragon/Pixie).",
    points = 10,
    trigger = monster_trained("Tiamat") && is_primary_breed("Dragon") && is_secondary_breed("Pixie") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "One of the Few",
    description = "Win the Legend Cup with a Dragon (Dragon/Dragon).",
    points = 10,
    trigger = monster_trained("Dragon") && is_primary_breed("Dragon") && is_secondary_breed("Dragon") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Foreign Legend",
    description = "Win the Legend Cup with a Corkasus (Dragon/Beaclon).",
    points = 10,
    trigger = monster_trained("Corkasus") && is_primary_breed("Dragon") && is_secondary_breed("Beaclon") && prereqs_met() && dragon_unlocked() && beaclon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Mix All The Tech!",
    description = "Win the Legend Cup with a Tecno Dragon (Dragon/Henger).",
    points = 10,
    trigger = monster_trained("Tecno Dragon") && is_primary_breed("Dragon") && is_secondary_breed("Henger") && prereqs_met() && dragon_unlocked() && henger_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Destructive Power On Display",
    description = "Win the Legend Cup with a Stone Dragon (Dragon/Golem).",
    points = 10,
    trigger = monster_trained("Stone Dragon") && is_primary_breed("Dragon") && is_secondary_breed("Golem") && prereqs_met() && dragon_unlocked() && golem_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Relic of a Bygone Era",
    description = "Win the Legend Cup with an Armor Dragon (Dragon/Durahan).",
    points = 10,
    trigger = monster_trained("Armor Dragon") && is_primary_breed("Dragon") && is_secondary_breed("Durahan") && prereqs_met() && dragon_unlocked() && durahan_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Lakeside Ruler",
    description = "Win the Legend Cup with a Crab Dragon (Dragon/Arrow Head).",
    points = 10,
    trigger = monster_trained("Crab Dragon") && is_primary_breed("Dragon") && is_secondary_breed("Arrow Head") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It's Gonna Hide the Cup",
    description = "Win the Legend Cup with a Hound Dragon (Dragon/Tiger).",
    points = 10,
    trigger = monster_trained("Hound Dragon") && is_primary_breed("Dragon") && is_secondary_breed("Tiger") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Like Holography",
    description = "Win the Legend Cup with a Gariel (Dragon/Gali).",
    points = 10,
    trigger = monster_trained("Gariel") && is_primary_breed("Dragon") && is_secondary_breed("Gali") && prereqs_met() && dragon_unlocked() && gali_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Oil Pot King",
    description = "Win the Legend Cup with an Oscerot (Dragon/Kato).",
    points = 10,
    trigger = monster_trained("Oscerot") && is_primary_breed("Dragon") && is_secondary_breed("Kato") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Thankfully, Nobody Brought Bombs",
    description = "Win the Legend Cup with a Dodongo (Dragon/Bajarl).",
    points = 10,
    trigger = monster_trained("Dodongo") && is_primary_breed("Dragon") && is_secondary_breed("Bajarl") && prereqs_met() && dragon_unlocked() && bajarl_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Mysterious Futuristic Power",
    description = "Win the Legend Cup with a Gidras (Dragon/Metalner).",
    points = 10,
    trigger = monster_trained("Gidras") && is_primary_breed("Dragon") && is_secondary_breed("Metalner") && prereqs_met() && dragon_unlocked() && metalner_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Back with a Vengeance",
    description = "Win the Legend Cup with a Death Dragon (Dragon/Joker).",
    points = 10,
    trigger = monster_trained("Death Dragon") && is_primary_breed("Dragon") && is_secondary_breed("Joker") && prereqs_met() && dragon_unlocked() && joker_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Apocalypse Bringer",
    description = "Win the Legend Cup with a Ragnaroks (Dragon/Monol).",
    points = 10,
    trigger = monster_trained("Ragnaroks") && is_primary_breed("Dragon") && is_secondary_breed("Monol") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Moo-low Gold",
    description = "Win the Legend Cup with a Moo (Dragon/???).",
    points = 10,
    trigger = monster_trained("Moo") && is_primary_breed("Dragon") && rare_breed_matches("Moo") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Centaur ====

achievement(
    set = legend_cup_set,
    title = "Fast & Ferious",
    description = "Win the Legend Cup with a Ferious (Centaur/Pixie).",
    points = 10,
    trigger = monster_trained("Ferious") && is_primary_breed("Centaur") && is_secondary_breed("Pixie") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Brave and Just",
    description = "Win the Legend Cup with a Dragoon (Centaur/Dragon).",
    points = 10,
    trigger = monster_trained("Dragoon") && is_primary_breed("Centaur") && is_secondary_breed("Dragon") && prereqs_met() && centaur_unlocked() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "They've Got it All",
    description = "Win the Legend Cup with a Centaur (Centaur/Centaur).",
    points = 10,
    trigger = monster_trained("Centaur") && is_primary_breed("Centaur") && is_secondary_breed("Centaur") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Who Gave the Moai a Spear?",
    description = "Win the Legend Cup with a Trojan (Centaur/Golem).",
    points = 10,
    trigger = monster_trained("Trojan") && is_primary_breed("Centaur") && is_secondary_breed("Golem") && prereqs_met() && centaur_unlocked() && golem_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Two Souls Means Two Legends",
    description = "Win the Legend Cup with a Chariot (Centaur/Durahan).",
    points = 10,
    trigger = monster_trained("Chariot") && is_primary_breed("Centaur") && is_secondary_breed("Durahan") && prereqs_met() && centaur_unlocked() && durahan_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Semi-Aquatic Fighter",
    description = "Win the Legend Cup with an Antares (Centaur/Arrow Head).",
    points = 10,
    trigger = monster_trained("Antares") && is_primary_breed("Centaur") && is_secondary_breed("Arrow Head") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Lonely Warrior",
    description = "Win the Legend Cup with a Celious (Centaur/Tiger).",
    points = 10,
    trigger = monster_trained("Celious") && is_primary_breed("Centaur") && is_secondary_breed("Tiger") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Free Spirited",
    description = "Win the Legend Cup with a Bazoo (Centaur/Bajarl).",
    points = 10,
    trigger = monster_trained("Bazoo") && is_primary_breed("Centaur") && is_secondary_breed("Bajarl") && prereqs_met() && centaur_unlocked() && bajarl_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No Love for the Creator",
    description = "Win the Legend Cup with a Reaper (Centaur/Joker).",
    points = 10,
    trigger = monster_trained("Reaper") && is_primary_breed("Centaur") && is_secondary_breed("Joker") && prereqs_met() && centaur_unlocked() && joker_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Thoroughbred Runner",
    description = "Win the Legend Cup with a Trotter (Centaur/???).",
    points = 10,
    trigger = monster_trained("Trotter") && is_primary_breed("Centaur") && rare_breed_matches("Trotter") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Under the Table and Dreaming",
    description = "Win the Legend Cup with a Blue Thunder (Centaur/???).",
    points = 10,
    trigger = monster_trained("Blue Thunder") && is_primary_breed("Centaur") && rare_breed_matches("Blue Thunder") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== ColorPandora ====

achievement(
    set = legend_cup_set,
    title = "Loud and Proud",
    description = "Win the Legend Cup with a PeachTreeBug (ColorPandora/Pixie).",
    points = 10,
    trigger = monster_trained("PeachTreeBug") && is_primary_breed("ColorPandora") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Victory, Love and Effort Prevail",
    description = "Win the Legend Cup with a ColorPandora (ColorPandora/ColorPandora).",
    points = 10,
    trigger = monster_trained("ColorPandora") && is_primary_breed("ColorPandora") && is_secondary_breed("ColorPandora") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Perfectly Camouflauged",
    description = "Win the Legend Cup with a Liquid Cube (ColorPandora/Jell).",
    points = 10,
    trigger = monster_trained("Liquid Cube") && is_primary_breed("ColorPandora") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Devilish Dice",
    description = "Win the Legend Cup with a Dice (ColorPandora/???).",
    points = 10,
    trigger = monster_trained("Dice") && is_primary_breed("ColorPandora") && rare_breed_matches("Dice") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Downtown Tram",
    description = "Win the Legend Cup with a Tram (ColorPandora/???).",
    points = 10,
    trigger = monster_trained("Tram") && is_primary_breed("ColorPandora") && rare_breed_matches("Tram") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Beaclon ====

achievement(
    set = legend_cup_set,
    title = "Death's Dance",
    description = "Win the Legend Cup with a Bethelgeus (Beaclon/Dragon).",
    points = 10,
    trigger = monster_trained("Bethelgeus") && is_primary_breed("Beaclon") && is_secondary_breed("Dragon") && beaclon_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Brute Forced It",
    description = "Win the Legend Cup with a Beaclon (Beaclon/Beaclon).",
    points = 5,
    trigger = monster_trained("Beaclon") && is_primary_breed("Beaclon") && is_secondary_breed("Beaclon") && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Pre-Henger Prototype",
    description = "Win the Legend Cup with a Melcarba (Beaclon/Henger).",
    points = 10,
    trigger = monster_trained("Melcarba") && is_primary_breed("Beaclon") && is_secondary_breed("Henger") && beaclon_unlocked() && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Rock On, Rocklon",
    description = "Win the Legend Cup with a Rocklon (Beaclon/Golem).",
    points = 10,
    trigger = monster_trained("Rocklon") && is_primary_breed("Beaclon") && is_secondary_breed("Golem") && beaclon_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Captaining an Army of One",
    description = "Win the Legend Cup with a Centurion (Beaclon/Durahan).",
    points = 10,
    trigger = monster_trained("Centurion") && is_primary_breed("Beaclon") && is_secondary_breed("Durahan") && beaclon_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Minimal Effort Expenditure",
    description = "Win the Legend Cup with a Sloth Beetle (Beaclon/Tiger).",
    points = 10,
    trigger = monster_trained("Sloth Beetle") && is_primary_breed("Beaclon") && is_secondary_breed("Tiger") && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Top Tier Transit",
    description = "Win the Legend Cup with a KautRoarKaut (Beaclon/Bajarl).",
    points = 10,
    trigger = monster_trained("KautRoarKaut") && is_primary_breed("Beaclon") && is_secondary_breed("Bajarl") && beaclon_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Fights Like Jagger",
    description = "Win the Legend Cup with a Jaggernaut (Beaclon/Joker).",
    points = 10,
    trigger = monster_trained("Jaggernaut") && is_primary_breed("Beaclon") && is_secondary_breed("Joker") && beaclon_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tightly Wound",
    description = "Win the Legend Cup with a Ducklon (Beaclon/Ducken).",
    points = 10,
    trigger = monster_trained("Ducklon") && is_primary_breed("Beaclon") && is_secondary_breed("Ducken") && beaclon_unlocked() && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Food Waste Ain't For Legends",
    description = "Win the Legend Cup with an Eggplantern (Beaclon/???).",
    points = 10,
    trigger = monster_trained("Eggplantern") && is_primary_breed("Beaclon") && rare_breed_matches("Eggplantern") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Henger ====

achievement(
    set = legend_cup_set,
    title = "Phantom Robotics",
    description = "Win the Legend Cup with a Garlant (Henger/Dragon).",
    points = 10,
    trigger = monster_trained("Garlant") && is_primary_breed("Henger") && is_secondary_breed("Dragon") && henger_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Fresh Start, Fresh Legend",
    description = "Win the Legend Cup with a Henger (Henger/Henger).",
    points = 10,
    trigger = monster_trained("Henger") && is_primary_breed("Henger") && is_secondary_breed("Henger") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Rocky Soul",
    description = "Win the Legend Cup with a Gaia (Henger/Golem).",
    points = 10,
    trigger = monster_trained("Gaia") && is_primary_breed("Henger") && is_secondary_breed("Golem") && henger_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Alpha and the Omega",
    description = "Win the Legend Cup with an Omega (Henger/Zuum).",
    points = 10,
    trigger = monster_trained("Omega") && is_primary_breed("Henger") && is_secondary_breed("Zuum") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Airborne Speedster",
    description = "Win the Legend Cup with a Heuy (Henger/Metalner).",
    points = 10,
    trigger = monster_trained("Heuy") && is_primary_breed("Henger") && is_secondary_breed("Metalner") && henger_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Evil Predispositions",
    description = "Win the Legend Cup with an End Bringer (Henger/Joker).",
    points = 10,
    trigger = monster_trained("End Bringer") && is_primary_breed("Henger") && is_secondary_breed("Joker") && henger_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The First Henger",
    description = "Win the Legend Cup with an Automaton (Henger/Mock).",
    points = 10,
    trigger = monster_trained("Automaton") && is_primary_breed("Henger") && is_secondary_breed("Mock") && henger_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Under the Full Moon",
    description = "Win the Legend Cup with a Black Henger (Henger/Monol).",
    points = 10,
    trigger = monster_trained("Black Henger") && is_primary_breed("Henger") && is_secondary_breed("Monol") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Mechanical Animal",
    description = "Win the Legend Cup with a Skeleton (Henger/???).",
    points = 10,
    trigger = monster_trained("Skeleton") && is_primary_breed("Henger") && rare_breed_matches("Skeleton") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Wracky ====

achievement(
    set = legend_cup_set,
    title = "Baby-Doll Eyes Did Work",
    description = "Win the Legend Cup with a Baby Doll (Wracky/Pixie).",
    points = 10,
    trigger = monster_trained("Baby Doll") && is_primary_breed("Wracky") && is_secondary_breed("Pixie") && wracky_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Prime Collector Material",
    description = "Win the Legend Cup with a Draco Doll (Wracky/Dragon).",
    points = 10,
    trigger = monster_trained("Draco Doll") && is_primary_breed("Wracky") && is_secondary_breed("Dragon") && wracky_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Buzz Lighthenger",
    description = "Win the Legend Cup with a Henger Doll (Wracky/Henger).",
    points = 10,
    trigger = monster_trained("Henger Doll") && is_primary_breed("Wracky") && is_secondary_breed("Henger") && wracky_unlocked() && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Charles Becoming a Household Name",
    description = "Win the Legend Cup with a Wracky (Wracky/Wracky).",
    points = 10,
    trigger = monster_trained("Wracky") && is_primary_breed("Wracky") && is_secondary_breed("Wracky") && wracky_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Little Too Authentic",
    description = "Win the Legend Cup with a Pebbly (Wracky/Golem).",
    points = 10,
    trigger = monster_trained("Pebbly") && is_primary_breed("Wracky") && is_secondary_breed("Golem") && wracky_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Small Knight, Significant Value",
    description = "Win the Legend Cup with a Petit Knight (Wracky/Durahan).",
    points = 10,
    trigger = monster_trained("Petit Knight") && is_primary_breed("Wracky") && is_secondary_breed("Durahan") && wracky_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No Take-Bakkys!",
    description = "Win the Legend Cup with a Bakky (Wracky/Bajarl).",
    points = 10,
    trigger = monster_trained("Bakky") && is_primary_breed("Wracky") && is_secondary_breed("Bajarl") && wracky_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Favorite Amongst the Children",
    description = "Win the Legend Cup with a Metal Glay (Wracky/Metalner).",
    points = 10,
    trigger = monster_trained("Metal Glay") && is_primary_breed("Wracky") && is_secondary_breed("Metalner") && wracky_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Do Not Trust the Clown Doll",
    description = "Win the Legend Cup with a Tricker (Wracky/Joker).",
    points = 10,
    trigger = monster_trained("Tricker") && is_primary_breed("Wracky") && is_secondary_breed("Joker") && wracky_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It's Not Cheap, It's Cost Effective",
    description = "Win the Legend Cup with a Mocky (Wracky/Mock).",
    points = 10,
    trigger = monster_trained("Mocky") && is_primary_breed("Wracky") && is_secondary_breed("Mock") && wracky_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "All I Want for Christmas Is This Doll",
    description = "Win the Legend Cup with a Satan Clause (Wracky/???).",
    points = 10,
    trigger = monster_trained("Satan Clause") && is_primary_breed("Wracky") && rare_breed_matches("Satan Clause") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Golem ====

achievement(
    set = legend_cup_set,
    title = "Pacifist at Heart",
    description = "Win the Legend Cup with a Pink Golem (Golem/Pixie).",
    points = 10,
    trigger = monster_trained("Pink Golem") && is_primary_breed("Golem") && is_secondary_breed("Pixie") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Grounded in Reality",
    description = "Win the Legend Cup with a Tyrant (Golem/Dragon).",
    points = 10,
    trigger = monster_trained("Tyrant") && is_primary_breed("Golem") && is_secondary_breed("Dragon") && golem_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Horn's Just For Show",
    description = "Win the Legend Cup with a Strong Horn (Golem/Beaclon).",
    points = 10,
    trigger = monster_trained("Strong Horn") && is_primary_breed("Golem") && is_secondary_breed("Beaclon") && golem_unlocked() && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Ancient War Weapon",
    description = "Win the Legend Cup with a Gobi (Golem/Henger).",
    points = 10,
    trigger = monster_trained("Gobi") && is_primary_breed("Golem") && is_secondary_breed("Henger") && golem_unlocked() && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tell Me I Looked Cool Out There",
    description = "Win the Legend Cup with a Mariomax (Golem/Wracky).",
    points = 10,
    trigger = monster_trained("Mariomax") && is_primary_breed("Golem") && is_secondary_breed("Wracky") && golem_unlocked() && wracky_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "One Punch to Rule Them All",
    description = "Win the Legend Cup with a Golem (Golem/Golem).",
    points = 10,
    trigger = monster_trained("Golem") && is_primary_breed("Golem") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Desirable Scales",
    description = "Win the Legend Cup with a Scaled Golem (Golem/Zuum).",
    points = 10,
    trigger = monster_trained("Scaled Golem") && is_primary_breed("Golem") && is_secondary_breed("Zuum") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Sentient Armor",
    description = "Win the Legend Cup with a Battle Rocks (Golem/Durahan).",
    points = 10,
    trigger = monster_trained("Battle Rocks") && is_primary_breed("Golem") && is_secondary_breed("Durahan") && golem_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Body Built for Anything",
    description = "Win the Legend Cup with a Dagon (Golem/Arrow Head).",
    points = 10,
    trigger = monster_trained("Dagon") && is_primary_breed("Golem") && is_secondary_breed("Arrow Head") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Nevermeltice",
    description = "Win the Legend Cup with a Big Blue (Golem/Tiger).",
    points = 10,
    trigger = monster_trained("Big Blue") && is_primary_breed("Golem") && is_secondary_breed("Tiger") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Turning Point in Our History",
    description = "Win the Legend Cup with a Moaigon (Golem/Hare).",
    points = 10,
    trigger = monster_trained("Moaigon") && is_primary_breed("Golem") && is_secondary_breed("Hare") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Sedentary Sleepyhead",
    description = "Win the Legend Cup with a Sleepyhead (Golem/Baku).",
    points = 10,
    trigger = monster_trained("Sleepyhead") && is_primary_breed("Golem") && is_secondary_breed("Baku") && golem_unlocked() && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Noble's Best Friend",
    description = "Win the Legend Cup with an Amenhotep (Golem/Gali).",
    points = 10,
    trigger = monster_trained("Amenhotep") && is_primary_breed("Golem") && is_secondary_breed("Gali") && golem_unlocked() && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "In A Weight Class of its Own",
    description = "Win the Legend Cup with a Pressure (Golem/Zilla).",
    points = 10,
    trigger = monster_trained("Pressure") && is_primary_breed("Golem") && is_secondary_breed("Zilla") && golem_unlocked() && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Perfect Data Access Object Reference",
    description = "Win the Legend Cup with a Dao (Golem/Bajarl).",
    points = 10,
    trigger = monster_trained("Dao") && is_primary_breed("Golem") && is_secondary_breed("Bajarl") && golem_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Starbound",
    description = "Win the Legend Cup with an Astro (Golem/Metalner).",
    points = 10,
    trigger = monster_trained("Astro") && is_primary_breed("Golem") && is_secondary_breed("Metalner") && golem_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Celebrating With Curry Rice",
    description = "Win the Legend Cup with a Titan (Golem/Suezo).",
    points = 10,
    trigger = monster_trained("Titan") && is_primary_breed("Golem") && is_secondary_breed("Suezo") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "I'm the Joker Now",
    description = "Win the Legend Cup with an Angolmor (Golem/Joker).",
    points = 10,
    trigger = monster_trained("Angolmor") && is_primary_breed("Golem") && is_secondary_breed("Joker") && golem_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "This Sea God's Better on Land",
    description = "Win the Legend Cup with a Poseidon (Golem/Jell).",
    points = 10,
    trigger = monster_trained("Poseidon") && is_primary_breed("Golem") && is_secondary_breed("Jell") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Straight Faced Champion",
    description = "Win the Legend Cup with a Wood Golem (Golem/Mock).",
    points = 10,
    trigger = monster_trained("Wood Golem") && is_primary_breed("Golem") && is_secondary_breed("Mock") && golem_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "God of Nature",
    description = "Win the Legend Cup with an Ecologuardia (Golem/Plant).",
    points = 10,
    trigger = monster_trained("Ecologuardia") && is_primary_breed("Golem") && is_secondary_breed("Plant") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Big Brother Is Watching",
    description = "Win the Legend Cup with a Black Golem (Golem/Monol).",
    points = 10,
    trigger = monster_trained("Black Golem") && is_primary_breed("Golem") && is_secondary_breed("Monol") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Bearer of Ancient Scriptures",
    description = "Win the Legend Cup with a Magna (Golem/Worm).",
    points = 10,
    trigger = monster_trained("Magna") && is_primary_breed("Golem") && is_secondary_breed("Worm") && golem_unlocked() && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Pure Offense",
    description = "Win the Legend Cup with a Marble Guy (Golem/Naga).",
    points = 10,
    trigger = monster_trained("Marble Guy") && is_primary_breed("Golem") && is_secondary_breed("Naga") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tecmo Bowl MVP",
    description = "Win the Legend Cup with a ForwardGolem (Golem/???).",
    points = 10,
    trigger = monster_trained("ForwardGolem") && is_primary_breed("Golem") && rare_breed_matches("ForwardGolem") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Zuum ====

achievement(
    set = legend_cup_set,
    title = "Wings Not Needed to Win",
    description = "Win the Legend Cup with a FairySaurian (Zuum/Pixie).",
    points = 10,
    trigger = monster_trained("FairySaurian") && is_primary_breed("Zuum") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Explosively Violent",
    description = "Win the Legend Cup with a Salamander (Zuum/Dragon).",
    points = 10,
    trigger = monster_trained("Salamander") && is_primary_breed("Zuum") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Do the Move Good and Fast",
    description = "Win the Legend Cup with a Rock Saurian (Zuum/Golem).",
    points = 10,
    trigger = monster_trained("Rock Saurian") && is_primary_breed("Zuum") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Natural Evolution of Dino",
    description = "Win the Legend Cup with a Zuum (Zuum/Zuum).",
    points = 10,
    trigger = monster_trained("Zuum") && is_primary_breed("Zuum") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Natural Triathlon Candidate",
    description = "Win the Legend Cup with a Crab Saurian (Zuum/Arrow Head).",
    points = 10,
    trigger = monster_trained("Crab Saurian") && is_primary_breed("Zuum") && is_secondary_breed("Arrow Head") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Greatest Delivery Monster",
    description = "Win the Legend Cup with a HoundSaurian (Zuum/Tiger).",
    points = 10,
    trigger = monster_trained("HoundSaurian") && is_primary_breed("Zuum") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Selective Bravery",
    description = "Win the Legend Cup with a Spot Saurian (Zuum/Hare).",
    points = 10,
    trigger = monster_trained("Spot Saurian") && is_primary_breed("Zuum") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Smartest Zuum in the Room",
    description = "Win the Legend Cup with a Hachiro (Zuum/Baku).",
    points = 10,
    trigger = monster_trained("Hachiro") && is_primary_breed("Zuum") && is_secondary_breed("Baku") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Status Symbol",
    description = "Win the Legend Cup with a NobleSaurian (Zuum/Gali).",
    points = 10,
    trigger = monster_trained("NobleSaurian") && is_primary_breed("Zuum") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Might Is Right",
    description = "Win the Legend Cup with a Tasman (Zuum/Kato).",
    points = 10,
    trigger = monster_trained("Tasman") && is_primary_breed("Zuum") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Loves the Coarse and Rough Sand",
    description = "Win the Legend Cup with a Sand Saurian (Zuum/Bajarl).",
    points = 10,
    trigger = monster_trained("Sand Saurian") && is_primary_breed("Zuum") && is_secondary_breed("Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Fully Committed Prankster",
    description = "Win the Legend Cup with a Mustardy (Zuum/Suezo).",
    points = 10,
    trigger = monster_trained("Mustardy") && is_primary_breed("Zuum") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Mezmerising Patterns",
    description = "Win the Legend Cup with a Basilisk (Zuum/Joker).",
    points = 10,
    trigger = monster_trained("Basilisk") && is_primary_breed("Zuum") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Prehistoric Gel",
    description = "Win the Legend Cup with a JellySaurian (Zuum/Jell).",
    points = 10,
    trigger = monster_trained("JellySaurian") && is_primary_breed("Zuum") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Even Cowards Can Be Legends",
    description = "Win the Legend Cup with a Wood Saurian (Zuum/Mock).",
    points = 10,
    trigger = monster_trained("Wood Saurian") && is_primary_breed("Zuum") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Bridal Beast",
    description = "Win the Legend Cup with an AlohaSaurian (Zuum/Plant).",
    points = 10,
    trigger = monster_trained("AlohaSaurian") && is_primary_breed("Zuum") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Fashionista",
    description = "Win the Legend Cup with a BlackSaurian (Zuum/Monol).",
    points = 10,
    trigger = monster_trained("BlackSaurian") && is_primary_breed("Zuum") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Loyal Steed",
    description = "Win the Legend Cup with a ShellSaurian (Zuum/Worm).",
    points = 10,
    trigger = monster_trained("ShellSaurian") && is_primary_breed("Zuum") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Inherited Anger",
    description = "Win the Legend Cup with a Naga Saurian (Zuum/Naga).",
    points = 10,
    trigger = monster_trained("Naga Saurian") && is_primary_breed("Zuum") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Waste of Mind",
    description = "Win the Legend Cup with a ZebraSaurian (Zuum/???).",
    points = 10,
    trigger = monster_trained("ZebraSaurian") && is_primary_breed("Zuum") && rare_breed_matches("ZebraSaurian") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Durahan ====

achievement(
    set = legend_cup_set,
    title = "Equal Opportunity Fighting",
    description = "Win the Legend Cup with a Leziena (Durahan/Pixie).",
    points = 10,
    trigger = monster_trained("Leziena") && is_primary_breed("Durahan") && is_secondary_breed("Pixie") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Powered by the Dragon Head",
    description = "Win the Legend Cup with a Vesuvius (Durahan/Dragon).",
    points = 10,
    trigger = monster_trained("Vesuvius") && is_primary_breed("Durahan") && is_secondary_breed("Dragon") && durahan_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Winning Unscathed",
    description = "Win the Legend Cup with a Hercules (Durahan/Beaclon).",
    points = 10,
    trigger = monster_trained("Hercules") && is_primary_breed("Durahan") && is_secondary_breed("Beaclon") && durahan_unlocked() && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Anything but Normal",
    description = "Win the Legend Cup with a Kelmadics (Durahan/Golem).",
    points = 10,
    trigger = monster_trained("Kelmadics") && is_primary_breed("Durahan") && is_secondary_breed("Golem") && durahan_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Armor With a Drive to Win",
    description = "Win the Legend Cup with a Durahan (Durahan/Durahan).",
    points = 10,
    trigger = monster_trained("Durahan") && is_primary_breed("Durahan") && is_secondary_breed("Durahan") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Crustaceous Armor",
    description = "Win the Legend Cup with a Lorica (Durahan/Arrow Head).",
    points = 10,
    trigger = monster_trained("Lorica") && is_primary_breed("Durahan") && is_secondary_breed("Arrow Head") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Molded By the Tiger",
    description = "Win the Legend Cup with a Hound Knight (Durahan/Tiger).",
    points = 10,
    trigger = monster_trained("Hound Knight") && is_primary_breed("Durahan") && is_secondary_breed("Tiger") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Garuda's Back With a Vengeance",
    description = "Win the Legend Cup with a Garuda (Durahan/Phoenix).",
    points = 10,
    trigger = monster_trained("Garuda") && is_primary_breed("Durahan") && is_secondary_breed("Phoenix") && durahan_unlocked() && phoenix_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Brought a Laser Sword to a Fist Fight",
    description = "Win the Legend Cup with a Metal Glory (Durahan/Metalner).",
    points = 10,
    trigger = monster_trained("Metal Glory") && is_primary_breed("Durahan") && is_secondary_breed("Metalner") && durahan_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Cursed Armaments",
    description = "Win the Legend Cup with a Genocider (Durahan/Joker).",
    points = 10,
    trigger = monster_trained("Genocider") && is_primary_breed("Durahan") && is_secondary_breed("Joker") && durahan_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Forgot to Replace My Starter Equipment",
    description = "Win the Legend Cup with a Wood Knight (Durahan/Mock).",
    points = 10,
    trigger = monster_trained("Wood Knight") && is_primary_breed("Durahan") && is_secondary_breed("Mock") && durahan_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Musashi's Continued Legacy",
    description = "Win the Legend Cup with a Shogun (Durahan/???).",
    points = 10,
    trigger = monster_trained("Shogun") && is_primary_breed("Durahan") && rare_breed_matches("Shogun") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Third Eye Blind",
    description = "Win the Legend Cup with a Ruby Knight (Durahan/???).",
    points = 10,
    trigger = monster_trained("Ruby Knight") && is_primary_breed("Durahan") && rare_breed_matches("Ruby Knight") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "I'll Make a Monster Out of You",
    description = "Win the Legend Cup with a Kokushi Muso (Durahan/???).",
    points = 10,
    trigger = monster_trained("Kokushi Muso") && is_primary_breed("Durahan") && rare_breed_matches("Kokushi Muso") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Arrow Head ====

achievement(
    set = legend_cup_set,
    title = "Yet Another Take on the Henger",
    description = "Win the Legend Cup with a Renocraft (Arrow Head/Henger).",
    points = 10,
    trigger = monster_trained("Renocraft") && is_primary_breed("Arrow Head") && is_secondary_breed("Henger") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Night Owl",
    description = "Win the Legend Cup with a Priarocks (Arrow Head/Golem).",
    points = 10,
    trigger = monster_trained("Priarocks") && is_primary_breed("Arrow Head") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Medieval Vaporware",
    description = "Win the Legend Cup with a Plated Arrow (Arrow Head/Durahan).",
    points = 10,
    trigger = monster_trained("Plated Arrow") && is_primary_breed("Arrow Head") && is_secondary_breed("Durahan") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Endurance Battler",
    description = "Win the Legend Cup with an Arrow Head (Arrow Head/Arrow Head).",
    points = 10,
    trigger = monster_trained("Arrow Head") && is_primary_breed("Arrow Head") && is_secondary_breed("Arrow Head") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Is the Happy, Not the Sadness!",
    description = "Win the Legend Cup with a MustardArrow (Arrow Head/Suezo).",
    points = 10,
    trigger = monster_trained("MustardArrow") && is_primary_breed("Arrow Head") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Death By A Thousand Thorns",
    description = "Win the Legend Cup with a Selketo (Arrow Head/Joker).",
    points = 10,
    trigger = monster_trained("Selketo") && is_primary_breed("Arrow Head") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Imflammable Oak",
    description = "Win the Legend Cup with a Log Sawer (Arrow Head/Mock).",
    points = 10,
    trigger = monster_trained("Log Sawer") && is_primary_breed("Arrow Head") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "We've Come A Long Way",
    description = "Win the Legend Cup with a Sumopion (Arrow Head/???).",
    points = 10,
    trigger = monster_trained("Sumopion") && is_primary_breed("Arrow Head") && rare_breed_matches("Sumopion") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Tiger ====

achievement(
    set = legend_cup_set,
    title = "Work Hard, Play Harder",
    description = "Win the Legend Cup with a Daton (Tiger/Pixie).",
    points = 10,
    trigger = monster_trained("Daton") && is_primary_breed("Tiger") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Granite Hound",
    description = "Win the Legend Cup with a Rock Hound (Tiger/Golem).",
    points = 10,
    trigger = monster_trained("Rock Hound") && is_primary_breed("Tiger") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Definitely a Triceratops",
    description = "Win the Legend Cup with a Datonare (Tiger/Zuum).",
    points = 10,
    trigger = monster_trained("Datonare") && is_primary_breed("Tiger") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Ordinary Legend",
    description = "Win the Legend Cup with a Tiger (Tiger/Tiger).",
    points = 10,
    trigger = monster_trained("Tiger") && is_primary_breed("Tiger") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "This One's a Keeper",
    description = "Win the Legend Cup with a Hare Hound (Tiger/Hare).",
    points = 10,
    trigger = monster_trained("Hare Hound") && is_primary_breed("Tiger") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Dignified Fighter",
    description = "Win the Legend Cup with a Balon (Tiger/Gali).",
    points = 10,
    trigger = monster_trained("Balon") && is_primary_breed("Tiger") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Depth Perception Is a Crutch",
    description = "Win the Legend Cup with a Mono Eyed (Tiger/Suezo).",
    points = 10,
    trigger = monster_trained("Mono Eyed") && is_primary_breed("Tiger") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Cooler Wind Blows",
    description = "Win the Legend Cup with a Jelly Hound (Tiger/Jell).",
    points = 10,
    trigger = monster_trained("Jelly Hound") && is_primary_breed("Tiger") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Reppin' the South Side",
    description = "Win the Legend Cup with a Tropical Dog (Tiger/Plant).",
    points = 10,
    trigger = monster_trained("Tropical Dog") && is_primary_breed("Tiger") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Terrorizing the Ranks",
    description = "Win the Legend Cup with a Terror Dog (Tiger/Monol).",
    points = 10,
    trigger = monster_trained("Terror Dog") && is_primary_breed("Tiger") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Can Do This With Half My Eyes Closed!",
    description = "Win the Legend Cup with a Jagd Hound (Tiger/Worm).",
    points = 10,
    trigger = monster_trained("Jagd Hound") && is_primary_breed("Tiger") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Further Fueling the Prohibition",
    description = "Win the Legend Cup with a Cabalos (Tiger/Naga).",
    points = 10,
    trigger = monster_trained("Cabalos") && is_primary_breed("Tiger") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Nobody Can Dance With Wolves",
    description = "Win the Legend Cup with a White Hound (Tiger/???).",
    points = 10,
    trigger = monster_trained("White Hound") && is_primary_breed("Tiger") && rare_breed_matches("White Hound") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Hopper ====

achievement(
    set = legend_cup_set,
    title = "Jumping to Victory",
    description = "Win the Legend Cup with a Fairy Hopper (Hopper/Pixie).",
    points = 10,
    trigger = monster_trained("Fairy Hopper") && is_primary_breed("Hopper") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Hopper of the Peaple",
    description = "Win the Legend Cup with a Draco Hopper (Hopper/Dragon).",
    points = 10,
    trigger = monster_trained("Draco Hopper") && is_primary_breed("Hopper") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Do Not Touch the Horn",
    description = "Win the Legend Cup with a Skipper (Hopper/Tiger).",
    points = 10,
    trigger = monster_trained("Skipper") && is_primary_breed("Hopper") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Naughty Little Guy",
    description = "Win the Legend Cup with a Hopper (Hopper/Hopper).",
    points = 10,
    trigger = monster_trained("Hopper") && is_primary_breed("Hopper") && is_secondary_breed("Hopper") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Win for One Is a Win for All",
    description = "Win the Legend Cup with a Mustachios (Hopper/Kato).",
    points = 10,
    trigger = monster_trained("Mustachios") && is_primary_breed("Hopper") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Probably Eating the Cup After",
    description = "Win the Legend Cup with an Emerald Eye (Hopper/Bajarl).",
    points = 10,
    trigger = monster_trained("Emerald Eye") && is_primary_breed("Hopper") && is_secondary_breed("Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Lustrous Future",
    description = "Win the Legend Cup with a Springer (Hopper/Metalner).",
    points = 10,
    trigger = monster_trained("Springer") && is_primary_breed("Hopper") && is_secondary_breed("Metalner") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Sees All",
    description = "Win the Legend Cup with a Rear Eyed (Hopper/Suezo).",
    points = 10,
    trigger = monster_trained("Rear Eyed") && is_primary_breed("Hopper") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Real Trendsetter",
    description = "Win the Legend Cup with a Snow Hopper (Hopper/Jill).",
    points = 10,
    trigger = monster_trained("Snow Hopper") && is_primary_breed("Hopper") && is_secondary_breed("Jill") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Too Much of a Good Thing",
    description = "Win the Legend Cup with a Pink Hopper (Hopper/Mocchi).",
    points = 10,
    trigger = monster_trained("Pink Hopper") && is_primary_breed("Hopper") && is_secondary_breed("Mocchi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Self-Centered Fighter",
    description = "Win the Legend Cup with a Sneak Hopper (Hopper/Joker).",
    points = 10,
    trigger = monster_trained("Sneak Hopper") && is_primary_breed("Hopper") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No Bark, All Bite",
    description = "Win the Legend Cup with a Woody Hopper (Hopper/Mock).",
    points = 10,
    trigger = monster_trained("Woody Hopper") && is_primary_breed("Hopper") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Deep Cover Hopper",
    description = "Win the Legend Cup with a Frog Hopper (Hopper/???).",
    points = 10,
    trigger = monster_trained("Frog Hopper") && is_primary_breed("Hopper") && rare_breed_matches("Frog Hopper") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Hare ====

achievement(
    set = legend_cup_set,
    title = "Self-Conscious Legend",
    description = "Win the Legend Cup with a Fairy Hare (Hare/Pixie).",
    points = 10,
    trigger = monster_trained("Fairy Hare") && is_primary_breed("Hare") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Dexterity Made Optional",
    description = "Win the Legend Cup with a Rocky Fur (Hare/Golem).",
    points = 10,
    trigger = monster_trained("Rocky Fur") && is_primary_breed("Hare") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Jumped to the Top",
    description = "Win the Legend Cup with a Scaled Hare (Hare/Zuum).",
    points = 10,
    trigger = monster_trained("Scaled Hare") && is_primary_breed("Hare") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Chic Hare",
    description = "Win the Legend Cup with a Blue Hare (Hare/Tiger).",
    points = 10,
    trigger = monster_trained("Blue Hare") && is_primary_breed("Hare") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Quick Bugger, That One",
    description = "Win the Legend Cup with a Hare (Hare/Hare).",
    points = 10,
    trigger = monster_trained("Hare") && is_primary_breed("Hare") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Divinity Asserting Dominance",
    description = "Win the Legend Cup with a Prince Hare (Hare/Gali).",
    points = 10,
    trigger = monster_trained("Prince Hare") && is_primary_breed("Hare") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "More Eyes Means More Accurate",
    description = "Win the Legend Cup with a Four Eyed (Hare/Suezo).",
    points = 10,
    trigger = monster_trained("Four Eyed") && is_primary_breed("Hare") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Power Lies in Its Flabby Belly",
    description = "Win the Legend Cup with a Jelly Hare (Hare/Jell).",
    points = 10,
    trigger = monster_trained("Jelly Hare") && is_primary_breed("Hare") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Embossed Leaves",
    description = "Win the Legend Cup with a Leaf Hare (Hare/Plant).",
    points = 10,
    trigger = monster_trained("Leaf Hare") && is_primary_breed("Hare") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Night Brawler",
    description = "Win the Legend Cup with an Evil Hare (Hare/Monol).",
    points = 10,
    trigger = monster_trained("Evil Hare") && is_primary_breed("Hare") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Eyebrows Alone Are Legendary",
    description = "Win the Legend Cup with a Wild Hare (Hare/Worm).",
    points = 10,
    trigger = monster_trained("Wild Hare") && is_primary_breed("Hare") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Glass Cannon",
    description = "Win the Legend Cup with a Purple Hare (Hare/Naga).",
    points = 10,
    trigger = monster_trained("Purple Hare") && is_primary_breed("Hare") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Next Jackie Chan",
    description = "Win the Legend Cup with a KungFuHare (Hare/???).",
    points = 10,
    trigger = monster_trained("KungFuHare") && is_primary_breed("Hare") && rare_breed_matches("KungFuHare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Baku ====

achievement(
    set = legend_cup_set,
    title = "Domesticated Laziness",
    description = "Win the Legend Cup with a Magmax (Baku/Dragon).",
    points = 10,
    trigger = monster_trained("Magmax") && is_primary_breed("Baku") && is_secondary_breed("Dragon") && baku_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Master of Useless Facts",
    description = "Win the Legend Cup with a Higante (Baku/Golem).",
    points = 10,
    trigger = monster_trained("Higante") && is_primary_breed("Baku") && is_secondary_breed("Golem") && baku_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The People's Bulwark",
    description = "Win the Legend Cup with a War Baku (Baku/Durahan).",
    points = 10,
    trigger = monster_trained("War Baku") && is_primary_breed("Baku") && is_secondary_breed("Durahan") && baku_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Glutton for Victory",
    description = "Win the Legend Cup with an Icebergy (Baku/Tiger).",
    points = 10,
    trigger = monster_trained("Icebergy") && is_primary_breed("Baku") && is_secondary_breed("Tiger") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Challenge of Legends Accepted",
    description = "Win the Legend Cup with a Gontar (Baku/Hare).",
    points = 10,
    trigger = monster_trained("Gontar") && is_primary_breed("Baku") && is_secondary_breed("Hare") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Pure and Innocent",
    description = "Win the Legend Cup with a Baku (Baku/Baku).",
    points = 10,
    trigger = monster_trained("Baku") && is_primary_breed("Baku") && is_secondary_breed("Baku") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Risk Free Victory",
    description = "Win the Legend Cup with a Nussie (Baku/Kato).",
    points = 10,
    trigger = monster_trained("Nussie") && is_primary_breed("Baku") && is_secondary_breed("Kato") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Forgot Its Evil Duties",
    description = "Win the Legend Cup with a Baku Clown (Baku/Joker).",
    points = 10,
    trigger = monster_trained("Baku Clown") && is_primary_breed("Baku") && is_secondary_breed("Joker") && baku_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Patience Leads to Victory",
    description = "Win the Legend Cup with a Giga Pint (Baku/Jell).",
    points = 10,
    trigger = monster_trained("Giga Pint") && is_primary_breed("Baku") && is_secondary_breed("Jell") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Homogenic",
    description = "Win the Legend Cup with a ShiShi (Baku/???).",
    points = 10,
    trigger = monster_trained("ShiShi") && is_primary_breed("Baku") && rare_breed_matches("ShiShi") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Gali ====

achievement(
    set = legend_cup_set,
    title = "A Strange Tale in the Ogre Battle Saga",
    description = "Win the Legend Cup with a Pink Mask (Gali/Pixie).",
    points = 10,
    trigger = monster_trained("Pink Mask") && is_primary_breed("Gali") && is_secondary_breed("Pixie") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Be Ya Self",
    description = "Win the Legend Cup with a Stone Mask (Gali/Golem).",
    points = 10,
    trigger = monster_trained("Stone Mask") && is_primary_breed("Gali") && is_secondary_breed("Golem") && gali_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Jurassic Scales",
    description = "Win the Legend Cup with a Scaled Mask (Gali/Zuum).",
    points = 10,
    trigger = monster_trained("Scaled Mask") && is_primary_breed("Gali") && is_secondary_breed("Zuum") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Framed by Fangs",
    description = "Win the Legend Cup with a Fanged Mask (Gali/Tiger).",
    points = 10,
    trigger = monster_trained("Fanged Mask") && is_primary_breed("Gali") && is_secondary_breed("Tiger") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Hare-Brained Guardian",
    description = "Win the Legend Cup with a Furred Mask (Gali/Hare).",
    points = 10,
    trigger = monster_trained("Furred Mask") && is_primary_breed("Gali") && is_secondary_breed("Hare") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Bit Closer to God Now",
    description = "Win the Legend Cup with a Gali (Gali/Gali).",
    points = 10,
    trigger = monster_trained("Gali") && is_primary_breed("Gali") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Decorative Eye",
    description = "Win the Legend Cup with a Suezo Mask (Gali/Suezo).",
    points = 10,
    trigger = monster_trained("Suezo Mask") && is_primary_breed("Gali") && is_secondary_breed("Suezo") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Gel Is Only Pictured",
    description = "Win the Legend Cup with an Aqua Mask (Gali/Jell).",
    points = 10,
    trigger = monster_trained("Aqua Mask") && is_primary_breed("Gali") && is_secondary_breed("Jell") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Peace Loving Guardian",
    description = "Win the Legend Cup with a Colorful (Gali/Plant).",
    points = 10,
    trigger = monster_trained("Colorful") && is_primary_breed("Gali") && is_secondary_breed("Plant") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Smooth as Silk",
    description = "Win the Legend Cup with a Galirous (Gali/Monol).",
    points = 10,
    trigger = monster_trained("Galirous") && is_primary_breed("Gali") && is_secondary_breed("Monol") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "All Smiles Here",
    description = "Win the Legend Cup with a Brown Mask (Gali/Worm).",
    points = 10,
    trigger = monster_trained("Brown Mask") && is_primary_breed("Gali") && is_secondary_breed("Worm") && gali_unlocked() && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Born to Battle",
    description = "Win the Legend Cup with a Purple Mask (Gali/Naga).",
    points = 10,
    trigger = monster_trained("Purple Mask") && is_primary_breed("Gali") && is_secondary_breed("Naga") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Legend Larger Than Life",
    description = "Win the Legend Cup with a Happy Mask (Gali/???).",
    points = 10,
    trigger = monster_trained("Happy Mask") && is_primary_breed("Gali") && rare_breed_matches("Happy Mask") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Kato ====

achievement(
    set = legend_cup_set,
    title = "Inherited Violent Tendencies",
    description = "Win the Legend Cup with a Draco Kato (Kato/Dragon).",
    points = 10,
    trigger = monster_trained("Draco Kato") && is_primary_breed("Kato") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Now You See Me, Now You Don't",
    description = "Win the Legend Cup with a Blue Kato (Kato/Tiger).",
    points = 10,
    trigger = monster_trained("Blue Kato") && is_primary_breed("Kato") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Look What the Cat Dragged In",
    description = "Win the Legend Cup with a Gordish (Kato/Gali).",
    points = 10,
    trigger = monster_trained("Gordish") && is_primary_breed("Kato") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Olive Oil Fanatic",
    description = "Win the Legend Cup with a Kato (Kato/Kato).",
    points = 10,
    trigger = monster_trained("Kato") && is_primary_breed("Kato") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Befuddling Tactics",
    description = "Win the Legend Cup with a Citronie (Kato/Suezo).",
    points = 10,
    trigger = monster_trained("Citronie") && is_primary_breed("Kato") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Story of the Tamamayu",
    description = "Win the Legend Cup with a Pink Kato (Kato/Mocchi).",
    points = 10,
    trigger = monster_trained("Pink Kato") && is_primary_breed("Kato") && is_secondary_breed("Mocchi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Reclusive Cat",
    description = "Win the Legend Cup with a Tainted Cat (Kato/Joker).",
    points = 10,
    trigger = monster_trained("Tainted Cat") && is_primary_breed("Kato") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Rikimaru's Ancestor",
    description = "Win the Legend Cup with a Ninja Kato (Kato/???).",
    points = 10,
    trigger = monster_trained("Ninja Kato") && is_primary_breed("Kato") && rare_breed_matches("Ninja Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Zilla ====

achievement(
    set = legend_cup_set,
    title = "Immaculate Body Image",
    description = "Win the Legend Cup with a Pink Zilla (Zilla/Pixie).",
    points = 10,
    trigger = monster_trained("Pink Zilla") && is_primary_breed("Zilla") && is_secondary_breed("Pixie") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Anti-Titanic Terror",
    description = "Win the Legend Cup with a Gooji (Zilla/Tiger).",
    points = 10,
    trigger = monster_trained("Gooji") && is_primary_breed("Zilla") && is_secondary_breed("Tiger") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Large Lad Wins it All",
    description = "Win the Legend Cup with a Zilla (Zilla/Zilla).",
    points = 10,
    trigger = monster_trained("Zilla") && is_primary_breed("Zilla") && is_secondary_breed("Zilla") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Eyes of the Sea",
    description = "Win the Legend Cup with a Gigalon (Zilla/Jell).",
    points = 10,
    trigger = monster_trained("Gigalon") && is_primary_breed("Zilla") && is_secondary_breed("Jell") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Perpetually in Fear of Gooji",
    description = "Win the Legend Cup with a Deluxe Liner (Zilla/???).",
    points = 10,
    trigger = monster_trained("Deluxe Liner") && is_primary_breed("Zilla") && rare_breed_matches("Deluxe Liner") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Bajarl ====

achievement(
    set = legend_cup_set,
    title = "Binto's Secret Pulling Through",
    description = "Win the Legend Cup with a Bajarl (Bajarl/Bajarl).",
    points = 10,
    trigger = monster_trained("Bajarl") && is_primary_breed("Bajarl") && is_secondary_breed("Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Made for Assassination",
    description = "Win the Legend Cup with a Jaba (Bajarl/Joker).",
    points = 10,
    trigger = monster_trained("Jaba") && is_primary_breed("Bajarl") && is_secondary_breed("Joker") && bajarl_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "King of the Ring",
    description = "Win the Legend Cup with a Boxer Bajarl (Bajarl/???).",
    points = 10,
    trigger = monster_trained("Boxer Bajarl") && is_primary_breed("Bajarl") && rare_breed_matches("Boxer Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No Further Need to Hide in the Pot",
    description = "Win the Legend Cup with a Magic Bajarl (Bajarl/???).",
    points = 10,
    trigger = monster_trained("Magic Bajarl") && is_primary_breed("Bajarl") && rare_breed_matches("Magic Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Hero of Justice",
    description = "Win the Legend Cup with an Ultrarl (Bajarl/???).",
    points = 10,
    trigger = monster_trained("Ultrarl") && is_primary_breed("Bajarl") && rare_breed_matches("Ultrarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Mew ====

achievement(
    set = legend_cup_set,
    title = "Lost the Moo Roulette, Still a Winner",
    description = "Win the Legend Cup with a Mum Mew (Mew/Pixie).",
    points = 10,
    trigger = monster_trained("Mum Mew") && is_primary_breed("Mew") && is_secondary_breed("Pixie") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tiger's Cousin, Twice Removed",
    description = "Win the Legend Cup with a Bowwow (Mew/Tiger).",
    points = 10,
    trigger = monster_trained("Bowwow") && is_primary_breed("Mew") && is_secondary_breed("Tiger") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Do Not Mess With Its Ears",
    description = "Win the Legend Cup with an Eared Mew (Mew/Hare).",
    points = 10,
    trigger = monster_trained("Eared Mew") && is_primary_breed("Mew") && is_secondary_breed("Hare") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Loves To Sing-a",
    description = "Win the Legend Cup with a Mew (Mew/Mew).",
    points = 10,
    trigger = monster_trained("Mew") && is_primary_breed("Mew") && is_secondary_breed("Mew") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Dreams Can Come True",
    description = "Win the Legend Cup with an Aqua Mew (Mew/Jell).",
    points = 10,
    trigger = monster_trained("Aqua Mew") && is_primary_breed("Mew") && is_secondary_breed("Jell") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Pool's Smelling Like Teen Spirit",
    description = "Win the Legend Cup with a Swimmer (Mew/???).",
    points = 10,
    trigger = monster_trained("Swimmer") && is_primary_breed("Mew") && rare_breed_matches("Swimmer") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Phoenix ====

achievement(
    set = legend_cup_set,
    title = "Reborn Legend Upholding Its Status",
    description = "Win the Legend Cup with a Phoenix (Phoenix/Phoenix).",
    points = 10,
    trigger = monster_trained("Phoenix") && is_primary_breed("Phoenix") && is_secondary_breed("Phoenix") && phoenix_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Burning with Rage",
    description = "Win the Legend Cup with a Cinder Bird (Phoenix/???).",
    points = 10,
    trigger = monster_trained("Cinder Bird") && is_primary_breed("Phoenix") && rare_breed_matches("Cinder Bird") && phoenix_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Ghost ====

achievement(
    set = legend_cup_set,
    title = "Second Chance Taken",
    description = "Win the Legend Cup with a Ghost (Ghost/Ghost).",
    points = 10,
    trigger = monster_trained("Ghost") && is_primary_breed("Ghost") && is_secondary_breed("Ghost") && ghost_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Iron Chef",
    description = "Win the Legend Cup with a Chef (Ghost/???).",
    points = 10,
    trigger = monster_trained("Chef") && is_primary_breed("Ghost") && rare_breed_matches("Chef") && ghost_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Metalner ====

achievement(
    set = legend_cup_set,
    title = "What is Love?",
    description = "Win the Legend Cup with a Love Seeker (Metalner/Pixie).",
    points = 10,
    trigger = monster_trained("Love Seeker") && is_primary_breed("Metalner") && is_secondary_breed("Pixie") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Intergalactic Champion",
    description = "Win the Legend Cup with a Metalner (Metalner/Metalner).",
    points = 10,
    trigger = monster_trained("Metalner") && is_primary_breed("Metalner") && is_secondary_breed("Metalner") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Alien on Permanent Vacation",
    description = "Win the Legend Cup with a Metazorl (Metalner/Suezo).",
    points = 10,
    trigger = monster_trained("Metazorl") && is_primary_breed("Metalner") && is_secondary_breed("Suezo") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Agent C's Claim to Fame",
    description = "Win the Legend Cup with a Chinois (Metalner/???).",
    points = 10,
    trigger = monster_trained("Chinois") && is_primary_breed("Metalner") && rare_breed_matches("Chinois") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Suezo ====

achievement(
    set = legend_cup_set,
    title = "All It Wanted was Equal Treatment",
    description = "Win the Legend Cup with a Pink Eye (Suezo/Pixie).",
    points = 10,
    trigger = monster_trained("Pink Eye") && is_primary_breed("Suezo") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Heavyweight Champion",
    description = "Win the Legend Cup with a Rocky Suezo (Suezo/Golem).",
    points = 10,
    trigger = monster_trained("Rocky Suezo") && is_primary_breed("Suezo") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Regular Farm Invader",
    description = "Win the Legend Cup with a Melon Suezo (Suezo/Zuum).",
    points = 10,
    trigger = monster_trained("Melon Suezo") && is_primary_breed("Suezo") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Horn Is a Metaphor",
    description = "Win the Legend Cup with a Horn (Suezo/Tiger).",
    points = 10,
    trigger = monster_trained("Horn") && is_primary_breed("Suezo") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Time for a New Adventure",
    description = "Win the Legend Cup with a Furred Suezo (Suezo/Hare).",
    points = 10,
    trigger = monster_trained("Furred Suezo") && is_primary_breed("Suezo") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Inside Its Eye Is Another Legend",
    description = "Win the Legend Cup with an Orion (Suezo/Gali).",
    points = 10,
    trigger = monster_trained("Orion") && is_primary_breed("Suezo") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Endearing Expressions",
    description = "Win the Legend Cup with a Suezo (Suezo/Suezo).",
    points = 10,
    trigger = monster_trained("Suezo") && is_primary_breed("Suezo") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Modeling After the Ultimate Form",
    description = "Win the Legend Cup with a Clear Suezo (Suezo/Jell).",
    points = 10,
    trigger = monster_trained("Clear Suezo") && is_primary_breed("Suezo") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Earnest Among Suezos",
    description = "Win the Legend Cup with a Green Suezo (Suezo/Plant).",
    points = 10,
    trigger = monster_trained("Green Suezo") && is_primary_breed("Suezo") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Insomniacs Rise Up",
    description = "Win the Legend Cup with a Red Eye (Suezo/Monol).",
    points = 10,
    trigger = monster_trained("Red Eye") && is_primary_breed("Suezo") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Legends Multiply",
    description = "Win the Legend Cup with a Fly Eye (Suezo/Worm).",
    points = 10,
    trigger = monster_trained("Fly Eye") && is_primary_breed("Suezo") && is_secondary_breed("Worm") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Used Only a Fraction of Its Strength",
    description = "Win the Legend Cup with a Purple Suezo (Suezo/Naga).",
    points = 10,
    trigger = monster_trained("Purple Suezo") && is_primary_breed("Suezo") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "That's Gold, Jerry!",
    description = "Win the Legend Cup with a Gold Suezo (Suezo/???).",
    points = 10,
    trigger = monster_trained("Gold Suezo") && is_primary_breed("Suezo") && rare_breed_matches("Gold Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No, I Don't Want No Scrub",
    description = "Win the Legend Cup with a Silver Suezo (Suezo/???).",
    points = 10,
    trigger = monster_trained("Silver Suezo") && is_primary_breed("Suezo") && rare_breed_matches("Silver Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Flush It All Away",
    description = "Win the Legend Cup with a Bronze Suezo (Suezo/???).",
    points = 10,
    trigger = monster_trained("Bronze Suezo") && is_primary_breed("Suezo") && rare_breed_matches("Bronze Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Nice Shot!",
    description = "Win the Legend Cup with a Birdie (Suezo/???).",
    points = 10,
    trigger = monster_trained("Birdie") && is_primary_breed("Suezo") && rare_breed_matches("Birdie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Jill ====

achievement(
    set = legend_cup_set,
    title = "Meat Lover",
    description = "Win the Legend Cup with a Pong Pong (Jill/Pixie).",
    points = 10,
    trigger = monster_trained("Pong Pong") && is_primary_breed("Jill") && is_secondary_breed("Pixie") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Finally Off Gathering Duty",
    description = "Win the Legend Cup with a Pierry (Jill/Tiger).",
    points = 10,
    trigger = monster_trained("Pierry") && is_primary_breed("Jill") && is_secondary_breed("Tiger") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Huh? Was I Supposed To Win?",
    description = "Win the Legend Cup with a Wondar (Jill/Hare).",
    points = 10,
    trigger = monster_trained("Wondar") && is_primary_breed("Jill") && is_secondary_breed("Hare") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "In Need of a Victory Feast",
    description = "Win the Legend Cup with a Bengal (Jill/Kato).",
    points = 10,
    trigger = monster_trained("Bengal") && is_primary_breed("Jill") && is_secondary_breed("Kato") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Five Steps Ahead",
    description = "Win the Legend Cup with a Zorjil (Jill/Suezo).",
    points = 10,
    trigger = monster_trained("Zorjil") && is_primary_breed("Jill") && is_secondary_breed("Suezo") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Reppin' the North Side",
    description = "Win the Legend Cup with a Jill (Jill/Jill).",
    points = 10,
    trigger = monster_trained("Jill") && is_primary_breed("Jill") && is_secondary_breed("Jill") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Enough Smart to Be A Legend",
    description = "Win the Legend Cup with a Skull Capped (Jill/Joker).",
    points = 10,
    trigger = monster_trained("Skull Capped") && is_primary_breed("Jill") && is_secondary_breed("Joker") && jill_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Yabba Dabba Doo!",
    description = "Win the Legend Cup with a Pithecan (Jill/???).",
    points = 10,
    trigger = monster_trained("Pithecan") && is_primary_breed("Jill") && rare_breed_matches("Pithecan") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Mocchi ====

achievement(
    set = legend_cup_set,
    title = "The Most Beautiful Monster of All",
    description = "Win the Legend Cup with a Manna (Mocchi/Pixie).",
    points = 10,
    trigger = monster_trained("Manna") && is_primary_breed("Mocchi") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Too Cute to Be Violent",
    description = "Win the Legend Cup with a Draco Mocchi (Mocchi/Dragon).",
    points = 10,
    trigger = monster_trained("Draco Mocchi") && is_primary_breed("Mocchi") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Natural Armor Coming in Clutch",
    description = "Win the Legend Cup with a KnightMocchi (Mocchi/Durahan).",
    points = 10,
    trigger = monster_trained("KnightMocchi") && is_primary_breed("Mocchi") && is_secondary_breed("Durahan") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Fake It 'Till You Make It",
    description = "Win the Legend Cup with a Fake Penguin (Mocchi/Tiger).",
    points = 10,
    trigger = monster_trained("Fake Penguin") && is_primary_breed("Mocchi") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Taught This Old Cat Every Trick",
    description = "Win the Legend Cup with a Nyankoro (Mocchi/Kato).",
    points = 10,
    trigger = monster_trained("Nyankoro") && is_primary_breed("Mocchi") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Mascot Material",
    description = "Win the Legend Cup with a Mocchi (Mocchi/Mocchi).",
    points = 10,
    trigger = monster_trained("Mocchi") && is_primary_breed("Mocchi") && is_secondary_breed("Mocchi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Partial Fiend, Full Legend",
    description = "Win the Legend Cup with a Hell Pierrot (Mocchi/Joker).",
    points = 10,
    trigger = monster_trained("Hell Pierrot") && is_primary_breed("Mocchi") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Was Only Pretending To Be Soft",
    description = "Win the Legend Cup with a Gelatine (Mocchi/Jell).",
    points = 10,
    trigger = monster_trained("Gelatine") && is_primary_breed("Mocchi") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Every Caloriena Counts",
    description = "Win the Legend Cup with a Caloriena (Mocchi/???).",
    points = 10,
    trigger = monster_trained("Caloriena") && is_primary_breed("Mocchi") && rare_breed_matches("Caloriena") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Speeding to the Top",
    description = "Win the Legend Cup with a Mocchini (Mocchi/???).",
    points = 10,
    trigger = monster_trained("Mocchini") && is_primary_breed("Mocchi") && rare_breed_matches("Mocchini") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Joker ====

achievement(
    set = legend_cup_set,
    title = "Famed Atrocity",
    description = "Win the Legend Cup with a Hell Heart (Joker/Pixie).",
    points = 10,
    trigger = monster_trained("Hell Heart") && is_primary_breed("Joker") && is_secondary_breed("Pixie") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Crueler Than a Dragon",
    description = "Win the Legend Cup with a Flare Death (Joker/Dragon).",
    points = 10,
    trigger = monster_trained("Flare Death") && is_primary_breed("Joker") && is_secondary_breed("Dragon") && joker_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Strength Beyond Measure",
    description = "Win the Legend Cup with a Tombstone (Joker/Golem).",
    points = 10,
    trigger = monster_trained("Tombstone") && is_primary_breed("Joker") && is_secondary_breed("Golem") && joker_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Only One Hit Needed",
    description = "Win the Legend Cup with a Blue Terror (Joker/Tiger).",
    points = 10,
    trigger = monster_trained("Blue Terror") && is_primary_breed("Joker") && is_secondary_breed("Tiger") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Redemption After Disgrace",
    description = "Win the Legend Cup with an Odium (Joker/Bajarl).",
    points = 10,
    trigger = monster_trained("Odium") && is_primary_breed("Joker") && is_secondary_breed("Bajarl") && joker_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Unsealed Terror",
    description = "Win the Legend Cup with a Joker (Joker/Joker).",
    points = 10,
    trigger = monster_trained("Joker") && is_primary_breed("Joker") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Peak Aggression",
    description = "Win the Legend Cup with a Bloodshed (Joker/???).",
    points = 10,
    trigger = monster_trained("Bloodshed") && is_primary_breed("Joker") && rare_breed_matches("Bloodshed") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Gaboo ====

achievement(
    set = legend_cup_set,
    title = "Cool as a Gaboo",
    description = "Win the Legend Cup with a Frozen Gaboo (Gaboo/Tiger).",
    points = 10,
    trigger = monster_trained("Frozen Gaboo") && is_primary_breed("Gaboo") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Secret Numbing Agent Applied",
    description = "Win the Legend Cup with a Dokoo (Gaboo/Joker).",
    points = 10,
    trigger = monster_trained("Dokoo") && is_primary_breed("Gaboo") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Shy Blob",
    description = "Win the Legend Cup with a Gaboo (Gaboo/Gaboo).",
    points = 10,
    trigger = monster_trained("Gaboo") && is_primary_breed("Gaboo") && is_secondary_breed("Gaboo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Core Not Needed",
    description = "Win the Legend Cup with a Jelly Gaboo (Gaboo/Jell).",
    points = 10,
    trigger = monster_trained("Jelly Gaboo") && is_primary_breed("Gaboo") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Close Quarter Combat Master",
    description = "Win the Legend Cup with a GabooSoldier (Gaboo/???).",
    points = 10,
    trigger = monster_trained("GabooSoldier") && is_primary_breed("Gaboo") && rare_breed_matches("GabooSoldier") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Jell ====

achievement(
    set = legend_cup_set,
    title = "Jam's Only For Fighting",
    description = "Win the Legend Cup with a Pink Jam (Jell/Pixie).",
    points = 10,
    trigger = monster_trained("Pink Jam") && is_primary_breed("Jell") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Walling the Competition",
    description = "Win the Legend Cup with a Wall Mimic (Jell/Golem).",
    points = 10,
    trigger = monster_trained("Wall Mimic") && is_primary_breed("Jell") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Scales Are Only for Show",
    description = "Win the Legend Cup with a Scaled Jell (Jell/Zuum).",
    points = 10,
    trigger = monster_trained("Scaled Jell") && is_primary_breed("Jell") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Confectionery Advertising",
    description = "Win the Legend Cup with an Icy Jell (Jell/Tiger).",
    points = 10,
    trigger = monster_trained("Icy Jell") && is_primary_breed("Jell") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Spiritually Related to Gaboo",
    description = "Win the Legend Cup with a Muddy Jell (Jell/Hare).",
    points = 10,
    trigger = monster_trained("Muddy Jell") && is_primary_breed("Jell") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Many Reasons to Be Proud",
    description = "Win the Legend Cup with a Noble Jell (Jell/Gali).",
    points = 10,
    trigger = monster_trained("Noble Jell") && is_primary_breed("Jell") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "All-Seeing Eye",
    description = "Win the Legend Cup with an Eye Jell (Jell/Suezo).",
    points = 10,
    trigger = monster_trained("Eye Jell") && is_primary_breed("Jell") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Flexibility is Key For Winning",
    description = "Win the Legend Cup with a Jell (Jell/Jell).",
    points = 10,
    trigger = monster_trained("Jell") && is_primary_breed("Jell") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Fiending for Water",
    description = "Win the Legend Cup with a Chloro Jell (Jell/Plant).",
    points = 10,
    trigger = monster_trained("Chloro Jell") && is_primary_breed("Jell") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Coal Tar Making a Name For Itself",
    description = "Win the Legend Cup with a Clay (Jell/Monol).",
    points = 10,
    trigger = monster_trained("Clay") && is_primary_breed("Jell") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Eyes Down Here, Buddy",
    description = "Win the Legend Cup with a Worm Jell (Jell/Worm).",
    points = 10,
    trigger = monster_trained("Worm Jell") && is_primary_breed("Jell") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Living in the Moment",
    description = "Win the Legend Cup with a Purple Jell (Jell/Naga).",
    points = 10,
    trigger = monster_trained("Purple Jell") && is_primary_breed("Jell") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "T-1000 Taking Names",
    description = "Win the Legend Cup with a Metal Jell (Jell/???).",
    points = 10,
    trigger = monster_trained("Metal Jell") && is_primary_breed("Jell") && rare_breed_matches("Metal Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Undine ====

achievement(
    set = legend_cup_set,
    title = "Wind and Water At Its Call",
    description = "Win the Legend Cup with a Siren (Undine/Joker).",
    points = 10,
    trigger = monster_trained("Siren") && is_primary_breed("Undine") && is_secondary_breed("Joker") && undine_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "She's Talented on Land Too",
    description = "Win the Legend Cup with an Undine (Undine/Undine).",
    points = 10,
    trigger = monster_trained("Undine") && is_primary_breed("Undine") && is_secondary_breed("Undine") && undine_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Now She's Part of That World",
    description = "Win the Legend Cup with a Mermaid (Undine/???).",
    points = 10,
    trigger = monster_trained("Mermaid") && is_primary_breed("Undine") && rare_breed_matches("Mermaid") && undine_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Niton ====

achievement(
    set = legend_cup_set,
    title = "That Belongs in a Museum",
    description = "Win the Legend Cup with an Ammon (Niton/Golem).",
    points = 10,
    trigger = monster_trained("Ammon") && is_primary_breed("Niton") && is_secondary_breed("Golem") && niton_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Steel Shell",
    description = "Win the Legend Cup with a Knight Niton (Niton/Durahan).",
    points = 10,
    trigger = monster_trained("Knight Niton") && is_primary_breed("Niton") && is_secondary_breed("Durahan") && niton_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Stripe Per Tournament Won",
    description = "Win the Legend Cup with a Stripe Shell (Niton/Kato).",
    points = 10,
    trigger = monster_trained("Stripe Shell") && is_primary_breed("Niton") && is_secondary_breed("Kato") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Appearing With a Win",
    description = "Win the Legend Cup with an Alabia Niton (Niton/Bajarl).",
    points = 10,
    trigger = monster_trained("Alabia Niton") && is_primary_breed("Niton") && is_secondary_breed("Bajarl") && niton_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Future Is Now",
    description = "Win the Legend Cup with a Metal Shell (Niton/Metalner).",
    points = 10,
    trigger = monster_trained("Metal Shell") && is_primary_breed("Niton") && is_secondary_breed("Metalner") && niton_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tough Nut to Crack",
    description = "Win the Legend Cup with a Clear Shell (Niton/Jell).",
    points = 10,
    trigger = monster_trained("Clear Shell") && is_primary_breed("Niton") && is_secondary_breed("Jell") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Rather Skittish",
    description = "Win the Legend Cup with a Niton (Niton/Niton).",
    points = 10,
    trigger = monster_trained("Niton") && is_primary_breed("Niton") && is_secondary_breed("Niton") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tree Cake",
    description = "Win the Legend Cup with a Baum Kuchen (Niton/Mock).",
    points = 10,
    trigger = monster_trained("Baum Kuchen") && is_primary_breed("Niton") && is_secondary_breed("Mock") && niton_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Kickball Champion",
    description = "Win the Legend Cup with a Dribbler (Niton/???).",
    points = 10,
    trigger = monster_trained("Dribbler") && is_primary_breed("Niton") && rare_breed_matches("Dribbler") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Lightning McQueen",
    description = "Win the Legend Cup with a Radial Niton (Niton/???).",
    points = 10,
    trigger = monster_trained("Radial Niton") && is_primary_breed("Niton") && rare_breed_matches("Radial Niton") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Best Disc Stone Ever",
    description = "Win the Legend Cup with a Disc Niton (Niton/???).",
    points = 10,
    trigger = monster_trained("Disc Niton") && is_primary_breed("Niton") && rare_breed_matches("Disc Niton") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Mock ====

achievement(
    set = legend_cup_set,
    title = "Nobody Expects the Tree To Fight Back",
    description = "Win the Legend Cup with an Ebony (Mock/Joker).",
    points = 10,
    trigger = monster_trained("Ebony") && is_primary_breed("Mock") && is_secondary_breed("Joker") && mock_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Legendary Crook Gonzales",
    description = "Win the Legend Cup with a Mock (Mock/Mock).",
    points = 10,
    trigger = monster_trained("Mock") && is_primary_breed("Mock") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Comparsa Companion",
    description = "Win the Legend Cup with a White Birch (Mock/???).",
    points = 25,
    trigger = monster_trained("White Birch") && is_primary_breed("Mock") && rare_breed_matches("White Birch") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Electric Warrior",
    description = "Win the Legend Cup with a Pole Mock (Mock/???).",
    points = 25,
    trigger = monster_trained("Pole Mock") && is_primary_breed("Mock") && rare_breed_matches("Pole Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Ducken ====

achievement(
    set = legend_cup_set,
    title = "If Many Rocks Look Like A Duck...",
    description = "Win the Legend Cup with a Blocken (Ducken/Golem).",
    points = 10,
    trigger = monster_trained("Blocken") && is_primary_breed("Ducken") && is_secondary_breed("Golem") && ducken_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Lost Technology Rediscovered",
    description = "Win the Legend Cup with a Ticken (Ducken/Suezo).",
    points = 10,
    trigger = monster_trained("Ticken") && is_primary_breed("Ducken") && is_secondary_breed("Suezo") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Fun Can Providing So Much Fun",
    description = "Win the Legend Cup with a Ducken (Ducken/Ducken).",
    points = 10,
    trigger = monster_trained("Ducken") && is_primary_breed("Ducken") && is_secondary_breed("Ducken") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "These Are the Better Days",
    description = "Win the Legend Cup with a Watermelony (Ducken/???).",
    points = 10,
    trigger = monster_trained("Watermelony") && is_primary_breed("Ducken") && rare_breed_matches("Watermelony") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Not So Unlucky Now, Are We",
    description = "Win the Legend Cup with a Cawken (Ducken/???).",
    points = 10,
    trigger = monster_trained("Cawken") && is_primary_breed("Ducken") && rare_breed_matches("Cawken") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Plant ====

achievement(
    set = legend_cup_set,
    title = "Queen of FIMBA, Legend of IMa",
    description = "Win the Legend Cup with a Queen Plant (Plant/Pixie).",
    points = 10,
    trigger = monster_trained("Queen Plant") && is_primary_breed("Plant") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Getting Something Out of Nothing",
    description = "Win the Legend Cup with a Rock Plant (Plant/Golem).",
    points = 10,
    trigger = monster_trained("Rock Plant") && is_primary_breed("Plant") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Dream-Illuminating Lights",
    description = "Win the Legend Cup with a Scaled Plant (Plant/Zuum).",
    points = 10,
    trigger = monster_trained("Scaled Plant") && is_primary_breed("Plant") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "This Plant's Got It All!",
    description = "Win the Legend Cup with a Blue Plant (Plant/Tiger).",
    points = 10,
    trigger = monster_trained("Blue Plant") && is_primary_breed("Plant") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Nimble Plant",
    description = "Win the Legend Cup with a Hare Plant (Plant/Hare).",
    points = 10,
    trigger = monster_trained("Hare Plant") && is_primary_breed("Plant") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Styling on the Opposition",
    description = "Win the Legend Cup with a Gold Plant (Plant/Gali).",
    points = 10,
    trigger = monster_trained("Gold Plant") && is_primary_breed("Plant") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No Challenge Is Too Great",
    description = "Win the Legend Cup with an Usaba (Plant/Suezo).",
    points = 10,
    trigger = monster_trained("Usaba") && is_primary_breed("Plant") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Comfortably Numb",
    description = "Win the Legend Cup with a Mirage Plant (Plant/Jell).",
    points = 10,
    trigger = monster_trained("Mirage Plant") && is_primary_breed("Plant") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Victory Via Attrition",
    description = "Win the Legend Cup with a Plant (Plant/Plant).",
    points = 10,
    trigger = monster_trained("Plant") && is_primary_breed("Plant") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Sooty Foliage",
    description = "Win the Legend Cup with a Black Plant (Plant/Monol).",
    points = 10,
    trigger = monster_trained("Black Plant") && is_primary_breed("Plant") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Plant By Any Other Name",
    description = "Win the Legend Cup with a Fly Plant (Plant/Worm).",
    points = 10,
    trigger = monster_trained("Fly Plant") && is_primary_breed("Plant") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Resilient Fauna",
    description = "Win the Legend Cup with a Weeds (Plant/Naga).",
    points = 10,
    trigger = monster_trained("Weeds") && is_primary_breed("Plant") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Loves Raggae and Winning Equally",
    description = "Win the Legend Cup with a Raggae Plant (Plant/???).",
    points = 10,
    trigger = monster_trained("Raggae Plant") && is_primary_breed("Plant") && rare_breed_matches("Raggae Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Monol ====

achievement(
    set = legend_cup_set,
    title = "Smothering All With Kindness",
    description = "Win the Legend Cup with a Romper Wall (Monol/Pixie).",
    points = 10,
    trigger = monster_trained("Romper Wall") && is_primary_breed("Monol") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Most Active Wall",
    description = "Win the Legend Cup with an Obelisk (Monol/Golem).",
    points = 10,
    trigger = monster_trained("Obelisk") && is_primary_breed("Monol") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Noodles Are On It Tonight",
    description = "Win the Legend Cup with a Jura Wall (Monol/Zuum).",
    points = 10,
    trigger = monster_trained("Jura Wall") && is_primary_breed("Monol") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Sleeping Well After That Win",
    description = "Win the Legend Cup with a Blue Sponge (Monol/Tiger).",
    points = 10,
    trigger = monster_trained("Blue Sponge") && is_primary_breed("Monol") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Warmest Wall",
    description = "Win the Legend Cup with a Furred Wall (Monol/Hare).",
    points = 10,
    trigger = monster_trained("Furred Wall") && is_primary_breed("Monol") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Deific Representation",
    description = "Win the Legend Cup with an Ivory Wall (Monol/Gali).",
    points = 10,
    trigger = monster_trained("Ivory Wall") && is_primary_breed("Monol") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Recognizable From a Mile Away",
    description = "Win the Legend Cup with a Sandy (Monol/Suezo).",
    points = 10,
    trigger = monster_trained("Sandy") && is_primary_breed("Monol") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Summertime Champ",
    description = "Win the Legend Cup with an Ice Candy (Monol/Jell).",
    points = 10,
    trigger = monster_trained("Ice Candy") && is_primary_breed("Monol") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Soil Gave It Strength",
    description = "Win the Legend Cup with a New Leaf (Monol/Plant).",
    points = 10,
    trigger = monster_trained("New Leaf") && is_primary_breed("Monol") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Parts Stronger Than the Whole",
    description = "Win the Legend Cup with a Monol (Monol/Monol).",
    points = 10,
    trigger = monster_trained("Monol") && is_primary_breed("Monol") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "I Swear The Walls Have Eyes!",
    description = "Win the Legend Cup with a Soboros (Monol/Worm).",
    points = 10,
    trigger = monster_trained("Soboros") && is_primary_breed("Monol") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Ant-Proof",
    description = "Win the Legend Cup with an Asphaltum (Monol/Naga).",
    points = 10,
    trigger = monster_trained("Asphaltum") && is_primary_breed("Monol") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Rise of Darth Monol",
    description = "Win the Legend Cup with a Galaxy (Monol/???).",
    points = 10,
    trigger = monster_trained("Galaxy") && is_primary_breed("Monol") && rare_breed_matches("Galaxy") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No One Can Stop Mr. Domino",
    description = "Win the Legend Cup with a Dominos (Monol/???).",
    points = 10,
    trigger = monster_trained("Dominos") && is_primary_breed("Monol") && rare_breed_matches("Dominos") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Performed Better On The Wall",
    description = "Win the Legend Cup with a Scribble (Monol/???).",
    points = 10,
    trigger = monster_trained("Scribble") && is_primary_breed("Monol") && rare_breed_matches("Scribble") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Ape ====

achievement(
    set = legend_cup_set,
    title = "Stone Statue",
    description = "Win the Legend Cup with a Rock Ape (Ape/Golem).",
    points = 10,
    trigger = monster_trained("Rock Ape") && is_primary_breed("Ape") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Honest Techniques Only",
    description = "Win the Legend Cup with a Gibberer (Ape/Hare).",
    points = 10,
    trigger = monster_trained("Gibberer") && is_primary_breed("Ape") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Lazy Yet Capable",
    description = "Win the Legend Cup with a Bossy (Ape/Gali).",
    points = 10,
    trigger = monster_trained("Bossy") && is_primary_breed("Ape") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Using Natural Funk to Its Advantage",
    description = "Win the Legend Cup with a Tropical Ape (Ape/Plant).",
    points = 10,
    trigger = monster_trained("Tropical Ape") && is_primary_breed("Ape") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Unparalleled Laziness",
    description = "Win the Legend Cup with an Ape (Ape/Ape).",
    points = 10,
    trigger = monster_trained("Ape") && is_primary_breed("Ape") && is_secondary_breed("Ape") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Warhol & Nico Special",
    description = "Win the Legend Cup with a Gold Dust (Ape/???).",
    points = 10,
    trigger = monster_trained("Gold Dust") && is_primary_breed("Ape") && rare_breed_matches("Gold Dust") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Worm====

achievement(
    set = legend_cup_set,
    title = "Rare Beauty",
    description = "Win the Legend Cup with a Red Worm (Worm/Pixie).",
    points = 10,
    trigger = monster_trained("Red Worm") && is_primary_breed("Worm") && is_secondary_breed("Pixie") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Coveted Eyes",
    description = "Win the Legend Cup with a Rock Worm (Worm/Golem).",
    points = 10,
    trigger = monster_trained("Rock Worm") && is_primary_breed("Worm") && is_secondary_breed("Golem") && worm_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Didn't Even Need Its Legs",
    description = "Win the Legend Cup with a Scaled Worm (Worm/Zuum).",
    points = 10,
    trigger = monster_trained("Scaled Worm") && is_primary_breed("Worm") && is_secondary_breed("Zuum") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tusks to Be Feared",
    description = "Win the Legend Cup with a Drill Tusk (Worm/Tiger).",
    points = 10,
    trigger = monster_trained("Drill Tusk") && is_primary_breed("Worm") && is_secondary_breed("Tiger") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Orayo!",
    description = "Win the Legend Cup with a Corone (Worm/Hare).",
    points = 10,
    trigger = monster_trained("Corone") && is_primary_breed("Worm") && is_secondary_breed("Hare") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Tougher Than Advertised",
    description = "Win the Legend Cup with a Mask Worm (Worm/Gali).",
    points = 10,
    trigger = monster_trained("Mask Worm") && is_primary_breed("Worm") && is_secondary_breed("Gali") && worm_unlocked() && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Good Luck Finding the Real Eye",
    description = "Win the Legend Cup with an Eye Worm (Worm/Suezo).",
    points = 10,
    trigger = monster_trained("Eye Worm") && is_primary_breed("Worm") && is_secondary_breed("Suezo") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Flabby Body Saving the Day",
    description = "Win the Legend Cup with a Jelly Worm (Worm/Jell).",
    points = 10,
    trigger = monster_trained("Jelly Worm") && is_primary_breed("Worm") && is_secondary_breed("Jell") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Red and Blue Contrasting Well",
    description = "Win the Legend Cup with a Flower Worm (Worm/Plant).",
    points = 10,
    trigger = monster_trained("Flower Worm") && is_primary_breed("Worm") && is_secondary_breed("Plant") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Carrying Itself to Victory",
    description = "Win the Legend Cup with a Black Worm (Worm/Monol).",
    points = 10,
    trigger = monster_trained("Black Worm") && is_primary_breed("Worm") && is_secondary_breed("Monol") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "No Weaknesses Found",
    description = "Win the Legend Cup with a Worm (Worm/Worm).",
    points = 10,
    trigger = monster_trained("Worm") && is_primary_breed("Worm") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "The Shiny Eyes Are Still Scary",
    description = "Win the Legend Cup with a Purple Worm (Worm/Naga).",
    points = 10,
    trigger = monster_trained("Purple Worm") && is_primary_breed("Worm") && is_secondary_breed("Naga") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "This Express is Licensed to Ill",
    description = "Win the Legend Cup with an Express Worm (Worm/???).",
    points = 10,
    trigger = monster_trained("Express Worm") && is_primary_breed("Worm") && rare_breed_matches("Express Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Naga ====

achievement(
    set = legend_cup_set,
    title = "Almost Forgot It Was a Monster",
    description = "Win the Legend Cup with a Ripper (Naga/Pixie).",
    points = 10,
    trigger = monster_trained("Ripper") && is_primary_breed("Naga") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "A Single Strike Won It All",
    description = "Win the Legend Cup with a Trident (Naga/Golem).",
    points = 10,
    trigger = monster_trained("Trident") && is_primary_breed("Naga") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Blowing Raspberries at the Competition",
    description = "Win the Legend Cup with a Stinger (Naga/Zuum).",
    points = 10,
    trigger = monster_trained("Stinger") && is_primary_breed("Naga") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Rare Obedience",
    description = "Win the Legend Cup with a Striker (Naga/Tiger).",
    points = 10,
    trigger = monster_trained("Striker") && is_primary_breed("Naga") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Don't Cut Yourself on That Edge",
    description = "Win the Legend Cup with an Edgehog (Naga/Hare).",
    points = 10,
    trigger = monster_trained("Edgehog") && is_primary_breed("Naga") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Slow and Steady Wins the Fight",
    description = "Win the Legend Cup with a Bazula (Naga/Gali).",
    points = 10,
    trigger = monster_trained("Bazula") && is_primary_breed("Naga") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "It Agreed To This One Goal",
    description = "Win the Legend Cup with a Cyclops (Naga/Suezo).",
    points = 10,
    trigger = monster_trained("Cyclops") && is_primary_breed("Naga") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Adopting a Slithery Form",
    description = "Win the Legend Cup with an Aqua Cutter (Naga/Jell).",
    points = 10,
    trigger = monster_trained("Aqua Cutter") && is_primary_breed("Naga") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Broke the Cycle of Jungle Hunting",
    description = "Win the Legend Cup with a Jungler (Naga/Plant).",
    points = 10,
    trigger = monster_trained("Jungler") && is_primary_breed("Naga") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "In For a Long Fight",
    description = "Win the Legend Cup with a Crimson Eyed (Naga/Monol).",
    points = 10,
    trigger = monster_trained("Crimson Eyed") && is_primary_breed("Naga") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Nature's Strongest Protector",
    description = "Win the Legend Cup with an Earth Keeper (Naga/Worm).",
    points = 10,
    trigger = monster_trained("Earth Keeper") && is_primary_breed("Naga") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "Cruel and Unusual Tactics",
    description = "Win the Legend Cup with a Naga (Naga/Naga).",
    points = 10,
    trigger = monster_trained("Naga") && is_primary_breed("Naga") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    set = legend_cup_set,
    title = "One Step Closer to Immortality",
    description = "Win the Legend Cup with a Time Noise (Naga/???).",
    points = 10,
    trigger = monster_trained("Time Noise") && is_primary_breed("Naga") && rare_breed_matches("Time Noise") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)