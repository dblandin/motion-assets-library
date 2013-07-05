class PhotoGridCell < UICollectionViewCell
  IDENTIFIER = 'PhotoGridCellIdentifier'

  attr_accessor :image_view

  def initWithFrame(frame)
    super.tap do |cell|
      cell.add_image_view
    end
  end

  def reset_with_photo(photo)
    image_view.image = UIImage.imageWithCGImage(photo.thumbnail)
  end

  protected

  def add_image_view
    self.image_view = UIImageView.alloc.initWithFrame([[0, 0], [105, 105]]).tap do |image_view|
      contentView.addSubview(image_view)
    end
  end
end
