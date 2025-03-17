// Monster Rancher 2 [Subset - 389 Legend Cup Champions]
// #ID = 32120
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
    return byte(0x09923c) == 0x66 ||
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
        byte(0x099288) == 0x66
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

// for dragon: check that the tournament is on the calendar
function dragon_unlocked() => byte(0x099078) == 0x1c && byte(0x099387) == 0x01
// for centaur: check that the flags around getting a spear have been hit
function centaur_unlocked() => byte(0x099359) == 0x00 && byte(0x09935a) == 0x00 && byte(0x99388) == 0x01
// for beaclon, nothing really good except checking stat screen to make sure one's been raised
function beaclon_unlocked() => word(0x98fe6) > 0 && byte(0x9938a) == 0x01
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function henger_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && byte(0x9938b) == 0x01
// check that they got the doll and it moved on ranch
function wracky_unlocked() => byte(0x99350) == 0x00 && byte(0x99351) == 0x00 && byte(0x9938c) == 0x01
// check that stable is at least level 1
function golem_unlocked() => (byte(0x98fc2) == 0x01 || byte(0x98fc2) == 0x02) && byte(0x9938d) == 0x01
// check that the durahan invitational is on calendar
function durahan_unlocked() => byte(0x99079) == 0x16 && byte(0x99338) == 0x00 && byte(0x9938f) == 0x01
// check that stable is at least level 1
function baku_unlocked() => (byte(0x98fc2) == 0x01 || byte(0x98fc2) == 0x02) && byte(0x99394) == 0x01
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function gali_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && byte(0x99395) == 0x01
// check that they've been told about what zilla beard do
function zilla_unlocked() => byte(0x099340) == 0x00 && byte(0x099341) == 0x00 && byte(0x099342) == 0x00 && byte(0x99397) == 0x01
// check that binto forked the pot over
function bajarl_unlocked() => byte(0x99316) == 0x00 && byte(0x99398) == 0x01
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function mew_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && byte(0x99399) == 0x01
// there SHOULD be a flag for phoenix feather having been found, but I haven't needed it till now
// in lieu, check that they went to phoenix volcano (have gone on an expedition ever)
function phoenix_unlocked() => byte(0x9932c) == 0x00 && byte(0x9939a) == 0x01
// check that pabs has yelled about the altar being a mess
function ghost_unlocked() => byte(0x9933d) == 0x00 && byte(0x9939b) == 0x01
// check that metalner has visited from afar
function metalner_unlocked() => byte(0x09935e) == 0x00 && byte(0x09935f) == 0x00 && byte(0x099360) == 0x00 && byte(0x099367) == 0x00 && byte(0x9939c) == 0x01
// check that pabs put on the mask
function joker_unlocked() => byte(0x9934a) == 0x00 && byte(0x993a0) == 0x01
// both undine and niton, check that the player's got a hot springs
function undine_unlocked() => byte(0x99356) == 0x00 && byte(0x993a3) == 0x01
function niton_unlocked() => byte(0x99356) == 0x00 && byte(0x993a4) == 0x01
// check that tree on ranch died
function mock_unlocked() => byte(0x993ac) == 0x0b && byte(0x993a5) == 0x01
// check that they've been to the shrine after going to IMa vs. FIMBA at least once
function worm_unlocked() => byte(0x99312) == 0x00 && byte(0x99358) == 0x00 && byte(0x993aa) == 0x01
// check that player's gotten at least one fun can and that they've got strong glue in inventory
// NOTE: strong glue cannot be sold, meaning that if it's gone and they have a ducken they cheated it out
// TODO make strong glue check work
function ducken_unlocked() => byte(0x99322) == 0x00 && byte(0x993a6) == 0x01 && inventory_contains_glue()
// check that player has seen Bighand
function jill_unlocked() => byte(0x099344) == 0x00 && byte(0x09921d) == 0x01 && byte(0x9939e) == 0x01 

function m1_grand_prix_won() => byte(0x97a80) == 0x01
function greatest_4_won() => byte(0x97a84) == 0x01
function world_monsters_cup_won() => byte(0x97a88) == 0x01
function winners_cup_won() => byte(0x97a8c) == 0x01
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


// TODO add check for if card is flagged
// cards run from 0x9908c -> 0x99223, byte each

function prereq_tournaments_won() => m1_grand_prix_won() && winners_cup_won() && greatest_4_won() && world_monsters_cup_won()
function correct_date() => current_month() == 0x04 && current_week() == 0x04
function prereqs_met() => prereq_tournaments_won() && correct_date() && (current_tournament() == 0x4e || current_tournament() == 0x4f) 

// ==== Pixie ====

achievement(
    title = "Spoiled but Not Powerless",
    description = "Win the Legend Cup with a Pixie (Pixie/Pixie).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "High Pride",
    description = "Win the Legend Cup with a Daina (Pixie/Dragon).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Dragon") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Unico vs. The World",
    description = "Win the Legend Cup with a Unico (Pixie/Centaur).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Centaur") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Little Tease",
    description = "Win the Legend Cup with a Jilt (Pixie/Wracky).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Wracky") && prereqs_met() && wracky_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Strong-Willed",
    description = "Win the Legend Cup with a Granity (Pixie/Golem).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Golem") && prereqs_met() && golem_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Welcome to the Jungle",
    description = "Win the Legend Cup with a Dixie (Pixie/Zuum).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Brave Yet Delicate",
    description = "Win the Legend Cup with a Janne (Pixie/Durahan).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Durahan") && prereqs_met() && durahan_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Poster Girl",
    description = "Win the Legend Cup with a Mint (Pixie/Tiger).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Constellation of Legends",
    description = "Win the Legend Cup with a Lepus (Pixie/Hare).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Today There Is No Mercy",
    description = "Win the Legend Cup with an Angel (Pixie/Gali).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Gali") && prereqs_met() && gali_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Second Musical Now in the Works",
    description = "Win the Legend Cup with a Kitten (Pixie/Kato).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Sloppy, but Efficient",
    description = "Win the Legend Cup with a Jinnee (Pixie/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Bajarl") && prereqs_met() && bajarl_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "This Is Our Future",
    description = "Win the Legend Cup with a Futurity (Pixie/Metalner).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Metalner") && prereqs_met() && metalner_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Dr. Maccots Greatest Discovery",
    description = "Win the Legend Cup with a Vanity (Pixie/Suezo).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Northern Legend",
    description = "Win the Legend Cup with a Snowy (Pixie/Jill).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Jill") && prereqs_met() && jill_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Little Witch",
    description = "Win the Legend Cup with a Lilim (Pixie/Joker).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Joker") && prereqs_met() && joker_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Nagisa Skin",
    description = "Win the Legend Cup with a Nagisa (Pixie/Jell).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Forest Dweller",
    description = "Win the Legend Cup with a Dryad (Pixie/Mock).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Mock") && prereqs_met() && mock_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Time to Soak Some Rays",
    description = "Win the Legend Cup with a Serenity (Pixie/Plant).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Shield No Longer Needed",
    description = "Win the Legend Cup with a Silhouette (Pixie/Monol).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Beauty Is in the Eye of the Beholder",
    description = "Win the Legend Cup with a Night Flyer (Pixie/Worm).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Worm") && prereqs_met() && worm_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Vampiric Tendencies",
    description = "Win the Legend Cup with an Allure (Pixie/Naga).",
    points = 10,
    trigger = is_primary_breed("Pixie") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ??? pixies
