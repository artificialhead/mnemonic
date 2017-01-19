alias Mnemonic.{Repo, Ecto.Schema}

changeset = Schema.changeset(%Schema{}, %{key: "thekey2", value: %{
  "foo" => %{
    "bar" => "foobar"
  },
  "foobar" => "baz"
}})

if changeset.valid?, do: Repo.insert(changeset)
