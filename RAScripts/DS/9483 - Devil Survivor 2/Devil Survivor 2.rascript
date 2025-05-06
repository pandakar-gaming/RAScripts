// Devil Survivor 2
// #ID=9483
// md5: 4b1ee25404620aed63ee09f24a9a6db5

in_game_clock = word(0x00284ab4)
day = byte(0x00284aba)
macca = dword(0x00284a98)
current_location = byte(0x00284da9)
current_city = byte(0x00284d85)
most_recent_mission = word(0x00284fae)
current_event = word(0x00198824)
// both of these are counted in frames, game runs @ 30fps
current_time_in_mission = dword(tbyte(0x001be0ac) + 0x10)
total_time_in_mission = dword(tbyte(0x001be0ac) + 0x28)
in_game_time = tbyte(0x00284480)
active_auction_menu = dword(0x001be73c)

function on_grid_map() => byte(0x00284abb) == 0x01
function non_null_ptr(addr) => addr != 0x00 && addr >= 0x02000000 && addr <= 0x02ffffff

function character_alive(char_name) {
    // for whatever reason no characters exist from 0x00 -> 0x02
    char_index = chararacter_ids_by_name[char_name] - 0x03

    return bit2(0x00284dc2 + (0x10 * char_index)) == 0
}

// the compendium itself is in a static spot in memory
start_of_compendium = 0x00285074 
end_of_compendium = 0x00287054
function demon_registered(monster_id) {
    // monster_ids seem to start at 0x0e
    offset = (monster_id - 0x0e) * 0x20
    return word(start_of_compendium + offset) == 0xffff 
        && byte(start_of_compendium + offset + 0x02) == monster_id
        && byte(start_of_compendium + offset + 0x04) == 0xff
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
    0x09: "??? 0x09",
    0x0a: "Shinbashi Special Platform",
    0x0b: "??? 0x0b",
    0x0c: "Sengakuji",
    0x0d: "??? 0x0d",
    0x0e: "Shiba Park",
    0x0f: "Shibuya Q-TRONT",
    0x10: "Hanzoumon Line Platform",
    0x11: "Testing Site",
    0x12: "Shibuya Station",
    0x13: "??? 0x13",
    0x14: "??? 0x14",
    0x15: "??? 0x15",
    0x16: "Miyashita Park",
    0x17: "??? 0x17",
    0x18: "Kannagi-cho",
    0x19: "SL Plaza",
    0x1a: "??? 0x1a",
    0x1b: "??? 0x1b",
    0x1c: "Diet Building",
    0x1d: "Nagata-cho, Tokyo Branch",
    0x1e: "Hibiya Park",
    0x1f: "??? 0x1f",
    0x20: "??? 0x20",
    0x21: "99 Plaza",
    0x22: "??? 0x22",
    0x23: "??? 0x23",
    0x24: "??? 0x24",
    0x25: "??? 0x25",
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
    0x31: "??? 0x31",
    0x32: "Triangle Plaza",
    0x33: "Festival Gate",
    0x34: "??? 0x34",
    0x35: "Shinsekai",
    0x36: "??? 0x36",
    0x37: "Akasaka Mall",
    0x38: "Ebisu Bridge",
    0x39: "OCUT Plaza",
    0x3a: "??? 0x3a",
    0x3b: "??? 0x3b",
    0x3c: "??? 0x3c",
    0x3d: "Osaka Castle Park Square"
}

missions = {
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
    0x7ec: "Daichi's Report",
    0x2329: "Tokyo in Ruins",
    0x232a: "An Idle Man",
    0x232b: "Hard Bargain",
    0x2333: "Osaka Woman",
    0x233d: "Io and Nicaea",
    0x233e: "Ladies' Man",
    0x2347: "901 Collapse",
    0x2351: "Joe the Flake",
    0x2352: "The New World",
    0x235d: "Hungry Joe",
    0x2366: "Adult Woman",
    0x2383: "JP's Chief",
    0x238d: "Osaka Spirit",
    0x23b5: "In Search Of..."
}

