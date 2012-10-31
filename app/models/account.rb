class Account < ActiveRecord::Base
  attr_accessible :acc_number, :client_id
  belongs_to :client
  has_many :operations, dependent: :destroy

  SEPARATOR = '-'

  validates :client_id, presence: true

  before_save :generate_account_number

  private

    def generate_account_number
      last_found = Account.last
      year_prefix = Date.today.year.to_s
      acc_suffix = 0
      acc_suffix = last_found.acc_number.split(SEPARATOR).last.to_i if last_found
      self.acc_number = year_prefix << SEPARATOR << sprintf("%05d", acc_suffix + 1)
    end
end