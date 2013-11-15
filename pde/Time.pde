
class Time
{
  
  Time()
  {
  }
  
  //set interval of time from user input
  void setinterval(int val)
  {
    interval=val;   //here I couldn't work with randon.   (int)random(1,5);
    //println(interval + "seconds passed");
  }
  
  //skip through user input b
  boolean skip(int sec)
  {
    int passedtime=millis()-savedtime;
    if(passedtime>=sec*1000)
    {  
//      println(i);
//      i++;
      savedtime=millis();
      return true;
    }
    else
    {
      return false;
    }
  }
  
  //change time to sec
  int time_to_count(int min)
  {
    
    int return_time=parseInt((min*60)/interval);
    //println(return_time);
    return return_time;
  }
  
  //total times in 1 min is fix as 3. So total time noise can play is 3*min/min.
  //User input the time the noise need to play.
  
  //checking on sample whether it is ok to play or not....
  
  void checkonsample(int chance)
  {
    int totaltime=time.time_to_count(totaltime_to_calculate); 
    //println(chance +" in " +totaltime + " seconds");
    float ran=random(totaltime);
    //println(totaltime);
    //println(i + " " + ran);
    if(ran>.5 && ran<(chance+.5))
    {
      player.select_disturbence();
      //println("OK");
    }
  }
}


