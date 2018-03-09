#include <Wire.h>  

/* Arduino's I2C Slave Address */
#define SLAVE_ADDRESS 0x04

/* PIN DECLARATION */
int Pin_LockGet = 2;//PD2
int Pin_Amperag = A0; //pc 0
int Pin_LockSet = 12; //pb 4
int Pin_LightR = 11; //pb 3
int Pin_LightG = 10; //pb 2
int Pin_LightB = 9; //pb 1
int Pin_LED = 6; //pd 6

/* Global Variable */
volatile short Value_Amperag;
volatile short Value_LightR = 0;
volatile short Value_LightG = 0;
volatile short Value_LightB = 0;
volatile short Value_LED = 0;
volatile bool Value_Lock;

/* Protocol Variable */
byte Mode, Pin, Value;
byte Response[5];


void setup()
{
	// Initialize pins
	pinMode(Pin_Amperag, INPUT);
	pinMode(Pin_LockGet, INPUT);
	pinMode(Pin_LockSet, OUTPUT);
	pinMode(Pin_LightR, OUTPUT);
	pinMode(Pin_LightG, OUTPUT);
	pinMode(Pin_LightB, OUTPUT);
	pinMode(Pin_LED, OUTPUT);

	Serial.begin(9600);

	// Initialize I2C Slave on address 'SLAVE_ADDRESS'
	Wire.begin(SLAVE_ADDRESS);
	Wire.onRequest(SendData); //��������� ������� �� �������
	Wire.onReceive(ReceiveData); //����������� ������ �� �������
}

void loop()
{
	// Read Amperag value
	Value_Amperag = map(analogRead(Pin_Amperag), 0, 1023, 0, 255);

	// Read Pin_LockGet value
	Value_Lock = (digitalRead(Pin_LockGet) == HIGH) ? true : false;

  analogWrite(Pin_LightR, Value_LightR);
  analogWrite(Pin_LightG, Value_LightG);
  analogWrite(Pin_LightB, Value_LightB);
  analogWrite(Pin_LED, Value_LED);

	// Wait for 100 ms
	delay(100);
}

// Callback for I2C Received Data
void ReceiveData(int byteCount)
{
	// Read first byte which is Protocol Mode
	Mode = Wire.read();

	// Read second byte which is Pin. Only Valid for Mode 2
	Pin = Wire.read();

	// Read third byte which is Pin-Value. Only Valid for Mode 2
	Value = Wire.read();

	if (Mode == 2)
	{
		digitalWrite(Pin, Value);
	}

	if (Mode == 3)
	{
    switch (Pin)
    {
    case 11:
      Value_LightR = constrain(Value, 0, 255);
      break;
    case 10:
      Value_LightG = constrain(Value, 0, 255);
      break;
    case 9:
      Value_LightB = constrain(Value, 0, 255);
      break;
    case 6:
      Value_LED = constrain(Value, 0, 255);
      break;
    default:
      break;
    }
	}
}

void SendData()
{
	switch (Mode)
	{
	case 0: // Mode: Read Lock and USB
		Response[0] = (byte)Value_Amperag;
		Response[1] = (byte)((Value_Lock == true) ? 1 : 0);
		break;
	case 1: // Mode: Read Devices State
		Response[0] = (digitalRead(Pin_LockSet) == HIGH) ? 1 : 0;
		Response[1] = Value_LightR;
		Response[2] = Value_LightG;
		Response[3] = Value_LightB;
		Response[4] = Value_LED;
		break;
	case 2: // Mode: Set Device State
		Response[0] = (digitalRead(Pin) == HIGH) ? 1 : 0;
		break;
	case 3: // Mode: Set Device State
		Response[0] = map(analogRead(Pin), 0, 1023, 0, 255);
		break;
	default:
		break;
	}

	// Wire back response
	Wire.write(Response, 5);
}
