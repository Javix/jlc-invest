class Client < ActiveRecord::Base
  has_many :operations, dependent: :destroy
  default_scope order: 'clients.lastname'
  attr_accessible :firstname, :lastname, :street, :house, :box, :zipcode, :city, :country, :phone

  validates :firstname, presence: true, length: {maximum: 50}
  validates :lastname, presence: true, length: {maximum: 50}, uniqueness: {case_sensitive: false, scope: "firstname"}
  validates :street, presence: true, length: {maximum: 50}
  validates :house, presence: true, length: {maximum: 5}
  validates :zipcode, presence: true, length: {maximum: 5}
  validates :city, presence: true, length: {maximum: 50}
  validates :country, presence: true, length: {maximum: 50}

  before_validation do |client|
    client.firstname = firstname.strip.split('-').map(&:capitalize).join('-')
    client.lastname = lastname.upcase.strip
    client.street = street.capitalize.strip
    client.zipcode = zipcode.strip
    client.city = city.capitalize.strip
    client.country = country.upcase.strip
  end

  def full_name
    ["#{firstname}", "#{lastname}"].join(' ')
  end
end
