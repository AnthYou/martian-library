module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :items,
          [Types::ItemType],
          null: false,
          description: "Returns a list of items in the martian library"

    field :me, Types::UserType, null: true

    def items
      # Item.all ### too many queries for user
      Item.preload(:user) ### resolves N+1 queries, but not useful when we don't need user
    end

    def me
      context[:current_user]
    end
  end
end
