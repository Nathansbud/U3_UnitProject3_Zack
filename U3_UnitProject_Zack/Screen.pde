class Screen //<>//
{
  private Button[] _options; //Story choices
  private Button _musicSelector; //Music selector
  private Button _inventory; //Inventory button
  private String[] _buttonText; //Button labels
  public int[] _goesTo;  //Button lead to
  private String _title; //Screen title
  private String _text; //Screen body
  private int _tbW, _tbH; //Text Box Width and Height
  private int _textSize;

  public Screen(String title, String text, String[] buttonText, int[] goesTo) //Story screen
  {
    _title = title;
    _text = text;
    _buttonText = buttonText; 
    _tbW = width - width/48;
    _tbH = height - height/3;
    _textSize = 25;
    _goesTo = goesTo;
    _options = new Button[_buttonText.length];
  }

  public Screen(String title, String[] buttonText) //Non-story screen? Menu inherits it, but it's the most half-assed inheritance the world has ever seen. Will remove this later.
  {
    _title = title;
    _buttonText = buttonText; 
    _textSize = 25;
    _options = new Button[_buttonText.length];
  }

  public void Update() //All-around screen update
  {
    background(bgColor); 
    DrawButtons(); //Draws buttons
    UpdateInfo(); //Updates names
    DrawText();
    //int x = _buttonText.length;
    //switch(x)
    //{
    //case 1:
    //  println("Buttons Lead To: " + _goesTo[x - x] + " & Screen Is: " + currentScreen);
    //  break;
    //case 2:  
    //  println("Buttons Lead To: " + _goesTo[x - x] + ", " + _goesTo[x - 1] + " & Screen Is: " + currentScreen);
    //  break;
    //case 3:
    //  println("Buttons Lead To: " + _goesTo[x - x]+ ", " + _goesTo[x - 2] + ", " + _goesTo[x - 1] + " & Screen Is: " + currentScreen + " o " + clothingChoice[2]);
    //  break;
    //default:
    //  println("There Are No Buttons On Screen! Screen: " + currentScreen);
    //  break;
    //}
  }

  private void DrawButtons()
  {
    DrawOptions();
    DrawMusicSelector();
    DrawInventoryButton();
  }

  private void DrawOptions() //Draws buttons, assigns to them the goesTo information & labels from Parse() 
  {
    for (int i = 0; i < _buttonText.length; i++) //Make as many buttons as there are labels for, no more no less; if 2 labels, 2 buttons; if 3 labels, 3 buttons.
    {
      _options[i] = new Button(_buttonText[i], width/2 - _buttonText[i].length(), height - height/3 + (height/18 * i), _goesTo[i], "Story"); //<>//
    }
    for (int i = 0; i < _buttonText.length; i++) //Updates said buttons
    {
      _options[i].Update();
    }
  }

  private void DrawMusicSelector() //Make music selector button
  {
    _musicSelector = new Button(" Music Selector ", float(width - width/12), float(height - height/3), "Music"); 
    _musicSelector.Update();
  }

  private void DrawInventoryButton() //Make sure that button isn't drawn if inventory is empty (and ensure that it can't open on menu as a catch in case I accidentally add an item there?)
  {
    if (inventory.size() > 0 && state != 0)
    {
      _inventory = new Button(" Inventory ", float(width/12), float(height - height/3), "Inventory");
      _inventory.Update();
    }
  }

  private void UpdateInfo() //Name and text-replacement related nonsense. Desperately needs to be organized more effectively. It works for now.
  {
    if (currentScreen < 33 || currentScreen > 37)
    {

      if (currentScreen == 1 && playerName != "" && playerName != " " && keyPressed && key == ENTER) ////Promted to name player. If no player name is set, playerName = Zack
      {
        _text = _text.replaceAll("@PlayerName", playerName);
      }

      if (currentScreen > 1 && playerName != "" && playerName != " ")
      {
        _text = _text.replaceAll("@PlayerName", playerName);
        _text = _text.replaceAll("@PlayerLastName", playerLastName);
        for (int i = 0; i < _buttonText.length; i++) 
        {
          _buttonText[i] = _buttonText[i].replaceAll("@PlayerName", playerName);
        }
      }

      if (currentScreen > 1 && playerName == "") 
      {
        playerName = "Zack";
      }

      if ((currentScreen == 11 || currentScreen == 13) && friendName != "" && playerName != " " && keyPressed && key == ENTER) //Prompted to name friend. If no friend name, friendName = Abhay
      {
        _text = _text.replaceAll("@FriendName", friendName);
      }

      if (currentScreen > 13 && friendName != "" && playerName != " ") //If no friend name is set, friendName = Abhay
      {
        _text = _text.replaceAll("@FriendName", friendName);
        _text = _text.replaceAll("@FriendLastName", friendLastName);
        for (int i = 0; i < _buttonText.length; i++)
        {
          _buttonText[i] = _buttonText[i].replaceAll("@FriendName", friendName);
        }
      } 
      if (currentScreen > 13 && friendName == "") 
      {
        friendName = "Abhay";
      }

      if (currentScreen == 14 && enemyName != "" && playerName != " " && keyPressed && key == ENTER)
      {        
        _text = _text.replaceAll("@EnemyName", enemyName);
      }
      if (currentScreen > 14 && enemyName != "" && enemyName != " ") //If no enemy name is set, enemyName = Ranine...and lackey Janet but she doesn't get to be named, damn it!2
      {
        _text = _text.replaceAll("@EnemyName", enemyName);
        _text = _text.replaceAll("@LackeyName", lackeyName);
        for (int i = 0; i < _buttonText.length; i++)
        {
          _buttonText[i] = _buttonText[i].replaceAll("@EnemyName", enemyName);
          _buttonText[i] = _buttonText[i].replaceAll("@LackeyName", lackeyName);
        }
      } 
      if (currentScreen > 14 && enemyName == "")
      {
        enemyName = "Ranine";
        lackeyName = "Janet";
      }
      _text = _text.replaceAll("@PlayerLockerNumber", playerLockerNumber); //Set locker numbers in text to locker numbers of player/friend (based on random numbers generated)
      _text = _text.replaceAll("@FriendLockerNumber", friendLockerNumber);
      _text = _text.replaceAll("@LockerDif", lockDif); //Set difference to abs(pLN - fLN)
    }
  }
  private void DrawText()
  {
    textSize(_textSize); 
    fill(0);
    textAlign(CENTER);
    text(_title, width/2, height/40);  //Puts title at top center of screen
    textAlign(LEFT);
    text(_text, width/48, height/25, _tbW, _tbH); //Puts body text under title, goes until limits specified by textbox
  }

  public void DrawTitle()
  {
    textSize(_textSize);
    fill(0);
    textAlign(CENTER);
    text(_title, width/2, height/40);  //Puts title at top center of screen
    textAlign(LEFT);
  }
}