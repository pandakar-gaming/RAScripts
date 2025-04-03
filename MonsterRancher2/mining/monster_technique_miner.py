"""
Logic for reading a given Technique as defined in Monster Rancher 2. 
"""
from dataclasses import dataclass
import io
import os

import mr2_utility

@dataclass
class Technique:
    offset_found_at: str
    name: str
    move_type: int
    move_range: int
    nature: int
    scaling: int
    available: int
    hit_percentage: int
    force: int
    withering: int
    sharpness: int
    guts_cost: int
    guts_steal: int
    life_steal: int
    life_recovery: int
    force_miss_self: int
    force_hit_self: int

def read_technique_bytes(offset: int, technique_bytes: bytes):
    offset_str = hex(offset)
    name = mr2_utility.read_encoded_bytes(technique_bytes)
    move_type = technique_bytes[0x10]
    move_range = technique_bytes[0x11]
    nature_requirement = int.from_bytes(technique_bytes[0x12:0x13], byteorder='little', signed=True)
    scaling = technique_bytes[0x13]
    is_available = technique_bytes[0x14]
    # more interpretation needs to happen here
    hit_percentage = int.from_bytes(technique_bytes[0x15:0x16], byteorder='little', signed=True)
    force = int.from_bytes(technique_bytes[0x16:0x17], byteorder='little', signed=True)
    withering = technique_bytes[0x17]
    sharpness = technique_bytes[0x18]
    guts_cost = technique_bytes[0x19]
    guts_steal = technique_bytes[0x1a]
    life_steal = technique_bytes[0x1b]
    life_recovery = technique_bytes[0x1c]
    force_miss_self = technique_bytes[0x1d]
    force_hit_self = technique_bytes[0x1e]

    technique = Technique(offset_str, name, move_type, move_range, nature_requirement, scaling, is_available, 
                          hit_percentage, force, withering, sharpness, guts_cost, guts_steal, 
                          life_steal, life_recovery, force_miss_self, force_hit_self)
    print(technique)
    return technique

def mine_techniques(mr2file: io.BufferedReader, base_offset: int):
    techniques = []
    for i in range(0, 24):
        new_offset = base_offset + (0x20 * i)
        # print(f"Reading 0x20 bytes from {hex(new_offset)}")
        mr2file.seek(new_offset, os.SEEK_SET)
        technique_bytes = mr2file.read(0x20)
        techniques_reinterpreted = read_technique_bytes(new_offset, technique_bytes)
        techniques.append(techniques_reinterpreted)
    return techniques
