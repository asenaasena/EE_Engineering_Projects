// Very simple code to read the analog A0 input and send it to the PC to 
// be evaluated in MATLAB. 


int sensorValue = 0;
void setup() {
 

  pinMode(7, OUTPUT);
Serial.begin(115200); // serial communication hizini belirleme
}

void loop() {





sensorValue = analogRead(0); // Sampling A0 port
sensorValue = sensorValue / 4;  // Losing some precision to fit in a byte
Serial.write(sensorValue); // serial port to PC


}
