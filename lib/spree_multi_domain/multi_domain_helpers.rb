module SpreeMultiDomain
  module MultiDomainHelpers
    def self.included(receiver)
      receiver.send :helper, 'spree/products'
      receiver.send :helper, 'spree/taxons'

      receiver.send :helper_method, :taxons_for_search
    end

    def get_taxonomies
      @taxonomies ||= current_store.present? ? Spree::Taxonomy.by_store(current_store) : Spree::Taxonomy
      @taxonomies = @taxonomies.includes(root: :children)
      @taxonomies
    end

    def taxons_for_search
      taxons = @taxon&.parent ? @taxon.parent.children : Spree::Taxon.roots
      if current_store.present?
        taxons.joins(:taxonomy).where('spree_taxonomies.store_id = ?', current_store.id)
      else
        taxons
      end
    end
  end
end
