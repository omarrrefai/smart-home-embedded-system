
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;MyProject.c,38 :: 		void interrupt(void) {
;MyProject.c,39 :: 		if (INTCON & 0x02)   // External Interrupt - IR SENSOR
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt0
;MyProject.c,42 :: 		for (ii = 0; ii < 5; ii++)
	CLRF       interrupt_ii_L1+0
L_interrupt1:
	MOVLW      5
	SUBWF      interrupt_ii_L1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt2
;MyProject.c,44 :: 		PORTB = PORTB | 0x80; // Set RB7   BUZZER ON
	BSF        PORTB+0, 7
;MyProject.c,45 :: 		myDDelay();
	CALL       _myDDelay+0
;MyProject.c,46 :: 		PORTB = PORTB & 0x7F; // Clear RB7
	MOVLW      127
	ANDWF      PORTB+0, 1
;MyProject.c,47 :: 		myDDelay();
	CALL       _myDDelay+0
;MyProject.c,42 :: 		for (ii = 0; ii < 5; ii++)
	INCF       interrupt_ii_L1+0, 1
;MyProject.c,49 :: 		}
	GOTO       L_interrupt1
L_interrupt2:
;MyProject.c,50 :: 		INTCON = INTCON & 0xFD;// CLear INTF
	MOVLW      253
	ANDWF      INTCON+0, 1
;MyProject.c,51 :: 		}
L_interrupt0:
;MyProject.c,53 :: 		if (INTCON & 0x04) {// will get here every 1ms
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt4
;MyProject.c,54 :: 		TMR0 = 248;
	MOVLW      248
	MOVWF      TMR0+0
;MyProject.c,55 :: 		Mcntr++;
	INCF       _Mcntr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Mcntr+1, 1
;MyProject.c,56 :: 		Dcntr++;
	INCF       _Dcntr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _Dcntr+1, 1
;MyProject.c,57 :: 		if (Dcntr == 500) {//after 500 ms
	MOVF       _Dcntr+1, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt48
	MOVLW      244
	XORWF      _Dcntr+0, 0
L__interrupt48:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
;MyProject.c,58 :: 		Dcntr = 0;
	CLRF       _Dcntr+0
	CLRF       _Dcntr+1
;MyProject.c,63 :: 		ATD_init_LDR();
	CALL       _ATD_init_LDR+0
;MyProject.c,64 :: 		voltage = LDR_Servo();
	CALL       _LDR_Servo+0
	MOVF       R0+0, 0
	MOVWF      _voltage+0
	MOVF       R0+1, 0
	MOVWF      _voltage+1
;MyProject.c,65 :: 		if ((voltage == 0) & (current_state != 0)) {
	MOVLW      0
	XORWF      R0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt49
	MOVLW      0
	XORWF      R0+0, 0
L__interrupt49:
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R2+0
	MOVF       _current_state+0, 0
	XORLW      0
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R2+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt6
;MyProject.c,66 :: 		current_state = 0;
	CLRF       _current_state+0
;MyProject.c,67 :: 		Rotation0();
	CALL       _Rotation0+0
;MyProject.c,68 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;MyProject.c,69 :: 		} //0 Degree
	GOTO       L_interrupt7
L_interrupt6:
;MyProject.c,70 :: 		else if ((voltage == 1) & (current_state != 1)) {
	MOVLW      0
	XORWF      _voltage+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt50
	MOVLW      1
	XORWF      _voltage+0, 0
L__interrupt50:
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _current_state+0, 0
	XORLW      1
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt8
;MyProject.c,71 :: 		current_state = 1;
	MOVLW      1
	MOVWF      _current_state+0
;MyProject.c,72 :: 		Rotation45();
	CALL       _Rotation45+0
;MyProject.c,73 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;MyProject.c,74 :: 		}//45 Degree
	GOTO       L_interrupt9
L_interrupt8:
;MyProject.c,75 :: 		else if ((voltage == 2) & (current_state != 2)) {
	MOVLW      0
	XORWF      _voltage+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt51
	MOVLW      2
	XORWF      _voltage+0, 0
L__interrupt51:
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _current_state+0, 0
	XORLW      2
	MOVLW      1
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt10
;MyProject.c,76 :: 		current_state = 2;
	MOVLW      2
	MOVWF      _current_state+0
;MyProject.c,77 :: 		Rotation90();
	CALL       _Rotation90+0
;MyProject.c,78 :: 		PORTD = 0x01;
	MOVLW      1
	MOVWF      PORTD+0
;MyProject.c,79 :: 		} //90 Degree
L_interrupt10:
L_interrupt9:
L_interrupt7:
;MyProject.c,81 :: 		}
L_interrupt5:
;MyProject.c,83 :: 		INTCON = INTCON & 0xFB; //clear T0IF
	MOVLW      251
	ANDWF      INTCON+0, 1
;MyProject.c,84 :: 		}
L_interrupt4:
;MyProject.c,86 :: 		}
L_end_interrupt:
L__interrupt47:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;MyProject.c,89 :: 		void main()
;MyProject.c,93 :: 		TRISA = 0xFF; // RA1 RA3 Inputs
	MOVLW      255
	MOVWF      TRISA+0
