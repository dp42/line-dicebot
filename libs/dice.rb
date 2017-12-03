class Dice
  def initialize(expression)
    @expression = expression
    @pattern  = /^([1-9][0-9]?)?[dD]([1-9][0-9]?[0-9]?) ?([+-])? ?([1-9][0-9]?[0-9]?)? ?(>|<|>=|<=)? ?([1-9][0-9]?[0-9]?)?$/
    @sum = 0
    @dice = 1
    @sides = 6
    @adjuster
    @adustment_value
    @objective
    @judgement_condition
  end

  def roll(expression = nil)
    @expression = expression ? expression : @expression

    return nil unless valid?

    parse

    @sum = 0

    @dice.times do
      @sum += rand(@sides) + 1
    end

    adjust_sum if @adjuster

    if @judgement_condition
      judge
      result = "\u{1F3B2} [#{@expression}] ==> #{@sum}[#{@judgement}]"
    else
      result = "\u{1F3B2} [#{@expression}] ==> #{@sum}"
    end
  end

  def valid?
     @expression.match?(@pattern)
  end

  def parse
    parsed = @expression.match(@pattern)
    @dice = parsed[1] ? parsed[1].to_i : 1
    @sides = parsed[2].to_i
    @adjuster = parsed[3]
    @adjustment_value = parsed[4].to_i
    @judgement_condition = parsed[5]
    @objective = parsed[6].to_i
  end

  def adjust_sum
    @sum = case @adjuster
           when '+'
             @sum + @adjustment_value
           when '-'
             @sum - @adjustment_value
           end
  end

  def judge
    suceeded = "成功\u{2B55}"
    failed = "失敗\u{1F480}"

    @judgement = case @judgement_condition
                 when '>'
                   @sum > @objective ? suceeded : failed
                 when '<'
                   @sum < @objective ? suceeded : failed
                 when '>='
                   @sum >= @objective ? suceeded : failed
                 when '<='
                   @sum <= @objective ? suceeded : failed
                 end
  end
end
