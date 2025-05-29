# harrow
Harrow is a narrative library for stories that need to be told

## Overview
Harrow provides a custom syntax, a parsing library, and a runtime environment designed for interactive narrative games.

## How It Works
1. Use `harrow.Library` to parse a story file into a `harrow.Story` object.

2. Pass the Story to `harrow.Runtime`, which interprets and runs the content.

3. Attach listeners to runtime events like show text, show choices, commands to connect the narrative to UI or game systems.

## Example


```twee
// CaveEntrance

[torchLit = false]

The mouth of the cave yawns open, cold air curling out like breath.

Kaelen: We’re not turning back now.

- Light the torch : torchLit = true
- Enter without a light

You step forward, heart pounding.

[if torchLit = true]
    The torch casts long shadows across the stone walls.
[else]
    Darkness swallows everything beyond the first few steps.
[end]


- Follow the narrow tunnel : Tunnel
- Climb the crumbled ledge : Ledge


# Tunnel
    The tunnel twists sharply, the walls damp and close. 
    A faint sound echoes ahead — like whispering metal.

# Ledge
    The rocks shift underfoot as you climb.
    At the top, a hidden alcove reveals a faded mural of a forgotten king.
```

## How It Works
1. Use harrow.Library to parse a story file into a harrow.Story object.

2. Pass the Story to harrow.Runtime, which interprets and runs the content.

3. Attach listeners to runtime events like showText, showDialogue, and runCommand to connect the narrative to UI and game systems.