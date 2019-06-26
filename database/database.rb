class Database
  @@db_con ||= PG.connect dbname: 'nti_killer_games'
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
