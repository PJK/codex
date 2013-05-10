require 'yaml'

module Codex
  class Init < Subcommand
    def print
      opts = @opts[:full] ? @context.opts : @context.copts
      opts = opts.delete_if {|k, v| v.nil? || !Saveable.include?(k) }
      opts = Hash[opts.map {|x| [x[0].to_s, x[1]]}]
      Log.info("Opts to write: "  + opts.to_s)
      fname = File.absolute_path(File.join(@opts[:dir_given] ? @opts[:dir] : Dir.pwd, Dotname))
      Log.debug("File to write in: #{fname}")
      IO.write(fname, YAML.dump(opts))
    end
  end
end
