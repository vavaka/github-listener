module SpecHelpers
  module Fixture
    def fixture_path
      File.join(File.dirname(__FILE__), "fixtures")
    end

    def fixture(file)
      File.read(fixture_path + '/' + file)
    end
  end
end
