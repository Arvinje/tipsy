module Tipsy
  class FetchTips

    def initialize(venue)
      @venue = venue
    end

    def run
      first_batch = TipFetcherWorker.new(@venue)
      first_batch.run
      Tipsy.log.info "Persisting #{first_batch.total_count} tips for Venue(#{@venue.fid})"
      pool = TipFetcherWorker.pool(args: [@venue])
      first_batch.total_count.times.select{ |n| n % first_batch.batch_count == 0 }.drop(1).each do |offset|
        pool.async.run(offset)
      end
    end

  end
end
