module Tipsy
  class Venue
    include Mongoid::Document

    field :fid,            type: String
    field :name,           type: String
    field :rating,         type: Float
    field :rating_signals, type: Integer
    field :likes,          type: Integer

    has_many :tips, dependent: :destroy

    index({ fid: 1 }, { unique: true, name: "fid_index" })
  end
end
