module Mutations
  class AddItemMutation < Mutations::BaseMutation
    # argument :title, String, required: true
    # argument :description, String, required: false
    # argument :image_url, String, required: false
    argument :attributes, Types::ItemAttributes, required: true

    field :item, Types::ItemType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    def resolve(title:, description: nil, image_url: nil)
      check_authentication!

      item = Item.new(attributes.to_h.merge(user: context[:current_user]))

      if item.save
        MartianLibrarySchema.subscriptions.trigger("itemAdded", {}, item)
        { item: item }
      else
        { errors: item.errors }
      end
    end
  end
end
