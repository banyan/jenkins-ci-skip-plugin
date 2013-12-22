source 'https://rubygems.org'

gem "jenkins-plugin-runtime", "~> 0.2.3"

group :development do
  gem "jpi", "~> 0.3.8"
  gem "jruby-openssl", "~> 0.8.8"
  gem "rake", "~> 10.0.4"
  gem "pry"

  # It should be set rspec 3.0.0.beta2 when it is released.
  # https://github.com/rspec/rspec-rails/issues/878#issuecomment-30575316
  %w[ core expectations mocks support ].each do |name|
    gem "rspec-#{name}", git: "https://github.com/rspec/rspec-#{name}.git", branch: 'master'
  end
end
