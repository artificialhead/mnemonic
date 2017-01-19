defmodule Mnemonic.Ecto.Data do
  alias Mnemonic.{Repo, Ecto.Schema}

  def load do
    Repo.all(Schema)
    |> Enum.map(fn(memory) ->
        {String.to_atom(memory.key), memory.value}
      end)
  end
end
