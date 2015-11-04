module Findable
  extend ActiveSupport::Concern

  module ClassMethods
    def insensitive_find_by(attribute)
      result = self.where(nil)
      attribute.each do |key, value|
        result = not_an_id?(value) ? self.where("lower(#{key}) = ?", value.downcase) : self.where("#{key} = ?", value)
      end
      result
    end

    def not_an_id?(value)
      value.to_i == 0
    end
  end

end
