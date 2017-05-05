require 'net/http'
require 'multi_json'
require 'yaml'
require 'uri'
require 'digest/md5'

require "tx-ruby/version"
require "tx-ruby/resource_components/translation_components/utilities"
require "tx-ruby/crud_requests"
require "tx-ruby/errors"
require "tx-ruby/formats"
require "tx-ruby/project"
require "tx-ruby/projects"
require "tx-ruby/json"
require "tx-ruby/languages"
require "tx-ruby/language"
require "tx-ruby/project_components/language"
require "tx-ruby/project_components/language_components/coordinators"
require "tx-ruby/project_components/language_components/reviewers"
require "tx-ruby/project_components/language_components/translators"
require "tx-ruby/project_components/languages"
require "tx-ruby/resource"
require "tx-ruby/resource_components/content"
require "tx-ruby/resource_components/source"
require "tx-ruby/resource_components/stats"
require "tx-ruby/resource_components/translation"
require "tx-ruby/resource_components/translation_components/string"
require "tx-ruby/resource_components/translation_components/strings"
require "tx-ruby/resources"



module Transifex
  
  class Configuration 
    attr_accessor :client_login, :client_secret, :root_url

    def root_url
      @root_url ||= "https://www.transifex.com/api/2"      
    end 
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield configuration
  end

  def self.build_request_url(url='')
    URI(self.configuration.root_url + url)    
  end

  def self.query_api(method, url, params={})
    uri = build_request_url(url)

    res = Net::HTTP.start(uri.host, 80) do |http|
      req = Net::HTTP::const_get(method.capitalize).new(uri.request_uri, request_headers)
      req.basic_auth self.configuration.client_login, self.configuration.client_secret
      begin
        req.body = Transifex::JSON.dump(params)
      rescue Encoding::UndefinedConversionError
        params[:content] = params[:content].force_encoding("utf-8")
        req.body = Transifex::JSON.dump(params) 
      end
      http.request req
    end

    begin
      data = Transifex::JSON.load(res.body.nil? ? '' : res.body)
    rescue
      data = res.body
    end

    unless (res.is_a? Net::HTTPOK) || (res.is_a? Net::HTTPCreated) || (res.is_a? Net::HTTPNoContent)
      error = TransifexError.new(uri, res.code, data)
      raise error
    end    

    data
  end

  def self.request_headers    
    request_headers = {      
      'Content-Type' => 'application/json',
      'Accept' => 'application/json',
      'User-Agent' => "Transifex-interface-ruby/#{Transifex::VERSION}"
    }    
  end
end
