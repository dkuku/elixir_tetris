defmodule BottomTest do
  use ExUnit.Case

  import Tetris.Bottom
  test "various collisions" do
    bottom = %{{1,1} => {1,1,:blue}}

    assert collides?(bottom, [{1,1}])
    assert collides?(bottom, [{1,2},{1,1}])
    assert collides?(bottom, {1,1,:red})
    assert collides?(bottom, {1,1})
    refute collides?(bottom, [{1,2},{1,4}])
    refute collides?(bottom, [{1,2}])
    refute collides?(bottom, {1,0,:red})
    refute collides?(bottom, {1,2})
  end

  test "merge points" do
    bottom = %{{1,1} => {1,1,:blue}}

    actual = merge(bottom, [{1,2,:red},{1,4,:red}]) 
    expected = %{
      {1, 1} => {1, 1, :blue},
      {1, 2} => {1, 2, :red},
      {1, 4} => {1, 4, :red}
    }
    assert actual == expected
  end

  test "complete ys" do
    bottom = Map.put_new(complete_row(20), {1,19}, {1,19,:blue})

    assert complete_ys(bottom) == [20]
  end

  test "collapse single row and move down above rows" do
    bottom = Map.put_new(complete_row(20), {1,19}, {1,19,:blue})
    actual = collapse_row(bottom, 20)

    assert Enum.count(bottom) == 11
    assert Enum.count(actual) == 1
    assert Map.get(actual, {1, 20}) == {1, 20, :blue}
  end

  test " full collapse single row and move down above rows" do
    bottom = Map.put_new(complete_row(20), {1,19}, {1,19,:blue})
    {score, actual} = full_collapse(bottom)

    assert score == 1
    assert Enum.count(bottom) == 11
    assert Enum.count(actual) == 1
    assert Map.get(actual, {1, 20}) == {1, 20, :blue}
  end

  def complete_row(row, color \\ :red) do
    1..10
    |> Enum.map(fn x -> {{x, row}, {x, row, color}} end)
    |> Map.new
  end
end
