import java.util.Iterator;  //<>//
import java.util.*;
import  java.lang.Object;
// Example of Reading from JSON and Visualisation of Visitor Tracks
// 1.2 / p3.3

String filename="out.json",metadata="meta.json",metastats="metastats.json";                    // temp. filename
Boolean isInit = false;
JSONObject json,meta;

JSONObject moment;

//Array of json arrays
JSONArray[] tracks;

float h;
int i0=0;
int i1=0;
int[] count;

float[][] x_coord;
float[][] y_coord;
int[][] stops;
float[][] h_height;
String[][] timestamps;
float[][] speed;

int[] lenght;
float[] h_mid;

float [][]tmeta;

String start_time, end_time;                    // Starting and ending time of all tracks in the file

int text_oX = 30;
int text_oY = 70;

int pieX = 180;
int pieY = 450;


//int oX =900;
//int oY = 850;
int oX =1188;
int oY = 670;
float Ok = 105;
float Okx = 120;
float trx = -90;

int room_oX = 250;
int room_oY = 30;
int wd = 1110;
int ht = 615;

//---------------------------------
// interface. buttons
//---------------------------------
int rectX1 = 150, rectY1 = 46;      // Position of square button
int rectX2 = 270, rectY2 = rectY1;      // Position of square button
int rectSizeW = 50;     // Diameter of rect
int rectSizeH = 35;     // Diameter of rect
color rectColor = color(222);
color rectHighlight = color(100,100,100);
boolean rectOver1 = false;
boolean rectOver2 = false;
// heatmap button
int heatX = 30, heatY = rectY1+ 60;      // Position of square button
int heatW = 170;     // Diameter of rect
int heatH = 35;     // Diameter of rect
color heatColor = color(222);
color heatHighlight = color(100,100,100);
boolean heatOver = false;
//
// normal button
int norX = 220, norY = heatY;      // Position of square button
int norW = 190;     // Diameter of rect
int norH = 35;     // Diameter of rect
color norColor = color(222);
color norHighlight = color(100,100,100);
boolean norOver = false;
// End ofinterface. buttons
//---------------------------------

boolean agg = false;
//---------------------------------
// heatmap
//---------------------------------
float[][] interp_array;
boolean showHeatMap = false;
// End of heatmap
//---------------------------------


int circleX, circleY;  // Position of circle button
color currentColor;

int curTrk = -1;

int[][] angles;
//int[] angles = { 10, 20, 150};

int cx = 10, cy = 20;

int nstops = 0;


PImage timebg;


PImage jelly;
PGraphics pg;

PImage holdimg,attimg,enjimg;

// ---------
int total_people=0;
int total_visits=0;

//----------
float itemsAgg[][];

float itemsx[] = { 0,0,0,0,0,0,0 };
float itemsy[] = { 0,0,0,0,0,0,0 };


// ------------------


void setup() {
  fullScreen();
  reset();
  // heatmap
  int heatW = 870, heatH = 870;
  
  pg = createGraphics(heatW, heatH);
  interp_array = new float[heatW][heatH];
  makeArray(); 
  
}


void reset() {
  rect(room_oX, room_oY, wd, ht);
  jelly = loadImage("b2pplan.jpg");
  
  holdimg = loadImage("holdimg.png");
  attimg = loadImage("attimg.png");
  enjimg = loadImage("enjimg.png");
  
  jelly.resize(width, height);
  background(jelly);
  loadData();  
  
  
    
  //if(curTrk<9) {
  //  int x = curTrk+1;
  //  loadMetadata("t0"+x);
  //}
  // else {
  //   int x = curTrk+1;
     
  // }
  if(curTrk>-1) {
    
    int x = curTrk + 1;
    loadMetadata("t0"+x);    
    drawIndices();
    
  } else if ( curTrk == -2) {
    
    for(int i =0;i< lenght.length ; i++) {
      int x = i + 1;
      background(jelly);
      loadMetadata("t0"+x);
      drawIndices();
      
    }
  }
}


