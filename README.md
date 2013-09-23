# motion-assets-library

Access iOS media via ALAssetsLibrary

[![Gem Version](https://badge.fury.io/rb/motion-assets-library.png)](http://badge.fury.io/rb/motion-assets-library)
[![Code Climate](https://codeclimate.com/github/dblandin/motion-assets-library.png)](https://codeclimate.com/github/dblandin/motion-assets-library)

motion-assets-library's initial development was sponsored by [dscout](https://dscout.com). Many thanks to them!

## Usage

Instantiate a loader and set a delegate:

``` ruby
Motion::AssetsLibrary::Loader.new.tap do |loader|
  loader.delegate = WeakRef.new(self)
end
```

Implement the delegate method:

``` ruby
  def did_load_assets(assets)
    @assets = assets

    colletion_view.reloadData
  end
```

### Handling denied access to the Photo Library

Set a denied callback:

``` ruby
denied_callback = -> do
  show_alert('Access to the Photo Library has been denied. Please update your privacy settings')
end

Motion::AssetsLibrary::Loader.new.tap do |loader|
  loader.delegate = WeakRef.new(self)
  loader.denied denied_callback
end
```

## Setup

Add this line to your application's Gemfile:

    gem 'motion-assets-library'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-assets-library

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

[dscout](https://dscout.com) - for their sponsorship
