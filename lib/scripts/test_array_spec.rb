require 'rails_helper'

describe TestArray do
  before do
    @array = TestArray.new
    @numbers = @array.instance_eval { @numbers }.sort
  end

  it 'build an array of numbers' do
    expect(@numbers.class).to eq Array
  end

  it 'find missing numbers' do
    number = nil
    loop do
      number = rand(@numbers.first..@numbers.last)
      break unless @numbers.include?(number)
    end
    expect(@array.find_missing_numbers).to include(number)
  end
end