achievement(
    title = "Power of the Red Pill",
    description = "Win the Legend Cup with a Poison (Pixie/???).",
    points = 10,
    trigger = rare_breed_matches("Poison") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Pixie of Destiny",
    description = "Win the Legend Cup with a Kasumi (Pixie/???).",
    points = 10,
    trigger = rare_breed_matches("Kasumi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Woman in Mia",
    description = "Win the Legend Cup with a Mia (Pixie/???).",
    points = 10,
    trigger = rare_breed_matches("Mia") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Dragon ====

achievement(
    title = "Uncontested Strength",
    description = "Win the Legend Cup with a Tiamat (Dragon/Pixie).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Pixie") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "One of the Few",
    description = "Win the Legend Cup with a Dragon (Dragon/Dragon).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Dragon") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Foreign Legend",
    description = "Win the Legend Cup with a Corkasus (Dragon/Beaclon).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Beaclon") && prereqs_met() && dragon_unlocked() && beaclon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Mix All The Tech!",
    description = "Win the Legend Cup with a Tecno Dragon (Dragon/Henger).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Henger") && prereqs_met() && dragon_unlocked() && henger_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Destructive Power On Display",
    description = "Win the Legend Cup with a Stone Dragon (Dragon/Golem).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Golem") && prereqs_met() && dragon_unlocked() && golem_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Relic of a Bygone Era",
    description = "Win the Legend Cup with an Armor Dragon (Dragon/Durahan).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Durahan") && prereqs_met() && dragon_unlocked() && durahan_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Lakeside Ruler",
    description = "Win the Legend Cup with a Crab Dragon (Dragon/Arrow Head).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Arrow Head") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It's Gonna Hide the Cup",
    description = "Win the Legend Cup with a Hound Dragon (Dragon/Tiger).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Tiger") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Like Holography",
    description = "Win the Legend Cup with a Gariel (Dragon/Gali).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Gali") && prereqs_met() && dragon_unlocked() && gali_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Oil Pot King",
    description = "Win the Legend Cup with an Oscerot (Dragon/Kato).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Kato") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Thankfully, Nobody Brought Bombs",
    description = "Win the Legend Cup with a Dodongo (Dragon/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Kato") && prereqs_met() && dragon_unlocked() && bajarl_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Mysterious Futuristic Power",
    description = "Win the Legend Cup with a Gidras (Dragon/Metalner).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Kato") && prereqs_met() && dragon_unlocked() && metalner_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Back with a Vengeance",
    description = "Win the Legend Cup with a Death Dragon (Dragon/Joker).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Kato") && prereqs_met() && dragon_unlocked() && joker_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Apocalypse Bringer",
    description = "Win the Legend Cup with a Ragnaroks (Dragon/Monol).",
    points = 10,
    trigger = is_primary_breed("Dragon") && is_secondary_breed("Kato") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Moo-low Gold",
    description = "Win the Legend Cup with a Moo (Dragon/???).",
    points = 10,
    trigger = rare_breed_matches("Moo") && prereqs_met() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Centaur ====

achievement(
    title = "Fast & Ferious",
    description = "Win the Legend Cup with a Ferious (Centaur/Pixie).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Pixie") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Brave and Just",
    description = "Win the Legend Cup with a Dragoon (Centaur/Dragon).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Dragon") && prereqs_met() && centaur_unlocked() && dragon_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "They've Got it All",
    description = "Win the Legend Cup with a Centaur (Centaur/Centaur).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Centaur") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Who Gave the Moai a Spear?",
    description = "Win the Legend Cup with a Trojan (Centaur/Golem).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Golem") && prereqs_met() && centaur_unlocked() && golem_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Two Souls Means Two Legends",
    description = "Win the Legend Cup with a Chariot (Centaur/Durahan).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Durahan") && prereqs_met() && centaur_unlocked() && durahan_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Semi-Aquatic Fighter",
    description = "Win the Legend Cup with an Antares (Centaur/Arrow Head).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Arrow Head") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Lonely Warrior",
    description = "Win the Legend Cup with a Celious (Centaur/Tiger).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Tiger") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Free Spirited",
    description = "Win the Legend Cup with a Bazoo (Centaur/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Bajarl") && prereqs_met() && centaur_unlocked() && bajarl_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No Love for the Creator",
    description = "Win the Legend Cup with a Reaper (Centaur/Joker).",
    points = 10,
    trigger = is_primary_breed("Centaur") && is_secondary_breed("Joker") && prereqs_met() && centaur_unlocked() && joker_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Thoroughbred Runner",
    description = "Win the Legend Cup with a Trotter (Centaur/???).",
    points = 10,
    trigger = rare_breed_matches("Trotter") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Under the Table and Dreaming",
    description = "Win the Legend Cup with a Blue Thunder (Centaur/???).",
    points = 10,
    trigger = rare_breed_matches("Blue Thunder") && prereqs_met() && centaur_unlocked() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== ColorPandora ====

achievement(
    title = "Loud and Proud",
    description = "Win the Legend Cup with a PeachTreeBug (ColorPandora/Pixie).",
    points = 10,
    trigger = is_primary_breed("ColorPandora") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Victory, Love and Effort Prevail",
    description = "Win the Legend Cup with a ColorPandora (ColorPandora/ColorPandora).",
    points = 10,
    trigger = is_primary_breed("ColorPandora") && is_secondary_breed("ColorPandora") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Perfectly Camouflauged",
    description = "Win the Legend Cup with a Liquid Cube (ColorPandora/Jell).",
    points = 10,
    trigger = is_primary_breed("ColorPandora") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Devilish Dice",
    description = "Win the Legend Cup with a Dice (ColorPandora/???).",
    points = 10,
    trigger = rare_breed_matches("Dice") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Downtown Tram",
    description = "Win the Legend Cup with a Tram (ColorPandora/???).",
    points = 10,
    trigger = rare_breed_matches("Tram") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Beaclon ====

achievement(
    title = "Death's Dance",
    description = "Win the Legend Cup with a Bethelgeus (Beaclon/Dragon).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Dragon") && beaclon_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Brute Forced It",
    description = "Win the Legend Cup with a Beaclon (Beaclon/Beaclon).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Beaclon") && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Pre-Henger Prototype",
    description = "Win the Legend Cup with a Melcarba (Beaclon/Henger).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Henger") && beaclon_unlocked() && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Rock On, Rocklon",
    description = "Win the Legend Cup with a Rocklon (Beaclon/Golem).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Golem") && beaclon_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Captaining an Army of One",
    description = "Win the Legend Cup with a Centurion (Beaclon/Durahan).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Durahan") && beaclon_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Minimal Effort Expenditure",
    description = "Win the Legend Cup with a Sloth Beetle (Beaclon/Tiger).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Tiger") && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Top Tier Transit",
    description = "Win the Legend Cup with a KautRoarKaut (Beaclon/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Bajarl") && beaclon_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Fights Like Jagger",
    description = "Win the Legend Cup with a Jaggernaut (Beaclon/Joker).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Joker") && beaclon_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tightly Wound",
    description = "Win the Legend Cup with a Ducklon (Beaclon/Ducken).",
    points = 10,
    trigger = is_primary_breed("Beaclon") && is_secondary_breed("Ducken") && beaclon_unlocked() && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Food Waste Ain't For Legends",
    description = "Win the Legend Cup with an Eggplantern (Beaclon/???).",
    points = 10,
    trigger = rare_breed_matches("Eggplantern") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Henger ====

achievement(
    title = "Phantom Robotics",
    description = "Win the Legend Cup with a Garlant (Henger/Dragon).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Dragon") && henger_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Fresh Start, Fresh Legend",
    description = "Win the Legend Cup with a Henger (Henger/Henger).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Henger") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Rocky Soul",
    description = "Win the Legend Cup with a Gaia (Henger/Golem).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Golem") && henger_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Alpha and the Omega",
    description = "Win the Legend Cup with an Omega (Henger/Zuum).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Zuum") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Airborne Speedster",
    description = "Win the Legend Cup with a Heuy (Henger/Metalner).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Metalner") && henger_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Evil Predispositions",
    description = "Win the Legend Cup with an End Bringer (Henger/Joker).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Joker") && henger_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The First Henger",
    description = "Win the Legend Cup with an Automaton (Henger/Mock).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Mock") && henger_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Under the Full Moon",
    description = "Win the Legend Cup with a Black Henger (Henger/Monol).",
    points = 10,
    trigger = is_primary_breed("Henger") && is_secondary_breed("Monol") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Mechanical Animal",
    description = "Win the Legend Cup with a Skeleton (Henger/???).",
    points = 10,
    trigger = rare_breed_matches("Skeleton") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Wracky ====

