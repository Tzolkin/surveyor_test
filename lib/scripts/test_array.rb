class TestArray
  def initialize(size = 10)
    @numbers = build_numbers(size)
  end

  def find_missing_numbers
    array = @numbers.sort
    missing_numbers = []
    array.each_with_index do |number, index|
      next if index >= array.size - 1

      missing_part = ((number + 1)..(array[index + 1] - 1)).to_a
      missing_numbers << missing_part
    end
    missing_numbers.flatten.sort
  end

  private

  def build_numbers(size)
    array = []
    loop do
      number = rand(1...50)
      array << number unless array.include?(number)
      return array if array.size >= size
    end
  end
end

test = TestArray.new
test.instance_eval { puts @numbers.join(', ') }
puts test.find_missing_numbers.join(', ')
