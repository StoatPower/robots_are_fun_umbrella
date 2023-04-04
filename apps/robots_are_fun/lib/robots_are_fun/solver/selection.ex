defmodule RobotsAreFun.Solver.Selection do

  @doc """
  Elitism selection strategy.

  Prefers the most elite chromosomes. Doesn't factor genetic diversity into
  the mix at all.

  Pros: Fast and simple
  Cons: Can lead to premature convergence

  Pair with stronger mutation, larger populations, or larger chromosomes to
  help counteract the lack of diversity in selection.
  """
  def elite(population, n) do
    population
    |> Enum.take(n)
  end

  @doc """
  Tournament selection strategy using duplicates.

  Pits chromosomes against one another in a tournament. Selections are still
  based on fitness, but tournament selection introduces a strategy to choose
  parents that are both diverse and strong. Tournament size affects the balance
  of selected parents.

  Pros:
    Useful for balancing both fitness and diveristy.
    Works well in parallel.
    Much faster than disallowing duplicates.
  Cons:
    Might not be appropriate for smaller populations.
    Risk of allowing population to become less genetically diverse compared
    to disallowing duplicates.
  """
  def tournament(population, n, tournament_size) do
    0..(n - 1)
    |> Enum.map(&tournament_selector/2)
  end

  defp tournament_selector(population, tournament_size) do
    population
    |> Enum.take_random(tournament_size)
    |> Enum.max_by(& &1.fitness)
  end
end
