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
	    
	    GLOBAL	    SENSE
	    
SENS:	   code		    0x600
SENSE:	   CALL		    GROUND			    ; Ground echo pins to insure proper functionality of sensor
	   MOVLW	    0x05	        
	   CALL		    TRIGGER

	   
	   
TRIGGER:   MOVWF	    WREG			    ; Prepare WREG for sensor set up
	   BTFSC	    SMOVCON,	    2		    ; Test for use of R Sensor
	   BCF		    WREG,	    0		    ; If R sensor only is needed, clear L sensor trigger bit
	   BTFSC	    SMOVCON,	    3		    ; Test for use of L Sensor
	   BCF		    WREG,	    3		    ; If L sensor only is needed, clear R sensor trigger bit
	   MOVWF	    PORTB			    ; Set Trigger ~10 us before sense loop begins	   
	   RETURN
    
    
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
    
    
    
    
    
    
	    End	