;MyProject.c,94 :: 		TRISB = 0x01; // PORTB as Output Port except RB0
	MOVLW      1
	MOVWF      TRISB+0
;MyProject.c,95 :: 		TRISC = 0x80; // PORTC output RC7 input
	MOVLW      128
	MOVWF      TRISC+0
;MyProject.c,96 :: 		TRISD = 0x00; // PORTD Output
	CLRF       TRISD+0
;MyProject.c,99 :: 		PORTB = 0x00;
	CLRF       PORTB+0
;MyProject.c,100 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;MyProject.c,101 :: 		PORTC = 0x00;
	CLRF       PORTC+0
;MyProject.c,104 :: 		Dcntr = 0;
	CLRF       _Dcntr+0
	CLRF       _Dcntr+1
;MyProject.c,105 :: 		Mcntr = 0;
	CLRF       _Mcntr+0
	CLRF       _Mcntr+1
;MyProject.c,106 :: 		TMR0 = 248;
	MOVLW      248
	MOVWF      TMR0+0
;MyProject.c,109 :: 		OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
	MOVLW      135
	MOVWF      OPTION_REG+0
;MyProject.c,110 :: 		INTCON = 0xB0; // GIE, T0IE and INTE (TMR) overflow interrupt and External Interrupt Enable)
	MOVLW      176
	MOVWF      INTCON+0
;MyProject.c,111 :: 		speed = 0; // DC Motor initial speed
	CLRF       _speed+0
	CLRF       _speed+1
;MyProject.c,112 :: 		current_state = 0; //Servo initial state
	CLRF       _current_state+0
;MyProject.c,114 :: 		while (1)
L_main11:
;MyProject.c,116 :: 		read_temperature(); // Read Temperature and change speed accordingly
	CALL       _read_temperature+0
;MyProject.c,117 :: 		PWM(10, speed);
	MOVLW      10
	MOVWF      FARG_PWM_p+0
	MOVLW      0
	MOVWF      FARG_PWM_p+1
	MOVF       _speed+0, 0
	MOVWF      FARG_PWM_d+0
	MOVF       _speed+1, 0
	MOVWF      FARG_PWM_d+1
	CALL       _PWM+0
;MyProject.c,118 :: 		}
	GOTO       L_main11
;MyProject.c,119 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_read_temperature:

