part of UnderSurveillance;

abstract class Person extends Sprite {
  num suspisionLevel = 0.0;
  num maxSuspisionLevel = 0.0;
  num complianceLevel = 100.0;
  num maxComplianceLevel = 100.0;
  int minY = 120;
  int maxX;
  int maxY;
  num xDir;
  num yDir;
  Random random = new Random();
  String Id = "";
  
  bool underCctvSurveillance = false;
  bool underCreditCardSurveillance = false;
  bool underEmailSurveillance = false;
  bool underPhoneSurveillance = false;
  bool underAgentSurveillance = false;
  
  StreamController _selectedController;
  
  Bitmap cctvButton;
  Bitmap creditCardButton;
  Bitmap emailButton;
  Bitmap phoneButton;
  Bitmap agentButton;
  
  Bitmap suspicionBarBackground;
  Bitmap suspicionBar;
 
  Bitmap complianceBarBackground;
  Bitmap complianceBar;
  
  num disabledAlpha = 0.5;
  
  void Init(colour)
  {
    var background = new BitmapData(60, 60, false, colour);
    var backgroundBitmap = new Bitmap(background);
    backgroundBitmap
      ..x = 0
      ..y = 0;
    this.addChild(backgroundBitmap);
    
    this.onMouseClick.listen(OnMouseClick);
    
    // create the buttons
    var buttonOffset = 62;
    
    Mask buttonMask = new Mask.rectangle(0, 0, 10, 10)
      ..border = true
      ..borderColor = Color.Black
      ..borderWidth = 1;
    
    cctvButton = new Bitmap(new BitmapData(10, 10, false, Color.Purple))
      ..x = 0
      ..y = buttonOffset
      ..alpha = disabledAlpha
      ..mask = buttonMask;
    this.addChild(cctvButton);    
    
    creditCardButton = new Bitmap(new BitmapData(10, 10, false, Color.Orange))
      ..x = 12
      ..y = buttonOffset
      ..alpha = disabledAlpha
      ..mask = buttonMask;
    this.addChild(creditCardButton);
    
    emailButton = new Bitmap(new BitmapData(10, 10, false, Color.Blue))
      ..x = 24
      ..y = buttonOffset
      ..alpha = disabledAlpha
      ..mask = buttonMask;
    this.addChild(emailButton);
    
    phoneButton = new Bitmap(new BitmapData(10, 10, false, Color.Yellow))
      ..x = 36
      ..y = buttonOffset
      ..alpha = disabledAlpha
      ..mask = buttonMask;
    this.addChild(phoneButton);    
    
    agentButton = new Bitmap(new BitmapData(10, 10, false, Color.Magenta))
      ..x = 48
      ..y = buttonOffset
      ..alpha = disabledAlpha
      ..mask = buttonMask;
    this.addChild(agentButton);
    
    // create the bars
    Mask barMask = new Mask.rectangle(0, 0, 60, 10)
    ..border = true
    ..borderColor = Color.Black
    ..borderWidth = 1;
    
    complianceBarBackground = new Bitmap(new BitmapData(60, 10, false, Color.LightPink))
      ..x = 0
      ..y = -24
      ..mask = barMask;
    this.addChild(complianceBarBackground);
    
    complianceBar = new Bitmap(new BitmapData(60, 10, false, Color.Green))
      ..x = 0
      ..y = -24;
    this.addChild(complianceBar);
    
    suspicionBarBackground = new Bitmap(new BitmapData(60, 10, false, Color.LightGray))
      ..x = 0
      ..y = -12
      ..mask = barMask;
    this.addChild(suspicionBarBackground);
    
    suspicionBar = new Bitmap(new BitmapData(1, 10, false, Color.Green))
      ..x = 0
      ..y = -12;
    this.addChild(suspicionBar);
    
    var nameLabel = new TextField()
      ..x = 0
      ..y = 10
      ..text = Id;
    this.addChild(nameLabel);
    
    _selectedController = new StreamController.broadcast();
  }
  
  Stream get onSelected => _selectedController.stream;
  
  void OnMouseClick(MouseEvent evt);
  
  void Move()
  {
    x = min(maxX, max(0, x += xDir));
    y = min(maxY, max(minY, y += yDir));
    
    // if the person has reached the boundary, then change direction for the next turn
    if (x == 0 || x == maxX || y == minY || y == maxY)
    {
      SetDirection();
    }
  }
  
  void SetDirection()
  {
    xDir = random.nextDouble() * 0.6;
    yDir = random.nextDouble() * 0.6;
    
    if (random.nextDouble() > 0.5) 
    {
      xDir *= -1;
    }
    
    if (random.nextDouble() > 0.5)
    {
      yDir *= -1;
    }
  }
  
  void Loop() {
    if (random.nextInt(1000) < 5)
    {
      SetDirection();
    }
    
    Move();
  }
  
  void IncrSuspicion(num amt) {
    suspisionLevel = min(maxSuspisionLevel, suspisionLevel + amt);
    suspicionBar.width = suspisionLevel / 100.0 * suspicionBarBackground.width;
  }
  
  void IncrIntrusion(num amt) {
    complianceLevel = max(0.0, complianceLevel - amt);
    complianceBar.width = complianceLevel / maxComplianceLevel * complianceBarBackground.width;
    
    if (complianceLevel < 60.0 && complianceLevel > 30) {
      complianceBar.bitmapData = new BitmapData(40, 10, false, Color.OrangeRed);
    } else if (complianceLevel <= 30.0) {
      complianceBar.bitmapData = new BitmapData(40, 10, false, Color.Red);
    }
  }
  
  void ToggleCctv() {
    this.underCctvSurveillance = !this.underCctvSurveillance;
    if (this.underCctvSurveillance) {
      cctvButton.alpha = 1;
    } else {
      cctvButton.alpha = 0.3;
    }
  }
  
  void ToggleCreditCard() {
    this.underCreditCardSurveillance = !this.underCreditCardSurveillance;
    if (this.underCreditCardSurveillance) {
      creditCardButton.alpha = 1;
    } else {
      creditCardButton.alpha = 0.3;
    }
  }
  
  void ToggleEmail() {
    this.underEmailSurveillance = !this.underEmailSurveillance;
    if (this.underEmailSurveillance) {
      emailButton.alpha = 1;
    } else {
      emailButton.alpha = 0.3;
    }
  }
  
  void TogglePhone() {
    this.underPhoneSurveillance = !this.underPhoneSurveillance;
    if (this.underPhoneSurveillance) {
      phoneButton.alpha = 1;
    } else {
      phoneButton.alpha = 0.3;
    }
  }
  
  void ToggleAgent() {
    this.underAgentSurveillance = !this.underAgentSurveillance;
    if (this.underAgentSurveillance) {
      agentButton.alpha = 1;
    } else {
      agentButton.alpha = 0.3;
    }
  }
}