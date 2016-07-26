# EDBot Library

This library is an advanced example of how to use the EDBot robot developed by students at Clark College. The library operates on a timing loop and it is quite easy to add your own code into this loop

## Getting Started

*Can I assume they allready have matlab or should I walk through that*

### Prerequisities

What things you need to install the software and how to install them

```
Give examples
```

### Installing

A step by step series of examples that tell you have to get a development env running

Stay what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo

## Using the library

You can start with the RobotTest.asm file as an example or build your own, the key things to remember are
1) you must set the speed to 4mhz unless you modify the library
```
movlw   0x60	
    iorwf   OSCCON	; Set to 4mhz
```
2) You have to call core init and enable basic interrupt support in order to get the timing loop to work.
```
; Enable interupts and get ready for sub init code
    bsf INTCON, GIE ; enable interrupts
    bsf INTCON, PEIE ; enable all interrupts
    
    ;Do pwm init code.
    call CoreDoInit
```




