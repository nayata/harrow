# Introduction

**Harrow** is a narrative library for creating interactive stories and choice-based games.

Stories consist of text, character dialogue, variables, choices, actions, events and conditional logic. Each line is processed as an individual story element.

Harrow scripts can be written as plain text files, exported from **Twine** as `.twee` files, or stored using the `.story` extension. For `.story` files, syntax highlighting is available through the Harrow syntax definition:

https://github.com/nayata/harrow/tree/main/harrow-syntax



# Text

Story text is written directly as plain text. Each line creates a separate paragraph in the story.

```
The mouth of the cave yawns open, cold air curling out like breath. 
Moss clings to the stones, and the scent of damp earth fills the air.
```

Character dialogue is written using the `:` symbol after the character's name.

```
Kaelen: We’re not turning back now.
```

Comments are marked using `//`.

```
// CaveEntrance

You step forward, heart pounding.
```



# Choices

Choices are created by starting a line with the `-` symbol.

A choice consists of visible text followed by one or more optional fields separated by `:`.

```
Text : Route : Action : Condition
```

All fields except the choice text are optional.

- **Route** - moves to another route.
- **Action** - changes or assigns a variable, or performs another supported operation.
- **Condition** - stores a condition associated with the choice.

A choice with no additional fields simply continues the current route.

Example:

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

**Important:** The story flow stops when a new route begins.
An explicit action is required to transition into that route.

#### Example

Moving via choice:

```
The mouth of the cave yawns open, cold air curling out like breath.
- Enter the cave : Cave


# Cave
You step into the cave. It's cold and silent.
```

Moving via command:

```
The mouth of the cave yawns open, cold air curling out like breath.
[move Cave]


# Cave
You step into the cave. It's cold and silent.
```



# Variables

Variables are declared using square brackets and the `=` operator.

```
[gold = 50]
```

Variables can store numbers or strings.

```
[quest = Find the tomb of the forgotten king.]
[quest.status = completed]
```


#### Random

A variable can be assigned a random value:

```
[dice roll 20]
```


#### Variable operations

Basic mathematical operations (`+`, `-`, `*`, `/`, and `%`) are supported. Other variables can be used in calculations.

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
- This is too much for this information.
```



# Conditional blocks

A simple `if`.

```
[torch.lit = true]

[if torch.lit == true]
    The torch casts long shadows across the stone walls.
[end]
```

`if/else` condition. As an alternative to `==`, Harrow also supports the `is` operator for equality comparisons.

```
[if torch.lit is true]
    The torch casts long shadows across the stone walls.
[else]
    Darkness swallows everything beyond the first few steps.
[end]
```


## CoG-style Fairmath

Harrow includes support for **Fairmath**, the percentage-based stat system popularized by *Choice of Games*.

Unlike simple addition and subtraction, Fairmath makes large values harder to increase and small values harder to decrease. This produces smooth character progression without allowing statistics to reach their minimum or maximum too quickly.

Fairmath is available for any numeric variable using the `%+` and `%-` operators.

```
[strength %+ 20]
[morality %- 15]
```

Because Fairmath values are stored as normal variables, they can be used anywhere a regular variable can be used, including conditions.

```
[if strength >= 70]
    You effortlessly force the door open.
[else]
    The door refuses to budge.
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
  Completely halts story execution and triggers the `onLock` function. No further content will be processed unless triggered externally.

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
  Stops the story and triggers the `onTransition(name)` function.
  Can be used for scene transitions or other UI-related logic.

  ```
  [transition Fade]
  ```



# Events

Custom events can be defined using square brackets, as long as the event name does not conflict with existing **action**, **condition**, or **variable** keywords.

When a custom event is encountered, it will trigger the function:

```
onEvent(type, data)
```

* `type` - the part of the event before the first space
* `data` - the remaining content after the first space

This mechanism allows for custom logic, UI updates, sound effects, or any external behavior needed during story execution.

### Example:

```
[sound play cave_wind.ogg]
[show image cave_entrance.png]
```


> [!WARNING]
> Whitespace is significant in variable expressions, conditions, commands, and events. Operators and arguments must be separated by spaces. Otherwise, they will not be parsed correctly.
>
> ✔ `[gold + 20]`
>
> ✘ `[gold+20]`

See [Running](Running.md) for more information.
