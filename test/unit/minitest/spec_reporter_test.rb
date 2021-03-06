require_relative "../../test_helper"

module MinitestReportersTest
  class SpecReporterTest < Minitest::Test
    def setup
      @reporter = Minitest::Reporters::SpecReporter.new
      @test = Minitest::Test.new("")
      @test.time = 0
    end

    def test_removes_underscore_in_name_if_shoulda
      @test.name = "test_: Should foo"
      assert_output /test:/ do
        @reporter.io = $stdout
        @reporter.record(@test)
      end
    end

    def test_wont_modify_name_if_not_shoulda
      @test.name = "test_foo"
      assert_output /test_foo/ do
        @reporter.io = $stdout
        @reporter.record(@test)
      end
    end

    def test_responds_to_test_name_after_record
      test_name = 'test_: Should foo'
      the_test_class = Class.new(Minitest::Test) do
        define_method test_name do
          assert(false)
        end
      end
      the_test = the_test_class.new('')
      the_test.name = test_name
      @reporter.io = StringIO.new
      @reporter.record(the_test)
      assert_respond_to the_test, the_test.name
    end
  end
end
