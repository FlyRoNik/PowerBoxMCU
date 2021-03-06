/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 27.04.2017
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
// TWI functions
#include <twi.h>

bit b1, status_phone, status_lock, status_LED;
unsigned char Permit, counter_digitizing, checksum;

unsigned int current, voltage, avarage_current, avarage_voltage;
unsigned char status_power;
                                                                                                    
unsigned char read_command, current_command, i, size_commands, write_command, color_R, color_G, color_B;

//I2C Bus Slave Address
#define SLAVE_ADDRESS 0x0f //10 = 0x0a

//Restrictive current
#define RESTRICTIVE_CURRENT 1000 //700 = 2A

//minimum supply current
#define MIN_SUPPLY_CURRENT 50

// TWI Slave receive buffer
#define TWI_RX_BUFFER_SIZE 13
unsigned char twi_rx_buffer[TWI_RX_BUFFER_SIZE];

// TWI Slave transmit buffer
#define TWI_TX_BUFFER_SIZE 21
unsigned char twi_tx_buffer[TWI_TX_BUFFER_SIZE];


void setPower(char x){
    PORTD.5 = x;
    status_power = x;        
}

// TWI Slave receive handler
// This handler is called everytime a byte
// is received by the TWI slave
bool twi_rx_handler(bool rx_complete)
{
if (twi_result==TWI_RES_OK)
   {
   // A data byte was received without error
   // and it was stored at twi_rx_buffer[twi_rx_index]
   // Place your code here to process the received byte
   // Note: processing must be VERY FAST, otherwise
   // it is better to process the received data when
   // all communication with the master has finished   
   if(((twi_rx_buffer[0]>3) && (twi_rx_buffer[0] < 22)) && ((twi_rx_buffer[1]==0 || (twi_rx_buffer[1]==1)))){
   
   
   checksum = 0;
    for (i = 0; i < twi_rx_buffer[0] - 1; i++) {
        checksum += twi_rx_buffer[i];       
    };   
    
    if(checksum == twi_rx_buffer[twi_rx_buffer[0] - 1]){
    checksum = 0;   
    read_command = 0;
    current_command = 0;
    size_commands = 1;
    write_command = 0;
    if (twi_rx_buffer[1] == 0) {        //command set      
        for (i = 2; i < twi_rx_buffer[0] - 1; i++) {  //twi_rx_buffer[0] - count command
                if (read_command == 0) {
                    current_command = twi_rx_buffer[i];
                    read_command = 1;  
                }
                else{
                    switch (current_command) {
                        case 0:{   //set power                                   
                            switch(twi_rx_buffer[i]){
                                case 0: setPower(1); //OFF
                                    break;
                                case 1: setPower(0); //ON
                                    break;
                                case 2: setPower(2); //FAIL
                                    break;
                                 default: setPower(1); //OFF
                            };
                            
                            read_command = 0;    
                        }
                        break;
                        case 1:{    //set color rgb
                            switch (read_command) {
                                 case 1: PORTB.3 = twi_rx_buffer[i]; //color_R
                                    break;
                                 case 2: PORTB.2 = twi_rx_buffer[i]; //color_G
                                    break;
                                 case 3: PORTB.1 = twi_rx_buffer[i]; //color_B
                                    break;
                                }; 
                            if(read_command == 3){
                                read_command = 0;       
                            }
                            else 
                                read_command++;
                        }
                        break;
                        case 2:{    //set LED    
                            PORTD.6 = twi_rx_buffer[i];
                            read_command = 0;    
                        }
                        break;
                        case 3:{    //open door    
                            PORTB.4 = twi_rx_buffer[i];
                            read_command = 0;            
                        }
                        break;
                        }; 
                }
        };
        twi_tx_buffer[0] = 0;        
    }
    else  {                            //command get      
        for (i = 0; i < 21; i++) {
            twi_tx_buffer[i] = 0;    
        }; 
        for (i = 2; i < twi_rx_buffer[0] - 1; i++) {  //twi_rx_buffer[0] - count command   
            twi_tx_buffer[size_commands + 1] = twi_rx_buffer[i];
            if(twi_rx_buffer[i] == 1){
                size_commands += 4;                           
            }else{
                if((twi_rx_buffer[i] == 5) || (twi_rx_buffer[i] == 6)){
                    size_commands += 3;    
                }else
                    size_commands += 2;
            }                    
        };
        
        size_commands++;        
        
        for (i = 2; i < size_commands; i++) {  //twi_rx_buffer[0] - count command   
            if (write_command == 0) {
                    current_command = twi_tx_buffer[i];
                    write_command = 1;  
                }
                else{
                    switch (current_command) {
                        case 0:{   //get power    
                            switch(status_power){
                                case 0: twi_tx_buffer[i] = 1;; //OFF
                                    break;
                                case 1: twi_tx_buffer[i] = 0; //ON
                                    break;
                                case 2: twi_tx_buffer[i] = 2; //FAIL
                                    break;
                            };                
                            
                            write_command = 0;    
                        }
                        break; 
                        case 1:{    //get color rgb
                            switch (write_command) {
                                 case 1: twi_tx_buffer[i] = color_R;
                                    break;
                                 case 2: twi_tx_buffer[i] = color_G;
                                    break;
                                 case 3: twi_tx_buffer[i] = color_B;
                                    break;
                                }; 
                            if(write_command == 3){
                                write_command = 0;       
                            }
                            else 
                                write_command++;
                        }
                        break; 
                        case 2:{    //get status_LED    
                            twi_tx_buffer[i] = status_LED;
                            write_command = 0;    
                        }
                        break;
                        case 3:{    //get status_lock    
                            twi_tx_buffer[i] = status_lock;
                            write_command = 0;    
                        }
                        break;                                                                                   
                        case 4:{    //get status_phone    
                            twi_tx_buffer[i] = status_phone;
                            write_command = 0;    
                        }
                        break;
                        case 5:{    //get avarage_current    
                            switch (write_command) {
                                 case 1: twi_tx_buffer[i] = avarage_current;
                                    break;
                                 case 2: twi_tx_buffer[i] = avarage_current>>8;
                                    break;
                                }; 
                            if(write_command == 2){
                                write_command = 0;       
                            }
                            else 
                                write_command++;            
                        }
                        break;
                        case 6:{    //get avarage_voltage    
                            switch (write_command) {
                                 case 1: twi_tx_buffer[i] = avarage_voltage;
                                    break;
                                 case 2: twi_tx_buffer[i] = avarage_voltage>>8;
                                    break;
                                }; 
                            if(write_command == 2){
                                write_command = 0;       
                            }
                            else 
                                write_command++;            
                        }
                        break; 
                        }; 
                }        
        };         
        size_commands++;
        twi_tx_buffer[0] = size_commands;
        twi_tx_buffer[1] = 1;
        for (i = 0; i < size_commands - 1; i++) {
            checksum +=  twi_tx_buffer[i];       
        };
        twi_tx_buffer[size_commands - 1] = checksum;        
    };    
    }else{
        twi_tx_buffer[0] = 255;  
    } 
    }else{
        twi_tx_buffer[0] = 255;
    }


   }
else
   {
   // Receive error
   // Place your code here to process the error

   return false; // Stop further reception
   }

// The TWI master has finished transmitting data?
if (rx_complete) return false; // Yes, no more bytes to receive

// Signal to the TWI master that the TWI slave
// is ready to accept more data, as long as
// there is enough space in the receive buffer
return (twi_rx_index<sizeof(twi_rx_buffer));
}

