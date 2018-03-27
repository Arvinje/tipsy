module Tipsy
  class MeanNgramPolarity
    attr_reader :ngram, :polarity

    def initialize(ngram:, mean:)
      @ngram    = ngram
      @mean     = mean
      @polarity = nil
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

    def ngram_mean_score
      @ngram_mean = ngram_class.where(content: @ngram).avg(:score)
    end

    def calculate_polarity
      return unless ngram_class.where(content: @ngram).exists?
      @polarity = (ngram_mean_score - 4.5) / 5.1
    end
  end
end