;MyProject.c,121 :: 		void read_temperature(void) {
;MyProject.c,122 :: 		ATD_init_TMP(); // initiate RA3 for Analog Reading
	CALL       _ATD_init_TMP+0
;MyProject.c,123 :: 		myreading2 = ATD_read_TMP();
	CALL       _ATD_read_TMP+0
	MOVF       R0+0, 0
	MOVWF      _myreading2+0
	MOVF       R0+1, 0
	MOVWF      _myreading2+1
	MOVF       R0+2, 0
	MOVWF      _myreading2+2
	MOVF       R0+3, 0
	MOVWF      _myreading2+3
;MyProject.c,125 :: 		temperature = ((myreading2 * 500) / 1023);
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      122
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      192
	MOVWF      R4+1
	MOVLW      127
	MOVWF      R4+2
	MOVLW      136
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__read_temperature+0
	MOVF       R0+1, 0
	MOVWF      FLOC__read_temperature+1
	MOVF       R0+2, 0
	MOVWF      FLOC__read_temperature+2
	MOVF       R0+3, 0
	MOVWF      FLOC__read_temperature+3
	MOVF       FLOC__read_temperature+0, 0
	MOVWF      _temperature+0
	MOVF       FLOC__read_temperature+1, 0
	MOVWF      _temperature+1
	MOVF       FLOC__read_temperature+2, 0
	MOVWF      _temperature+2
	MOVF       FLOC__read_temperature+3, 0
	MOVWF      _temperature+3
;MyProject.c,126 :: 		t = temperature;
	MOVF       FLOC__read_temperature+0, 0
	MOVWF      R0+0
	MOVF       FLOC__read_temperature+1, 0
	MOVWF      R0+1
	MOVF       FLOC__read_temperature+2, 0
	MOVWF      R0+2
	MOVF       FLOC__read_temperature+3, 0
	MOVWF      R0+3
	CALL       _double2word+0
	MOVF       R0+0, 0
	MOVWF      _t+0
	MOVF       R0+1, 0
	MOVWF      _t+1
;MyProject.c,129 :: 		if (temperature > 40.0) {
	MOVF       FLOC__read_temperature+0, 0
	MOVWF      R4+0
	MOVF       FLOC__read_temperature+1, 0
	MOVWF      R4+1
	MOVF       FLOC__read_temperature+2, 0
	MOVWF      R4+2
	MOVF       FLOC__read_temperature+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      32
	MOVWF      R0+2
	MOVLW      132
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_read_temperature13
;MyProject.c,130 :: 		speed = 99;
	MOVLW      99
	MOVWF      _speed+0
	MOVLW      0
	MOVWF      _speed+1
;MyProject.c,131 :: 		PORTC = 0xFF;
	MOVLW      255
	MOVWF      PORTC+0
;MyProject.c,132 :: 		}
	GOTO       L_read_temperature14
L_read_temperature13:
;MyProject.c,133 :: 		else if ((temperature < 40.0) & (temperature > 30.0)) {
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      32
	MOVWF      R4+2
	MOVLW      132
	MOVWF      R4+3
	MOVF       _temperature+0, 0
	MOVWF      R0+0
	MOVF       _temperature+1, 0
	MOVWF      R0+1
	MOVF       _temperature+2, 0
	MOVWF      R0+2
	MOVF       _temperature+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      FLOC__read_temperature+0
	MOVF       _temperature+0, 0
	MOVWF      R4+0
	MOVF       _temperature+1, 0
	MOVWF      R4+1
	MOVF       _temperature+2, 0
	MOVWF      R4+2
	MOVF       _temperature+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      112
	MOVWF      R0+2
	MOVLW      131
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       FLOC__read_temperature+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_read_temperature15
;MyProject.c,134 :: 		speed = 30;
	MOVLW      30
	MOVWF      _speed+0
	MOVLW      0
	MOVWF      _speed+1
;MyProject.c,135 :: 		PORTC = 0x0F;
	MOVLW      15
	MOVWF      PORTC+0
;MyProject.c,136 :: 		}
	GOTO       L_read_temperature16
L_read_temperature15:
;MyProject.c,137 :: 		else if ((temperature < 30.0) & (temperature > 25.0)) {
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      112
	MOVWF      R4+2
	MOVLW      131
	MOVWF      R4+3
	MOVF       _temperature+0, 0
	MOVWF      R0+0
	MOVF       _temperature+1, 0
	MOVWF      R0+1
	MOVF       _temperature+2, 0
	MOVWF      R0+2
	MOVF       _temperature+3, 0
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      FLOC__read_temperature+0
	MOVF       _temperature+0, 0
	MOVWF      R4+0
	MOVF       _temperature+1, 0
	MOVWF      R4+1
	MOVF       _temperature+2, 0
	MOVWF      R4+2
	MOVF       _temperature+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      72
	MOVWF      R0+2
	MOVLW      131
	MOVWF      R0+3
	CALL       _Compare_Double+0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       FLOC__read_temperature+0, 0
	ANDWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_read_temperature17
;MyProject.c,138 :: 		speed = 18;
	MOVLW      18
	MOVWF      _speed+0
	MOVLW      0
	MOVWF      _speed+1
;MyProject.c,139 :: 		PORTC = 0x04;
	MOVLW      4
	MOVWF      PORTC+0
;MyProject.c,140 :: 		}
	GOTO       L_read_temperature18
L_read_temperature17:
;MyProject.c,142 :: 		speed = 0;
	CLRF       _speed+0
	CLRF       _speed+1
;MyProject.c,143 :: 		PORTC = 0x01;
	MOVLW      1
	MOVWF      PORTC+0
;MyProject.c,144 :: 		}
L_read_temperature18:
L_read_temperature16:
L_read_temperature14:
;MyProject.c,145 :: 		}
L_end_read_temperature:
	RETURN
