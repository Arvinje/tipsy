module Tipsy
  class Tip
    include Mongoid::Document

    field :fid,                  type: String
    field :content,              type: String
    field :content_tokens,       type: Array
    field :content_lemma,        type: Array
    field :content_tags,         type: Array
    field :emoticons,            type: Array
    field :created_at,           type: DateTime
    field :likes,                type: Integer

    belongs_to :venue
    has_many :unigrams, dependent: :destroy
    has_many :bigrams, dependent: :destroy

    index({ fid: 1 }, { unique: true, name: "fid_index" })
  end
end
