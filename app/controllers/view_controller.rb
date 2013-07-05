class ViewController < UIViewController
  def viewDidLoad
    super

    view.addSubview(collection_view)
  end

  def collection_view
    @_collection_view ||= begin
      Motion::AssetsLibrary::AssetsCollectionView.alloc.initWithFrame(view.bounds, collectionViewLayout: layout)
    end
  end

  def layout
    UICollectionViewFlowLayout.alloc.init.tap do |layout|
      layout.itemSize = CGSizeMake(105.0, 105.0)
      layout.minimumInteritemSpacing = 1.0
      layout.minimumLineSpacing = 1.0
    end
  end
end
