module Tipsy
  class ExtractBigrams
    include Celluloid

    def run(tip)
      begin
        @tip = tip
        @venue = tip.venue
        extract! if tip.content_lemma.present?
      rescue => e
        Tipsy.log.unknown "There was an unknown exception:"
        Tipsy.log.unknown e
      end
    end

    private

    def stopwords
      @stopwords ||= File.readlines("mysql_stopwords.txt").map(&:chomp)
    end

    def bigrams
      @tip.content_lemma.select{ |w| w =~ /^[a-zA-Z]+$/ && w.length > 2 }
                        .map(&:downcase)
                        .select{ |w| !stopwords.include?(w) }
                        .each_cons(2)
    end

    def extract!
      bigrams_array = bigrams.map do |bigram|
        { tip: @tip, content: bigram, score: @venue.rating }
      end
      Bigram.create!(bigrams_array)
      Tipsy.log.info "Extracted #{bigrams_array.count} bigrams for Tip##{@tip.fid}"
    end

  end
end
