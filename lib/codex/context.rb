require 'yaml'
require 'mechanize'
require 'highline/import'

module Codex

  Dotname = '.codex'

  class Context
    attr_reader :opts, :welcome, :client, :dotopts, :copts
  
    def initialize(opts)
      @opts = opts
      @copts = opts.clone
      Log.debug("Opts for Context: #{opts.inspect}")
      def find_dotfiles(dirname)
        return [] if !File.readable?(dirname) || dirname == '/'
        upper = find_dotfiles(File.dirname(dirname))
        p = File.join(dirname, Dotname)
        upper += [p] if File.exists?(p)
        upper
      end
      def build_settings(dotfiles)
        opts = {}
        dotfiles.each do |file|
          f = YAML.parse_file(file).to_ruby
          if f then 
            opts.merge!(f) 
          else
            raise Exception.new("Couldn't read dotfile: #{file}")   
          end
        end
        opts
      end
      dotfiles = find_dotfiles(Dir.pwd)
      Log.debug("Dotfiles found: #{dotfiles.inspect}")
      @dotopts = build_settings(dotfiles)
      Log.debug("Dotopts: #{@dotopts.inspect}")
      #yaml gives us string keys
      @dotopts.each do |k, v|
        @opts[k.to_sym] = v if @opts[k.to_sym].nil?
      end
      Log.debug("Final opts: #{@opts.inspect}")
      raise Exception.new("Location empty") if @opts[:location].nil?
    end

    def login
      @opts[:password] = ask("Enter  password:  ") { |q| q.echo = "*" } unless @opts[:password]
      @client = Mechanize.new
      @client.log = Log
      @client.get(@opts[:location] + '/') do |p|
        @welcome = p.form_with(:action => "?action=login") do |f|
          f.login = @opts[:username]
          f.passwd = @opts[:password]
        end.submit
      end
      Log.debug "Arrived at: " +  @welcome.uri.to_s
      raise Exception.new("Couldn't log in. Are your credentials valid?") if (@welcome.uri.query =~ /welcome/).nil?
    end

    def get(url)
      @client.get(@opts[:location] + url)
    end

  end
end
