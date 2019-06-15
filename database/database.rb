class Database
  @@db_con ||= PG.connect dbname: 'nti_killer_games'
  
  def self.exec(*args)
    @@db_con.exec(*args).entries
  end

  def self.prepare(*args)
    @@db_con.prepare(*args)
  end

  def self.exec_prepared(*args)
    @@db_con.exec_prepared(*args).entries
  end
end
