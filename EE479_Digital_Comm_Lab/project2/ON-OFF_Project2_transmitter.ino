int ledState = LOW;             // ledState used to set the LED

unsigned long previousMillis = 0;        // will store last time LED was updated

// constants won't change:
const long interval = 60;           // interval at which to blink (milliseconds)
int rnd_interval;


//char input[] ="Ali ata bak. Emel eve gel. Pelin topu tut. qwertyuiop OLEEY !!!";

//for user, enter the sequence you want to transmit
char input[]  ="Robert's got a quick hand ";
int datasize = sizeof(input);
char a;
int b;
uint8_t bin[(sizeof(input)-1)*7];
int i;
int z;
int k;
uint8_t bin_s[((sizeof(input)-1)*7) +3+14];
uint8_t STR[] = {0,0,0,0,0,1,0};
uint8_t ENDTR[] = {0,0,0,0,1,0,0};
int lim=0;
int tr_ct = 0;


int sensorValue = 0;
void setup() {
  // put your setup code here, to run once:
  ///////////////////
rnd_interval = interval;
  /////////////////////////

  //data read
for (i = 0; i < datasize - 1; i++) {

    a = input[i];
    b=a;
    int num = b;


//decimal to 7-bit binary
   for (z=6 ; z>=0 ; z--){
    bin[z+i*7]=num%2;
    num=num/2;
     
   }

}


//sending pilot symbols for detection
bin_s[0]=0;
bin_s[1]=1;
bin_s[2]=0;

//detection for beginning
for(i=0;i<7;i++){
  bin_s[i+3] = STR[i];
}

for(i=0;i<sizeof(bin);i++){
bin_s[i+10] = bin[i];
}
//detection for the end
for(i=0;i<7;i++){
  bin_s[i+10+sizeof(bin)] = ENDTR[i];
}
lim = sizeof(bin_s) -1 ;  //putting a limit so that after transmission there will be no blinking
  pinMode(7, OUTPUT);
//Serial.begin(115200); // serial communication hizini belirleme
}

void loop() {
//Blinking LED
unsigned long currentMillis = millis();



  if (currentMillis - previousMillis >= rnd_interval) {
    // save the last time you blinked the LED
    previousMillis = currentMillis;
    rnd_interval = interval+random(-10,11);  //random frequency tolerance test
    // if the LED is off turn it on and vice-versa:
    if(tr_ct<lim){
      //if bit is one,it means bright
    if (bin_s[tr_ct]==1) {
      ledState = HIGH;
    } else if (bin_s[tr_ct]==0) {
      ledState = LOW;
    }
    tr_ct++;
    //if(tr_ct > sizeof(bin)-2){
    }
       if(tr_ct > 999999){ //in order to avoid overflow
       // Serial.println(tr_ct);
        tr_ct = 0;
    }

    
    // set the LED with the ledState of the variable:
    digitalWrite(7, ledState);
  }


  
//  // put your main code here, to run repeatedly:
//sensorValue = analogRead(0); // A0 portundan sample alma 
//sensorValue = sensorValue / 4;
//Serial.write(sensorValue); // serial port'tan PC'ye yollama
////Serial.println(sensorValue);

}
