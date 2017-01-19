defmodule Mnemonic.Ecto.Schema do
  use Ecto.Schema

  alias Ecto.Changeset

  schema "mnemonic_settings" do
    field :key, :string
    field :value, :map
    timestamps()
  end

  def changeset(schema, params \\ :empty) do
    schema
    |> Changeset.cast(params, [:key, :value])
    |> Changeset.validate_required([:key, :value])
  end
end
