module Tipsy
  class EvaluateUnigrams
    attr_reader :final_unigrams

    def initialize(lemma: ,mean: , calculator: MeanNgramPolarity)
      @lemma = lemma
      @mean = mean
      @calculator = calculator
    end

    def run
      @final_unigrams = unigrams.map do |unigram|
                          @calculator.new(unigram: unigram, mean: @mean).run
                        end
    end

    def final_lemma
      []
    end

    private

    def unigrams
      @lemma.select{ |lem| lem.class == String }
    end
  end
end
