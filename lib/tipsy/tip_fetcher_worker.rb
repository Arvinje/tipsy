module Tipsy
  class TipFetcherWorker
    include Celluloid

    def initialize(venue)
      @venue = venue
      @limit = 200
    end

    def run(offset=0)
      begin
        @tips = Tipsy.client.venue_tips @venue.fid, limit: @limit, offset: offset
        persist!
      rescue Foursquare2::APIError => e
        Tipsy.log.fatal "Foursquare Error when fetching tips for Venue(#{@venue.fid})"
        Tipsy.log.fatal e
      rescue => e
        Tipsy.log.unknown "Unknown error when fetching tips for Venue(#{@venue.fid})"
        Tipsy.log.fatal e
      end
    end

    def total_count
      @tips[:count]
    end

    def batch_count
      @tips.items.count
    end

    def persist!
      Tipsy.log.info "Persisting a batch of #{batch_count} tips for Venue(#{@venue.fid})"
      tips_array = @tips.items.map do |tip|
        {fid: tip[:id], content: tip[:text], created_at: tip[:createdAt],
         likes: tip[:likes][:count], venue: @venue}
      end
      Tip.create!(tips_array)
    end

  end
end
