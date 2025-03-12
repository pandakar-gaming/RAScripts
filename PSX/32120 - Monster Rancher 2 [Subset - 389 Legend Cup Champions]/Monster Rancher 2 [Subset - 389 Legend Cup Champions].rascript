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


function is_primary_breed(breed_name) => byte(0x97a18) == breeds[breed_name]
function is_secondary_breed(breed_name) => byte(0x97a1c) == breeds[breed_name]

// Given the name of the unique monster, determine whether our current monster is that monster.
// Rare breeds have some sub-breed identifier from 0x26 to 0x2b
// It is dependent on which specific monster you're talking about though, and it is not formulaic
// Special enemy monsters also make use of this system so we have to map it out
function rare_breed_matches(breed_name) {

    if (breed_name == "Poison") {
        return is_primary_breed("Pixie") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }
    
    if (breed_name == "Kasumi") {
        return is_primary_breed("Pixie") && byte(0x97a1c) == 0x27
    }
    
    if (breed_name == "Mia") {
        return is_primary_breed("Pixie") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }

    if (breed_name == "Moo") {
        return is_primary_breed("Dragon") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }
    
    if (breed_name == "Trotter") {
        return is_primary_breed("Centaur") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }    
    
    if (breed_name == "Blue Thunder") {
        return is_primary_breed("Centaur") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }    
    
    if (breed_name == "Dice") {
        return is_primary_breed("ColorPandora") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }
    
    if (breed_name == "Tram") {
        return is_primary_breed("ColorPandora") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }
    
    if (breed_name == "Eggplantern") {
        return is_primary_breed("Beaclon") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }
    
    if (breed_name == "Skeleton") {
        return is_primary_breed("Henger") && byte(0x97a1c) == 0x2c // I don't know what this is yet
    }    
    
    if (breed_name == "ForwardGolem") {
        return is_primary_breed("Golem") && byte(0x97a1c) == 0x2c // I don't know what this is yet
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
    title = "Serene Celebrations Are in Order",
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
    description = "WWin the Legend Cup with a Celious (Centaur/Tiger).",
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
    title = "Full Night Cover",
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
    title = "Popularity is Strangely Skyrocketing",
    description = "Win the Legend Cup with a Bakky (Wracky/Bajarl).",
    points = 10,
    trigger = is_primary_breed("Wracky") && is_secondary_breed("Bajarl") && wracky_unlocked() && bajarl_unlocked() && prereqs_met() && prev(legend_cup() == 0x00) && legend_cup() == 0x01
)

achievement(
    title = "A Child's Favorite",
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
    title = "All I Want For Christmas is This Doll",
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
    title = "Operating on Pure Magic",
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
    title = "Celebrating with Curry Rice",
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
    title = "Big Brother is Watching",
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

// ==== Durahan ====

// ==== Arrow Head ====

// ==== Tiger ====

// ==== Hopper ====

// ==== Hare ====

// ==== Baku ====

// ==== Gali ====

// ==== Kato ====

// ==== Zilla ====

// ==== Bajarl ====

// ==== Mew ====

// ==== Phoenix ====

// ==== Ghost ====

// ==== Metalner ====

// ==== Suezo ====

// ==== Jill ====

// ==== Mocchi ====

// ==== Joker ====

// ==== Gaboo ====

// ==== Jell ====

// ==== Undine ====

// ==== Niton ====

// ==== Mock ====

// ==== Ducken ====

// ==== Plant ====

// ==== Monol ====

// ==== Ape ====

// ==== Worm====

// ==== Naga ====