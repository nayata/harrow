# Introduction

1) Content
2) Choices
3) Routes
4) Variables
5) Conditional blocks
6) Branching
7) Actions
8) Events



# Variables

Variables can be created using suuared braqets and `=` operator

```
[gold = 50]
```

Variables can be numbers or strings:

```
[quest = Find a lost princess.]
[quest.status = completed]
```


#### Random
```
[dice roll 20]
```


#### Variable operations

```
[damage = 20]
[critical roll 20]
[damage + critical]

[enemy.health - damage]
```


#### Printing variables

The value of a variable can be printed in text using a squared braquets:

```
[gold = 50]
You have [gold] gold coins.
```

The value of a variable can be printed in choices too:

```
- I have [gold] gold coins.
- This is to much for this information.
```



# Conditional blocks

A simple 'if'

```
[torch.lit = true]

[if torch.lit = true]
    The torch casts long shadows across the stone walls.
[end]
```

'if/else' condition

```
[if torch.lit = true]
    The torch casts long shadows across the stone walls.
[else]
    Darkness swallows everything beyond the first few steps.
[end]
```

'chance' condition

```
[torch.lit = false]

[if torch.lit chance 50]
    [torch.lit = true]
    You fire the torch and long shadows falls across the stone walls.
[end]
```