// Fill array with Perlin noise (smooth random) values
void makeArray() {
  for (int c = 0; c < interp_array.length; c++) {
    for (int r = 0; r < interp_array[c].length; r++) {
      // Range is 24.8 - 30.8      
      interp_array[c][r] = 24.8 + 5.0 * noise(r * 0.01, c * 0.01);
    }
  }
}


void applyColor() {  // Generate the heat map
  
  pushStyle();

  pg.beginDraw();

  colorMode(HSB, 1, 1, 1);
  pg.loadPixels();
  int p = 0;
  for (int c = 0; c < interp_array.length; c++) {
    for (int r = 0; r < interp_array[c].length; r++) {
      // Get the heat map value 
      float value = interp_array[c][r];
      // Constrain value to acceptable range.
      value = constrain(value, 25, 30);
      // Map the value to the hue
      // 0.2 blue
      // 1.0 red
      value = map(value, 25, 30, 0.2, 1.0);
      pg.pixels[p++] = color(value, 0.9, 1);      
      
    }
  }
  pg.updatePixels();
  
  image(pg, 840, 25);
  pg.endDraw();
  
  popStyle();
  
}

void pieChart(float diameter, int[] data,boolean stop, int ox, int oy) {

  float lastAngle = 4.7;
  float startAngle = lastAngle;

  noStroke();
  for (int i = 0; i < data.length; i++) {
    if (stop == false) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    stop = !stop;
    if(data[i]==0) {
       data[i] = 1;
    }
    arc(ox+560, oy+30, diameter, diameter, lastAngle, lastAngle+radians(data[i]));

    lastAngle += radians(data[i]);
  }
}

void drawSummary(int curtrkColor) {
  textSize(28);
  //color trkColor = color( (i%3)* 255, ((i+1)%3) * 255, ((i+2)%3) * 255 );
  fill(255); 
  text("Track #", text_oX, text_oY);
  fill(curtrkColor); 
  text(curTrk+1, text_oX+190, text_oY);
  fill(255);
  text(" of "+lenght.length, text_oX+300, text_oY); 

  noFill();
  stroke(255);
  rect(text_oX,text_oY+100,390,60);
  
}

void drawMov(int oX, int oY) {
  try {
    
  int total=0;
  int n_stops = 0,n_moves=0;
  for(int i=0;i< tmeta.length;i++) {
    if(tmeta[i][0] == 1 ) {
      n_stops += tmeta[i][2];
    } else {
      n_moves += tmeta[i][2];
    }
    total += tmeta[i][1]; 
  }
  
  fill(255); 
  text("Total time: ", oX, oY+60);
  text(total+" seconds", oX+200, oY+60);

  fill(0, 255, 0);
  text("Move: ", oX, oY+130);
  fill(255); 
  text(n_moves+ " %", oX+100, oY+130);

  fill(255, 0, 0);
  text("Stop: ", oX+200, oY+130);
  fill(255); 
  text(n_stops+ " %", oX+300, oY+130);  
  
  getStopTimes(curTrk,oX,oY);
  
  } catch (Exception e) {}
}

void drawInterface() {

  color curtrkColor = color( (curTrk%3)* 255, ((curTrk+1)%3) * 255, ((curTrk+2)%3) * 255 );

  
  fill(rectHighlight);
  if (rectOver1) {
    fill(rectColor);
  }
  rect(rectX1, rectY1, rectSizeW, rectSizeH);
  
  fill(rectHighlight);  
  if(rectOver2){
    fill(rectColor); 
  }
  rect(rectX2, rectY2, rectSizeW, rectSizeH);
  
  fill(0);  
  textSize(32);
  text("<", rectX1+12, rectY1+27);
  text(">", rectX2+12, rectY2+27);

  // heatmap button
  fill(rectHighlight);  
  if(heatOver){
    fill(rectColor); 
  }
  rect(heatX, heatY, heatW, heatH);
  textSize(28);
  fill(255,255,255);
  text("Heat Map", heatX+10, heatY+27);
  
  
  // normal map button
  fill(norHighlight);  
  if(norOver){
    fill(norColor);
  }
  rect(norX, norY, norW, norH);
  textSize(28);
  fill(255,255,255);
  text("Aggregation", norX+10, norY+27);
}

