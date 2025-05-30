# Introduction

![Twine](/twine.png "Twine")

**Harrow** uses a flow-based execution model, unlike systems such as **Twine**, which display the entire content of a passage at once. In Harrow, content is revealed step-by-step, following the flow of the story.

Depending on the page type, the flow may automatically continue to the next page or pause, waiting for an external command to proceed.


# Before start

Install the library from haxelib:

```
haxelib install harrow
```

Alternatively the dev version of the library can be installed from github:

```
haxelib git harrow https://github.com/nayata/harrow.git
```

Include the library in your project's `.hxml`:

```
-lib harrow
```


See [Running](Running.md) for more information.
