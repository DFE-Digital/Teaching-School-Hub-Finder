RSpec.describe SearchForm, type: :model do
  it { is_expected.to validate_presence_of :location }
end
