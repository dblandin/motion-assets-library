class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions: launch_options)
    return true if RUBYMOTION_ENV == 'test'

    initialize_main_controller

    true
  end

  private

  def initialize_main_controller
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    window.setRootViewController(photo_library_controller)

    window.makeKeyAndVisible
  end

  def photo_library_controller
    PhotoLibraryController.alloc.init
  end
end
