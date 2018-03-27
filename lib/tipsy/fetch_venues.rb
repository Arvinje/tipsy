module Tipsy
  class FetchVenues

    def initialize(options={})
      @options = options
    end

    def run
      begin
        venue_ids.each do |id|
          if Venue.where(fid: id).exists?
            Tipsy.log.info "Venue(#{id}) already exists"
            next
          end
          venue = persist_venue(id)
          if venue == false
            Tipsy.log.info "Venue(#{id}) doesn't have rating"
            next
          end
          FetchTips.new(venue).run
        end
      rescue Foursquare2::APIError => e
        Tipsy.log.fatal "Foursquare Error:"
        Tipsy.log.fatal e
      rescue => e
        Tipsy.log.unknown "Unknown error:"
        Tipsy.log.fatal e
      end
    end

    private

    def venue_ids
      @venue_ids ||= Tipsy.client.search_venues(@options).venues.collect(&:id)
    end

    def persist_venue(venue_id)
      venue = Tipsy.client.venue venue_id
      return false if venue[:rating].nil? || venue[:rating] > 6.5 # || venue[:rating] < 7 || venue[:rating] > 8.5
      Tipsy.log.info "Persisting Venue(#{venue_id})"
      Venue.create!(fid: venue[:id], name: venue[:name], rating: venue[:rating], rating_signals: venue[:ratingSignals], likes: venue[:likes][:count])
    end

  end
end
