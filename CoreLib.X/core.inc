#ifndef __EDBOT_INC__
#define __EDBOT_INC__

; you can redefine this to wherever you feel like, 90 is default for now
; this lets a user who needs more than 0x10 addresses get more by pushing back 
; our memory.
#ifndef MEM_START
#define MEM_START 0x90
#endif
; this defines the start of the library's memory bank, this can be shifted around
; do not assume you can access any memory past this as the sub modules will use it
    variable MemoryStart = MEM_START

.coreData    udata_ovr MemoryStart
PWMCONL res 1 ;Control register for Left PWM 
PWMCONR res 1 ;Control register for Right PWM
SensLastL res 1 ; last read on Left Sensor
SensLastR res 1 ; Last read on Right sensor

;Increment memory start, if you add more variables avove
;YOU MUST UPDATE THIS!!!!!
MemoryStart += 4

; Please do not define __CORE_SKIP_PUBLIC unless you are extending
; the core library and know what you are doing, this is ment for internal
; header file so that global and extern does not collide
#ifndef __CORE_SKIP_PUBLIC
; this is the public portion of the library anything user accessible should be 
; defined below

    extern CoreDoLoop
    extern CoreDoInit

#endif ; __CORE_SKIP_PUBLIC
#endif ; __EDBOT_INC__