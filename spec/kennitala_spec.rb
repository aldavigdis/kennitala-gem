# frozen_string_literal: true

RSpec.describe Kennitala do
  before(:context) do
    @kt_person1 = Kennitala.new('0101302989')
    @kt_company1 = Kennitala.new('4612023220')
  end

  it 'generates a valid random personal kennitala if no string is provided' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Kennitala.new
    end
    expect(invalid_count).to eq(0)
  end

  it 'generates a valid random personal kennitala if kennitala is provided ' \
     'as boolean false' do
       invalid_count = 0
       255.times do
         invalid_count += 1 unless Kennitala.new(false)
       end
       expect(invalid_count).to eq(0)
     end

  it 'generates a valid random personal kennitala if kt_string equals false' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Kennitala.new(false).person?
    end
    expect(invalid_count).to eq(0)
  end

  it 'generates a valid random company kennitala if is_company equals true' do
    invalid_count = 0
    255.times do
      invalid_count += 1 unless Kennitala.new(false, true).company?
    end
    expect(invalid_count).to eq(0)
  end

  it 'raises the correct argument error if the argument provided is not a ' \
     'string or a boolean false' do
    expect { Kennitala.new(461_202_322_0) }
      .to raise_error(ArgumentError, 'Kennitala needs to be provided as a ' \
                                     'String or Boolean (false)')
  end

  it 'assumes out-of-bounds day-of-month to be valid' do
    out_of_bounds_kt_string = '6902691399'
    expect { Kennitala.new(out_of_bounds_kt_string) }
      .not_to raise_error(ArgumentError)
  end

  describe '.to_s' do
    it 'removes non-numeric characters from the kennitala string' do
      kt_with_junk = Kennitala.new('Mjá 🐈 kisa 010130-2989')
      expect(kt_with_junk.to_s).to eq('0101302989')
    end
  end

  describe '.to_date' do
    # This should cover .year, .month and .day as well
    it 'casts the kennitala to a Date object' do
      expect(@kt_person1.to_date).to be_an_instance_of(Date)
    end
    it 'assumes out-of-bounds day-of-month to be actually the last day of the month' do
      kt = '6902691399'.to_kt
      date = kt.to_date
      expect(date.day).to eq(28)
    end
  end

  describe '.age' do
    it 'calculates the age of a person in years and returns it as a Fixnum' do
      y_diff = Date.today.year - @kt_person1.year
      m_diff = Date.today.month - @kt_person1.month
      d_diff = Date.today.month - @kt_person1.month
      age = if m_diff < 0 || (m_diff == 0 && d_diff < 0)
              y_diff - 1
            else
              y_diff
            end
      expect(@kt_person1.age).to eq(age)
    end
    it 'calculates the age of a company in years and returns it as a Fixnum' do
      expect(@kt_company1.age).to be_an_instance_of(Integer)
    end
  end

  describe '.company?' do
    it 'figures out a company kennitala' do
      expect(@kt_company1.company?).to eq(true)
    end
    it 'figures out a personal kennitala' do
      expect(@kt_person1.company?).to eq(false)
    end
  end

  describe '.person?' do
    it 'figures out a company kennitala' do
      expect(@kt_company1.person?).to eq(false)
    end
    it 'figures out a personal kennitala' do
      expect(@kt_person1.person?).to eq(true)
    end
  end

  describe '.entity_type' do
    it 'identifies a person' do
      expect(@kt_person1.entity_type).to eq('person')
    end
    it 'identifies a company' do
      expect(@kt_company1.entity_type).to eq('company')
    end
  end

  describe '.pp' do
    it 'uses a single space as the default spacer' do
      expect(@kt_person1.pp).to eq('010130 2989')
    end
    it 'adds a specific spacer if specified' do
      expect(@kt_person1.pp('-')).to eq('010130-2989')
    end
    it 'can handle emoji (or any multibyte utf-8 character) as a spacer' do
      # Why? - Just because!
      expect(@kt_person1.pp('🐈')).to eq('010130🐈2989')
    end
  end
end
