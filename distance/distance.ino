void setup() {
  // put your setup code here, to run once:
  Serial.begin (9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int32_t value = analogRead (A0);
  Serial.print (value * 3 / 10, HEX);
  Serial.write('\r');
  delay(200);
}

// 0 5000
// 0 1023
//L = 3096*Vout/Vcc
//Serial.println (3096/5*map(value, 0, 1023, 0, 5000)/10000);

