#include <Wire.h>

byte Response[4];
void setup() {
  Response[0] = 4;
  Response[1] = 0;
  
  Response[2] = 3;
  Response[3] = 1;
  
/* Response[4] = 1;
  Response[5] = 1;
  Response[6] = 1;
  Response[7] = 1;
  
  Response[8] = 2;
  Response[9] = 1;
  
  Response[10] = 3;
  Response[11] = 1;*/

//  Response[0] = 3;
//  Response[1] = 1;
//  Response[2] = 0;
  /*Response[3] = 1;
  Response[4] = 2;
  Response[5] = 3;
  Response[6] = 4;
  Response[7] = 5;
  Response[8] = 6;*/
  Wire.begin(); // join i2c bus (address optional for master)
  Serial.begin(9600);  // start serial for output
}

void loop() {
  Wire.beginTransmission(0x00); // transmit to device #8
  //if ( Response[3] == 1) {         // check if the input is HIGH (button released)
 //     Response[3] = 0;
 // } else {
 //    Response[3] = 1;
 // }
  Wire.write(Response, 4);              // sends one byte
  Wire.endTransmission();    // stop transmitting

//  Wire.requestFrom(0x00, 20);
//  byte t = Wire.read(); // receive a byte as character
//  Serial.println("********************");         // print the character
//  Serial.println(t);         // print the character
//  t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
  
  /*t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character
  t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character
  
  t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character
  t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character

   t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character
   t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character
  t = Wire.read(); // receive a byte as character
  Serial.println(t);  

   t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character
   t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character
  t = Wire.read(); // receive a byte as character
  Serial.println(t);         // print the character*/

//  t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
//   t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
//  t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
//  t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
//
//   t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
//  t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
//
//  t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
//  t = Wire.read(); // receive a byte as character
//  Serial.println(t);         // print the character
  
  delay(1000);
}
