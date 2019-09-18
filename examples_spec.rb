############################################       expect(...).to eq       #############################################

class HelloWorld

  def say_hello
     "Hello World!"
  end

end

describe HelloWorld do
  context 'When testing the HelloWorld class' do

     it "should say 'Hello World' when we call the say_hello method" do
        hw = HelloWorld.new
        message = hw.say_hello
        expect(message).to eq "Hello World!"
     end

  end
end

############################################       expect(...).to be true/false       #############################################

class StringAnalyzer
  def has_vowels?(str)
     !!(str =~ /[aeiou]+/i)
  end
end

describe StringAnalyzer do
  context 'with valid input ' do
    it 'should detect when a string contains vowels' do
      sa = StringAnalyzer.new
      test_string = 'uuu'
      expect(sa.has_vowels? test_string).to be true
    end

    it 'should detect when a string doesnt contain vowels' do
      sa = StringAnalyzer.new
      test_string = 'bcdgf'
      expect(sa.has_vowels? test_string).to be false
    end
  end
end

############################################       expect(...).to be [<,>,=,...]       #############################################
############################################       expect(...).to be_between(#,#).inclusive/exclusive
############################################       expect(...).to match [REGEX]

describe 'An example of the equality Matchers' do
  it ' should show how the equality Matchers work' do
    a = 'test string'
    b = a

    # the following Expectations will all pass
    expect(a).to eq 'test string'
    expect(a).to eql 'test string'
    expect(a).to be b
    expect(a).to equal b
  end
end

describe 'An example of the comparison Matchers' do
  it ' should show how the comparison Matchers work' do
    a = 1
    b = 2
    c = 3
    d = 'test string'

    # the following Expectations will all pass
    expect(b).to be > a
    expect(b).to be >= a
    expect(a).to be < b
    expect(b).to be <= b
    expect(c).to be_between(1,3).inclusive
    expect(b).to be_between(1,3).exclusive
    expect(d).to match /TEST/i
  end
end

############################################       expect(...).to be_instance_of       #############################################
############################################       expect(...).to be_kind_of
############################################       expect(...).to be_respond_to(...)

describe 'An example of the type/class Matchers' do
  it ' should show how the type/class Matchers work' do
    x = 1
    y = 3.14
    z = 'test string'

    # the following expectations will all pass
    expect(x).to be_instance_of Fixnum    # when arg is instance of expected class
    expect(y).to be_kind_of Numeric       # when arg is instance of expected class OR any parent classes
    expect(z).to respond_to(:length)      # when arg responds to the specified method
  end
end

############################################       expect(...).to be true/false       #############################################
############################################       expect(...).to be_truthy/be_falsey/be_nil

describe 'An example of the true/false/nil Matchers' do
  it ' should show how the true/false/nil Matchers work' do
    x = true
    y = false
    z = nil
    a = 'test string'

    # the following Expectations will all pass
    expect(x).to be true
    expect(y).to be false
    expect(a).to be_truthy    # when arg is not false or nil
    expect(z).to be_falsey    # when arg is false or nil
    expect(z).to be_nil
  end
end

############################################       expect { ... }.to raise_error(...)       #############################################

describe 'An example of the error Matchers' do
  it 'should show how the error Matchers work' do

    # the following Expectations will all pass
    expect { 1/0 }.to raise_error(ZeroDivisionError)
    expect { 1/0 }.to raise_error('divided by 0')
    expect { 1/0 }.to raise_error('divided by 0', ZeroDivisionError)    # when block raises error of type ErrorClass with the message "error message"
  end
end

############################################       USING DOUBLES       #############################################

class ClassRoom
  def initialize(students)
     @students = students
  end

  def list_student_names
     @students.map(&:name).join(',')
  end
end

describe ClassRoom do
  it 'the list_student_names method should work correctly' do       # test doubles act as mock object so we can make sure we are testing the class we want to test
     student1 = double('student')
     student2 = double('student')

     allow(student1).to receive(:name) { 'John Smith'}
     allow(student2).to receive(:name) { 'Jill Smith'}

     cr = ClassRoom.new [student1,student2]
     expect(cr.list_student_names).to eq('John Smith,Jill Smith')
  end
end

############################################       RSPEC HOOKS (before_each, after_each ...)       #############################################

class SimpleClass
  attr_accessor :message

  def initialize
    puts "\nCreating a new instance of the SimpleClass class"
    @message = 'howdy'
  end

  def update_message(new_message)
    @message = new_message
  end
end

