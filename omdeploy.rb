require 'thor'
require 'omsignal/backend/build'

module OMsignal
  module Cli
    class Backend < Thor
      private

      @@default_services = OMsignal::Backend::all_services
      @@default_services_s = @@default_services.join(", ")

      def self.backend_build_options
        method_option :version, :type => :string, :default => :latest, :aliases => '-v', :desc => 'The version to build'
        method_option :clean, :type => :boolean, :default => true, :aliases => '-c', :desc => 'Clean the project before building'
        method_option :services, :type => :array, :default => @@default_services, :aliases => '-s', :desc => 'Restrict the services to build'
        method_option :fetch, :type => :boolean, :default => true, :aliases => '-f', :desc => 'Fetch the git repo before checking out a particular version'
      end

      public

      desc 'build', "build packages for the backend services"
      backend_build_options
      def build
        build = OMsignal::Backend::Build.new(options)
        build.build
      end

      desc 'publish-local', "publish the packages to the local repository"
      backend_build_options
      method_option :build, :type => :boolean, :default => true, :aliases => '-b', :desc => 'Build before publishing'
      def publish_local
        build = OMsignal::Backend::Build.new(options)
        build.publish_local
      end

    end

  end
end