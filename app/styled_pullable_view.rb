class StyledPullableView < PullableView
  def initWithFrame(frame)
    super.tap do
      imgView = UIImageView.alloc.initWithImage(UIImage.imageNamed("background.png"))
      imgView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
      self.addSubview(imgView)
    end
  end
end