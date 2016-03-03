import processing.serial.*;

Serial serialPort  = new Serial(this, Serial.list()[0], 9600);  // Create object from Serial class
int boxsize = 50;
int cols, rows;
color[][] grid;
 
void setup() {
  size(800, 400);
  cols = width/boxsize;
  rows = height/boxsize;
  grid = new color[cols][rows];
 
  // to start them all white (by default they start 0 aka black)
  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      grid[i][j] = color(255); // set each to white
    }
  }
}
 
void draw() {
  background(255);
  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      int x = i*boxsize;
      int y = j*boxsize;
      if (mouseX > x && mouseX < (x + boxsize) && mouseY > y && mouseY < (y + boxsize)) {
        if (mousePressed && (mouseButton == LEFT)) {
          grid[i][j] = color(255, 0, 0); // red, color of LED
        } else if (mousePressed && (mouseButton == RIGHT)) {
          grid[i][j] = color(255, 255, 255); // explicit 255 * 3
        }
      }
      fill(grid[i][j]);
      rect(x, y, boxsize, boxsize);
    }
  }
}

void mouseReleased() {
  // Whenever the mouse is clicked, send the data through serial
  //serialPort.write(254);
  int[] serialData = new int[16]; // one value for type, 16 for cols
  
  // Signals to Arduino that it should translate picture
  //serialData[0] = 254;
  
  for (int col = 0; col < 16; col++) {
    for (int row = 7; row >= 0; row--) {
      if (grid[col][row] == color(255, 0, 0)) {
        serialData[col] += pow(2, 7 - row);
      }
    }
  }
  
  // Send the data over the Serial port
  for (int col = 0; col < 16; col++) {
    serialPort.write(serialData[col]);
  }
}
