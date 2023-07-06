class LocalAuthority < ApplicationRecord
  include RGeo::ActiveRecord::GeometryMixin

  def self.search(query)
    Search.new(self, query).call
  end

  def self.order_by_distance_from(point)
    order(Arel.sql("geometry <-> ST_Geomfromtext('#{point.as_text}')"))
  end
end
