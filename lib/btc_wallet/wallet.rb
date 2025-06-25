# frozen_string_literal: true

require "colorize"

module BtcWallet
  class Wallet
    extend StoreMethods
    include SendMethods

    attr_reader :key, :mempool_client, :logger
    # @param key [Bitcoin::Key]
    def initialize(key, mempool_client:, logger:)
      @key = key
      @mempool_client = mempool_client
      @logger = logger
    end

    def address
      key.to_p2wpkh
    end

    def balance
      data = mempool_client.address_info(address)
      logger.debug("Address info: #{data.inspect}".gray)

      data.dig("chain_stats", "funded_txo_sum").to_i - data.dig("chain_stats", "spent_txo_sum").to_i
    end

    # Build and sign Bitcon transaction than sends a specified amount to a given address.
    #
    # @param to_address [String] the destination Bitcoin address
    # @param amount [Integer] the amount to send in satoshis
    # @param fee [Integer] the transaction fee in satoshis (default: ::BtcWallet::DEFAULT_FEE)
    # @return [Bitcoin::Tx] the constructed and signed Bitcoin transaction
    def build_tx(to_address, amount, fee = ::BtcWallet::DEFAULT_FEE)
      selected_utxos, total_in = prepare_utxos(amount, fee)
      change = total_in - amount - fee

      Bitcoin::Tx.new.tap do |tx|
        add_inputs(tx, selected_utxos)

        add_output(tx, to_address, amount)
        add_output(tx, address, change) if change > 0

        sign_inputs(tx, selected_utxos)
      end
    end

    def send_with_proportional_fee(to_address, amount, fee_rate = ::BtcWallet::DEFAULT_FEE_RATE)
      dummy_tx = build_tx(to_address, amount)
      new_fee = dummy_tx.vsize * fee_rate

      logger.info "Sending to #{to_address} (amount=#{amount} fee=#{new_fee})"
      build_tx(to_address, amount, new_fee)
    end

    def send_and_broadcast(to_address, amount, fee = nil)
      tx =
        if fee
          logger.info "Sending to #{to_address} (amount=#{amount} fee=#{fee})"
          build_tx(to_address, amount, fee)
        else
          send_with_proportional_fee(to_address, amount)
        end

      broadcast(tx)
      tx
    end

    def broadcast(tx)
      logger.debug("Broadcasting TX: #{tx.to_hex}".gray)
      mempool_client.broadcast(tx)
    end

    private

    # Retrieves UTXOs for the wallet address.
    #
    # @raise [NoUTXOsAvailable] if no UTXOs are available for the address
    def utxos
      mempool_client.utxos(address).tap do |list|
        raise NoUTXOsAvailable, "No UTXOs available" if list.empty?
        logger.debug("Available UTXOs: #{list.inspect}".gray)
      end
    end
  end
end
