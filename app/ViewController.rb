class ViewController < UIViewController
  PUlL_UP_VIEW_HEIGHT   = 400
  PULL_DOWN_VIEW_HEIGHT = 300
  
  def viewDidLoad
    super
    
    self.view.backgroundColor = UIColor.whiteColor
    
    @pullable = true
    
    xOffset = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 224 : 0
    
    @pull_up_view = StyledPullableView.alloc.initWithFrame(CGRectMake(xOffset, 0, 320, PUlL_UP_VIEW_HEIGHT)).tap do |view|
      view.opened_center     = CGPointMake(160 + xOffset, (self.view.frame.size.height - PUlL_UP_VIEW_HEIGHT / 2))
      view.closed_center     = CGPointMake(160 + xOffset, self.view.frame.size.height + PUlL_UP_VIEW_HEIGHT / 2 - 30)
      view.center            = view.closed_center
      view.handle_view.frame = CGRectMake(0, 0, 320, 40)
      view.should_receive_touch { @pullable }
      view.on_change_state do |opened|
        @pull_up_label.text = opened ? "Now I'm open!" : "Now I'm closed, pull me up again!"
      end
      self.view.addSubview(view)
    end
    
    @pull_up_label = UILabel.alloc.initWithFrame(CGRectMake(0, 4, 320, 20)).tap do |label|
      label.textAlignment   = UITextAlignmentCenter
      label.backgroundColor = UIColor.clearColor
      label.textColor       = UIColor.lightGrayColor
      label.text            = "Pull me up!"
      @pull_up_view.addSubview(label)
    end
    
    @pull_up_static_label = UILabel.alloc.initWithFrame(CGRectMake(0, 80, 320, 64)).tap do |label|
      label.textAlignment   = UITextAlignmentCenter
      label.backgroundColor = UIColor.clearColor
      label.textColor       = UIColor.whiteColor
      label.shadowColor     = UIColor.blackColor
      label.shadowOffset    = CGSizeMake(1, 1)
      label.text            = "I only go half-way up!"
      @pull_up_view.addSubview(label)
    end
    
    @pull_down_view = StyledPullableView.alloc.initWithFrame(CGRectMake(xOffset, 0, 320, PULL_DOWN_VIEW_HEIGHT)).tap do |view|
      view.opened_center = CGPointMake(160 + xOffset, PULL_DOWN_VIEW_HEIGHT / 2)
      view.closed_center = CGPointMake(160 + xOffset, - PULL_DOWN_VIEW_HEIGHT / 2 + 30)
      view.center        = view.closed_center
      view.should_receive_touch { @pullable }
      view.on_change_state do |opened|
        @pull_up_label.text = opened ? "Now I'm open!" : "Now I'm closed, pull me up again!"
      end
      self.view.addSubview(view)
    end
    
    @pull_down_static_label = UILabel.alloc.initWithFrame(CGRectMake(0, 200, 320, 64)).tap do |label|
      label.textAlignment   = UITextAlignmentCenter
      label.backgroundColor = UIColor.clearColor
      label.textColor       = UIColor.whiteColor
      label.shadowColor     = UIColor.blackColor
      label.shadowOffset    = CGSizeMake(1, 1)
      label.text            = "Look at this beautiful linen texture!"
      @pull_down_view.addSubview(label)
    end
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    UIInterfaceOrientationIsPortrait(interfaceOrientation)
  end
end