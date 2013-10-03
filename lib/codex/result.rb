module Codex
  class Result < Subcommand
    def initialize(opts, context)
      super
      @context.login
    end

    def latest_id
     List.new({}, @context).fetch_submissions[0][:id] 
    end

    def print
      #raise Exception.new("Missing submission ID") unless @opts[:id]
      @opts[:id] = latest_id unless @opts[:id]
      url = "/?groupId=#{@context.opts[:group]}&taskId=#{@context.opts[:task]}&submitId=#{@opts[:id]}&module=groups%2Ftasks&page=submitInfo"
      if @opts[:fetch] then
        puts @context.get(url + "&download=1").body
        
      else
        puts @context.get(url).search('pre').shift.text
      end
    end
  end
end
