defmodule Mnemonic do
  @ets_table :mnemonic
  @driver Application.get_env(:mnemonic, :driver)

  def load do
    apply(@driver, :load, [])
    |> create_cache()
    {:ok}
  end

  @doc """
  Retrieve value from stored memory. If no value is found for particular key, default value will be returned. Dot notation can be used to retrieve nested value.

  ##Example
      Mnemonic.get "foo.bar.baz"
  """
  def get(key, default \\ nil) do
    if nested_elem?(key) do
      [key | nested_keys] = String.split(key, ".")
    else
      nested_keys = key
    end

    find_from_memory(key)
    |> traverse_memory(nested_keys, default)
  end

  @doc """
  Insert or update the stored memory. If the key does not exists, it will insert a new key and value into the memory.

  ##Example
      Mnemonic.put "foo.bar", "new_value"
  """
  def put(key, value) do
    if !is_nil(get(key)) do
      replace_existing_memory(key, value)
      {:ok}
    else
      cache_memory(key, value)
      {:ok}
    end
  end

  def forget(key) do

  end

  @doc """
  Flush the ETS table. This will delete all stored memories inside the ETS table.

  ##Example
      Mnemonic.flush
  """
  def flush do
    :ets.delete_all_objects(@ets_table)
    {:ok}
  end

  def persist do

  end

  defp create_cache(memories) do
    if :ets.info(@ets_table) == :undefined do
      :ets.new(@ets_table, [:set, :protected, :named_table])
    end

    Enum.each(memories, fn (memory) ->
      key =
        elem(memory, 0)
        |> to_string()
      value = elem(memory, 1)

      cache_memory(key, value)
    end)
  end

  def cache_memory(key, value),
    do: :ets.insert(@ets_table, {key, value})

  defp nested_elem?(key),
    do: String.contains?(key, ".")

  defp find_from_memory(key) do
    try do
      :ets.lookup(@ets_table, key)
      |> List.first()
      |> elem(1)
    rescue
      ArgumentError -> nil
    end
  end

  defp traverse_memory(memory, key, default) when is_list(key) do
    try do
      value = get_in(memory, key)
      if !is_nil(value), do: value, else: default
    rescue
      FunctionClauseError -> default
    end
  end
  defp traverse_memory(nil, _, default),
    do: default
  defp traverse_memory(memory, key, default) do
    if !is_nil(memory), do: memory, else: default
  end

  defp replace_existing_memory(key, value) do
    if nested_elem?(key) do
      [key | nested_keys] = String.split(key, ".")
    else
      nested_keys = key
    end

    find_from_memory(key)
    |> replace(nested_keys, value, key)
  end

  defp replace(memory, key, value, root_key \\ nil) when is_list(key) do
    new_memory = put_in(memory, key, value)
    cache_memory(root_key, new_memory)
  end
  defp replace(memory, key, value, _),
    do: cache_memory(key, value)
end
