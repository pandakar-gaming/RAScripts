Anything in the "mining" folder is intended to read data from the NTSC version of Monster Rancher 2 for the PS1.

To run it, you'll need a modern version of Python. I developed against 3.10.1.

Most complete class is `miner/mr2_utility.py`. This can be used to encode or decode strings using the game's custom encoding, as it does not use ASCII.

# Data Miners

Entry point to run all associated "mining" scripts is mr2_bin_scraper.py. Feed the script your path to the Monster Rancher 2.bin file. 

Loose notes here: techniques seem to be split up per monster "variant." For example, Pixie/Pixie has its own set of techniques available and Pixie/Dragon, the next monster after it, also has its own set of techniques.
It is not feature complete. I got lazy partway through dev once I had gotten a working grip on how techniques were laid out by the game. 

Tournaments, I was able to read some metadata. Don't know where the rest of it is at.

Monsters in tournaments were readily available and simple enough to produce full copies of. I have no idea where errantry monsters are stored, but they're not in the same format. 