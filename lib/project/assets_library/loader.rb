class Motion
  class AssetsLibrary
    class Loader
      attr_accessor :delegate, :observer

      def initialize
        listen_to_asset_library
      end

      def load_assets
        assets_library.enumerateGroupsWithTypes(
          ALAssetsGroupSavedPhotos,
          usingBlock:   album_block,
          failureBlock: album_failure_block)
      end

      def reset_assets
        @_assets = []

        load_assets
      end

      def assets
        @_assets ||= []
      end

      private

      def listen_to_asset_library
        self.observer = notification_center.addObserver(
          self,
          selector: 'asset_library_did_change:',
          name: ALAssetsLibraryChangedNotification,
          object: nil)
      end

      def asset_library_did_change(notification)
        reset_assets
      end

      def dealloc
        notification_center.removeObserver(observer)
      end

      def album_block
        lambda { |group, stop| group.enumerateAssetsUsingBlock(asset_block) if group }
      end

      def album_failure_block
        lambda { |error| p "Error: #{error[0].description}" }
      end

      def asset_block
        lambda do |asset, index, stop|
          if asset
            add_asset(asset)
          else
            notify_load
          end
        end
      end

      def notify_load
        unless delegate.respondsToSelector 'did_load_assets:'
          raise DelegateMethodUnimplemented, 'did_load_assets: must be implemented'
        end

        delegate.did_load_assets(assets)
      end

      def add_asset(asset)
        assets << AssetsLibrary::AssetWrapper.new(asset)
      end

      def assets_library
        @_assets_library ||= ALAssetsLibrary.alloc.init
      end

      def notification_center
        NSNotificationCenter.defaultCenter
      end
    end
  end
end
