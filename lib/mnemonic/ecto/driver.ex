defmodule Mnemonic.Ecto.Driver do
  @behaviour Mnemonic.Driver

  alias Mnemonic.{Repo, Ecto.Schema}

  def load do
    Repo.all(Schema)
    |> Enum.map(fn(memory) ->
        {String.to_atom(memory.key), memory.value}
      end)
  end
end
