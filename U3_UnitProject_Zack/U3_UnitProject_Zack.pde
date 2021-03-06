/* SchoolQuest (Working Title) //<>//

 A choose your own text adventure by Zack.
 
 */

//Import Nonsense//
//<Minim>//
import ddf.minim.*; //Minim starts here...
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*; //...and it ends here.  
//</Minim>//
//<Java>//
import java.lang.Object; //JFileChooser starts here...
import java.awt.Component;
import java.awt.Container;
import java.awt.Window; 
import java.awt.Dialog;
import java.awt.FileDialog;
import javax.swing.JComponent;
import javax.swing.JFileChooser; //...and it ends here. 
import javax.swing.filechooser.FileFilter; //FileNameExtensionFilter starts here...
import javax.swing.filechooser.FileNameExtensionFilter;  //...the end.
import javax.swing.JDialog; //Dialog begins here...
import javax.swing.JButton; 
import javax.swing.JOptionPane;
import java.util.List; //...viola! Dialog over.
//</Java>//

//Variables//
Minim minim = new Minim(this); //Minim Variables, Exhibit A
AudioPlayer selectedSong; //Exhibit B
String songName = null; //Exhibit C
String startingCharacter; //Starting character of "screens" which tells Parse() that a screen is beginning; used as a switch.
String storyline[]; //Array of Text. This makes all the everything work.
String[] playerLastNames = {"Amiton", "Zinner", "Ostomel", "Stevenson"}, friendLastNames = {"Johnson", "Peterson", "Mitchell", "Anderson"};
String friendLastName, playerLastName;
String playerName = "", friendName = "", enemyName = "", lackeyName = "Janet"; //Strings used for player-input names of "characters." These replace the @CharacterName markers used in the textadventure.txt file
ArrayList<Screen> schoolQuestScreens = new ArrayList<Screen>(), voidScreens = new ArrayList<Screen>(); 
boolean schoolQuest, theVoid;
Menu menu;
int currentScreen = 1; //Current screen in the screens ArrayList being shown
int loopCount = 10000;
boolean mouseIsReleased, drawScreen, songSelected; //Used to trigger button presses
boolean clothingChoice[] = new boolean[3], lockersRule, lockerLocked; //"Choices" player has made
boolean giveComputer, giveRobot; //Inventory (SchoolQuest)
boolean giveMap; //Inventory (Void)
int state = 0; //Menu State (0 is Menu, 1 is SchoolQuest, 2 is Void, 3 is Quit)
int gameState; //Current "Game State" on Screen 44; player's choice of game to play
int lockerNumbers[] = new int[2];
String lockDif;
int bgColor = 255;
String playerLockerNumber, friendLockerNumber;
ArrayList<String> inventoryMaster = new ArrayList<String>();
ArrayList<String> inventory = new ArrayList<String>();

//Aaaaaand begin!

void setup()
{
  fullScreen();
  playerLastName = playerLastNames[(int)random(0, 4)]; //Player has a random last name
  friendLastName = friendLastNames[(int)random(0, 4)]; //...so does friend
  lockerNumbers[0] = (int)random(100); //Give random locker number
  playerLockerNumber = String.valueOf(lockerNumbers[0]);
  lockerNumbers[1] = (int)random(100);
  friendLockerNumber = String.valueOf(lockerNumbers[1]);
  if (friendLockerNumber == playerLockerNumber) //Ensure that fLN & pLN don't equal one another, because, like, they're lockers?
  {
    playerLockerNumber = String.valueOf(109); //109 109 109 109 109
  }
  drawScreen = true;
  storyline = loadStrings("SchoolQuest.zk");
  Parse();
  int lockDifInt = abs(lockerNumbers[0] - lockerNumbers[1]);
  if (lockDifInt < 20) //Trigger boolean, which affects a screen; if lockersRule player & friend won't split up, else they will.
  {
    lockersRule = true;
  }
  lockDif = String.valueOf(lockDifInt);
}

void draw()
{
  println(inventory + ", Current Screen is " + currentScreen);
  CheckBooleans(); 
  if (songSelected)
  {
    PlayMusic(); 
    songSelected = false;
  }
  switch(state) //Various menu states
  {
  case 0: //Menu
    menu = new Menu("\n\n\n\n\n\n\nChoose a Text Adventure", menuButtons);
    menu.UpdateMenu();
    currentScreen = 1;
    playerName = ""; //Not currently working as intended
    friendName = "";
    enemyName = "";
    lackeyName = ""; //^^^^
    schoolQuest = false;
    theVoid = false;
    inventory.clear();
    break;
  case 1:  //SchoolQuest
    schoolQuest = true;
    if (schoolQuestScreens.size() > 0) //Once screens are loaded in, draw them (the first is 1, and currentScreen is initially set to that value)
    {
      if (drawScreen)
      {
        schoolQuest = true;
        schoolQuestScreens.get(currentScreen).Update();
      } else
      {
        exit(); //If quit button pressed, quit.
      }
    }
    break;
  case 2: //Void //<>//
    theVoid = true;
    if (voidScreens.size() > 0) //Once screens are loaded in, draw them (the first is 1, and currentScreen is initially set to that value)
    {
      if (drawScreen)
      {
        voidScreens.get(currentScreen).Update();
      } else
      {
        exit(); //If quit button pressed, quit.
      }
    }
    break;
  case 3: //Quit
    exit();
  }

  if (currentScreen == 0) //Quit if screen = 0
  {
    drawScreen = false;
  }

  mouseIsReleased = false; //mouseIsReleased is continually set to false so that the releasing of mouse is only registered for one frame, else would trigger buttons at any time
}

