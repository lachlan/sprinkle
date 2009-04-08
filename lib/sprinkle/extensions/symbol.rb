class Symbol #:nodoc:
  include Comparable

  def to_task_name
    to_s.to_task_name
  end

  def <=>(other)
    self.to_s <=> other.to_s
  end
end