class FaqCategoryPolicy < AllUserAccess
  def move_up?
    user
  end

  def move_down?
    user
  end
end