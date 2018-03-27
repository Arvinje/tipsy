module Tipsy
  class EvaluateNgrams
    attr_reader :lemma

    def initialize(lemma: ,mean: , calculator: MeanNgramPolarity)
      @lemma = lemma
      @mean = mean
      @calculator = calculator
    end

    def run
      3.downto(1).each do |n|
        extract_ngrams(n)
        regenerate_lemma
      end
    end

    private

    def ngrams(n)
      @ngrams = @lemma.each_cons(n).each_with_index.select do |ngram, _index|
                                                        ngram.all?{ |uni| uni.class == String }
                                                      end
    end

    def extract_ngrams(n)
      @ngrams = ngrams(n).map do |ngram, index|
        [@calculator.new(ngram: ngram, mean: @mean).run, index]
      end
    end

    def regenerate_lemma
      @ngrams.select{ |n| n.first.polarity.present? }.each do |ngram, index|
        next if @lemma[index].nil?
        @lemma[index]     = ngram
        @lemma[index + 1] = nil if ngram.ngram_class == Bigram || ngram.ngram_class == Trigram
        @lemma[index + 2] = nil if ngram.ngram_class == Trigram
      end
      @lemma.compact!
    end
  end
end
