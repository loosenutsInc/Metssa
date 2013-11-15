//Loading libraries...
import g4p_controls.*;
import controlP5.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import processing.video.*;

ControlP5 cp5;
PFont font;
Time time;                          //Create an instance of class Time...
Player player;                      //Create an instance of class Player...
Minim minim;                        
AudioPlayer player1;
AudioPlayer player2;
Movie movie;
ExtraWindow ew1;

GImageButton music1, music2, music3, music4, music5, music6, //Music selection
             video1, video2, video3, video4, video5, video6, //Video selection
             music_mode, video_mode, //Select mode  
             play, stop_play;

GCheckbox cbx1, cbx2, cbx3, cbx4, cbx5, cbx6, cbx7, cbx8, cbx9; 
GCustomSlider music, noise, musicvol, noisevol;

//Knobs for volume. Using controlP5 knob
Knob music_volume;
Knob noise_volume;

//Knob to set interval
Knob knob_interval;

String[] files;

String selected_music;              //The music selected...
String video_to_play;               //The video file selected...
int selected_disturbance;           //The selected disturbance from multiple user selections...
boolean selected_change;            //Checks whether a selection occured or not....
boolean video_loaded;               //Set when video is ready to play in the player...
int[] cbx=new int[9];               //Check box value stores into the array...
int totaltime_to_calculate;         //Total time in minute....
int noise_count;                    //The percentage of time disturbence to be played...
int player1_volume;                 //Select volume for player 1...
int player2_volume;                 //Select volume for player 2...
boolean play_mode;                  //Music only or Video also...
int interval=20;                       //Interval of sampling...
int savedtime;                      //Saving current time for check interval...

boolean playing1,playing2;          //The curresponding player plays if the variable put true...
int window_width,window_height;     //Check window width and window height for set video play window size...
String work_assigned1, work_assigned2;  //Set the variables as 'play' when player is need to play...

void setup()
{
  //Set size
  size(610, 680);    
  
  //Select font
  font=loadFont("BerlinSansFB-Bold-48.vlw");
  textFont(font, 16);
  
  time = new Time();
  minim=new Minim(this);
  player=new Player();
  
  //Music and Video selection Image Buttons
  files = new String[] { 
    "music1.png", "music1.png", "music1.png"
  };
  music1=new GImageButton(this, 30, 40, files);

  files = new String[] { 
    "music2.png", "music2.png", "music2.png"
  };
  music2=new GImageButton(this, 110, 40, files);
  files = new String[] { 
    "music3.png", "music3.png", "music3.png"
  };
  music3=new GImageButton(this, 190, 40, files);

  files = new String[] { 
    "music4.png", "music4.png", "music4.png"
  };
  music4=new GImageButton(this, 30, 120, files);

  files = new String[] { 
    "music5.png", "music5.png", "music5.png"
  };
  music5=new GImageButton(this, 110, 120, files);

  files = new String[] { 
    "music6.png", "music6.png", "music6.png"
  };
  music6=new GImageButton(this, 190, 120, files);

  files = new String[] { 
    "video1.png", "video1.png", "video1.png"
  };
  video1=new GImageButton(this, 350, 40, files);

  files = new String[] { 
    "video2.png", "video2.png", "video2.png"
  };
  video2=new GImageButton(this, 430, 40, files);

  files = new String[] { 
    "video3.png", "video3.png", "video3.png"
  };
  video3=new GImageButton(this, 510, 40, files);

  files = new String[] { 
    "video4.png", "video4.png", "video4.png"
  };
  video4=new GImageButton(this, 350, 120, files);

  files = new String[] { 
    "video5.png", "video5.png", "video5.png"
  };
  video5=new GImageButton(this, 430, 120, files);

  files = new String[] { 
    "video6.png", "video6.png", "video6.png"
  };
  video6=new GImageButton(this, 510, 120, files);

  //Disturbence selection Check boxs

    cbx1= new GCheckbox(this, 30, 230, 100, 15, "Vehicle Horn");
  cbx2= new GCheckbox(this, 240, 230, 100, 15, "Crackers");
  cbx3= new GCheckbox(this, 450, 230, 100, 15, "Sneezing");
  cbx4= new GCheckbox(this, 30, 250, 100, 15, "Coughing");
  cbx5= new GCheckbox(this, 240, 250, 150, 15, "Crying Baby");
  cbx6= new GCheckbox(this, 450, 250, 150, 15, "Ballon Bursting");
  cbx7= new GCheckbox(this, 30, 270, 170, 15, "Lighting and Thunder");
  cbx8= new GCheckbox(this, 240, 270, 150, 15, "Nadhaswaram");
  cbx9= new GCheckbox(this, 450, 270, 150, 15, "Barking");

  //Time selection slider....

  music = new GCustomSlider(this, 200, 322, 250, 50, "blue18px");
  music.setShowDecor(false, true, true, false);
  music.setNbrTicks(16);
  music.setEasing(2);
  music.setLimits(10, 10, 60);

  //Slider for noise count.............
  noise = new GCustomSlider(this, 200, 352, 250, 50, null);
  noise.setShowDecor(false, false, true, false);
  noise.setLimits(30, 0, 100);

  //Knob for sound controls
  cp5 = new ControlP5(this);

  music_volume =  cp5.addKnob("music_volume")
    .setRange(0, 100)
      .setValue(50)
        .setPosition(200, 395)
          .setRadius(60)
            .setCaptionLabel("")
              .setDragDirection(Knob.HORIZONTAL)
                ;

  noise_volume =  cp5.addKnob("noise_volume")
    .setRange(0, 100)
      .setValue(30)
        .setPosition(330, 395)
          .setRadius(60)
            .setCaptionLabel("")
              .setDragDirection(Knob.HORIZONTAL)
                ;

  // Knob for set interval....

  knob_interval = cp5.addKnob("interval")
    .setRange(20, 60)
      .setValue(20)
        .setPosition(270, 560)
          .setRadius(40)
            .setCaptionLabel("")
              .setNumberOfTickMarks(4)
                .snapToTickMarks(true)
                  .setDragDirection(Knob.HORIZONTAL)
                    ;

  // Image button for select play mode...

  files = new String[] { 
    "music_mode.png", "music_mode.png", "music_mode.png"
  };
  music_mode=new GImageButton(this, 30, 570, files);

  files = new String[] { 
    "video_mode.png", "video_mode.png", "video_mode.png"
  };
  video_mode=new GImageButton(this, 110, 570, files);

  files = new String[] { 
    "player_play.png", "player_play.png", "player_play.png"
  };
  play=new GImageButton(this, 430, 570, files);

  files = new String[] { 
    "player_stop.png", "player_stop.png", "player_stop.png"
  };
  stop_play=new GImageButton(this, 510, 570, files);
}


