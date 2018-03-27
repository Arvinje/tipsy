module Tipsy
  class FetchAll

    def self.complete_all
      Venue.where(tips: nil).each do |venue|
        FetchTips.new(venue).run
      end
    end

    def initialize(options={})
      @start_lat, @start_long = options[:sw].split(', ').map(&:to_f)
      @end_lat, @end_long     = options[:ne].split(', ').map(&:to_f)
    end

    def run
      (@start_lat..@end_lat).step(0.04).each do |lat|
        (@start_long..@end_long).step(0.04).each do |long|
          Tipsy.log.info "Scanning #{lat}, #{long}"
          # Tipsy::FetchVenues.new(ll: "#{lat},#{long}", radius: 1000, intent: 'browse', categoryId: '4d4b7105d754a06374d81259', limit: 50).run
          Tipsy::FetchVenues.new(ll: "#{lat},#{long}", radius: 10000, intent: 'browse', limit: 50).run
        end
      end
    end

  end
end
