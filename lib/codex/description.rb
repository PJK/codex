module Codex
  class Description < Subcommand
    def initialize(opts, context)
      super
      @context.login
    end

    def print
      p = @context.get("/?groupId=#{@context.opts[:group]}&taskId=#{@context.opts[:task]}&module=groups%2Ftasks&page=specification")
      puts p.search('.specification_in').pop.text.gsub(/([\t\r\n]){2,}/, '\1').strip 
    end
  end
end