void draw() {
  update(mouseX, mouseY);
  color curtrkColor = color( (curTrk%3)* 255, ((curTrk+1)%3) * 255, ((curTrk+2)%3) * 255 );
  drawSummary(curtrkColor);
  
  drawInterface();

  int i = curTrk;

  if (i==-1) {
    return;
  }

  //for (int i = 0; i < lenght.length; i++) {

  //color trkColor = color( (i%3)* 255, ((i+1)%3) * 255, ((i+2)%3) * 255 );

  
  if (i != -2 && count[i]<lenght[i] && !showHeatMap) {
    
    try {
      float xes = x_coord[i][count[i]]*Okx+trx;
      float yes = y_coord[i][count[i]]*Ok;
      // oX+ (x*Ok)
  
      stroke(speed[i][count[i]]*255,40*speed[i][count[i]],0);
      fill(speed[i][count[i]]*255,40*speed[i][count[i]],0);
      if (count[i]<lenght[i]-1) 
        line(oX+xes, oY-yes, oX+(x_coord[i][count[i]+1]*Okx+trx), oY-(y_coord[i][count[i]+1]*Ok));

      //println("color i,count[i] : ",speed[i][count[i]]," , i=",i," , count[i]= ",count[i]);      
      noStroke();
      ellipse(oX+xes, oY-yes, 10, 10);

      count[i]++;
    } 
    catch (Exception e) {
    };
  } 
  
  if(showHeatMap == true) {
    applyColor();
  }
  delay(50);
  //}




  textSize(28);
  
  drawMov(text_oX+10,text_oY+80 );
  
  
} 
int holdingAgg = 0;
void drawIndices() {
 
  int items[] = { 0,0,0,0,0,0,0 };
  // items panel //<>//
  noFill();
  int panelX = 20, panelY = 400;
  
  //rect(panelX, panelY, 800, 470);
  noStroke();
  
    
  int k=0;
 for(int i=0;i<tmeta.length;i++) {
   k = (int) tmeta[i][3]-1;
   if(k==-1) continue;
   
   //println("k:= ",k);
   items[k] = (int)tmeta[i][2];
     
   itemsx[k] = tmeta[i][4];
   itemsy[k] = tmeta[i][5];
 }
 
 
  //holdingAgg = 0;
  
  for(int l=0;l<items.length;l++)
  {    
    // in table
    
    fill(0,40,200);
    rect(panelX+4, panelY+6+((l+1)*75), 700, 65);
    
    fill(255);
    ellipse(panelX+40, panelY+36+((l+1)*75), 50, 50);
    fill(100);
    text(l+1,panelX+32,panelY+45+((l+1)*75));
    
    fill(255);
    float holding_power = items[l];
    if(agg == true) {
    
      text(itemsAgg[l][1],panelX+320,panelY+45+((l+1)*75));
      text(itemsAgg[l][2],panelX+120,panelY+45+((l+1)*75));
    } else {
      
      text(holding_power,panelX+320,panelY+45+((l+1)*75));
      if(holding_power>0) {
        text("100",panelX+ 150,panelY+45+((l+1)*75));
      } else {
        text("0",panelX+150,panelY+45+((l+1)*75));
      }
      
    }
    
    text("20",panelX+600,panelY+45+((l+1)*75));
   
    if(itemsx[l]==0 && itemsy[l]==0) continue;
    
    
    if(agg == true) {
      println("dfghjklkjkhg " ,itemsAgg[l][1]*5);
      fill(255,0,0, 70);
      ellipse(oX+ (itemsx[l]*Okx)+trx, oY- (itemsy[l]*Ok), (int)itemsAgg[l][1]*2, (int)itemsAgg[l][1]*2);
      fill(255,255,0, 120);
      ellipse(oX+ (itemsx[l]*Okx)+trx, oY- (itemsy[l]*Ok), (int)itemsAgg[l][2]*5, (int)itemsAgg[l][2]*5);
    } else {
      fill(255,255,0, 120);
      ellipse(oX+ (itemsx[l]*Okx)+trx, oY- (itemsy[l]*Ok), holding_power, holding_power);
    }

  }
  
  int attx = 150, holdy = panelY+10, holdw=60, holdh=60;
  int holdx = 350, atty = panelY+10, attw=holdw, atth=holdh;
  int enjx = 600, enjy = panelY+10, enjw=holdw, enjh=holdh;
  
  image(attimg, attx, atty, attw, atth);
  image(holdimg, holdx, holdy, holdw, holdh);
  image(enjimg, enjx, enjy, enjw, enjh);
    
    
}


