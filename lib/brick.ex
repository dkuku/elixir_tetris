defmodule Tetris.Brick do
  defstruct [
    name: :o,
    location: {40, 0},
    rotation: 0,
    reflection: false
  ]
  @names ~w(i z o t l)a

  def new(), do: __struct__()
  def new_random() do
    %{
    name: random_name(),
    location: {40, 0},
    rotation: random_rotation(),
    reflection: random_reflection()
    }
  end

  def random_reflection() do
    [true, false]
    |> Enum.random
  end
  def random_rotation() do
    [0, 90, 180, 270]
    |> Enum.random
  end
  def random_name() do
    @names
    |> Enum.random
  end
end
