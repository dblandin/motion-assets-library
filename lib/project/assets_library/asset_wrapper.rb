class Motion
  class AssetsLibrary
    class AssetWrapper
      attr_accessor :asset

      def initialize(asset)
        self.asset = asset
      end

      def asset_url
        asset.valueForProperty('ALAssetPropertyAssetURL')
      end

      def thumbnail
        asset.thumbnail
      end

      def filename
        default_representation.filename
      end

      def cgi_image
        default_representation.CGImageWithOptions(nil)
      end

      def type
        asset.valueForProperty('ALAssetPropertyType')
      end

      def default_representation
        asset.defaultRepresentation
      end
    end
  end
end
