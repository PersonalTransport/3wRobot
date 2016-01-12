;------------------------------------------------------------------------------------- 
; FILE: Initialize.asm
; DESC: Initialize Call for any car function.
; DATE: 11-10-15
; AUTH: Marie Bomber 
; DEVICE: PICmicro (PIC18F1220) 
;------------------------------------------------------------------------------------- 
	    list	   p=18F1220			   ; Set processor type 
	    radix	   hex				   ; Sets the default radix for data exp. 
	    config	   WDT=OFF, LVP=OFF		   ; Disable Watchdog timer and Low Voltage
	    config	   OSC= INTIO2
    
	    GLOBAL	    INITIALIZE

#include P18F1220.inc
#include 3WheelInclude.inc
	    
	    code	    0x300
INITIALIZE: MOVLW	    0x60
	    IORWF	    OSCCON
	    CLRF	    TMOVCON
	    CLRF	    SENSCON
	    CLRF	    TCOUNT
	    CLRF	    SCOUNT
	    MOVLW	    0x7F
	    MOVWF	    ADCON1
	    CLRF	    TRISA			    ; Set Port A to Output only
	    MOVLW	    0x09
	    MOVWF	    TRISB			    ; Set Port B to 0000 1001 (input on RB1 and RB2)
	    BSF		    PORTB,	    RB5		    ; Ensure on LED is lit
	    BSF		    INTCON,	    GIE		    ; Enable global interrupts
	    BSF		    INTCON,	    PEIE	    ; Enable peripherial interrupts
	    BSF		    INTCON,	    TMR0IE
	    BCF		    INTCON2,	    TMR0IP	    ; Timer 0 enabled and set to low priority (move timer)
	    BSF		    INTCON3,	    INT1IE	    ; Interrupt 1 Enable (Left Sensor)
	    BSF		    INTCON3,	    INT2IE	    ; Interrupt 2 Enable (Right Sensor)
	    BCF		    INTCON3,	    INT1IP	    ; Interrupt 1 set to low priority (Left Sensor)
	    BCF		    INTCON3,	    INT2IP	    ; Interrupt 2 set to low priority (Right Sensor)
	    BCF		    INTCON2,	    INTEDG1	    ; Interrupt 1 set to falling edge (Left Sensor)
	    BCF		    INTCON2,	    INTEDG2	    ; Interrupt 2 set to falling edge (Right Sensor)
	    BSF		    PIE1,	    TMR2IE	    
	    BCF		    IPR1,	    TMR2IP	    ; Timer 2 enabled and set to low priority (sense timer)
	    MOVLW	    0x05
	    MOVWF	    T0CON			    ; 0000 0011 Set Timer 0 to 16 bit, 1:64 pre-scale, internal clock
	    SETF	    TMR0L
	    SETF	    TMR0H			    ; Timer 0 set to 0xFFFF
	    RETURN
	    
	    End