achievement(
    title = "Baby-Doll Eyes Did Work",
    description = "Win the Legend Cup with a Baby Doll (Wracky/Pixie).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Pixie") && wracky_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Prime Collector Material",
    description = "Win the Legend Cup with a Draco Doll (Wracky/Dragon).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Dragon") && wracky_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Buzz Lighthenger",
    description = "Win the Legend Cup with a Henger Doll (Wracky/Henger).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Henger") && wracky_unlocked() && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Charles Becoming a Household Name",
    description = "Win the Legend Cup with a Wracky (Wracky/Wracky).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Wracky") && wracky_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Little Too Authentic",
    description = "Win the Legend Cup with a Pebbly (Wracky/Golem).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Golem") && wracky_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Small Knight, Significant Value",
    description = "Win the Legend Cup with a Petit Knight (Wracky/Durahan).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Durahan") && wracky_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No Take-Bakkys!",
    description = "Win the Legend Cup with a Bakky (Wracky/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Bajarl") && wracky_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Favorite Amongst the Children",
    description = "Win the Legend Cup with a Metal Glay (Wracky/Metalner).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Metalner") && wracky_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Do Not Trust the Clown Doll",
    description = "Win the Legend Cup with a Tricker (Wracky/Joker).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Joker") && wracky_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It's Not Cheap, It's Cost Effective",
    description = "Win the Legend Cup with a Mocky (Wracky/Mock).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Mock") && wracky_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "All I Want for Christmas Is This Doll",
    description = "Win the Legend Cup with a Satan Clause (Wracky/???).",
    points = 10,
    trigger = rare_breed_matches("Skeleton") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Golem ====

achievement(
    title = "Pacifist at Heart",
    description = "Win the Legend Cup with a Pink Golem (Golem/Pixie).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Pixie") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Grounded in Reality",
    description = "Win the Legend Cup with a Tyrant (Golem/Dragon).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Dragon") && golem_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Horn's Just For Show",
    description = "Win the Legend Cup with a Strong Horn (Golem/Beaclon).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Beaclon") && golem_unlocked() && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Ancient War Weapon",
    description = "Win the Legend Cup with a Gobi (Golem/Henger).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Henger") && golem_unlocked() && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tell Me I Looked Cool Out There",
    description = "Win the Legend Cup with a Mariomax (Golem/Wracky).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Wracky") && golem_unlocked() && wracky_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "One Punch to Rule Them All",
    description = "Win the Legend Cup with a Golem (Golem/Golem).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Desirable Scales",
    description = "Win the Legend Cup with a Scaled Golem (Golem/Zuum).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Zuum") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Sentient Armor",
    description = "Win the Legend Cup with a Battle Rocks (Golem/Durahan).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Durahan") && golem_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Body Built for Anything",
    description = "Win the Legend Cup with a Dagon (Golem/Arrow Head).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Durahan") && golem_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Nevermeltice",
    description = "Win the Legend Cup with a Big Blue (Golem/Tiger).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Tiger") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Turning Point in Our History",
    description = "Win the Legend Cup with a Moaigon (Golem/Hare).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Hare") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Sedentary Sleepyhead",
    description = "Win the Legend Cup with a Sleepyhead (Golem/Baku).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Baku") && golem_unlocked() && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Noble's Best Friend",
    description = "Win the Legend Cup with an Amenhotep (Golem/Gali).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Gali") && golem_unlocked() && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "In A Weight Class of its Own",
    description = "Win the Legend Cup with a Pressure (Golem/Zilla).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Zilla") && golem_unlocked() && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Perfect Data Access Object Reference",
    description = "Win the Legend Cup with a Dao (Golem/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Bajarl") && golem_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Starbound",
    description = "Win the Legend Cup with an Astro (Golem/Metalner).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Metalner") && golem_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Celebrating With Curry Rice",
    description = "Win the Legend Cup with a Titan (Golem/Suezo).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Suezo") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "I'm the Joker Now",
    description = "Win the Legend Cup with an Angolmor (Golem/Joker).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Joker") && golem_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "This Sea God's Better on Land",
    description = "Win the Legend Cup with a Poseidon (Golem/Jell).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Jell") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Straight Faced Champion",
    description = "Win the Legend Cup with a Wood Golem (Golem/Mock).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Mock") && golem_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "God of Nature",
    description = "Win the Legend Cup with an Ecologuardia (Golem/Plant).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Plant") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Big Brother Is Watching",
    description = "Win the Legend Cup with a Black Golem (Golem/Monol).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Monol") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Bearer of Ancient Scriptures",
    description = "Win the Legend Cup with a Magna (Golem/Worm).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Worm") && golem_unlocked() && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Pure Offense",
    description = "Win the Legend Cup with a Marble Guy (Golem/Naga).",
    points = 10,
    trigger = is_primary_breed("Golem") && is_secondary_breed("Naga") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tecmo Bowl MVP",
    description = "Win the Legend Cup with a ForwardGolem (Golem/???).",
    points = 10,
    trigger = rare_breed_matches("ForwardGolem") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Zuum ====

achievement(
    title = "Wings Not Needed to Win",
    description = "Win the Legend Cup with a FairySaurian (Zuum/Pixie).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Explosively Violent",
    description = "Win the Legend Cup with a Salamander (Zuum/Dragon).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Do the Move Good and Fast",
    description = "Win the Legend Cup with a Rock Saurian (Zuum/Golem).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Natural Evolution of Dino",
    description = "Win the Legend Cup with a Zuum (Zuum/Zuum).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Natural Triathlon Candidate",
    description = "Win the Legend Cup with a Crab Saurian (Zuum/Arrow Head).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Arrow Head") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Greatest Delivery Monster",
    description = "Win the Legend Cup with a HoundSaurian (Zuum/Tiger).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Selective Bravery",
    description = "Win the Legend Cup with a Spot Saurian (Zuum/Hare).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Smartest Zuum in the Room",
    description = "Win the Legend Cup with a Hachiro (Zuum/Baku).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Baku") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Status Symbol",
    description = "Win the Legend Cup with a NobleSaurian (Zuum/Gali).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Might Is Right",
    description = "Win the Legend Cup with a Tasman (Zuum/Kato).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Loves the Coarse and Rough Sand",
    description = "Win the Legend Cup with a Sand Saurian (Zuum/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Fully Committed Prankster",
    description = "Win the Legend Cup with a Mustardy (Zuum/Suezo).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Mezmerising Patterns",
    description = "Win the Legend Cup with a Basilisk (Zuum/Joker).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Prehistoric Gel",
    description = "Win the Legend Cup with a JellySaurian (Zuum/Jell).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Even Cowards Can Be Legends",
    description = "Win the Legend Cup with a Wood Saurian (Zuum/Mock).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Bridal Beast",
    description = "Win the Legend Cup with an AlohaSaurian (Zuum/Plant).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Fashionista",
    description = "Win the Legend Cup with a BlackSaurian (Zuum/Monol).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Loyal Steed",
    description = "Win the Legend Cup with a ShellSaurian (Zuum/Worm).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Inherited Anger",
    description = "Win the Legend Cup with a Naga Saurian (Zuum/Naga).",
    points = 10,
    trigger = is_primary_breed("Zuum") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Waste of Mind",
    description = "Win the Legend Cup with a ZebraSaurian (Zuum/???).",
    points = 10,
    trigger = is_primary_breed("Zuum") && rare_breed_matches("ZebraSaurian") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Durahan ====

