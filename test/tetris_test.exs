defmodule TetrisTest do
  use ExUnit.Case
  import Tetris
  alias Tetris.{ Brick }

  test "move right successfull" do
    brick = Brick.new(location: {5, 1})
    bottom = %{}

    expected = brick |> Brick.right
    actual = Tetris.try_right(brick, bottom)

    assert actual == expected
  end
  test "move right failed - return original brick" do
    brick = Brick.new(location: {7, 1})
    bottom = %{}

    actual = Tetris.try_right(brick, bottom)

    assert actual == brick
  end

  test "drops without merging" do
    brick = Brick.new(location: {5, 1})
    bottom = %{}
    score = 0

    actual = Tetris.drop(brick, bottom, score)

    assert actual.brick == Brick.down(brick)
    assert actual.bottom == bottom
    assert actual.score == score
  end
  test "drops with merging" do
    brick = Brick.new(location: {5, 17})
    bottom = %{}
    score = 100

    actual = Tetris.drop(brick, bottom, score)

    assert actual.brick != Brick.down(brick)
    assert actual.brick != brick
    assert actual.brick.location == {40, 0}
    assert Enum.all?(Map.keys(bottom), &is_tuple(actual.bottom[&1]))
    assert actual.score == score
  end

  test "drops with merging multiple rows" do
    score = 0
    brick = Brick.new(location: {5, 16}, name: :i)
    bottom = 
      for x <- 1..10, y <- 17..20, x != 7 do
        {{x,y}, {x,y, :blue}}
      end
      |> Map.new

    %{score: score, bottom: bottom, brick: brick} = 
      Tetris.drop(brick, bottom, score)

    assert brick.location == {40, 0}
    assert bottom == %{}
    assert score == 800
  end

  test "compute score" do
    assert 0 == compute_score(0)
    assert 100 == compute_score(1)
    assert 200 == compute_score(2)
    assert 400 == compute_score(3)
    assert 800 == compute_score(4)
  end
end
