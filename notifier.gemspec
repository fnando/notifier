require "./lib/notifier/version"

Gem::Specification.new do |s|
  s.name        = "notifier"
  s.version     = Notifier::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["fnando.vieira@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/notifier"
  s.summary     = "Send system notifications on several platforms with a simple and unified API. Currently supports Growl, Libnotify, OSD, KDE (Knotify and Kdialog) and Snarl"
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.requirements << "Growl, terminal-notifier, Libnotify, OSD, KDE (Knotify and Kdialog) or Snarl"

  s.add_development_dependency "minitest-utils"
  s.add_development_dependency "rake"
  s.add_development_dependency "mocha"
  s.add_development_dependency "codeclimate-test-reporter"
end
