module Mutations
  class UpdateItemMutation < Mutations::BaseMutation
    argument :id, ID, required: true
    # argument :title, String, required: true
    # argument :description, String, required: false
    # argument :image_url, String, required: false
    argument :attributes, Types::ItemAttributes, required: true

    field :item, Types::ItemType, null: true
    field :errors, Types::ValidationErrorsType, null: true

    def resolve(id:, title:, description: nil, image_url: nil)
      check_authentication!

      item = Item.find(id)

      if item.update(attributes.to_h)
        { item: item }
      else
        { errors: item.errors }
      end
    end
  end
end