; end of _read_temperature

_ATD_init_TMP:

;MyProject.c,146 :: 		void ATD_init_TMP(void) {    // Initiate TMP at Channel 3 (RA3)
;MyProject.c,147 :: 		ADCON0 = 0x59;// ATD ON, Don't GO, Channel 3, Fosc/16
	MOVLW      89
	MOVWF      ADCON0+0
;MyProject.c,148 :: 		ADCON1 = 0xC0;// All channels Analog, 500 KHz, right justified
	MOVLW      192
	MOVWF      ADCON1+0
;MyProject.c,149 :: 		}
L_end_ATD_init_TMP:
	RETURN
; end of _ATD_init_TMP

_ATD_read_TMP:

;MyProject.c,151 :: 		float ATD_read_TMP(void) {
;MyProject.c,154 :: 		ADCON0 = ADCON0 | 0x04; // Start ADC conversion
	BSF        ADCON0+0, 2
;MyProject.c,155 :: 		while (ADCON0 & 0x04); // Wait for conversion to complete
L_ATD_read_TMP19:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read_TMP20
	GOTO       L_ATD_read_TMP19
L_ATD_read_TMP20:
;MyProject.c,157 :: 		ret = (ADRESH << 8) | ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
	CALL       _word2double+0
;MyProject.c,158 :: 		return ret;
;MyProject.c,159 :: 		}
L_end_ATD_read_TMP:
	RETURN
; end of _ATD_read_TMP

_myDDelay:

;MyProject.c,161 :: 		void myDDelay(void) {
;MyProject.c,164 :: 		for (k = 0; k < 40; k++)
	CLRF       R3+0
L_myDDelay21:
	MOVLW      40
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_myDDelay22
;MyProject.c,165 :: 		for (j = 0; j < 2000; j++);
	CLRF       R1+0
	CLRF       R1+1
L_myDDelay24:
	MOVLW      7
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDDelay57
	MOVLW      208
	SUBWF      R1+0, 0
L__myDDelay57:
	BTFSC      STATUS+0, 0
	GOTO       L_myDDelay25
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L_myDDelay24
L_myDDelay25:
;MyProject.c,164 :: 		for (k = 0; k < 40; k++)
	INCF       R3+0, 1
;MyProject.c,165 :: 		for (j = 0; j < 2000; j++);
	GOTO       L_myDDelay21
L_myDDelay22:
;MyProject.c,166 :: 		}
L_end_myDDelay:
	RETURN
; end of _myDDelay

_myDelay:

;MyProject.c,167 :: 		void myDelay(unsigned int x) {
;MyProject.c,168 :: 		Mcntr = 0;
	CLRF       _Mcntr+0
	CLRF       _Mcntr+1
;MyProject.c,169 :: 		while (Mcntr < x);
L_myDelay27:
	MOVF       FARG_myDelay_x+1, 0
	SUBWF      _Mcntr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__myDelay59
	MOVF       FARG_myDelay_x+0, 0
	SUBWF      _Mcntr+0, 0
L__myDelay59:
	BTFSC      STATUS+0, 0
	GOTO       L_myDelay28
	GOTO       L_myDelay27
L_myDelay28:
;MyProject.c,170 :: 		}
L_end_myDelay:
	RETURN
; end of _myDelay

_PWM:

