"""
Entrypoint for parsing everything from Monster Rancher 2's PSX binary.
Give it the full path to your binary and it will attempt to do the following:
- read all techniques associated with every Monster variant
- read all tournament Monster data

Roadmap:
- items
- tournaments
- anything else that looks fun?
"""
import argparse
import io
import os
from pathlib import Path

import monster_technique_miner
import tournament_miner
import tournament_monster_miner


def mine_all_tournament_monsters(mr2file: io.BufferedReader) -> list:
    # Monsters
    monsters = []
    mr2file.seek(0x1ee0df0, os.SEEK_SET)
    num_monsters = mr2file.read(2)
    num_monsters = int.from_bytes(num_monsters, byteorder='big') ^ 0xffff
    print(num_monsters)
    monsters.extend(tournament_monster_miner.mine_monsters(mr2file, 0x1ee0dc4, 27))
    # monsters.extend(find_monsters(mr2file, 0x1ee0df8, 26))
    print("--")
    monsters.extend(tournament_monster_miner.mine_monsters(mr2file, 0x1ee1470, 40))
    print("--")
    monsters.extend(tournament_monster_miner.mine_monsters(mr2file, 0x1eecc50, 39))
    print("--")
    monsters.extend(tournament_monster_miner.mine_monsters(mr2file, 0x1eed56c, 34))
    return monsters


def mine_all_techniques(mr2file: io.BufferedReader) -> list:
    techniques = []
    ##############################################################################
    #                              PIXIES                                        #
    ##############################################################################
    # Monster 001, Pixie (Pixie/Pixie)
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x24fe0b8))
    # Monster 002, Daina (Pixie/Dragon)
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x25d6868))
    # Monster 003, Unico (Pixie/Centaur)
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2663c88))
    # Monster 004, Jilt (Pixie/Wracky)
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x273c438))
    # Monster 005, Granity (Pixie/Golem)
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x27c9858))
    # Monster 006, Dixie (Pixie/Zuum)
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x28a2008))
    # Monster 007, Janne (Pixie/Durahan)
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x292f428))
    # Monster 008, Mint (Pixie/Tiger).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2a07bd8))
    # Monster 009, Lepus (Pixie/Hare).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2a94ff8))
    # Monster 010, Angel (Pixie/Gali).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2b6d7a8))
    # Monster 011, Kitten (Pixie/Kato).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2bfabc8))
    # Monster 012, Jinnee (Pixie/Bajarl).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2cd3378))
    # 13, Futurity (Pixie/Metalner).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2d60798))
    # 14, Vanity (Pixie/Suezo).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2e38f48))
    # 15, Snowy (Pixie/Jill).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2ec6368))
    # 16, Lilim (Pixie/Joker).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x2f9eb18))
    # 17, Nagisa (Pixie/Jell).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x302bf38))
    # 18, Dryad (Pixie/Mock).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x31046e8))
    # 19, Serenity (Pixie/Plant).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x3191b08))
    # 20, Silhouette (Pixie/Monol).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x326a2b8))
    # 21, Night Flyer (Pixie/Worm).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x32f76d8))
    # 22, Allure (Pixie/Naga).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x33cfe88))
    # 23, Poison (Pixie/???).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x345d2a8))
    # 24, Kasumi (Pixie/???).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x3535a58))
    # 25, Mia (Pixie/???).
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x35c2e78))

    ################################################################################# 
    # Important Note; There are more Pixie move references. 25 more, to be precise.
    # 26-50 in game file begin at 0x369b628. 
    # Not writing them out right now because I don't know which set is used, or why.
    #################################################################################

    ##############################################################################
    #                              DRAGONS                                       #
    ##############################################################################

    # 26, Tiamat (Dragon/Pixie).
    # Dragon, ??
    techniques.extend(monster_technique_miner.mine_techniques(mr2file, 0x47ed808))

    # TODO get move order for the following
    ##############################################################################
    #                              CENTAURS                                      #
    ##############################################################################

    # 0x02 = Centaur

    ##############################################################################
    #                              COLORPANDORA                                  #
    ##############################################################################

    # 0x03 = ColorPandora

    ##############################################################################
    #                              BEACLONS                                      #
    ##############################################################################

    # 0x04 = Beaclon

    ##############################################################################
    #                              HENGER                                        #
    ##############################################################################

    # 0x05 = Henger

    ##############################################################################
    #                              WRACKYS                                       #
    ##############################################################################
    # or is it Wrackies plural? Why do you want to have more than one?!

    # 0x06 = Wracky

    ##############################################################################
    #                              GOLEMS                                        #
    ##############################################################################

    # 0x07 = Golem

    ##############################################################################
    #                              ZUUMS                                         #
    ##############################################################################

    # 0x08 = Zuum

    ##############################################################################
    #                              DURAHANS                                      #
    ##############################################################################

    # 0x09 = Durahan
    ##############################################################################
    #                              ARROWHEADS                                    #
    ##############################################################################

    # 0x0a = Arrowhead

    ##############################################################################
    #                              TIGERS                                        #
    ##############################################################################

    # 0x0b = Tiger

    ##############################################################################
    #                              HOPPERS                                      #
    ##############################################################################

    # 0x0c = Hopper

    ##############################################################################
    #                              HARES                                         #
    ##############################################################################

    # 0x0d = Hare

    ##############################################################################
    #                              BAKUS                                         #
    ##############################################################################

    # 0x0e = Baku

    ##############################################################################
    #                              GALIS                                         #
    ##############################################################################

    # 0x0f = Gali
    ##############################################################################
    #                              KATOS                                         #
    ##############################################################################

    # 0x10 = Kato
    ##############################################################################
    #                              ZILLAS                                        #
    ##############################################################################

    # 0x11 = Zilla
    ##############################################################################
    #                              BAJARLS                                       #
    ##############################################################################

    # 0x12 = Bajarl
    ##############################################################################
    #                              MEWS                                          #
    ##############################################################################

    # 0x13 = Mew
    ##############################################################################
    #                              PHOENIXES                                     #
    ##############################################################################

    # 0x14 = Phoenix
    ##############################################################################
    #                              GHOSTS                                        #
    ##############################################################################

    # 0x15 = Ghost
    ##############################################################################
    #                              METALNERS                                     #
    ##############################################################################

    # 0x16 = Metalner
    ##############################################################################
    #                              SUEZOS                                        #
    ##############################################################################

    # 0x17 = Suezo
    ##############################################################################
    #                              JILLS                                         #
    ##############################################################################

    # 0x18 = Jill
    ##############################################################################
    #                              MOCCHIS                                       #
    ##############################################################################

    # 0x19 = Mocchi
    ##############################################################################
    #                              JOKERS                                        #
    ##############################################################################

    # 0x1a = Joker
    ##############################################################################
    #                              GABOOS                                        #
    ##############################################################################

    # 0x1b = Gaboo
    ##############################################################################
    #                              JELLS                                         #
    ##############################################################################

    # 0x1c = Jell
    ##############################################################################
    #                              UNDINES                                       #
    ##############################################################################

    # 0x1d = Undine
    ##############################################################################
    #                              NITONS                                        #
    ##############################################################################

    # 0x1e = Niton
    ##############################################################################
    #                              MOCKS                                         #
    ##############################################################################

    # 0x1f = Mock
    ##############################################################################
    #                              DUCKENS                                       #
    ##############################################################################

    # 0x20 = Ducken
    ##############################################################################
    #                              PLANTS                                        #
    ##############################################################################

    # 0x21 = Plant
    ##############################################################################
    #                              MONOLS                                        #
    ##############################################################################

    # 0x22 = Monol
    ##############################################################################
    #                              APES                                          #
    ##############################################################################

    # 0x23 = Ape
    ##############################################################################
    #                              WORMS                                         #
    ##############################################################################

    # 0x24 = Worm
    ##############################################################################
    #                              NAGAS                                         #
    ##############################################################################
    # 0x25 = Naga

    return techniques


