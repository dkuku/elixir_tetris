defmodule Tetris.Points do
  def translate(points, {x,y}) do
    points
    |> Enum.map(fn {dx, dy} -> {dx + x, dy + y} end)
  end

  def transpose(points) do
    points |>
    Enum.map(fn {x, y} ->  {y, x} end)
  end

  def mirror(points) do
    points |>
    Enum.map(fn {x, y} ->  {4-x, y} end)
  end

  def flip(points) do
    points |>
    Enum.map(fn {x, y} ->  {x, 4-y} end)
  end

  def rotate(points, 0), do: points
  def rotate(points, degrees) do
    rotate(
      rotate_90(points),
      degrees - 90
    )
  end
  defp rotate_90(points) do
    points
    |> transpose
    |> mirror
  end
end
