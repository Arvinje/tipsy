module Tipsy
  class WordHashBuilder
    include Celluloid

    def mine(tip)
      begin
        @tip = tip
        @venue = tip.venue
        persist_hashes word_hashes
      rescue => e
        Tipsy.log.unknown "There was an unknown exception:"
        Tipsy.log.unknown e
      end
    end

    private

    def statistics_for(word)
      $redis.hgetall word
    end

    def build_hash_for(word)
      previous_hash = statistics_for word
      current_score = @venue.rating + (previous_hash.empty? ? 0 : previous_hash['score'].to_i)
      current_repeat = @repeat_counts[word] + (previous_hash.empty? ? 0 : previous_hash['repeat'].to_i)
      {
        score: current_score,
        repeat: current_repeat,
        average: current_score/current_repeat
      }
    end

    def word_hashes
      @repeat_counts = Hash.new 0
      @tip.content_lemma.each { |word| @repeat_counts[word] += 1 }
      @tip.content_lemma.map { |word| [word, build_hash_for(word)] }
    end

    def persist_hashes(array)
      if @tip == Tip.find_by(fid:"4b85aa5170c603bb4efc92b4")
        Tipsy.log.info array
      end
      array.each do |tuple|
        $redis.mapped_hmset(tuple.first, tuple.last)
      end
      Tipsy.log.info "#{array.count} words processed for Tip(#{@tip.fid})"
    end

  end
end
