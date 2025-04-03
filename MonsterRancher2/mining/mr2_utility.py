"""
General utility script for Monster Rancher 2 things.
"""

def read_encoded_bytes(encoded_bytes: bytes):
    """
    Reads the given sequence of bytes until it runs into the first 0xff byte, then re-encodes as ASCII.
    """
    encoded_name_bytes = []
    # reading name byte-by-byte until we hit the null terminator
    for i in range(0x00, len(encoded_bytes)):
        ind_byte = f"{(encoded_bytes[i]):#04x}"
        if ind_byte == "0xff":
            break
        encoded_name_bytes.append(ind_byte)
    
    name = decode_mr2_string(encoded_name_bytes)
    return name


def get_techniques_for_breed(breed_id: int):
    if breed_id == 0x00: # Pixie
        return {
            0: 'Pat', 
            1: 'Slap', 
            2: 'Aquatico', 
            3: 'Kick', 
            4: 'High Kick', 
            5: 'Heel Raid', 
            6: 'PsyonicBlast', 
            7: 'Bang', 
            8: 'Big Bang', 
            9: '1-2 Punch', 
            10: 'Phantom Claw', 
            11: 'Death Final', 
            12: 'Bolt', 
            13: 'Lightning', 
            14: 'Kiss', 
            15: 'Life Steal', 
            16: 'Refreshment', 
            17: 'Fire Breath', 
            18: 'Flame', 
            19: 'PsyonicBurst', 
            20: 'Gigaflame', 
            21: 'Ray', 
            22: 'Megaray', 
            23: 'Gigaray', 
        }
    if breed_id == 0x01: # Dragon
        return {
            0: 'Tail Whip', 
            1: 'Tail Attack', 
            2: 'Bite', 
            3: 'Two Bites', 
            4: 'Dragon Punch', 
            5: 'Wing Attack', 
            6: 'Wing Combo', 
            7: 'Claw Combo', 
            8: 'Claw', 
            9: 'SpinningClaw', 
            10: 'Flutter', 
            11: 'Flutters', 
            12: 'Trample', 
            13: 'Fire Breath', 
            14: 'Dragon Combo', 
            15: 'Inferno', 
            16: 'Glide Charge', 
            17: 'SlammimgDown', 
            18: 'Flying Combo', 
            19: 'Dummy', 
            20: 'Dummy', 
            21: 'Dummy', 
            22: 'Dummy', 
            23: 'Dummy',
        }
    if breed_id == 0x0e: # Baku
        return {
            0: "Dust Cloud",
            1: "Bite",
            2: "Two Bites",
            3: "Three Bites",
            4: "Tongue Slap",
            5: "Charge",
            6: "Roar",
            7: "Two Roars",
            8: "MillionRoars",
            9: "Diving Press",
            10: "Sneeze",
            11: "Mating Song",
            12: "Foul Wind",
            13: "Gust Breath",
            14: "Hypnotism",
            15: "Nap"
        }
    if breed_id == 0x1a: # Joker
        return {
            0: "Death Punch",
            1: "Death Slash",
            2: "Death Smash",
            3: "Death Cutter",
            4: "Death Energy",
            5: "Death Final"
        }

