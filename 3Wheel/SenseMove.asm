;------------------------------------------------------------------------------------- 
; FILE: TimedMove.asm
; DESC: Repository for any calls related to sensed motion of the car
; DATE: 12-01-15
; AUTH: Marie Bomber 
; DEVICE: PICmicro (PIC18F1220) 
;------------------------------------------------------------------------------------- 
	    list	   p=18F1220			   ; Set processor type 
	    radix	   hex				   ; Sets the default radix for data exp. 
	    
#include p18f1220.inc
#include 3WheelInclude.inc
	    
	    GLOBAL	    SMOVE
	    
SMOV:	   code		    0x400
SMOVE:	   CALL		    GROUND			    ; Ground echo pins to insure proper functionality of sensor
	   MOVLW	    0x05	        
	   CALL		    TRIGGER
	   MOVLW	    0x0F			    ; Default to forward motion (01 us)
	   BTFSS	    SMOVCON,	    0		    ; Test for R turn		(02-3 us)
	   BCF		    WREG,	    2
	   BTFSS	    SMOVCON,	    1		    ; Test for L turn		(04-5 us)
	   BCF		    WREG,	    1		    
	   MOVWF	    PORTA			    ; Begin motion		(06 us)
LOOKAGAIN: CLRF		    TEMPR			    ; Clear R sensor count	(07 us)
	   CLRF		    TEMPL			    ; Clear L sensor count	(08 us)
	   MOVLW	    E0				    ; Prepare to copy Distance information from SMOVCON
	   ANDWF	    SMOVCON
	   ;MOVLW	    				    ;				(09 us)
	   MOVWF	    SLOOK			    ;				(10 us)
	   NOP						    ; Buffer			(11 us)
	   CLRF		    PORTB			    ; Clear triggers
LOOK:	   BTFSS	    PORTB,	    RB2		    ; Begin detection loop, as long as L & R sesors are high, there will be no change. 
	   CALL		    LOOKR
	   BTFSS	    PORTB,	    RB1
	   CALL		    LOOKL	   
	   DECF		    SLOOK
	   BNZ		    LOOK
	   CALL		    GROUND			    ; Ground echo pins to insure proper functionality of sensor
	   MOVLW	    0x05	        
	   CALL		    TRIGGER			    ; Start looking again
	   BRA		    LOOKAGAIN
	   
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
	   
GRDELAY:   DECF	    WREG
	   BNZ		    GRDELAY
	   RETURN

LOOKR:	   BTFSS	    SMOVCON,	    2		    ; If R sensor is not used
	   RETURN					    ; Return to LOOK loop
	   

LOOKL:	   
	   
	   

	   End