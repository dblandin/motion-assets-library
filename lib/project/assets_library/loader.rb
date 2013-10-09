class Motion
  class AssetsLibrary
    class Loader
      attr_accessor :delegate

      def load_assets
        assets_library.enumerateGroupsWithTypes(
          ALAssetsGroupSavedPhotos,
          usingBlock:   album_block,
          failureBlock: album_failure_block)
      end

      def denied(callback)
        @denied_callback = callback
      end

      def denied_callback
        @denied_callback ||= -> { }
      end

      def access_denied?
        [ALAuthorizationStatusDenied, ALAuthorizationStatusRestricted].include? authorization_status
      end

      def authorization_status
        ALAssetsLibrary.authorizationStatus
      end

      def reset_assets
        @assets = []

        load_assets
      end

      def assets
        @assets ||= []
      end

      private

      def album_block
        lambda { |group, stop| group.enumerateAssetsWithOptions(asset_enumeration_options, usingBlock: asset_block) if group }
      end

      def album_failure_block
        lambda do |error|
          p "Error: #{error.localizedDescription}"

          denied_callback.call if access_denied?
        end
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

        Dispatch::Queue.main.async do
          delegate.did_load_assets(assets)
        end
      end

      def add_asset(asset)
        assets << AssetsLibrary::AssetWrapper.new(asset)
      end

      def assets_library
        @assets_library ||= ALAssetsLibrary.alloc.init
      end

      def asset_enumeration_options
        NSEnumerationReverse
      end
    end
  end
end
