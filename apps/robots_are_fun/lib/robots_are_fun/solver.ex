defmodule RobotsAreFun.Solver do
  @moduledoc """
  A solver that uses genetic algorithms to solve `RobotsAreFun.Solver.Problem`s.

  ## Genetic Algorithms in a Nutshell

  ### How does a genetic algorithm work?

  Genetic algorithms work via a series of `transformations` on `populations` of `chromosomes`
  over some number of `generations`. One generation represents one complete series of
  transformations. Ideally, the population that results from the subsequent generations
  have better solutions than previous ones.

  Every step in the process takes a population and produces a population for the next step.

  #### What is a chromosome?

  Chromosomes represent solutions to problems. Some problems are encoded using real values,
  some as permutations, and some using characters. The data structure is often a list, but
  sometimes the problem requires a different one to encode solutions. Specific encoding
  schemes vary from problem to problem.

  #### What is a population?

  A population is simply a collection of chromosomes. Usually, how you encode a population
  won't change--as long as the population is a series of chromosomes, it doesn't matter
  what data structure you use.

  The size of a population doesn't matter either. Bigger populations take longer to `transform`,
  but they may `converge` on a solution faster, whereas smaller populations are easier to
  transform, but they may take longer to converge.

  ### Overall Rules

  * **Rule 1** Encode chromosomes using a data structure that supports collections.
  * **Rule 2** Your algorithm should work on any population size.

  ### Step 1 - Initializing the Population

  The first step in every genetic algorithm is initializing the population, which is
  typically random. This is done with a `genotype` function, which is just a way to
  represent solutions.

  * **Rule 3** The initialization step must produce an initial population--a list of
      possible solutions.
  * **Rule 4** The function which initializes the population should be agnostic to how
      the chromosome is encoded. You can achieve this by accepting a function that returns
      a chromosome.

  ### Step 2 - Evaluating the Population

  The evaluation step is responsible for evaluating each chromosome based on some
  `fitness function` and `sorting` the population based on this fitness. The fitness
  function is a way to measure success.

  * **Rule 5** The evaluation step must take a population as input.
  * **Rule 6** The evaluation step must produce a population sorted by fitness.
  * **Rule 7** The function which evaluates the population should take a parameter
      that is a function that returns the fitness of each chromosome.
  * **Rule 8** The fitness function can return anything, as long as the fitness can be sorted.

  ### Step 3 - Selecting Parents

  Once sorted, you can begin selecting parents for reproduction. Selection is responsible
  for matching parents that will provide strong children. An initial selection method is
  simply pairing adjascent chromosomes. Later, different sorting mechanisms will be used.

  * **Rule 9** The selection step must take a population as input.
  * **Rule 10** The selection step must produce a transformed population that's easy
      to work with during crossover--say by returning a list of tuples which are pairs
      of parents.

  ### Step 4 - Creating Children

  Crossover is analagous to reproduction. The goal of crossover is to exploit the strengths
  of current solutions to find new, better solutions.

  * **Rule 11** The crossover step should take a list of 2-tuples (or parents) as input.
  * **Rule 12** Combine the 2-tuples, representing pairs of parents using a crossover technique.
  * **Rule 13** Return a population identical in size to the initial population.

  ### Step 5 - Creating Mutants

  The goal of mutation is to prevent premature convergence by transforming some of the
  chromosomes in the population. The mutation rate sould be kept relatively low--typically
  somewhere around 5%.

  * **Rule 14** The mutation step should accept a population as input.
  * **Rule 15** The mutation step should mutate _only some_ of the chromosomes in the
      population--the percentage should be relatively small.
  """

  @doc """
  Entry point for running a genetic algorithm.

  Follows the following rules:
    * Rule 1 - encodes chromosomes using a data structure supporting collections
    * Rule 2 - works on a population of any size

  ## Examples

    iex> RobotsAreFun.Solver.run(problem)

  """

  alias RobotsAreFun.Solver.{Chromosome, Crossover, Mutation, Selection}

  def run(problem, opts \\ []) do
    population = initialize(&problem.genotype/0, opts)

    population
    |> evolve(problem, 0, 0, 0, opts)
  end

  @doc """
  Recursive evolution function designed to model a single evolution
  in the genetic algorithm.

  ## Examples

    iex> RobotsAreFun.Solver.evolve(population, problem)

  """
  def evolve(population, problem, generation, last_max_fitness, temperature, opts \\ []) do
    population = evaluate(population, &problem.fitness_function/1, opts)

    best = hd(population)
    best_fitness = best.fitness
    temperature = 0.8 * (temperature + (best_fitness - last_max_fitness))
    IO.write("\rCurrent Best: #{best.fitness}")

    if problem.terminate?(population, generation, temperature) do
      best
    else
      generation = generation + 1

      {parents, leftover} = selection(population, opts)
      # obtain new children by passing parents into crossover
      children = crossover(parents, opts)
      # recombine children with leftover before mutating and continuing evolution
      (children ++ leftover)
      |> mutation(opts)
      # recurse
      |> evolve(problem, generation, best_fitness, temperature, opts)
    end
  end

  @doc """
  Step 1 - Initialize the population.

  Follows the following rules:
    * Rule 3 - produces the initial population
    * Rule 4 - is agnostic to how the chromosomes are encoded

  """
  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  @doc """
  Step 2 - Evaluation of the population.

  Follows the following rules:
    * Rule 5 - takes a population as first input
    * Rule 6 - produces a population sorted on fitness
    * Rule 7 - takes a fitness function as the second input, which
        takes a parameter that is a function that evaluates the fitness
        of each chromosome
    * Rule 8 - the fitness function can return anything, as long as it
        produces a sortable result

  """
  def evaluate(population, fitness_function, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      fitness = fitness_function.(chromosome)
      age = chromosome.age + 1
      %Chromosome{chromosome | fitness: fitness, age: age}
    end)
    |> Enum.sort_by(& &1.fitness, &>=/2)
  end

  @doc """
  Step 3 - Selection of parents in population.

  Accepts many different kinds of selection and defaults to `elite/2` which is what
  our initial, naive implementation did. Also accounts for different selection rates.

  Follows the following rules:
    * Rule 9 - takes a population as input
    * Rule 10 - produces a transformed population that easy's to work
        with during crossover

  """
  def selection(population, opts \\ []) do
    select_fn = Keyword.get(opts, :selection_type, &Selection.elite/2)
    select_rate = Keyword.get(opts, :selection_rate, 0.8)

    # `n` is the number of parents to select
    # the associated logic just ensures you have enough parents to make even pairs
    n = round(length(population) * select_rate)
    n = if rem(n, 2) == 0, do: n, else: n + 1

    # extract the parents using `apply/2` and the chosen selection strategy
    parents =
      select_fn
      |> apply([population, n])

    # determine who wasn't selected with the help of MapSet
    leftover =
      population
      |> MapSet.new()
      |> MapSet.difference(MapSet.new(parents))

    # turn the parents into tuples for corssover
    parents =
      parents
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple(&1))

    {parents, MapSet.to_list(leftover)}
  end

  @doc """
  Step 4 - Crossover: recombine selected parents into new children

  Accepts many types of crossover defaulting to "single point" crossover.

  Follows the following rules:
    * Rule 11 - takes a list of parents as input
    * Rule 12 - recombines the list of parents using a crossover function
    * Rule 13 - returns a population of the same size as input population

  """
  def crossover(population, opts \\ []) do
    crossover_fn = Keyword.get(opts, :crossover_type, &Crossover.single_point/2)
    repairment_fn = Keyword.get(opts, :repairment_fn)

    children =
      population
      |> Enum.reduce(
        [],
        fn {p1, p2}, acc ->
          {c1, c2} = apply(crossover_fn, [p1, p2])
          [c1, c2 | acc]
        end
      )

    if is_function(repairment_fn) do
      children
      |> Enum.map(&repairment_fn.(&1))
    else
      children
    end
  end

  @doc """
  Step 5 - Mutation to prevent premature convergence

  Accepts many types of mutation strategies defaulting to

  Follows the following rules:
    * Rule 14 - accepts a population as input
    * Rule 15 - mutates a small percentage of population
  """
  def mutation(population, opts \\ []) do
    mutate_fn = Keyword.get(opts, :mutation_type, &Mutation.flip/1)
    rate = Keyword.get(opts, :mutation_rate, 0.05)

    population
    |> Enum.map(fn chromosome ->
      if :rand.uniform() < rate do
        apply(mutate_fn, [chromosome])
      else
        chromosome
      end
    end)
  end
end
