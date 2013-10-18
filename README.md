PullableView
============

UIView subclass that implements pullable behaviour similar to the Notification Center in iOS 5.

[Original Objective-C code](https://github.com/crocodella/PullableView) by Fabio Rodella / Crocodella.

This is a direct translation for [RubyMotion](http://www.rubymotion.com). All credit for the code goes to Crocodella.

Requirements
------------

A valid RubyMotion license, of course.

Installation
------------

    git clone https://github.com/otagi/PullableView.git

Setup
-----

1. Build and run the sample app with the usual `rake` command.
2. Play with it.
3. Copy the `PullableView` class into your project.

Changes
-------

There are a few cosmetic changes in this Ruby version:

* The `PullableView`'s delegate pattern has been replaced by block-based callbacks.
* The start/stop button in the sample app has been removed. The views are pullable by default.
