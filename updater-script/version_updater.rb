#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rest_client'
require 'json'
require 'yaml'

# Script to hit the /info endpoint for all the deployed microservices to obtain the version information.
class VersionUpdater
  # Handle Ctrl + C gracefully.
  trap('INT') { exit }

  def initialize
    @config = YAML.load_file(File.join(__dir__, 'config.yml'))
    @logger = Logger.new($stdout)

    @config['environments'].each do |environment|
      @config['services'].each do |service, app_name|
        host     = host_for_environment(environment)
        protocol = protocol_for_environment(environment)
        info_url = "#{protocol}://#{app_name}-#{environment}.#{host}/info"
        @logger.info "#{environment}/#{service} has version #{service_version(info_url)}"
      end
    end
  end

  private

  def host_for_environment(environment)
    environment.include?('prod') ? @config['hosts']['production'] : @config['hosts']['development']
  end

  def protocol_for_environment(environment)
    environment.include?('prod') ? 'https' : 'http'
  end

  def service_version(info_url)
    RestClient.get(info_url) do |response, _request, _result, &_block|
      return JSON.parse(response)['version'] unless response.code == 404
    end

    'N/A'
  end
end

VersionUpdater.new
