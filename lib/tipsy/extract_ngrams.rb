module Tipsy
  class ExtractNgrams
    include Celluloid

    STOPWORDS = File.readlines("mysql_stopwords.txt").map(&:chomp)

    def run(tip)
      begin
        @tip = tip
        @venue = tip.venue
        @sentences = nil
        persist! if tip.content_lemma.present?
      rescue => e
        Tipsy.log.unknown "There was an unknown exception:"
        Tipsy.log.unknown e
      end
    end

    private

    def sentences
      @sentences ||= @tip.content_lemma.split(".").map do |sentence|
        sentence.select{ |w| w =~ /^[a-zA-Z]+$/ && w.length > 2 }
                .map(&:downcase).delete_if{ |w| STOPWORDS.include?(w) }
      end
    end

    def unigrams
      sentences.flatten
    end

    def bigrams
      sentences.inject([]) { |bigrams, sentence| bigrams << sentence.each_cons(2) }.map(&:to_a).flatten(1)
    end

    def trigrams
      sentences.inject([]) { |trigrams, sentence| trigrams << sentence.each_cons(3) }.map(&:to_a).flatten(1)
    end

    def unigrams_array
      unigrams.map do |unigram|
        { tip: @tip, content: unigram, score: @venue.rating }
      end
    end

    def bigrams_array
      bigrams.map do |bigram|
        { tip: @tip, content: bigram, score: @venue.rating }
      end
    end

    def trigrams_array
      trigrams.map do |trigram|
        { tip: @tip, content: trigram, score: @venue.rating }
      end
    end

    def persist!
      unigram_count = Unigram.create!(unigrams_array).count
      Tipsy.log.info "Extracted #{unigram_count} unigrams for Tip##{@tip.fid}"
      bigram_count = Bigram.create!(bigrams_array).count
      Tipsy.log.info "Extracted #{bigram_count} bigrams for Tip##{@tip.fid}"
      trigram_count = Trigram.create!(trigrams_array).count
      Tipsy.log.info "Extracted #{trigram_count} trigrams for Tip##{@tip.fid}"
    end
  end
end
