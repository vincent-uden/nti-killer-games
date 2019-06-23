require 'awesome_print'
require 'pg'

require_relative '../database/database'
require_relative '../database/models/code_words'
require_relative '../database/models/users'


def get_code_words()
  words = CodeWord.select_all.map { |x| x['word'] }
  ap words
  generated_codes = []
  while generated_codes.length < 8000 do
    index1 = rand(0..19)
    index2 = rand(20..39)
    index3 = rand(40..59)
    word = words[index1] + "-" + words[index2] + "-" + words[index3]
    if !generated_codes.include? word
      generated_codes << word
    end
  end

  ap generated_codes
  p generated_codes.uniq.length == generated_codes.length
end

get_code_words
