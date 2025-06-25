# frozen_string_literal: true

module BtcWallet
  module StoreMethods
    WALLET_KEY_FILE_ENV = "BTC_WALLET_KEY_FILE"

    # defaults
    def default_key_file
      Pathname.new(
        ENV.fetch(WALLET_KEY_FILE_ENV) {
          File.expand_path("../../priv/#{Etc.getlogin}.key", __dir__)
        }
      )
    end

    def default_logger
      Logger.new($stdout)
    end

    def default_mempool_client
      MempoolClient.new(
        ENV.fetch("MEMPOOL_API_BASE_ADDR", DEFAULT_MEMPOOL_BASE_ADDR)
      )
    end

    def create_default!
      new(
        create_key(default_key_file),
        mempool_client: default_mempool_client,
        logger: default_logger
      )
    end

    def load_default!(logger: nil)
      new(
        load_key(default_key_file),
        mempool_client: default_mempool_client,
        logger: logger || default_logger
      )
    end

    # keys
    def create_key(key_path)
      Bitcoin::Key.generate.tap do |key|
        key_path.write(key.to_wif)

        FileUtils.chmod(0o600, key_path)
      end
    end

    def load_key(key_path)
      raise "Key file not found: #{key_path}" unless File.exist?(key_path)

      Bitcoin::Key.from_wif(File.read(key_path).strip)
    end
  end
end
