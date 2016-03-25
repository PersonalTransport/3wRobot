;------------------------------------------------------------------------------------- 
; FILE: Sensor.asm
; DESC: Repository for any calls related to sensor use
; DATE: 12-01-15
; AUTH: Marie Bomber 
; DEVICE: PICmicro (PIC18F1220) 
;------------------------------------------------------------------------------------- 
    
 	    list	   p=18F1220			   ; Set processor type 
	    radix	   hex				   ; Sets the default radix for data exp. 
	    
#include P18F1220.inc
#include 3WheelInclude.inc
	    
	    GLOBAL	    SENSE, SLEFT, SRIGHT, NOTFOUND
	    
SENS:	   code		    0x600
SENSE:	   CALL		    GROUND			    ; Ground echo pins to insure proper functionality of sensor
	   MOVLW	    0x05			    ; Prepare WREG for sensor set up
	   CALL		    TRIGGER			    ; Set trigger high to begin sense cycle
	   MOVLW	    0x38			    ; count for trigger (3 us)
	   MOVWF	    T2CON			    ; 0000 0011 Set Timer 2 1:8 Postscale, no Prescale (4 us)
	   CLRF		    TMR2			    ; Clear timer 2, allows 2.04 millisecond sense period (5 us)
	   NOP
	   NOP
	   NOP
	   NOP
	   NOP
	   NOP						    ; 6 additional us of delay before trigger ground.
	   CLRF		    PORTB			    ; Disable trigger
	   BSF		    T2CON, TMR2ON		    ; Begin sense cycle
	   RETURN					    ; Return to student's code
	   

	   
	   
	   
	   
TRIGGER:   BTFSC	    SMOVCON,	    2		    ; Test for use of R Sensor
	   BCF		    WREG,	    0		    ; If R sensor only is needed, clear L sensor trigger bit
	   BTFSC	    SMOVCON,	    3		    ; Test for use of L Sensor
	   BCF		    WREG,	    3		    ; If L sensor only is needed, clear R sensor trigger bit
	   MOVWF	    PORTB			    ; Set Trigger ~10 us before sense loop begins	   
	   RETURN					    ; Count for trigger, 2 us
    
    
GROUND:	   BTFSC	    SMOVCON,	    2		    ; Test for use of R sensor
	   BCF		    TRISB,	    RB2		    ; Ground R. Echo
	   BTFSC	    SMOVCON,	    3		    ; Test for use of L sensor
	   BCF		    TRISB,	    RB1		    ; Ground L. Echo
	   MOVLW	    0x06
	   CALL		    GRDELAY			    ; Delay ~25 us
	   MOVLW	    0x0A			    
	   MOVWF	    TRISB			    ; Set R and L echo back to input
	   RETURN
	   
GRDELAY:   DECF		    WREG
	   BNZ		    GRDELAY
	   RETURN	   
    
SLEFT:	   BCF		    T2CON,	    TMR2ON	    ; Turn off timer and use for measurement.
	   BCF		    INTCON3,	    INT1IF	    ; Clear interrupt flag
	   MOVFF	    TMR2,	    DISTL	    ; Copy contents of TMR2 to distance register (left)
	   RRNCF	    DISTL
	   RRNCF	    DISTL
	   RRNCF	    DISTL			    ; Divide by 8 (via rotation)
	   BCF		    DISTL,	    7		    
	   BCF		    DISTL,	    6		   
	   BCF		    DISTL,	    5		    ; Clear upper 3 bits of DISTL for accurate measurement
	   INCF		    SCOUNT			    ; Increase SCOUNT for stage management
	   RETURN
	   
	   
	    
SRIGHT:	   BCF		    T2CON,	    TMR2ON	    ; Turn off timer and use for measurement.
	   BCF		    INTCON3,	    INT2IF	    ; Clear interrupt flag
	   MOVFF	    TMR2,	    DISTR	    ; Copy contents of TMR2 to distance register (left)
	   RRNCF	    DISTR
	   RRNCF	    DISTR
	   RRNCF	    DISTR			    ; Divide by 8 (via rotation)
	   BCF		    DISTR,	    7		    
	   BCF		    DISTR,	    6		   
	   BCF		    DISTR,	    5		    ; Clear upper 3 bits of DISTL for accurate measurement
	   INCF		    SCOUNT			    ; Increase SCOUNT for stage management
	   RETURN
	    
NOTFOUND:  BCF		    T2CON,	    TMR2ON	    ; Turn off timer
	   BCF		    PIR1,	    TMR2IF	    ; Clear interrupt flag
	   CLRF		    DISTL			    ; Clear distance left measurement
	   CLRF		    DISTR			    ; Clear distance right measurement
	   INCF		    SCOUNT			    ; Increase SCOUNT for stage management
	   RETURN    
    
	    End	


