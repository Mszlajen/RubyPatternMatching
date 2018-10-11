Gem::Specification.new do |s|
  s.name               = "RubyPatternMatching"
  s.version            = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matias Szlajen"]
  s.date = %q{2018-10-07}
  s.description = %q{An implementation of pattern matching for Ruby language }
  s.email = %q{mszlajen@est.frba.utn.edu.ar}
  s.files = ["lib/RubyPatternMatching.rb"]
  s.test_files = ['spec/matchers_tests/test_spec.rb,' 'spec/methods_tests/test_spec.rb']
  #s.homepage = %q{http://rubygems.org/gems/hola}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
