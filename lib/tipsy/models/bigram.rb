module Tipsy
  class Bigram
    include Mongoid::Document

    field :content, type: Array
    field :score,   type: Float

    belongs_to :tip
  end
end
