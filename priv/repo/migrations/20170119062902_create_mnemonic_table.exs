defmodule Mnemonic.Repo.Migrations.CreateMnemonicTable do
  use Ecto.Migration

  def up do
    create table(:mnemonic_settings) do
      add :key, :string
      add :value, :map
      timestamps()
    end

    create index(:mnemonic_settings, [:key])
  end

  def down do
    drop table(:mnemonic_settings)
  end
end
