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
end