achievement(
    title = "Equal Opportunity Fighting",
    description = "Win the Legend Cup with a Leziena (Durahan/Pixie).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Pixie") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Powered by the Dragon Head",
    description = "Win the Legend Cup with a Vesuvius (Durahan/Dragon).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Dragon") && durahan_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Winning Unscathed",
    description = "Win the Legend Cup with a Hercules (Durahan/Beaclon).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Beaclon") && durahan_unlocked() && beaclon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Anything but Normal",
    description = "Win the Legend Cup with a Kelmadics (Durahan/Golem).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Golem") && durahan_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Armor With a Drive to Win",
    description = "Win the Legend Cup with a Durahan (Durahan/Durahan).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Durahan") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Crustaceous Armor",
    description = "Win the Legend Cup with a Lorica (Durahan/Arrow Head).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Arrow Head") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Molded By the Tiger",
    description = "Win the Legend Cup with a Hound Knight (Durahan/Tiger).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Tiger") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Garuda's Back With a Vengeance",
    description = "Win the Legend Cup with a Garuda (Durahan/Phoenix).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Phoenix") && durahan_unlocked() && phoenix_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Brought a Laser Sword to a Fist Fight",
    description = "Win the Legend Cup with a Metal Glory (Durahan/Metalner).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Metalner") && durahan_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Cursed Armaments",
    description = "Win the Legend Cup with a Genocider (Durahan/Joker).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Joker") && durahan_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Forgot to Replace My Starter Equipment",
    description = "Win the Legend Cup with a Wood Knight (Durahan/Mock).",
    points = 10,
    trigger = is_primary_breed("Durahan") && is_secondary_breed("Mock") && durahan_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Musashi's Continued Legacy",
    description = "Win the Legend Cup with a Shogun (Durahan/???).",
    points = 10,
    trigger = is_primary_breed("Durahan") && rare_breed_matches("Shogun") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Third Eye Blind",
    description = "Win the Legend Cup with a Ruby Knight (Durahan/???).",
    points = 10,
    trigger = is_primary_breed("Durahan") && rare_breed_matches("Ruby Knight") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "I'll Make a Monster Out of You",
    description = "Win the Legend Cup with a Kokushi Muso (Durahan/???).",
    points = 10,
    trigger = is_primary_breed("Durahan") && rare_breed_matches("Kokushi Muso") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Arrow Head ====

achievement(
    title = "Yet Another Take on the Henger",
    description = "Win the Legend Cup with a Renocraft (Arrow Head/Henger).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && is_secondary_breed("Henger") && henger_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Night Owl",
    description = "Win the Legend Cup with a Priarocks (Arrow Head/Golem).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Medieval Vaporware",
    description = "Win the Legend Cup with a Plated Arrow (Arrow Head/Durahan).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && is_secondary_breed("Durahan") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Endurance Battler",
    description = "Win the Legend Cup with an Arrow Head (Arrow Head/Arrow Head).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && is_secondary_breed("Arrow Head") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Is the Happy, Not the Sadness!",
    description = "Win the Legend Cup with a MustardArrow (Arrow Head/Suezo).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Death By A Thousand Thorns",
    description = "Win the Legend Cup with a Selketo (Arrow Head/Joker).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Imflammable Oak",
    description = "Win the Legend Cup with a Log Sawer (Arrow Head/Mock).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "We've Come A Long Way",
    description = "Win the Legend Cup with a Sumopion (Arrow Head/???).",
    points = 10,
    trigger = is_primary_breed("Arrow Head") && rare_breed_matches("Sumopion") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Tiger ====

achievement(
    title = "Work Hard, Play Harder",
    description = "Win the Legend Cup with a Daton (Tiger/Pixie).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Granite Hound",
    description = "Win the Legend Cup with a Rock Hound (Tiger/Golem).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Definitely a Triceratops",
    description = "Win the Legend Cup with a Datonare (Tiger/Zuum).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Ordinary Legend",
    description = "Win the Legend Cup with a Tiger (Tiger/Tiger).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "This One's a Keeper",
    description = "Win the Legend Cup with a Hare Hound (Tiger/Hare).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Dignified Fighter",
    description = "Win the Legend Cup with a Balon (Tiger/Gali).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Depth Perception Is a Crutch",
    description = "Win the Legend Cup with a Mono Eyed (Tiger/Suezo).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Cooler Wind Blows",
    description = "Win the Legend Cup with a Jelly Hound (Tiger/Jell).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Reppin' the South Side",
    description = "Win the Legend Cup with a Tropical Dog (Tiger/Plant).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Terrorizing the Ranks",
    description = "Win the Legend Cup with a Terror Dog (Tiger/Monol).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Can Do This With Half My Eyes Closed!",
    description = "Win the Legend Cup with a Jagd Hound (Tiger/Worm).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Further Fueling the Prohibition",
    description = "Win the Legend Cup with a Cabalos (Tiger/Naga).",
    points = 10,
    trigger = is_primary_breed("Tiger") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Nobody Can Dance With Wolves",
    description = "Win the Legend Cup with a White Hound (Tiger/???).",
    points = 10,
    trigger = is_primary_breed("Tiger") && rare_breed_matches("White Hound") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Hopper ====

achievement(
    title = "Jumping to Victory",
    description = "Win the Legend Cup with a Fairy Hopper (Hopper/Pixie).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Hopper of the Peaple",
    description = "Win the Legend Cup with a Draco Hopper (Hopper/Dragon).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Do Not Touch the Horn",
    description = "Win the Legend Cup with a Skipper (Hopper/Tiger).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Naughty Little Guy",
    description = "Win the Legend Cup with a Hopper (Hopper/Hopper).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Hopper") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Win for One Is a Win for All",
    description = "Win the Legend Cup with a Mustachios (Hopper/Kato).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Probably Eating the Cup After",
    description = "Win the Legend Cup with an Emerald Eye (Hopper/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Lustrous Future",
    description = "Win the Legend Cup with a Springer (Hopper/Metalner).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Metalner") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Sees All",
    description = "Win the Legend Cup with a Rear Eyed (Hopper/Suezo).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Real Trendsetter",
    description = "Win the Legend Cup with a Snow Hopper (Hopper/Jill).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Jill") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Too Much of a Good Thing",
    description = "Win the Legend Cup with a Pink Hopper (Hopper/Mocchi).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Mocchi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Self-Centered Fighter",
    description = "Win the Legend Cup with a Sneak Hopper (Hopper/Joker).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No Bark, All Bite",
    description = "Win the Legend Cup with a Woody Hopper (Hopper/Mock).",
    points = 10,
    trigger = is_primary_breed("Hopper") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Deep Cover Hopper",
    description = "Win the Legend Cup with a Frog Hopper (Hopper/???).",
    points = 10,
    trigger = is_primary_breed("Hopper") && rare_breed_matches("Frog Hopper") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Hare ====

achievement(
    title = "Self-Conscious Legend",
    description = "Win the Legend Cup with a Fairy Hare (Hare/Pixie).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Dexterity Made Optional",
    description = "Win the Legend Cup with a Rocky Fur (Hare/Golem).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Jumped to the Top",
    description = "Win the Legend Cup with a Scaled Hare (Hare/Zuum).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Chic Hare",
    description = "Win the Legend Cup with a Blue Hare (Hare/Tiger).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Quick Bugger, That One",
    description = "Win the Legend Cup with a Hare (Hare/Hare).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Divinity Asserting Dominance",
    description = "Win the Legend Cup with a Prince Hare (Hare/Gali).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "More Eyes Means More Accurate",
    description = "Win the Legend Cup with a Four Eyed (Hare/Suezo).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Power Lies in Its Flabby Belly",
    description = "Win the Legend Cup with a Jelly Hare (Hare/Jell).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Embossed Leaves",
    description = "Win the Legend Cup with a Leaf Hare (Hare/Plant).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Night Brawler",
    description = "Win the Legend Cup with an Evil Hare (Hare/Monol).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Eyebrows Alone Are Legendary",
    description = "Win the Legend Cup with a Wild Hare (Hare/Worm).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Glass Cannon",
    description = "Win the Legend Cup with a Purple Hare (Hare/Naga).",
    points = 10,
    trigger = is_primary_breed("Hare") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Next Jackie Chan",
    description = "Win the Legend Cup with a KungFuHare (Hare/???).",
    points = 10,
    trigger = is_primary_breed("Hare") && rare_breed_matches("KungFuHare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Baku ====

achievement(
    title = "Domesticated Laziness",
    description = "Win the Legend Cup with a Magmax (Baku/Dragon).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Dragon") && baku_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Master of Useless Facts",
    description = "Win the Legend Cup with a Higante (Baku/Golem).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Golem") && baku_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The People's Bulwark",
    description = "Win the Legend Cup with a War Baku (Baku/Durahan).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Durahan") && baku_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Glutton for Victory",
    description = "Win the Legend Cup with an Icebergy (Baku/Tiger).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Tiger") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Challenge of Legends Accepted",
    description = "Win the Legend Cup with a Gontar (Baku/Hare).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Hare") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Pure and Innocent",
    description = "Win the Legend Cup with a Baku (Baku/Baku).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Baku") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Risk Free Victory",
    description = "Win the Legend Cup with a Nussie (Baku/Kato).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Kato") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Forgot Its Evil Duties",
    description = "Win the Legend Cup with a Baku Clown (Baku/Joker).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Joker") && baku_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Patience Leads to Victory",
    description = "Win the Legend Cup with a Giga Pint (Baku/Jell).",
    points = 10,
    trigger = is_primary_breed("Baku") && is_secondary_breed("Jell") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Homogenic",
    description = "Win the Legend Cup with a ShiShi (Baku/???).",
    points = 10,
    trigger = is_primary_breed("Baku") && rare_breed_matches("ShiShi") && baku_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Gali ====

