class Motion
  class AssetsLibrary
    class AssetCell < UICollectionViewCell
      IDENTIFIER = 'AssetCellIdentifier'

      attr_accessor :image_view

      def initWithFrame(frame)
        super.tap do |cell|
          cell.add_image_view
        end
      end

      def reset_with_asset(asset)
        image_view.image = UIImage.imageWithCGImage(asset.thumbnail)
      end

      protected

      def add_image_view
        self.image_view = UIImageView.alloc.initWithFrame([[0, 0], [105, 105]]).tap do |image_view|
          contentView.addSubview(image_view)
        end
      end
    end
  end
end
