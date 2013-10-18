# Protocol for objects that wish to be notified when the state of a PullableView changes:
# pullableView(view, didChangeState: opened)     # Notifies of a changed state
# pullableView(view, shouldReceiveTouch: touch)  # Optional

class PullableView < UIView
  attr_accessor :closed_center, :opened_center
  attr_accessor :handle_view
  # attr_accessor :drag_recognizer, :tap_recognizer
  # attr_accessor :start_pos, :min_pos, :max_pos
  # attr_accessor :opened
  # attr_accessor :vertical_axis
  # attr_accessor :toggle_on_tap
  # attr_accessor :animate
  # attr_accessor :animation_duration
  attr_accessor :delegate

  def initWithFrame(frame)
    super.tap do
      @animate = true
      @animation_duration = 0.2
      @toggle_on_tap = true
      @opened = false
      
      @handle_view = UIView.alloc.initWithFrame(CGRectMake(0, frame.size.height - 40, frame.size.width, 40)).tap do |view|
        view.backgroundColor = UIColor.redColor
        self.addSubview(view)
        self.bringSubviewToFront(view)
      end
      
      @drag_recognizer = UIPanGestureRecognizer.alloc.initWithTarget(self, action: 'handleDrag:').tap do |recognizer|
        recognizer.minimumNumberOfTouches = 1
        recognizer.maximumNumberOfTouches = 1
        recognizer.delegate = self
        @handle_view.addGestureRecognizer(recognizer)
      end
        
      @tap_recognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action: 'handleTap:').tap do |recognizer|
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        recognizer.delegate = self
        @handle_view.addGestureRecognizer(recognizer)
      end
    end
  end

  def handleDrag(sender)
    case sender.state
    when UIGestureRecognizerStateBegan
      @start_pos = self.center
      
      # Determines if the view can be pulled in the x or y axis
      @vertical_axis = @closed_center.x == @opened_center.x
      
      # Finds the minimum and maximum points in the axis
      if @vertical_axis
        @min_pos = @closed_center.y < @opened_center.y ? @closed_center : @opened_center
        @max_pos = @closed_center.y > @opened_center.y ? @closed_center : @opened_center
      else
        @min_pos = @closed_center.x < @opened_center.x ? @closed_center : @opened_center
        @max_pos = @closed_center.x > @opened_center.x ? @closed_center : @opened_center
      end
    when UIGestureRecognizerStateChanged
      translate = sender.translationInView(self.superview)
      
      # Moves the view, keeping it constrained between opened_center and closed_center
      if @vertical_axis
        newPos = CGPointMake(@start_pos.x, @start_pos.y + translate.y)
        if newPos.y < @min_pos.y
          newPos.y = @min_pos.y
          translate = CGPointMake(0, newPos.y - @start_pos.y)
        end
        if newPos.y > @max_pos.y
          newPos.y = @max_pos.y
          translate = CGPointMake(0, newPos.y - @start_pos.y)
        end
      else
        newPos = CGPointMake(@start_pos.x + translate.x, @start_pos.y)
        if newPos.x < @min_pos.x
          newPos.x = @min_pos.x
          translate = CGPointMake(newPos.x - @start_pos.x, 0)
        end
        if newPos.x > @max_pos.x
          newPos.x = @max_pos.x
          translate = CGPointMake(newPos.x - @start_pos.x, 0)
        end
      end
      
      sender.setTranslation(translate, inView: self.superview)
      self.center = newPos
    when UIGestureRecognizerStateEnded
      # Gets the velocity of the gesture in the axis, so it can be
      # determined to which endpoint the state should be set.
      vectorVelocity = sender.velocityInView(self.superview)
      axisVelocity = @vertical_axis ? vectorVelocity.y : vectorVelocity.x
      target = axisVelocity < 0 ? @min_pos : @max_pos
      self.setOpened(CGPointEqualToPoint(target, @opened_center), animated:@animate)
    end
  end

  def handleTap(sender)
    if sender.state == UIGestureRecognizerStateEnded
      self.setOpened(!@opened, animated:@animate)
    end
  end

  def toggle_on_tap=(tap)
    @toggle_on_tap = tap
    @tap_recognizer.enabled = tap
  end

  def setOpened(op, animated: anim)
    @opened = op
    if anim
      UIView.beginAnimations(nil, context: nil)
      UIView.setAnimationDuration(@animation_duration)
      UIView.setAnimationCurve(UIViewAnimationCurveEaseOut)
      UIView.setAnimationDelegate(self)
      UIView.setAnimationDidStopSelector('animationDidStop:finished:context:')
    end
    
    self.center = @opened ? @opened_center : @closed_center
    
    if anim
      # For the duration of the animation, no further interaction with the view is permitted
      @drag_recognizer.enabled = false
      @tap_recognizer.enabled = false
      UIView.commitAnimations
    else
      if @delegate.respondsToSelector('pullableView:didChangeState:')
        @delegate.pullableView(self, didChangeState: @opened)
      end
    end
  end

  def animationDidStop(animationID, finished: finished, context: context)
    if finished
      # Restores interaction after the animation is over
      @drag_recognizer.enabled = true
      @tap_recognizer.enabled = @toggle_on_tap
      
      if delegate.respondsToSelector('pullableView:didChangeState:')
        delegate.pullableView(self, didChangeState: @opened)
      end
    end
  end

  ### UIGestureRecognizerDelegate
  
  def gestureRecognizer(gestureRecognizer, shouldReceiveTouch: touch)
    if delegate.respondsToSelector('pullableView:shouldReceiveTouch:')
      delegate.pullableView(self, shouldReceiveTouch: touch)
    else
      true
    end
  end
end
