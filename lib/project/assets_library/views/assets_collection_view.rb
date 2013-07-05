class Motion
  class AssetsLibrary
    class AssetsCollectionView < UICollectionView
      def initWithFrame(frame, collectionViewLayout: layout)
        super.tap do |collection_view|
          collection_view.dataSource = _data_source
        end
      end

      protected

      def _data_source
        @_data_source ||= AssetsLibrary::AssetsDataSource.new(WeakRef.new(self))
      end
    end
  end
end
