defmodule Tetris do
  alias Tetris.{ Brick, Bottom, Points }

  def prepare(brick) do
    brick
    |> Brick.prepare
    |> Points.move_to_location(brick.location)
  end

  def try_move(brick, bottom, f) do
    new_brick = f.(brick)

    if Bottom.collides?(bottom, prepare(new_brick)) do
      brick
    else
      new_brick 
    end
  end

  def drop(brick, bottom, score) do
    dropped_brick = Brick.down(brick)

    Bottom.collides?(bottom, prepare(dropped_brick))
    |> do_drop(brick, bottom, score)
  end

  def do_drop(true=_collides, brick, bottom, score) do
    new_brick = Brick.new_random()
    points = 
      brick 
      |> prepare
      |> Points.with_color(Brick.color(brick))

    {deleted_rows, new_bottom} = 
      bottom
      |> Bottom.merge(points)
      |> Bottom.full_collapse

    %{
      brick: new_brick,
      bottom: new_bottom,
      score: score + compute_score(deleted_rows),
      game_over: Bottom.collides?(new_bottom, prepare(new_brick))
    }
  end

  def do_drop(false=_collides, brick, bottom, score) do
    %{
      brick: Brick.down(brick),
      bottom: bottom,
      score: score,
      game_over: false
    } 
  end

  def try_left(brick, bottom), do: try_move(brick, bottom, &Brick.left/1)
  def try_right(brick, bottom), do: try_move(brick, bottom, &Brick.right/1)
  def try_down(brick, bottom), do: try_move(brick, bottom, &Brick.down/1)
  def try_spin(brick, bottom), do: try_move(brick, bottom, &Brick.spin_90/1)

  def compute_score(0), do: 0
  def compute_score(complete_row_count), do: round( 100 * :math.pow(2, complete_row_count - 1) )
end
