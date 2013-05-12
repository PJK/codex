# encoding: utf-8 

module Codex
  class Submit < Subcommand
    def initialize(opts, context)
      super
      @context.login
    end

    def print
      raise Exception.new("File not found/readable") unless File.readable?(@opts[:file])
      @opts[:lang] = guess_lang unless @opts[:lang_given]
      p = @context.get("/?groupId=#{@context.opts[:group]}&taskId=#{@context.opts[:task]}&module=groups%2Ftasks&page=newSubmit")
      f = p.forms[1]
      f.radiobuttons_with(:value => /file/).pop.check
      lang = f.radiobuttons_with(:value => @opts[:lang])
      raise Exception.new("Language #{@opts[:lang]} not allowed for this task") if lang.empty?
      lang.pop.check
      f.newSubmitForm_comment = @opts[:comment]
      f.file_upload.file_name = @opts[:file]
      res = @context.client.submit(f, f.buttons[0])
      raise Exception.new("Failure. Please enable debugging mode and retry") unless res.title =~ /Odevzdaná/
      return if @opts[:quick]
      #TODO - poll until results are really available
      Result.new({}, @context).print 
    end

    private

    def guess_lang
      g = File.extname(@opts[:file]).sub '.', ''
      raise Exception.new("Unknown language: #{g}") unless Extensions.include? g
      g
    end

  end
end
