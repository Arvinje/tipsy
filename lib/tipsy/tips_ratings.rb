module Tipsy
  class TipsRatings

    def run
      CSV.open("tips_ratings.csv", 'w') do |csv_object|
        csv_object << ['value', 'frequency']
        get_frequencies.sort.each do |value, freq|
          csv_object << [value, freq]
        end
      end
    end

    private

    def get_frequencies
      frequencies = Hash.new 0
      Venue.each do |venue|
        frequencies[venue.rating] += venue.tips.count
      end
      Tipsy.log.info "Generated values-frequencies hash."
      return frequencies
    end

  end
end
