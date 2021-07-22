char input[] ="Just close your eyes, ramazanhcamizqwerty  dididasena"; //user can enter characters
int datasize = sizeof(input);

uint8_t manch[(((sizeof(input)-1)*7) +2+14)*2];  //size of manchestor code
int lim =0;

int i;
int c;
int z;
int k;
int j;

int ledState = LOW;             // ledState used to set the LED
int rnd_interval;               //variable to be used for tolerance tests
//// Generally, you should use "unsigned long" for variables that hold time
//// The value will quickly become too large for an int to store
unsigned long previousMillis = 0;        // will store last time LED was updated
//
//// constants won't change:
const long interval = 50;     // one period is set as 50ms


int tr_ct = 0;  //counter


int sensorValue = 0; 
void setup() {
  // put your setup code here, to run once:
char a;
int b;
uint8_t bin[(sizeof(input)-1)*7];
uint8_t bin_s[((sizeof(input)-1)*7) +2+14];
uint8_t STR[] = {0,0,0,0,0,1,0};
uint8_t ENDTR[] = {0,0,0,0,1,0,0};

  //////////////

  //take the data bits
for (i = 0; i < datasize - 1; i++) {

    a = input[i];
    b=a;
    int num = b;

//decimal to 7-bit binary conversion
   for (z=6 ; z>=0 ; z--){
    bin[z+i*7]=num%2;
    num=num/2;
     
   }

}
//pilot code for the beginning
bin_s[0]=1;
bin_s[1]=0;

//detection for the beginning
for(i=0;i<7;i++){
  bin_s[i+2] = STR[i];
}

//actual data
for(i=0;i<sizeof(bin);i++){
bin_s[i+9] = bin[i];
}


//detection for the end
for(i=0;i<7;i++){
  bin_s[i+9+sizeof(bin)] = ENDTR[i];
}

//for(c=0;c<sizeof(bin_s);c++){
//Serial.print(bin_s[c]);
//}


//converting every bit  to 2 bit according to Manchestor coding
  for( j=0;j < sizeof(bin_s); j++){
if(bin_s[j]==1){
  manch[2*j]=0;
  manch[2*j+1]=1;
}
else if (bin_s[j]==0){

  manch[2*j]=1;
  manch[2*j+1]=0;
}
//Serial.println(j);

}

lim = sizeof(manch) ; //putting a limit so that after transmission there will be no blinking

  pinMode(7, OUTPUT);
Serial.begin(9600); // serial communication hizini belirleme
}

void loop() {
//Blinking LED
unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= rnd_interval/2)  {
     rnd_interval = interval+random(-8,9); //randomness for test case
    // save the last time you blinked the LED
    previousMillis = currentMillis;
    if(tr_ct<lim){
    // if the LED is off turn it on and vice-versa:

    //if bit is 1 which means led is on and vice versa
    if (manch[tr_ct]==1) {
      ledState = HIGH;
    } else if (manch[tr_ct]==0) {
      ledState = LOW;
    }
    tr_ct++;
    }
    if(tr_ct > 999999){ //to avoid overflow
        //Serial.println(tr_ct);
        tr_ct = 0;
    }

    
    // set the LED with the ledState of the variable:
    digitalWrite(7, ledState);
  }


//  
//  // put your main code here, to run repeatedly:
//sensorValue = analogRead(0); // A0 portundan sample alma 
//sensorValue = sensorValue / 4;
//Serial.write(sensorValue); // serial port'tan PC'ye yollama
////Serial.println(sensorValue);

}
