defmodule RobotsAreFun.Solver.Problem do
  @moduledoc """
  A behaviour for defining the necessary functions belonging to a solver.
  """

  alias Types.Chromosome

  @callback genotype(keyword()) :: Chromosome.t()

  @callback fitness_function(Chromosome.t(), keyword()) :: number()

  @callback terminate?(Enum.t(), integer(), integer()) :: boolean()

  @callback repair_chromosome(Chromosome.t()) :: Chromosome.t()
end
