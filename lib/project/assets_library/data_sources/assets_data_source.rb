class Motion
  class AssetsLibrary
    class AssetsDataSource
      attr_accessor :collection_view

      def initialize(collection_view)
        self.collection_view = collection_view

        register_cells

        asset_loader.load_assets
      end

      def register_cells
        collection_view.registerClass(
          cell_class,
          forCellWithReuseIdentifier: cell_class::IDENTIFIER)
      end

      def cell_class
        AssetsLibrary::AssetCell
      end

      def collectionView(collection_view, numberOfItemsInSection: section)
        asset_loader.assets.count
      end

      def collectionView(collection_view, cellForItemAtIndexPath: index_path)
        collection_view.dequeueReusableCellWithReuseIdentifier(cell_class::IDENTIFIER, forIndexPath: index_path).tap do |cell|
          asset = asset_loader.assets[index_path.row]

          cell.reset_with_asset(asset)
        end
      end

      def asset_loader
        @_asset_loader ||= AssetsLibrary::Loader.new.tap do |loader|
          loader.delegate = WeakRef.new(self)
        end
      end

      def did_load_assets(asset)
        collection_view.reloadData
      end
    end
  end
end
