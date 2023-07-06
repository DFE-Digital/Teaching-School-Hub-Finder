class Hub < ApplicationRecord
  def self.by_local_authority(*authorities)
    where("areas && ARRAY[?]::varchar[]", authorities)
  end
end