city = {
    0x00: "Tokyo",
    0x01: "Osaka"
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

auction_unlock_eligibility = 0x00284ad0
auctions_unlocked = 0x00284acb

// *** Achievements ***

// Progression

achievement(
    title = "Death Clips Mean Nothing",
    description = "Avert the crisis shown in your first ever death clip.",
    points = 1,
    // TODO find a better "end of combat" indicator, this pops so far after the mission that it doesn't really vibe
    trigger =  day == 0x01 && most_recent_mission == 0x3e9 && prev(in_game_clock == 0x30c) && in_game_clock == 0x32a
)

// Days (for testing, may not commit to)

// day 1
achievement(
    title = "[IN DEV] Survived Day 1",
    description = "Tokyo's gone up in flames, but now you're cozy in bed and nothing matters.",
    points = 5,
    trigger = prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x01) && day == 0x02 
)
// day 2
achievement(
    title = "[IN DEV] Survived Day 2",
    description = "It's looking more rough out there, but the only problem you've got now is getting enough sleep.",
    points = 5,
    trigger = prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x02) && day == 0x03 
)
// day 3
achievement(
    title = "[IN DEV] Survived Day 3",
    description = "The world's getting strange, but not getting sleep is stranger.",
    points = 10,
    trigger = prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x03) && day == 0x04
)
// day 4
achievement(
    title = "[IN DEV] Survived Day 4",
    description = "No matter how bad it gets, a good night of sleep just a bit easier to deal with.",
    points = 10,
    trigger = prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x04) && day == 0x05 
)
// day 5
achievement(
    title = "[IN DEV] Survived Day 5",
    description = "Maybe the problems in Tokyo will go away with one more night of sleep...",
    points = 10,
    trigger = prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x05) && day == 0x06 
)
// day 6
achievement(
    title = "[IN DEV] Survived Day 6",
    description = "It's time to make your choice. What sort of world do you want to live in?",
    points = 10,
    trigger = prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x06) && day == 0x07 
)
// day 7
achievement(
    title = "[IN DEV] Survived Day 7",
    description = "You've made your choice and now it's time to own it. Get out there and make the world the way you want it to be.",
    points = 25,
    trigger = prev(in_game_clock == 0x4ec) && in_game_clock == 0x00 && prev(day == 0x07) && day == 0x08 
)

// FATE stages

