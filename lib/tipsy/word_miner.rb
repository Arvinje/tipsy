module Tipsy
  class WordMiner

    def run
      pool = WordHashBuilder.pool
      Tip.each do |tip|
        pool.async.mine tip
      end
    end

  end
end