describe SimpleClass do
  before(:each) do
    @simple_class = SimpleClass.new
  end

  it 'should have an intitial message' do
    expect(@simple_class).to_not be_nil
    @simple_class.message = 'Something else'
  end

  it 'should be able to change its message' do
    @simple_class.update_message('a new message')
    expect(@simple_class.message).to_not be 'howdy'
  end
end

describe 'Before and after hooks' do
  before(:each) do
    puts 'Runs before each Example'
  end

  after(:each) do
    puts 'Runs after each example'
  end

  before(:all) do
    puts 'Runs before all examples'
  end

  after(:all) do
    puts 'Runs after all Examples'
  end

  it 'is the first Example in this spec file' do
    puts 'Running the first Example'
  end

  it 'is the second Example in this spec file' do
    puts 'Running the second Example'
  end
end

############################################       RSPEC TAGS (it 'is a slow test', :slow => true do)       #############################################

# describe 'How to run specific Examples with Tags' do
#   it 'is a slow test', :slow => true do
#     sleep 10
#     puts 'This test is slow!'
#   end
#   # to run: rspec --tag slow hello_world_spec.rb

#   it 'is a fast test', :fast => true do
#     puts 'This test is fast!'
#   end
#   # to run: rspec --tag fast hello_world_spec.rb
# end

############################################       RSPEC SUBJECTS (Shortening code to have object instantiation in 'describe' line)       #############################################

class Person
  attr_reader :first_name, :last_name

  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end
end

describe Person do    # NOT subject example!!
  it 'create a new person with a first and last name' do
    person = Person.new 'John', 'Smith'

    expect(person).to have_attributes(first_name: 'John')
    expect(person).to have_attributes(last_name: 'Smith')
  end
end

describe Person.new 'John', 'Smith' do    # THIS is the subject example!!
  it { is_expected.to have_attributes(first_name: 'John') }
  it { is_expected.to have_attributes(last_name: 'Smith') }
end

############################################       RSPEC HELPERS (Helper method when multiple tests are using the same code)       #############################################

class Dog
  attr_reader :good_dog, :has_been_walked

  def initialize(good_or_not)
    @good_dog = good_or_not
    @has_been_walked = false
  end

  def walk_dog
    @has_been_walked = true
  end
end

describe Dog do     # NOT using Helpers!!
  it 'should be able to create and walk a good dog' do
    dog = Dog.new(true)
    dog.walk_dog

    expect(dog.good_dog).to be true
    expect(dog.has_been_walked).to be true
  end

  it 'should be able to create and walk a bad dog' do
    dog = Dog.new(false)
    dog.walk_dog

    expect(dog.good_dog).to be false
    expect(dog.has_been_walked).to be true
  end
end

describe Dog do     # THIS is using Helpers!!
  def create_and_walk_dog(good_or_bad)
    dog = Dog.new(good_or_bad)
    dog.walk_dog
    return dog
  end

  it 'should be able to create and walk a good dog' do
    dog = create_and_walk_dog(true)

    expect(dog.good_dog).to be true
    expect(dog.has_been_walked).to be true
  end

  it 'should be able to create and walk a bad dog' do
    dog = create_and_walk_dog(false)

    expect(dog.good_dog).to be false
    expect(dog.has_been_walked).to be true
  end
end

############################################       RSPEC METADATA (Using data about the rspec example object itself)       #############################################

RSpec.describe 'An Example Group with a metadata variable', :foo => 17 do
  context 'and a context with another variable', :bar => 12 do

    it 'can access the metadata variable of the outer Example Group' do |example|
      expect(example.metadata[:foo]).to eq(17)
    end

    it 'can access the metadata variable in the context block' do |example|
      expect(example.metadata[:bar]).to eq(12)
    end
  end
end

RSpec.describe "An Example Group with a metadata variable", :foo => 17 do
  context 'and a context with another variable', :bar => 12 do

     it 'can access the metadata variable in the context block' do |example|
        expect(example.metadata[:foo]).to eq(17)
        expect(example.metadata[:bar]).to eq(12)

        example.metadata.each do |k,v|
          puts "#{k}: #{v}"
        end
     end
  end
end

############################################       RSPEC FORMATTERS (Adding flags on the rspec command to format output)       #############################################

RSpec.describe 'An Example Group with positive and negative Examples' do
  context 'when testing Ruby\'s built-in math library' do

    it 'can do normal numeric operations' do
      expect(1+1).to eq(2)
    end

    it 'generates an error when expected' do
      expect{ 1/0 }.to raise_error(ZeroDivisionError)
    end
  end
end

# rspec --format progress hello_world_spec.rb:338     # DEFAULT
# rspec --format doc hello_world_spec.rb:338          # DOCUMENTATION STYLE - prints out description strings