def lookup_breed(breed: int) -> str:
    """
    Get the breed of Monster based off the given breed ID.
    """
    if breed == 0x00:
        return "Pixie"
    elif breed == 0x01:
        return "Dragon"
    elif breed == 0x02:
        return "Centaur"
    elif breed == 0x03:
        return "ColorPandora"
    elif breed == 0x04:
        return "Beaclon"
    elif breed == 0x05:
        return "Henger"
    elif breed == 0x06:
        return "Wracky"
    elif breed == 0x07:
        return "Golem"
    elif breed == 0x08:
        return "Zuum"
    elif breed == 0x09:
        return "Durahan"
    elif breed == 0x0a:
        return "Arrowhead"
    elif breed == 0x0b:
        return "Tiger"
    elif breed == 0x0c:
        return "Hopper"
    elif breed == 0x0d:
        return "Hare"
    elif breed == 0x0e:
        return "Baku"
    elif breed == 0x0f:
        return "Gali"
    elif breed == 0x10:
        return "Kato"
    elif breed == 0x11:
        return "Zilla"
    elif breed == 0x12:
        return "Bajarl"
    elif breed == 0x13:
        return "Mew"
    elif breed == 0x14:
        return "Phoenix"
    elif breed == 0x15:
        return "Ghost"
    elif breed == 0x16:
        return "Metalner"
    elif breed == 0x17:
        return "Suezo"
    elif breed == 0x18:
        return "Jill"
    elif breed == 0x19:
        return "Mocchi"
    elif breed == 0x1a:
        return "Joker"
    elif breed == 0x1b:
        return "Gaboo"
    elif breed == 0x1c:
        return "Jell"
    elif breed == 0x1d:
        return "Undine"
    elif breed == 0x1e:
        return "Niton"
    elif breed == 0x1f:
        return "Mock"
    elif breed == 0x20:
        return "Ducken"
    elif breed == 0x21:
        return "Plant"
    elif breed == 0x22:
        return "Monol"
    elif breed == 0x23:
        return "Ape"
    elif breed == 0x24:
        return "Worm"
    elif breed == 0x25:
        return "Naga"
    elif breed == 0x26:
        return "??? (Enemy)"
    elif breed == 0x27:
        return "???"
    elif breed == 0x28:
        return "???"
    elif breed == 0x29:
        return "???"
    elif breed == 0x2a:
        return "???"
    elif breed == 0x2b:
        return "???"
    elif breed == 0x2c:
        return None
    elif breed == 0x2d:
        return None
    elif breed == 0x2e:
        return None
import argparse

