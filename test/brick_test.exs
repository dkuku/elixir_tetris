defmodule BrickTest do
  use ExUnit.Case

  import Tetris.{Brick, Points}
  test "Creates a new brick" do
    assert new_brick().name == :o
  end

  test "Creates a new random brick" do
    actual = new_random()
    assert actual.name in [:i, :o, :l, :z, :t]
    assert actual.rotation in [0, 90, 180, 270]
    assert actual.reflection in [true, false]
  end

  test "should manipulate brick" do
    actual = 
      new_brick()
      |> left
      |> right
      |> right
      |> down
      |> spin_90

    assert actual.name  == :o
    assert actual.rotation == 90
    assert actual.location == {41, 1}
  end

  test "should return points for i shape" do
    points = 
      new_brick(name: :i)
      |> shape()

    assert  points == [{2, 1}, {2, 2}, {2, 3}, {2, 4}]
  end

  test "Each block has a length of 4" do
    [:i, :l, :o, :z, :t]
    |> Enum.map(fn name -> new_brick(%{name: name}) |> shape end)
    |> Enum.each(fn points -> 
      assert length(points) == 4
    end)
  end

  test "should translate a point" do
    points = 
      new_brick(name: :i)
      |> shape()
      |> translate({0,1})
      |> translate({1,0})

    assert  points == [{3, 2}, {3, 3}, {3, 4}, {3, 5}]

  end
  def new_brick(attributes \\ []) do
    new(attributes)
  end
end
