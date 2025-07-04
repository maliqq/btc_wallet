# frozen_string_literal: true

require_relative "lib/btc_wallet/version"

Gem::Specification.new do |spec|
  spec.name = "btc_wallet"
  spec.version = BtcWallet::VERSION
  spec.authors = ["Malik Bakti"]
  spec.email = ["malik@baktiyarov.com"]

  spec.summary = "BTC wallet in Signet."
  spec.description = "Simple BTC wallet to operate with transactions in Signet network."
  spec.homepage = "https://github.com/maliqq/btc_wallet"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "thor"
  spec.add_dependency "dotenv"
  spec.add_dependency "bitcoinrb"
  spec.add_dependency "activesupport"
  spec.add_dependency "rest-client"
  spec.add_dependency "colorize"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
