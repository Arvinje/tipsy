module Tipsy
  class AllNgrams
    def run
      pool = ExtractNgrams.pool
      Tip.each do |tip|
        pool.async.run tip
      end
      self
    end
  end
end
