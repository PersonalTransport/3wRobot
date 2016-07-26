# EDBot Library

This library is an advanced example of how to use the EDBot robot developed by students at Clark College. The library operates on a timing loop and it is quite easy to add your own code into this loop

## Getting Started

*Can I assume they allready have matlab or should I walk through that*

### Prerequisities

In order to use this library you should be familiar with MPLAB X Ide and have it installed, and you should allready know how to program the EDBot.
And of course you should have access to an EDBot to use.

### Installing

The EDBot repository contains everything you need to verify the function of the library if you checkout / download the entire repository and open it in XCode as a project.
if you want to integrate the library into your own existing project you want to download or checkout just the CoreLib.X folder and put this inside the root folder of your existing project.
you then need to go to your projects properties menu and go to the librarys tab like this
![alt text](https://github.com/PersonalTransport/EDbot/blob/master/img/install_01.png "Library Settings")


## Using the library

You can start with the RobotTest.asm file as an example or build your own, the key things to remember are
1) you must set the speed to 4mhz unless you modify the library
```assembly
	movlw   0x60	
	iorwf   OSCCON	; Set to 4mhz
```
2) You have to call core init and enable basic interrupt support in order to get the timing loop to work.
```assembly
; Enable interupts and get ready for sub init code
	bsf INTCON, GIE ; enable interrupts
	bsf INTCON, PEIE ; enable all interrupts
    
	;Do pwm init code.
	call CoreDoInit
```
3) You then need to add something like this for your interrupt code, along with the required directives pointing your interrupt to this location this does the pulse width modulation code for the motors and reads the sensors every 30ms as long as you follow this style of code, you should be able to have your own high priority interrupts.
```assembly
HPRIO:
	btfsc PIR1, TMR2IF ; high priority loop
	bra RobotL
   
	retfie ; Return from interrupt

RobotL: call CoreDoLoop ; PWM_LOOP is responsible to clear the flag.
	;why not clear here
	bra HPRIO	; return to HPRIO in case other interrupts need to be processed.
```





