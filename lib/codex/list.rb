# encoding: utf-8

module Codex
  class List < Subcommand
    def initialize(opts, context)
      super
      @groups = []
      @context.login
    end

    def print
      if @context.opts[:task] && !@opts[:tasks] && !@opts[:groups] then
        print_submissions
      elsif @context.opts[:group] && !@opts[:groups] then
        print_tasks
      else 
        print_groups
      end
    end

    def print_groups 
      fetch_groups
      @groups.each {|x| puts sprintf("%-40s %5d", x[:name], x[:id])}
    end

    def fetch_tasks
      @tasks = @context.get("/?groupId=#{@context.opts[:group]}&C2_amount=0&module=groups%2Ftasks").search('table tr')[1..-1].map do |x|
        td = x.search('td')
        points = td[2].text.match(/Přiděleno: (\d+)Max.: (\d+)/)
        ret =  {
          :name => x.search('.cellHeader').pop.text.strip,
          :points => {
            :max => points[2],
            :attained => points[1],
          },
          :id => td[0].search('a').pop.get_attribute('href').match(/taskId=(\d+)/)[1]
        }
      end
    end

    def print_tasks
      fetch_tasks.each {|x| puts("%-40s %2d/%-2d %10d" % [x[:name], x[:points][:attained], x[:points][:max], x[:id]])}
    end

    def fetch_submissions
      s = @context.get("/?groupId=#{@context.opts[:group]}&taskId=#{@context.opts[:task]}&module=groups%2Ftasks&page=submits")
      t = s.search('table')[2].search('tr')[1..-1]
      res = t.map do |x|
        tds = x.search('td')
        {
          :date => tds[1].text.strip,
          :extension => tds[4].text.strip,
          :rating => tds[5].text.strip,
          :comment => tds[7].text.strip,
          :id => tds[8].search('a').pop.get_attribute('href').match(/&download=(\d+)/)[1]
        }
      end
    end


    def print_submissions
       fetch_submissions.each {|x| puts("%-26<date>s %-4<extension>s %-6<rating>s %-6<id>d %40<comment>s" % x)}
    end

    private

    def fetch_groups
      l = @context.get('/?module=groups').links_with(:href => /tasks/)
      l.each {|x| @groups << {:name => x.text, :id => x.href.match(/^\?groupId=(\d+)/)[1]}}
    end
  end
end
