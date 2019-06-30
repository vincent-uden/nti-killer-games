require 'awesome_print'
require 'pg'

require_relative '../database/database'
require_relative '../database/models/code_words'
require_relative '../database/models/users'


def get_code_words(amount)
  words = CodeWord.select_all.map { |x| x['word'] }
  generated_codes = []
  while generated_codes.length < amount do
    index1 = rand(0..19)
    index2 = rand(20..39)
    index3 = rand(40..59)
    word = words[index1] + "-" + words[index2] + "-" + words[index3]
    if !generated_codes.include? word
      generated_codes << word
    end
  end

  generated_codes
end
