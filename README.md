# Harrow

![Harrow](/harrow.png "Harrow")

Library and a runtime for narrative-driven games.



## Example

```twee
[health = 80]
[energy = 100]
[potions = 2]


Neon lights flicker across the rain-slicked streets of New Eridu.
Holographic ads scream for your attention as hover-cars zip overhead.
Your comms crackle to life.

Operator: Proxy, this is Control. Hollow anomaly in Sector 7 slums.
Operator: Corrupted Ethereal drone gone rogue - it's assimilating tech and proxies alike.
Operator: Neutralize it before it breaches the outer wall. Gear up and move out.

- Check Inventory : Inventory
- Move to Factory : Factory


# Inventory

Health [health] | Energy [energy]
Potion [potions] (Restore 30 health)

Your plasma rifle hums softly, charging indicator glowing blue. Standard-issue, reliable.
Base Damage [damage]

[move Factory]


# Factory
Rusted gates creak open. Inside, machinery groans under red emergency lights.
A massive shadow lurches forward - the Corrupted Drone.

It screeches: "Intruder... assimilate!"

[move Battle]
```



## How It Works

1. Use `harrow.Library` to parse a story file into a `harrow.Story` object.
2. Pass the `Story` to `harrow.Runtime`, which interprets and runs the content.
3. Attach listeners to `harrow.Runtime` events like text, choices and actions to connect the narrative to UI or game systems.



## Documentation

* [Writing](https://github.com/nayata/harrow/blob/main/Documentation/Writing.md)
* [Running](https://github.com/nayata/harrow/blob/main/Documentation/Running.md)
* [Twine](https://github.com/nayata/harrow/blob/main/Documentation/Twine.md)

