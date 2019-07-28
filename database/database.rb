# To backup database, run this in shell
# createdb -O *ownerName* -T *originalDb* *newDbName*

class Database
  if ENV['RACK_ENV'] ==  'test'
    @@db_con ||= PG.connect dbname: 'testing_nti'
  else
    @@db_con ||= PG.connect dbname: 'nti_killer_games'
  end
  @@db_con.type_map_for_results = PG::BasicTypeMapForResults.new @@db_con
  
  def self.exec(*args)
    @@db_con.exec(*args).entries
  end

  def self.prepare(*args)
    @@db_con.prepare(*args)
  end

  def self.exec_prepared(*args)
    @@db_con.exec_prepared(*args).entries
  end

  def self.exec_params(*args)
    @@db_con.exec_params(*args).entries
  end

  def self.escape(string)
    @@db_con.escape_string string
  end
end