void keyPressed() //Replaces all @CharacterNames with player-inputted ones. However, not fully finished yet (drawing-wise, doesn't prevent player from not naming characters)
{ 
  switch(currentScreen)
  {
  case 1:
    if (key == BACKSPACE)
    {
      if (playerName.length() > 0)
      {
        playerName = playerName.substring(0, playerName.length() - 1);
      }
    } else
      if (key != CODED && key != ENTER && playerName.length() <= 10)
      {
        playerName = playerName + key;
      }
    break;
  case 11:
  case 13:
    if (key == BACKSPACE)
    {
      if (friendName.length() > 0)
      {
        friendName = friendName.substring(0, friendName.length() - 1);
      }
    } else
      if (key != CODED && key != ENTER && friendName.length() <= 10)
      {
        friendName = friendName + key;
      }
    break;
  case 14:
    if (key == BACKSPACE)
    {
      if (enemyName.length() > 0)
      {
        enemyName = enemyName.substring(0, enemyName.length() - 1);
      }
    } else
      if (key != CODED && key != ENTER && enemyName.length() <= 10)
      {
        enemyName = enemyName + key;
      }
    break;
  }


  switch(key) //Tools for easy navigation. Not intended to be present in the final game.
  {
  case TAB:
    currentScreen = 1;
    break;
  }
  switch(keyCode)
  {
  case ALT:
    state = 0;
    break;
  }
}

void Parse() //The real bread and butter of the program
{
  for (int i = 0; i < storyline.length; i++) //So long as all lines have not been read through, keep iterating
  {
    if (storyline[i].equals("=")) //Slightly inefficient, add all possible inventory items to inventoryMaster, then later have inventory grab them out of inventoryMaster as needed.
    {
      i++;        
      while (storyline[i].charAt(0) != '>')
      {
        inventoryMaster.add(storyline[i]);
        i++;
      }
    }

    if (storyline[i].equals("#") || storyline[i].equals("$") ||storyline[i].equals("$ ") || storyline[i].equals("$")) 
    {
      String startingCharacter = storyline[i++]; //Chooses character from ^^^
      String title = storyline[i++]; //This moved-to line is the title of the screen. Record this line and increase i by 1
      String text = ""; //This moved-to line, always after the title, begins the body text of the page. This line can go until...
      while (storyline[i].charAt(0) != '>') //...the carat. Until the first character seen on a line is >, text is increased by each line of the storyline
      {
        text += storyline[i++];
        while (storyline[i].length() == 0) //If it reaches a blank line, instead of crashing (as it would otherwise), replaces that blank line with 2 line breaks (as would be the reason for leaving a blank line in the first place)
        {
          storyline[i] = "\n\n";
        }
      }
      i++;
      String[] buttonText; //The text of each button
      buttonText = split(storyline[i++], ", "); //Everything on currentLine should be put into an array, seperated by commas (there can only be three things)
      int[] goesTo; //Where each  button points to 
      goesTo = int(split(storyline[i], ", ")); //Same deal as buttons

      switch(startingCharacter) //Based on startingCharacter, do whatever.
      {
      case "#":
      case "# ":
        schoolQuestScreens.add(new Screen(title, text, buttonText, goesTo)); //Using all of this data, create new screen, with title at top, text as body, buttonText[] on buttons, and goesTo coming into play when button is clicked
        break;
      case "$":
      case "$ ":
        voidScreens.add(new Screen(title, text, buttonText, goesTo)); //Using all of this data, create new screen, with title at top, text as body, buttonText[] on buttons, and goesTo coming into play when button is clicked
        break;
      }
    }
  }
}


void PlayMusic() //Play a song based on chosen file from music selector.
{
  selectedSong = minim.loadFile(songName);
  selectedSong.loop(loopCount);
}

void mouseReleased()
{
  if (storyline.length > 0)
  {
    mouseIsReleased = true; //True for a frame only, which is enough to check for button presses
  }
}

void CheckBooleans()
{ 
  if (schoolQuest)
  {
    theVoid = false;
    UpdateInventory();
    switch(currentScreen)
    {
    case 1:
      giveComputer = true;
      break;
    case 6:
      clothingChoice[0] = true;
      break;
    case 7: 
      clothingChoice[1] = true;
      giveRobot = true;
      break;
    case 8:
      clothingChoice[2] = true;
      break;
    }

    if (currentScreen == 40 && lockersRule)
    {
      currentScreen = 41;
    }

    //if (clothingChoice[1] == true && currentScreen == 17)
    //{
    //}
    //if (clothingChoice[2] == true && currentScreen == 17)
    //{
    //  currentScreen = 39;
    //}
  }

  if (theVoid)
  {
    schoolQuest = false;
    UpdateInventory();
    switch(currentScreen)
    {
    case 1:
      giveMap = true;
      break;
    }
  }
}

void UpdateInventory()
{
  if (!computerObtained() && giveComputer)
  {
    if (schoolQuest)
    {
      inventory.add(0, inventoryMaster.get(2));
      giveComputer = false;
    }
  }
  if (!robotObtained() && giveRobot)
  {
    if (schoolQuest)
    {
      inventory.add(0, inventoryMaster.get(3));
      giveRobot = false;
    }
  }

  if (!mapObtained() && giveMap)
  {
    if (theVoid)
    {
      inventory.add(0, "Map");
      giveMap = false;
    }
  }
}
boolean computerObtained()
{
  if (inventory.contains(inventoryMaster.get(2)))
    return true;
  else
    return false;
}

boolean robotObtained()
{
  if (inventory.contains(inventoryMaster.get(3)))
    return true;
  else
    return false;
}

boolean mapObtained()
{
  if (inventory.contains("Map"))
    return true; 
  else 
  return false;
}