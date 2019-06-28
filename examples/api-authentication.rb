# frozen_string_literal: true

#
# solarisBank Digital Assets Platform API
#
# Authentication module for constructing API requests.
#
# Usage:
#   authentication_headers = API::Authentication.construct_headers(
#     "GET", "/v1/assets", "", "my-key-id", "f795...087d"
#   )
#
require "ed25519"
require "base64"
require "digest"

# API Authentication using HTTP Signatures
#
# HTTP Signatures draft 11:
# https://tools.ietf.org/html/draft-cavage-http-signatures-11
#
# HTTP Instance Digests:
# https://tools.ietf.org/html/rfc3230
# https://tools.ietf.org/html/rfc5843
#
# Ed25519:
# https://ed25519.cr.yp.to/
# https://github.com/crypto-rb/ed25519
#
module API
  module Authentication
    NONCE_HEADER = "X-Nonce"
    NONCE_SIZE   = 16 # bytes

    DIGEST_ALGORITHM = {
      sha256: { id: "SHA-256", class: Digest::SHA256 }
    }.freeze

    # Constructs authentication headers for a HTTP request
    #
    # @param request_method [String] HTTP request method, e.g. "POST" or "GET"
    # @param path [String] HTTP request path, including query parameters, e.g. "/foo?a=1"
    # @param body [String] HTTP request payload (body)
    # @param key_id [String] an ID of the Ed25519 signing key supplied with the request
    # @param key_seed [String] a hexadecimal string representation of the Ed25519 signing key seed
    #
    # @return [Hash] a set of HTTP headers
    #
    def self.construct_headers(request_method, path, body, key_id, key_seed)
      headers = {}
      headers["Digest"] = construct_digest(body)
      headers[NONCE_HEADER] = nonce
      headers["Signature"] = construct_signature_header(request_method, path, headers, key_id, key_seed)
      headers
    end

    # Constructs HTTP request payload digest as the value of Digest header
    # according to RFC 5843, using SHA-256 algorithm.
    #
    # See:
    # https://tools.ietf.org/html/rfc3230
    # https://tools.ietf.org/html/rfc5843
    #
    # @param body [String]
    # @return [String] value of the Digest header
    #
    def self.construct_digest(body)
      digest_bytes = DIGEST_ALGORITHM[:sha256][:class].digest(body)
      DIGEST_ALGORITHM[:sha256][:id] + "=" + Base64.strict_encode64(digest_bytes)
    end

    # Constructs Signature header according to HTTP Signatures draft v11.
    #
    # Headers covered by signature:
    #   "(request-target) (created) digest x-nonce"
    #
    # See:
    # https://tools.ietf.org/html/draft-cavage-http-signatures-11
    #
    # @param request_method [String] HTTP request method, e.g. "POST" or "GET"
    # @param path [String] HTTP request path, including query parameters, e.g. "/foo?a=1"
    # @param key_id [String] an ID of the Ed25519 signing key supplied with the request
    # @param key_seed [String] a hexadecimal string representation of the Ed25519 signing key seed
    #
    # @return [String] value of the Signature header
    #
    def self.construct_signature_header(request_method, path, headers, key_id, key_seed)
      params = {}

      params["keyId"] = key_id
      params["algorithm"] = "hs2019"
      params["created"] = Time.now.utc.to_i
      params["headers"] = "(request-target) (created) digest " + NONCE_HEADER.downcase
      signature_string = construct_signature_string(request_method, path, headers, params)
      params["signature"] = construct_signature_param(signature_string, key_seed)
      params.map { |name, value| "#{name}=#{value.inspect}" }.join(",")
    end

    # Constructs Signature String as dictated by 'headers' signature param
    #
    # @param request_method [String] HTTP request method, e.g. "POST" or "GET"
    # @param path [String] HTTP request path, including query parameters, e.g. "/foo?a=1"
    # @param headers [Hash]
    # @param signature_params [Hash]
    #
    # @return [String]
    #
    def self.construct_signature_string(request_method, path, headers, signature_params)
      signature_headers = signature_params["headers"].split(" ").map(&:downcase)
      signature_headers.map do |header_name|
        case header_name
        when "(request-target)"
          [header_name, request_method.downcase + " " + path]
        when "(created)"
          [header_name, signature_params["created"]]
        else
          header = headers.find { |name, _| name.downcase == header_name }
          raise "Header '#{header_name}' not found" unless header
          [header_name, header.last.strip]
        end
      end.map { |name, value| "#{name}: #{value}" }.join("\n")
    end

    # Constructs the actual signature of the message (canonical Signature String as per draft)
    #
    # As a first step the message is hashed using SHA-512, then a signature is produced
    # using Ed25519 and encoded using base64.
    #
    # @oaram signature_string [String] a Signature String
    # @param key_seed [String] a hexadecimal string representation of the Ed25519 signing key seed
    # @return [String] a base64 encoded signature
    #
    def self.construct_signature_param(signature_string, key_seed)
      digest = Digest::SHA512.digest(signature_string)
      key = Ed25519::SigningKey.new(h2b(key_seed))
      signature = key.sign(digest)
      Base64.strict_encode64(signature)
    end

    # Generates a new random API key
    #
    # @return [Hash] with :seed and :pub_key keys, as hexadecimal represenation
    #
    def self.generate_key_pair
      key = Ed25519::SigningKey.generate
      {
        seed: b2h(key.to_bytes),
        pub_key: b2h(key.verify_key.to_bytes)
      }
    end

    # Generates a pub_key from a seed
    #
    # @param seed [String] a hexadecimal representation of the seed
    # @return [String] a hexadecimal representation of the pub key
    #
    def self.pub_key_from_seed(seed)
      key = Ed25519::SigningKey.new(h2b(seed))
      b2h(key.verify_key.to_bytes)
    end

    # Constructs a random nonce
    #
    # @return [String]
    #
    def self.nonce
      SecureRandom.hex(NONCE_SIZE)
    end

    # Converts a hexadecimal string to a bytes array
    #
    # @param hex_string [String]
    # @return [String]
    #
    def self.h2b(hex_string)
      [hex_string].pack("H*")
    end

    # Converts a bytes array to a hexadecimal string
    #
    # @param bytes [String]
    # @return [String]
    #
    def self.b2h(bytes)
      bytes.unpack("H*").first
    end
  end # module Authentication
end # module API
