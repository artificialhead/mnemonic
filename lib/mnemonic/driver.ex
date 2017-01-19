defmodule Mnemonic.Driver do
  @callback load :: map()

  @callback store(tuple()) :: {:ok}
end