void init1(int noTracks) {

  x_coord=new float[noTracks][];
  y_coord=new float[noTracks][];
  stops=new int[noTracks][];
  h_height=new float[noTracks][];
  timestamps=new String[noTracks][];

  lenght=new int[noTracks];
  h_mid=new float[noTracks];
  angles = new int[noTracks][];
  
  speed = new float[noTracks][];
}

void init2(int i, int no_elements) {

  x_coord[i]=new float[no_elements];
  y_coord[i]=new float[no_elements];
  stops[i]=new int[no_elements];
  h_height[i]=new float[no_elements];
  timestamps[i]=new String[no_elements];
  speed[i] = new float[no_elements];
}

void getStopTimes(int i,int ox, int oy) {
  int k=0;
  try {    
    int counter = tmeta.length;
    //println("counter= ",counter);
    int[] newangles = new int[counter];
    
    for (k=0; k<counter; k++) {
      //println("k= ",k);
      newangles[k] = (int) (tmeta[k][2] * 3.6) ;
    }
  
    //println(" newangles ----- ", newangles[0]);
    //println(" newangles ----- ", newangles[1]);
    //println(" newangles ----- ", newangles[2]);
    //println(" newangles size----- ", newangles.length);
  
    boolean is_stop = false;
    if(tmeta[1][0] == 1) {
      is_stop = true;
    }
    pieChart(250, newangles,is_stop,ox,oy);
  } catch (Exception e){}
}

void loadMetadata(String trk){
  try {
  meta = loadJSONObject(metadata);  
  JSONObject s = meta.getJSONObject("tracks");
  
  println("  ppppaream: ",trk);
  JSONArray track = s.getJSONArray(trk);  
  tmeta = new float[track.size()][6];
  
  for (int i = 0; i < track.size(); i++) {
     try {
       tmeta[i][0] = track.getJSONObject(i).getInt("stop");
       tmeta[i][1] = track.getJSONObject(i).getInt("duration");
       tmeta[i][2] = track.getJSONObject(i).getInt("percentage");
       tmeta[i][3] = track.getJSONObject(i).getInt("item");
       tmeta[i][4] = track.getJSONObject(i).getFloat("item_x");
       tmeta[i][5] = track.getJSONObject(i).getFloat("item_y");
       
     } catch (Exception e){
     }
     
  }
  
   //<>//
  
  

  //println("ads--------- tmetaaaaa  "+ itemsAgg[1][0]);
  //println("ads--------- tmetaaaaa  "+itemsAgg[1][1]);
  //println("ads--------- tmetaaaaa  "+itemsAgg[1][2]);
  //println("ads--------- tmetaaaaa  "+tmeta[1][3]);
  //println("ads--------- tmetaaaaa  "+tmeta[1][4]);
  
  
  //println("ads--------- tmetaaaaa  "+tmeta[2][0]);
  //println("ads--------- tmetaaaaa  "+tmeta[2][1]);
  //println("ads--------- tmetaaaaa  "+tmeta[2][2]);
  //println("ads--------- tmetaaaaa  "+tmeta[2][3]);
  //println("ads--------- tmetaaaaa  "+tmeta[2][4]);
  
 } catch (Exception e){}
}

