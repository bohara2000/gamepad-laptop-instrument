import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

String oscServer = "127.0.0.1"; 
int oscServerPortSend = 6449; 
int oscServerPortReceive = 6450; 

ArrayList<Track> tracks;
ArrayList<FloatList> TrackMeasures;
PFont f; 

// color values for tracks
float r;
float g;
float b;

float t=6;

void setup()
{
  size(displayWidth, displayHeight);
  frameRate(25); 
 
  oscP5 = new OscP5(this,oscServerPortReceive);
  
  f = createFont("Serif.bolditalic", 48);
  fill(102);
  textFont(f,48);  
  tracks = new ArrayList<Track>();
  TrackMeasures = new ArrayList<FloatList>();
}

void draw()
{  
  
  for (int i = 0; i < tracks.size(); i++)
  {    
      tracks.get(i).display(TrackMeasures.get(i));    
  }

}

boolean sketchFullScreen() {
  return true;
}

void oscEvent(OscMessage theOscMessage) { 
  
  if(theOscMessage.addrPattern().equals("/track/create"))
  {
    /* print the address pattern and the typetag of the received OscMessage */ 
    println("### received an osc message."); 
    print(" addrpattern: "+theOscMessage.addrPattern()); 
    println(" typetag: "+theOscMessage.typetag()); 
    println(" arguments: "+theOscMessage.arguments().length); 
    
    println("Creating track" + theOscMessage.get(0).intValue());  // Does not execute
    
    // define a FloatList for beat lengths
    FloatList measure = new FloatList();
    
    for (int i = 1; i < theOscMessage.arguments().length; i++)
    {      
      println(i);
      //println("filling: " + theOscMessage.get(i).floatValue());
      measure.append(theOscMessage.get(i).floatValue());
    }
    
    TrackMeasures.add(measure);
    
    // add track
    text((tracks.size()+1),10, 61 + (((height-20)/8)+0)*tracks.size());
    float i;
  
    for (i=0; i<t; i=i+1) {
      
      if(i<(t/3) || i>(2*t/3)) {
        r=255;
      }
      else{
        r=80;
      }
        if (i>=t/6 && i<=t/2) {
        g=255;
        }
        else{
          g=80;
        }
      if(i>t/3) {
        b=255;
      }
      else {
        b=80;
      }
      
      if ( i == tracks.size() ) { break; }
    }
    tracks.add(new Track(81, 11 + (((height-20)/8)+0)*tracks.size(), width*0.85, ((height-20)/8)-10, r,g,b));  
  }
  
  if(theOscMessage.addrPattern().equals("/track/click"))
  {
       //println("track click"); 
       //println(" typetag: "+theOscMessage.typetag()); 
       //println(" arguments: "+theOscMessage.arguments().length); 
       int TrackNumber = theOscMessage.get(0).intValue();
       int BeatNumber = theOscMessage.get(2).intValue();
       //println("Track: " +TrackNumber+" - Beat: "+ BeatNumber);
       for( int i = 0; i < tracks.get(TrackNumber).beats.size(); i++ )
       {
         if (i == BeatNumber)
         {
           tracks.get(TrackNumber).beats.get(i).bgdcolor = 255;
         } else {
           tracks.get(TrackNumber).beats.get(i).bgdcolor = 0;
         }
         
       }
       
  }
  
  if(theOscMessage.addrPattern().equals("/track/pulse"))
  {
       println("track pulse playing");  // Does not execute
       println(" typetag: "+theOscMessage.typetag()); 
       println(" arguments: "+theOscMessage.arguments().length); 
       int TrackNumber = theOscMessage.get(0).intValue();
       int BeatNumber = theOscMessage.get(1).intValue();
       int InstrumentNumber = theOscMessage.get(2).intValue();
       
       //println("Track: "+ TrackNumber + " - Beat: " + BeatNumber + "Instrument: " + InstrumentNumber);
       for( int i = 0; i < tracks.get(TrackNumber).beats.size(); i++ )
       {
         // draw or hide the instrument icon
         if (i == BeatNumber)
         {
           // reset image to null by default
           tracks.get(TrackNumber).beats.get(i).img = null;
           if (InstrumentNumber >= 0){
             tracks.get(TrackNumber).beats.get(i).bgdcolor= -1;
             if (InstrumentNumber == 0)
             {
               tracks.get(TrackNumber).beats.get(i).img = loadImage("120px-PlayStationTriangle.svg.png");
             }        
             if (InstrumentNumber == 1)
             {
               tracks.get(TrackNumber).beats.get(i).img = loadImage("120px-PlayStationCircle.svg.png");
             }
             if (InstrumentNumber == 2)
             {
               tracks.get(TrackNumber).beats.get(i).img = loadImage("120px-PlayStationX.svg.png");
             }
             if (InstrumentNumber == 3)
             {
               tracks.get(TrackNumber).beats.get(i).img = loadImage("120px-PlayStationSquare.svg.png");
             } 
           } else {
             //println("-----------------------###################################-----------------------");
             tracks.get(TrackNumber).beats.get(i).img = null;
           }
           
         }
       }
       
       // perhaps here we can use transparent svg files in the middle...
  }
  
} 

