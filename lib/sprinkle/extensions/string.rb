class String #:nodoc:
  
  # REVISIT: what chars shall we allow in task names?
  def to_task_name
    s = downcase
    s.gsub!(/-/, '_') # all - to _ chars
    s
  end

  def escape_for_win32_shell
    dup.escape_for_win32_shell!
  end
  
  def escape_for_win32_shell!
    gsub!(/"/, '""').gsub!(/%/, '%%').gsub!(/([|&^])/, '^\1')
    self
  end
  
end