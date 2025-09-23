"""
Loose ideas here:
- take MR2 binary as input
- start at 0x1ee0df0
- read first two bytes, xor with 0xffff. this is our "number of monsters"
- for i in range (0, numMonsters): 
-     set offset = 0x1ee0df0 + 8 * i
-     interpret bytes as follows
{
  +0x00: Monster Name [16 bytes]. Null-terminated (0xff), rest of bytes are 0x00.
  +0x10: Main Breed [8-bit]
  +0x11: Sub Breed [8-bit]
  +0x12: LIF [16-bit]
  +0x14: POW [16-bit]
  +0x16: DEF [16-bit]
  +0x18: SKI [16-bit]
  +0x1a: SPD [16-bit]
  +0x1c: INT [16-bit]
  +0x1e: Nature [8-bit]
  +0x1f: Fear [8-bit]
  +0x20: Spoil [8-bit]
  +0x24: Flags for Techniques Learned [3 bytes]
  +0x28: Move Speed [8-bit]
  +0x29: Guts Rate [8-bit]
  +0x2c: Battle Special flags [2 bytes]
  +0x2e: 4 empty bytes
  +0x32: 0xffff to signal end of record
}
- dump contents to spreadsheet
- see if it makes sense
- if it does, you know which monster is which maybe! yay!
"""

from dataclasses import dataclass
import io
import os
from typing import Any

import mr2_utility

@dataclass
class Monster:
    offset_found_at: str
    name: str
    main_breed: str # debating if int
    sub_breed: str # debating if int
    LIF: int
    POW: int
    DEF: int
    SKI: int
    SPD: int
    INT: int
    nature: int
    fear: int
    spoil: int
    techniques_learned: list[bool]
    move_speed: int
    guts_rate: int
    battle_special_flags: list[bool]


def determine_battle_specials(battle_special_bytes: bytes) -> dict[str | Any, bool | Any]:
    unity = (battle_special_bytes[1] & 0x10) > 0 # bit 12
    drunk = (battle_special_bytes[1] & 0x08) > 0 # bit 11 
    real  = (battle_special_bytes[1] & 0x04) > 0 # bit 10
    vigor = (battle_special_bytes[1] & 0x02) > 0 # bit 9
    hurry = (battle_special_bytes[1] & 0x01) > 0 # bit 8
    ease  = (battle_special_bytes[0] & 0x80) > 0 # bit 7
    guard = (battle_special_bytes[0] & 0x40) > 0 # bit 6
    fury  = (battle_special_bytes[0] & 0x20) > 0 # bit 5
    fight = (battle_special_bytes[0] & 0x10) > 0 # bit 4
    will  = (battle_special_bytes[0] & 0x08) > 0 # bit 3
    grit  = (battle_special_bytes[0] & 0x04) > 0 # bit 2
    anger = (battle_special_bytes[0] & 0x02) > 0 # bit 1
    power = (battle_special_bytes[0] & 0x01) > 0 # bit 0
    return {
        "unity": unity,
        "drunk": drunk,
        "real": real,
        "vigor": vigor,
        "hurry": hurry,
        "ease": ease,
        "guard": guard,
        "fury": fury,
        "fight": fight,
        "will": will,
        "grit": grit,
        "anger": anger,
        "power": power
    }


def determine_techniques_learned(breed_id: int, technique_bytes: bytes) -> list[bool]:
    all_techniques = mr2_utility.get_techniques_for_breed(breed_id)
    if all_techniques is None:
        return []
    learned_techniques = []
    technique_map = int.from_bytes(technique_bytes, byteorder='little', signed=False)
    for key, value in all_techniques.items():
        learned = (technique_map & (0x01 << key)) > 0
        if learned:
            learned_techniques.append(value) 

    return learned_techniques


def read_monster_bytes(offset: int, monster_bytes: bytes):
    offset_str = hex(offset)
    name = mr2_utility.read_encoded_bytes(monster_bytes)

    main_breed = mr2_utility.lookup_breed(monster_bytes[0x10])
    sub_breed = mr2_utility.lookup_breed(monster_bytes[0x11])
    LIF = int.from_bytes(monster_bytes[0x12:0x14], byteorder='little', signed=True)
    POW = int.from_bytes(monster_bytes[0x14:0x16], byteorder='little', signed=True)
    DEF = int.from_bytes(monster_bytes[0x16:0x18], byteorder='little', signed=True)
    SKI = int.from_bytes(monster_bytes[0x18:0x1a], byteorder='little', signed=True)
    SPD = int.from_bytes(monster_bytes[0x1a:0x1c], byteorder='little', signed=True)
    INT = int.from_bytes(monster_bytes[0x1c:0x1e], byteorder='little', signed=True)
    nature = int.from_bytes(monster_bytes[0x1e:0x1f], byteorder='little', signed=True)
    fear = monster_bytes[0x1f]
    spoil = monster_bytes[0x20]
    techniques_learned = determine_techniques_learned(monster_bytes[0x10], monster_bytes[0x24:0x28])
    move_speed = monster_bytes[0x28]
    guts_rate = monster_bytes[0x29]
    battle_specials = determine_battle_specials(monster_bytes[0x2c:0x2e])

    monster = Monster(offset_str, name, main_breed, sub_breed, LIF, POW, DEF, SKI, SPD, INT, nature, fear, spoil, techniques_learned, move_speed, guts_rate, battle_specials)
    print(monster)
    return monster


def mine_monsters(mr2file: io.BufferedReader, base_offset: int, num_monsters: int):
    monsters = []
    for i in range(0, num_monsters):
        new_offset = base_offset + (0x34*i)
        # print(f"Reading 0x30 bytes from {hex(new_offset)}")
        mr2file.seek(new_offset, os.SEEK_SET)
        monster_bytes = mr2file.read(0x30)
        monster_reinterpreted = read_monster_bytes(new_offset, monster_bytes)
        monsters.append(monster_reinterpreted)
    return monsters

