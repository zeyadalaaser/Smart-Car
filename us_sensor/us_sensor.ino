
// Define the pins for the ultrasonic sensor and LED
const int trigPin = 9;
const int echoPin = 10;
const int outPin = 4;

int enA = 3;
int enB = 5;

// Variables for duration and distance calculation
long duration;
int distanceThreshold = 4; // Distance threshold in centimeters

void setup() {
  // Define the trigPin as an output and echoPin as an input
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // Define the outPin as an output
  pinMode(outPin, OUTPUT);
  pinMode(enA, OUTPUT);
	pinMode(enB, OUTPUT);

  analogWrite(enA, 215);
  analogWrite(enB, 255);
}

void loop() {
  // Clear the trigPin
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);

  // Set the trigPin on HIGH state for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Read the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);

  // Calculate the distance in centimeters
  int distance = duration * 0.034 / 2;

  // Check if the object is 4cm away
  if (distance <= distanceThreshold) {
    digitalWrite(outPin, LOW);
  } else {
    digitalWrite(outPin, HIGH);
  }

  // Delay before the next measurement
  
  delayMicroseconds(10);
}