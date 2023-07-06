require 'csv'

class Hub::Importer
  DEFAULT_SOURCE = Rails.root.join("db/data/hubs.csv").freeze
  attr_reader :path

  def initialize(path = DEFAULT_SOURCE)
    @path = path
  end

  def reload!
    ApplicationRecord.transaction do
      clear
      load
    end
  end

  def clear!
    ApplicationRecord.transaction { clear }
  end

  def load!
    ApplicationRecord.transaction { load }
  end

  private

  def read_file(path, &block)
    CSV.foreach(path, headers: true) do |row|
      block.call row.to_h
    end
  end

  def load
    Rails.logger.debug("Loading #{@path}")

    read_file(@path) do |data|
      Hub.create!(
        name: data['Teaching School Hub name'],
        phone: data['Contact phone number'],
        email: data['Email address'],
        website: data['TSH website, where available'],
        areas: get_local_authorities(data['Teaching School Hub area'].split(' - ').last)
      )
    end
  end

  def clear
    Hub.delete_all
  end

  def get_local_authorities(string)
    mapped = authorities_with_comas_map.inject(string.dup) do |str, (key, value)|
      str.sub(key, value)
    end
    inversed_map = @authorities_with_comas_map.invert

    mapped.split(', ').map do |str|
      inversed_map[str] || str
    end
  end

  # CSV contains coma separated list of authorities, but some authorities have comes in their name.
  def authorities_with_comas_map
    @authorities_with_comas_map ||= LocalAuthority.where("name LIKE '%,%'")
      .pluck(:name)
      .index_with { |name| name.gsub(',', '*') }
  end
end
