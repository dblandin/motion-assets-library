# motion-assets-library

Access iOS media via ALAssetsLibrary

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
    self.assets = assets

    colletion_view.reloadData
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