achievement(
    title = "A Strange Tale in the Ogre Battle Saga",
    description = "Win the Legend Cup with a Pink Mask (Gali/Pixie).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Pixie") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Be Ya Self",
    description = "Win the Legend Cup with a Stone Mask (Gali/Golem).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Golem") && gali_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Jurassic Scales",
    description = "Win the Legend Cup with a Scaled Mask (Gali/Zuum).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Zuum") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Framed by Fangs",
    description = "Win the Legend Cup with a Fanged Mask (Gali/Tiger).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Tiger") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Hare-Brained Guardian",
    description = "Win the Legend Cup with a Furred Mask (Gali/Hare).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Hare") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Bit Closer to God Now",
    description = "Win the Legend Cup with a Gali (Gali/Gali).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Decorative Eye",
    description = "Win the Legend Cup with a Suezo Mask (Gali/Suezo).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Suezo") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Gel Is Only Pictured",
    description = "Win the Legend Cup with an Aqua Mask (Gali/Jell).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Jell") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Peace Loving Guardian",
    description = "Win the Legend Cup with a Colorful (Gali/Plant).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Plant") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Smooth as Silk",
    description = "Win the Legend Cup with a Galirous (Gali/Monol).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Monol") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "All Smiles Here",
    description = "Win the Legend Cup with a Brown Mask (Gali/Worm).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Worm") && gali_unlocked() && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Born to Battle",
    description = "Win the Legend Cup with a Purple Mask (Gali/Naga).",
    points = 10,
    trigger = is_primary_breed("Gali") && is_secondary_breed("Naga") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Legend Larger Than Life",
    description = "Win the Legend Cup with a Happy Mask (Gali/???).",
    points = 10,
    trigger = is_primary_breed("Gali") && rare_breed_matches("Happy Mask") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Kato ====

