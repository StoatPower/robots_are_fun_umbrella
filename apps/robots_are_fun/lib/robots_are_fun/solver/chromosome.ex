defmodule RobotsAreFun.Solver.Chromosome do
  @moduledoc """
  A `Chromosome` is a possible solution to the problem being solved.

  At the most basic level, a chromosome is a single solution to your problem.
  It's a series of genes consisting of values known as _alleles_. Genes are
  typically represented using list types or other enumerable data types, like
  trees, sets, and arrays.
  """

  @type t :: %__MODULE__{
          genes: Enum.t(),
          size: integer(),
          fitness: number(),
          age: integer(),
          metadata: keyword()
        }

  @enforce_keys :genes
  defstruct [:genes, size: 0, fitness: 0, age: 0, metadata: []]

  def set_metadata(%__MODULE__{} = chromosome, metadata \\ []) when is_list(metadata) do
    if Keyword.keyword?(metadata) do
      %__MODULE__{chromosome | metadata: metadata}
    else
      raise Error, "not a keyword list"
    end
  end

  def put_metadata(%__MODULE__{metadata: metadata} = chromosome, key, value) when is_atom(key) do
    %__MODULE__{chromosome | metadata: Keyword.put(metadata, key, value)}
  end

  def fetch_metadata(%__MODULE__{metadata: metadata}, key) when is_atom(key) do
    Keyword.fetch(metadata, key)
  end

  def fetch_metadata(_, _), do: :error

  def fetch_metadata!(%__MODULE__{metadata: metadata}, key) when is_atom(key) do
    Keyword.fetch!(metadata, key)
  end

end
