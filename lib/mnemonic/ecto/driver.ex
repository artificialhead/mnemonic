defmodule Mnemonic.Ecto.Driver do
  @behaviour Mnemonic.Driver

  import Ecto.Changeset, only: [change: 2]

  alias Mnemonic.{Repo, Ecto.Schema}

  def load do
    Repo.all(Schema)
    |> Enum.map(fn(memory) ->
        {String.to_atom(memory.key), memory.value}
      end)
  end

  def store(memory) do
    Repo.get_by(Schema, key: elem(memory, 0))
    |> change(value: elem(memory, 1))
    |> Repo.update()
    {:ok}
  end
end
