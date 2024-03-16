// DC MOTOR & TEMP FUNCTION SIGNATURES

unsigned char mysevenseg[10] = { 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F };
void ATD_init_TMP(void);
void PWM(unsigned int p, unsigned int d);
float ATD_read_TMP(void);
void read_temperature(void);
void PWM(unsigned int p, unsigned int d);
void myDDelay(void);
void myDelay(unsigned int);


// LDR & SERVO FUNCTION SIGNATURES
void ATD_init_LDR(void);
unsigned int ATD_read_LDR(void);
void Rotation0();
void Rotation45();
void Rotation90();
int LDR_Servo(void);

// LDR & SERVO INTIALIZATIONS
unsigned int myreading;
unsigned char myVoltage;
unsigned char current_state;
int voltage;



// DC MOTOR & TEMP INITIALIZATIONS
unsigned int period, duty;
unsigned int Dcntr;
unsigned int  Mcntr;
float myreading2;
unsigned int speed;
float temperature = 0;
unsigned int t;
float tmp = 0;
void interrupt(void) {
    if (INTCON & 0x02)   // External Interrupt - IR SENSOR
    {
        unsigned char ii;
        for (ii = 0; ii < 5; ii++)
        {
            PORTB = PORTB | 0x80; // Set RB7   BUZZER ON
            myDDelay();
            PORTB = PORTB & 0x7F; // Clear RB7
            myDDelay();

        }
        INTCON = INTCON & 0xFD;// CLear INTF
    }

    if (INTCON & 0x04) {// will get here every 1ms
        TMR0 = 248;
        Mcntr++;
        Dcntr++;
        if (Dcntr == 500) {//after 500 ms
            Dcntr = 0;


            // LDR X SERVO

            ATD_init_LDR();
            voltage = LDR_Servo();
            if ((voltage == 0) & (current_state != 0)) {
                current_state = 0;
                Rotation0();
                PORTD = 0x00;
            } //0 Degree
            else if ((voltage == 1) & (current_state != 1)) {
                current_state = 1;
                Rotation45();
                PORTD = 0x00;
            }//45 Degree
            else if ((voltage == 2) & (current_state != 2)) {
                current_state = 2;
                Rotation90();
                PORTD = 0x01;
            } //90 Degree

        }
        
        INTCON = INTCON & 0xFB; //clear T0IF
    }

}


void main()
{

    // Setting Port directions
    TRISA = 0xFF; // RA1 RA3 Inputs
    TRISB = 0x01; // PORTB as Output Port except RB0
    TRISC = 0x80; // PORTC output RC7 input
    TRISD = 0x00; // PORTD Output
    
    // Initializing Ports
    PORTB = 0x00;
    PORTD = 0x00;
    PORTC = 0x00;
    
    // Initializing Counters
    Dcntr = 0;
    Mcntr = 0;
    TMR0 = 248;
    
    // Other Inilizations
    OPTION_REG = 0x87;//Fosc/4 with 256 prescaler => incremetn every 0.5us*256=128us ==> overflow 8count*128us=1ms to overflow
    INTCON = 0xB0; // GIE, T0IE and INTE (TMR) overflow interrupt and External Interrupt Enable)
    speed = 0; // DC Motor initial speed
    current_state = 0; //Servo initial state
    
    while (1)
    {
        read_temperature(); // Read Temperature and change speed accordingly
        PWM(10, speed);
    }
}

void read_temperature(void) {
     ATD_init_TMP(); // initiate RA3 for Analog Reading
    myreading2 = ATD_read_TMP();

    temperature = ((myreading2 * 500) / 1023);
    t = temperature;


    if (temperature > 40.0) {
        speed = 99;
        PORTC = 0xFF;
    }
    else if ((temperature < 40.0) & (temperature > 30.0)) {
        speed = 30;
        PORTC = 0x0F;
    }
    else if ((temperature < 30.0) & (temperature > 25.0)) {
        speed = 18;
        PORTC = 0x04;
    }
    else {
        speed = 0;
        PORTC = 0x01;
    }
}
void ATD_init_TMP(void) {    // Initiate TMP at Channel 3 (RA3)
    ADCON0 = 0x59;// ATD ON, Don't GO, Channel 3, Fosc/16
    ADCON1 = 0xC0;// All channels Analog, 500 KHz, right justified
}

float ATD_read_TMP(void) {
    float ret;

    ADCON0 = ADCON0 | 0x04; // Start ADC conversion
    while (ADCON0 & 0x04); // Wait for conversion to complete

    ret = (ADRESH << 8) | ADRESL;
    return ret;
}

void myDDelay(void) {
    unsigned int j;// reserve two memory locations (16-bit) unsigned: 0-65535 (64k)
    unsigned char k;// reserve one memory location (8-bit) unsigned:0-255
    for (k = 0; k < 40; k++)
        for (j = 0; j < 2000; j++);
}
void myDelay(unsigned int x) {
    Mcntr = 0;
    while (Mcntr < x);
}

void PWM(unsigned int p, unsigned int d) {

    // period in milliseconds, d 1-100 %
    //This will have the PWM Signal Out on PORTB1-7, so do the necessary initializations in the main.
    period = p;//milliseconds
    duty = (d * p) / 100;
    PORTB = PORTB | 0x10; // High RB4
    myDelay(duty);
    PORTB = PORTB & 0xEF; // Low RB4
    myDelay(period - duty);

}

void ATD_init_LDR(void) {    // Initiate LDR at Channel 1 (RA1)
    ADCON0 = 0x49;// ATD ON, Don't GO, Channel 1, Fosc/16
    ADCON1 = 0xC0;// All channels Analog, 500 KHz, right justified
}

unsigned int ATD_read_LDR(void) {
    unsigned int ret;

    ADCON0 = ADCON0 | 0x04; // Start ADC conversion
    while (ADCON0 & 0x04); // Wait for conversion to complete

    ret = (ADRESH << 8) | ADRESL;
    return ret;
}

void Rotation0() //0 Degree
{
    unsigned int i;
    for (i = 0; i < 50; i++)
    {
        PORTB = PORTB | 0x20;
        Delay_us(800); // pulse of 800us
        PORTB = PORTB & 0xDF;
        Delay_us(19200);

    }
    PORTB = PORTB & 0x7F; // Clear RB7
}

void Rotation45() //45 Degree
{
    unsigned int i;
    for (i = 0; i < 50; i++)
    {
        PORTB = PORTB | 0x20;
        Delay_us(1150); // pulse of 400us
        PORTB = PORTB & 0xDF;
        Delay_us(18850);
    }
    PORTB = PORTB & 0x7F; // Clear RB7
}


void Rotation90() //90 Degree
{
    unsigned int i;
    for (i = 0; i < 50; i++)
    {
        PORTB = PORTB | 0x20;
        Delay_us(1500); // pulse of 1500us
        PORTB = PORTB & 0xDF;
        Delay_us(18500);
        PORTB = PORTB & 0x7F; // Clear RB7

    }
    PORTB = PORTB & 0x7F; // Clear RB7
}

int LDR_Servo(void)
{
    myreading = ATD_read_LDR();
    myVoltage = (myreading * 5) / 1023; // gets Voltage from LDR
    voltage = myVoltage;
    return voltage;
}