;MyProject.c,172 :: 		void PWM(unsigned int p, unsigned int d) {
;MyProject.c,176 :: 		period = p;//milliseconds
	MOVF       FARG_PWM_p+0, 0
	MOVWF      _period+0
	MOVF       FARG_PWM_p+1, 0
	MOVWF      _period+1
;MyProject.c,177 :: 		duty = (d * p) / 100;
	MOVF       FARG_PWM_d+0, 0
	MOVWF      R0+0
	MOVF       FARG_PWM_d+1, 0
	MOVWF      R0+1
	MOVF       FARG_PWM_p+0, 0
	MOVWF      R4+0
	MOVF       FARG_PWM_p+1, 0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _duty+0
	MOVF       R0+1, 0
	MOVWF      _duty+1
;MyProject.c,178 :: 		PORTB = PORTB | 0x10; // High RB4
	BSF        PORTB+0, 4
;MyProject.c,179 :: 		myDelay(duty);
	MOVF       R0+0, 0
	MOVWF      FARG_myDelay_x+0
	MOVF       R0+1, 0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;MyProject.c,180 :: 		PORTB = PORTB & 0xEF; // Low RB4
	MOVLW      239
	ANDWF      PORTB+0, 1
;MyProject.c,181 :: 		myDelay(period - duty);
	MOVF       _duty+0, 0
	SUBWF      _period+0, 0
	MOVWF      FARG_myDelay_x+0
	MOVF       _duty+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _period+1, 0
	MOVWF      FARG_myDelay_x+1
	CALL       _myDelay+0
;MyProject.c,183 :: 		}
L_end_PWM:
	RETURN
; end of _PWM

_ATD_init_LDR:

;MyProject.c,185 :: 		void ATD_init_LDR(void) {    // Initiate LDR at Channel 1 (RA1)
;MyProject.c,186 :: 		ADCON0 = 0x49;// ATD ON, Don't GO, Channel 1, Fosc/16
	MOVLW      73
	MOVWF      ADCON0+0
;MyProject.c,187 :: 		ADCON1 = 0xC0;// All channels Analog, 500 KHz, right justified
	MOVLW      192
	MOVWF      ADCON1+0
;MyProject.c,188 :: 		}
L_end_ATD_init_LDR:
	RETURN
; end of _ATD_init_LDR

_ATD_read_LDR:

;MyProject.c,190 :: 		unsigned int ATD_read_LDR(void) {
;MyProject.c,193 :: 		ADCON0 = ADCON0 | 0x04; // Start ADC conversion
	BSF        ADCON0+0, 2
;MyProject.c,194 :: 		while (ADCON0 & 0x04); // Wait for conversion to complete
L_ATD_read_LDR29:
	BTFSS      ADCON0+0, 2
	GOTO       L_ATD_read_LDR30
	GOTO       L_ATD_read_LDR29
L_ATD_read_LDR30:
;MyProject.c,196 :: 		ret = (ADRESH << 8) | ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	IORWF      R0+0, 1
	MOVLW      0
	IORWF      R0+1, 1
;MyProject.c,197 :: 		return ret;
;MyProject.c,198 :: 		}
L_end_ATD_read_LDR:
	RETURN
; end of _ATD_read_LDR

_Rotation0:

;MyProject.c,200 :: 		void Rotation0() //0 Degree
;MyProject.c,203 :: 		for (i = 0; i < 50; i++)
	CLRF       R1+0
	CLRF       R1+1
L_Rotation031:
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Rotation064
	MOVLW      50
	SUBWF      R1+0, 0
L__Rotation064:
	BTFSC      STATUS+0, 0
	GOTO       L_Rotation032
;MyProject.c,205 :: 		PORTB = PORTB | 0x20;
	BSF        PORTB+0, 5
;MyProject.c,206 :: 		Delay_us(800); // pulse of 800us
	MOVLW      3
	MOVWF      R12+0
	MOVLW      18
	MOVWF      R13+0
L_Rotation034:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation034
	DECFSZ     R12+0, 1
	GOTO       L_Rotation034
	NOP
;MyProject.c,207 :: 		PORTB = PORTB & 0xDF;
	MOVLW      223
	ANDWF      PORTB+0, 1
;MyProject.c,208 :: 		Delay_us(19200);
	MOVLW      50
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_Rotation035:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation035
	DECFSZ     R12+0, 1
	GOTO       L_Rotation035
	NOP
	NOP
;MyProject.c,203 :: 		for (i = 0; i < 50; i++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;MyProject.c,210 :: 		}
	GOTO       L_Rotation031
L_Rotation032:
;MyProject.c,211 :: 		PORTB = PORTB & 0x7F; // Clear RB7
	MOVLW      127
	ANDWF      PORTB+0, 1
;MyProject.c,212 :: 		}
L_end_Rotation0:
	RETURN
; end of _Rotation0

_Rotation45:

;MyProject.c,214 :: 		void Rotation45() //45 Degree
;MyProject.c,217 :: 		for (i = 0; i < 50; i++)
	CLRF       R1+0
	CLRF       R1+1