// TWI Slave transmission handler
// This handler is called for the first time when the
// transmission from the TWI slave to the master
// is about to begin, returning the number of bytes
// that need to be transmitted
// The second time the handler is called when the
// transmission has finished
// In this case it must return 0
unsigned char twi_tx_handler(bool tx_complete)
{
if (tx_complete==false)
   {
   // Transmission from slave to master is about to start
   // Return the number of bytes to transmit  
        
    
   return sizeof(twi_tx_buffer);
   }

// Transmission from slave to master has finished
// Place code here to eventually process data from
// the twi_rx_buffer, if it wasn't yet processed
// in the twi_rx_handler 

// No more bytes to send in this transaction
return 0;
}

// Declare your global variables here

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here    16ms
    b1=0;
}


// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x1e;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x04;
DDRD=0x60;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15,625 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x05;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=0x00;
EIMSK=0x00;
PCICR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x01;

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// USART initialization
// USART disabled
UCSR0B=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR1=0x00;

// ADC initialization
// ADC disabled
ADMUX = 0x40;
ADCSRA = 0x87;    

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// TWI initialization
// Mode: TWI Slave
// Match Any Slave Address: Off
// I2C Bus Slave Address: 0x00
twi_slave_init(false, SLAVE_ADDRESS,twi_rx_buffer,sizeof(twi_rx_buffer),twi_tx_buffer,twi_rx_handler,twi_tx_handler);

Permit=0;
current=0;
voltage=0;
counter_digitizing = 0;

avarage_current = 0;
avarage_voltage = 0;
status_power = 1;
status_phone = 0;
status_lock = 0; 
status_LED = 0;
color_R = 0;
color_G = 0;
color_B = 0;

// Global enable interrupts
#asm("sei")

while (1)
      {
      b1=1;
      color_R = PORTB.3;
      color_G = PORTB.2;
      color_B = PORTB.1;              
      status_LED = PORTD.6;
      status_lock = PIND.2;
       
      if (PORTB.4==1){
        Permit++;
        if (Permit==10){
            PORTB.4=0;   
            Permit=0;
        }
      }
      else
        Permit=0;
             
      if(status_power == 0){
        ADMUX&=0xfe;    
        ADCSRA|=0x40;
        while((ADCSRA&0x40)==0x40);
        current+=ADCW;
        
        ADMUX|=0x01;    
        ADCSRA|=0x40;
        while((ADCSRA&0x40)==0x40);
        voltage+=ADCW;
         
        counter_digitizing++;
        if(counter_digitizing == 8){        
            avarage_current = current>>3;
            avarage_voltage = voltage>>3;
             if (avarage_current > RESTRICTIVE_CURRENT){
                PORTD.5 = 1;
                status_power = 2; // Error power
             }
             if (avarage_current > MIN_SUPPLY_CURRENT){ 
                status_phone = 1;
             }else{
                status_phone = 0;
             }
            counter_digitizing = 0;       
            current = 0;
            voltage = 0;   
        } 
      }      
      
      while(b1);
      }
}