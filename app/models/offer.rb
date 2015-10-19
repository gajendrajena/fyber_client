require 'rest-client'
require 'cgi'
require 'json'

class Offer
  API_URL = 'http://api.sponsorpay.com/feed'
  API_VERSION = 1
  CONFIGURABLES = [:api_key, :appid, :format, :locale, :ip, :device]

  attr_accessor :logger, :api_key, :appid, :format, :locale, :ip, :device

  def initialize(options = {})
    CONFIGURABLES.each do |key|
      #for missing mandatory parameters issue an error
      check_required_parameter(key, options[key]) unless [:format, :locale].include?(key)
      instance_variable_set(:"@#{key}", options[key])
    end
  end

  def get(endpoint, params)
    uri = api_uri(endpoint)
    begin
      response = RestClient.get(uri, params: parameters(params))
    rescue => e
      raise Fyber::ServerError, e.message
    end
    response || {}
  end

  def offers(filters = {})
    # check required keys
    [:offer_types, :uid, :pub0].each do |key|
      check_required_parameter(key, filters[key])
    end
    filters[:timestamp] = Time.now.to_i
    filters[:page] ||= 1
    # Get offers
    response = get(offers_path, filters)
    data = JSON.parse(response)
    data['offers']
  end

  private

  def offers_path
    'offers'
  end

  def api_uri(endpoint)
    "#{API_URL}/v#{API_VERSION}/#{endpoint}.#{format}"
  end

  def parameters(list = {})
    CONFIGURABLES.each do |key|
      list[key] = instance_variable_get(:"@#{key}") unless key == :format
    end
    # sort alphabetically
    list = Hash[list.sort]
    params_string = list.collect { |k, v| "#{k.to_s}=#{CGI::escape(v.to_s)}" }.join('&')
    params_string = "#{params_string}&#{api_key}"
    list[:hashkey] = Digest::SHA1.hexdigest(params_string)
    list
  end

  def check_required_parameter(key, value)
    raise Fyber::ClientError, "Required parameter #{key.to_s} is not set" if value.nil?
  end

  # default config
  def format
    @format || FYBER_CONFIG['format']
  end

  def locale
    @locale || FYBER_CONFIG['locale']
  end
end

module Fyber
  class ClientError < StandardError; end
  class ServerError < StandardError; end
end