require "rest-client"

module BtcWallet
  class MempoolClient
    attr_reader :base_addr

    def initialize(base_addr)
      @base_addr = base_addr
    end

    def address_info(address)
      resp = RestClient.get("#{base_addr}/address/#{address}")
      JSON.parse(resp.body)
    end

    def utxos(address)
      resp = RestClient.get("#{base_addr}/address/#{address}/utxo")
      JSON.parse(resp.body)
    end

    def broadcast(tx)
      resp = RestClient.post(
        "#{base_addr}/tx",
        tx.to_hex,
        {content_type: "text/plain"}
      )
      resp.body
    rescue RestClient::BadRequest => e
      raise MempoolError, e.response.body
    end
  end
end
