;-------------------------------------------------------------------------------------
; FILE: main.asm
; DESC: Experiment 1 ? Simple Counter
; DATE: 5-18-06
; AUTH: Class
; DEVICE: PICmicro (PIC18F1220)
;-------------------------------------------------------------------------------------
    list p=18F1220 ; Set processor type
    radix hex ; Sets the default radix for data exp.
 config WDT=OFF, LVP=OFF ; Disable Watchdog timer and Low Voltage
#define PORTA 0xF80
#define PORTB 0xF81
#define TRISA 0xF92
#define TRISB 0xF93
#define ADCON1 0xFC1
COUNT equ 0x080
LASTIN equ 0x081
INPUT equ 0x082
TEMP equ 0x083
    org 0x000 ; Set the program origin (start) to absolute 0x000
 ; Initialize all I/O ports
    CLRF PORTA ; Initialize PORTA
    CLRF PORTB ; Initialize PORTB
    MOVLW 0x7F ; Set all A\D Converter Pins as
    MOVWF ADCON1 ; digital I/O pins
    MOVLW 0x00 ; Value used to initialize data direction
    MOVWF TRISB ; Set Port B RB<7:0> as outputs
    MOVLW 0x01 ; Value used to initialize data direction
    MOVWF TRISA ; Set Port A Pin 0 RA<0> as input
    MOVLW 0x00 ; W = 0
    MOVWF COUNT ; COUNT = WREG
    MOVWF LASTIN ; LASTIN = WREG
Loop: MOVFF PORTA, INPUT ; INPUT = PORTA
    MOVF INPUT, 0 ; W = PORTA
    XORWF LASTIN, 0 ; W = W XOR LASTIN
    ANDLW 0x1 ; W = W AND 0x1
    MOVFF INPUT, LASTIN ; LASTIN = PORTA
    MOVWF TEMP ; TEMP = W
    BTFSC TEMP, 0 ; If TEMP<0> = 0 Then Skip Next Command
    CALL IncL
    GOTO Loop
IncL: MOVF COUNT, 0 ; W = COUNT
    ADDLW 1 ; W = W + 1
    MOVWF COUNT ; COUNT = W
    MOVWF PORTB ; PORTB = W
    RETURN
    end ; Indicates the end of the program. 


