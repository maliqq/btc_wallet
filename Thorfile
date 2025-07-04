require "dotenv"
require "pp"
require "pry"
require "colorize"

Dotenv.load(".env.local", ".env")

require "btc_wallet"

module BtwWallet
  class Main < Thor
    include Thor::Actions

    namespace :btc

    desc "create", "Create a test address"
    def create
      wallet = BtcWallet::Wallet.create_default!

      puts "Signet address: #{wallet.address}"
    end

    desc "address", "Address of your wallet"
    def address
      wallet = BtcWallet::Wallet.load_default!

      puts "Your address: #{wallet.address}"
    end

    desc "balance", "Show current balance in sats for a wallet"
    def balance
      wallet = BtcWallet::Wallet.load_default!

      puts "Balance for #{wallet.address}: #{wallet.balance}"
    end

    desc "send ADDRESS --amount <amount>", "Send amount to specific address"
    method_option :amount, aliases: "-n", type: :numeric, required: true, desc: "Amount in sats"
    method_option :fee, type: :numeric, desc: "Amount fee in sats"
    def send(to_address)
      wallet = BtcWallet::Wallet.load_default!
      tx = wallet.send_and_broadcast(to_address, options[:amount], options[:fee])

      puts "Transaction ID: #{tx.txid}"
    rescue ::BtcWallet::AmountTooSmall
      puts "Amount is too small! Try another amount".red
    end
  end
end
