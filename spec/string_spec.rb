# frozen_string_literal: true

RSpec.describe String do
  it 'can be cast to kennitala using .to_kt' do
    expect('0101302989'.to_kt).to be_an_instance_of(Kennitala)
  end
  it 'will not be cast to a kennitala if invalid and will raise an error' do
    expect { ''.to_kt }.to raise_error(ArgumentError, 'Kennitala is invalid')
  end
end
