require 'pdf-reader'

class PdfParser
  def initialize(file_path)
    @file_path = file_path
  end

  attr_reader :file_path

  def extract_pdf_text
    reader = PDF::Reader.new(file_path)
    reader.pages.map(&:text).join("\n")
  end

  def chunk_text(text, max_chunk_words: 200)
    sentences = text.split(/(?<=[.?!])\s+/)
    chunks = []
    current_chunk = []

    sentences.each do |sentence|
      if (current_chunk + [sentence]).join(' ').split.size > max_chunk_words
        chunks << current_chunk.join(' ')
        current_chunk = []
      end
      current_chunk << sentence
    end

    chunks << current_chunk.join(' ') unless current_chunk.empty?
    chunks
  end

  def ingest_pdf_to_help_articles(title_prefix: "PDF Section")
    full_text = extract_pdf_text
    chunks = chunk_text(full_text)

    chunks.each_with_index do |chunk, idx|
      HelpArticle.create!(
        title: "#{title_prefix} #{idx + 1}",
        content: chunk,
        tags: "pdf_import",
        embedding: EmbeddingService.embed(chunk)
      )
    end
  end
end