achievement(
    title = "[IN DEV]Ronaldo's Best Friend",
    description = "Reach FATE stage 5 with Ronaldo.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]IO's Best Friend",
    description = "Reach FATE stage 5 with Io.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Yamato's Best Friend",
    description = "Reach FATE stage 5 with Yamato.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Fumi's Best Friend",
    description = "Reach FATE stage 5 with Fumi.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Daichi's Best Friend",
    description = "Reach FATE stage 5 with Daichi.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Otome's Best Friend",
    description = "Reach FATE stage 5 with Otome.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Jungo's Best Friend",
    description = "Reach FATE stage 5 with Jungo.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Makoto's Best Friend",
    description = "Reach FATE stage 5 with Makoto.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Keita's Best Friend",
    description = "Reach FATE stage 5 with Keita.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Airi's Best Friend",
    description = "Reach FATE stage 5 with Airi.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Joe's Best Friend",
    description = "Reach FATE stage 5 with Joe.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Hinako's Best Friend",
    description = "Reach FATE stage 5 with Hinako.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)
achievement(
    title = "[IN DEV]Anguished One's Best Friend",
    description = "Reach FATE stage 5 with the Anguished One.",
    points = 10,
    trigger = day == 0x09 // stub for now to at least put the achievement in my list, this should not fire
    // will replace with more accurate trigger later when I've got more characters to codify against
)

achievement(
    title = "[IN DEV] Death Clip",
    description = "Win the Death Clip mission.",
    points = 2,
    trigger = day == 0x01 && prev(in_game_clock == 0x30c) && in_game_clock == 0x32a
)
// Death Clip: Win the mission ()
// Daichi's Crisis: 
// Daichi's Worth: Get all of your allies to the designated escape area without losing any demons.
// App Abuser: No enemies escape, nobody dies
// Demon-Hacked: ??
// Never Say Die: probably just a "meet Hinako" OR Complete "Never Say Die" with Hinako's team getting 0 team kills.
// keita mission: Win without any miasma summoning an additional monster.
// Girl in Pursuit: probably just a "meet Airi"
// Boy in Combat: probably just a "meet Jungo"

achievement(
    title = "[IN DEV]Vs. Q",
    description = "Complete the Vs. Q mission on Tuesday.",
    points = 5,
    // TODO find a better way to trip this over "well this was the most recent mission and the clock advanced..."
    trigger = day == 0x03  && most_recent_mission == 0xbbb && prev(in_game_clock == 0x1c2) && in_game_clock == 0x1e0
)

achievement(
    title = "[IN DEV]Miasma Maestro",
    description = "Clear all of the miasma in either of 'Osaka Soul' or 'Too Late' before any additional enemy teams are summoned.",
    points = 5,
    trigger = day == 0x09 // TODO needs battle team information
)

achievement(
    title = "Are We Sure These Death Clips Come True?",
    description = "Avert the disaster foretold in Keita's death clip.",
    points = 3,
    trigger = most_recent_mission == 0x7dc && character_alive("Keita") && prev(on_grid_map()) && !on_grid_map()
)

// Merak Arrives: Win mission without ever getting hit by Circumpolarity.

// *** Unique Teams and Fusion Things ***
// Daichi with Bai Suzhen + ?
// Fuse any Element monster
achievement(
    "Blind Bidder",
    description = "Win an auction through bidding without seeing any of the reactions from other bidders.",
    points = 2,
    trigger = day == 0x09 // TODO needs more auction digging
)
achievement(
    title = "Math Is Not its Strong Suit",
    description = "Have a demon give you back more Macca than the Extra it demanded.",
    points = 2,
    trigger = day == 0x09 // TODO needs more auction digging
)
achievement(
    title="All That Glitters Is Macca, Actually",
    description = "Unlock the Gold tier of auctions.",
    points = 5,
    trigger = bit5(auction_unlock_eligibility) == 0x01
        && non_null_ptr(active_auction_menu)
        && prev(bit2(auctions_unlocked) == 0x00) 
        && bit2(auctions_unlocked) == 0x01
)

// Auctions
// Upgrade to Gold Rank

// Skill-Adjacent Achievements
achievement(
    title = "[IN DEV]All Command Skills",
    description = "Learn all Command skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_command_skills()) == 0x42 && measured(num_learned_command_skills() == 0x43, when=always_true(), format="raw")
)

achievement(
    title = "[IN DEV]All Passive Skills",
    description = "Learn all Passive Skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_passive_skills()) == 0x4b && measured(num_learned_passive_skills() == 0x4c, when=always_true(), format="raw")
)

achievement(
    title = "[IN DEV]All Auto Skills",
    description = "Learn all Auto Skills from Skill Break.",
    points = 25,
    trigger = prev(num_learned_auto_skills()) == 0x1f && measured(num_learned_auto_skills() == 0x20, when=always_true(), format="raw")
)

achievement(
    title = "[IN DEV]All the Skills, Ever",
    description = "Learn all of the learnable skills that can be learned.",
    points = 25,
    trigger = prev(num_learned_command_skills() + num_learned_passive_skills() + num_learned_auto_skills()) == 0xae
        && measured(num_learned_command_skills() + num_learned_passive_skills() + num_learned_auto_skills() == 0xaf, when=always_true(), format="raw")
)

// *** Rich Presence ***

rich_presence_conditional_display(day == 0x01 && in_game_clock == 0x00 && macca == 0x00, "On the title screen")
rich_presence_conditional_display(on_grid_map(), "{0} {1} | In Combat at {2}, {3} | Time on Turn={4} | Time on Mission={5}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_lookup("City", current_city, city),
    rich_presence_value("Time on Turn", current_time_in_mission / 30, "SECS"),
    rich_presence_value("Combat Timer", total_time_in_mission / 30, "SECS")
)

rich_presence_display("{0} {1} 💰 {2} | At {3}, {4} | IGT={5}",
    rich_presence_lookup("Day", day, day_of_week),
    rich_presence_value("Time", in_game_clock, "SECS"),
    rich_presence_value("Macca", macca),
    rich_presence_lookup("Location", current_location, location),
    rich_presence_lookup("City", current_city, city),
    rich_presence_value("In-Game Time", in_game_time / 60, "SECS")
)
// 0x001aff10