class Motion
  class AssetsLibrary
    class Saver
      attr_reader :success_callback, :failure_callback, :denied_callback

      def failure(callback)
        @failure_callback = callback
      end

      def denied(callback)
        @denied_callback = callback
      end

      def save(image, &block)
        save(image, to_album: nil, &block)
      end

      def save(image, to_album: album_name, &block)
        @success_callback = block

        if access_denied?
          denied_callback.call if denied_callback
        else
          do_save(image, album: album_name)
        end
      end

      private

      def do_save(image, album: album_name)
        asset_url = nil

        asset_url = assets_library.writeImageToSavedPhotosAlbum(image.CGImage,
          orientation: image.imageOrientation,
          completionBlock: lambda { |asset_url, error|
            if error
              failure_callback.call(error) if failure_callback
            else
              add_asset_url(asset_url, to_album: album_name) if album_name

              success_callback.call(asset_url) if success_callback
            end
        })
      end

      def add_asset_url(asset_url, to_album: album_name)
        album_found = false

        assets_library.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: lambda { |group, stop|
          if group && album_name === group.valueForProperty(ALAssetsGroupPropertyName)
            album_found = stop = true

            assets_library.assetForURL(asset_url, resultBlock: lambda { |asset|
              group.addAsset(asset)
            }, failureBlock: nil)
          end

          if album_found == false
            assets_library.addAssetsGroupAlbumWithName(album_name, resultBlock: lambda { |group|
              assets_library.assetForURL(asset_url, resultBlock: lambda { |asset|
                group.addAsset(asset)
              }, failureBlock: nil)
            }, failureBlock: nil)
          end
        }, failureBlock: nil)
      end

      def assets_library
        @assets_library ||= ALAssetsLibrary.alloc.init
      end

      def access_denied?
        [ALAuthorizationStatusDenied, ALAuthorizationStatusRestricted].include? authorization_status
      end

      def authorization_status
        ALAssetsLibrary.authorizationStatus
      end
    end
  end
end