def decode_mr2_string(encoded_bytes: list):
    """
    Given a list of two-character strings representing bytes, return the list of bytes as if it were a String in Monster Rancher 2.
    """
    ascii_string = ""
    for hex_byte in encoded_bytes:
        hex_byte = hex_byte.replace("0x", "")

        if hex_byte == "00":
            ascii_string += " "
        elif hex_byte == "01":
            ascii_string += "0"
        elif hex_byte == "02":
            ascii_string += "1"
        elif hex_byte == "03":
            ascii_string += "2"
        elif hex_byte == "04":
            ascii_string += "3"
        elif hex_byte == "05":
            ascii_string += "4"
        elif hex_byte == "06":
            ascii_string += "5"
        elif hex_byte == "07":
            ascii_string += "6"
        elif hex_byte == "08":
            ascii_string += "7"
        elif hex_byte == "09":
            ascii_string += "8"
        elif hex_byte == "0a":
            ascii_string += "9"
        elif hex_byte == "0b":
            ascii_string += "A"
        elif hex_byte == "0c":
            ascii_string += "B"
        elif hex_byte == "0d":
            ascii_string += "C"
        elif hex_byte == "0e":
            ascii_string += "D"
        elif hex_byte == "0f":
            ascii_string += "E"
        elif hex_byte == "10":
            ascii_string += "F"
        elif hex_byte == "11":
            ascii_string += "G"
        elif hex_byte == "12":
            ascii_string += "H"
        elif hex_byte == "13":
            ascii_string += "I"
        elif hex_byte == "14":
            ascii_string += "J"
        elif hex_byte == "15":
            ascii_string += "K"
        elif hex_byte == "16":
            ascii_string += "L"
        elif hex_byte == "17":
            ascii_string += "M"
        elif hex_byte == "18":
            ascii_string += "N"
        elif hex_byte == "19":
            ascii_string += "O"
        elif hex_byte == "1a":
            ascii_string += "P"
        elif hex_byte == "1b":
            ascii_string += "Q"
        elif hex_byte == "1c":
            ascii_string += "R"
        elif hex_byte == "1d":
            ascii_string += "S"
        elif hex_byte == "1e":
            ascii_string += "T"
        elif hex_byte == "1f":
            ascii_string += "U"
        elif hex_byte == "20":
            ascii_string += "V"
        elif hex_byte == "21":
            ascii_string += "W"
        elif hex_byte == "22":
            ascii_string += "X"
        elif hex_byte == "23":
            ascii_string += "Y"
        elif hex_byte == "24":
            ascii_string += "Z"
        elif hex_byte == "25":
            ascii_string += "a"
        elif hex_byte == "26":
            ascii_string += "b"
        elif hex_byte == "27":
            ascii_string += "c"
        elif hex_byte == "28":
            ascii_string += "d"
        elif hex_byte == "29":
            ascii_string += "e"
        elif hex_byte == "2a":
            ascii_string += "f"
        elif hex_byte == "2b":
            ascii_string += "g"
        elif hex_byte == "2c":
            ascii_string += "h"
        elif hex_byte == "2d":
            ascii_string += "i"
        elif hex_byte == "2e":
            ascii_string += "j"
        elif hex_byte == "2f":
            ascii_string += "k"
        elif hex_byte == "30":
            ascii_string += "l"
        elif hex_byte == "31":
            ascii_string += "m"
        elif hex_byte == "32":
            ascii_string += "n"
        elif hex_byte == "33":
            ascii_string += "o"
        elif hex_byte == "34":
            ascii_string += "p"
        elif hex_byte == "35":
            ascii_string += "q"
        elif hex_byte == "36":
            ascii_string += "r"
        elif hex_byte == "37":
            ascii_string += "s"
        elif hex_byte == "38":
            ascii_string += "t"
        elif hex_byte == "39":
            ascii_string += "u"
        elif hex_byte == "3a":
            ascii_string += "v"
        elif hex_byte == "3b":
            ascii_string += "w"
        elif hex_byte == "3c":
            ascii_string += "x"
        elif hex_byte == "3d":
            ascii_string += "y"
        elif hex_byte == "3e":
            ascii_string += "z"
        elif hex_byte == "3f":
            ascii_string += "."
        elif hex_byte == "40":
            ascii_string += "∙"
        elif hex_byte == "41":
            ascii_string += "!"
        elif hex_byte == "42":
            ascii_string += "?"
        elif hex_byte == "43":
            ascii_string += "-"
        elif hex_byte == "44":
            ascii_string += "."
        elif hex_byte == "54":
            ascii_string += "`"
    
    return ascii_string


