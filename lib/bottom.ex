defmodule Tetris.Bottom do
  def merge(bottom, points) do
    points
    |> Enum.map(fn {x,y,c}-> {{x,y}, {x,y,c}} end)
    |> Enum.into(bottom)
  end

  def collides?(bottom, {x, y, _}), do: collides?(bottom, {x, y})
  def collides?(bottom, {x, y}) do
    !!Map.get(bottom, {x, y}) || x < 1 || x > 10 || y > 20
  end
  def collides?(bottom, points) when is_list(points) do
    Enum.any?(points, &collides?(bottom, &1))
  end


  @spec complete_ys(map()) :: map()
  def complete_ys(bottom) do
    bottom
    |> Map.keys
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq
    |> Enum.filter(fn row -> complete?(bottom, row) end)
  end

  def complete?(bottom, row) do
    bottom
    |> Map.keys
    |> Enum.filter(fn {_x, y} -> y == row end)
    |> Enum.count
    |> Kernel.==(10)
  end

  def collapse_row(bottom, row) do
    delete_keys = deleted_row_keys(bottom, row)
    bottom
    |> Map.drop(delete_keys)
    |> Enum.map(&move_point_down(&1, row))
    |> Map.new
  end

  def move_point_down({{x,y}, {x,y,color}}, row) when y < row do
    {{x, y + 1}, {x , y+1 , color}}
  end

  def move_point_down(point, _row), do: point

  def deleted_row_keys(bottom, row) do
    bottom
    |> Map.keys
    |> Enum.filter(fn {_x, y} -> y == row end)
  end

  def full_collapse(bottom) do
    complete_rows = 
      bottom
      |> complete_ys
      |> Enum.sort
    collapse_count = Enum.count(complete_rows)

    new_bottom =
      Enum.reduce(complete_rows, bottom, &collapse_row(&2, &1))

    {collapse_count, new_bottom}
  end
end
