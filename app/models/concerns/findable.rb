module Findable
  extend ActiveSupport::Concern

  module ClassMethods
    def insensitive_find_by(attribute)
      result = self.where(nil)
      attribute.each do |key, value|
        result = value.is_a?(String) ? self.where("lower(#{key}) = ?", value.downcase) : self.where("#{key} = ?", value)
      end
      result
    end
  end


end
