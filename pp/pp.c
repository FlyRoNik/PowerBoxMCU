/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 26.04.2017
Author  : Nikita
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega328p.h>
#include <delay.h>

void main(void)
{
PORTB=0x01;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x04;

while (1)
      {         
      
      if(PINC.0 == 0){
         PORTD.4 = 1;
         delay_ms(100);
         PORTD.4 = 1;
      }
}
