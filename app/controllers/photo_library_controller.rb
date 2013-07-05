class PhotoLibraryController < UIViewController
  def viewDidLoad
    super

    register_cells

    configure_collection_view

    view.addSubview(collection_view)

    asset_loader.load_assets
  end

  def register_cells
    collection_view.registerClass(PhotoGridCell, forCellWithReuseIdentifier: PhotoGridCell::IDENTIFIER)
  end

  def configure_collection_view
    collection_view.tap do |photo_view|
      photo_view.dataSource = self
    end
  end

  def asset_loader
    @_asset_loader ||= Motion::AssetsLibrary::Loader.new.tap do |loader|
      loader.delegate = self
    end
  end

  def collection_view
    @_collection_view ||= begin
      UICollectionView.alloc.initWithFrame(view.bounds, collectionViewLayout: collection_view_layout)
    end
  end

  def collection_view_layout
    UICollectionViewFlowLayout.alloc.init.tap do |layout|
      layout.itemSize = CGSizeMake(105.0, 105.0)
      layout.minimumInteritemSpacing = 1.0
      layout.minimumLineSpacing = 1.0
    end
  end

  def collectionView(collection_view, numberOfItemsInSection: section)
    asset_loader.assets.count
  end

  def collectionView(collection_view, cellForItemAtIndexPath: index_path)
    collection_view.dequeueReusableCellWithReuseIdentifier(PhotoGridCell::IDENTIFIER, forIndexPath: index_path).tap do |cell|
      photo = asset_loader.assets[index_path.row]

      cell.reset_with_photo(photo)
    end
  end

  def did_load_assets(assets)
    collection_view.reloadData
  end
end
