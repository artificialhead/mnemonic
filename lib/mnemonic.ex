defmodule Mnemonic do
  @ets_table :mnemonic

  defdelegate load, to: Mnemonic.Ecto.Data

  def start do
    load()
    |> cache_memory()
    {:ok}
  end

  def get(key, default \\ nil) do
    if nested_elem?(key) do
      keys = String.split(key, ".")
      try do
        memory = find_from_memory(List.first(keys))
        |> get_in(List.delete_at(keys, 0))

        if !is_nil(memory), do: memory, else: default
      rescue
        FunctionClauseError -> default
      end
    else
      memory = find_from_memory(key)
      if length(memory) > 0, do: memory, else: default
    end
  end

  def put do

  end

  def forget do

  end

  def flush do

  end

  defp cache_memory(memories) do
    :ets.new(@ets_table, [:set, :protected, :named_table])
    Enum.each(memories, fn (memory) ->
      key =
        elem(memory, 0)
        |> to_string()
      value = elem(memory, 1)
      :ets.insert(@ets_table, {key, value})
    end)
  end

  defp find_from_memory(key) do
    :ets.lookup(@ets_table, key)
    |> List.first()
    |> elem(1)
  end

  defp nested_elem?(key),
    do: String.contains?(key, ".")
end
