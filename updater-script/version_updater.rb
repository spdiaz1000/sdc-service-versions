#!/usr/bin/env ruby
# frozen_string_literal: true

require 'rest-client'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'thor'
require 'yaml'

# Script to hit the /info endpoint for all the deployed microservices to obtain the version information.
class VersionUpdater < Thor
  # Handle Ctrl + C gracefully.
  trap('INT') { exit }

  def initialize(*args)
    super
    @config = YAML.load_file(File.join(__dir__, 'config.yml'))
  end

  desc 'all', 'Display all deployed service versions'
  def all
    for_each_service_and_environment(method(:output_service_version))
  end

  desc 'diff', 'Display only deployed service versions that differ from those in the sdc-service-versions Git repo'
  def diff
    for_each_service_and_environment(method(:output_service_version_diff))
  end

  private

  def host_for_environment(environment)
    environment.include?('prod') ? @config['hosts']['production'] : @config['hosts']['development']
  end

  def protocol_for_environment(environment)
    environment.include?('prod') ? 'https' : 'http'
  end

  def for_each_service_and_environment(method)
    github_repo = @config['sdc-versions-repo-url']
    @config['environments'].each do |environment|
      @config['services'].each do |service, app_name|
        github_url = "#{github_repo}/#{environment}/services/#{service}.version"
        host       = host_for_environment(environment)
        protocol   = protocol_for_environment(environment)
        info_url   = "#{protocol}://#{app_name}-#{environment}.#{host}/info"
        method.call(environment, service, info_url, github_url, github_repo)
      end
    end
  end

  def output_service_version(environment, service, info_url, _github_url, _github_repo)
    version = service_version(info_url)
    puts "#{environment}/#{service} has version #{version[0]}, commit #{version[1]}"
  end

  def output_service_version_diff(environment, service, info_url, github_url, github_repo)
    github_url      = "#{github_repo}/#{environment}/services/#{service}.version"
    github_version  = github_service_version(github_url)
    service_version = service_version(info_url)
    puts "#{environment}/#{service} has version #{service_version[0]} and GitHub version #{github_version}" if github_version != service_version[0]
  end

  def github_service_version(github_url)
    doc = Nokogiri::HTML(open(github_url))
    doc.xpath('//body').text if doc
  rescue OpenURI::HTTPError
    'N/A'
  end

  def service_version(info_url)
    begin
      RestClient.get(info_url) do |response, _request, _result, &_block|
        unless response.code == 404
          return JSON.parse(response)['version'], JSON.parse(response)['commit'][0, 7]
        end
      end
    rescue RestClient::Exceptions::OpenTimeout
      STDERR.puts "Timed out connecting to #{info_url}"
    end

    ['N/A', 'N/A']
  end
end

VersionUpdater.start(ARGV)
