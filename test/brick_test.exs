defmodule BrickTest do
  use ExUnit.Case

  import Tetris.Brick
  alias Tetris.Points
  test "Creates a new brick" do
    assert new_brick().name == :l
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
      |> assert_location({40, 0})
      |> left
      |> assert_location({39, 0})
      |> right
      |> assert_location({40, 0})
      |> right
      |> assert_location({41, 0})
      |> down
      |> assert_location({41, 1})
      |> assert_rotation(0)
      |> spin_90
      |> assert_rotation(90)
      |> spin_90
      |> assert_rotation(180)

    assert actual.name  == :l
    assert actual.rotation == 180
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
      |> Points.move_to_location({0,1})
      |> Points.move_to_location({1,0})

    assert  points == [{3, 2}, {3, 3}, {3, 4}, {3, 5}]
  end

  test "should translate a list of points" do
    [{1, 1}]
    |> Points.mirror 
    |> assert_point({4, 1})
    |> Points.flip 
    |> assert_point({4, 4})
    |> Points.rotate_90
    |> assert_point({1, 4})
    |> Points.rotate_90
    |> assert_point({1, 1})
  end

  test "should convert brick to string" do
    actual = new_brick(name: :l) |> Tetris.Brick.to_string
    expected = "    \n□□□ \n  □ \n    "

    assert actual == expected
  end

  test "should inspect brick" do
    actual = new_brick(name: :l) |> inspect
    expected = 
"""

    
□□□ 
  □ 
    
 location: {#{x_center()}, 0}
 reflection: false
 rotation: 0
"""

    assert "#{actual}\n" == expected
  end

  test "add color" do
    colors = ~w(blue orange yellow red green grey)a
    assert color(%{name: :l}) in colors
    assert color(%{name: :i}) in colors
    assert color(%{name: :o}) in colors
    assert color(%{name: :t}) in colors
    assert color(%{name: :z}) in colors

    actual = 
      new()
      |> shape
      |> Tetris.Points.with_color(:blue)

    assert actual == [{2, 1, :blue}, {2, 2, :blue}, {2, 3, :blue}, {3, 3, :blue}]
  end
  def assert_rotation(actual, expected) do
    assert actual.rotation == expected
    actual
  end
  def assert_location(actual, expected) do
    assert actual.location == expected
    actual
  end
  def assert_point([actual], expected) do
    assert actual == expected
    [actual]
  end
    
  def new_brick(attributes \\ []) do
    new(attributes)
  end
end
