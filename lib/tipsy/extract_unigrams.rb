module Tipsy
  class ExtractUnigrams
    include Celluloid

    STOPWORDS = File.readlines("mysql_stopwords.txt").map(&:chomp)

    def run(tip)
      begin
        @tip = tip
        @venue = tip.venue
        if tip.content_lemma.present?
          extract!
          remove_stopwords!
        end
      rescue => e
        Tipsy.log.unknown "There was an unknown exception:"
        Tipsy.log.unknown e
      end
    end

    private

    def unigrams
      @tip.content_lemma.select{ |w| w =~ /^[a-zA-Z]+$/ && w.length > 3 }.map(&:downcase)
    end

    def extract!
      unigrams_array = unigrams.map do |unigram|
        { tip: @tip, content: unigram, score: @venue.rating }
      end
      Unigram.create!(unigrams_array)
      Tipsy.log.info "Extracted #{unigrams_array.count} unigrams for Tip##{@tip.fid}"
    end

    def remove_stopwords!
      Unigram.where(:content.in => STOPWORDS).delete
    end
  end
end
