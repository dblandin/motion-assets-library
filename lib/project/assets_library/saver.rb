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
        @album_found      = false

        if access_denied?
          denied_callback.call if denied_callback
        else
          do_save(image, album: album_name)
        end
      end

      def save_image_data(image_data, &block)
        save_image_data(image_data, to_album: nil, &block)
      end

      def save_image_data(image_data, to_album: album_name, &block)
        @success_callback = block
        @album_found      = false

        if access_denied?
          denied_callback.call if denied_callback
        else
          do_save_data(image_data, album: album_name)
        end
      end

      private

      def do_save(image, album: album_name)
        asset_url = nil

        asset_url = assets_library.writeImageToSavedPhotosAlbum(
          image.CGImage,
          orientation: image.imageOrientation,
          completionBlock: write_image_block(album_name))
      end

      def do_save_data(image_data, album: album_name)
        asset_url = nil

        asset_url = assets_library.writeImageDataToSavedPhotosAlbum(
          image_data,
          metadata: nil,
          completionBlock: write_image_block(album_name))
      end

      def write_image_block(album_name)
        lambda { |asset_url, error|
          if error
            failure_callback.call(error) if failure_callback
          else
            add_asset_url(asset_url, to_album: album_name) if album_name

            success_callback.call(asset_url) if success_callback
          end
        }
      end

      def album_found?
        !!@album_found
      end

      def add_asset_url(asset_url, to_album: album_name)
        assets_library.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: lambda { |group, stop|
          if group
            if album_name === group.valueForProperty(ALAssetsGroupPropertyName)
              @album_found = true

              assets_library.assetForURL(asset_url, resultBlock: lambda { |asset|
                group.addAsset(asset)
              }, failureBlock: nil)
            end
          else
            unless album_found?
              assets_library.addAssetsGroupAlbumWithName(album_name, resultBlock: lambda { |new_group|
                assets_library.assetForURL(asset_url, resultBlock: lambda { |asset|
                  new_group.addAsset(asset)
                }, failureBlock: nil)
              }, failureBlock: nil)
            end
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
