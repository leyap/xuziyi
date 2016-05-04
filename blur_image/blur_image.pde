/*
 *	author:	lisper
 *	email:	leyapin@gmail.com
 *	time:	2016-05-05
 */

import processing.serial.*;

Serial myPort;                       // The serial port

int arrayMax = 10;
String serialInArray = new String();
int [] levelValues = new int[arrayMax];
int count = 0;
int distance;
PImage img;

void setup () {
	size(500, 400);  // Stage size
	printArray(Serial.list());
	String portName = Serial.list()[4];
	myPort = new Serial(this, portName, 9600);
	img = loadImage ("image.jpg");
}

void draw() {
	image(img, 0, 0, width, height);
	filter(BLUR, map(distance, 300, 0, 0, 8));
	noFill();
	ellipse(width/2, height/2, distance, distance);
}

void serialEvent(Serial myPort) {
	int inByte = myPort.read();
	if (inByte == '\r') {
		if (serialInArray.length() > 0) {
			distance  = Integer.parseInt(serialInArray, 16);
			levelValues[count++] = distance;
			if (count >= arrayMax) {
				count = 0;
			}
			distance = 0;
			for (int i=0; i<arrayMax; i++) {
				distance += levelValues[i];
			}
			distance /= arrayMax;
			println("v = "+distance);
		}
		serialInArray = "";
	} else {
		if (inByte >= '0' && inByte <= '9' || (inByte >= 'A' && inByte <= 'F')) {
			println(char(inByte));
			serialInArray+=char(inByte);
		} else {
			println ("=="+inByte);
		}
	}
}

