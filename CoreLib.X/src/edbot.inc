extern CoreDoLoop
extern CoreDoInit

cblock 0x90
    PWMCONL ;Control register for Left PWM    
    PWMCONR ;Control register for Right PWM
    SensLastL ; last read on Left Sensor
    SensLastR ; Last read on Right sensor
endc