def encode_ascii_string(string_to_translate):
    new_encoding = []
    # going to write out the full encoding char by char
    # maybe if I feel like it later I'll make it elegant
    for char in string_to_translate:
        if char == " ":
            new_encoding.append(0x00)
        elif char == "0":
            new_encoding.append(0x01)
        elif char == "1":
            new_encoding.append(0x02)
        elif char == "2":
            new_encoding.append(0x03)
        elif char == "3":
            new_encoding.append(0x04)
        elif char == "4":
            new_encoding.append(0x05)
        elif char == "5":
            new_encoding.append(0x06)
        elif char == "6":
            new_encoding.append(0x07)
        elif char == "7":
            new_encoding.append(0x08)
        elif char == "8":
            new_encoding.append(0x09)
        elif char == "9":
            new_encoding.append(0x0a)
        elif char == "A":
            new_encoding.append(0x0b)
        elif char == "B":
            new_encoding.append(0x0c)
        elif char == "C":
            new_encoding.append(0x0d)
        elif char == "D":
            new_encoding.append(0x0e)
        elif char == "E":
            new_encoding.append(0x0f)
        elif char == "F":
            new_encoding.append(0x10)
        elif char == "G":
            new_encoding.append(0x11)
        elif char == "H":
            new_encoding.append(0x12)
        elif char == "I":
            new_encoding.append(0x13)
        elif char == "J":
            new_encoding.append(0x14)
        elif char == "K":
            new_encoding.append(0x15)
        elif char == "L":
            new_encoding.append(0x16)
        elif char == "M":
            new_encoding.append(0x17)
        elif char == "N":
            new_encoding.append(0x18)
        elif char == "O":
            new_encoding.append(0x19)
        elif char == "P":
            new_encoding.append(0x1a)
        elif char == "Q":
            new_encoding.append(0x1b)
        elif char == "R":
            new_encoding.append(0x1c)
        elif char == "S":
            new_encoding.append(0x1d)
        elif char == "T":
            new_encoding.append(0x1e)
        elif char == "U":
            new_encoding.append(0x1f)
        elif char == "V":
            new_encoding.append(0x20)
        elif char == "W":
            new_encoding.append(0x21)
        elif char == "X":
            new_encoding.append(0x22)
        elif char == "Y":
            new_encoding.append(0x23)
        elif char == "Z":
            new_encoding.append(0x24)
        elif char == "a":
            new_encoding.append(0x25)
        elif char == "b":
            new_encoding.append(0x26)
        elif char == "c":
            new_encoding.append(0x27)
        elif char == "d":
            new_encoding.append(0x28)
        elif char == "e":
            new_encoding.append(0x29)
        elif char == "f":
            new_encoding.append(0x2a)
        elif char == "g":
            new_encoding.append(0x2b)
        elif char == "h":
            new_encoding.append(0x2c)
        elif char == "i":
            new_encoding.append(0x2d)
        elif char == "j":
            new_encoding.append(0x2e)
        elif char == "k":
            new_encoding.append(0x2f)
        elif char == "l":
            new_encoding.append(0x30)
        elif char == "m":
            new_encoding.append(0x31)
        elif char == "n":
            new_encoding.append(0x32)
        elif char == "o":
            new_encoding.append(0x33)
        elif char == "p":
            new_encoding.append(0x34)
        elif char == "q":
            new_encoding.append(0x35)
        elif char == "r":
            new_encoding.append(0x36)
        elif char == "s":
            new_encoding.append(0x37)
        elif char == "t":
            new_encoding.append(0x38)
        elif char == "u":
            new_encoding.append(0x39)
        elif char == "v":
            new_encoding.append(0x3a)
        elif char == "w":
            new_encoding.append(0x3b)
        elif char == "x":
            new_encoding.append(0x3c)
        elif char == "y":
            new_encoding.append(0x3d)
        elif char == "z":
            new_encoding.append(0x3e)
        elif char == ".":
            new_encoding.append(0x3f)
        elif char == "`":
            new_encoding.append(0x54)
    return new_encoding

def encode(mr2_str):
    print(f"Original string encoding of ['{mr2_str}']")
    for char in mr2_str:
        hex_encoded_char = char.encode("utf-8").hex()
        print(f"{char}=0x{hex_encoded_char}")
    new_encoding = encode_ascii_string(mr2_str)
    print("Same bytes, in order: ")
    for i in range(len(new_encoding)):
        print(f"{mr2_str[i]}={new_encoding[i]:#04x}")

def decode(hex_str):
    # print(f"Inputted hex: {hex_str}")
    hex_str = hex_str.replace("0x", "")
    individual_bytes = [hex_str[i:i+2] for i in range(0, len(hex_str), 2)]
    decoded_str = decode_mr2_string(individual_bytes)
    formatted_output = f"{' '.join(individual_bytes)}\n{'  '.join(decoded_str)}\n{len(decoded_str)} bytes"
    # print(decoded_str)
    print(formatted_output)

def main():
    parser = argparse.ArgumentParser("MR2 Encoding Shifter")
    parser.add_argument("-e", "--encode", action="store_true", help="If we need to shift ASCII to MR2")
    parser.add_argument("-d", "--decode", action="store_true", help="MR2 to ASCII. Expect format of 0x__??__??")
    parser.add_argument("mr2_string", help="The string you need translated")
    args = parser.parse_args()

    if args.encode:
        encode(args.mr2_string)
    elif args.decode:
        decode(args.mr2_string)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()