# Introduction

1) Text
2) Choices
3) Branching
4) Variables
5) Conditional blocks
6) Actions



# Text

The most basic **Harrow** script is just plain text written in a `.txt` file or a **Twine** `.twee` file. Each line of text creates a new paragraph.

```
The mouth of the cave yawns open, cold air curling out like breath. 
Moss clings to the stones, and the scent of damp earth fills the air.
```

Character dialogue is written using the `:` symbol after the character's name:

```
Kaelen: We’re not turning back now.
```

Comments are marked using `//`.

```
// CaveEntrance

You step forward, heart pounding.
```



# Choices

Choices can be created using the `-` symbol at the beginning of a line.

A choice may include an action, written after a `:` symbol.
There are two types of actions:

1. Route navigation – to jump to another passage.

2. Variable operation – to change or assign a variable.

A choice may also be empty and simply continue the current flow.

```
- Attack : damage = 20
- Drink potion : Heal
- Wait
```

In this example:

- The `Attack` choice uses an action to set damage to 20.

- The `Drink potion` choice uses an action to navigate to the `Heal` route.

- The `Wait` choice has no action and continues the current flow.



# Branching

Branching in Harrow is done using `routes`, which are declared with the `#` symbol at the beginning of a line.
Routes function similarly to `passages` in **Twine**.

To move to a specific route, use an action in a choice or a move command:
`[move RouteName]`.

Important: The story flow stops when a new route begins.
An explicit action is required to transition into that route.

#### Example

Moving via choice:

```
The mouth of the cave yawns open, cold air curling out like breath.
- Enter the cave : CaveInterior


# CaveInterior
You step into the cave. It's cold and silent.
```

Moving via command:

```
The mouth of the cave yawns open, cold air curling out like breath.
[move CaveInterior]


# CaveInterior
You step into the cave. It's cold and silent.
```



# Variables

Variables are declared using square brackets and the `=` operator.

```
[gold = 50]
```

Variables can store numbers or strings.

```
[quest = Find a lost princess.]
[quest.status = completed]
```


#### Random

A variable can be assigned a random value:

```
[dice roll 20]
```


#### Variable operations

Basic mathematical operations (`+`, `-`, `*`, and `/`) are supported. Other variables can be used in calculations.

```
[damage = 20]
[critical roll 20]
[damage + critical]

[enemy.health - damage]
```


#### Printing variables

The value of a variable can be displayed in text using square brackets.

```
[gold = 50]
You have [gold] gold coins.
```

Variables can also be shown inside choices.

```
- I have [gold] gold coins.
- This is to much for this information.
```



# Conditional blocks

A simple `if`.

```
[torch.lit = true]

[if torch.lit = true]
    The torch casts long shadows across the stone walls.
[end]
```

`if/else` condition.

```
[if torch.lit = true]
    The torch casts long shadows across the stone walls.
[else]
    Darkness swallows everything beyond the first few steps.
[end]
```

`chance` condition.

```
[torch.lit = false]

[if torch.lit chance 50]
    [torch.lit = true]
    You fire the torch and long shadows falls across the stone walls.
[end]
```


# Actions

In addition to the `move` command, Harrow supports several built-in **actions** that control the flow of the story. These commands can be used to pause, stop, or trigger external events within the runtime.

### Available Actions

* **`move`**
  Move to another route.

  ```
  [move RouteName]
  ```

* **`wait`**
  Pauses story flow for a specified time.

  ```
  [wait 10]
  ```

* **`lock`**
  Completely halts story execution. No further content will be processed unless triggered externally.

  ```
  [lock]
  ```

* **`close`**
  Stops the story and triggers the `onClose` function.

  ```
  [close]
  ```

* **`story`**
  Stops the current flow and calls the `onStory(name)` function with the specified name as a parameter.
  This can be used to load a new chapter of story into the current runtime.

  ```
  [story ChapterTwo]
  ```

* **`transition`**
  Stops the story and triggers the `onTransition` function.
  Can be used for scene transitions or other UI-related logic.

  ```
  [transition]
  ```
