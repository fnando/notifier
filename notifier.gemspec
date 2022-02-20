# frozen_string_literal: true

require "./lib/notifier/version"

Gem::Specification.new do |s|
  s.name        = "notifier"
  s.version     = Notifier::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nando Vieira"]
  s.email       = ["me@fnando.com"]
  s.homepage    = "http://rubygems.org/gems/notifier"
  s.summary     = "Send system notifications on several platforms with a " \
                  "simple and unified API. Currently supports Libnotify, " \
                  "OSD, KDE (Knotify and Kdialog) and Snarl"
  s.description = s.summary
  s.required_ruby_version = ">= 2.7"
  s.metadata["rubygems_mfa_required"] = "true"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map do |f|
    File.basename(f)
  end
  s.require_paths = ["lib"]

  s.requirements << "terminal-notifier, Libnotify, OSD, KDE (Knotify and " \
                    "Kdialog) or Snarl"

  s.add_development_dependency "minitest-utils"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rake"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "rubocop-fnando"
  s.add_development_dependency "simplecov"
end
