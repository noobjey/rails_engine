class Customer < ActiveRecord::Base
  has_many :invoices

  def self.insensitive_find_by(attribute)
    result = self.where(nil)
    attribute.each do |key, value|
      if value.is_a?(String)
        result = self.where("lower(#{key}) = ?", value.downcase)
      else
        result = self.where("#{key} = ?", value)
      end
    end
    result
  end

end