class Track
{
  float w; // single bar width
  float xpos; // rect xposition
  float h; // rect height
  float ypos ; // rect yposition
  
  int bgcolor = -1; // background color
  
  float bgR = -1;
  float bgG = -1;
  float bgB = -1;
  
  int beatPadding = 5; // padding around Beat objects
  
  ArrayList<Beat> beats;
  
  Track(float ixp, float iyp, float iw, float ih, int ibg)
  {
    w = iw; 
    xpos = ixp;
    h = ih;
    ypos = iyp; 
    bgcolor = ibg;
    beats = new ArrayList<Beat>();    
  }
  
  Track(float ixp, float iyp, float iw, float ih, float ibgR, float ibgG, float ibgB)
  {
    w = iw; 
    xpos = ixp;
    h = ih;
    ypos = iyp; 
    bgR = ibgR;
    bgG = ibgG;
    bgB = ibgB;
    beats = new ArrayList<Beat>();    
  }
  
  // default - build one beat object
  void display()
  {
    if (bgcolor != -1)
    {
      fill(bgcolor);
    } else {
      fill(bgR, bgG, bgB);
    }
    
    rect(xpos, ypos, w, h, 10);
    
    beats.add(new Beat( xpos + 10, ypos +10, w*0.5, h*0.70, 40) );
    beats.get(0).display();
  }
  
  // build a number of beats of equal width
  void display(int nbrOfBeats)
  {
    if (bgcolor != -1)
    {
      fill(bgcolor);
    } else {
      fill(bgR, bgG, bgB);
    }
    
    rect(xpos, ypos, w, h, 10);
    
    for (int i = 0; i < nbrOfBeats; i++) {
      beats.add(new Beat( ((xpos + beatPadding) + (w/nbrOfBeats)*i), (ypos + beatPadding), ((w/nbrOfBeats)-(beatPadding*2)), (h-(beatPadding*2)), 40) );
      beats.get(i).display();
    }
  }
  
  // build a number of beats with different widths
  void display(FloatList beatArray)
  {
    FloatList beatWidthPercentages = new FloatList();
    float totalBeatWidth = 0.0;
    
    if (bgcolor != -1)
    {
      fill(bgcolor);
    } else {
      fill(bgR, bgG, bgB);
    }
    rect(xpos, ypos, w, h, 10);
    
    // get the sum of the values in the beatArray
    for (int i = 0; i < beatArray.size(); i++) {
      totalBeatWidth+=beatArray.get(i);
    }
    
    // now get the beat width percentages
    for (int i = 0; i < beatArray.size(); i++) {
      beatWidthPercentages.append(beatArray.get(i)/totalBeatWidth);
    }
    
    
    // get the
    float newXPos = 0; 
    
    for (int i = 0; i < beatArray.size(); i++) {
      if (i == 0)
      {
        newXPos += (xpos + beatPadding);
      } else {
        newXPos += w*beatWidthPercentages.get(i-1);
      }
       
      beats.add(new Beat( newXPos, (ypos + beatPadding), ((w*beatWidthPercentages.get(i))-(beatPadding*2)), (h-(beatPadding*2)), 40) );
      beats.get(i).display();
    }
    
  }
}

class Beat
{
  float w; // single bar width
  float xpos; // rect xposition
  float h; // rect height
  float ypos ; // rect yposition
  
  int bgdcolor; // background color
  PImage img; // "instrument" image - indicates which image selected
  
  float bgR = -1;
  float bgG = -1;
  float bgB = -1;
  
  Beat(float ixp, float iyp, float iw, float ih, int ibg)
  {
    w = iw; 
    xpos = ixp;
    h = ih;
    ypos = iyp; 
    bgdcolor = ibg;

    
  }
  
  void display()
  {
    if (bgdcolor != -1)
    {
      fill(bgdcolor);
      rect(xpos, ypos, w, h, 10);
    } else {
      fill(0);
      rect(xpos, ypos, w, h, 10);
    }
    
    if (img != null)
    {
      image(img, xpos + (w-60)/2, ypos + (h - 60)/2, 60, 60);
    } 
  }
  
  
}
