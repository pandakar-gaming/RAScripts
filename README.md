A proper explanation for the repo will go here one day. Later.

Note for myself (and others) looking to copy notes from one set to another: you could do this via regex. Way I've been doing this:

1. Find your {set}-Notes.json file and format it using something like Visual Studio Code.
2. Find the notes you want to copy over and copy them over to some scratch file.
3. Run a regex like the following: `\{\n    "User": "pandakar",\n    "Address": "(.*)",\n    "Note": "(.*)"\n\}`
Note that you may have to modify this a bit to match whitespace and your username. The important part is that you're capturing the address in one capture group and the note in another.
4. Replace with the following: N0:$1:"$2"
5. Trim commas off the end and paste the contents into your {set}-User.txt file.