achievement(
    title = "Inherited Violent Tendencies",
    description = "Win the Legend Cup with a Draco Kato (Kato/Dragon).",
    points = 10,
    trigger = is_primary_breed("Kato") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Now You See Me, Now You Don't",
    description = "Win the Legend Cup with a Blue Kato (Kato/Tiger).",
    points = 10,
    trigger = is_primary_breed("Kato") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Look What the Cat Dragged In",
    description = "Win the Legend Cup with a Gordish (Kato/Gali).",
    points = 10,
    trigger = is_primary_breed("Kato") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Olive Oil Fanatic",
    description = "Win the Legend Cup with a Kato (Kato/Kato).",
    points = 10,
    trigger = is_primary_breed("Kato") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Befuddling Tactics",
    description = "Win the Legend Cup with a Citronie (Kato/Suezo).",
    points = 10,
    trigger = is_primary_breed("Kato") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Story of the Tamamayu",
    description = "Win the Legend Cup with a Pink Kato (Kato/Mocchi).",
    points = 10,
    trigger = is_primary_breed("Kato") && is_secondary_breed("Mocchi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Reclusive Cat",
    description = "Win the Legend Cup with a Tainted Cat (Kato/Joker).",
    points = 10,
    trigger = is_primary_breed("Kato") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Rikimaru's Ancestor",
    description = "Win the Legend Cup with a Ninja Kato (Kato/???).",
    points = 10,
    trigger = is_primary_breed("Kato") && rare_breed_matches("Ninja Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Zilla ====

achievement(
    title = "Immaculate Body Image",
    description = "Win the Legend Cup with a Pink Zilla (Zilla/Pixie).",
    points = 10,
    trigger = is_primary_breed("Zilla") && is_secondary_breed("Pixie") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Anti-Titanic Terror",
    description = "Win the Legend Cup with a Gooji (Zilla/Tiger).",
    points = 10,
    trigger = is_primary_breed("Zilla") && is_secondary_breed("Tiger") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Large Lad Wins it All",
    description = "Win the Legend Cup with a Zilla (Zilla/Zilla).",
    points = 10,
    trigger = is_primary_breed("Zilla") && is_secondary_breed("Zilla") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Eyes of the Sea",
    description = "Win the Legend Cup with a Gigalon (Zilla/Jell).",
    points = 10,
    trigger = is_primary_breed("Zilla") && is_secondary_breed("Jell") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Perpetually in Fear of Gooji",
    description = "Win the Legend Cup with a Deluxe Liner (Zilla/???).",
    points = 10,
    trigger = is_primary_breed("Zilla") && rare_breed_matches("Deluxe Liner") && zilla_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Bajarl ====

achievement(
    title = "Binto's Secret Pulling Through",
    description = "Win the Legend Cup with a Bajarl (Bajarl/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Bajarl") && is_secondary_breed("Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Made for Assassination",
    description = "Win the Legend Cup with a Jaba (Bajarl/Joker).",
    points = 10,
    trigger = is_primary_breed("Bajarl") && is_secondary_breed("Joker") && bajarl_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "King of the Ring",
    description = "Win the Legend Cup with a Boxer Bajarl (Bajarl/???).",
    points = 10,
    trigger = is_primary_breed("Bajarl") && rare_breed_matches("Boxer Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No Further Need to Hide in the Pot",
    description = "Win the Legend Cup with a Magic Bajarl (Bajarl/???).",
    points = 10,
    trigger = is_primary_breed("Bajarl") && rare_breed_matches("Magic Bajarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Hero of Justice",
    description = "Win the Legend Cup with an Ultrarl (Bajarl/???).",
    points = 10,
    trigger = is_primary_breed("Bajarl") && rare_breed_matches("Ultrarl") && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Mew ====

achievement(
    title = "Lost the Moo Roulette, Still a Winner",
    description = "Win the Legend Cup with a Mum Mew (Mew/Pixie).",
    points = 10,
    trigger = is_primary_breed("Mew") && is_secondary_breed("Pixie") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tiger's Cousin, Twice Removed",
    description = "Win the Legend Cup with a Bowwow (Mew/Tiger).",
    points = 10,
    trigger = is_primary_breed("Mew") && is_secondary_breed("Tiger") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Do Not Mess With Its Ears",
    description = "Win the Legend Cup with an Eared Mew (Mew/Hare).",
    points = 10,
    trigger = is_primary_breed("Mew") && is_secondary_breed("Hare") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Loves To Sing-a",
    description = "Win the Legend Cup with a Mew (Mew/Mew).",
    points = 10,
    trigger = is_primary_breed("Mew") && is_secondary_breed("Mew") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Dreams Can Come True",
    description = "Win the Legend Cup with an Aqua Mew (Mew/Jell).",
    points = 10,
    trigger = is_primary_breed("Mew") && is_secondary_breed("Jell") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Pool's Smelling Like Teen Spirit",
    description = "Win the Legend Cup with a Mew/??? (Swimmer).",
    points = 10,
    trigger = is_primary_breed("Mew") && rare_breed_matches("Swimmer") && mew_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Phoenix ====

achievement(
    title = "Reborn Legend Upholding Its Status",
    description = "Win the Legend Cup with a Phoenix (Phoenix/Phoenix).",
    points = 10,
    trigger = is_primary_breed("Phoenix") && is_secondary_breed("Phoenix") && phoenix_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Burning with Rage",
    description = "Win the Legend Cup with a Cinder Bird (Phoenix/???).",
    points = 10,
    trigger = is_primary_breed("Phoenix") && rare_breed_matches("Cinder Bird") && phoenix_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Ghost ====

achievement(
    title = "Second Chance Taken",
    description = "Win the Legend Cup with a Ghost (Ghost/Ghost).",
    points = 10,
    trigger = is_primary_breed("Ghost") && is_secondary_breed("Ghost") && ghost_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Iron Chef",
    description = "Win the Legend Cup with a Chef (Ghost/???).",
    points = 10,
    trigger = is_primary_breed("Ghost") && rare_breed_matches("Chef") && ghost_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Metalner ====

achievement(
    title = "What is Love?",
    description = "Win the Legend Cup with a Love Seeker (Metalner/Pixie).",
    points = 10,
    trigger = is_primary_breed("Metalner") && is_secondary_breed("Pixie") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Intergalactic Champion",
    description = "Win the Legend Cup with a Metalner (Metalner/Metalner).",
    points = 10,
    trigger = is_primary_breed("Metalner") && is_secondary_breed("Metalner") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Alien on Permanent Vacation",
    description = "Win the Legend Cup with a Metazorl (Metalner/Suezo).",
    points = 10,
    trigger = is_primary_breed("Metalner") && is_secondary_breed("Suezo") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Agent C's Claim to Fame",
    description = "Win the Legend Cup with a Chinois (Metalner/???).",
    points = 10,
    trigger = is_primary_breed("Metalner") && rare_breed_matches("Chinois") && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Suezo ====

achievement(
    title = "All It Wanted was Equal Treatment",
    description = "Win the Legend Cup with a Pink Eye (Suezo/Pixie).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Heavyweight Champion",
    description = "Win the Legend Cup with a Rocky Suezo (Suezo/Golem).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Regular Farm Invader",
    description = "Win the Legend Cup with a Melon Suezo (Suezo/Zuum).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Horn Is a Metaphor",
    description = "Win the Legend Cup with a Horn (Suezo/Tiger).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Time for a New Adventure",
    description = "Win the Legend Cup with a Furred Suezo (Suezo/Hare).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Inside Its Eye Is Another Legend",
    description = "Win the Legend Cup with an Orion (Suezo/Gali).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Endearing Expressions",
    description = "Win the Legend Cup with a Suezo (Suezo/Suezo).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Modeling After the Ultimate Form",
    description = "Win the Legend Cup with a Clear Suezo (Suezo/Jell).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Earnest Among Suezos",
    description = "Win the Legend Cup with a Green Suezo (Suezo/Plant).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Insomniacs Rise Up",
    description = "Win the Legend Cup with a Red Eye (Suezo/Monol).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Legends Multiply",
    description = "Win the Legend Cup with a Fly Eye (Suezo/Worm).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Used Only a Fraction of Its Strength",
    description = "Win the Legend Cup with a Purple Suezo (Suezo/Naga).",
    points = 10,
    trigger = is_primary_breed("Suezo") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "That's Gold, Jerry!",
    description = "Win the Legend Cup with a Gold Suezo (Suezo/???).",
    points = 10,
    trigger = is_primary_breed("Suezo") && rare_breed_matches("Gold Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No, I Don't Want No Scrub",
    description = "Win the Legend Cup with a Silver Suezo (Suezo/???).",
    points = 10,
    trigger = is_primary_breed("Suezo") && rare_breed_matches("Silver Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Flush It All Away",
    description = "Win the Legend Cup with a Bronze Suezo (Suezo/???).",
    points = 10,
    trigger = is_primary_breed("Suezo") && rare_breed_matches("Bronze Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Nice Shot!",
    description = "Win the Legend Cup with a Birdie (Suezo/???).",
    points = 10,
    trigger = is_primary_breed("Suezo") && rare_breed_matches("Birdie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Jill ====

achievement(
    title = "Meat Lover",
    description = "Win the Legend Cup with a Pong Pong (Jill/Pixie).",
    points = 10,
    trigger = is_primary_breed("Jill") && is_secondary_breed("Pixie") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Finally Off Gathering Duty",
    description = "Win the Legend Cup with a Pierry (Jill/Tiger).",
    points = 10,
    trigger = is_primary_breed("Jill") && is_secondary_breed("Tiger") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Huh? Was I Supposed To Win?",
    description = "Win the Legend Cup with a Wondar (Jill/Hare).",
    points = 10,
    trigger = is_primary_breed("Jill") && is_secondary_breed("Hare") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "In Need of a Victory Feast",
    description = "Win the Legend Cup with a Bengal (Jill/Kato).",
    points = 10,
    trigger = is_primary_breed("Jill") && is_secondary_breed("Kato") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Five Steps Ahead",
    description = "Win the Legend Cup with a Zorjil (Jill/Suezo).",
    points = 10,
    trigger = is_primary_breed("Jill") && is_secondary_breed("Suezo") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Reppin' the North Side",
    description = "Win the Legend Cup with a Jill (Jill/Jill).",
    points = 10,
    trigger = is_primary_breed("Jill") && is_secondary_breed("Jill") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Enough Smart to Be A Legend",
    description = "Win the Legend Cup with a Skull Capped (Jill/Joker).",
    points = 10,
    trigger = is_primary_breed("Jill") && is_secondary_breed("Joker") && jill_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Yabba Dabba Doo!",
    description = "Win the Legend Cup with a Pithecan (Jill/???).",
    points = 10,
    trigger = is_primary_breed("Jill") && rare_breed_matches("Pithecan") && jill_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Mocchi ====

achievement(
    title = "The Most Beautiful Monster of All",
    description = "Win the Legend Cup with a Manna (Mocchi/Pixie).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Too Cute to Be Violent",
    description = "Win the Legend Cup with a Draco Mocchi (Mocchi/Dragon).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Dragon") && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Natural Armor Coming in Clutch",
    description = "Win the Legend Cup with a KnightMocchi (Mocchi/Durahan).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Durahan") && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Fake It 'Till You Make It",
    description = "Win the Legend Cup with a Fake Penguin (Mocchi/Tiger).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Taught This Old Cat Every Trick",
    description = "Win the Legend Cup with a Nyankoro (Mocchi/Kato).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Kato") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Mascot Material",
    description = "Win the Legend Cup with a Mocchi (Mocchi/Mocchi).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Mocchi") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Partial Fiend, Full Legend",
    description = "Win the Legend Cup with a Hell Pierrot (Mocchi/Joker).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Was Only Pretending To Be Soft",
    description = "Win the Legend Cup with a Gelatine (Mocchi/Jell).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Every Caloriena Counts",
    description = "Win the Legend Cup with a Caloriena (Mocchi/???).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && rare_breed_matches("Caloriena") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Speeding to the Top",
    description = "Win the Legend Cup with a Mocchini (Mocchi/???).",
    points = 10,
    trigger = is_primary_breed("Mocchi") && rare_breed_matches("Mocchini") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Joker ====

achievement(
    title = "Famed Atrocity",
    description = "Win the Legend Cup with a Hell Heart (Joker/Pixie).",
    points = 10,
    trigger = is_primary_breed("Joker") && is_secondary_breed("Pixie") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Crueler Than a Dragon",
    description = "Win the Legend Cup with a Flare Death (Joker/Dragon).",
    points = 10,
    trigger = is_primary_breed("Joker") && is_secondary_breed("Dragon") && joker_unlocked() && dragon_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Strength Beyond Measure",
    description = "Win the Legend Cup with a Tombstone (Joker/Golem).",
    points = 10,
    trigger = is_primary_breed("Joker") && is_secondary_breed("Dragon") && joker_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Only One Hit Needed",
    description = "Win the Legend Cup with a Blue Terror (Joker/Tiger).",
    points = 10,
    trigger = is_primary_breed("Joker") && is_secondary_breed("Tiger") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Redemption After Disgrace",
    description = "Win the Legend Cup with an Odium (Joker/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Joker") && is_secondary_breed("Bajarl") && joker_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Unsealed Terror",
    description = "Win the Legend Cup with a Joker (Joker/Joker).",
    points = 10,
    trigger = is_primary_breed("Joker") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Peak Aggression",
    description = "Win the Legend Cup with a Bloodshed (Joker/???).",
    points = 10,
    trigger = is_primary_breed("Joker") && rare_breed_matches("Bloodshed") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Gaboo ====

achievement(
    title = "Cool as a Gaboo",
    description = "Win the Legend Cup with a Frozen Gaboo (Gaboo/Tiger).",
    points = 10,
    trigger = is_primary_breed("Gaboo") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Secret Numbing Agent Applied",
    description = "Win the Legend Cup with a Dokoo (Gaboo/Joker).",
    points = 10,
    trigger = is_primary_breed("Gaboo") && is_secondary_breed("Joker") && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Shy Blob",
    description = "Win the Legend Cup with a Gaboo (Gaboo/Gaboo).",
    points = 10,
    trigger = is_primary_breed("Gaboo") && is_secondary_breed("Gaboo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Core Not Needed",
    description = "Win the Legend Cup with a Jelly Gaboo (Gaboo/Jell).",
    points = 10,
    trigger = is_primary_breed("Gaboo") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Close Quarter Combat Master",
    description = "Win the Legend Cup with a GabooSoldier (Gaboo/???).",
    points = 10,
    trigger = is_primary_breed("Gaboo") && rare_breed_matches("GabooSoldier") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Jell ====

achievement(
    title = "Jam's Only For Fighting",
    description = "Win the Legend Cup with a Pink Jam (Jell/Pixie).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Walling the Competition",
    description = "Win the Legend Cup with a Wall Mimic (Jell/Golem).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Scales Are Only for Show",
    description = "Win the Legend Cup with a Scaled Jell (Jell/Zuum).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Confectionery Advertising",
    description = "Win the Legend Cup with an Icy Jell (Jell/Tiger).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Spiritually Related to Gaboo",
    description = "Win the Legend Cup with a Muddy Jell (Jell/Hare).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Many Reasons to Be Proud",
    description = "Win the Legend Cup with a Noble Jell (Jell/Gali).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "All-Seeing Eye",
    description = "Win the Legend Cup with an Eye Jell (Jell/Suezo).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Flexibility is Key For Winning",
    description = "Win the Legend Cup with a Jell (Jell/Jell).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Fiending for Water",
    description = "Win the Legend Cup with a Chloro Jell (Jell/Plant).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Coal Tar Making a Name For Itself",
    description = "Win the Legend Cup with a Clay (Jell/Monol).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Eyes Down Here, Buddy",
    description = "Win the Legend Cup with a Worm Jell (Jell/Worm).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Living in the Moment",
    description = "Win the Legend Cup with a Purple Jell (Jell/Naga).",
    points = 10,
    trigger = is_primary_breed("Jell") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "T-1000 Taking Names",
    description = "Win the Legend Cup with a Metal Jell (Jell/???).",
    points = 10,
    trigger = is_primary_breed("Jell") && rare_breed_matches("Metal Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Undine ====

achievement(
    title = "Wind and Water At Its Call",
    description = "Win the Legend Cup with a Siren (Undine/Joker).",
    points = 10,
    trigger = is_primary_breed("Undine") && is_secondary_breed("Joker") && undine_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "She's Talented on Land Too",
    description = "Win the Legend Cup with an Undine (Undine/Undine).",
    points = 10,
    trigger = is_primary_breed("Undine") && is_secondary_breed("Undine") && undine_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Now She's Part of That World",
    description = "Win the Legend Cup with a Mermaid (Undine/???).",
    points = 10,
    trigger = is_primary_breed("Jell") && rare_breed_matches("Mermaid") && undine_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Niton ====

achievement(
    title = "That Belongs in a Museum",
    description = "Win the Legend Cup with an Ammon (Niton/Golem).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Golem") && niton_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Steel Shell",
    description = "Win the Legend Cup with a Knight Niton (Niton/Durahan).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Durahan") && niton_unlocked() && durahan_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Stripe Per Tournament Won",
    description = "Win the Legend Cup with a Stripe Shell (Niton/Kato).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Kato") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Appearing With a Win",
    description = "Win the Legend Cup with an Alabia Niton (Niton/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Bajarl") && niton_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Future Is Now",
    description = "Win the Legend Cup with a Metal Shell (Niton/Metalner).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Metalner") && niton_unlocked() && metalner_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tough Nut to Crack",
    description = "Win the Legend Cup with a Clear Shell (Niton/Jell).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Jell") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Rather Skittish",
    description = "Win the Legend Cup with a Niton (Niton/Niton).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Niton") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tree Cake",
    description = "Win the Legend Cup with a Baum Kuchen (Niton/Mock).",
    points = 10,
    trigger = is_primary_breed("Niton") && is_secondary_breed("Mock") && niton_unlocked() && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Kickball Champion",
    description = "Win the Legend Cup with a Dribbler (Niton/???).",
    points = 10,
    trigger = is_primary_breed("Niton") && rare_breed_matches("Dribbler") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Lightning McQueen",
    description = "Win the Legend Cup with a Radial Niton (Niton/???).",
    points = 10,
    trigger = is_primary_breed("Niton") && rare_breed_matches("Radial Niton") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Best Disc Stone Ever",
    description = "Win the Legend Cup with a Disc Niton (Niton/???).",
    points = 10,
    trigger = is_primary_breed("Niton") && rare_breed_matches("Disc Niton") && niton_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Mock ====

achievement(
    title = "Nobody Expects the Tree To Fight Back",
    description = "Win the Legend Cup with an Ebony (Mock/Joker).",
    points = 10,
    trigger = is_primary_breed("Mock") && is_secondary_breed("Joker") && mock_unlocked() && joker_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Legendary Crook Gonzales",
    description = "Win the Legend Cup with a Mock (Mock/Mock).",
    points = 10,
    trigger = is_primary_breed("Mock") && is_secondary_breed("Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Comparsa Companion",
    description = "Win the Legend Cup with a White Birch (Mock/???).",
    points = 10,
    trigger = is_primary_breed("Mock") && rare_breed_matches("White Birch") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Electric Warrior",
    description = "Win the Legend Cup with a Pole Mock (Mock/???).",
    points = 10,
    trigger = is_primary_breed("Mock") && rare_breed_matches("Pole Mock") && mock_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Ducken ====

achievement(
    title = "If Many Rocks Look Like A Duck...",
    description = "Win the Legend Cup with a Blocken (Ducken/Golem).",
    points = 10,
    trigger = is_primary_breed("Ducken") && is_secondary_breed("Golem") && ducken_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Lost Technology Rediscovered",
    description = "Win the Legend Cup with a Ticken (Ducken/Suezo).",
    points = 10,
    trigger = is_primary_breed("Ducken") && is_secondary_breed("Suezo") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Fun Can Providing So Much Fun",
    description = "Win the Legend Cup with a Ducken (Ducken/Ducken).",
    points = 10,
    trigger = is_primary_breed("Ducken") && is_secondary_breed("Ducken") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "These Are the Better Days",
    description = "Win the Legend Cup with a Watermelony (Ducken/???).",
    points = 10,
    trigger = is_primary_breed("Ducken") && rare_breed_matches("Watermelony") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Not So Unlucky Now, Are We",
    description = "Win the Legend Cup with a Cawken (Ducken/???).",
    points = 10,
    trigger = is_primary_breed("Ducken") && rare_breed_matches("Cawken") && ducken_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Plant ====

achievement(
    title = "Queen of FIMBA, Legend of IMa",
    description = "Win the Legend Cup with a Queen Plant (Plant/Pixie).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Getting Something Out of Nothing",
    description = "Win the Legend Cup with a Rock Plant (Plant/Golem).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Dream-Illuminating Lights",
    description = "Win the Legend Cup with a Scaled Plant (Plant/Zuum).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "This Plant's Got It All!",
    description = "Win the Legend Cup with a Blue Plant (Plant/Tiger).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Nimble Plant",
    description = "Win the Legend Cup with a Hare Plant (Plant/Hare).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Styling on the Opposition",
    description = "Win the Legend Cup with a Gold Plant (Plant/Gali).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No Challenge Is Too Great",
    description = "Win the Legend Cup with an Usaba (Plant/Suezo).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Comfortably Numb",
    description = "Win the Legend Cup with a Mirage Plant (Plant/Jell).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Victory Via Attrition",
    description = "Win the Legend Cup with a Plant (Plant/Plant).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Sooty Foliage",
    description = "Win the Legend Cup with a Black Plant (Plant/Monol).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Plant By Any Other Name",
    description = "Win the Legend Cup with a Fly Plant (Plant/Worm).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Resilient Fauna",
    description = "Win the Legend Cup with a Weeds (Plant/Naga).",
    points = 10,
    trigger = is_primary_breed("Plant") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Loves Raggae and Winning Equally",
    description = "Win the Legend Cup with a Raggae Plant (Plant/???).",
    points = 10,
    trigger = is_primary_breed("Plant") && rare_breed_matches("Raggae Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Monol ====

achievement(
    title = "Smothering All With Kindness",
    description = "Win the Legend Cup with a Romper Wall (Monol/Pixie).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Most Active Wall",
    description = "Win the Legend Cup with an Obelisk (Monol/Golem).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Noodles Are On It Tonight",
    description = "Win the Legend Cup with a Jura Wall (Monol/Zuum).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Sleeping Well After That Win",
    description = "Win the Legend Cup with a Blue Sponge (Monol/Tiger).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Warmest Wall",
    description = "Win the Legend Cup with a Furred Wall (Monol/Hare).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Deific Representation",
    description = "Win the Legend Cup with an Ivory Wall (Monol/Gali).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Recognizable From a Mile Away",
    description = "Win the Legend Cup with a Sandy (Monol/Suezo).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Summertime Champ",
    description = "Win the Legend Cup with an Ice Candy (Monol/Jell).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Soil Gave It Strength",
    description = "Win the Legend Cup with a New Leaf (Monol/Plant).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Parts Stronger Than the Whole",
    description = "Win the Legend Cup with a Monol (Monol/Monol).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "I Swear The Walls Have Eyes!",
    description = "Win the Legend Cup with a Soboros (Monol/Worm).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Ant-Proof",
    description = "Win the Legend Cup with an Asphaltum (Monol/Naga).",
    points = 10,
    trigger = is_primary_breed("Monol") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Rise of Darth Monol",
    description = "Win the Legend Cup with a Galaxy (Monol/???).",
    points = 10,
    trigger = is_primary_breed("Monol") && rare_breed_matches("Galaxy") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No One Can Stop Mr. Domino",
    description = "Win the Legend Cup with a Dominos (Monol/???).",
    points = 10,
    trigger = is_primary_breed("Monol") && rare_breed_matches("Dominos") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Performed Better On The Wall",
    description = "Win the Legend Cup with a Scribble (Monol/???).",
    points = 10,
    trigger = is_primary_breed("Monol") && rare_breed_matches("Scribble") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Ape ====

achievement(
    title = "Stone Statue",
    description = "Win the Legend Cup with a Rock Ape (Ape/Golem).",
    points = 10,
    trigger = is_primary_breed("Ape") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Honest Techniques Only",
    description = "Win the Legend Cup with a Gibberer (Ape/Hare).",
    points = 10,
    trigger = is_primary_breed("Ape") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Lazy Yet Capable",
    description = "Win the Legend Cup with a Bossy (Ape/Gali).",
    points = 10,
    trigger = is_primary_breed("Ape") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Using Natural Funk to Its Advantage",
    description = "Win the Legend Cup with a Tropical Ape (Ape/Plant).",
    points = 10,
    trigger = is_primary_breed("Ape") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Unparalleled Laziness",
    description = "Win the Legend Cup with an Ape (Ape/Ape).",
    points = 10,
    trigger = is_primary_breed("Ape") && is_secondary_breed("Ape") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Warhol & Nico Special",
    description = "Win the Legend Cup with a Gold Dust (Ape/???).",
    points = 10,
    trigger = is_primary_breed("Ape") && rare_breed_matches("Gold Dust") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Worm====

achievement(
    title = "Rare Beauty",
    description = "Win the Legend Cup with a Red Worm (Worm/Pixie).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Pixie") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Coveted Eyes",
    description = "Win the Legend Cup with a Rock Worm (Worm/Golem).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Golem") && worm_unlocked() && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Didn't Even Need Its Legs",
    description = "Win the Legend Cup with a Scaled Worm (Worm/Zuum).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Zuum") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tusks to Be Feared",
    description = "Win the Legend Cup with a Drill Tusk (Worm/Tiger).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Tiger") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Orayo!",
    description = "Win the Legend Cup with a Corone (Worm/Hare).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Hare") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Tougher Than Advertised",
    description = "Win the Legend Cup with a Mask Worm (Worm/Gali).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Gali") && worm_unlocked() && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Good Luck Finding the Real Eye",
    description = "Win the Legend Cup with an Eye Worm (Worm/Suezo).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Suezo") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Flabby Body Saving the Day",
    description = "Win the Legend Cup with a Jelly Worm (Worm/Jell).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Jell") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Red and Blue Contrasting Well",
    description = "Win the Legend Cup with a Flower Worm (Worm/Plant).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Plant") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Carrying Itself to Victory",
    description = "Win the Legend Cup with a Black Worm (Worm/Monol).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Monol") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "No Weaknesses Found",
    description = "Win the Legend Cup with a Worm (Worm/Worm).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "The Shiny Eyes Are Still Scary",
    description = "Win the Legend Cup with a Purple Worm (Worm/Naga).",
    points = 10,
    trigger = is_primary_breed("Worm") && is_secondary_breed("Naga") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "This Express is Licensed to Ill",
    description = "Win the Legend Cup with an Express Worm (Worm/???).",
    points = 10,
    trigger = is_primary_breed("Worm") && rare_breed_matches("Express Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

// ==== Naga ====

achievement(
    title = "Almost Forgot It Was a Monster",
    description = "Win the Legend Cup with a Ripper (Naga/Pixie).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Pixie") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Single Strike Won It All",
    description = "Win the Legend Cup with a Trident (Naga/Golem).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Golem") && golem_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Blowing Raspberries at the Competition",
    description = "Win the Legend Cup with a Stinger (Naga/Zuum).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Zuum") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Rare Obedience",
    description = "Win the Legend Cup with a Striker (Naga/Tiger).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Tiger") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Don't Cut Yourself on That Edge",
    description = "Win the Legend Cup with an Edgehog (Naga/Hare).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Hare") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Slow and Steady Wins the Fight",
    description = "Win the Legend Cup with a Bazula (Naga/Gali).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Gali") && gali_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "It Agreed To This One Goal",
    description = "Win the Legend Cup with a Cyclops (Naga/Suezo).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Suezo") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Adopting a Slithery Form",
    description = "Win the Legend Cup with an Aqua Cutter (Naga/Jell).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Jell") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Broke the Cycle of Jungle Hunting",
    description = "Win the Legend Cup with a Jungler (Naga/Plant).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Plant") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "In For a Long Fight",
    description = "Win the Legend Cup with a Crimson Eyed (Naga/Monol).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Monol") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Nature's Strongest Protector",
    description = "Win the Legend Cup with an Earth Keeper (Naga/Worm).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Worm") && worm_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "Cruel and Unusual Tactics",
    description = "Win the Legend Cup with a Naga (Naga/Naga).",
    points = 10,
    trigger = is_primary_breed("Naga") && is_secondary_breed("Naga") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "One Step Closer to Immortality",
    description = "Win the Legend Cup with a Time Noise (Naga/???).",
    points = 10,
    trigger = is_primary_breed("Naga") && rare_breed_matches("Time Noise") && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

