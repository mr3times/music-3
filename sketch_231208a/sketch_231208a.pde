import java.io.*; //Pure Java Library
//
//Library: use Sketch / Import Library / Minim
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
//
//Global Variables
File musicFolder, soundEffectFolder; //Class for java.io.* library
Minim minim; //creates object to access all functions
int numberOfSongs = 1, numberOfSoundEffects = 1; //Placeholder Only, reexecute lines after fileCount Known
int currentSong=0; //Variable is rewritten in setup()
AudioPlayer[] playList = new AudioPlayer[numberOfSongs]; //song is now similar to song1
AudioMetaData[] playListMetaData = new AudioMetaData[numberOfSongs]; //same as above
AudioPlayer[] soundEffects = new AudioPlayer[numberOfSoundEffects]; //song is now similar to song1PFont generalFont;
color purple = #2C08FF;
PFont generalFont;
Boolean stopBoolean=false, pauseBoolean=false, changeState=false;
//
void setup() {
  //size() or fullScreen()
  //Display Algorithm
  minim = new Minim(this); //load from data directory, loadFile should also load from project folder, like loadImage
  //Music File Load
  String relativeMusicPathway = "MusicUsed/"; //Relative Path
  String absoluteMusicPath = sketchPath( relativeMusicPathway ); //Absolute Path
  musicFolder = new File(absoluteMusicPath);
  int musicFileCount = musicFolder.list().length;
  File[] musicFiles = musicFolder.listFiles(); //String of Full Directies
  String[] songFilePathway = new String[musicFileCount];
  for ( int i = 0; i < musicFiles.length; i++ ) {
    songFilePathway[i] = ( musicFiles[i].toString() );
  }
  //Re-execute Playlist Population, similar to DIV Population
  numberOfSongs = musicFileCount; //Placeholder Only, reexecute lines after fileCount Known
  playList = new AudioPlayer[numberOfSongs]; //song is now similar to song1
  printArray(playList);
  playListMetaData = new AudioMetaData[numberOfSongs]; //same as above
  for ( int i=0; i<musicFileCount; i++ ) {
    printArray(playList);
    playList[i]= minim.loadFile( songFilePathway[i] );
    playListMetaData[i] = playList[i].getMetaData();
  } //End Music Load
  //
  //Sound Effects Load
 
 

  generalFont = createFont ("Harrington", 55); //Must also Tools / Create Font / Find Font / Do Not Press "OK"
  //

  currentSong = int ( random(0, numberOfSongs-1) );
  //println("Random Start", currentSong);
  //
  playList[currentSong].play();
} //End setup
//
void draw() {

  //if ( playList[currentSong].isLooping() && playList[currentSong].loopCount()!=-1 ) println("There are", playList[currentSong].loopCount(), "loops left.");
  //if ( playList[currentSong].isLooping() && playList[currentSong].loopCount()==-1 ) println("Looping Infinitely");
  //if ( playList[currentSong].isPlaying() && !playList[currentSong].isLooping() ) println("Play Once");
  //
  //println( "Song Position", song1.position(), "Song Length", song1.length() );
  //
  // songMetaData1.title()
  rect(width*1/4, height*0, width*1/2, height*3/10); //mistake
  fill(purple); //Ink
  textAlign (CENTER, CENTER); //Align X&Y, see Processing.org / Reference
  //Values: [LEFT | CENTER | RIGHT] & [TOP | CENTER | BOTTOM | BASELINE]
  int size = 10; //Change this font size
  textFont(generalFont, size); //Change the number until it fits, largest font size
  text(playListMetaData[currentSong].title(), width*1/4, height*0, width*1/2, height*3/10);
  fill(255); //Reset to white for rest of the program
  //
  //Autoplay, next song automatically plays
  if ( playList[currentSong].isPlaying() ) {
    //println("hereD1", playList[currentSong].isPlaying(), stopBoolean, pauseBoolean, changeState);
    if ( stopBoolean==true || pauseBoolean==true ) {
      //changeState=true;
      playList[currentSong].pause();
      //println("hereD2", playList[currentSong].isPlaying(), stopBoolean, pauseBoolean, changeState);
    }
    if ( stopBoolean==true ) playList[currentSong].rewind();
  } else {
    //println("hereD3", playList[currentSong].isPlaying(), stopBoolean, pauseBoolean, changeState);
    if ( changeState==false ) {
      playList[currentSong].rewind();
      if (currentSong==numberOfSongs-1) {
        currentSong=0;
      } else {
        currentSong = currentSong + 1; //currentSong--; currentSong-=1}
      }
      playList[currentSong].play();
      //println("hereD4", playList[currentSong].isPlaying(), stopBoolean, pauseBoolean, changeState);
    }
    if ( stopBoolean==false && pauseBoolean==false && changeState==true ) {
      playList[currentSong].rewind();
      playList[currentSong].play();
      changeState=false;
      //println("hereD5", playList[currentSong].isPlaying(), stopBoolean, pauseBoolean, changeState);
    }
    if ( pauseBoolean==false && stopBoolean==false  && changeState==true) {
      playList[currentSong].play();
      changeState=false;
      //println("hereD6", playList[currentSong].isPlaying(), stopBoolean, pauseBoolean, changeState);
    }
  }
} //End draw
//
void keyPressed() {
  println ( "herek1", playList[currentSong].isPlaying(), pauseBoolean );
  //
  if ( key=='P' || key=='p' ) {
    changeState=true;
    if ( pauseBoolean==false ) {
      pauseBoolean=true;
      println("herek2", pauseBoolean);
    } else {
      pauseBoolean=false;
      println("herek3", pauseBoolean);
      playList[currentSong].play();
    }
    if (  stopBoolean==true ) {
      stopBoolean=false;
    }
    println ( "herek4", playList[currentSong].isPlaying(), pauseBoolean, stopBoolean, changeState );
  }
  //
  //Simple STOP Behaviour: ask if .playing() & .pause() & .rewind(), or .rewind()
  if ( key=='S' | key=='s' ) {
    changeState=true;
    if ( stopBoolean == false ) {
      stopBoolean = true;
      playList[currentSong].pause(); 
    } else {
      stopBoolean = false;
      playList[currentSong].rewind();
    }
  }
  //Simple NEXT and PREVIOUS
  if ( key==CODED && keyCode==LEFT ) { //Previous
    if ( playList[currentSong].isPlaying() ) {
      playList[currentSong].pause();
      playList[currentSong].rewind();
      if (currentSong==0) {
        currentSong=numberOfSongs-1;
      } else {
        currentSong = currentSong - 1;
      }
    }
    println(currentSong);
    playList[currentSong].play();
  } //End Previous
  if ( key==CODED && keyCode==RIGHT ) { //NEXT
  } //End NEXT
  //
  
   //
   if ( key>='1' || key<='9' ) { 
   String keystr = String.valueOf(key);
   int loopNum = int(keystr); 
   playList[currentSong].loop(loopNum); 
   //
   }
   if ( key=='L' || key=='l' ) playList[currentSong].loop();
   //
   if ( key=='M' || key=='m' ) { //MUTE Button
   if ( playList[currentSong].isMuted() ) {
   
   playList[currentSong].unmute();
   } else {
   playList[currentSong].mute();
   }
   } //End MUTE
   if ( key=='F' || key=='f' ) playList[currentSong].skip( -1000 ); 
   if ( key=='R' || key=='r' ) playList[currentSong].skip( 1000 ); 
   //
   if ( key==' ') {
   if ( playList[currentSong].isPlaying()) {
   playList[currentSong].pause(); 
   } else {
   playList[currentSong].play(); 
   }
   }
   
} //End keyPressed
//
void mousePressed() {
} //End mousePressed
//
//End MAIN Program
