defmodule Elixiryf.Ticker do
  @typedoc "A stock ticker struct implementation"
  @type t :: %__MODULE__{
    name: String.t(),
    value: float()
  }

  @derive {Inspect, only: [:name, :value]}
  defstruct [:name, :value]
end
