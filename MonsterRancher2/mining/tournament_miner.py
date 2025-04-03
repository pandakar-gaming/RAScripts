from dataclasses import dataclass
import io
import os

import mr2_utility

@dataclass
class TournamentDescription:
    name: str
    grade: str
    tournament_format: str
    number_of_entries: int
    prize: str
    purse: str


def read_tournament_bytes(new_offset, tournament_bytes):
    print(mr2_utility.read_encoded_bytes(bytes(tournament_bytes)))


def mine_tournament(mr2file: io.BufferedReader, base_offset: int, num_tournaments: int):
    tournaments = []
    mr2file.seek(base_offset, os.SEEK_SET)
    starting_offset = base_offset
    for _ in range(0, num_tournaments):
        tournament_bytes = []
        last_byte = None
        num_bytes = 0
        while last_byte != 0xff:
            num_bytes += 0x01
            mr2file.seek(0x00, os.SEEK_CUR)
            last_byte = mr2file.read(0x01)[0]
            tournament_bytes.append(last_byte)
        print(tournament_bytes)
        tournament_bytes = mr2file.read(0x86)
        tournament_reinterpreted = read_tournament_bytes(starting_offset, tournament_bytes)
        tournaments.append(tournament_reinterpreted)
        print(f"original offset of {hex(starting_offset)} -> {hex(starting_offset + num_bytes + 1)}")
        starting_offset += num_bytes + 1
    return tournaments


def mine_tournament_names(mr2file: io.BufferedReader, base_offset: int, num_tournaments: int):
    tournament_names = []
    mr2file.seek(base_offset, os.SEEK_SET)
    starting_offset = base_offset
    for _ in range(0, num_tournaments):
        tournament_name_bytes = []
        num_bytes = 0
        last_byte = None
        while last_byte != 0xff:
            num_bytes += 0x01
            mr2file.seek(0x00, os.SEEK_CUR)
            last_byte = mr2file.read(0x01)[0]
            tournament_name_bytes.append(last_byte)
        tournament_reinterpreted = mr2_utility.read_encoded_bytes(bytes(tournament_name_bytes))
        print(tournament_reinterpreted)
        tournament_names.append(tournament_reinterpreted)

        starting_offset += num_bytes + 1
    return tournament_names