//functions from the interface

// Functions from image buttons...

public void handleButtonEvents(GImageButton button, GEvent event)
{
  if (button==music1)
  {
    selected_music="music1.mp3";
    selected_change=true;
  }

  if (button==music2)
  {
    selected_music="music2.mp3";
    selected_change=true;
  }

  if (button==music3)
  {
    selected_music="music3.mp3";
    selected_change=true;
  }

  if (button==music4)
  {
    selected_music="music4.mp3";
    selected_change=true;
  }

  if (button==music5)
  {
    selected_music="music5.mp3";
    selected_change=true;
  }

  if (button==music6)
  {
    selected_music="music6.mp3";
    selected_change=true;
  }

  if (button==video1)
  {
    video_to_play="video1.mov";
  }

  if (button==video2)
  {
    video_to_play="video2.mov";
  }

  if (button==video3)
  {
    video_to_play="video3.mov";
  }

  if (button==video4)
  {
    video_to_play="video4.mov";
  }

  if (button==video5)
  {
    video_to_play="video5.mov";
  }

  if (button==video6)
  {
    video_to_play="video6.mov";
  }
  
  //Select playing mode. Whether music only or View video with music...
  
  if(button==music_mode)
  {
    play_mode=false;
  }
  
  if(button==video_mode)
  {
    play_mode=true;
  }
  
  if(button==play)
  {
    for (int j=0;j<8;j++)                         //for() loop takes the count of selected disturbence and stores the indexes of selected disturbences..
    {
      if (cbx[j]==1)
      {
        selected_disturbance++;
      }
    }
    if (selected_disturbance>0)
    {
      work_assigned1="play";
      work_assigned2="play";
    }
    else
    {
      //G4P.showMessage(this, "Error: No disturbance selected", "Inform...", G4P.INFO);
      println("Error: No disturbance selected");
    }
  }
  
  if(button==stop_play)
  {
    selected_change=false;
    playing1=false;
    playing2=false;
    player1.close();
    player2.close();
    minim.stop();
    super.stop();
  }
  
  totaltime_to_calculate=parseInt(music.getValueS());
}

