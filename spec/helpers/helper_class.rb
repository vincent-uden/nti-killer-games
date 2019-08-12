class Helper
  
  @TEST_EMAIL = 'dorla@example.com'
  @TEST_PASSWORD = 'testpass123'

  def self.TEST_EMAIL
    @TEST_EMAIL
  end

  def self.TEST_PASSWORD
    @TEST_PASSWORD
  end

  def self.populate_user_data
    `pg_dump backup_nti | psql testing_nti`
  end
end
