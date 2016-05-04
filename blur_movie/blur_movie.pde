/*
 *	author:	lisper
 *	email:	leyapin@gmail.com
 *	time:	2016-05-05
 */

import processing.serial.*;
import processing.video.*;

Movie movie;

Serial myPort;                       // The serial port

int arrayMax = 5;
String serialString = new String();
int []  levelValues = new int[arrayMax];
boolean isTest = false;
int count = 0;
int distance;
//PImage img;
float blurValue;
float step;

void setup () {
	size(640, 480);  
	printArray(Serial.list());
	String portName = Serial.list()[4];
	myPort = new Serial(this, portName, 9600);
	//img = loadImage ("image.jpg");
	movie = new Movie(this, "mov.mov");
	movie.loop();
	stroke(30, 130, 30, 130);
	noFill();
}


void draw() {
	//image(img, 0, 0, width, height);
	image(movie, 0, 0, width, height);
	//float currentBlurValue = map(constrain(distance, 10, 150), 150, 10, 0, 18);
	float currentBlurValue = map(constrain(distance, 50, 150), 50, 150, 0, 10); 
	step =  (currentBlurValue-blurValue)/10;

	blurValue += step;
	if (blurValue < 0) {
		blurValue = 0;
	} else if (blurValue > 10 ) {
		blurValue = 10;
	}
	filter(BLUR, blurValue);
	if (isTest) {
		ellipse(width/2, height/2, blurValue*30+10, blurValue*30+10);
	}
}

//
void movieEvent(Movie m) {
	m.read();
}

//
void serialEvent(Serial myPort) {
	int inByte = myPort.read();
	if (inByte == '\r') {
		if (serialString.length() > 0) {
			distance  = Integer.parseInt(serialString, 16);
			levelValues[count++] = distance;
			if (count >= arrayMax) {
				count = 0;
			}
			distance = 0;
			for (int i=0; i<arrayMax; i++) {
				distance += levelValues[i];
			}
			distance /= arrayMax;
			println("distance = "+distance);
		}
		serialString = "";
	} else {
		if (inByte >= '0' && inByte <= '9' || (inByte >= 'A' && inByte <= 'F')) {
			serialString+=char(inByte);
		}
	}
}

//
void keyPressed() {
	if (key == ' ') {
		isTest = !isTest;
	}
}

