module Tipsy
  class Unigram
    include Mongoid::Document

    field :content, type: String
    field :score,   type: Float

    belongs_to :tip
  end
end