// Check the inputs of check box for disturbence selection.....

void handleToggleControlEvents(GToggleControl option, GEvent event)
{
  if (option == cbx1)
  {
    if (option.isSelected())
    {
      cbx[0]=1;
    }
    else
    {
      cbx[0]=0;
    }
  }
  else if (option == cbx2)
  {
    if (option.isSelected())
    {
      cbx[1]=1;
    }
    else
    {
      cbx[1]=0;
    }
  }
  else if (option == cbx3)
  {
    if (option.isSelected())
    {
      cbx[2]=1;
    }
    else
    {
      cbx[2]=0;
    }
  }
  else if (option == cbx4)
  {
    if (option.isSelected())
    {
      cbx[3]=1;
    }
    else
    {
      cbx[3]=0;
    }
  }
  else if (option == cbx5)
  {
    if (option.isSelected())
    {
      cbx[4]=1;
    }
    else
    {
      cbx[4]=0;
    }
  }
  else if (option == cbx6)
  {
    if (option.isSelected())
    {
      cbx[5]=1;
    }
    else
    {
      cbx[5]=0;
    }
  }
  else if (option == cbx7)
  {
    if (option.isSelected())
    {
      cbx[6]=1;
    }
    else
    {
      cbx[6]=0;
    }
  }
  else if (option == cbx8)
  {
    if (option.isSelected())
    {
      cbx[7]=1;
    }
    else
    {
      cbx[7]=0;
    }
  }
  else if (option == cbx9)
  {
    if (option.isSelected())
    {
      cbx[8]=1;
    }
    else
    {
      cbx[8]=0;
    }
  }
//  println(cbx);
}

// Get slider values.......

void handleSliderEvents(GValueControl slider, GEvent event)
{
  if (slider == music)
  {
    totaltime_to_calculate=parseInt(music.getValueS());
    //on changing total time also the noise count may change as per the values
    player.on_slidermove_noise();
  }
  
  if(slider == noise)
  {
    noise_count=parseInt(noise.getValueS());
//    println("noise_count" + noise_count);
    //on moving slider noise,wanna calculate the total count to be tested...
    player.on_slidermove_noise();
  }
}

//Get volumes from the knobs...

void music_volume(int e)
{
  player1_volume=e;
  if(player1!=null)
  {
    player.calculate_music_volume();
  }
}

void noise_volume(int e)
{
  player2_volume=e;
  if(player2!=null)
  {
    player.calculate_noise_volume();
   }
}

//Count interval...
void interval(int e)
{
  interval=e;
}

void draw()
{
  if(video_loaded)
  {
    ew1.image(movie,0,0,window_width,window_height);
    video_loaded=false;
  }
  background(205,205,205);
  fill(0,0,0);
  text("Select Music", 30, 30);
  text("Select Video", 490, 30);
  text("Select Disturbence", 30, 220);
  text("Time", 30, 350);
  text("Count", 30, 380);
  text("Interval", 281, 660);
  text("Main Volume", 210, 535);
  text("Noise Volume", 340, 535);
  text("Play Mode", 60, 660);
  text("Play", 450, 660);
  text("Stop", 528, 660);
  
  if (work_assigned1=="play")
  {
    work_assigned1="";
    player.player1_play();
     
      
    if(play_mode)
    {
      if(video_to_play==null)
      {
        //G4P.showMessage(this, "Error: No video selected", "Inform...", G4P.INFO);
        println("No video selected");
      }
      else
      {
        play_mode=false;
        movie=new Movie(this, video_to_play);
        movie.loop();
        ew1 = new ExtraWindow(this,"Soft song is good for mind.",0,0,parseInt(displayWidth),parseInt(displayHeight*0.90));
        ew1.setResizeable(true);
      }
    }
  }
  if (work_assigned2=="play")
  {
    time.setinterval(interval);          //Setting interval......
    if (time.skip(interval))      //Skip upto interval time............
    {
      time.checkonsample(noise_count);      //check possibility on sampled time.........
    }
  }
}

void movieEvent(Movie m) 
{
  m.read();
  video_loaded=true;
}

void stop()
{
  player1.close();
  player2.close();
  minim.stop();
  super.stop();
}

