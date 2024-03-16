#line 1 "C:/Users/omarr/Desktop/EMBEDDED/smart-home/MyProject.c"


unsigned char mysevenseg[10] = { 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F };
void ATD_init_TMP(void);
void PWM(unsigned int p, unsigned int d);
float ATD_read_TMP(void);
void read_temperature(void);
void PWM(unsigned int p, unsigned int d);
void myDDelay(void);
void myDelay(unsigned int);



void ATD_init_LDR(void);
unsigned int ATD_read_LDR(void);
void Rotation0();
void Rotation45();
void Rotation90();
int LDR_Servo(void);


unsigned int myreading;
unsigned char myVoltage;
unsigned char current_state;
int voltage;




unsigned int period, duty;
unsigned int Dcntr;
unsigned int Mcntr;
float myreading2;
unsigned int speed;
float temperature = 0;
unsigned int t;
float tmp = 0;
void interrupt(void) {
 if (INTCON & 0x02)
 {
 unsigned char ii;
 for (ii = 0; ii < 5; ii++)
 {
 PORTB = PORTB | 0x80;
 myDDelay();
 PORTB = PORTB & 0x7F;
 myDDelay();

 }
 INTCON = INTCON & 0xFD;
 }

 if (INTCON & 0x04) {
 TMR0 = 248;
 Mcntr++;
 Dcntr++;
 if (Dcntr == 500) {
 Dcntr = 0;




 ATD_init_LDR();
 voltage = LDR_Servo();
 if ((voltage == 0) & (current_state != 0)) {
 current_state = 0;
 Rotation0();
 PORTD = 0x00;
 }
 else if ((voltage == 1) & (current_state != 1)) {
 current_state = 1;
 Rotation45();
 PORTD = 0x00;
 }
 else if ((voltage == 2) & (current_state != 2)) {
 current_state = 2;
 Rotation90();
 PORTD = 0x01;
 }

 }

 INTCON = INTCON & 0xFB;
 }

}


void main()
{


 TRISA = 0xFF;
 TRISB = 0x01;
 TRISC = 0x80;
 TRISD = 0x00;


 PORTB = 0x00;
 PORTD = 0x00;
 PORTC = 0x00;


 Dcntr = 0;
 Mcntr = 0;
 TMR0 = 248;


 OPTION_REG = 0x87;
 INTCON = 0xB0;
 speed = 0;
 current_state = 0;

 while (1)
 {
 read_temperature();
 PWM(10, speed);
 }
}

void read_temperature(void) {
 ATD_init_TMP();
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
void ATD_init_TMP(void) {
 ADCON0 = 0x59;
 ADCON1 = 0xC0;
}

float ATD_read_TMP(void) {
 float ret;

 ADCON0 = ADCON0 | 0x04;
 while (ADCON0 & 0x04);

 ret = (ADRESH << 8) | ADRESL;
 return ret;
}

void myDDelay(void) {
 unsigned int j;
 unsigned char k;
 for (k = 0; k < 40; k++)
 for (j = 0; j < 2000; j++);
}
void myDelay(unsigned int x) {
 Mcntr = 0;
 while (Mcntr < x);
}

void PWM(unsigned int p, unsigned int d) {



 period = p;
 duty = (d * p) / 100;
 PORTB = PORTB | 0x10;
 myDelay(duty);
 PORTB = PORTB & 0xEF;
 myDelay(period - duty);

}

void ATD_init_LDR(void) {
 ADCON0 = 0x49;
 ADCON1 = 0xC0;
}

unsigned int ATD_read_LDR(void) {
 unsigned int ret;

 ADCON0 = ADCON0 | 0x04;
 while (ADCON0 & 0x04);

 ret = (ADRESH << 8) | ADRESL;
 return ret;
}

void Rotation0()
{
 unsigned int i;
 for (i = 0; i < 50; i++)
 {
 PORTB = PORTB | 0x20;
 Delay_us(800);
 PORTB = PORTB & 0xDF;
 Delay_us(19200);

 }
 PORTB = PORTB & 0x7F;
}

void Rotation45()
{
 unsigned int i;
 for (i = 0; i < 50; i++)
 {
 PORTB = PORTB | 0x20;
 Delay_us(1150);
 PORTB = PORTB & 0xDF;
 Delay_us(18850);
 }
 PORTB = PORTB & 0x7F;
}


void Rotation90()
{
 unsigned int i;
 for (i = 0; i < 50; i++)
 {
 PORTB = PORTB | 0x20;
 Delay_us(1500);
 PORTB = PORTB & 0xDF;
 Delay_us(18500);
 PORTB = PORTB & 0x7F;

 }
 PORTB = PORTB & 0x7F;
}

int LDR_Servo(void)
{
 myreading = ATD_read_LDR();
 myVoltage = (myreading * 5) / 1023;
 voltage = myVoltage;
 return voltage;
}
