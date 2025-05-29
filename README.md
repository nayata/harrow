# Harrow

**Harrow** is a custom syntax, a parsing library, and a runtime for narrative-driven games.


## How It Works

1. Use `harrow.Library` to parse a story file into a `harrow.Story` object.

2. Pass the Story to `harrow.Runtime`, which interprets and runs the content.

3. Attach listeners to `harrow.Runtime` events like text, choices and actions to connect the narrative to UI or game systems.


## Example


```twee
// CaveEntrance

[torchLit = false]

The mouth of the cave yawns open, cold air curling out like breath. 
Moss clings to the stones, and the scent of damp earth fills the air. 

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


## Story format

Stories in **Harrow** are written using simple `.txt` files with a minimal custom syntax. Alternatively, **Twine** can be used as a visual editor.

Harrow includes a built-in parser for `.twee` files — the format used by Twine — allowing stories created in Twine to be run directly within the Harrow runtime.


### Twine integration

Link to the Harrow `format.js` for use in the Twine editor:
```
https://nayata.github.io/format/format.js
```

harrow-twine - Twine story format based on Harrow, perfect for testing or even publishing directly in Twine. With syntax highlighting and a custom toolbar for the most commonly used actions.

