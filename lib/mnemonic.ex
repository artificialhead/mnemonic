defmodule Mnemonic do
  @ets_table :mnemonic

  driver_type = Application.get_env(:mnemonic, :driver)
  driver = Application.get_env(:mnemonic_drivers, driver_type)

  defdelegate load, to: driver

  def start do
    load()
    |> cache_memory()
    {:ok}
  end

  @doc """
  Retrieve value from stored memory. If no value is found for particular key, default value will be returned. Dot notation can be used to retrieve nested value.

  ##Example
      Mnemonic.get "foo.bar.baz"
  """
  def get(key, default \\ nil) do
    if nested_elem?(key) do
      keys = String.split(key, ".")
      try do
        memory = find_from_memory(List.first(keys))

        if length(memory) > 0 do
          value = get_in memory, keys
          if !is_nil(value), do: value, else: default
        else
          default
        end
      rescue
        FunctionClauseError -> default
      end
    else
      memory = find_from_memory(key)
      if length(memory) > 0, do: memory, else: default
    end
  end

  def put(key, value) do

  end

  def forget(key) do

  end

  def flush do
    :ets.delete_all_objects(@ets_table)

    {:ok}
  end

  def persist do

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
    try do
      :ets.lookup(@ets_table, key)
      |> List.first()
      |> elem(1)
    rescue
      ArgumentError -> []
    end
  end

  defp nested_elem?(key),
    do: String.contains?(key, ".")
end
