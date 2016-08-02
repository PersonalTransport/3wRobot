# Relocateable Code basics#
**note** this is not a replacement for official documentation, just a quick rundown

Up to this point you have probabally been using one file for all of your assembly code, if you look at my library you will notice I use lots of files.
When mpasm compiles my code it chooses where to put the bytecode based on the code directives I have supplied. this requires a slight shift from what you have been doing, but not by much.
The tick is to replace your ORG directives with code directives as so.
```assembly
.PWM code
```
.PWM is a label and can be anything, I prepend my code labels with a period to separate them from other labels, you can goto or jump to this label using standard methods, but it is generally not recomended to do so.
