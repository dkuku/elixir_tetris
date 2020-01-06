defmodule BrickTest do
  use ExUnit.Case

  import Tetris.Brick
  test "Creates a new brick" do
    assert new_brick().name == :o
  end

  test "Creates a new random brick" do
    actual = new_random()
    assert actual.name in [:i, :o, :l, :z, :t]
    assert actual.rotation in [0, 90, 180, 270]
    assert actual.reflection in [true, false]
  end

  def new_brick() do
    Tetris.Brick.new()
  end
end
