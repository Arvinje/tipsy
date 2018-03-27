module Tipsy
  class TextAnalyzer
    attr_reader :text_ngrams, :polarity

    STOPWORDS = File.readlines("mysql_stopwords.txt").map(&:chomp)

    def initialize(text)
      @text     = text
      @pipeline = StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma)
      @text_ngrams = []
    end

    def run
      preprocess_text
      evaluate_ngrams
      calculate_score
    end

    private

    def preprocess_text
      annotated_content = StanfordCoreNLP::Annotation.new(@text)
      @pipeline.annotate(annotated_content)
      @text_lemma = annotated_content.get(:tokens).map(&:lemma).split(".").map do |sentence|
                      sentence.select{ |w| w =~ /^[a-zA-Z]+$/ && w.length > 2 }
                              .map(&:downcase).delete_if{ |w| STOPWORDS.include?(w) }
                    end
    end

    def evaluate_ngrams
      @text_lemma.each do |sentence|
        evaluation    = EvaluateNgrams.new(lemma:sentence, mean: 6.8)
        evaluation.run
        @text_ngrams += evaluation.lemma
      end
    end

    def calculate_score
      @polarity = @text_ngrams.map(&:polarity).mean
    end
  end
end