L_Rotation4536:
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Rotation4566
	MOVLW      50
	SUBWF      R1+0, 0
L__Rotation4566:
	BTFSC      STATUS+0, 0
	GOTO       L_Rotation4537
;MyProject.c,219 :: 		PORTB = PORTB | 0x20;
	BSF        PORTB+0, 5
;MyProject.c,220 :: 		Delay_us(1150); // pulse of 400us
	MOVLW      3
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Rotation4539:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation4539
	DECFSZ     R12+0, 1
	GOTO       L_Rotation4539
	NOP
	NOP
;MyProject.c,221 :: 		PORTB = PORTB & 0xDF;
	MOVLW      223
	ANDWF      PORTB+0, 1
;MyProject.c,222 :: 		Delay_us(18850);
	MOVLW      49
	MOVWF      R12+0
	MOVLW      245
	MOVWF      R13+0
L_Rotation4540:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation4540
	DECFSZ     R12+0, 1
	GOTO       L_Rotation4540
;MyProject.c,217 :: 		for (i = 0; i < 50; i++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;MyProject.c,223 :: 		}
	GOTO       L_Rotation4536
L_Rotation4537:
;MyProject.c,224 :: 		PORTB = PORTB & 0x7F; // Clear RB7
	MOVLW      127
	ANDWF      PORTB+0, 1
;MyProject.c,225 :: 		}
L_end_Rotation45:
	RETURN
; end of _Rotation45

_Rotation90:

;MyProject.c,228 :: 		void Rotation90() //90 Degree
;MyProject.c,231 :: 		for (i = 0; i < 50; i++)
	CLRF       R1+0
	CLRF       R1+1
L_Rotation9041:
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Rotation9068
	MOVLW      50
	SUBWF      R1+0, 0
L__Rotation9068:
	BTFSC      STATUS+0, 0
	GOTO       L_Rotation9042
;MyProject.c,233 :: 		PORTB = PORTB | 0x20;
	BSF        PORTB+0, 5
;MyProject.c,234 :: 		Delay_us(1500); // pulse of 1500us
	MOVLW      4
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_Rotation9044:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation9044
	DECFSZ     R12+0, 1
	GOTO       L_Rotation9044
	NOP
;MyProject.c,235 :: 		PORTB = PORTB & 0xDF;
	MOVLW      223
	ANDWF      PORTB+0, 1
;MyProject.c,236 :: 		Delay_us(18500);
	MOVLW      49
	MOVWF      R12+0
	MOVLW      11
	MOVWF      R13+0
L_Rotation9045:
	DECFSZ     R13+0, 1
	GOTO       L_Rotation9045
	DECFSZ     R12+0, 1
	GOTO       L_Rotation9045
	NOP
	NOP
;MyProject.c,237 :: 		PORTB = PORTB & 0x7F; // Clear RB7
	MOVLW      127
	ANDWF      PORTB+0, 1
;MyProject.c,231 :: 		for (i = 0; i < 50; i++)
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;MyProject.c,239 :: 		}
	GOTO       L_Rotation9041
L_Rotation9042:
;MyProject.c,240 :: 		PORTB = PORTB & 0x7F; // Clear RB7
	MOVLW      127
	ANDWF      PORTB+0, 1
;MyProject.c,241 :: 		}
L_end_Rotation90:
	RETURN
; end of _Rotation90

_LDR_Servo:

;MyProject.c,243 :: 		int LDR_Servo(void)
;MyProject.c,245 :: 		myreading = ATD_read_LDR();
	CALL       _ATD_read_LDR+0
	MOVF       R0+0, 0
	MOVWF      _myreading+0
	MOVF       R0+1, 0
	MOVWF      _myreading+1
;MyProject.c,246 :: 		myVoltage = (myreading * 5) / 1023; // gets Voltage from LDR
	MOVLW      5
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _myVoltage+0
;MyProject.c,247 :: 		voltage = myVoltage;
	MOVF       R0+0, 0
	MOVWF      _voltage+0
	CLRF       _voltage+1
;MyProject.c,248 :: 		return voltage;
	MOVF       _voltage+0, 0
	MOVWF      R0+0
	MOVF       _voltage+1, 0
	MOVWF      R0+1
;MyProject.c,249 :: 		}
L_end_LDR_Servo:
	RETURN
; end of _LDR_Servo