def mine_all_tournaments(mr2file):
    """
    {

    }    
    """

    # HEROES CUP
    # offset = 0x24b6520 + 0x08
    # NAGEEL CUP
    offset = 0x15a48aa0
    tournaments = tournament_miner.mine_tournament(mr2file, 0x15a4877b, 13)
    # tournament_miner.mine_tournament(mr2file, 0x15a48aa0, 4)
    # end = 0x15a48b24
    # mr2file.seek(offset, os.SEEK_SET)
    # our_bytes = mr2file.read(0x84)


def mine_all_tournament_names(mr2file):
    tournament_names = tournament_miner.mine_tournament_names(mr2file, 0x1EF159B, 36)
    tournament_names = tournament_miner.mine_tournament_names(mr2file, 0x1ef194c, 35)


def read_mr2_binary(filepath: str):
    mr2_binary = Path(filepath)
    if not mr2_binary.exists():
        print(f"Filepath did not resolve to a file: {filepath}")
        return

    with open(filepath, 'rb', encoding=None) as mr2file:
        techniques = mine_all_techniques(mr2file)
        monsters = mine_all_tournament_monsters(mr2file)
        tournaments = mine_all_tournaments(mr2file)
        tournament_names = mine_all_tournament_names(mr2file)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "---filepath", type=str, help="Full path to Monster Rancher 2 binary")
    args = parser.parse_args()

    if args.filepath is None or args.filepath == "":
        parser.print_help()
        return

    read_mr2_binary(args.filepath)


if __name__ == "__main__":
    main()
