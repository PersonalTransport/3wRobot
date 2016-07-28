# EDBot Library

This library is an advanced example of how to use the EDBot robot developed by students at Clark College. The library operates on a timing loop and it is quite easy to add your own code into this loop

### Prerequisities

In order to use this library you should be familiar with MPLAB X Ide and have it installed, and you should allready know how to program the EDBot.
And of course you should have access to an EDBot to use.
it would be helpful to know something about the mpasm features I use such as [macro's](docs/macros.md) and [relocatable code](docs/code.md).

### Installing

The EDBot repository contains everything you need to verify the function of the library if you checkout / download the entire repository and open it in XCode as a project.
if you want to integrate the library into your own existing project you want to download or checkout just the CoreLib.X folder and put this inside the root folder of your existing project.
you then need to go to your projects properties menu and go to the library tab

![alt text](https://github.com/PersonalTransport/EDbot/blob/master/img/install_01.png "Library Settings")

Click the add library project folder button, choose the CoreLib.x and click Add. The default settings should be fine. After you hit Add you should have something like this.

![alt text](https://github.com/PersonalTransport/EDbot/blob/master/img/install_02.png "Library Settings")


## Using the library

You can start with the RobotTest.asm file as an example or build your own, the key things to remember are
1. you must set the speed to 4mhz unless you modify the library
```assembly
	movlw   0x60	
	iorwf   OSCCON	; Set to 4mhz
```
2. You have to call core init and enable basic interrupt support in order to get the timing loop to work.
```assembly
; Enable interupts and get ready for sub init code
	bsf INTCON, GIE ; enable interrupts
	bsf INTCON, PEIE ; enable all interrupts
    
	;Do pwm init code.
	call CoreDoInit
```
3. You then need to add something like this for your interrupt code, along with the required directives pointing your interrupt to this location this does the pulse width modulation code for the motors and reads the sensors every 30ms as long as you follow this style of code, you should be able to have your own high priority interrupts.
```assembly
HPRIO:
	btfsc PIR1, TMR2IF ; high priority loop
	bra RobotL
   
	retfie ; Return from interrupt

RobotL: call CoreDoLoop ; PWM_LOOP is responsible to clear the flag.
	;why not clear here
	bra HPRIO	; return to HPRIO in case other interrupts need to be processed.
```

4. at this point if you program te EDBot and run, you should hear a rapid clicking sound from the sensor, this let's you know that the code is sending triggers, if you don't hear anything you should look over your code carefully and ensure that you have interrupts enabled and have set the code entry point for the high priority interrupt correctly.

5. **should explain here how to adjust pwm settings for each wheel
6. **should explain here where I put the sensor data and how to interpret it**




