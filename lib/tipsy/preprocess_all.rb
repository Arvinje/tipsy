module Tipsy
  class PreprocessAll

    def run
      pipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma)
      # pool = Preprocessor.pool(args: pipeline)
      # Tip.each do |tip|
      #   pool.async.run tip
      # end
      prep = Preprocessor.new(pipeline)
      Tip.each do |tip|
        prep.run(tip)
      end
    end

  end
end
