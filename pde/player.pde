class Player
{
  Player()
  {
  }
  //Play first player(player playing mp3)...
  
  void player1_play()
  {
    if(selected_change)                //If a mp3 file selected for playing...
    {
      selected_change=false;           
      if(playing1)                     //If music mp3 is playing, we need to stop it before loading another...
      {
        
        player1.close();
        minim.stop();
      }
      player1=minim.loadFile(selected_music);
      player1.play();
      calculate_music_volume();
      player1.loop();
      playing1=true;
    }
  }
  
  //Function for selecting the disturbence to play...........
  void select_disturbence()                      //to select a disturbence randomnly from selected...
  {
    int count=0;                                 //count used to count the no of selected disturbences.
    int selection;                               //selection is a random value that shows the position of selected count to play as disturbence.
    int[] cbx_selected= new int [8];             //cbx_selected will keep the indexes of selected disturbences.
    for(int j=0;j<8;j++)                         //for() loop takes the count of selected disturbence and stores the indexes of selected disturbences..
    {
      if(cbx[j]==1)
      {
        cbx_selected[count]=j;
        count++;
      }
    }
    selected_disturbance=count;
    
    //println(cbx_selected);
    float ran_noise=random(-1,count-1);            //select a count randomnly.
    ran_noise=ran_noise + 0.5;
    selection=parseInt(ran_noise);
    //println("Random count =" + ran_noise + "    " + selection);
    //println(cbx_selected[selection]);            //cbx_selected[selection]) Focus the selected random value..
    String filename=cbx_selected[selection]+".mp3";
    
    //Playing disturbance player..............
    
     if(playing2)
     {
       player2.close();
       minim.stop();
     }
     //println(filename);
     player2=minim.loadFile(filename);
     player2.play();
     player.calculate_noise_volume();
     playing2=true;
  }
  
  //Calculate noise count to play....
  void on_slidermove_noise()
  {
    float time;
    float count;
    time=parseFloat(music.getValueS());
    time=time*(60/interval);
    count=parseFloat(noise.getValueS());
    count=(time*count)/100;
    noise_count=parseInt(count+.5);
    //println("Noise count is "+ noise_count);
  }
  
  //Calculating player1 volume...
  
  void calculate_music_volume()
  {
    float vol=parseFloat(player1_volume);
    //player1.printControls();
//    if(player1.hasControl(Controller.GAIN))
//    {
      float volume_gain=-80+((86*vol)/100);
      player1.setGain(volume_gain);
//    }
//    else if(player1.hasControl(Controller.VOLUME))
//    {
//      float volume=((65536*vol)/100);
//      player1.setVolume(volume);
//    }
//    else
//    {
//      println("Error with sound. Please restart your program to fix this problem.");
//    }
  }
  
  //Calculate noise player volume....
  void calculate_noise_volume()
  {
    float vol=parseFloat(player2_volume);
//    if(player2.hasControl(Controller.GAIN))
//    {
      float volume_gain=-80+((86*vol)/100);
      player2.setGain(volume_gain);
//    }
//    else if(player2.hasControl(Controller.VOLUME))
//    {
//      float volume=((65536*vol)/100);
//      player2.setVolume(volume);
//    }
//    else
//    {
//      println("Error with sound. Please restart your program to fix this problem.");
//    }
  }
}