void loadData() {
  
  json = loadJSONObject(filename);
  int noTracks = json.size();
  tracks = new JSONArray[noTracks];
  count=new int[noTracks];
  JSONObject o = (JSONObject) json;
  init1(noTracks);
  Set keyset = o.keys();
  Iterator<String> keys = keyset.iterator();
  int j = 0;
  for (int k=1;k<o.size() ;k++) 
  {
    try 
    {
      //String key = (String)keys.next();
      String key = "t0"+k;
      //println("key = ",key);
      
      tracks[j] = o.getJSONArray(key);      
      lenght[j]=tracks[j].size();
      init2(j, lenght[j]);
      for (int i = 0; i < lenght[j]; i++) {
        moment = tracks[j].getJSONObject(i);
        // fist and last time stamps
        
        
        
        if ((i==0) & (j==0)) start_time=moment.getString("time").substring(0, 11);                 
        if ((i==lenght[j]-1) & (j==0)) end_time=moment.getString("time").substring(0, 11);
        
        //println("moment x: ",moment.getFloat("x"));
        float x=moment.getFloat("x");       
        
        float y=moment.getFloat("y");
        timestamps[j][i]=moment.getString("time").substring(0, 11);
        h=h+h_height[j][i];                                           
        x_coord[j][i]=x;                                            
        y_coord[j][i]=y;  
        try {
          stops[j][i] = moment.getInt("stop");
          
        } 
        catch(Exception e) {
        }
        speed[j][i] = moment.getFloat("speed");
      }
      h_mid[j]=h/lenght[j]; 
      h=0;                                      
      j++;
    } catch (Exception e) {}
  }
  
  
  JSONArray aggstats = loadJSONArray(metastats);
  
  itemsAgg = new float[aggstats.size()][3];
  
  
  
  for(int i=0;i<aggstats.size();i++) {
    int itemIndex = aggstats.getJSONObject(i).getInt("item");
    float holding = aggstats.getJSONObject(i).getInt("holding");
    float attention = aggstats.getJSONObject(i).getInt("attention");
    
    itemsAgg[i][0] = itemIndex;
    itemsAgg[i][1] = holding;
    itemsAgg[i][2] = attention;    
  }
  
    
  
  //for (int i = 0; i < aggitems.size(); i++) {
  //  try {
  //    println("aggitems.getJSONObject(i).getInt(item)=",aggitems.getJSONObject(i).getInt("item"));
  //    itemsAgg[i][0] = aggitems.getJSONObject(i).getInt("item");
  //    itemsAgg[i][1] = aggitems.getJSONObject(i).getInt("holding");
  //    itemsAgg[i][2] = aggitems.getJSONObject(i).getInt("attention");      
  //  } catch (Exception e){}
  //}
  
}


void update(int x, int y) {
  if ( overRect(rectX1, rectY1, rectSizeW, rectSizeH) ) {
    rectOver1 = true;
  } else {
    rectOver1 = false;
  }

  if ( overRect(rectX2, rectY2, rectSizeW, rectSizeH) ) {
    rectOver2 = true;
  } else {
    rectOver2 = false;
  }
  
  if ( overRect(heatX, heatY, heatW, heatH) ) {
    heatOver = true;
  } else {
    heatOver = false;
  }
  
  if ( overRect(norX, norY, norW, norH) ) {
    norOver = true;
  } else {
    norOver = false;
  }
}


boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  boolean doreset = false;
  if (rectOver1) {
    currentColor = rectColor;
    doreset = true;
    curTrk = curTrk-1;
  }
  if (rectOver2) {
    currentColor = rectColor;
    doreset = true;
    curTrk = curTrk+1;
  }
  if (curTrk<0) {
    curTrk = lenght.length-1;
  } 
  if (curTrk >= lenght.length) {
    curTrk = 0;
  }
  

   if (heatOver) {
     showHeatMap = false;
     doreset = true;
     agg = false;
   }
   
   if (norOver) {
     showHeatMap = false;
     agg = true;
     doreset = true;
     curTrk = -2;
   }
  
  if(doreset == true) {
    reset();
  }
  //drawIndices();
}