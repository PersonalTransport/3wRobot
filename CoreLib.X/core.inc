#ifndef __EDBOT_INC__
#define __EDBOT_INC__

constant MemoryStart = 0x90

extern CoreDoLoop
extern CoreDoInit

cblock MemoryStart
    PWMCONL ;Control register for Left PWM    
    PWMCONR ;Control register for Right PWM
    SensLastL ; last read on Left Sensor
    SensLastR ; Last read on Right sensor
endc
    
#endif