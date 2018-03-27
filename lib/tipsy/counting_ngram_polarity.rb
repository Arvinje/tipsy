module Tipsy
  class CountingNgramPolarity
    attr_reader :ngram, :polarity

    def initialize(ngram:, mean:)
      @ngram  = ngram
      @mean   = mean
    end

    def run
      calculate_polarity
      self
    end

    def ngram_class
      @ngram_class ||= case @ngram.count
                         when 1
                           @ngram = @ngram.first
                           Unigram
                         when 2
                           Bigram
                         when 3
                           Trigram
                       end
    end

    private

    def positive_count
      @positive_count ||= ngram_class.where(content: @ngram, :score.gt => @mean).count
    end

    def negative_count
      @negative_count ||= ngram_class.where(content: @ngram, :score.lt => @mean).count
    end

    def calculate_polarity
      return unless ngram_class.where(content: @ngram).exists?
      @polarity ||= (positive_count - negative_count) / (positive_count + negative_count).to_f
    end
  end
end
