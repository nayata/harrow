# Harrow

Library and a runtime for narrative-driven games.



## Example

```twee
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



## How It Works

1. Use `harrow.Library` to parse a story file into a `harrow.Story` object.

2. Pass the `Story` to `harrow.Runtime`, which interprets and runs the content.

3. Attach listeners to `harrow.Runtime` events like text, choices and actions to connect the narrative to UI or game systems.



## Documentation

* [Writing](https://github.com/nayata/harrow/blob/main/Documentation/Writing.md)
* [Running](https://github.com/nayata/harrow/blob/main/Documentation/Running.md)
* [Twine as editor](https://github.com/nayata/harrow/blob/main/Documentation/Twine.md)

